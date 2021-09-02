Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A61D33FEAC7
	for <lists+kvm@lfdr.de>; Thu,  2 Sep 2021 10:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244584AbhIBIpM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Sep 2021 04:45:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27473 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244570AbhIBIpL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Sep 2021 04:45:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630572246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWRgLyOnqoIayiNQjYpy0dsyFWdFNzRj4QcD6Wzn1iU=;
        b=SWgJOV2inDYutHJ6n/1F8EHKD5U0UsN1wXXuWEFgG9nm7wPKgVbCiFGmoZcvtNMVxTXjAX
        x1BO6zv/bPWcdLxwYSReBNpIOFiN+52H9Jo4NYidHI9dBMuv7/rUrlEoV4SJZHRLAZZpkL
        r5jcaBy10jB7sR7tNNEquKSMdEjhfQM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-5E4bCwjpMsyWDYzmx2ihJg-1; Thu, 02 Sep 2021 04:44:05 -0400
X-MC-Unique: 5E4bCwjpMsyWDYzmx2ihJg-1
Received: by mail-wm1-f69.google.com with SMTP id w25-20020a1cf6190000b0290252505ddd56so433283wmc.3
        for <kvm@vger.kernel.org>; Thu, 02 Sep 2021 01:44:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:organization:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=VWRgLyOnqoIayiNQjYpy0dsyFWdFNzRj4QcD6Wzn1iU=;
        b=EdKpSXy6yAct8EpSPleSIJZd481EKj8WVGzudDQbhojeQ8qx9mO91DswbqVIu1tfgb
         VIBbSB0I1L5SiAVZN7oNlN3aJg4CwAgE1llybCQ2OGU7+IDaWMkFd7JbSBR+NRXwWpPE
         bBUk1vCbm6NizQNFlGqwaAy6y4Jee9es3Yqn21OFEAbqdYdmUSx3ko2gIl8bLArj9rvK
         x+QSGdmLkJTCYaHUHbzmLuZTArIdQzqFtcKDO5lf3dEQ1OniOxTCx5nSEqrRcpYksIjA
         sXSfJy5C5d2GBfbhD9P7cjNPWThy6EwsZS/GLrWavNQUk+scolXzKMOkVVyWIX3S1qAz
         FyTg==
X-Gm-Message-State: AOAM532FBxjoqV/3IQQDkk4bB1ANr64jNTaxdoLkgr0mPbfUKzHYIQKj
        fDXgbJ7I6MOLXuCxOPlChIwp9vSQmVACWY9Sj056ml2S3E4RclMtYccJZS4YKIxV8pCibanTeFy
        echv/uGroCWGS
X-Received: by 2002:adf:c149:: with SMTP id w9mr2316285wre.126.1630572244473;
        Thu, 02 Sep 2021 01:44:04 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzziPkwyia0D2Pb+mZpxXBmtVXs8bzUX9GXE24EybkhxUj0x0dWCmdrH8a50cPWIyUVXFUHxg==
X-Received: by 2002:adf:c149:: with SMTP id w9mr2316253wre.126.1630572244157;
        Thu, 02 Sep 2021 01:44:04 -0700 (PDT)
Received: from [192.168.3.132] (p5b0c60bd.dip0.t-ipconnect.de. [91.12.96.189])
        by smtp.gmail.com with ESMTPSA id b10sm1215199wrt.43.2021.09.02.01.44.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Sep 2021 01:44:03 -0700 (PDT)
To:     Yu Zhang <yu.c.zhang@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Andi Kleen <ak@linux.intel.com>,
        David Rientjes <rientjes@google.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Varad Gautam <varad.gautam@suse.com>,
        Dario Faggioli <dfaggioli@suse.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        linux-mm@kvack.org, linux-coco@lists.linux.dev,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Sathyanarayanan Kuppuswamy 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        Dave Hansen <dave.hansen@intel.com>
References: <20210824005248.200037-1-seanjc@google.com>
 <307d385a-a263-276f-28eb-4bc8dd287e32@redhat.com>
 <20210827023150.jotwvom7mlsawjh4@linux.intel.com>
 <8f3630ff-bd6d-4d57-8c67-6637ea2c9560@www.fastmail.com>
 <20210901102437.g5wrgezmrjqn3mvy@linux.intel.com>
 <f37a61ba-b7ef-c789-5763-f7f237ae41cc@kernel.org>
 <2b2740ec-fa89-e4c3-d175-824e439874a6@redhat.com>
 <20210902083453.aeouc6fob53ydtc2@linux.intel.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Subject: Re: [RFC] KVM: mm: fd-based approach for supporting KVM guest private
 memory
Message-ID: <823d9453-892e-508d-b806-1b18c9b9fc13@redhat.com>
Date:   Thu, 2 Sep 2021 10:44:02 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210902083453.aeouc6fob53ydtc2@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02.09.21 10:34, Yu Zhang wrote:
> On Wed, Sep 01, 2021 at 06:27:20PM +0200, David Hildenbrand wrote:
>> On 01.09.21 18:07, Andy Lutomirski wrote:
>>> On 9/1/21 3:24 AM, Yu Zhang wrote:
>>>> On Tue, Aug 31, 2021 at 09:53:27PM -0700, Andy Lutomirski wrote:
>>>>>
>>>>>
>>>>> On Thu, Aug 26, 2021, at 7:31 PM, Yu Zhang wrote:
>>>>>> On Thu, Aug 26, 2021 at 12:15:48PM +0200, David Hildenbrand wrote:
>>>>>
>>>>>> Thanks a lot for this summary. A question about the requirement: do we or
>>>>>> do we not have plan to support assigned device to the protected VM?
>>>>>>
>>>>>> If yes. The fd based solution may need change the VFIO interface as well(
>>>>>> though the fake swap entry solution need mess with VFIO too). Because:
>>>>>>
>>>>>> 1> KVM uses VFIO when assigning devices into a VM.
>>>>>>
>>>>>> 2> Not knowing which GPA ranges may be used by the VM as DMA buffer, all
>>>>>> guest pages will have to be mapped in host IOMMU page table to host pages,
>>>>>> which are pinned during the whole life cycle fo the VM.
>>>>>>
>>>>>> 3> IOMMU mapping is done during VM creation time by VFIO and IOMMU driver,
>>>>>> in vfio_dma_do_map().
>>>>>>
>>>>>> 4> However, vfio_dma_do_map() needs the HVA to perform a GUP to get the HPA
>>>>>> and pin the page.
>>>>>>
>>>>>> But if we are using fd based solution, not every GPA can have a HVA, thus
>>>>>> the current VFIO interface to map and pin the GPA(IOVA) wont work. And I
>>>>>> doubt if VFIO can be modified to support this easily.
>>>>>>
>>>>>>
>>>>>
>>>>> Do you mean assigning a normal device to a protected VM or a hypothetical protected-MMIO device?
>>>>>
>>>>> If the former, it should work more or less like with a non-protected VM. mmap the VFIO device, set up a memslot, and use it.  I'm not sure whether anyone will actually do this, but it should be possible, at least in principle.  Maybe someone will want to assign a NIC to a TDX guest.  An NVMe device with the understanding that the guest can't trust it wouldn't be entirely crazy ether.
>>>>>
>>>>> If the latter, AFAIK there is no spec for how it would work even in principle. Presumably it wouldn't work quite like VFIO -- instead, the kernel could have a protection-virtual-io-fd mechanism, and that fd could be bound to a memslot in whatever way we settle on for binding secure memory to a memslot.
>>>>>
>>>>
>>>> Thanks Andy. I was asking the first scenario.
>>>>
>>>> Well, I agree it is doable if someone really want some assigned
>>>> device in TD guest. As Kevin mentioned in his reply, HPA can be
>>>> generated, by extending VFIO with a new mapping protocol which
>>>> uses fd+offset, instead of HVA.
>>>
>>> I'm confused.  I don't see why any new code is needed for this at all.
>>> Every proposal I've seen for handling TDX memory continues to handle TDX
>>> *shared* memory exactly like regular guest memory today.  The only
>>> differences are that more hole punching will be needed, which will
>>> require lightweight memslots (to have many of them), memslots with
>>> holes, or mappings backing memslots with holes (which can be done with
>>> munmap() on current kernels).
>>>
>>> So you can literally just mmap a VFIO device and expect it to work,
>>> exactly like it does right now.  Whether the guest will be willing to
>>> use the device will depend on the guest security policy (all kinds of
>>> patches about that are flying around), but if the guest tries to use it,
>>> it really should just work.
>>
>> ... but if you end up mapping private memory into IOMMU of the device and
>> the device ends up accessing that memory, we're in the same position that
>> the host might get capped, just like access from user space, no?
> 
> Well, according to the spec:
> 
>    - If the result of the translation results in a physical address with a TD
>    private key ID, then the IOMMU will abort the transaction and report a VT-d
>    DMA remapping failure.
> 
>    - If the GPA in the transaction that is input to the IOMMU is private (SHARED
>    bit is 0), then the IOMMU may abort the transaction and report a VT-d DMA
>    remapping failure.
> 
> So I guess mapping private GPAs in IOMMU is not that dangerous as mapping
> into userspace. Though still wrong.
> 
>>
>> Sure, you can map only the complete duplicate shared-memory region into the
>> IOMMU of the device, that would work. Shame vfio mostly always pins all
>> guest memory and you essentially cannot punch holes into the shared memory
>> anymore -- resulting in the worst case in a duplicate memory consumption for
>> your VM.
>>
>> So you'd actually want to map only the *currently* shared pieces into the
>> IOMMU and update the mappings on demand. Having worked on something related,
> 
> Exactly. On demand mapping and page pinning for shared memory is necessary.
> 
>> I can only say that 64k individual mappings, and not being able to modify
>> existing mappings except completely deleting them to replace with something
>> new (!atomic), can be quite an issue for bigger VMs.
> 
> Do you mean atomicity in mapping/unmapping can hardly be guaranteed during
> the shared <-> private transition? May I ask for elaboration? Thanks!

If we expect to really only have little shared memory, and expect a VM 
always has no shared memory when booting up (I think this is the case), 
I guess this could work.

The issue is if the guest e.g., makes contiguous 2 MiB shared and later 
wants to unshare individual pages/parts.

You'll have to DMA map the 2 MiB in page granularity, otherwise you'll 
have to DMA unmap 2 MiB and DMA remap all still-shared pieces. That is 
not atomic and can be problematic if the device is accessing some of the 
shared parts at that time.

Consequently that means, that large shared regions can be problematic 
when mapped, because we'll have to map in page granularity. We have 64k 
such individual mappings in general.

64k * 4KiB == 256 MiB

Not sure if there would be use cases, e.g., with GPGPUs and similar, 
where you'd want to share a lot of memory with a device ...

But these are just my thoughts, maybe I am missing something important.

-- 
Thanks,

David / dhildenb

