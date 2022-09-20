Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E705BF100
	for <lists+kvm@lfdr.de>; Wed, 21 Sep 2022 01:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbiITXUZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 19:20:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiITXUW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 19:20:22 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B38E86F57B
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:20:20 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y3so9860445ejc.1
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 16:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=GtMxYIRvAVAlD5MIJW3CMU+hdQDh/A1FNoJWhhLH0qE=;
        b=pm+buGeFehD8BASPCqH113rGynSJwN6wxPzkq6dds4CXX+4p5I3dBJkJJS01RL+Tai
         jXH2C6g6rtblZqjB1SsUvwxyKHQi8PI5uw0Y+ftr+xqd8CxhaxojBqt0sbvWrNQ3QgwT
         HPi85aRbWX3nCZ/mx03/0M4ol+mefKDFl/abg2tUrRmQyeLI6HGQ8OT1RcyuobJttOxN
         tv9FNW7Rw6H99aA2h0obQ/oBQ2ZcBAUOcOrWNRg7zTAeetnuaOg44KKGVxIGps1+/op4
         BKH/r6CYUtGxJTGZtHM13rOeRwpoBPxI5vWiYm45neZhCA9By3jialVV75S3lBm/f6Ct
         DOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=GtMxYIRvAVAlD5MIJW3CMU+hdQDh/A1FNoJWhhLH0qE=;
        b=Enz4Gr0p+TujhN20508Vh+6AuKpSdnn9CmIT2/78A5Cgmm0AZDRFo/DpbxxJ9LIfHc
         /8OmngRHDYPvJELQv9YpH180w1Qtes6iH83cWcZZXmE+62xpEsQFYTwIQeYMTuedTDPs
         Nq+YDc9zOUdVaMjkeAEPScRmYMwigwzvrDMcuvKGRMn8UPcbh0TbcHIDH2LLERL65qet
         /7tKLwGHq/l3jYbQlGfV+iBkwASud99sBUlOsyyuJnZD+nlwg0lxoa94Fh2ZKqnbJ0Ys
         sWFtl+ymxy/BrxD6VglVG6pC/q0meqHnRa/0PRhKHnSRghpI+XDNmjsOimRjH9Z1X6/D
         nyMA==
X-Gm-Message-State: ACrzQf1gmauK41A+6XChs5odncjaIjbrqcwFQE6MirDQ5arb3WieQm3+
        WCXJ0SJy/9Uo0iQnd6foWxY=
X-Google-Smtp-Source: AMsMyM6/qMtYXfOb9sMZlghUptjRyYcuSU6AakPT4+aCBhB0cHXdoKH/wQKSzUALkR93qIrs+7A3TQ==
X-Received: by 2002:a17:907:1690:b0:77c:37be:2345 with SMTP id hc16-20020a170907169000b0077c37be2345mr18459194ejc.359.1663716019170;
        Tue, 20 Sep 2022 16:20:19 -0700 (PDT)
Received: from [127.0.0.1] (dynamic-078-054-006-055.78.54.pool.telefonica.de. [78.54.6.55])
        by smtp.gmail.com with ESMTPSA id er12-20020a056402448c00b0044ee91129f9sm629755edb.70.2022.09.20.16.20.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 16:20:18 -0700 (PDT)
Date:   Tue, 20 Sep 2022 23:20:11 +0000
From:   Bernhard Beschow <shentey@gmail.com>
To:     BALATON Zoltan <balaton@eik.bme.hu>,
        =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <f4bug@amsat.org>
CC:     qemu-devel@nongnu.org, "Michael S. Tsirkin" <mst@redhat.com>,
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
        =?ISO-8859-1?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?ISO-8859-1?Q?C=E9dric_Le_Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?ISO-8859-1?Q?Herv=E9_Poussineau?= <hpoussin@reactos.org>,
        qemu-ppc@nongnu.org, Cornelia Huck <cohuck@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Helge Deller <deller@gmx.de>,
        Stefano Stabellini <sstabellini@kernel.org>,
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
        =?ISO-8859-1?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
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
Subject: Re: [PATCH 9/9] exec/address-spaces: Inline legacy functions
In-Reply-To: <7411d60-2bc0-f927-752-56184958c790@eik.bme.hu>
References: <20220919231720.163121-1-shentey@gmail.com> <20220919231720.163121-10-shentey@gmail.com> <e1ef18a0-6a85-e536-1fbd-9f8794dc0217@amsat.org> <7411d60-2bc0-f927-752-56184958c790@eik.bme.hu>
Message-ID: <AFC88EBD-9403-4D4D-A5D0-C458A7262B3B@gmail.com>
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

Am 20=2E September 2022 09:02:41 UTC schrieb BALATON Zoltan <balaton@eik=2E=
bme=2Ehu>:
>
>
>On Tue, 20 Sep 2022, Philippe Mathieu-Daud=C3=A9 via wrote:
>
>> On 20/9/22 01:17, Bernhard Beschow wrote:
>>> The functions just access a global pointer and perform some pointer
>>> arithmetic on top=2E Allow the compiler to see through this by inlinin=
g=2E
>>=20
>> I thought about this while reviewing the previous patch, =2E=2E=2E
>>=20
>>> Signed-off-by: Bernhard Beschow <shentey@gmail=2Ecom>
>>> ---
>>>   include/exec/address-spaces=2Eh | 30 ++++++++++++++++++++++++++----
>>>   softmmu/physmem=2Ec             | 28 ----------------------------
>>>   2 files changed, 26 insertions(+), 32 deletions(-)
>>>=20
>>> diff --git a/include/exec/address-spaces=2Eh b/include/exec/address-sp=
aces=2Eh
>>> index b31bd8dcf0=2E=2E182af27cad 100644
>>> --- a/include/exec/address-spaces=2Eh
>>> +++ b/include/exec/address-spaces=2Eh
>>> @@ -23,29 +23,51 @@
>>>     #ifndef CONFIG_USER_ONLY
>>>   +#include "hw/boards=2Eh"
>>=20
>> =2E=2E=2E but I'm not a fan of including this header here=2E It is rest=
ricted to system emulation, but still=2E=2E=2E Let see what the others thin=
k=2E
>
>Had the same thought first if this would break user emulation but I don't=
 know how that works (and this include is withing !CONFIG_USER_ONLY)=2E I'v=
e checked in configure now and it seems that softmmu is enabled/disabled wi=
th system, which reminded me to a previous conversation where I've suggeste=
d renaming softmmu to sysemu as that better shows what it's really used for=
 and maybe the real softmmu part should be split from it but I don't rememb=
er the details=2E If it still works with --enable-user --disable-system the=
n maybe it's OK and only confusing because of misnaming sysemu as softmmu=
=2E

I've compiled all architectures w/o any --{enable,disable}-{user,system} f=
lags and I had compile errors only when putting the include outside the gua=
rd=2E So this in particular doesn't seem to be a problem=2E

Best regards,
Bernhard
>
>Reagrds,
>BALATON Zoltan
>
>>>   /**
>>>    * Get the root memory region=2E  This is a legacy function, provide=
d for
>>>    * compatibility=2E Prefer using SysBusState::system_memory directly=
=2E
>>>    */
>>> -MemoryRegion *get_system_memory(void);
>>> +inline MemoryRegion *get_system_memory(void)
>>> +{
>>> +    assert(current_machine);
>>> +
>>> +    return &current_machine->main_system_bus=2Esystem_memory;
>>> +}
>>>     /**
>>>    * Get the root I/O port region=2E  This is a legacy function, provi=
ded for
>>>    * compatibility=2E Prefer using SysBusState::system_io directly=2E
>>>    */
>>> -MemoryRegion *get_system_io(void);
>>> +inline MemoryRegion *get_system_io(void)
>>> +{
>>> +    assert(current_machine);
>>> +
>>> +    return &current_machine->main_system_bus=2Esystem_io;
>>> +}
>>>     /**
>>>    * Get the root memory address space=2E  This is a legacy function, =
provided for
>>>    * compatibility=2E Prefer using SysBusState::address_space_memory d=
irectly=2E
>>>    */
>>> -AddressSpace *get_address_space_memory(void);
>>> +inline AddressSpace *get_address_space_memory(void)
>>> +{
>>> +    assert(current_machine);
>>> +
>>> +    return &current_machine->main_system_bus=2Eaddress_space_memory;
>>> +}
>>>     /**
>>>    * Get the root I/O port address space=2E  This is a legacy function=
, provided
>>>    * for compatibility=2E Prefer using SysBusState::address_space_io d=
irectly=2E
>>>    */
>>> -AddressSpace *get_address_space_io(void);
>>> +inline AddressSpace *get_address_space_io(void)
>>> +{
>>> +    assert(current_machine);
>>> +
>>> +    return &current_machine->main_system_bus=2Eaddress_space_io;
>>> +}
>>>     #endif
>>>   diff --git a/softmmu/physmem=2Ec b/softmmu/physmem=2Ec
>>> index 07e9a9171c=2E=2Edce088f55c 100644
>>> --- a/softmmu/physmem=2Ec
>>> +++ b/softmmu/physmem=2Ec
>>> @@ -2674,34 +2674,6 @@ static void memory_map_init(SysBusState *sysbus=
)
>>>       address_space_init(&sysbus->address_space_io, system_io, "I/O");
>>>   }
>>>   -MemoryRegion *get_system_memory(void)
>>> -{
>>> -    assert(current_machine);
>>> -
>>> -    return &current_machine->main_system_bus=2Esystem_memory;
>>> -}
>>> -
>>> -MemoryRegion *get_system_io(void)
>>> -{
>>> -    assert(current_machine);
>>> -
>>> -    return &current_machine->main_system_bus=2Esystem_io;
>>> -}
>>> -
>>> -AddressSpace *get_address_space_memory(void)
>>> -{
>>> -    assert(current_machine);
>>> -
>>> -    return &current_machine->main_system_bus=2Eaddress_space_memory;
>>> -}
>>> -
>>> -AddressSpace *get_address_space_io(void)
>>> -{
>>> -    assert(current_machine);
>>> -
>>> -    return &current_machine->main_system_bus=2Eaddress_space_io;
>>> -}
>>> -
>>>   static void invalidate_and_set_dirty(MemoryRegion *mr, hwaddr addr,
>>>                                        hwaddr length)
>>>   {
>>=20
>>=20
>>=20
