Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86DA85BE157
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 11:06:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbiITJFM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 05:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231555AbiITJEg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 05:04:36 -0400
Received: from zero.eik.bme.hu (zero.eik.bme.hu [152.66.115.2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882976DAC3
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 02:02:47 -0700 (PDT)
Received: from zero.eik.bme.hu (blah.eik.bme.hu [152.66.115.182])
        by localhost (Postfix) with SMTP id DACEC746335;
        Tue, 20 Sep 2022 11:02:41 +0200 (CEST)
Received: by zero.eik.bme.hu (Postfix, from userid 432)
        id 8F6AB74632B; Tue, 20 Sep 2022 11:02:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by zero.eik.bme.hu (Postfix) with ESMTP id 8A79C746324;
        Tue, 20 Sep 2022 11:02:41 +0200 (CEST)
Date:   Tue, 20 Sep 2022 11:02:41 +0200 (CEST)
From:   BALATON Zoltan <balaton@eik.bme.hu>
To:     =?ISO-8859-15?Q?Philippe_Mathieu-Daud=E9?= <f4bug@amsat.org>
cc:     Bernhard Beschow <shentey@gmail.com>, qemu-devel@nongnu.org,
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
        Markus Armbruster <armbru@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        =?ISO-8859-15?Q?Daniel_P=2E_Berrang=E9?= <berrange@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        =?ISO-8859-15?Q?C=E9dric_Le_Goater?= <clg@kaod.org>,
        Stefan Hajnoczi <stefanha@redhat.com>, qemu-block@nongnu.org,
        Eduardo Habkost <eduardo@habkost.net>,
        =?ISO-8859-15?Q?Herv=E9_Poussineau?= <hpoussin@reactos.org>,
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
        =?ISO-8859-15?Q?Marc-Andr=E9_Lureau?= <marcandre.lureau@redhat.com>,
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
In-Reply-To: <e1ef18a0-6a85-e536-1fbd-9f8794dc0217@amsat.org>
Message-ID: <7411d60-2bc0-f927-752-56184958c790@eik.bme.hu>
References: <20220919231720.163121-1-shentey@gmail.com> <20220919231720.163121-10-shentey@gmail.com> <e1ef18a0-6a85-e536-1fbd-9f8794dc0217@amsat.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3866299591-1050215408-1663664561=:43449"
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Probability: 9%
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--3866299591-1050215408-1663664561=:43449
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT



On Tue, 20 Sep 2022, Philippe Mathieu-Daudé via wrote:

> On 20/9/22 01:17, Bernhard Beschow wrote:
>> The functions just access a global pointer and perform some pointer
>> arithmetic on top. Allow the compiler to see through this by inlining.
>
> I thought about this while reviewing the previous patch, ...
>
>> Signed-off-by: Bernhard Beschow <shentey@gmail.com>
>> ---
>>   include/exec/address-spaces.h | 30 ++++++++++++++++++++++++++----
>>   softmmu/physmem.c             | 28 ----------------------------
>>   2 files changed, 26 insertions(+), 32 deletions(-)
>> 
>> diff --git a/include/exec/address-spaces.h b/include/exec/address-spaces.h
>> index b31bd8dcf0..182af27cad 100644
>> --- a/include/exec/address-spaces.h
>> +++ b/include/exec/address-spaces.h
>> @@ -23,29 +23,51 @@
>>     #ifndef CONFIG_USER_ONLY
>>   +#include "hw/boards.h"
>
> ... but I'm not a fan of including this header here. It is restricted to 
> system emulation, but still... Let see what the others think.

Had the same thought first if this would break user emulation but I don't 
know how that works (and this include is withing !CONFIG_USER_ONLY). I've 
checked in configure now and it seems that softmmu is enabled/disabled 
with system, which reminded me to a previous conversation where I've 
suggested renaming softmmu to sysemu as that better shows what it's really 
used for and maybe the real softmmu part should be split from it but I 
don't remember the details. If it still works with --enable-user 
--disable-system then maybe it's OK and only confusing because of 
misnaming sysemu as softmmu.

Reagrds,
BALATON Zoltan

>>   /**
>>    * Get the root memory region.  This is a legacy function, provided for
>>    * compatibility. Prefer using SysBusState::system_memory directly.
>>    */
>> -MemoryRegion *get_system_memory(void);
>> +inline MemoryRegion *get_system_memory(void)
>> +{
>> +    assert(current_machine);
>> +
>> +    return &current_machine->main_system_bus.system_memory;
>> +}
>>     /**
>>    * Get the root I/O port region.  This is a legacy function, provided for
>>    * compatibility. Prefer using SysBusState::system_io directly.
>>    */
>> -MemoryRegion *get_system_io(void);
>> +inline MemoryRegion *get_system_io(void)
>> +{
>> +    assert(current_machine);
>> +
>> +    return &current_machine->main_system_bus.system_io;
>> +}
>>     /**
>>    * Get the root memory address space.  This is a legacy function, 
>> provided for
>>    * compatibility. Prefer using SysBusState::address_space_memory 
>> directly.
>>    */
>> -AddressSpace *get_address_space_memory(void);
>> +inline AddressSpace *get_address_space_memory(void)
>> +{
>> +    assert(current_machine);
>> +
>> +    return &current_machine->main_system_bus.address_space_memory;
>> +}
>>     /**
>>    * Get the root I/O port address space.  This is a legacy function, 
>> provided
>>    * for compatibility. Prefer using SysBusState::address_space_io 
>> directly.
>>    */
>> -AddressSpace *get_address_space_io(void);
>> +inline AddressSpace *get_address_space_io(void)
>> +{
>> +    assert(current_machine);
>> +
>> +    return &current_machine->main_system_bus.address_space_io;
>> +}
>>     #endif
>>   diff --git a/softmmu/physmem.c b/softmmu/physmem.c
>> index 07e9a9171c..dce088f55c 100644
>> --- a/softmmu/physmem.c
>> +++ b/softmmu/physmem.c
>> @@ -2674,34 +2674,6 @@ static void memory_map_init(SysBusState *sysbus)
>>       address_space_init(&sysbus->address_space_io, system_io, "I/O");
>>   }
>>   -MemoryRegion *get_system_memory(void)
>> -{
>> -    assert(current_machine);
>> -
>> -    return &current_machine->main_system_bus.system_memory;
>> -}
>> -
>> -MemoryRegion *get_system_io(void)
>> -{
>> -    assert(current_machine);
>> -
>> -    return &current_machine->main_system_bus.system_io;
>> -}
>> -
>> -AddressSpace *get_address_space_memory(void)
>> -{
>> -    assert(current_machine);
>> -
>> -    return &current_machine->main_system_bus.address_space_memory;
>> -}
>> -
>> -AddressSpace *get_address_space_io(void)
>> -{
>> -    assert(current_machine);
>> -
>> -    return &current_machine->main_system_bus.address_space_io;
>> -}
>> -
>>   static void invalidate_and_set_dirty(MemoryRegion *mr, hwaddr addr,
>>                                        hwaddr length)
>>   {
>
>
>
--3866299591-1050215408-1663664561=:43449--
