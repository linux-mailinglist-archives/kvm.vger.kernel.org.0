Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19EFB11BA31
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 18:24:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731072AbfLKRYS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 12:24:18 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:40465 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730927AbfLKRYR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Dec 2019 12:24:17 -0500
Received: by mail-wm1-f65.google.com with SMTP id t14so7844060wmi.5;
        Wed, 11 Dec 2019 09:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:references:user-agent:to:cc:subject:in-reply-to:message-id
         :date:mime-version;
        bh=y/ml3tRcBXOQAEMxRoKwsWvnAoXNtlDgHbqRIxJ9gnw=;
        b=RdIvH1bo9r+d9wBjozMCTcUJjK5vPbWH7KyBN1PKmOiDRtUHbrmbR3XjCCrPuLdgqh
         SNmcU+p3EJeXAtGtQr80HB2feBYg1NyFj/f7Z3eu0I6IrBUx9k/SCgR83BlvsQDatj/j
         bcdQbj6XWJzrkLqdWoMOYzgAgHLaNobSKOlEsmA3Aw5GIshDyQyatDEkFE/Wdoxeazlj
         Z/oc7PC+D1duJW/xZ6h/8CaZy4DuJpRDgyqY2+6AGVTpLDVulwbiL0XMJZNobSQ83cii
         yCBeQdFOq2bZGRMMiGacTW0bwHfumUEm6GWeQKgnKmwvPNTMxgyYFs3BeT5zqvC4wBi8
         wCjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:user-agent:to:cc:subject
         :in-reply-to:message-id:date:mime-version;
        bh=y/ml3tRcBXOQAEMxRoKwsWvnAoXNtlDgHbqRIxJ9gnw=;
        b=aWjZ8zirePbPgVWnHsl7iSOu3M4gIzJ6bPJwxFsOg8+znVy3gzLUVjFQzYM6nlsAPk
         6Fy5P42LlEi2cXr6r7SQ2EBWK9+UtZW9+S5oWHZHvlbC6EuUap7l2Yp03Cb3hrl/N282
         Fv2FV5ZZJ8EZm3gOG63blIxDo7RG+TIeSmCwe4SqLK8pqRbM10WqYViWTWtGxZCk0fXW
         9vLH/DfKkZRnFQwirV4JR0nONKA2LkV6rg6MvRnSyt5KAR4OZmgHr90QmkZuKdflYq5h
         +n8f5/pn3nS2qt2sKB3aMX2GUeqSi5679EIlC2tr6PeIij+FM/OOezXBsWShlFXKDAml
         WHkA==
X-Gm-Message-State: APjAAAUcvbfKsuRjzsh32IzkQaa7YEbVmhEN8bqbFaWPK6t7BKa48I0h
        C8/AzB5qeckxGiSfW+QQpIg=
X-Google-Smtp-Source: APXvYqwd5IezehTVU8Sr3MiaBWEJmNEc5VBuXl6j99B3J1SZHBL4reMHiP4ENjoHTr0WGqCrmFKqWg==
X-Received: by 2002:a1c:bbc3:: with SMTP id l186mr978208wmf.101.1576085050645;
        Wed, 11 Dec 2019 09:24:10 -0800 (PST)
Received: from ptitpuce ([2a01:e0a:466:71c0:ec85:f9c9:7056:d11])
        by smtp.gmail.com with ESMTPSA id 60sm3046114wrn.86.2019.12.11.09.24.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 09:24:08 -0800 (PST)
From:   Christophe de Dinechin <christophe.de.dinechin@gmail.com>
X-Google-Original-From: Christophe de Dinechin <christophe@dinechin.org>
References: <20191129213505.18472-1-peterx@redhat.com> <20191129213505.18472-5-peterx@redhat.com>
User-agent: mu4e 1.3.5; emacs 26.2
To:     Peter Xu <peterx@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RFC 04/15] KVM: Implement ring-based dirty memory tracking
In-reply-to: <20191129213505.18472-5-peterx@redhat.com>
Message-ID: <m1lfrihj2n.fsf@dinechin.org>
Date:   Wed, 11 Dec 2019 18:24:00 +0100
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Peter Xu writes:

> This patch is heavily based on previous work from Lei Cao
> <lei.cao@stratus.com> and Paolo Bonzini <pbonzini@redhat.com>. [1]
>
> KVM currently uses large bitmaps to track dirty memory.  These bitmaps
> are copied to userspace when userspace queries KVM for its dirty page
> information.  The use of bitmaps is mostly sufficient for live
> migration, as large parts of memory are be dirtied from one log-dirty
> pass to another.

That statement sort of concerns me. If large parts of memory are
dirtied, won't this cause the rings to fill up quickly enough to cause a
lot of churn between user-space and kernel?

See a possible suggestion to address that below.

> However, in a checkpointing system, the number of
> dirty pages is small and in fact it is often bounded---the VM is
> paused when it has dirtied a pre-defined number of pages. Traversing a
> large, sparsely populated bitmap to find set bits is time-consuming,
> as is copying the bitmap to user-space.
>
> A similar issue will be there for live migration when the guest memory
> is huge while the page dirty procedure is trivial.  In that case for
> each dirty sync we need to pull the whole dirty bitmap to userspace
> and analyse every bit even if it's mostly zeros.
>
> The preferred data structure for above scenarios is a dense list of
> guest frame numbers (GFN).  This patch series stores the dirty list in
> kernel memory that can be memory mapped into userspace to allow speedy
> harvesting.
>
> We defined two new data structures:
>
>   struct kvm_dirty_ring;
>   struct kvm_dirty_ring_indexes;
>
> Firstly, kvm_dirty_ring is defined to represent a ring of dirty
> pages.  When dirty tracking is enabled, we can push dirty gfn onto the
> ring.
>
> Secondly, kvm_dirty_ring_indexes is defined to represent the
> user/kernel interface of each ring.  Currently it contains two
> indexes: (1) avail_index represents where we should push our next
> PFN (written by kernel), while (2) fetch_index represents where the
> userspace should fetch the next dirty PFN (written by userspace).
>
> One complete ring is composed by one kvm_dirty_ring plus its
> corresponding kvm_dirty_ring_indexes.
>
> Currently, we have N+1 rings for each VM of N vcpus:
>
>   - for each vcpu, we have 1 per-vcpu dirty ring,
>   - for each vm, we have 1 per-vm dirty ring
>
> Please refer to the documentation update in this patch for more
> details.
>
> Note that this patch implements the core logic of dirty ring buffer.
> It's still disabled for all archs for now.  Also, we'll address some
> of the other issues in follow up patches before it's firstly enabled
> on x86.
>
> [1] https://patchwork.kernel.org/patch/10471409/
>
> Signed-off-by: Lei Cao <lei.cao@stratus.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Peter Xu <peterx@redhat.com>
> ---
>  Documentation/virt/kvm/api.txt | 109 +++++++++++++++
>  arch/x86/kvm/Makefile          |   3 +-
>  include/linux/kvm_dirty_ring.h |  67 +++++++++
>  include/linux/kvm_host.h       |  33 +++++
>  include/linux/kvm_types.h      |   1 +
>  include/uapi/linux/kvm.h       |  36 +++++
>  virt/kvm/dirty_ring.c          | 156 +++++++++++++++++++++
>  virt/kvm/kvm_main.c            | 240 ++++++++++++++++++++++++++++++++-
>  8 files changed, 642 insertions(+), 3 deletions(-)
>  create mode 100644 include/linux/kvm_dirty_ring.h
>  create mode 100644 virt/kvm/dirty_ring.c
>
> diff --git a/Documentation/virt/kvm/api.txt b/Documentation/virt/kvm/api.txt
> index 49183add44e7..fa622c9a2eb8 100644
> --- a/Documentation/virt/kvm/api.txt
> +++ b/Documentation/virt/kvm/api.txt
> @@ -231,6 +231,7 @@ Based on their initialization different VMs may have different capabilities.
>  It is thus encouraged to use the vm ioctl to query for capabilities (available
>  with KVM_CAP_CHECK_EXTENSION_VM on the vm fd)
>
> +
>  4.5 KVM_GET_VCPU_MMAP_SIZE
>
>  Capability: basic
> @@ -243,6 +244,18 @@ The KVM_RUN ioctl (cf.) communicates with userspace via a shared
>  memory region.  This ioctl returns the size of that region.  See the
>  KVM_RUN documentation for details.
>
> +Besides the size of the KVM_RUN communication region, other areas of
> +the VCPU file descriptor can be mmap-ed, including:
> +
> +- if KVM_CAP_COALESCED_MMIO is available, a page at
> +  KVM_COALESCED_MMIO_PAGE_OFFSET * PAGE_SIZE; for historical reasons,
> +  this page is included in the result of KVM_GET_VCPU_MMAP_SIZE.
> +  KVM_CAP_COALESCED_MMIO is not documented yet.

Does the above really belong to this patch?

> +
> +- if KVM_CAP_DIRTY_LOG_RING is available, a number of pages at
> +  KVM_DIRTY_LOG_PAGE_OFFSET * PAGE_SIZE.  For more information on
> +  KVM_CAP_DIRTY_LOG_RING, see section 8.3.
> +
>
>  4.6 KVM_SET_MEMORY_REGION
>
> @@ -5358,6 +5371,7 @@ CPU when the exception is taken. If this virtual SError is taken to EL1 using
>  AArch64, this value will be reported in the ISS field of ESR_ELx.
>
>  See KVM_CAP_VCPU_EVENTS for more details.
> +
>  8.20 KVM_CAP_HYPERV_SEND_IPI
>
>  Architectures: x86
> @@ -5365,6 +5379,7 @@ Architectures: x86
>  This capability indicates that KVM supports paravirtualized Hyper-V IPI send
>  hypercalls:
>  HvCallSendSyntheticClusterIpi, HvCallSendSyntheticClusterIpiEx.
> +
>  8.21 KVM_CAP_HYPERV_DIRECT_TLBFLUSH
>
>  Architecture: x86
> @@ -5378,3 +5393,97 @@ handling by KVM (as some KVM hypercall may be mistakenly treated as TLB
>  flush hypercalls by Hyper-V) so userspace should disable KVM identification
>  in CPUID and only exposes Hyper-V identification. In this case, guest
>  thinks it's running on Hyper-V and only use Hyper-V hypercalls.
> +
> +8.22 KVM_CAP_DIRTY_LOG_RING
> +
> +Architectures: x86
> +Parameters: args[0] - size of the dirty log ring
> +
> +KVM is capable of tracking dirty memory using ring buffers that are
> +mmaped into userspace; there is one dirty ring per vcpu and one global
> +ring per vm.
> +
> +One dirty ring has the following two major structures:
> +
> +struct kvm_dirty_ring {
> +	u16 dirty_index;
> +	u16 reset_index;

What is the benefit of using u16 for that? That means with 4K pages, you
can share at most 256M of dirty memory each time? That seems low to me,
especially since it's sufficient to touch one byte in a page to dirty it.

Actually, this is not consistent with the definition in the code ;-)
So I'll assume it's actually u32.

> +	u32 size;
> +	u32 soft_limit;
> +	spinlock_t lock;
> +	struct kvm_dirty_gfn *dirty_gfns;
> +};
> +
> +struct kvm_dirty_ring_indexes {
> +	__u32 avail_index; /* set by kernel */
> +	__u32 fetch_index; /* set by userspace */
> +};
> +
> +While for each of the dirty entry it's defined as:
> +
> +struct kvm_dirty_gfn {
> +        __u32 pad;
> +        __u32 slot; /* as_id | slot_id */
> +        __u64 offset;
> +};

Like other have suggested, I think we might used "pad" to store size
information to be able to dirty large pages more efficiently.

> +
> +The fields in kvm_dirty_ring will be only internal to KVM itself,
> +while the fields in kvm_dirty_ring_indexes will be exposed to
> +userspace to be either read or written.

The sentence above is confusing when contrasted with the "set by kernel"
comment above.

> +
> +The two indices in the ring buffer are free running counters.

Nit: this patch uses both "indices" and "indexes".
Both are correct, but it would be nice to be consistent.

> +
> +In pseudocode, processing the ring buffer looks like this:
> +
> +	idx = load-acquire(&ring->fetch_index);
> +	while (idx != ring->avail_index) {
> +		struct kvm_dirty_gfn *entry;
> +		entry = &ring->dirty_gfns[idx & (size - 1)];
> +		...
> +
> +		idx++;
> +	}
> +	ring->fetch_index = idx;
> +
> +Userspace calls KVM_ENABLE_CAP ioctl right after KVM_CREATE_VM ioctl
> +to enable this capability for the new guest and set the size of the
> +rings.  It is only allowed before creating any vCPU, and the size of
> +the ring must be a power of two.  The larger the ring buffer, the less
> +likely the ring is full and the VM is forced to exit to userspace. The
> +optimal size depends on the workload, but it is recommended that it be
> +at least 64 KiB (4096 entries).

Is there anything in the design that would preclude resizing the ring
buffer at a later time? Presumably, you'd want a large ring while you
are doing things like migrations, but it's mostly useless when you are
not monitoring memory. So it would be nice to be able to call
KVM_ENABLE_CAP at any time to adjust the size.

As I read the current code, one of the issue would be the mapping of the
rings in case of a later extension where we added something beyond the
rings. But I'm not sure that's a big deal at the moment.

> +
> +After the capability is enabled, userspace can mmap the global ring
> +buffer (kvm_dirty_gfn[], offset KVM_DIRTY_LOG_PAGE_OFFSET) and the
> +indexes (kvm_dirty_ring_indexes, offset 0) from the VM file
> +descriptor.  The per-vcpu dirty ring instead is mmapped when the vcpu
> +is created, similar to the kvm_run struct (kvm_dirty_ring_indexes
> +locates inside kvm_run, while kvm_dirty_gfn[] at offset
> +KVM_DIRTY_LOG_PAGE_OFFSET).
> +
> +Just like for dirty page bitmaps, the buffer tracks writes to
> +all user memory regions for which the KVM_MEM_LOG_DIRTY_PAGES flag was
> +set in KVM_SET_USER_MEMORY_REGION.  Once a memory region is registered
> +with the flag set, userspace can start harvesting dirty pages from the
> +ring buffer.
> +
> +To harvest the dirty pages, userspace accesses the mmaped ring buffer
> +to read the dirty GFNs up to avail_index, and sets the fetch_index
> +accordingly.  This can be done when the guest is running or paused,
> +and dirty pages need not be collected all at once.  After processing
> +one or more entries in the ring buffer, userspace calls the VM ioctl
> +KVM_RESET_DIRTY_RINGS to notify the kernel that it has updated
> +fetch_index and to mark those pages clean.  Therefore, the ioctl
> +must be called *before* reading the content of the dirty pages.

> +
> +However, there is a major difference comparing to the
> +KVM_GET_DIRTY_LOG interface in that when reading the dirty ring from
> +userspace it's still possible that the kernel has not yet flushed the
> +hardware dirty buffers into the kernel buffer.  To achieve that, one
> +needs to kick the vcpu out for a hardware buffer flush (vmexit).

When you refer to "buffers", are you referring to the cache lines that
contain the ring buffers, or to something else?

I'm a bit confused by this sentence. I think that you mean that a VCPU
may still be running while you read its ring buffer, in which case the
values in the ring buffer are not necessarily in memory yet, so not
visible to a different CPU. But I wonder if you can't make this
requirement to cause a vmexit unnecessary by carefully ordering the
writes, to make sure that the fetch_index is updated only after the
corresponding ring entries have been written to memory,

In other words, as seen by user-space, you would not care that the ring
entries have not been flushed as long as the fetch_index itself is
guaranteed to still be behind the not-flushed-yet entries.

(I would know how to do that on a different architecture, not sure for x86)

> +
> +If one of the ring buffers is full, the guest will exit to userspace
> +with the exit reason set to KVM_EXIT_DIRTY_LOG_FULL, and the
> +KVM_RUN ioctl will return -EINTR. Once that happens, userspace
> +should pause all the vcpus, then harvest all the dirty pages and
> +rearm the dirty traps. It can unpause the guest after that.

Except for the condition above, why is it necessary to pause other VCPUs
than the one being harvested?


> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b19ef421084d..0acee817adfb 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -5,7 +5,8 @@ ccflags-y += -Iarch/x86/kvm
>  KVM := ../../../virt/kvm
>
>  kvm-y			+= $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o \
> -				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o
> +				$(KVM)/eventfd.o $(KVM)/irqchip.o $(KVM)/vfio.o \
> +				$(KVM)/dirty_ring.o
>  kvm-$(CONFIG_KVM_ASYNC_PF)	+= $(KVM)/async_pf.o
>
>  kvm-y			+= x86.o emulate.o i8259.o irq.o lapic.o \
> diff --git a/include/linux/kvm_dirty_ring.h b/include/linux/kvm_dirty_ring.h
> new file mode 100644
> index 000000000000..8335635b7ff7
> --- /dev/null
> +++ b/include/linux/kvm_dirty_ring.h
> @@ -0,0 +1,67 @@
> +#ifndef KVM_DIRTY_RING_H
> +#define KVM_DIRTY_RING_H
> +
> +/*
> + * struct kvm_dirty_ring is defined in include/uapi/linux/kvm.h.
> + *
> + * dirty_ring:  shared with userspace via mmap. It is the compact list
> + *              that holds the dirty pages.
> + * dirty_index: free running counter that points to the next slot in
> + *              dirty_ring->dirty_gfns  where a new dirty page should go.
> + * reset_index: free running counter that points to the next dirty page
> + *              in dirty_ring->dirty_gfns for which dirty trap needs to
> + *              be reenabled
> + * size:        size of the compact list, dirty_ring->dirty_gfns
> + * soft_limit:  when the number of dirty pages in the list reaches this
> + *              limit, vcpu that owns this ring should exit to userspace
> + *              to allow userspace to harvest all the dirty pages
> + * lock:        protects dirty_ring, only in use if this is the global
> + *              ring

If that's not used for vcpu rings, maybe move it out of kvm_dirty_ring?

> + *
> + * The number of dirty pages in the ring is calculated by,
> + * dirty_index - reset_index

Nit: the code calls it "used" (in kvm_dirty_ring_used). Maybe find an
unambiguous terminology. What about "posted", as in

The number of posted dirty pages, i.e. the number of dirty pages in the
ring, is calculated as dirty_index - reset_index by function
kvm_dirty_ring_posted

(Replace "posted" by any adjective of your liking)

> + *
> + * kernel increments dirty_ring->indices.avail_index after dirty index
> + * is incremented. When userspace harvests the dirty pages, it increments
> + * dirty_ring->indices.fetch_index up to dirty_ring->indices.avail_index.
> + * When kernel reenables dirty traps for the dirty pages, it increments
> + * reset_index up to dirty_ring->indices.fetch_index.

Userspace should not be trusted to be doing this, see below.


> + *
> + */
> +struct kvm_dirty_ring {
> +	u32 dirty_index;
> +	u32 reset_index;
> +	u32 size;
> +	u32 soft_limit;
> +	spinlock_t lock;
> +	struct kvm_dirty_gfn *dirty_gfns;
> +};
> +
> +u32 kvm_dirty_ring_get_rsvd_entries(void);
> +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring);
> +
> +/*
> + * called with kvm->slots_lock held, returns the number of
> + * processed pages.
> + */
> +int kvm_dirty_ring_reset(struct kvm *kvm,
> +			 struct kvm_dirty_ring *ring,
> +			 struct kvm_dirty_ring_indexes *indexes);
> +
> +/*
> + * returns 0: successfully pushed
> + *         1: successfully pushed, soft limit reached,
> + *            vcpu should exit to userspace
> + *         -EBUSY: unable to push, dirty ring full.
> + */
> +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> +			struct kvm_dirty_ring_indexes *indexes,
> +			u32 slot, u64 offset, bool lock);
> +
> +/* for use in vm_operations_struct */
> +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i);

Not very clear what 'i' means, seems to be a page offset based on call sites?

> +
> +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring);
> +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring);
> +
> +#endif
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 498a39462ac1..7b747bc9ff3e 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -34,6 +34,7 @@
>  #include <linux/kvm_types.h>
>
>  #include <asm/kvm_host.h>
> +#include <linux/kvm_dirty_ring.h>
>
>  #ifndef KVM_MAX_VCPU_ID
>  #define KVM_MAX_VCPU_ID KVM_MAX_VCPUS
> @@ -146,6 +147,7 @@ static inline bool is_error_page(struct page *page)
>  #define KVM_REQ_MMU_RELOAD        (1 | KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
>  #define KVM_REQ_PENDING_TIMER     2
>  #define KVM_REQ_UNHALT            3
> +#define KVM_REQ_DIRTY_RING_FULL   4
>  #define KVM_REQUEST_ARCH_BASE     8
>
>  #define KVM_ARCH_REQ_FLAGS(nr, flags) ({ \
> @@ -321,6 +323,7 @@ struct kvm_vcpu {
>  	bool ready;
>  	struct kvm_vcpu_arch arch;
>  	struct dentry *debugfs_dentry;
> +	struct kvm_dirty_ring dirty_ring;
>  };
>
>  static inline int kvm_vcpu_exiting_guest_mode(struct kvm_vcpu *vcpu)
> @@ -501,6 +504,10 @@ struct kvm {
>  	struct srcu_struct srcu;
>  	struct srcu_struct irq_srcu;
>  	pid_t userspace_pid;
> +	/* Data structure to be exported by mmap(kvm->fd, 0) */
> +	struct kvm_vm_run *vm_run;
> +	u32 dirty_ring_size;
> +	struct kvm_dirty_ring vm_dirty_ring;

If you remove the lock from struct kvm_dirty_ring, you could just put it there.

>  };
>
>  #define kvm_err(fmt, ...) \
> @@ -832,6 +839,8 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>  					gfn_t gfn_offset,
>  					unsigned long mask);
>
> +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask);
> +
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm,
>  				struct kvm_dirty_log *log);
>  int kvm_vm_ioctl_clear_dirty_log(struct kvm *kvm,
> @@ -1411,4 +1420,28 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
>  				uintptr_t data, const char *name,
>  				struct task_struct **thread_ptr);
>
> +/*
> + * This defines how many reserved entries we want to keep before we
> + * kick the vcpu to the userspace to avoid dirty ring full.  This
> + * value can be tuned to higher if e.g. PML is enabled on the host.
> + */
> +#define  KVM_DIRTY_RING_RSVD_ENTRIES  64
> +
> +/* Max number of entries allowed for each kvm dirty ring */
> +#define  KVM_DIRTY_RING_MAX_ENTRIES  65536
> +
> +/*
> + * Arch needs to define these macro after implementing the dirty ring
> + * feature.  KVM_DIRTY_LOG_PAGE_OFFSET should be defined as the
> + * starting page offset of the dirty ring structures, while
> + * KVM_DIRTY_RING_VERSION should be defined as >=1.  By default, this
> + * feature is off on all archs.
> + */
> +#ifndef KVM_DIRTY_LOG_PAGE_OFFSET
> +#define KVM_DIRTY_LOG_PAGE_OFFSET 0
> +#endif
> +#ifndef KVM_DIRTY_RING_VERSION
> +#define KVM_DIRTY_RING_VERSION 0
> +#endif
> +
>  #endif
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index 1c88e69db3d9..d9d03eea145a 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -11,6 +11,7 @@ struct kvm_irq_routing_table;
>  struct kvm_memory_slot;
>  struct kvm_one_reg;
>  struct kvm_run;
> +struct kvm_vm_run;
>  struct kvm_userspace_memory_region;
>  struct kvm_vcpu;
>  struct kvm_vcpu_init;
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index e6f17c8e2dba..0b88d76d6215 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -236,6 +236,7 @@ struct kvm_hyperv_exit {
>  #define KVM_EXIT_IOAPIC_EOI       26
>  #define KVM_EXIT_HYPERV           27
>  #define KVM_EXIT_ARM_NISV         28
> +#define KVM_EXIT_DIRTY_RING_FULL  29
>
>  /* For KVM_EXIT_INTERNAL_ERROR */
>  /* Emulate instruction failed. */
> @@ -247,6 +248,11 @@ struct kvm_hyperv_exit {
>  /* Encounter unexpected vm-exit reason */
>  #define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
>
> +struct kvm_dirty_ring_indexes {
> +	__u32 avail_index; /* set by kernel */
> +	__u32 fetch_index; /* set by userspace */
> +};
> +
>  /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
>  struct kvm_run {
>  	/* in */
> @@ -421,6 +427,13 @@ struct kvm_run {
>  		struct kvm_sync_regs regs;
>  		char padding[SYNC_REGS_SIZE_BYTES];
>  	} s;
> +
> +	struct kvm_dirty_ring_indexes vcpu_ring_indexes;
> +};
> +
> +/* Returned by mmap(kvm->fd, offset=0) */
> +struct kvm_vm_run {
> +	struct kvm_dirty_ring_indexes vm_ring_indexes;
>  };
>
>  /* for KVM_REGISTER_COALESCED_MMIO / KVM_UNREGISTER_COALESCED_MMIO */
> @@ -1009,6 +1022,7 @@ struct kvm_ppc_resize_hpt {
>  #define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
>  #define KVM_CAP_ARM_NISV_TO_USER 177
>  #define KVM_CAP_ARM_INJECT_EXT_DABT 178
> +#define KVM_CAP_DIRTY_LOG_RING 179
>
>  #ifdef KVM_CAP_IRQ_ROUTING
>
> @@ -1472,6 +1486,9 @@ struct kvm_enc_region {
>  /* Available with KVM_CAP_ARM_SVE */
>  #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
>
> +/* Available with KVM_CAP_DIRTY_LOG_RING */
> +#define KVM_RESET_DIRTY_RINGS     _IO(KVMIO, 0xc3)
> +
>  /* Secure Encrypted Virtualization command */
>  enum sev_cmd_id {
>  	/* Guest initialization commands */
> @@ -1622,4 +1639,23 @@ struct kvm_hyperv_eventfd {
>  #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
>  #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
>
> +/*
> + * The following are the requirements for supporting dirty log ring
> + * (by enabling KVM_DIRTY_LOG_PAGE_OFFSET).
> + *
> + * 1. Memory accesses by KVM should call kvm_vcpu_write_* instead
> + *    of kvm_write_* so that the global dirty ring is not filled up
> + *    too quickly.
> + * 2. kvm_arch_mmu_enable_log_dirty_pt_masked should be defined for
> + *    enabling dirty logging.
> + * 3. There should not be a separate step to synchronize hardware
> + *    dirty bitmap with KVM's.
> + */
> +
> +struct kvm_dirty_gfn {
> +	__u32 pad;
> +	__u32 slot;
> +	__u64 offset;
> +};
> +
>  #endif /* __LINUX_KVM_H */
> diff --git a/virt/kvm/dirty_ring.c b/virt/kvm/dirty_ring.c
> new file mode 100644
> index 000000000000..9264891f3c32
> --- /dev/null
> +++ b/virt/kvm/dirty_ring.c
> @@ -0,0 +1,156 @@
> +#include <linux/kvm_host.h>
> +#include <linux/kvm.h>
> +#include <linux/vmalloc.h>
> +#include <linux/kvm_dirty_ring.h>
> +
> +u32 kvm_dirty_ring_get_rsvd_entries(void)
> +{
> +	return KVM_DIRTY_RING_RSVD_ENTRIES + kvm_cpu_dirty_log_size();
> +}
> +
> +int kvm_dirty_ring_alloc(struct kvm *kvm, struct kvm_dirty_ring *ring)
> +{
> +	u32 size = kvm->dirty_ring_size;
> +
> +	ring->dirty_gfns = vmalloc(size);
> +	if (!ring->dirty_gfns)
> +		return -ENOMEM;
> +	memset(ring->dirty_gfns, 0, size);
> +
> +	ring->size = size / sizeof(struct kvm_dirty_gfn);
> +	ring->soft_limit =
> +	    (kvm->dirty_ring_size / sizeof(struct kvm_dirty_gfn)) -
> +	    kvm_dirty_ring_get_rsvd_entries();

Minor, but what about

       ring->soft_limit = ring->size - kvm_dirty_ring_get_rsvd_entries();


> +	ring->dirty_index = 0;
> +	ring->reset_index = 0;
> +	spin_lock_init(&ring->lock);
> +
> +	return 0;
> +}
> +
> +int kvm_dirty_ring_reset(struct kvm *kvm,
> +			 struct kvm_dirty_ring *ring,
> +			 struct kvm_dirty_ring_indexes *indexes)
> +{
> +	u32 cur_slot, next_slot;
> +	u64 cur_offset, next_offset;
> +	unsigned long mask;
> +	u32 fetch;
> +	int count = 0;
> +	struct kvm_dirty_gfn *entry;
> +
> +	fetch = READ_ONCE(indexes->fetch_index);

If I understand correctly, if a malicious user-space writes
ring->reset_index + 1 into fetch_index, the loop below will execute 4
billion times.


> +	if (fetch == ring->reset_index)
> +		return 0;

To protect against scenario above, I would have something like:

	if (fetch - ring->reset_index >= ring->size)
		return -EINVAL;

> +
> +	entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> +	/*
> +	 * The ring buffer is shared with userspace, which might mmap
> +	 * it and concurrently modify slot and offset.  Userspace must
> +	 * not be trusted!  READ_ONCE prevents the compiler from changing
> +	 * the values after they've been range-checked (the checks are
> +	 * in kvm_reset_dirty_gfn).
> +	 */
> +	smp_read_barrier_depends();
> +	cur_slot = READ_ONCE(entry->slot);
> +	cur_offset = READ_ONCE(entry->offset);
> +	mask = 1;
> +	count++;
> +	ring->reset_index++;
> +	while (ring->reset_index != fetch) {
> +		entry = &ring->dirty_gfns[ring->reset_index & (ring->size - 1)];
> +		smp_read_barrier_depends();
> +		next_slot = READ_ONCE(entry->slot);
> +		next_offset = READ_ONCE(entry->offset);
> +		ring->reset_index++;
> +		count++;
> +		/*
> +		 * Try to coalesce the reset operations when the guest is
> +		 * scanning pages in the same slot.
> +		 */
> +		if (next_slot == cur_slot) {
> +			int delta = next_offset - cur_offset;

Since you diff two u64, shouldn't that be an i64 rather than int?

> +
> +			if (delta >= 0 && delta < BITS_PER_LONG) {
> +				mask |= 1ull << delta;
> +				continue;
> +			}
> +
> +			/* Backwards visit, careful about overflows!  */
> +			if (delta > -BITS_PER_LONG && delta < 0 &&
> +			    (mask << -delta >> -delta) == mask) {
> +				cur_offset = next_offset;
> +				mask = (mask << -delta) | 1;
> +				continue;
> +			}
> +		}
> +		kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);
> +		cur_slot = next_slot;
> +		cur_offset = next_offset;
> +		mask = 1;
> +	}
> +	kvm_reset_dirty_gfn(kvm, cur_slot, cur_offset, mask);

So if you did not coalesce the last one, you call kvm_reset_dirty_gfn
twice? Something smells weird about this loop ;-) I have a gut feeling
that it could be done in a single while loop combined with the entry
test, but I may be wrong.


> +
> +	return count;
> +}
> +
> +static inline u32 kvm_dirty_ring_used(struct kvm_dirty_ring *ring)
> +{
> +	return ring->dirty_index - ring->reset_index;
> +}
> +
> +bool kvm_dirty_ring_full(struct kvm_dirty_ring *ring)
> +{
> +	return kvm_dirty_ring_used(ring) >= ring->size;
> +}
> +
> +/*
> + * Returns:
> + *   >0 if we should kick the vcpu out,
> + *   =0 if the gfn pushed successfully, or,
> + *   <0 if error (e.g. ring full)
> + */
> +int kvm_dirty_ring_push(struct kvm_dirty_ring *ring,
> +			struct kvm_dirty_ring_indexes *indexes,
> +			u32 slot, u64 offset, bool lock)

Obviously, if you go with the suggestion to have a "lock" only in struct
kvm, then you'd have to pass a lock ptr instead of a bool.

> +{
> +	int ret;
> +	struct kvm_dirty_gfn *entry;
> +
> +	if (lock)
> +		spin_lock(&ring->lock);
> +
> +	if (kvm_dirty_ring_full(ring)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	entry = &ring->dirty_gfns[ring->dirty_index & (ring->size - 1)];
> +	entry->slot = slot;
> +	entry->offset = offset;
> +	smp_wmb();
> +	ring->dirty_index++;
> +	WRITE_ONCE(indexes->avail_index, ring->dirty_index);

Following up on comment about having to vmexit other VCPUs above:
If you have a write barrier for the entry, and then a write once for the
index, isn't that sufficient to ensure that another CPU will pick up the
right values in the right order?


> +	ret = kvm_dirty_ring_used(ring) >= ring->soft_limit;
> +	pr_info("%s: slot %u offset %llu used %u\n",
> +		__func__, slot, offset, kvm_dirty_ring_used(ring));
> +
> +out:
> +	if (lock)
> +		spin_unlock(&ring->lock);
> +
> +	return ret;
> +}
> +
> +struct page *kvm_dirty_ring_get_page(struct kvm_dirty_ring *ring, u32 i)

Still don't like 'i' :-)


(Stopped my review here for lack of time, decided to share what I had so far)

> +{
> +	return vmalloc_to_page((void *)ring->dirty_gfns + i * PAGE_SIZE);
> +}
> +
> +void kvm_dirty_ring_free(struct kvm_dirty_ring *ring)
> +{
> +	if (ring->dirty_gfns) {
> +		vfree(ring->dirty_gfns);
> +		ring->dirty_gfns = NULL;
> +	}
> +}
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 681452d288cd..8642c977629b 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -64,6 +64,8 @@
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/kvm.h>
>
> +#include <linux/kvm_dirty_ring.h>
> +
>  /* Worst case buffer size needed for holding an integer. */
>  #define ITOA_MAX_LEN 12
>
> @@ -149,6 +151,10 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
>  				    struct kvm_vcpu *vcpu,
>  				    struct kvm_memory_slot *memslot,
>  				    gfn_t gfn);
> +static void mark_page_dirty_in_ring(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_slot *slot,
> +				    gfn_t gfn);
>
>  __visible bool kvm_rebooting;
>  EXPORT_SYMBOL_GPL(kvm_rebooting);
> @@ -359,11 +365,22 @@ int kvm_vcpu_init(struct kvm_vcpu *vcpu, struct kvm *kvm, unsigned id)
>  	vcpu->preempted = false;
>  	vcpu->ready = false;
>
> +	if (kvm->dirty_ring_size) {
> +		r = kvm_dirty_ring_alloc(vcpu->kvm, &vcpu->dirty_ring);
> +		if (r) {
> +			kvm->dirty_ring_size = 0;
> +			goto fail_free_run;
> +		}
> +	}
> +
>  	r = kvm_arch_vcpu_init(vcpu);
>  	if (r < 0)
> -		goto fail_free_run;
> +		goto fail_free_ring;
>  	return 0;
>
> +fail_free_ring:
> +	if (kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  fail_free_run:
>  	free_page((unsigned long)vcpu->run);
>  fail:
> @@ -381,6 +398,8 @@ void kvm_vcpu_uninit(struct kvm_vcpu *vcpu)
>  	put_pid(rcu_dereference_protected(vcpu->pid, 1));
>  	kvm_arch_vcpu_uninit(vcpu);
>  	free_page((unsigned long)vcpu->run);
> +	if (vcpu->kvm->dirty_ring_size)
> +		kvm_dirty_ring_free(&vcpu->dirty_ring);
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_uninit);
>
> @@ -690,6 +709,7 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  	struct kvm *kvm = kvm_arch_alloc_vm();
>  	int r = -ENOMEM;
>  	int i;
> +	struct page *page;
>
>  	if (!kvm)
>  		return ERR_PTR(-ENOMEM);
> @@ -705,6 +725,14 @@ static struct kvm *kvm_create_vm(unsigned long type)
>
>  	BUILD_BUG_ON(KVM_MEM_SLOTS_NUM > SHRT_MAX);
>
> +	page = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!page) {
> +		r = -ENOMEM;
> +		goto out_err_alloc_page;
> +	}
> +	kvm->vm_run = page_address(page);
> +	BUILD_BUG_ON(sizeof(struct kvm_vm_run) > PAGE_SIZE);
> +
>  	if (init_srcu_struct(&kvm->srcu))
>  		goto out_err_no_srcu;
>  	if (init_srcu_struct(&kvm->irq_srcu))
> @@ -775,6 +803,9 @@ static struct kvm *kvm_create_vm(unsigned long type)
>  out_err_no_irq_srcu:
>  	cleanup_srcu_struct(&kvm->srcu);
>  out_err_no_srcu:
> +	free_page((unsigned long)page);
> +	kvm->vm_run = NULL;
> +out_err_alloc_page:
>  	kvm_arch_free_vm(kvm);
>  	mmdrop(current->mm);
>  	return ERR_PTR(r);
> @@ -800,6 +831,15 @@ static void kvm_destroy_vm(struct kvm *kvm)
>  	int i;
>  	struct mm_struct *mm = kvm->mm;
>
> +	if (kvm->dirty_ring_size) {
> +		kvm_dirty_ring_free(&kvm->vm_dirty_ring);
> +	}
> +
> +	if (kvm->vm_run) {
> +		free_page((unsigned long)kvm->vm_run);
> +		kvm->vm_run = NULL;
> +	}
> +
>  	kvm_uevent_notify_change(KVM_EVENT_DESTROY_VM, kvm);
>  	kvm_destroy_vm_debugfs(kvm);
>  	kvm_arch_sync_events(kvm);
> @@ -2301,7 +2341,7 @@ static void mark_page_dirty_in_slot(struct kvm *kvm,
>  {
>  	if (memslot && memslot->dirty_bitmap) {
>  		unsigned long rel_gfn = gfn - memslot->base_gfn;
> -
> +		mark_page_dirty_in_ring(kvm, vcpu, memslot, gfn);
>  		set_bit_le(rel_gfn, memslot->dirty_bitmap);
>  	}
>  }
> @@ -2649,6 +2689,13 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *me, bool yield_to_kernel_mode)
>  }
>  EXPORT_SYMBOL_GPL(kvm_vcpu_on_spin);
>
> +static bool kvm_fault_in_dirty_ring(struct kvm *kvm, struct vm_fault *vmf)
> +{
> +	return (vmf->pgoff >= KVM_DIRTY_LOG_PAGE_OFFSET) &&
> +	    (vmf->pgoff < KVM_DIRTY_LOG_PAGE_OFFSET +
> +	     kvm->dirty_ring_size / PAGE_SIZE);
> +}
> +
>  static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>  {
>  	struct kvm_vcpu *vcpu = vmf->vma->vm_file->private_data;
> @@ -2664,6 +2711,10 @@ static vm_fault_t kvm_vcpu_fault(struct vm_fault *vmf)
>  	else if (vmf->pgoff == KVM_COALESCED_MMIO_PAGE_OFFSET)
>  		page = virt_to_page(vcpu->kvm->coalesced_mmio_ring);
>  #endif
> +	else if (kvm_fault_in_dirty_ring(vcpu->kvm, vmf))
> +		page = kvm_dirty_ring_get_page(
> +		    &vcpu->dirty_ring,
> +		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
>  	else
>  		return kvm_arch_vcpu_fault(vcpu, vmf);
>  	get_page(page);
> @@ -3259,12 +3310,162 @@ static long kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
>  #endif
>  	case KVM_CAP_NR_MEMSLOTS:
>  		return KVM_USER_MEM_SLOTS;
> +	case KVM_CAP_DIRTY_LOG_RING:
> +		/* Version will be zero if arch didn't implement it */
> +		return KVM_DIRTY_RING_VERSION;
>  	default:
>  		break;
>  	}
>  	return kvm_vm_ioctl_check_extension(kvm, arg);
>  }
>
> +static void mark_page_dirty_in_ring(struct kvm *kvm,
> +				    struct kvm_vcpu *vcpu,
> +				    struct kvm_memory_slot *slot,
> +				    gfn_t gfn)
> +{
> +	u32 as_id = 0;
> +	u64 offset;
> +	int ret;
> +	struct kvm_dirty_ring *ring;
> +	struct kvm_dirty_ring_indexes *indexes;
> +	bool is_vm_ring;
> +
> +	if (!kvm->dirty_ring_size)
> +		return;
> +
> +	offset = gfn - slot->base_gfn;
> +
> +	if (vcpu) {
> +		as_id = kvm_arch_vcpu_memslots_id(vcpu);
> +	} else {
> +		as_id = 0;
> +		vcpu = kvm_get_running_vcpu();
> +	}
> +
> +	if (vcpu) {
> +		ring = &vcpu->dirty_ring;
> +		indexes = &vcpu->run->vcpu_ring_indexes;
> +		is_vm_ring = false;
> +	} else {
> +		/*
> +		 * Put onto per vm ring because no vcpu context.  Kick
> +		 * vcpu0 if ring is full.
> +		 */
> +		vcpu = kvm->vcpus[0];
> +		ring = &kvm->vm_dirty_ring;
> +		indexes = &kvm->vm_run->vm_ring_indexes;
> +		is_vm_ring = true;
> +	}
> +
> +	ret = kvm_dirty_ring_push(ring, indexes,
> +				  (as_id << 16)|slot->id, offset,
> +				  is_vm_ring);
> +	if (ret < 0) {
> +		if (is_vm_ring)
> +			pr_warn_once("vcpu %d dirty log overflow\n",
> +				     vcpu->vcpu_id);
> +		else
> +			pr_warn_once("per-vm dirty log overflow\n");
> +		return;
> +	}
> +
> +	if (ret)
> +		kvm_make_request(KVM_REQ_DIRTY_RING_FULL, vcpu);
> +}
> +
> +void kvm_reset_dirty_gfn(struct kvm *kvm, u32 slot, u64 offset, u64 mask)
> +{
> +	struct kvm_memory_slot *memslot;
> +	int as_id, id;
> +
> +	as_id = slot >> 16;
> +	id = (u16)slot;
> +	if (as_id >= KVM_ADDRESS_SPACE_NUM || id >= KVM_USER_MEM_SLOTS)
> +		return;
> +
> +	memslot = id_to_memslot(__kvm_memslots(kvm, as_id), id);
> +	if (offset >= memslot->npages)
> +		return;
> +
> +	spin_lock(&kvm->mmu_lock);
> +	/* FIXME: we should use a single AND operation, but there is no
> +	 * applicable atomic API.
> +	 */
> +	while (mask) {
> +		clear_bit_le(offset + __ffs(mask), memslot->dirty_bitmap);
> +		mask &= mask - 1;
> +	}
> +
> +	kvm_arch_mmu_enable_log_dirty_pt_masked(kvm, memslot, offset, mask);
> +	spin_unlock(&kvm->mmu_lock);
> +}
> +
> +static int kvm_vm_ioctl_enable_dirty_log_ring(struct kvm *kvm, u32 size)
> +{
> +	int r;
> +
> +	/* the size should be power of 2 */
> +	if (!size || (size & (size - 1)))
> +		return -EINVAL;
> +
> +	/* Should be bigger to keep the reserved entries, or a page */
> +	if (size < kvm_dirty_ring_get_rsvd_entries() *
> +	    sizeof(struct kvm_dirty_gfn) || size < PAGE_SIZE)
> +		return -EINVAL;
> +
> +	if (size > KVM_DIRTY_RING_MAX_ENTRIES *
> +	    sizeof(struct kvm_dirty_gfn))
> +		return -E2BIG;
> +
> +	/* We only allow it to set once */
> +	if (kvm->dirty_ring_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->lock);
> +
> +	if (kvm->created_vcpus) {
> +		/* We don't allow to change this value after vcpu created */
> +		r = -EINVAL;
> +	} else {
> +		kvm->dirty_ring_size = size;
> +		r = kvm_dirty_ring_alloc(kvm, &kvm->vm_dirty_ring);
> +		if (r) {
> +			/* Unset dirty ring */
> +			kvm->dirty_ring_size = 0;
> +		}
> +	}
> +
> +	mutex_unlock(&kvm->lock);
> +	return r;
> +}
> +
> +static int kvm_vm_ioctl_reset_dirty_pages(struct kvm *kvm)
> +{
> +	int i;
> +	struct kvm_vcpu *vcpu;
> +	int cleared = 0;
> +
> +	if (!kvm->dirty_ring_size)
> +		return -EINVAL;
> +
> +	mutex_lock(&kvm->slots_lock);
> +
> +	cleared += kvm_dirty_ring_reset(kvm, &kvm->vm_dirty_ring,
> +					&kvm->vm_run->vm_ring_indexes);
> +
> +	kvm_for_each_vcpu(i, vcpu, kvm)
> +		cleared += kvm_dirty_ring_reset(vcpu->kvm, &vcpu->dirty_ring,
> +						&vcpu->run->vcpu_ring_indexes);
> +
> +	mutex_unlock(&kvm->slots_lock);
> +
> +	if (cleared)
> +		kvm_flush_remote_tlbs(kvm);
> +
> +	return cleared;
> +}
> +
>  int __attribute__((weak)) kvm_vm_ioctl_enable_cap(struct kvm *kvm,
>  						  struct kvm_enable_cap *cap)
>  {
> @@ -3282,6 +3483,8 @@ static int kvm_vm_ioctl_enable_cap_generic(struct kvm *kvm,
>  		kvm->manual_dirty_log_protect = cap->args[0];
>  		return 0;
>  #endif
> +	case KVM_CAP_DIRTY_LOG_RING:
> +		return kvm_vm_ioctl_enable_dirty_log_ring(kvm, cap->args[0]);
>  	default:
>  		return kvm_vm_ioctl_enable_cap(kvm, cap);
>  	}
> @@ -3469,6 +3672,9 @@ static long kvm_vm_ioctl(struct file *filp,
>  	case KVM_CHECK_EXTENSION:
>  		r = kvm_vm_ioctl_check_extension_generic(kvm, arg);
>  		break;
> +	case KVM_RESET_DIRTY_RINGS:
> +		r = kvm_vm_ioctl_reset_dirty_pages(kvm);
> +		break;
>  	default:
>  		r = kvm_arch_vm_ioctl(filp, ioctl, arg);
>  	}
> @@ -3517,9 +3723,39 @@ static long kvm_vm_compat_ioctl(struct file *filp,
>  }
>  #endif
>
> +static vm_fault_t kvm_vm_fault(struct vm_fault *vmf)
> +{
> +	struct kvm *kvm = vmf->vma->vm_file->private_data;
> +	struct page *page = NULL;
> +
> +	if (vmf->pgoff == 0)
> +		page = virt_to_page(kvm->vm_run);
> +	else if (kvm_fault_in_dirty_ring(kvm, vmf))
> +		page = kvm_dirty_ring_get_page(
> +		    &kvm->vm_dirty_ring,
> +		    vmf->pgoff - KVM_DIRTY_LOG_PAGE_OFFSET);
> +	else
> +		return VM_FAULT_SIGBUS;
> +
> +	get_page(page);
> +	vmf->page = page;
> +	return 0;
> +}
> +
> +static const struct vm_operations_struct kvm_vm_vm_ops = {
> +	.fault = kvm_vm_fault,
> +};
> +
> +static int kvm_vm_mmap(struct file *file, struct vm_area_struct *vma)
> +{
> +	vma->vm_ops = &kvm_vm_vm_ops;
> +	return 0;
> +}
> +
>  static struct file_operations kvm_vm_fops = {
>  	.release        = kvm_vm_release,
>  	.unlocked_ioctl = kvm_vm_ioctl,
> +	.mmap           = kvm_vm_mmap,
>  	.llseek		= noop_llseek,
>  	KVM_COMPAT(kvm_vm_compat_ioctl),
>  };


--
Cheers,
Christophe de Dinechin (IRC c3d)
