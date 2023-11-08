Return-Path: <kvm+bounces-1224-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9AAA7E5BFB
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 18:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA7981C20BCA
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 17:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C06B30FB3;
	Wed,  8 Nov 2023 17:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rq1GDaZv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E504D30349
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 17:08:48 +0000 (UTC)
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61FEEEA
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 09:08:48 -0800 (PST)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-5afc00161daso84832977b3.1
        for <kvm@vger.kernel.org>; Wed, 08 Nov 2023 09:08:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699463327; x=1700068127; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TmuUCnmsxcWhKpY6PDAYvg4ZjDKBI8XOwGtY/GkMtWw=;
        b=rq1GDaZvMQJUd33Hq5d6Us3A4F4ZekFGSJ6IzgZpzJIAIPZ3y08u7g/iVrrLonT6WW
         VzwqgFXM2E4wfrgQ03/oYPpTYE4VjFgTx2wo/d6vceDRMeypuSXIh0tiUlJkW4av5DZE
         yANznrED3vp6sgWDdQP5ZpPqPwws4m4al9M6OivFnH43oInVTaJ6p95tLCxFu4hye7NM
         wUEGjkpO5zjRg8n6yVzBUu9oZIqfAkKxe8ABPjHjupEKtKvuQEHWpi079k5tpELH01Uy
         UL9+mc4ynZ9QuTVKXrB6kiXAs4P/qxfVSQD4u4e65PBZ0n4GtZamXqO0rpuqXruet8ni
         Cegg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699463327; x=1700068127;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmuUCnmsxcWhKpY6PDAYvg4ZjDKBI8XOwGtY/GkMtWw=;
        b=qTbrEq3Sr/W+1RLBO/GtxZQrNp7oMn+bbTDJrWIpoFhYVLCdQmpo4KbHrMtB9kNGpb
         WaokClmnQ3eiqfextQamR2aFvvkeLM+FKDl7emXh7SdcLX2Qx8JOLSfTaT1Av2XhmkAp
         IdmrEJNU8ioK6MDyI9/76Da8rTQn7UsmjypmJpMVK3fd+ejTG1asY+iZvipefu8/1pOn
         3e+/KHz10T9r0xzKXrWn2ZCTAkTID/fbP32UrbhlFrrg4+2cOQIvKxNFjJ+Ya2Hpnv6y
         uUPJ2sQCMJy3GKK2i/rujel97b20vl6pQzJ4GlI74mebedB4xB30cynFjLNDgRS4plXA
         6/bQ==
X-Gm-Message-State: AOJu0YxX1I71hzbzBZGa/qzU/UkhXMtWPH2UGnCdCrxRyXf140CcV45B
	VwNui/uTXLTZSKbdbtc7xJOE83mk0Uo=
X-Google-Smtp-Source: AGHT+IEUvQLF3BVsFAZtA/Akz9sUImZwW9cQuy2q9jQLuaSZdFfOebS0qYWIrABn6SnaGvlvWkhzzZxT0yQ=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:102:b0:da3:723b:b2a4 with SMTP id
 o2-20020a056902010200b00da3723bb2a4mr43586ybh.7.1699463327583; Wed, 08 Nov
 2023 09:08:47 -0800 (PST)
Date: Wed, 8 Nov 2023 09:08:46 -0800
In-Reply-To: <20231108111806.92604-22-nsaenz@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108111806.92604-1-nsaenz@amazon.com> <20231108111806.92604-22-nsaenz@amazon.com>
Message-ID: <ZUvAnqAIsUP4Vd0J@google.com>
Subject: Re: [RFC 21/33] KVM: Pass memory attribute array as a MMU notifier argument
From: Sean Christopherson <seanjc@google.com>
To: Nicolas Saenz Julienne <nsaenz@amazon.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hyperv@vger.kernel.org, pbonzini@redhat.com, vkuznets@redhat.com, 
	anelkz@amazon.com, graf@amazon.com, dwmw@amazon.co.uk, jgowans@amazon.com, 
	corbert@lwn.net, kys@microsoft.com, haiyangz@microsoft.com, 
	decui@microsoft.com, x86@kernel.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"

On Wed, Nov 08, 2023, Nicolas Saenz Julienne wrote:
> Pass the memory attribute array through struct kvm_mmu_notifier_arg and
> use it in kvm_arch_post_set_memory_attributes() instead of defaulting on
> kvm->mem_attr_array.
> 
> Signed-off-by: Nicolas Saenz Julienne <nsaenz@amazon.com>
> ---
>  arch/x86/kvm/mmu/mmu.c   | 8 ++++----
>  include/linux/kvm_host.h | 5 ++++-
>  virt/kvm/kvm_main.c      | 1 +
>  3 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index c0fd3afd6be5..c2bec2be2ba9 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -7311,6 +7311,7 @@ static bool hugepage_has_attrs(struct xarray *mem_attr_array,
>  bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  					 struct kvm_gfn_range *range)
>  {
> +	struct xarray *mem_attr_array = range->arg.mem_attr_array;
>  	unsigned long attrs = range->arg.attributes;
>  	struct kvm_memory_slot *slot = range->slot;
>  	int level;
> @@ -7344,8 +7345,8 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
>  			 * misaligned address regardless of memory attributes.
>  			 */
>  			if (gfn >= slot->base_gfn) {
> -				if (hugepage_has_attrs(&kvm->mem_attr_array,
> -						       slot, gfn, level, attrs))
> +				if (hugepage_has_attrs(mem_attr_array, slot,
> +						       gfn, level, attrs))

This is wildly broken.  The hugepage tracking is per VM, whereas the attributes
here are per-VTL.  I.e. KVM will (dis)allow hugepages based on whatever VTL last
changed its protections.

