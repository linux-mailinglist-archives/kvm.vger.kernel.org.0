Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1455E5BE283
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:56:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiITJ4A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:56:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbiITJzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:55:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08F16B666
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:55:50 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id 13so4864066ejn.3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:55:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MOHpKFoYlYyycfS9c46ICESvGULQBNymssneeKs799o=;
        b=quYFlnIJleuARwEhPjdTz1ToiR+OvGdDRZw0wCdlnOJ6MTQLsWsNk/r5mDr6XnAX31
         Hwj1d7mMoZGkMAivnJ2J9OA8ZQ/aEG9aq2Y0P6e4Wu9l0ogP2si80dYknPFTqUq67bFn
         Xm8Wc5/TDj6+sKRKK3cwfKdSiiVQZAM+wkG1hTzjWA/gxyr377xjsFx1EDW7bYvLo1Xu
         bN5dAy2agecZU4e8CyZs4D9MTl7i4prTbe0AYlQ0hmgCrP2yZe58bj+hgNmk3fik2WQI
         YCH4MamgZK77XXUAxDmY6RQjMtha7B+/kchkih5CEdwvGX58X2okw2imIkQdZF7pfF6O
         s7qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MOHpKFoYlYyycfS9c46ICESvGULQBNymssneeKs799o=;
        b=linTzF+1F/bnlt+UDfUKupxR6DnLTtxHXYUEyKXHbQZx4vcQljfEdI6i/aVif695Xt
         4PcvUjVh4E2dJ+MBrwpsgB3CwCUik33qiP1harqbi8tzDfrKRnW8guBK3+9p0GoqEcq8
         DC6KLM6BS75nqboREYWaAHrvBZSzlRNATwpXNJmmdKylPi0o232Ga8y3TUf5My+kY02k
         HY5oWmVIzq3aXbdx5qNNY3GfhzR8nHqLP2r6Wn7iDI5KCZjnKtNztgADbZ9lL/iKwjph
         yfbdywAaC//LcLk0xsS37sc3vGtoiDqW3Nay+Or4mCt09zphJytOChhviVApFjUcthvV
         LjAQ==
X-Gm-Message-State: ACrzQf1qZP45FVICxmmcpoXsf7Q5GdnzzOoDbvTEco4KJvrADPyRan0k
        +UX9H9GxmvY4nTh7yOh3jFBdWkcclVVNpBPidJB36Q==
X-Google-Smtp-Source: AMsMyM4VRt9iN2Ys9FUPfBpfYY02peK2ICLg9+doecZ6zcnwoVeZC5tVrJoMYR6zFGBVnQfqk1brL6iSz7epg8D/0ao=
X-Received: by 2002:a17:906:8a6b:b0:780:ab37:b63 with SMTP id
 hy11-20020a1709068a6b00b00780ab370b63mr14241916ejc.365.1663667749166; Tue, 20
 Sep 2022 02:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220919231720.163121-1-shentey@gmail.com>
In-Reply-To: <20220919231720.163121-1-shentey@gmail.com>
From:   Peter Maydell <peter.maydell@linaro.org>
Date:   Tue, 20 Sep 2022 10:55:37 +0100
Message-ID: <CAFEAcA8GjXFO4WK=KybgSc8rMfqecwD9EXS0kZMKtqogNf1Tsg@mail.gmail.com>
Subject: Re: [PATCH 0/9] Deprecate sysbus_get_default() and
 get_system_memory() et. al
To:     Bernhard Beschow <shentey@gmail.com>
Cc:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Aleksandar Rikalo <aleksandar.rikalo@syrmia.com>,
        Bandan Das <bsd@redhat.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Sergio Lopez <slp@redhat.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Xiaojuan Yang <yangxiaojuan@loongson.cn>,
        Cameron Esfahani <dirty@apple.com>,
        Michael Rolnik <mrolnik@gmail.com>,
        Song Gao <gaosong@loongson.cn>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Greg Kurz <groug@kaod.org>,
        Kamil Rytarowski <kamil@netbsd.org>,
        Peter Xu <peterx@redhat.com>, Joel Stanley <joel@jms.id.au>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, haxm-team@intel.com,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?Philippe_Mathieu=2DDaud=C3=A9?= <f4bug@amsat.org>,
        qemu-riscv@nongnu.org, Stafford Horne <shorne@gmail.com>,
        Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x@nongnu.org,
        =?UTF-8?B?TWFyYy1BbmRyw6kgTHVyZWF1?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        xen-devel@lists.xenproject.org,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>, kvm@vger.kernel.org,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Bin Meng <bin.meng@windriver.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>, qemu-arm@nongnu.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Anthony Perard <anthony.perard@citrix.com>,
        Andrew Jeffery <andrew@aj.id.au>,
        Artyom Tarasenko <atar4qemu@gmail.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
        Jason Wang <jasowang@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        Laurent Vivier <laurent@vivier.eu>,
        Alistair Francis <alistair@alistair23.me>,
        Jason Herne <jjherne@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 20 Sept 2022 at 00:18, Bernhard Beschow <shentey@gmail.com> wrote:
>
> In address-spaces.h it can be read that get_system_memory() and
> get_system_io() are temporary interfaces which "should only be used temporarily
> until a proper bus interface is available". This statement certainly extends to
> the address_space_memory and address_space_io singletons.

This is a long standing "we never really completed a cleanup"...

> This series attempts
> to stop further proliferation of their use by turning TYPE_SYSTEM_BUS into an
> object-oriented, "proper bus interface" inspired by PCIBus.
>
> While at it, also the main_system_bus singleton is turned into an attribute of
> MachineState. Together, this resolves five singletons in total, making the
> ownership relations much more obvious which helps comprehension.

...but I don't think this is the direction we want to go.
Overall the reason that the "system memory" and "system IO"
singletons are weird is that in theory they should not be necessary
at all -- board code should create devices and map them into an
entirely arbitrary MemoryRegion or set of MemoryRegions corresponding
to address space(s) for the CPU and for DMA-capable devices. But we
keep them around because
 (a) there is a ton of legacy code that assumes there's only one
     address space in the system and this is it
 (b) when modelling the kind of board where there really is only
     one address space, having the 'system memory' global makes
     the APIs for creating and connecting devices a lot simpler

Retaining the whole-system singleton but shoving it into MachineState
doesn't really change much, IMHO.

More generally, sysbus is rather weird because it isn't really a
bus. Every device in the system of TYPE_SYS_BUS_DEVICE is "on"
the unique TYPE_SYSTEM_BUS bus, but that doesn't mean they're
all in the same address space or that in real hardware they'd
all be on the same bus. sysbus has essentially degraded into a
hack for having devices get reset. I really really need to make
some time to have another look at reset handling. If we get that
right then I think it's probably possible to collapse the few
things TYPE_SYS_BUS_DEVICE does that TYPE_DEVICE does not down
into TYPE_DEVICE and get rid of sysbus altogether...

thanks
-- PMM
