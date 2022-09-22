Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4209D5E5CB6
	for <lists+kvm@lfdr.de>; Thu, 22 Sep 2022 09:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230020AbiIVHzK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Sep 2022 03:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiIVHzI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Sep 2022 03:55:08 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5451B6C77B
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 00:55:07 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id hy2so15464726ejc.8
        for <kvm@vger.kernel.org>; Thu, 22 Sep 2022 00:55:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XAn7c1pwQ/FfM7vHKOqOcGKKPoVtNy6cXXuDPbbsEMg=;
        b=KdwbP3Bc87qLjlpjsnO2AH1hFtCVaiTGJp44vkAjCHEyi2BVqdUN8ix+ddbhHaPK1r
         EqWJ5pPbZsCjVFS9e+dTsVJ0Foj6V+KoT4fRyJlz7QqnJ/8hVqxrc1Ho7ZLeIspC87hS
         EwLwWL/B0irPWwT9KoGor+fge4WF8zkBMONJ36LmRsHQ1cCTfxd9d0oVkt47Fb8ho6Yq
         vGRDgumcb7zLXHHzBCfP5aDStxiv4J7vmNbl/fZPXSp3qCOfLbaEdK0wuuYY9KcWK55E
         P9+VDLqy0HdpS4ndwVtZP2lM2k+QoDCxBOx6WyXF/QkqHcfEpOC7COF2TxEu7OhFiih6
         yxPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=XAn7c1pwQ/FfM7vHKOqOcGKKPoVtNy6cXXuDPbbsEMg=;
        b=Da3AucoDrt3m9bnF4XTNlJM+uK4nQTI6+z8xNu/1iPJlAIP9wa4/J8EZgm1Em9Yv+V
         ziYMNeoJ9/aVRhZws2eYRby9C6KuugduQMltcv5RULWas0dNk8ZEI/Kcp19xsf/iqn2z
         LjNuj3r9z1MUi7/wIkQbkCvLBQjZ9CqOmpVFL67rrlvVbl3HNNNlxiBk4vpXnx8wrqb+
         GNV6gtzxopmQP63+fOwSqUNOOQ2LUA9ctadH691cg/FY7IZbl+mwp9TRtwoVMZfFXEcA
         C8VG2F6TFqIQdggniw3VWTag9bPKt5o/x9lfBa4NTzvdaibn3N/loSFWiCO1HoZl7b04
         sDXQ==
X-Gm-Message-State: ACrzQf2d8wARr1RmpNUhno+TF3VrEjRAYXuGOCOEPWteNGVptkAWq+ce
        mvXkexPiKbLNB1tUZW4DvXE=
X-Google-Smtp-Source: AMsMyM4vh+kpWsvDAV6UjWoPXkkUVHDYB2adjnMzVWEdRb430ELqUeGucGcmkbkYyJGj0Q/DyqUmmQ==
X-Received: by 2002:a17:906:9b93:b0:780:3b58:93e1 with SMTP id dd19-20020a1709069b9300b007803b5893e1mr1620475ejc.698.1663833305755;
        Thu, 22 Sep 2022 00:55:05 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-077-191-214-084.77.191.pool.telefonica.de. [77.191.214.84])
        by smtp.gmail.com with ESMTPSA id u17-20020a056402065100b0045081dc93dfsm3166610edx.78.2022.09.22.00.55.04
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 22 Sep 2022 00:55:05 -0700 (PDT)
Date:   Thu, 22 Sep 2022 07:55:01 +0000
From:   B <shentey@gmail.com>
To:     Markus Armbruster <armbru@redhat.com>
CC:     Alistair Francis <alistair23@gmail.com>,
        Bin Meng <bin.meng@windriver.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
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
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?ISO-8859-1?Q?C=E9dric_Le_Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Qemu-block <qemu-block@nongnu.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        =?ISO-8859-1?Q?Herv=E9_Poussineau?= <hpoussin@reactos.org>,
        "open list:New World" <qemu-ppc@nongnu.org>,
        Cornelia Huck <cohuck@redhat.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <f4bug@amsat.org>,
        "open list:RISC-V" <qemu-riscv@nongnu.org>,
        Stafford Horne <shorne@gmail.com>, Paul Durrant <paul@xen.org>,
        Havard Skinnemoen <hskinnemoen@google.com>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        Alexander Graf <agraf@csgraf.de>,
        Thomas Huth <thuth@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Wenchao Wang <wenchao.wang@intel.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        qemu-s390x <qemu-s390x@nongnu.org>,
        =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        Eric Farman <farman@linux.ibm.com>,
        Reinoud Zandijk <reinoud@netbsd.org>,
        Alexander Bulekov <alxndr@bu.edu>,
        Yanan Wang <wangyanan55@huawei.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>,
        "open list:X86" <xen-devel@lists.xenproject.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        John Snow <jsnow@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Darren Kenny <darren.kenny@oracle.com>,
        "open list:Overall" <kvm@vger.kernel.org>,
        Qiuhao Li <Qiuhao.Li@outlook.com>,
        John G Johnson <john.g.johnson@oracle.com>,
        Sunil Muthuswamy <sunilmut@microsoft.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        qemu-arm <qemu-arm@nongnu.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Maydell <peter.maydell@linaro.org>,
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
Subject: Re: [PATCH 1/9] hw/riscv/sifive_e: Fix inheritance of SiFiveEState
In-Reply-To: <87a66tgwd5.fsf@pond.sub.org>
References: <20220919231720.163121-1-shentey@gmail.com> <20220919231720.163121-2-shentey@gmail.com> <CAKmqyKN+V2R8PkED67tB8+pCZs9369ViiL8OZ9XhO3SdUCk5=Q@mail.gmail.com> <87edw6xoog.fsf@pond.sub.org> <0BBD7391-7B2D-44E7-9396-D1747784B9DA@gmail.com> <87a66tgwd5.fsf@pond.sub.org>
Message-ID: <58A6CCCB-7426-41A2-9D3A-0683FBC51F47@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 21=2E September 2022 04:55:02 UTC schrieb Markus Armbruster <armbru@red=
hat=2Ecom>:
>Bernhard Beschow <shentey@gmail=2Ecom> writes:
>
>> Am 20=2E September 2022 11:36:47 UTC schrieb Markus Armbruster <armbru@=
redhat=2Ecom>:
>>>Alistair Francis <alistair23@gmail=2Ecom> writes:
>>>
>>>> On Tue, Sep 20, 2022 at 9:18 AM Bernhard Beschow <shentey@gmail=2Ecom=
> wrote:
>>>>>
>>>>> SiFiveEState inherits from SysBusDevice while it's TypeInfo claims i=
t to
>>>>> inherit from TYPE_MACHINE=2E This is an inconsistency which can caus=
e
>>>>> undefined behavior such as memory corruption=2E
>>>>>
>>>>> Change SiFiveEState to inherit from MachineState since it is registe=
red
>>>>> as a machine=2E
>>>>>
>>>>> Signed-off-by: Bernhard Beschow <shentey@gmail=2Ecom>
>>>>
>>>> Reviewed-by: Alistair Francis <alistair=2Efrancis@wdc=2Ecom>
>>>
>>>To the SiFive maintainers: since this is a bug fix, let's merge it righ=
t
>>>away=2E
>>
>> I could repost this particular patch with the three new tags (incl=2E F=
ixes) if desired=2E
>
>Can't hurt, and could help the maintainers=2E

[X] Done=2E

Best regards,
Bernhard
