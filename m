Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F92B4F620A
	for <lists+kvm@lfdr.de>; Wed,  6 Apr 2022 16:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbiDFOrP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Apr 2022 10:47:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235061AbiDFOrB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Apr 2022 10:47:01 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD3B4DF6C5
        for <kvm@vger.kernel.org>; Wed,  6 Apr 2022 04:14:48 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-2eb57fd3f56so22050297b3.8
        for <kvm@vger.kernel.org>; Wed, 06 Apr 2022 04:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MkKxjYAV/v0VMd11SMXqG8EhXPeJQ34GzLrs6aLHBhk=;
        b=BnkL/xviW3/SATQQBN0J4jLUdrTQRMmZsVp7lEWCOmkmWwekK4I3vVJpW5wY+oaW6o
         wMWw7poztVXO8dmLd+4dn47QCBX/MLXDvtQ0FtncjF48Ky/apTe5LetGClF9I8xv8hLd
         39QIq1nCVrCyq+b89tHhY+wy8NDABlDcruy0U3VUH+wy5CC/74PQNoqlWZUGpPI4ktd2
         2syhOC3nTsaeBG0iofZAEy+fKLdo2YsKyo/Wo++rIt2NrTU9fzPbBH0Ng8KlfS5PTmtk
         EZZmtp49FjP3cappOUQR7sHOielNZL7XjaQF+GBy228W5SABlrjalbp+fGs0YWTIyb9y
         NQoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MkKxjYAV/v0VMd11SMXqG8EhXPeJQ34GzLrs6aLHBhk=;
        b=tX5XZVuy8yoxCPwJxtIO0STFyYVLD/U8mRVpCXTblJI3U1mk8hDgDgZNaLdv5lLK1h
         PBe+lokRV8piKfsbn9nFjt7PBSCP4Vt1TiQZyQvAF9FJ4TMvC3Zf+98GNkH8D/hvTEdR
         ajIUoVe14Ad5j/FdvJz/YdyKxwvAuisfbdXbX7YvyUBkNQ0M/e6xEtk1G6qqqWU61xuy
         nVsbg4Fz62Ol8gYL08fy8J6N27HAfOybcy9QUXq3bgtHkH67wActFU/Bt6HIyndb437J
         2wsLqFOAzPudqv4Apl7lozbD3f3aWhOBSqzm74FojAQ90cwXeZDedRNhDDV46O524r4o
         SDvg==
X-Gm-Message-State: AOAM532t+vO73juUltpK95HZt2X/Ckuu8mVW49hbsVZFUiPlawYjHa6q
        PiGfho6bQktV3YnpUJckkIgr6mLJyceK536TgzZR3Q==
X-Google-Smtp-Source: ABdhPJytWaKSjrcKoa2mbzwJv7RhwFSgw11lPqUjgtEaNT3OmaJMCRA7mDMdyjLwii6p/gHggvStzLZXxV0l/YkXcmI=
X-Received: by 2002:a81:1592:0:b0:2eb:5472:c681 with SMTP id
 140-20020a811592000000b002eb5472c681mr6491648ywv.10.1649243687745; Wed, 06
 Apr 2022 04:14:47 -0700 (PDT)
MIME-Version: 1.0
References: <20220323155743.1585078-1-marcandre.lureau@redhat.com>
 <20220323155743.1585078-33-marcandre.lureau@redhat.com> <CAARzgwzXXKqhvP9CnST3iD_obfqCWn8Z+8WNcs0u-O_UGoM1-w@mail.gmail.com>
 <87o81epk1s.fsf@pond.sub.org>
In-Reply-To: <87o81epk1s.fsf@pond.sub.org>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Wed, 6 Apr 2022 12:14:36 +0100
Message-ID: <CAFEAcA9kYweS2zMHjWDuV_y2AxKbgJ5UYNHLK3sASCLVD=yEqg@mail.gmail.com>
Subject: Re: [PATCH 32/32] Remove qemu-common.h include from most units
To:     Markus Armbruster <armbru@redhat.com>
Cc:     Ani Sinha <ani@anisinha.ca>, marcandre.lureau@redhat.com,
        Aarushi Mehta <mehta.aaru20@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        =?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Alexander Graf <agraf@csgraf.de>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Alistair Francis <alistair.francis@wdc.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Bandan Das <bsd@redhat.com>,
        Bastian Koppelmann <kbastian@mail.uni-paderborn.de>,
        Bin Meng <bin.meng@windriver.com>,
        Cameron Esfahani <dirty@apple.com>,
        Chris Wulff <crwulff@gmail.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Christian Schoenebeck <qemu_oss@crudebyte.com>,
        Colin Xu <colin.xu@intel.com>, Corey Minyard <minyard@acm.org>,
        Cornelia Huck <cohuck@redhat.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        David Hildenbrand <david@redhat.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Eric Auger <eric.auger@redhat.com>,
        Eric Farman <farman@linux.ibm.com>,
        Fabien Chouteau <chouteau@adacore.com>,
        Fam Zheng <fam@euphon.net>, Gerd Hoffmann <kraxel@redhat.com>,
        Greg Kurz <groug@kaod.org>, Halil Pasic <pasic@linux.ibm.com>,
        Hanna Reitz <hreitz@redhat.com>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Helge Deller <deller@gmx.de>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Igor Mammedov <imammedo@redhat.com>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Joel Stanley <joel@jms.id.au>,
        John G Johnson <john.g.johnson@oracle.com>,
        John Snow <jsnow@redhat.com>,
        Julia Suvorova <jusual@redhat.com>,
        KONRAD Frederic <frederic.konrad@adacore.com>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Kevin Wolf <kwolf@redhat.com>, Kyle Evans <kevans@freebsd.org>,
        Laurent Vivier <Laurent@vivier.eu>,
        Li Zhijian <lizhijian@fujitsu.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Marek Vasut <marex@denx.de>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Michael Roth <michael.roth@amd.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Richard Henderson <richard.henderson@linaro.org>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Stefan Berger <stefanb@linux.vnet.ibm.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Stefan Weil <sw@weilnetz.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Taylor Simpson <tsimpson@quicinc.com>,
        Thomas Huth <huth@tuxfamily.org>,
        Tyrone Ting <kfting@nuvoton.com>, Warner Losh <imp@bsdimp.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Yanan Wang <wangyanan55@huawei.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Zhang Chen <chen.zhang@intel.com>,
        "open list:ARM PrimeCell and..." <qemu-arm@nongnu.org>,
        "open list:Overall KVM CPUs" <kvm@vger.kernel.org>,
        "open list:RISC-V TCG CPUs" <qemu-riscv@nongnu.org>,
        "open list:S390-ccw boot" <qemu-s390x@nongnu.org>,
        "open list:X86 HAXM CPUs" <haxm-team@intel.com>,
        "open list:raw" <qemu-block@nongnu.org>,
        "open list:sPAPR (pseries)" <qemu-ppc@nongnu.org>,
        qemu-devel@nongnu.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 6 Apr 2022 at 11:45, Markus Armbruster <armbru@redhat.com> wrote:
>
> First of all: thank you so much for completing the "empty out
> qemu-common.h" job!
>
> This is what's left:
>
>     #ifndef QEMU_COMMON_H
>     #define QEMU_COMMON_H
>
>     /* Copyright string for -version arguments, About dialogs, etc */
>     #define QEMU_COPYRIGHT "Copyright (c) 2003-2022 " \
>         "Fabrice Bellard and the QEMU Project developers"
>
>     /* Bug reporting information for --help arguments, About dialogs, etc */
>     #define QEMU_HELP_BOTTOM \
>         "See <https://qemu.org/contribute/report-a-bug> for how to report bugs.\n" \
>         "More information on the QEMU project at <https://qemu.org>."
>
>     #endif




> Rename the header?  Or replace the macros by variables, and move their
> declarations elsewhere?  Not demands; this series is lovely progress as
> is.

We should put those in a qemu/copyright.h, I think.
Leaving a "qemu-common.h" around is an open invitation to people
throwing more random stuff into it again in future.

As you say, we can totally do this as a later followup.

thanks
-- PMM
