Return-Path: <kvm+bounces-71413-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEZ5Ko6YmGlaJwMAu9opvQ
	(envelope-from <kvm+bounces-71413-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:23:26 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0F0169AE9
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 18:23:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0B4AE3014F6B
	for <lists+kvm@lfdr.de>; Fri, 20 Feb 2026 17:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02C7732B996;
	Fri, 20 Feb 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ls2Dc+GA"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CDF428F50F
	for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 17:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771608197; cv=none; b=jJ5ZROwAirzv8DnqczfkUeIvlp8Bkw7XCddTw6nBQO5vPc/m31F4TzBQmcvt4fv+q2qM7SQsTF90S0wC4LR/HToGWUI0gwbXqXAeOScFeaM1S2rtZP3a+YHSVnSwZjMeDY9aX9OeMxBN4hkX0YeCqbtEFb+wLueBS+fb4YsfeCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771608197; c=relaxed/simple;
	bh=N4vvYLmbSC+lWZdiZowMt5Dnv4enGTpeHrDlBx83/vM=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bE07T3GJla6uhR+ITIlXlTm06Z3QC0kJdQC+gKbV3zI0/evrdpB8MzlUr4dbgqeIXLaHJifPzM9zm1+AHPSSvoAcezxI0zPURuz+Vw+ABaev+wgP07XSpkwe57Zus0PSWCSRNe9mNfpRM9a/n/z+YH7zqmdxyMr2M8LOgCqhHB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ls2Dc+GA; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2aad5fc5b2fso20403325ad.1
        for <kvm@vger.kernel.org>; Fri, 20 Feb 2026 09:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771608195; x=1772212995; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=TscEQ0P2KNXXlEwZM4rO49aZdtxwBEkde4PwCpeJoWQ=;
        b=ls2Dc+GA0WOvgUWcg1B8CuA3i5sHapFXXY67LFbyjQ+W5JTwW35mzkRYnQ03xFeqTf
         hJyCpL5eDELBkR0yhOmr20dLkQDSMVjIGpufaLFQLFB8tXTWk3QBdljESbeLRIpVowGk
         K24Q+9ALBGE1PRyzmxCZUxN+EP5x4Rt8cJHLRBio68FzwNqIjWZguTu0dFXgsjPG1Jex
         I//f6AsOiKz2P+ksarhGunemwL0bkwnyLIHhWJDNhP8xEkptMiRXmxICWD0JILuy4Uf+
         gxZZhd38l/sVKM/De1hcpJTtaUCnE17y+C6La55mFrvom3JRZLS7dXmdrknSIEtgQyuJ
         3MBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771608195; x=1772212995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TscEQ0P2KNXXlEwZM4rO49aZdtxwBEkde4PwCpeJoWQ=;
        b=wblnMBRJIMIifw0dL2T/1edms5K9ejSbq1m+kQ1sfBZIcWHgK/2Hzh13r6SJQjKAk0
         yP1q5xjPVt1yccgfLkKOi3FDdsGZ2377A99DCAsBJ/t/xLv6hazeZy9Megw3r+JBbLaH
         MflMqz1dQV0Mc3NiTQUnJS0nTAKaB/qXfy9oqQhmI2UfCdU3t3vbPFkYU4nya0qBR3tv
         2QHOqJJLUzbsu1gvseI1XY81YyQddoPy5iRMkdRLAvp80iTCG4ZcC6EQkJFA8U5sFDyE
         NN7oeWEzt6eNzBwUtPHd8oRyAlNJveXXzxmfsf5dvDuWm+I8nZ5Sq/FAKetgEbC74Kiu
         OK7g==
X-Gm-Message-State: AOJu0YzRd29jWB57PVwJT0Yi7wEiXt4QpJw48qgaWoF/vLpxuGNjTi/f
	VmuAJoAIMoXvMHd71raeoXBU/09hRVU2hLgRKTYpFU6EDi+l1gDHLkEe8CvylUJMul2msUSuvdH
	9+J2smA==
X-Received: from plsb22.prod.google.com ([2002:a17:902:b616:b0:2a0:f0e5:b144])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e852:b0:2a9:cb10:42b
 with SMTP id d9443c01a7336-2ad7452f39amr2369645ad.44.1771608195306; Fri, 20
 Feb 2026 09:23:15 -0800 (PST)
Date: Fri, 20 Feb 2026 09:23:13 -0800
In-Reply-To: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <00a7a31b-573b-4d92-91f8-7d7e2f88ea48@tum.de>
Message-ID: <aZiYgTNHfM5Y_Mo7@google.com>
Subject: Re: [PATCH] x86/hyper-v: Validate entire GVA range for non-canonical
 addresses during PV TLB flush
From: Sean Christopherson <seanjc@google.com>
To: Manuel Andreas <manuel.andreas@tum.de>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71413-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,tum.de:email]
X-Rspamd-Queue-Id: 8B0F0169AE9
X-Rspamd-Action: no action

+Vitaly and Paolo

Please use scripts/get_maintainer.pl, otherwise your emails might not reach the
right eyeballs.

On Thu, Feb 19, 2026, Manuel Andreas wrote:
> In KVM guests with Hyper-V hypercalls enabled, the hypercalls
> HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST and HVCALL_FLUSH_VIRTUAL_ADDRESS_LIST_EX
> allow a guest to request invalidation of portions of a virtual TLB.
> For this, the hypercall parameter includes a list of GVAs that are supposed
> to be invalidated.
> 
> Currently, only the base GVA is checked to be canonical. In reality,
> this check needs to be performed for the entire range of GVAs.
> This still enables guests running on Intel hardware to trigger a
> WARN_ONCE in the host (see prior commit below).
> 
> This patch simply moves the check for non-canonical addresses to be
> performed for every single GVA of the supplied range. This should also
> be more in line with the Hyper-V specification, since, although
> unlikely, a range starting with an invalid GVA may still contain
> GVAs that are valid.
> 
> Fixes: fa787ac07b3c ("KVM: x86/hyper-v: Skip non-canonical addresses during PV TLB flush")
> Signed-off-by: Manuel Andreas <manuel.andreas@tum.de>
> ---
>  arch/x86/kvm/hyperv.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index de92292eb1f5..f4f6accf1a33 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1981,16 +1981,17 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
>  		if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
>  			goto out_flush_all;
>  
> -		if (is_noncanonical_invlpg_address(entries[i], vcpu))
> -			continue;
> -
>  		/*
>  		 * Lower 12 bits of 'address' encode the number of additional
>  		 * pages to flush.
>  		 */
>  		gva = entries[i] & PAGE_MASK;
> -		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
> +		for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++) {
> +			if (is_noncanonical_invlpg_address(gva + j * PAGE_SIZE, vcpu))
> +				continue;
> +
>  			kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
> +		}

Vitaly, can we treat the entire request as garbage and throw it away if any part
isn't valid?  Or do you think we should go with the more conservative approach
as above?

diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
index de92292eb1f5..f568f3d4f6e5 100644
--- a/arch/x86/kvm/hyperv.c
+++ b/arch/x86/kvm/hyperv.c
@@ -1967,8 +1967,8 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
        struct kvm_vcpu_hv_tlb_flush_fifo *tlb_flush_fifo;
        struct kvm_vcpu_hv *hv_vcpu = to_hv_vcpu(vcpu);
        u64 entries[KVM_HV_TLB_FLUSH_FIFO_SIZE];
+       gva_t gva, extra_pages;
        int i, j, count;
-       gva_t gva;
 
        if (!tdp_enabled || !hv_vcpu)
                return -EINVAL;
@@ -1978,18 +1978,22 @@ int kvm_hv_vcpu_flush_tlb(struct kvm_vcpu *vcpu)
        count = kfifo_out(&tlb_flush_fifo->entries, entries, KVM_HV_TLB_FLUSH_FIFO_SIZE);
 
        for (i = 0; i < count; i++) {
+
                if (entries[i] == KVM_HV_TLB_FLUSHALL_ENTRY)
                        goto out_flush_all;
 
-               if (is_noncanonical_invlpg_address(entries[i], vcpu))
-                       continue;
-
                /*
                 * Lower 12 bits of 'address' encode the number of additional
                 * pages to flush.
                 */
                gva = entries[i] & PAGE_MASK;
-               for (j = 0; j < (entries[i] & ~PAGE_MASK) + 1; j++)
+               extra_pages = (entries[i] & ~PAGE_MASK);
+
+               if (is_noncanonical_invlpg_address(gva, vcpu) ||
+                   is_noncanonical_invlpg_address(gva + extra_pages * PAGE_SIZE))
+                       continue;
+
+               for (j = 0; j < extra_pages + 1; j++)
                        kvm_x86_call(flush_tlb_gva)(vcpu, gva + j * PAGE_SIZE);
 
                ++vcpu->stat.tlb_flush;

