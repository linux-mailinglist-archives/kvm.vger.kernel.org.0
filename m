Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267446A4DC5
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 23:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjB0WNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 17:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbjB0WNE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 17:13:04 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC12213531;
        Mon, 27 Feb 2023 14:13:02 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id u5so4969432plq.7;
        Mon, 27 Feb 2023 14:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gSoyIRdk2necibNGHW1XNcmlnKUC/UGS7KXWUhWzN54=;
        b=K8scKwSRgffkGyn/nz0CjNmeUu9IkROiI9wYW2WOXsLWOzbtNxmjFDQgirrYf63N3N
         gs5Rj/aml0czFpP6Kc/PO/trA3i34d1twm1kI18lRt3b/G2LkD7FkoQve0Zt6e4tQ4lq
         Tk55sYyuK9gAeQGX/xVPNFhievWGq2loLNa0jNAgUCLg+c6+N0CXuIgT+ZnNWWUlEsmI
         q4m1WL/KmSgWof+FHaH2uy15xTMDuDKyrONurQg3mCLL5HdhYcbqLzcQqjkEhQZCrk+s
         wFH2UHYIMOviHVtCQBgSa/Kzj8IPF/yeesMbuVdPJCrI1MmbuBSWaoxOzz3xBeuWu4FA
         iQQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gSoyIRdk2necibNGHW1XNcmlnKUC/UGS7KXWUhWzN54=;
        b=hHF2BWTlxdKUECKBihci4uGG4r/VBOW3xpYvL9QxOe+kDvcqIA7xvnPQPGoC1LyaTB
         b6uv6RuSZv9CLTizeIUPZO7duyxXp3y+Ei4/aCENGEfcpUsE73Olun99p8pKClhmNaRh
         Z9/UgV3Tq7YQ7iqzuPFYi4XrPxkm54W6ftjYTIJzXiuFvc9Y9VJIVGZ3KBY7957D2Zuc
         mLfbgnm4DygIDYP8LhxkWnIpQto5CVm9CikgpkuDi/1RGjqN6ihuZohSk8hUNEw2LxbH
         RKzVTab5ncL9BhdWCV/T0UISUb6V7c6jZJNw4MtugX+jGwgkQ29wWal7aPbl1zUF+9l1
         hvOA==
X-Gm-Message-State: AO0yUKUIPKBVzPDi99E5XkQnRz9ZqPn9XgqMmAtw6iwWEnoNqMBas5X6
        n7CcIiOpKeR5TE45/aZJhSk=
X-Google-Smtp-Source: AK7set+Uy+nFOhkmkQDDLJ1gqsEs1tmKs4LqyIleZkZP3Xt0pM9IqSPX4XpDeIgMX9/zEelfiGiG/g==
X-Received: by 2002:a17:902:7c97:b0:19d:244:a3a8 with SMTP id y23-20020a1709027c9700b0019d0244a3a8mr410725pll.10.1677535982069;
        Mon, 27 Feb 2023 14:13:02 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id g3-20020a1709026b4300b00198e346c35dsm5100350plt.9.2023.02.27.14.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 14:13:01 -0800 (PST)
Date:   Mon, 27 Feb 2023 14:12:59 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 099/113] KVM: TDX: Handle TDX PV map_gpa hypercall
Message-ID: <20230227221259.GR4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <1a7c87931d303b2e66874e0bbbd791aa308bc918.1673539699.git.isaku.yamahata@intel.com>
 <20230131013029.qtansdeuvwe7nlzt@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230131013029.qtansdeuvwe7nlzt@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 31, 2023 at 09:30:29AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Thu, Jan 12, 2023 at 08:32:47AM -0800, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > Wire up TDX PV map_gpa hypercall to the kvm/mmu backend.
> >
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  arch/x86/kvm/vmx/tdx.c | 53 ++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 53 insertions(+)
> >
> > diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> > index 4bbde58510a4..486d0f0c6dd1 100644
> > --- a/arch/x86/kvm/vmx/tdx.c
> > +++ b/arch/x86/kvm/vmx/tdx.c
> > @@ -1181,6 +1181,57 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
> >  	return 1;
> >  }
> >
> > +static int tdx_map_gpa(struct kvm_vcpu *vcpu)
> > +{
> > +	struct kvm *kvm = vcpu->kvm;
> > +	gpa_t gpa = tdvmcall_a0_read(vcpu);
> > +	gpa_t size = tdvmcall_a1_read(vcpu);
> > +	gpa_t end = gpa + size;
> > +	gfn_t s = gpa_to_gfn(gpa) & ~kvm_gfn_shared_mask(kvm);
> > +	gfn_t e = gpa_to_gfn(end) & ~kvm_gfn_shared_mask(kvm);
> > +	int i;
> > +
> > +	if (!IS_ALIGNED(gpa, 4096) || !IS_ALIGNED(size, 4096) ||
> > +	    end < gpa ||
> > +	    end > kvm_gfn_shared_mask(kvm) << (PAGE_SHIFT + 1) ||
> > +	    kvm_is_private_gpa(kvm, gpa) != kvm_is_private_gpa(kvm, end)) {
> > +		tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> > +		return 1;
> > +	}
> > +
> > +	/*
> > +	 * Check how the requested region overlaps with the KVM memory slots.
> > +	 * For simplicity, require that it must be contained within a memslot or
> > +	 * it must not overlap with any memslots (MMIO).
> > +	 */
> > +	for (i = 0; i < KVM_ADDRESS_SPACE_NUM; i++) {
> > +		struct kvm_memslots *slots = __kvm_memslots(kvm, i);
> > +		struct kvm_memslot_iter iter;
> > +
> > +		kvm_for_each_memslot_in_gfn_range(&iter, slots, s, e) {
> > +			struct kvm_memory_slot *slot = iter.slot;
> > +			gfn_t slot_s = slot->base_gfn;
> > +			gfn_t slot_e = slot->base_gfn + slot->npages;
> > +
> > +			/* no overlap */
> > +			if (e < slot_s || s >= slot_e)
> > +				continue;
> > +
> > +			/* contained in slot */
> > +			if (slot_s <= s && e <= slot_e) {
> > +				if (kvm_slot_can_be_private(slot))
> > +					return tdx_vp_vmcall_to_user(vcpu);
> > +				continue;
> > +			}
> > +
> > +			break;
> > +		}
> > +	}
> > +
> > +	tdvmcall_set_return_code(vcpu, TDG_VP_VMCALL_INVALID_OPERAND);
> 
> This returns TDG_VP_VMCALL_INVALID_OPERAND if the TD is running with
> non-private slots, which looks incorrect to the caller in TD guest(because
> the operands are correct). Can we just refuse to create TD if private memory
> slot is the only supported slot type for it ?

TD needs to support both private and non-private memory slot for device
assignment via shared pages.

So question should be, what's the expectation for non-private memory slot with
memory attribute change or TDX map_gpa.

- setting memory attributes: KVM_SET_MEMORY_ATTRIBUTES
  - option 1. return error
  - option 2. silently ignore as nop
              Following get-attributes returns non-private.
  - option 3. Allow setting attributes value. but no effect.
              Following get-attributes returns private. but kvm page fault
              doesn't have any effect.

- TDX MAP GPA hypercall
  Let's assume the region is contained in a single memory slot.
  - option 1. return error
  - option 2. silently ignore as nop

For map gpa hypercall, it's better to return error because guest should know
which region is for private memory or device assignment.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
