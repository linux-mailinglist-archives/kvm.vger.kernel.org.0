Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0BB3BD49B
	for <lists+kvm@lfdr.de>; Tue,  6 Jul 2021 14:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343573AbhGFMOh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Jul 2021 08:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245561AbhGFMM6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Jul 2021 08:12:58 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F8BC09CE6E
        for <kvm@vger.kernel.org>; Tue,  6 Jul 2021 05:07:22 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id a18so37859581lfs.10
        for <kvm@vger.kernel.org>; Tue, 06 Jul 2021 05:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Ospo8X/Guvquin0Jkhfm+NucE4Ml3Sq8Ps7yQoP/kFA=;
        b=h2PGHRhCQBzRlSa5dCwI8pd4aIiZ34O+6eNmpIx3hGOYg9M5nlT6NmYF0spQVCHGev
         rR/TPHYbEWvtbUn2DjFF/wjaebCi0/4/kCfdZjmYXwk9leN0872JsXkPWVFhIU/z6JI9
         7+Njv7fOy1UfUkK6MMElAn+YeLF1XcbA0+LswhJ8amDktTLtpbGUiwdYM8//A0ndzbwz
         bUpWW5SgRDxVbBY1cI+iiU9eCLqOnEf6wVAmwEJRIfyS/QcGBrxIqFV9nv1ZeIpK5WaE
         MODz9rbfq3Mnk5j6VtoUR7SayMZftLBfQlmlV7/ZyZkWUZ1fWS98ruok+YUZCoyBCitB
         O+tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Ospo8X/Guvquin0Jkhfm+NucE4Ml3Sq8Ps7yQoP/kFA=;
        b=pDrQNGOzjVhFF6ZfauFAbQtMyJfLDsRhjZ5BZbg5PrjSb9EvdsLU+HX/zyWXQeu948
         98ByNZPL86ed6Cq8xQx0gfY5hkhVpMURgN9XQDQzF2ex/nx90x1HXafcu3B7SVwkxnJU
         s3/3gWYuZCu+PHMyIwUvyXCIxvO5nO9INKJaX9qa0V5abhAjFH61G6NKLrP7f9WimsSG
         uzsMjGrTZ+xQjH27CoPodAZrvzU7Dn88GIWkUF7Et/Y4egUdtYDORp1xOMV402o3xK/h
         79uygRY3IQrYFz+1Iuj4l42+VEE5Cz5XCf8EdmC6GlvMNatRRm27SbQPvY1M+yU8qc6/
         CI1Q==
X-Gm-Message-State: AOAM53150MsbmA7MGAV4Eo1pCELoywv/NSW0BO/degBi91h00oIfjOpo
        fHU10ebpqgckYqxzGSY/nQ4=
X-Google-Smtp-Source: ABdhPJwDkjeEQKOKppl6oJBn3ajArgr3Zcfwz9kerRIenHP3/B1/D2+Ne2up9z3SR56hTWMhyNsIPQ==
X-Received: by 2002:a19:5210:: with SMTP id m16mr14144855lfb.651.1625573239494;
        Tue, 06 Jul 2021 05:07:19 -0700 (PDT)
Received: from [192.168.1.7] ([212.22.223.21])
        by smtp.gmail.com with ESMTPSA id l6sm1783397lji.63.2021.07.06.05.07.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 05:07:19 -0700 (PDT)
Subject: Re: [Kvmtool] Some thoughts on using kvmtool Virtio for Xen
To:     Wei Chen <Wei.Chen@arm.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        "will@kernel.org" <will@kernel.org>,
        "julien.thierry.kdev@gmail.com" <julien.thierry.kdev@gmail.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>,
        "jean-philippe@linaro.org" <jean-philippe@linaro.org>,
        Julien Grall <julien@xen.org>,
        Andre Przywara <Andre.Przywara@arm.com>,
        Marc Zyngier <maz@kernel.org>,
        Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
References: <DB9PR08MB6857B375207376D8320AFBA89E309@DB9PR08MB6857.eurprd08.prod.outlook.com>
 <alpine.DEB.2.21.2106291716560.9437@sstabellini-ThinkPad-T480s>
 <DB9PR08MB6857B9DC597D253F69D31B6D9E1C9@DB9PR08MB6857.eurprd08.prod.outlook.com>
From:   Oleksandr <olekstysh@gmail.com>
Message-ID: <17f02c54-4697-7aaa-6c6b-19c2bbeb169b@gmail.com>
Date:   Tue, 6 Jul 2021 15:07:18 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <DB9PR08MB6857B9DC597D253F69D31B6D9E1C9@DB9PR08MB6857.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


Hello Wei,


Sorry for the late response.
And thanks for working in that direction and preparing the document.


On 05.07.21 13:02, Wei Chen wrote:
> Hi Stefano,
>
> Thanks for your comments.
>
>> -----Original Message-----
>> From: Stefano Stabellini <sstabellini@kernel.org>
>> Sent: 2021年6月30日 8:43
>> To: will@kernel.org; julien.thierry.kdev@gmail.com; Wei Chen
>> <Wei.Chen@arm.com>
>> Cc: kvm@vger.kernel.org; xen-devel@lists.xen.org; jean-philippe@linaro.org;
>> Julien Grall <julien@xen.org>; Andre Przywara <Andre.Przywara@arm.com>;
>> Marc Zyngier <maz@kernel.org>; Stefano Stabellini <sstabellini@kernel.org>;
>> Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>
>> Subject: Re: [Kvmtool] Some thoughts on using kvmtool Virtio for Xen
>>
>> Hi Wei,
>>
>> Sorry for the late reply.
>>
>>
>> On Tue, 15 Jun 2021, Wei Chen wrote:
>>> Hi,
>>>
>>> I have some thoughts of using kvmtool Virtio implementation
>>> for Xen. I copied my markdown file to this email. If you have
>>> time, could you please help me review it?
>>>
>>> Any feedback is welcome!
>>>
>>> # Some thoughts on using kvmtool Virtio for Xen
>>> ## Background
>>>
>>> Xen community is working on adding VIRTIO capability to Xen. And we're
>> working
>>> on VIRTIO backend of Xen. But except QEMU can support virtio-net for
>> x86-xen,
>>> there is not any VIRTIO backend can support Xen. Because of the
>> community's
>>> strong voice of Out-of-QEMU, we want to find a light weight VIRTIO
>> backend to
>>> support Xen.


Yes, having something light weight to provide Virtio backends for the at 
least *main* devices (console, blk, net)
which we could run on Xen without an extra effort would be really nice.


>>>
>>> We have an idea of utilizing the virtio implementaton of kvmtool for Xen.
>> And
>>> We know there was some agreement that kvmtool won't try to be a full
>> QEMU
>>> alternative. So we have written two proposals in following content for
>>> communities to discuss in public:
>>>
>>> ## Proposals
>>> ### 1. Introduce a new "dm-only" command
>>> 1. Introduce a new "dm-only" command to provide a pure device model mode.
>> In
>>>     this mode, kvmtool only handles IO request. VM creation and
>> initialization
>>>     will be bypassed.
>>>
>>>      * We will rework the interface between the virtio code and the rest
>> of
>>>      kvmtool, to use just the minimal set of information. At the end,
>> there
>>>      would be MMIO accesses and shared memory that control the device
>> model,
>>>      so that could be abstracted to do away with any KVM specifics at all.
>> If
>>>      this is workable, we will send the first set of patches to introduce
>> this
>>>      interface, and adapt the existing kvmtool to it. Then later we will
>> can
>>>      add Xen support on top of it.
>>>
>>>      About Xen support, we will detect the presence of Xen libraries,
>> also
>>>      allow people to ignore them, as kvmtoll do with optional features
>> like
>>>      libz or libaio.
>>>
>>>      Idealy, we want to move all code replying on Xen libraries to a set
>> of
>>>      new files. In this case, thes files can only be compiled when Xen
>>>      libraries are detected. But if we can't decouple this code
>> completely,
>>>      we may introduce a bit of #ifdefs to protect this code.
>>>
>>>      If kvm or other VMM do not need "dm-only" mode. Or "dm-only" can not
>>>      work without Xen libraries. We will make "dm-only" command depends
>> on
>>>      the presence of Xen libraries.
>>>
>>>      So a normal compile (without the Xen libraries installed) would
>> create
>>>      a binary as close as possible to the current code, and only the
>> people
>>>      who having Xen libraries installed would ever generate a "dm-only"
>>>      capable kvmtool.
>>>
>>> ### 2. Abstract kvmtool virtio implementation as a library
>>> 1. Add a kvmtool Makefile target to generate a virtio library. In this
>>>     scenario, not just Xen, but any project else want to provide a
>>>     userspace virtio backend service can link to this virtio libraris.
>>>     These users would benefit from the VIRTIO implementation of kvmtool
>>>     and will participate in improvements, upgrades, and maintenance of
>>>     the VIRTIO libraries.
>>>
>>>      * In this case, Xen part code will not upstream to kvmtool repo,
>>>        it would then be natural parts of the xen repo, in xen/tools or
>>>        maintained in other repo.
>>>
>>>        We will have a completely separate VIRTIO backend for Xen, just
>>>        linking to kvmtool's VIRTIO library.
>>>
>>>      * The main changes of kvmtool would be:
>>>          1. Still need to rework the interface between the virtio code
>>>             and the rest of kvmtool, to abstract the whole virtio
>>>             implementation into a library
>>>          2. Modify current build system to add a new virtio library
>> target.
>>
>>
>> I don't really have a preference between the two.
>>
>>  From my past experience with Xen enablement in QEMU, I can say that the
>> Xen part of receiving IO emulation requests is actually pretty minimal.

In general, both proposals sound good to me, probably with a little 
preference for #1, but I am not sure that I can see all pitfalls here.


> Yes, we have done some prototyping, and the code of Xen receive IOREQ
> support can be implemented in a separate new file without invasion into
> the existing kvmtool.
>
> The point is that the device implementation calls the hypervisor interfaces
> to handle these IOREQs, and is currently tightly coupled to Linux-KVM in the
> implementation of each device. Without some abstract work, these adaptations
> can lead to more intrusive modifications.
>
>> See as a reference
>> https://github.com/qemu/qemu/blob/13d5f87cc3b94bfccc501142df4a7b12fee3a6e7
>> /hw/i386/xen/xen-hvm.c#L1163.
>> The modifications to rework the internal interfaces that you listed
>> below are far more "interesting" than the code necessary to receive
>> emulation requests from Xen.


+1

>>
> I'm glad to hear that : )
>
>> So it looks like option-1 would be less efforts and fewer code changes
>> overall to kvmtools. Option-2 is more work. The library could be nice to
>> have but then we would have to be very careful about the API/ABI,
>> compatibility, etc.
>>
>> Will Deacon and Julien Thierry might have an opinion.
>>
>>
> Looking forward to Will and Julien's comments.
>
>>> ## Reworking the interface is the common work for above proposals
>>> **In kvmtool, one virtual device can be separated into three layers:**
>>>
>>> - A device type layer to provide an abstract
>>>      - Provide interface to collect and store device configuration.
>>>          Using block device as an example, kvmtool is using disk_image to
>>>          -  collect and store disk parameters like:
>>>              -  backend image format: raw, qcow or block device
>>>              -  backend block device or file image path
>>>              -  Readonly, direct and etc
>>>      - Provide operations to interact with real backend devices or
>> services:
>>>          - provide backend device operations:
>>>              - block device operations
>>>              - raw image operations
>>>              - qcow image operations
>>> - Hypervisor interfaces
>>>      - Guest memory mapping and unmapping interfaces
>>>      - Virtual device register interface
>>>          - MMIO/PIO space register
>>>          - IRQ register
>>>      - Virtual IRQ inject interface
>>>      - Hypervisor eventfd interface
>> The "hypervisor interfaces" are the ones that are most interesting as we
>> need an alternative implementation for Xen for each of them. This is
>> the part that was a bit more delicate when we added Xen support to QEMU.
>> Especially the memory mapping and unmapping. All doable but we need
>> proper abstractions.
>>
> Yes. Guest memory mapping and unmapping, if we use option#1, this will be a
> a big change introduced in Kvmtool. Since Linux-KVM guest memory in kvmtool
> is flat mapped in advance, it does not require dynamic Guest memory mapping
> and unmapping. A proper abstract interface can bridge this gap.

The layer separation scheme looks reasonable to me at first sight. 
Agree, "Hypervisor interfaces" worry the most, especially "Guest memory 
mapping and unmapping" which is something completely different on Xen in 
comparison with Kvm. If I am not mistaken, in the PoC the Virtio ring(s) 
are mapped at once during device initialization and unmapped during 
releasing it, while the payloads I/O buffers are mapped/unmapped at 
run-time ...
If only we could map all memory in advance and just calculate virt addr 
at run-time like it was done for Kvm case in guest_flat_to_host(). What 
we would just need is to re-map memory once the guest memory layout is 
changed
(fortunately, we have invalidate mapcache request to signal about that).


FYI, I had a discussion with Julien on IRC regarding foreign memory 
mappings and possible improvements, the main problem today is that we 
need to steal page from the backend domain memory in order to map guest 
page into backend address space, so if we decide to map all memory in 
advance and need to serve guest(s) with a lot of memory we may run out 
of memory in the host very quickly (see XSA-300). So the idea is to try 
to map guest memory into some unused address space provided by the 
hypervisor and then hot-plugged without charging real domain pages 
(everything not mapped into P2M could be theoretically treated as 
unused). I have already started investigations, but unfortunately had to 
postpone them due to project related activities, definitely I have a 
plan to resume them again and create a PoC at least. This would simplify 
things, improve performance and eliminate the memory pressure in the host.


>
>>> - An implementation layer to handle guest IO request.
>>>      - Kvmtool provides virtual devices for guest. Some virtual devices
>> two
>>>        kinds of implementations:
>>>          - VIRTIO implementation
>>>          - Real hardware emulation
>>>
>>> For example, kvmtool console has virtio console and 8250 serial two
>> kinds
>>> of implementations. These implementation depends on device type
>> parameters
>>> to create devices, and depends on device type ops to forward data
>> from/to
>>> real device. And the implementation will invoke hypervisor interfaces to
>>> map/unmap resources and notify guest.
>>>
>>> In the current kvmtool code, the boundaries between these three layers
>> are
>>> relatively clear, but there are a few pieces of code that are somewhat
>>> interleaved, for example:
>>> - In virtio_blk__init(...) function, the code will use disk_image
>> directly.
>>>    This data is kvmtool specified. If we want to make VIRTIO
>> implementation
>>>    become hypervisor agnostic. Such kind of code should be moved to other
>>>    place. Or we just keep code from virtio_blk__init_one(...) in virtio
>> block
>>>    implementation, but keep virtio_blk__init(...) in kvmtool specified
>> part
>>>    code.
>>>
>>> However, in the current VIRTIO device creation and data handling process,
>>> the device type and hypervisor API used are both exclusive to kvmtool
>> and
>>> KVM. If we want to use current VIRTIO implementation for other device
>>> models and hypervisors, it is unlikely to work properly.
>>>
>>> So, the major work of reworking interface is decoupling VIRTIO
>> implementation
>>> from kvmtool and KVM.
>>>
>>> **Introduce some intermediate data structures to do decouple:**
>>> 1. Introduce intermedidate type data structures like `virtio_disk_type`,
>>>     `virtio_net_type`, `virtio_console_type` and etc. These data
>> structures
>>>     will be the standard device type interfaces between virtio device
>>>     implementation and hypervisor.  Using virtio_disk_type as an example:
>>>      ~~~~
>>>      struct virtio_disk_type {
>>>          /*
>>>           * Essential configuration for virtio block device can be got
>> from
>>>           * kvmtool disk_image. Other hypervisor device model also can
>> use
>>>           * this data structure to pass necessary parameters for creating
>>>           * a virtio block device.
>>>           */
>>>          struct virtio_blk_cfg vblk_cfg;
>>>          /*
>>>           * Virtio block device MMIO address and IRQ line. These two
>> members
>>>           * are optional. If hypervisor provides allocate_mmio_space and
>>>           * allocate_irq_line capability and device model doesn't set
>> these
>>>           * two fields, virtio block implementation will use hypervisor
>> APIs
>>>           * to allocate MMIO address and IRQ line. If these two fields
>> are
>>>           * configured, virtio block implementation will use them.
>>>           */
>>>          paddr_t addr;
>>>          uint32_t irq;
>>>          /*
>>>           * In kvmtool, this ops will connect to disk_image APIs. Other
>>>           * hypervisor device model should provide similar APIs for this
>>>           * ops to interact with real backend device.
>>>           */
>>>          struct disk_type_ops {
>>>              .read
>>>              .write
>>>              .flush
>>>              .wait
>>>              ...
>>>          } ops;
>>>      };
>>>      ~~~~
>>>
>>> 2. Introduce a intermediate hypervisor data structure. This data
>> structure
>>>     provides a set of standard hypervisor API interfaces. In virtio
>>>     implementation, the KVM specified APIs, like kvm_register_mmio, will
>> not
>>>     be invoked directly. The virtio implementation will use these
>> interfaces
>>>     to access hypervisor specified APIs. for example `struct vmm_impl`:
>>>      ~~~~
>>>      struct vmm_impl {
>>>          /*
>>>           * Pointer that link to real hypervisor handle like `struct kvm
>> *kvm`.
>>>           * This pointer will be passed to the vmm ops;
>>>           */
>>>          void *vmm;
>>>          allocate_irq_line_fn_t(void* vmm, ...);
>>>          allocate_mmio_space_fn_t(void* vmm, ...);
>>>          register_mmio_fn_t(void* vmm, ...);
>>>          map_guest_page_fn_t(void* vmm, ...);
>>>          unmap_guest_page_fn_t(void* vmm, ...);
>>>          virtual_irq_inject_fn_t(void* vmm, ...);
>>>      };
>>>      ~~~~
>> Are the map_guest_page and unmap_guest_page functions already called at
>> the appropriate places for KVM?
> As I had mentioned in above, KVM doesn't need map_guest_page and unmap_guest_page
> dynamically while handling the IOREQ. These two interfaces can be pointed to NULL
> or empty functions for KVM.
>
>> If not, the main issue is going to be adding the
>> map_guest_page/unmap_guest_page calls to the virtio device
>> implementations.
>>
> Yes, we can place them to virtio device implementations, and keep NOP
> operation for KVM. Other VMMs can be implemented as the case may be
>
>>> 3. After decoupled with kvmtool, any hypervisor can use standard
>> `vmm_impl`
>>>     and `virtio_xxxx_type` interfaces to invoke standard virtio
>> implementation
>>>     interfaces to create virtio devices.
>>>      ~~~~
>>>      /* Prepare VMM interface */
>>>      struct vmm_impl *vmm = ...;
>>>      vmm->register_mmio_fn_t = kvm__register_mmio;
>>>      /* kvm__map_guset_page is a wrapper guest_flat_to_host */
>>>      vmm->map_guest_page_fn_t = kvm__map_guset_page;
>>>      ...
>>>
>>>      /* Prepare virtio_disk_type */
>>>      struct virtio_disk_type *vdisk_type = ...;
>>>      vdisk_type->vblk_cfg.capacity = disk_image->size / SECTOR_SIZE;
>>>      ...
>>>      vdisk_type->ops->read = disk_image__read;
>>>      vdisk_type->ops->write = disk_image__write;
>>>      ...
>>>
>>>      /* Invoke VIRTIO implementation API to create a virtio block device
>> */
>>>      virtio_blk__init_one(vmm, vdisk_type);
>>>      ~~~~
>>>
>>> VIRTIO block device simple flow before reworking interface:
>>>
>> https://drive.google.com/file/d/1k0Grd4RSuCmhKUPktHj9FRamEYrPCFkX/view?usp
>> =sharing
>>> ![image](https://drive.google.com/uc?export=view&id=1k0Grd4RSuCmhKUPktHj
>> 9FRamEYrPCFkX)
>>> VIRTIO block device simple flow after reworking interface:
>>>
>> https://drive.google.com/file/d/1rMXRvulwlRO39juWf08Wgk3G1NZtG2nL/view?usp
>> =sharing
>>> ![image](https://drive.google.com/uc?export=view&id=1rMXRvulwlRO39juWf08
>> Wgk3G1NZtG2nL)

Could you please provide an access for these documents if possible?


>>>
>>> Thanks,
>>> Wei Chen
>>> IMPORTANT NOTICE: The contents of this email and any attachments are
>> confidential and may also be privileged. If you are not the intended
>> recipient, please notify the sender immediately and do not disclose the
>> contents to any other person, use it for any purpose, or store or copy the
>> information in any medium. Thank you.
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.

-- 
Regards,

Oleksandr Tyshchenko

