Return-Path: <kvm+bounces-322-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D1697DE49A
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 17:32:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E54B4B21176
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 16:32:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3568E15E84;
	Wed,  1 Nov 2023 16:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="H0peW2Vg"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FE3415E80
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 16:31:59 +0000 (UTC)
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9101D10C
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 09:31:58 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id d9443c01a7336-1cc252cbde2so37996355ad.0
        for <kvm@vger.kernel.org>; Wed, 01 Nov 2023 09:31:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1698856318; x=1699461118; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YV/Jadwf9F+4h9faQyKBO/VGXY2YU0z1WDp/3xRNHSA=;
        b=H0peW2VgEHgEAmUBl8WSgwDu6k3CQIV6n15GUScEvSn79JwEn8g4dsqv2PfNQmSRHg
         mOr2XyOBSXinROqvvc2GgKs1M6Psbmyf3XBBY7PvM9YV5NQChNUy3xr0RR1I0AdhZFNj
         /SEtTbNu0cOhpnalVQUgXoJd6qFRGEirEilPOzervJ/2/0VSipCg1CQpoQKk5UNouxy0
         71lE735dwCIub4yXv1iTRdUMUZ3mAyODMCZLa3WDd4K01dmctSTNMadjXZeKZf7Okjqb
         G8704HOhBl/ifqqMLgPT98Ih3vTLySx1YzU1a92CT0vd+c0zoH8M5gkyV02gwZzB2ptg
         x/MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698856318; x=1699461118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YV/Jadwf9F+4h9faQyKBO/VGXY2YU0z1WDp/3xRNHSA=;
        b=lhhLlLJ74iao4VD8qtyDnIdi6nyaNmMl6agPnPMaExAfnV2SvS6dlNv29tGdn9/fMi
         3UOs0Z+H+LtCyvgf8JhoQe0RQQNnaaFr3ffNyo8VTQTKHzMDfhfBZ/jeBi96Eno4yh+j
         J+o4Sh/bpStklB3V9d9dBxUdyGrIAxn7nkicdllUrgEPKgC2RQnE5/8gPPYZVJ7SKFp9
         5tJR8l+tS6ozwXZfSbl6g2cUI8qwt4BHQd8WQF8fO3wqPZl6JfjQqpxTsIyYdkYZ/uec
         7zb10beZ4JiwIQl4SBoGsNVVodo6QxG3+mJXDUSY92z59aKLNa21DQ3eRqMwGx8LH9Yb
         3o9A==
X-Gm-Message-State: AOJu0Yxa1kqHxWdJvOHogCrpm/60gEZ+7RDBs2TsbhyR6dzvdpHkHB+t
	mUC/WP2RotT7ch3WrXr45klurWdND+k=
X-Google-Smtp-Source: AGHT+IFjPqC/TQoUJx9xijTOJvOyhtwW2g8NWHhEyZb55Fnj2J2udLjDB8ouZshuVH4VRanHeJsp8MbYxRU=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:25d2:b0:1cc:2ffe:5a27 with SMTP id
 jc18-20020a17090325d200b001cc2ffe5a27mr230020plb.9.1698856318050; Wed, 01 Nov
 2023 09:31:58 -0700 (PDT)
Date: Wed, 1 Nov 2023 09:31:56 -0700
In-Reply-To: <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20230914063325.85503-1-weijiang.yang@intel.com>
 <20230914063325.85503-20-weijiang.yang@intel.com> <d67fe0ca19f7aef855aa376ada0fc96a66ca0d4f.camel@redhat.com>
Message-ID: <ZUJ9fDuQUNe9BLUA@google.com>
Subject: Re: [PATCH v6 19/25] KVM: VMX: Emulate read and write to CET MSRs
From: Sean Christopherson <seanjc@google.com>
To: Maxim Levitsky <mlevitsk@redhat.com>
Cc: Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, dave.hansen@intel.com, peterz@infradead.org, 
	chao.gao@intel.com, rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="us-ascii"

On Tue, Oct 31, 2023, Maxim Levitsky wrote:
> On Thu, 2023-09-14 at 02:33 -0400, Yang Weijiang wrote:
> > Add emulation interface for CET MSR access. The emulation code is split
> > into common part and vendor specific part. The former does common check
> > for MSRs and reads/writes directly from/to XSAVE-managed MSRs via the
> > helpers while the latter accesses the MSRs linked to VMCS fields.
> > 
> > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > ---

...

> > +	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
> > +	case MSR_KVM_SSP:
> > +		if (host_msr_reset && kvm_cpu_cap_has(X86_FEATURE_SHSTK))
> > +			break;
> > +		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
> > +			return 1;
> > +		if (index == MSR_KVM_SSP && !host_initiated)
> > +			return 1;
> > +		if (is_noncanonical_address(data, vcpu))
> > +			return 1;
> > +		if (index != MSR_IA32_INT_SSP_TAB && !IS_ALIGNED(data, 4))
> > +			return 1;
> > +		break;
> Once again I'll prefer to have an ioctl for setting/getting SSP, this will
> make the above code simpler (e.g there will be no need to check that write
> comes from the host/etc).

I don't think an ioctl() would be simpler overall, especially when factoring in
userspace.  With a synthetic MSR, we get the following quite cheaply:

 1. Enumerating support to userspace.
 2. Save/restore of the value, e.g. for live migration.
 3. Vendor hooks for propagating values to/from the VMCS/VMCB.

For an ioctl(), #1 would require a capability, #2 (and #1 to some extent) would
require new userspace flows, and #3 would require new kvm_x86_ops hooks.

The synthetic MSR adds a small amount of messiness, as does bundling 
MSR_IA32_INT_SSP_TAB with the other shadow stack MSRs.  The bulk of the mess comes
from the need to allow userspace to write '0' when KVM enumerated supported to
userspace.

If we isolate MSR_IA32_INT_SSP_TAB, that'll help with the synthetic MSR and with
MSR_IA32_INT_SSP_TAB.  For the unfortunate "host reset" behavior, the best idea I
came up with is to add a helper.  It's still a bit ugly, but the ugliness is
contained in a helper and IMO makes it much easier to follow the case statements.

get:

	case MSR_IA32_INT_SSP_TAB:
		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) ||
		    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
			return 1;
		break;
	case MSR_KVM_SSP:
		if (!host_initiated)
			return 1;
		fallthrough;
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK))
			return 1;
		break;

static bool is_set_cet_msr_allowed(struct kvm_vcpu *vcpu, u32 index, u64 data,
				   bool host_initiated)
{
	bool any_cet = index == MSR_IA32_S_CET || index == MSR_IA32_U_CET;

	if (guest_can_use(vcpu, X86_FEATURE_SHSTK))
		return true;

	if (any_cet && guest_can_use(vcpu, X86_FEATURE_IBT))
		return true;

	/* 
	 * If KVM supports the MSR, i.e. has enumerated the MSR existence to
	 * userspace, then userspace is allowed to write '0' irrespective of
	 * whether or not the MSR is exposed to the guest.
	 */
	if (!host_initiated || data)
		return false;

	if (kvm_cpu_cap_has(X86_FEATURE_SHSTK))
		return true;

	return any_cet && kvm_cpu_cap_has(X86_FEATURE_IBT);
}

set:
	case MSR_IA32_U_CET:
	case MSR_IA32_S_CET:
		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
			return 1;
		if (data & CET_US_RESERVED_BITS)
			return 1;
		if (!guest_can_use(vcpu, X86_FEATURE_SHSTK) &&
		    (data & CET_US_SHSTK_MASK_BITS))
			return 1;
		if (!guest_can_use(vcpu, X86_FEATURE_IBT) &&
		    (data & CET_US_IBT_MASK_BITS))
			return 1;
		if (!IS_ALIGNED(CET_US_LEGACY_BITMAP_BASE(data), 4))
			return 1;

		/* IBT can be suppressed iff the TRACKER isn't WAIT_ENDBR. */
		if ((data & CET_SUPPRESS) && (data & CET_WAIT_ENDBR))
			return 1;
		break;
	case MSR_IA32_INT_SSP_TAB:
		if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
			return 1;

		if (is_noncanonical_address(data, vcpu))
			return 1;
		break;
	case MSR_KVM_SSP:
		if (!host_initiated)
			return 1;
		fallthrough;
	case MSR_IA32_PL0_SSP ... MSR_IA32_PL3_SSP:
		if (!is_set_cet_msr_allowed(vcpu, index, data, host_initiated))
			return 1;
		if (is_noncanonical_address(data, vcpu))
			return 1;
		if (!IS_ALIGNED(data, 4))
			return 1;
		break;
	}

