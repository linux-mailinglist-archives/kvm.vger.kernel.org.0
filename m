Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE1AA6D6597
	for <lists+kvm@lfdr.de>; Tue,  4 Apr 2023 16:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbjDDOk7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Apr 2023 10:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjDDOk5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Apr 2023 10:40:57 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 803443AB5;
        Tue,  4 Apr 2023 07:40:53 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id 38308e7fff4ca-2a5f619b4e2so760481fa.0;
        Tue, 04 Apr 2023 07:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680619252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8jMFTqZ3iX4TYtwGxvCBQk3Ib7hvU7vvi0bgFu56EK0=;
        b=AqFcW0+z2nqWIvV59SVfS9ovPz0wpK2NVEr/92uv+2oNKtQqs0gM/H2+VYxlIo6YCr
         eD55r5NM39gud2Bz0x2CVKXX13ykMnkdqi+WwOXPr/tfqFyAbPK525CHZAJIHrXY53Ia
         fmt6XU4HZiphjGhVWXAO88HzQSDHCJwiWkb1bKbJUt3aalNhPv6t5mnKFv4YP/ovYrSO
         hP/i6xLR0H0NikKmLnUvedmvf+aRZKUcPUYzcaGhE6RkmsNzBNUaaYgQuXurUewfKcDj
         /blybMBPkXprc32WMhNsW+JdCZEkNHKFGzrqwx0XQsdCsK5KLMiiqnFlmSi21btzyxfu
         ddXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680619252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8jMFTqZ3iX4TYtwGxvCBQk3Ib7hvU7vvi0bgFu56EK0=;
        b=Th9YS3j9uJdSMf8fHrKMWxDn9oO/4qYZignQPSo09xd/fJP11Q7B0lKAEJDP2W4rTF
         Wz7IEZPE//r8Oe7Qg679ZWMCqKyBWuVCu/GnLXRHwYydTKMn/kAXcoCdM7pDewgaciPp
         /q8rfwZSzh/UOXWIn8+UskB2xVTxsdbdQNvlLcjQZYMeFs9tSDrUiyfNfx9j68ejjwNp
         v1wHzdsfN1FTh27/rPDlxoRJy+W5qtn0Rj1WlBCDhNSuTKak9Tm+poHdMlk3IFg0Y2y4
         nLEhFS5zRiha7vuKeOtoRuUtrDtfdlr12qZyKkki/x7bWzGX6G/v05gDpiumPJr9RcV2
         0FIA==
X-Gm-Message-State: AAQBX9c3YEMqFpv5gfniDZrgAvHTd06ktOkGrK/rWQ7/1dVdEaQfcro2
        BLH1fjRc5EwAleLMqM2covs=
X-Google-Smtp-Source: AKy350b1m3A3BFbhnjEWAZBZaO+cl87OMMz86TJAKmwKy4zTQ86+WUTaHK3S2APiVUkq35oqpY+1rQ==
X-Received: by 2002:a2e:bd84:0:b0:2a6:1dbf:5d3e with SMTP id o4-20020a2ebd84000000b002a61dbf5d3emr1026319ljq.0.1680619251465;
        Tue, 04 Apr 2023 07:40:51 -0700 (PDT)
Received: from localhost (88-115-161-74.elisa-laajakaista.fi. [88.115.161.74])
        by smtp.gmail.com with ESMTPSA id a7-20020a05651c010700b0029c13f4d519sm2369013ljb.119.2023.04.04.07.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 07:40:51 -0700 (PDT)
Date:   Tue, 4 Apr 2023 17:40:48 +0300
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Michael Roth <michael.roth@amd.com>
Cc:     <kvm@vger.kernel.org>, <linux-coco@lists.linux.dev>,
        <linux-mm@kvack.org>, <linux-crypto@vger.kernel.org>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>, <mingo@redhat.com>, <jroedel@suse.de>,
        <thomas.lendacky@amd.com>, <hpa@zytor.com>, <ardb@kernel.org>,
        <pbonzini@redhat.com>, <seanjc@google.com>, <vkuznets@redhat.com>,
        <jmattson@google.com>, <luto@kernel.org>,
        <dave.hansen@linux.intel.com>, <slp@redhat.com>,
        <pgonda@google.com>, <peterz@infradead.org>,
        <srinivas.pandruvada@linux.intel.com>, <rientjes@google.com>,
        <dovmurik@linux.ibm.com>, <tobin@ibm.com>, <bp@alien8.de>,
        <vbabka@suse.cz>, <kirill@shutemov.name>, <ak@linux.intel.com>,
        <tony.luck@intel.com>, <marcorr@google.com>,
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        <alpergun@google.com>, <dgilbert@redhat.com>, <jarkko@kernel.org>,
        <ashish.kalra@amd.com>, <nikunj.dadhania@amd.com>,
        Vishal Annapurve <vannapurve@google.com>
Subject: Re: [PATCH RFC v8 04/56] KVM: Add HVA range operator
Message-ID: <20230404174048.00005ef9.zhi.wang.linux@gmail.com>
In-Reply-To: <20230327003444.lqfrididd4gavomb@amd.com>
References: <20230220183847.59159-1-michael.roth@amd.com>
        <20230220183847.59159-5-michael.roth@amd.com>
        <20230220233709.00006dfc@gmail.com>
        <20230327003444.lqfrididd4gavomb@amd.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sun, 26 Mar 2023 19:34:44 -0500
Michael Roth <michael.roth@amd.com> wrote:

> On Mon, Feb 20, 2023 at 11:37:09PM +0200, Zhi Wang wrote:
> > On Mon, 20 Feb 2023 12:37:55 -0600
> > Michael Roth <michael.roth@amd.com> wrote:
> > 
> > > From: Vishal Annapurve <vannapurve@google.com>
> > > 
> > > Introduce HVA range operator so that other KVM subsystems
> > > can operate on HVA range.
> > > 
> > > Signed-off-by: Vishal Annapurve <vannapurve@google.com>
> > > [mdr: minor checkpatch alignment fixups]
> > > Signed-off-by: Michael Roth <michael.roth@amd.com>
> > > ---
> > >  include/linux/kvm_host.h |  6 +++++
> > >  virt/kvm/kvm_main.c      | 48 ++++++++++++++++++++++++++++++++++++++++
> > >  2 files changed, 54 insertions(+)
> > > 
> > > diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> > > index 4d542060cd93..c615650ed256 100644
> > > --- a/include/linux/kvm_host.h
> > > +++ b/include/linux/kvm_host.h
> > > @@ -1402,6 +1402,12 @@ void kvm_mmu_invalidate_begin(struct kvm *kvm);
> > >  void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
> > >  void kvm_mmu_invalidate_end(struct kvm *kvm);
> > >  
> > > +typedef int (*kvm_hva_range_op_t)(struct kvm *kvm,
> > > +				struct kvm_gfn_range *range, void *data);
> > > +
> > > +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> > > +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data);
> > > +
> > >  long kvm_arch_dev_ioctl(struct file *filp,
> > >  			unsigned int ioctl, unsigned long arg);
> > >  long kvm_arch_vcpu_ioctl(struct file *filp,
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index f7e00593cc5d..4ccd655dd5af 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -642,6 +642,54 @@ static __always_inline int __kvm_handle_hva_range(struct kvm *kvm,
> > >  	return (int)ret;
> > >  }
> > >  
> > 
> > Below function seems a reduced duplicate of __kvm_handle_hva_range()
> > in virt/kvm/kvm_main.c. It would be nice to factor __kvm_handle_hva_range().
> 
> A few differences make it difficult to refactor this clearly:
> 
>   - This handler is mainly used for loading initial contents into guest
>     image before booting and doesn't rely on the MMU lock being held. It
>     also *can't* be called with MMU lock held because it suffers from the
>     same issue with mem_attr_update() hook where it needs to take a
>     mutex as part of unmapping from directmap when transitioning page to
>     private state in RMP table
>   - This handler wants to return an error code, as opposed to existing
>     handlers which return a true/false values which are passed along to
>     MMU notifier call-site and handled differently.
>   - This handler wants to terminate iterating through memslots as soon
>     as it encounters the first failure, whereas the existing handlers
>     expect to be called for each slot regardless of return value.
> 
> So it's a pretty different use-case that adds enough complexity to
> __kvm_handle_hva_range() that it might need be worth refactoring it,
> since it complicates some bits that are closely tied to dealing with
> invalidations where the extra complexity probably needs to be
> well-warranted.
> 
> I took a stab at it here for reference, but even with what seems to be
> the minimal set of changes it doesn't save on any code and ultimately I
> think it makes it harder to make sense of what going on:
> 
>   https://github.com/mdroth/linux/commit/976c5fb708f7babe899fd80e27e19f8ba3f6818d
> 
> Is there a better approach?
> 

Those requirements looks pretty suitable for kvm_handle_hva_range(). Guess
we just need to extend the iterator a little bit.

My ideas:

1) Add a lock flag in struct kvm_hva_range to indicate if kvm_lock is required
or not during the iteration. Check the flag with if (!locked && hva_range.need_lock). Then the unlock part can be left un-touched.

2) Add an error code in struct kvm_gfn_range, the handler can set it so that __kvm_handle_hva_range() can check gfn_range.err after ret|= handler(xxx);
If the err is set, bail out.

3) Return the gfn_range.err to the caller. The caller can decide how to convert
it (to boolean or keep it)

4) Set hva_range.need_lock in the existing and the new caller.

How about this?

> Thanks,
> 
> -Mike
> 
> > 
> > > +int kvm_vm_do_hva_range_op(struct kvm *kvm, unsigned long hva_start,
> > > +			   unsigned long hva_end, kvm_hva_range_op_t handler, void *data)
> > > +{
> > > +	int ret = 0;
> > > +	struct kvm_gfn_range gfn_range;
> > > +	struct kvm_memory_slot *slot;
> > > +	struct kvm_memslots *slots;
> > > +	int i, idx;
> > > +
> > > +	if (WARN_ON_ONCE(hva_end <= hva_start))
> > > +		return -EINVAL;
> > > +
> > > +	idx = srcu_read_lock(&kvm->srcu);
> > > +
> > > +	for (i = 0; i < kvm_arch_nr_memslot_as_ids(kvm); i++) {
> > > +		struct interval_tree_node *node;
> > > +
> > > +		slots = __kvm_memslots(kvm, i);
> > > +		kvm_for_each_memslot_in_hva_range(node, slots,
> > > +						  hva_start, hva_end - 1) {
> > > +			unsigned long start, end;
> > > +
> > > +			slot = container_of(node, struct kvm_memory_slot,
> > > +					    hva_node[slots->node_idx]);
> > > +			start = max(hva_start, slot->userspace_addr);
> > > +			end = min(hva_end, slot->userspace_addr +
> > > +						  (slot->npages << PAGE_SHIFT));
> > > +
> > > +			/*
> > > +			 * {gfn(page) | page intersects with [hva_start, hva_end)} =
> > > +			 * {gfn_start, gfn_start+1, ..., gfn_end-1}.
> > > +			 */
> > > +			gfn_range.start = hva_to_gfn_memslot(start, slot);
> > > +			gfn_range.end = hva_to_gfn_memslot(end + PAGE_SIZE - 1, slot);
> > > +			gfn_range.slot = slot;
> > > +
> > > +			ret = handler(kvm, &gfn_range, data);
> > > +			if (ret)
> > > +				goto e_ret;
> > > +		}
> > > +	}
> > > +
> > > +e_ret:
> > > +	srcu_read_unlock(&kvm->srcu, idx);
> > > +
> > > +	return ret;
> > > +}
> > > +
> > >  static __always_inline int kvm_handle_hva_range(struct mmu_notifier *mn,
> > >  						unsigned long start,
> > >  						unsigned long end,
> > 

