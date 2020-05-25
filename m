Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D52A1E0FCE
	for <lists+kvm@lfdr.de>; Mon, 25 May 2020 15:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403874AbgEYNtW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 25 May 2020 09:49:22 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:50374 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403812AbgEYNtV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 25 May 2020 09:49:21 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04PDgGit014534;
        Mon, 25 May 2020 13:47:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s7KIET0nPuMkj+HSRLz0InJT7D6cWyb2Hd4U4WhRrRo=;
 b=fF8ehDGeJ1pY/y1tbaYEKRs8k4Rl9Ajo2W/mUo+bdWKISsF7qGp3nSW3SBiEuqdHiDYt
 OGxfQfD7s0eZpnamHRNIUYBBA/jjA5NzHk9H+VFWfvlgEdHyOjriy12LgUUxRT4Be6vv
 f/bFTF/OemjmL3KzEqA2aj44BCW6LPjwkc6XwdOamxqmtFRrHupYJ4dXOmSUkV+H6K8p
 rugrka68HBDEbuF34WAnpk4sitU40JVDEW6156dH2eCkpqeFA/hmM32ix4Yzix/Rftke
 k6FR+kVq+Z9mFU8VbxM3kyhOQWR3T6DtGg3ydwrjpkbej99S/ctk/RcJ+wJF7AfKDpVa XQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 316usknndc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 25 May 2020 13:47:28 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 04PDguJs002776;
        Mon, 25 May 2020 13:47:28 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 317ddm9gsk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 May 2020 13:47:28 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 04PDlOPf004311;
        Mon, 25 May 2020 13:47:24 GMT
Received: from [192.168.14.112] (/79.178.199.48)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 25 May 2020 06:47:24 -0700
Subject: Re: [RFC 00/16] KVM protected memory extension
To:     "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
Cc:     David Rientjes <rientjes@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>,
        "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
        "Kleen, Andi" <andi.kleen@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
References: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
From:   Liran Alon <liran.alon@oracle.com>
Message-ID: <42685c32-a7a9-b971-0cf4-e8af8d9a40c6@oracle.com>
Date:   Mon, 25 May 2020 16:47:18 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.13; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200522125214.31348-1-kirill.shutemov@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0 mlxscore=0
 phishscore=0 adultscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005250106
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9631 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 bulkscore=0 mlxlogscore=999 phishscore=0
 cotscore=-2147483648 adultscore=0 mlxscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.12.0-2004280000
 definitions=main-2005250106
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


On 22/05/2020 15:51, Kirill A. Shutemov wrote:
> == Background / Problem ==
>
> There are a number of hardware features (MKTME, SEV) which protect guest
> memory from some unauthorized host access. The patchset proposes a purely
> software feature that mitigates some of the same host-side read-only
> attacks.
>
>
> == What does this set mitigate? ==
>
>   - Host kernel ”accidental” access to guest data (think speculation)

Just to clarify: This is any host kernel memory info-leak vulnerability. 
Not just speculative execution memory info-leaks. Also architectural ones.

In addition, note that removing guest data from host kernel VA space 
also makes guest<->host memory exploits more difficult.
E.g. Guest cannot use already available memory buffer in kernel VA space 
for ROP or placing valuable guest-controlled code/data in general.

>
>   - Host kernel induced access to guest data (write(fd, &guest_data_ptr, len))
>
>   - Host userspace access to guest data (compromised qemu)

I don't quite understand what is the benefit of preventing userspace VMM 
access to guest data while the host kernel can still access it.

QEMU is more easily compromised than the host kernel because it's 
guest<->host attack surface is larger (E.g. Various device emulation).
But this compromise comes from the guest itself. Not other guests. In 
contrast to host kernel attack surface, which an info-leak there can
be exploited from one guest to leak another guest data.
>
> == What does this set NOT mitigate? ==
>
>   - Full host kernel compromise.  Kernel will just map the pages again.
>
>   - Hardware attacks
>
>
> The patchset is RFC-quality: it works but has known issues that must be
> addressed before it can be considered for applying.
>
> We are looking for high-level feedback on the concept.  Some open
> questions:
>
>   - This protects from some kernel and host userspace read-only attacks,
>     but does not place the host kernel outside the trust boundary. Is it
>     still valuable?
I don't currently see a good argument for preventing host userspace 
access to guest data while host kernel can still access it.
But there is definitely strong benefit of mitigating kernel info-leaks 
exploitable from one guest to leak another guest data.
>
>   - Can this approach be used to avoid cache-coherency problems with
>     hardware encryption schemes that repurpose physical bits?
>
>   - The guest kernel must be modified for this to work.  Is that a deal
>     breaker, especially for public clouds?
>
>   - Are the costs of removing pages from the direct map too high to be
>     feasible?

If I remember correctly, this perf cost was too high when considering 
XPFO (eXclusive Page Frame Ownership) patch-series.
This created two major perf costs:
1) Removing pages from direct-map prevented direct-map from simply be 
entirely mapped as 1GB huge-pages.
2) Frequent allocation/free of userspace pages resulted in frequent TLB 
invalidations.

Having said that, (1) can be mitigated in case guest data is completely 
allocated from 1GB hugetlbfs to guarantee it will not
create smaller holes in direct-map. And (2) is not relevant for QEMU/KVM 
use-case.

This makes me wonder:
XPFO patch-series, applied to the context of QEMU/KVM, seems to provide 
exactly the functionality of this patch-series,
with the exception of the additional "feature" of preventing guest data 
from also being accessible to host userspace VMM.
i.e. XPFO will unmap guest pages from host kernel direct-map while still 
keeping them mapped in host userspace VMM page-tables.

If I understand correctly, this "feature" is what brings most of the 
extra complexity of this patch-series compared to XPFO.
It requires guest modification to explicitly specify to host which pages 
can be accessed by userspace VMM, it requires
changes to add new VM_KVM_PROTECTED VMA flag & FOLL_KVM for GUP, and it 
creates issues with Live-Migration support.

So if there is no strong convincing argument for the motivation to 
prevent userspace VMM access to guest data *while host kernel
can still access guest data*, I don't see a good reason for using this 
approach.

Furthermore, I would like to point out that just unmapping guest data 
from kernel direct-map is not sufficient to prevent all
guest-to-guest info-leaks via a kernel memory info-leak vulnerability. 
This is because host kernel VA space have other regions
which contains guest sensitive data. For example, KVM per-vCPU struct 
(which holds vCPU state) is allocated on slab and therefore
still leakable.

I recommend you will have a look at my (and Alexandre Charte) KVM Forum 
2019 talk on KVM ASI which provides extensive background
on the various attempts done by the community for mitigating host kernel 
memory info-leaks exploitable by guest to leak other guests data:
https://static.sched.com/hosted_files/kvmforum2019/34/KVM%20Forum%202019%20KVM%20ASI.pdf

>
> == Series Overview ==
>
> The hardware features protect guest data by encrypting it and then
> ensuring that only the right guest can decrypt it.  This has the
> side-effect of making the kernel direct map and userspace mapping
> (QEMU et al) useless.  But, this teaches us something very useful:
> neither the kernel or userspace mappings are really necessary for normal
> guest operations.
>
> Instead of using encryption, this series simply unmaps the memory. One
> advantage compared to allowing access to ciphertext is that it allows bad
> accesses to be caught instead of simply reading garbage.
>
> Protection from physical attacks needs to be provided by some other means.
> On Intel platforms, (single-key) Total Memory Encryption (TME) provides
> mitigation against physical attacks, such as DIMM interposers sniffing
> memory bus traffic.
>
> The patchset modifies both host and guest kernel. The guest OS must enable
> the feature via hypercall and mark any memory range that has to be shared
> with the host: DMA regions, bounce buffers, etc. SEV does this marking via a
> bit in the guest’s page table while this approach uses a hypercall.
>
> For removing the userspace mapping, use a trick similar to what NUMA
> balancing does: convert memory that belongs to KVM memory slots to
> PROT_NONE: all existing entries converted to PROT_NONE with mprotect() and
> the newly faulted in pages get PROT_NONE from the updated vm_page_prot.
> The new VMA flag -- VM_KVM_PROTECTED -- indicates that the pages in the
> VMA must be treated in a special way in the GUP and fault paths. The flag
> allows GUP to return the page even though it is mapped with PROT_NONE, but
> only if the new GUP flag -- FOLL_KVM -- is specified. Any userspace access
> to the memory would result in SIGBUS. Any GUP access without FOLL_KVM
> would result in -EFAULT.
>
> Any anonymous page faulted into the VM_KVM_PROTECTED VMA gets removed from
> the direct mapping with kernel_map_pages(). Note that kernel_map_pages() only
> flushes local TLB. I think it's a reasonable compromise between security and
> perfromance.
>
> Zapping the PTE would bring the page back to the direct mapping after clearing.
> At least for now, we don't remove file-backed pages from the direct mapping.
> File-backed pages could be accessed via read/write syscalls. It adds
> complexity.
>
> Occasionally, host kernel has to access guest memory that was not made
> shared by the guest. For instance, it happens for instruction emulation.
> Normally, it's done via copy_to/from_user() which would fail with -EFAULT
> now. We introduced a new pair of helpers: copy_to/from_guest(). The new
> helpers acquire the page via GUP, map it into kernel address space with
> kmap_atomic()-style mechanism and only then copy the data.
>
> For some instruction emulation copying is not good enough: cmpxchg
> emulation has to have direct access to the guest memory. __kvm_map_gfn()
> is modified to accommodate the case.
>
> The patchset is on top of v5.7-rc6 plus this patch:
>
> https://urldefense.com/v3/__https://lkml.kernel.org/r/20200402172507.2786-1-jimmyassarsson@gmail.com__;!!GqivPVa7Brio!MSTb9DzpOUJMLMaMq-J7QOkopsKIlAYXpIxiu5FwFYfRctwIyNi8zBJWvlt89j8$
>
> == Open Issues ==
>
> Unmapping the pages from direct mapping bring a few of issues that have
> not rectified yet:
>
>   - Touching direct mapping leads to fragmentation. We need to be able to
>     recover from it. I have a buggy patch that aims at recovering 2M/1G page.
>     It has to be fixed and tested properly
As I've mentioned above, not mapping all guest memory from 1GB hugetlbfs 
will lead to holes in kernel direct-map which force it to not be mapped 
anymore as a series of 1GB huge-pages.
This have non-trivial performance cost. Thus, I am not sure addressing 
this use-case is valuable.
>
>   - Page migration and KSM is not supported yet.
>
>   - Live migration of a guest would require a new flow. Not sure yet how it
>     would look like.

Note that Live-Migration issue is a result of not making guest data 
accessible to host userspace VMM.

-Liran

>
>   - The feature interfere with NUMA balancing. Not sure yet if it's
>     possible to make them work together.
>
>   - Guests have no mechanism to ensure that even a well-behaving host has
>     unmapped its private data.  With SEV, for instance, the guest only has
>     to trust the hardware to encrypt a page after the C bit is set in a
>     guest PTE.  A mechanism for a guest to query the host mapping state, or
>     to constantly assert the intent for a page to be Private would be
>     valuable.
