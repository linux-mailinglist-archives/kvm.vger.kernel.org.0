Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2B4716EAD5
	for <lists+kvm@lfdr.de>; Tue, 25 Feb 2020 17:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730488AbgBYQIJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 25 Feb 2020 11:08:09 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31053 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729206AbgBYQII (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 25 Feb 2020 11:08:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582646884;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=S1sTbrSC99W9QZbff7ApRObolVgQzVVyNEhNkuV+XxY=;
        b=KcIwV9ZsJ/rp+c0HHHEqk/aQHWzv2L/j4923F0TXSu1Qy2XZAd4Csvwg9q078UDIRVos9K
        M1MPwkt+GjNjNW+hYEnfsIl3R9EYvWrcTUbku0Sl9hgfr6DtX8X7mtmQ0YxgwEEUPLndN5
        uYDjlJBzJdesBMEDoc/WcqQ+CTC5z2A=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-212-CKF6umLwPWya4NhPB52Pnw-1; Tue, 25 Feb 2020 11:08:02 -0500
X-MC-Unique: CKF6umLwPWya4NhPB52Pnw-1
Received: by mail-qv1-f69.google.com with SMTP id p3so13391301qvt.9
        for <kvm@vger.kernel.org>; Tue, 25 Feb 2020 08:08:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S1sTbrSC99W9QZbff7ApRObolVgQzVVyNEhNkuV+XxY=;
        b=E2oKoNez0plzpFKzYzxYBkhdsIe0lefunIs6l0tfTwFYfKktCqlX26cRszBhjzb0CE
         5Lu5TUhrBPDajoLhICxtSOBRzDrOTaWChCBb+UIPREPuJMb6B20db1BB0M3zeERQRg1F
         NXVwMEV8kNxji/l8yi6fvTx6qcpqNcLRwzLNTpSeTrePBli5Uaf7TxJSpp1jWGBQTA8A
         FhwCArOGGx5ddbpc9o9AtAkR3LNxsZ2RY5e2M11H7oUDJYcyuIot6+3CRhoF1Bl2Gvms
         y6vonlwhF+C8o4LGBfqoLQWxkWWaP9CDOKauBpdL6198qJhP/VG/o1S/AvPYtycC5Ac4
         XDDA==
X-Gm-Message-State: APjAAAU8xnc5CO8TOHY2yb2bBHZtp84w8BoYC+6ULuDlqYAbimySwO7i
        mWEnphkuvUXpC+vcCwhAVQBaDR9qDejTr0z+sXgG3cDNbUcHXcVI8YlkmU5wyAO4EonavGh0xXV
        erQnAwJClpHB7
X-Received: by 2002:a05:6214:927:: with SMTP id dk7mr51899552qvb.200.1582646881334;
        Tue, 25 Feb 2020 08:08:01 -0800 (PST)
X-Google-Smtp-Source: APXvYqyURLtAF828B3zXahN6X77yqBRAqGG2OeA9Yq3Dqoq3Dikm6rAnqPF9mIi0oXl9CF1YGU5ffQ==
X-Received: by 2002:a05:6214:927:: with SMTP id dk7mr51899512qvb.200.1582646880930;
        Tue, 25 Feb 2020 08:08:00 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id h193sm2051301qke.17.2020.02.25.08.07.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:07:59 -0800 (PST)
Date:   Tue, 25 Feb 2020 11:07:58 -0500
From:   Peter Xu <peterx@redhat.com>
To:     "Zhoujian (jay)" <jianjay.zhou@huawei.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "wangxin (U)" <wangxinxin.wang@huawei.com>,
        "Huangweidong (C)" <weidong.huang@huawei.com>,
        "Liujinsong (Paul)" <liu.jinsong@huawei.com>
Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
Message-ID: <20200225160758.GB127720@xz-x1>
References: <20200224032558.2728-1-jianjay.zhou@huawei.com>
 <20200224170538.GH37727@xz-x1>
 <B2D15215269B544CADD246097EACE7474BB1B778@dggemm508-mbx.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <B2D15215269B544CADD246097EACE7474BB1B778@dggemm508-mbx.china.huawei.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 25, 2020 at 03:15:37AM +0000, Zhoujian (jay) wrote:
> 
> 
> > -----Original Message-----
> > From: Peter Xu [mailto:peterx@redhat.com]
> > Sent: Tuesday, February 25, 2020 1:06 AM
> > To: Zhoujian (jay) <jianjay.zhou@huawei.com>
> > Cc: kvm@vger.kernel.org; pbonzini@redhat.com;
> > sean.j.christopherson@intel.com; wangxin (U) <wangxinxin.wang@huawei.com>;
> > Huangweidong (C) <weidong.huang@huawei.com>; Liujinsong (Paul)
> > <liu.jinsong@huawei.com>
> > Subject: Re: [PATCH v3] KVM: x86: enable dirty log gradually in small chunks
> > 
> > On Mon, Feb 24, 2020 at 11:25:58AM +0800, Jay Zhou wrote:
> > > It could take kvm->mmu_lock for an extended period of time when
> > > enabling dirty log for the first time. The main cost is to clear all
> > > the D-bits of last level SPTEs. This situation can benefit from manual
> > > dirty log protect as well, which can reduce the mmu_lock time taken.
> > > The sequence is like this:
> > >
> > > 1. Initialize all the bits of the dirty bitmap to 1 when enabling
> > >    dirty log for the first time
> > > 2. Only write protect the huge pages
> > > 3. KVM_GET_DIRTY_LOG returns the dirty bitmap info 4.
> > > KVM_CLEAR_DIRTY_LOG will clear D-bit for each of the leaf level
> > >    SPTEs gradually in small chunks
> > >
> > > Under the Intel(R) Xeon(R) Gold 6152 CPU @ 2.10GHz environment, I did
> > > some tests with a 128G windows VM and counted the time taken of
> > > memory_global_dirty_log_start, here is the numbers:
> > >
> > > VM Size        Before    After optimization
> > > 128G           460ms     10ms
> > >
> > > Signed-off-by: Jay Zhou <jianjay.zhou@huawei.com>
> > > ---
> > > v3:
> > >   * add kvm_manual_dirty_log_init_set helper, add testcase on top and
> > >     keep old behavior for KVM_MEM_READONLY [Peter]
> > >   * tweak logic at enabling KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2
> > [Sean,
> > > Peter]
> > >
> > > v2:
> > >   * add new bit to KVM_ENABLE_CAP for
> > KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2 [Paolo]
> > >   * support non-PML path [Peter]
> > >   * delete the unnecessary ifdef and make the initialization of bitmap
> > >     more clear [Sean]
> > >   * document the new bits and tweak the testcase
> > >
> > >  Documentation/virt/kvm/api.rst  | 16 +++++++++++++---
> > > arch/x86/include/asm/kvm_host.h |  3 ++-
> > >  arch/x86/kvm/mmu/mmu.c          |  7 ++++---
> > >  arch/x86/kvm/vmx/vmx.c          |  3 ++-
> > >  arch/x86/kvm/x86.c              | 18 +++++++++++++++---
> > >  include/linux/kvm_host.h        |  9 ++++++++-
> > >  virt/kvm/kvm_main.c             | 30 +++++++++++++++++++++++-------
> > >  7 files changed, 67 insertions(+), 19 deletions(-)
> > >
> > > diff --git a/Documentation/virt/kvm/api.rst
> > > b/Documentation/virt/kvm/api.rst index 97a72a5..807fcd7 100644
> > > --- a/Documentation/virt/kvm/api.rst
> > > +++ b/Documentation/virt/kvm/api.rst
> > > @@ -5704,10 +5704,20 @@ and injected exceptions.
> > >  :Architectures: x86, arm, arm64, mips
> > >  :Parameters: args[0] whether feature should be enabled or not
> > >
> > > -With this capability enabled, KVM_GET_DIRTY_LOG will not
> > > automatically -clear and write-protect all pages that are returned as dirty.
> > > +Valid flags are::
> > > +
> > > +  #define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0)  #define
> > > + KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
> > 
> > I think I mis-read previously on the old version so my comment was misleading.
> > If this is the sub-capability within KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2,
> > then I don't think we need to have the ending "2" any more.  How about:
> 
> It's OK, :-)
> 
> > 
> >   KVM_MANUAL_PROTECT_ENABLE
> >   KVM_MANUAL_PROTECT_INIT_ALL_SET
> 
> I think this naming emphasizes more about "manual protect", and the
> original naming emphasizes more about "dirty log". The object of manual protect
> and initial-all-set is dirty log, so it seem that the original names are a little more
> close to the thing we do.

OK.  Then maybe rename bit 0 of KVM_DIRTY_LOG_MANUAL_PROTECT2 to
KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE?  No strong opinion but it looks
weird to have the ending "2" in the sub-caps..

> 
> > > +
> > > +With KVM_DIRTY_LOG_MANUAL_PROTECT2 set, KVM_GET_DIRTY_LOG will
> > not
> > > +automatically clear and write-protect all pages that are returned as dirty.
> > >  Rather, userspace will have to do this operation separately using
> > > KVM_CLEAR_DIRTY_LOG.
> > > +With KVM_DIRTY_LOG_INITIALLY_SET set, all the bits of the dirty
> > > +bitmap will be initialized to 1 when created, dirty logging will be
> > > +enabled gradually in small chunks using KVM_CLEAR_DIRTY_LOG.
> > > +However, the KVM_DIRTY_LOG_INITIALLY_SET depends on
> > > +KVM_DIRTY_LOG_MANUAL_PROTECT2, it can not be set individually and
> > supports x86 only for now.
> > >
> > >  At the cost of a slightly more complicated operation, this provides
> > > better  scalability and responsiveness for two reasons.  First, @@
> > > -5716,7 +5726,7 @@ than requiring to sync a full memslot; this ensures
> > > that KVM does not  take spinlocks for an extended period of time.
> > > Second, in some cases a  large amount of time can pass between a call
> > > to KVM_GET_DIRTY_LOG and  userspace actually using the data in the
> > > page.  Pages can be modified -during this time, which is inefficint for both the
> > guest and userspace:
> > > +during this time, which is inefficient for both the guest and userspace:
> > >  the guest will incur a higher penalty due to write protection faults,
> > > while userspace can see false reports of dirty pages.  Manual
> > > reprotection  helps reducing this time, improving guest performance
> > > and reducing the diff --git a/arch/x86/include/asm/kvm_host.h
> > > b/arch/x86/include/asm/kvm_host.h index 40a0c0f..a90630c 100644
> > > --- a/arch/x86/include/asm/kvm_host.h
> > > +++ b/arch/x86/include/asm/kvm_host.h
> > > @@ -1312,7 +1312,8 @@ void kvm_mmu_set_mask_ptes(u64 user_mask, u64
> > > accessed_mask,
> > >
> > >  void kvm_mmu_reset_context(struct kvm_vcpu *vcpu);  void
> > > kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > > -				      struct kvm_memory_slot *memslot);
> > > +				      struct kvm_memory_slot *memslot,
> > > +				      int start_level);
> > >  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> > >  				   const struct kvm_memory_slot *memslot);  void
> > > kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm, diff --git
> > > a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c index
> > > 87e9ba2..a4e70eb 100644
> > > --- a/arch/x86/kvm/mmu/mmu.c
> > > +++ b/arch/x86/kvm/mmu/mmu.c
> > > @@ -5860,13 +5860,14 @@ static bool slot_rmap_write_protect(struct kvm
> > > *kvm,  }
> > >
> > >  void kvm_mmu_slot_remove_write_access(struct kvm *kvm,
> > > -				      struct kvm_memory_slot *memslot)
> > > +				      struct kvm_memory_slot *memslot,
> > > +				      int start_level)
> > >  {
> > >  	bool flush;
> > >
> > >  	spin_lock(&kvm->mmu_lock);
> > > -	flush = slot_handle_all_level(kvm, memslot, slot_rmap_write_protect,
> > > -				      false);
> > > +	flush = slot_handle_level(kvm, memslot, slot_rmap_write_protect,
> > > +				start_level, PT_MAX_HUGEPAGE_LEVEL, false);
> > >  	spin_unlock(&kvm->mmu_lock);
> > >
> > >  	/*
> > > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c index
> > > 3be25ec..0deb8c3 100644
> > > --- a/arch/x86/kvm/vmx/vmx.c
> > > +++ b/arch/x86/kvm/vmx/vmx.c
> > > @@ -7201,7 +7201,8 @@ static void vmx_sched_in(struct kvm_vcpu *vcpu,
> > > int cpu)  static void vmx_slot_enable_log_dirty(struct kvm *kvm,
> > >  				     struct kvm_memory_slot *slot)  {
> > > -	kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > > +	if (!kvm_manual_dirty_log_init_set(kvm))
> > > +		kvm_mmu_slot_leaf_clear_dirty(kvm, slot);
> > >  	kvm_mmu_slot_largepage_remove_write_access(kvm, slot);  }
> > >
> > > diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index
> > > fb5d64e..f816940 100644
> > > --- a/arch/x86/kvm/x86.c
> > > +++ b/arch/x86/kvm/x86.c
> > > @@ -9956,7 +9956,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm
> > > *kvm,  {
> > >  	/* Still write protect RO slot */
> > >  	if (new->flags & KVM_MEM_READONLY) {
> > > -		kvm_mmu_slot_remove_write_access(kvm, new);
> > > +		kvm_mmu_slot_remove_write_access(kvm, new,
> > PT_PAGE_TABLE_LEVEL);
> > >  		return;
> > >  	}
> > >
> > > @@ -9993,8 +9993,20 @@ static void kvm_mmu_slot_apply_flags(struct kvm
> > *kvm,
> > >  	if (new->flags & KVM_MEM_LOG_DIRTY_PAGES) {
> > >  		if (kvm_x86_ops->slot_enable_log_dirty)
> > >  			kvm_x86_ops->slot_enable_log_dirty(kvm, new);
> > > -		else
> > > -			kvm_mmu_slot_remove_write_access(kvm, new);
> > > +		else {
> > > +			int level = kvm_manual_dirty_log_init_set(kvm) ?
> > > +				PT_DIRECTORY_LEVEL : PT_PAGE_TABLE_LEVEL;
> > > +
> > > +			/*
> > > +			 * If we're with initial-all-set, we don't need
> > > +			 * to write protect any small page because
> > > +			 * they're reported as dirty already.  However
> > > +			 * we still need to write-protect huge pages
> > > +			 * so that the page split can happen lazily on
> > > +			 * the first write to the huge page.
> > > +			 */
> > > +			kvm_mmu_slot_remove_write_access(kvm, new, level);
> > > +		}
> > >  	} else {
> > >  		if (kvm_x86_ops->slot_disable_log_dirty)
> > >  			kvm_x86_ops->slot_disable_log_dirty(kvm, new); diff --git
> > > a/include/linux/kvm_host.h b/include/linux/kvm_host.h index
> > > e89eb67..80ada94 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -360,6 +360,13 @@ static inline unsigned long
> > *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
> > >  	return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
> > > }
> > >
> > > +#define KVM_DIRTY_LOG_MANUAL_PROTECT2 (1 << 0) #define
> > > +KVM_DIRTY_LOG_INITIALLY_SET (1 << 1) #define
> > > +KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT2 |
> > \
> > > +				KVM_DIRTY_LOG_INITIALLY_SET)
> > > +
> > > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm);
> > > +
> > >  struct kvm_s390_adapter_int {
> > >  	u64 ind_addr;
> > >  	u64 summary_addr;
> > > @@ -493,7 +500,7 @@ struct kvm {
> > >  #endif
> > >  	long tlbs_dirty;
> > >  	struct list_head devices;
> > > -	bool manual_dirty_log_protect;
> > > +	u64 manual_dirty_log_protect;
> > >  	struct dentry *debugfs_dentry;
> > >  	struct kvm_stat_data **debugfs_stat_data;
> > >  	struct srcu_struct srcu;
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c index
> > > 70f03ce..0ffb804 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -858,11 +858,17 @@ static int kvm_vm_release(struct inode *inode,
> > struct file *filp)
> > >  	return 0;
> > >  }
> > >
> > > +bool kvm_manual_dirty_log_init_set(struct kvm *kvm) {
> > > +	return kvm->manual_dirty_log_protect & KVM_DIRTY_LOG_INITIALLY_SET;
> > > +}
> > 
> > Nit: this can be put into kvm_host.h as inlined.
> 
> I'm afraid not. I tried to do it, but it can't be compiled through. Since this
> function is shared between the kvm and kvm_intel(vmx part) module, it should be
> exported.

What's the error?  Did you add it into the right kvm_host.h (which is
./include/linux/kvm_host.h, not per-arch one), and was it with "static
inline"?

> 
> BTW: how about using kvm_dirty_log_manual_protect and_init_set instead of
> kvm_manual_dirty_log_init_set (just an idea, your opinions are welcome).

I'm fine with either namings.

> 
> > 
> > > +EXPORT_SYMBOL_GPL(kvm_manual_dirty_log_init_set);
> > > +
> > >  /*
> > >   * Allocation size is twice as large as the actual dirty bitmap size.
> > >   * See x86's kvm_vm_ioctl_get_dirty_log() why this is needed.
> > >   */
> > > -static int kvm_create_dirty_bitmap(struct kvm_memory_slot *memslot)
> > > +static int kvm_alloc_dirty_bitmap(struct kvm_memory_slot *memslot)
> > >  {
> > >  	unsigned long dirty_bytes = 2 * kvm_dirty_bitmap_bytes(memslot);
> > >
> > > @@ -1094,8 +1100,11 @@ int __kvm_set_memory_region(struct kvm *kvm,
> > >
> > >  	/* Allocate page dirty bitmap if needed */
> > >  	if ((new.flags & KVM_MEM_LOG_DIRTY_PAGES) && !new.dirty_bitmap) {
> > > -		if (kvm_create_dirty_bitmap(&new) < 0)
> > > +		if (kvm_alloc_dirty_bitmap(&new))
> > >  			goto out_free;
> > > +
> > > +		if (kvm_manual_dirty_log_init_set(kvm))
> > > +			bitmap_set(new.dirty_bitmap, 0, new.npages);
> > >  	}
> > >
> > >  	slots = kvzalloc(sizeof(struct kvm_memslots), GFP_KERNEL_ACCOUNT);
> > > @@ -3310,9 +3319,6 @@ static long
> > kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > >  	case KVM_CAP_IOEVENTFD_ANY_LENGTH:
> > >  	case KVM_CAP_CHECK_EXTENSION_VM:
> > >  	case KVM_CAP_ENABLE_CAP_VM:
> > > -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > > -	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > > -#endif
> > >  		return 1;
> > >  #ifdef CONFIG_KVM_MMIO
> > >  	case KVM_CAP_COALESCED_MMIO:
> > > @@ -3320,6 +3326,10 @@ static long
> > kvm_vm_ioctl_check_extension_generic(struct kvm *kvm, long arg)
> > >  	case KVM_CAP_COALESCED_PIO:
> > >  		return 1;
> > >  #endif
> > > +#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> > > +	case KVM_CAP_MANUAL_DIRTY_LOG_PROTECT2:
> > > +		return KVM_DIRTY_LOG_MANUAL_CAPS;
> > 
> > We probably can only return the new feature bit when with CONFIG_X86?
> 
> How about to define different values in different architectures(see
> KVM_USER_MEM_SLOTS as an example), like this:
> 
> diff --git a/arch/arm/include/asm/kvm_host.h b/arch/arm/include/asm/kvm_host.h
> index c3314b2..383a8ae 100644
> --- a/arch/arm/include/asm/kvm_host.h
> +++ b/arch/arm/include/asm/kvm_host.h
> @@ -23,6 +23,10 @@
>  #define KVM_HAVE_ONE_REG
>  #define KVM_HALT_POLL_NS_DEFAULT 500000
> 
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT (1 << 0)
> +#define KVM_DIRTY_LOG_INITIALLY_SET 0
> +#define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT
> +
>  #define KVM_VCPU_MAX_FEATURES 2
> 
>  #include <kvm/arm_vgic.h>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 41204a4..503ee17 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -85,6 +85,10 @@
> 
>  #define KVM_HALT_POLL_NS_DEFAULT 500000
> 
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT (1 << 0)
> +#define KVM_DIRTY_LOG_INITIALLY_SET 0
> +#define KVM_DIRTY_LOG_MANUAL_CAPS KVM_DIRTY_LOG_MANUAL_PROTECT
> +
>  #ifdef CONFIG_KVM_MIPS_VZ
>  extern unsigned long GUESTID_MASK;
>  extern unsigned long GUESTID_FIRST_VERSION;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 40a0c0f..ac05172 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -49,6 +49,11 @@
> 
>  #define KVM_IRQCHIP_NUM_PINS  KVM_IOAPIC_NUM_PINS
> 
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT (1 << 0)
> +#define KVM_DIRTY_LOG_INITIALLY_SET (1 << 1)
> +#define KVM_DIRTY_LOG_MANUAL_CAPS (KVM_DIRTY_LOG_MANUAL_PROTECT | \
> +               KVM_DIRTY_LOG_INITIALLY_SET)
> +
>  /* x86-specific vcpu->requests bit members */
>  #define KVM_REQ_MIGRATE_TIMER          KVM_ARCH_REQ(0)
>  #define KVM_REQ_REPORT_TPR_ACCESS      KVM_ARCH_REQ(1)
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index e89eb67..ebd3e55 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -360,6 +360,18 @@ static inline unsigned long *kvm_second_dirty_bitmap(struct kvm_memory_slot *mem
>         return memslot->dirty_bitmap + len / sizeof(*memslot->dirty_bitmap);
>  }
> 
> +#ifndef KVM_DIRTY_LOG_MANUAL_PROTECT
> +#define KVM_DIRTY_LOG_MANUAL_PROTECT 0
> +#endif
> +#ifndef KVM_DIRTY_LOG_INITIALLY_SET
> +#define KVM_DIRTY_LOG_INITIALLY_SET 0
> +#endif
> +#ifndef KVM_DIRTY_LOG_MANUAL_CAPS
> +#define KVM_DIRTY_LOG_MANUAL_CAPS 0
> +#endif

This seems a bit more awkward to me... You also reminded me that maybe
it's good we put the sub-cap definition into uapi.  How about:

==========

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 40a0c0fd95ca..fcffaf8a6964 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1697,4 +1697,7 @@ static inline int kvm_cpu_get_apicid(int mps_cpu)
 #define GET_SMSTATE(type, buf, offset)         \
        (*(type *)((buf) + (offset) - 0x7e00))
 
+#define KVM_DIRTY_LOG_MANUAL_CAPS      (KVM_DIRTY_LOG_MANUAL_PROTECT | \
+                                        KVM_DIRTY_LOG_INITIALLY_SET)
+
 #endif /* _ASM_X86_KVM_HOST_H */
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e89eb67356cb..39d49802ee87 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -1410,4 +1410,8 @@ int kvm_vm_create_worker_thread(struct kvm *kvm, kvm_vm_thread_fn_t thread_fn,
                                uintptr_t data, const char *name,
                                struct task_struct **thread_ptr);
 
+#ifndef KVM_DIRTY_LOG_MANUAL_CAPS
+#define KVM_DIRTY_LOG_MANUAL_CAPS      KVM_DIRTY_LOG_MANUAL_PROTECT
+#endif
+
 #endif
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 4b95f9a31a2f..a83f7627c0c1 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -1628,4 +1628,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK                0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN    (1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT   (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET    (1 << 1)
+
 #endif /* __LINUX_KVM_H */

==========

Thanks,

-- 
Peter Xu

