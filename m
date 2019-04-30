Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F00B10055
	for <lists+kvm@lfdr.de>; Tue, 30 Apr 2019 21:32:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbfD3Tb4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 Apr 2019 15:31:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37770 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726006AbfD3Tb4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 Apr 2019 15:31:56 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 498533082134;
        Tue, 30 Apr 2019 19:31:55 +0000 (UTC)
Received: from [10.36.112.20] (ovpn-112-20.ams2.redhat.com [10.36.112.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A2DE1001E85;
        Tue, 30 Apr 2019 19:31:49 +0000 (UTC)
Subject: Re: [PATCH v6 00/14] KVM/X86: Introduce a new guest mapping interface
To:     Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Raslan, KarimAllah" <karahmed@amazon.de>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "rkrcmar@redhat.com" <rkrcmar@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>
References: <1548966284-28642-1-git-send-email-karahmed@amazon.de>
 <1552914624.8242.1.camel@amazon.de>
 <20190318142232.GC16697@char.us.oracle.com>
 <1552936587.8242.22.camel@amazon.de>
 <20190429135828.GA21193@char.us.oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=pbonzini@redhat.com; prefer-encrypt=mutual; keydata=
 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
 uUHgL9dKIfvpm+rNXRn9wAwGjk0X/A==
Message-ID: <4866fbea-25ec-e112-93c3-90fa8a89ad42@redhat.com>
Date:   Tue, 30 Apr 2019 21:31:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190429135828.GA21193@char.us.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.42]); Tue, 30 Apr 2019 19:31:55 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29/04/19 15:58, Konrad Rzeszutek Wilk wrote:
> On Mon, Mar 18, 2019 at 07:16:28PM +0000, Raslan, KarimAllah wrote:
>> On Mon, 2019-03-18 at 10:22 -0400, Konrad Rzeszutek Wilk wrote:
>>> On Mon, Mar 18, 2019 at 01:10:24PM +0000, Raslan, KarimAllah wrote:
>>>>
>>>> I guess this patch series missed the 5.1 merge window? :)
>>>
>>> Were there any outstanding fixes that had to be addressed?
>>
>> Not as far as I can remember. This version addressed all requests raised in 
>> 'v5'.
> 
> Paolo,
> 
> Are there any concerns in pulling this patchset in?

No, it should be in 5.2.

Paolo

> 
> Thank you!
>>
>>>
>>>>
>>>>
>>>> On Thu, 2019-01-31 at 21:24 +0100, KarimAllah Ahmed wrote:
>>>>>
>>>>> Guest memory can either be directly managed by the kernel (i.e. have a "struct
>>>>> page") or they can simply live outside kernel control (i.e. do not have a
>>>>> "struct page"). KVM mostly support these two modes, except in a few places
>>>>> where the code seems to assume that guest memory must have a "struct page".
>>>>>
>>>>> This patchset introduces a new mapping interface to map guest memory into host
>>>>> kernel memory which also supports PFN-based memory (i.e. memory without 'struct
>>>>> page'). It also converts all offending code to this interface or simply
>>>>> read/write directly from guest memory. Patch 2 is additionally fixing an
>>>>> incorrect page release and marking the page as dirty (i.e. as a side-effect of
>>>>> using the helper function to write).
>>>>>
>>>>> As far as I can see all offending code is now fixed except the APIC-access page
>>>>> which I will handle in a seperate series along with dropping
>>>>> kvm_vcpu_gfn_to_page and kvm_vcpu_gpa_to_page from the internal KVM API.
>>>>>
>>>>> The current implementation of the new API uses memremap to map memory that does
>>>>> not have a "struct page". This proves to be very slow for high frequency
>>>>> mappings. Since this does not affect the normal use-case where a "struct page"
>>>>> is available, the performance of this API will be handled by a seperate patch
>>>>> series.
>>>>>
>>>>> So the simple way to use memory outside kernel control is:
>>>>>
>>>>> 1- Pass 'mem=' in the kernel command-line to limit the amount of memory managed 
>>>>>    by the kernel.
>>>>> 2- Map this physical memory you want to give to the guest with:
>>>>>    mmap("/dev/mem", physical_address_offset, ..)
>>>>> 3- Use the user-space virtual address as the "userspace_addr" field in
>>>>>    KVM_SET_USER_MEMORY_REGION ioctl.
>>>>>
>>>>> v5 -> v6:
>>>>> - Added one extra patch to ensure that support for this mem= case is complete
>>>>>   for x86.
>>>>> - Added a helper function to check if the mapping is mapped or not.
>>>>> - Added more comments on the struct.
>>>>> - Setting ->page to NULL on unmap and to a poison ptr if unused during map
>>>>> - Checking for map ptr before using it.
>>>>> - Change kvm_vcpu_unmap to also mark page dirty for LM. That requires
>>>>>   passing the vCPU pointer again to this function.
>>>>>
>>>>> v4 -> v5:
>>>>> - Introduce a new parameter 'dirty' into kvm_vcpu_unmap
>>>>> - A horrible rebase due to nested.c :)
>>>>> - Dropped a couple of hyperv patches as the code was fixed already as a
>>>>>   side-effect of another patch.
>>>>> - Added a new trivial cleanup patch.
>>>>>
>>>>> v3 -> v4:
>>>>> - Rebase
>>>>> - Add a new patch to also fix the newly introduced enlightned VMCS.
>>>>>
>>>>> v2 -> v3:
>>>>> - Rebase
>>>>> - Add a new patch to also fix the newly introduced shadow VMCS.
>>>>>
>>>>> Filippo Sironi (1):
>>>>>   X86/KVM: Handle PFNs outside of kernel reach when touching GPTEs
>>>>>
>>>>> KarimAllah Ahmed (13):
>>>>>   X86/nVMX: handle_vmon: Read 4 bytes from guest memory
>>>>>   X86/nVMX: Update the PML table without mapping and unmapping the page
>>>>>   KVM: Introduce a new guest mapping API
>>>>>   X86/nVMX: handle_vmptrld: Use kvm_vcpu_map when copying VMCS12 from
>>>>>     guest memory
>>>>>   KVM/nVMX: Use kvm_vcpu_map when mapping the L1 MSR bitmap
>>>>>   KVM/nVMX: Use kvm_vcpu_map when mapping the virtual APIC page
>>>>>   KVM/nVMX: Use kvm_vcpu_map when mapping the posted interrupt
>>>>>     descriptor table
>>>>>   KVM/X86: Use kvm_vcpu_map in emulator_cmpxchg_emulated
>>>>>   KVM/nSVM: Use the new mapping API for mapping guest memory
>>>>>   KVM/nVMX: Use kvm_vcpu_map for accessing the shadow VMCS
>>>>>   KVM/nVMX: Use kvm_vcpu_map for accessing the enlightened VMCS
>>>>>   KVM/nVMX: Use page_address_valid in a few more locations
>>>>>   kvm, x86: Properly check whether a pfn is an MMIO or not
>>>>>
>>>>>  arch/x86/include/asm/e820/api.h |   1 +
>>>>>  arch/x86/kernel/e820.c          |  18 ++++-
>>>>>  arch/x86/kvm/mmu.c              |   5 +-
>>>>>  arch/x86/kvm/paging_tmpl.h      |  38 +++++++---
>>>>>  arch/x86/kvm/svm.c              |  97 ++++++++++++------------
>>>>>  arch/x86/kvm/vmx/nested.c       | 160 +++++++++++++++-------------------------
>>>>>  arch/x86/kvm/vmx/vmx.c          |  19 ++---
>>>>>  arch/x86/kvm/vmx/vmx.h          |   9 ++-
>>>>>  arch/x86/kvm/x86.c              |  14 ++--
>>>>>  include/linux/kvm_host.h        |  28 +++++++
>>>>>  virt/kvm/kvm_main.c             |  64 ++++++++++++++++
>>>>>  11 files changed, 267 insertions(+), 186 deletions(-)
>>>>>
>>>>
>>>>
>>>>
>>>> Amazon Development Center Germany GmbH
>>>> Krausenstr. 38
>>>> 10117 Berlin
>>>> Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
>>>> Ust-ID: DE 289 237 879
>>>> Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
>>>>
>>
>>
>>
>> Amazon Development Center Germany GmbH
>> Krausenstr. 38
>> 10117 Berlin
>> Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
>> Ust-ID: DE 289 237 879
>> Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
>>

