Return-Path: <kvm+bounces-71712-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id sFCJIEo7nmkZUQQAu9opvQ
	(envelope-from <kvm+bounces-71712-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 00:59:06 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1644218E360
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 00:59:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F1649305A6C2
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 23:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36254364036;
	Tue, 24 Feb 2026 23:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dMeVcH4W"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69BCC34CFCB
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771977530; cv=none; b=G/0S9W9lIklSgcr26vHxBArZ/JkujBxKI90PxgIQ77+W2FAtNz4uiwyIqXPb5jpeFAgudQeI2iErmytld5SPkMOY/xIx4LE5dPXrnehtUR6056meBjsC1NJ+TCuU+p8BmxveHso7gFM4dFvH9rqIlQ19ZgB+jNKX/xf2GfTfUH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771977530; c=relaxed/simple;
	bh=1hZ09gpBg3VxEVvQ/Q7NWvATkzz701KmBrmzFwCUlTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s/VCf0k7gFViFRvnqAJZqlEhB3dakfbcFq0K3zaPVBCpmm8Ck/wpiaSD9aFIEG7r/cdBBfUxpK3fc1R+oWxqUJaMgGVLDcYpZwItCtGcb7VtzsH3hnkDREe9xbhqvDwSFyEFe2zPm7Ft6SOR62gh5YDdQbzqmaQA2DBBc5OrfoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dMeVcH4W; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10751C116D0
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 23:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771977530;
	bh=1hZ09gpBg3VxEVvQ/Q7NWvATkzz701KmBrmzFwCUlTg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dMeVcH4WPUEvz+jpiMu20Z/UDAFQhvcGtGyOlowm/uju+HHN1ANEP6OhCf+jGOY/Z
	 d+7g5ZvP9ZEkn+TAkDJPbO4Hlbsn/OL+TDhjvlXbEqKQ7JUMwd1jFZj+oS+LulJ82y
	 iKkEsE/CFxfhWkR9p9R4WInBQQ8IizWa5PLvBvUPqhe4tRxDNxTAjwCU89rcBMghPX
	 LzGzwLMDmrXxlmnb0ZsWHrMwyQ9Z8IvtWqMbd2yF2O5m38pn+zpWFIp8ibJW3xnLwT
	 zajqYiJWSU52fWucWzZa4Xzj8LJ+JUV8GAF1DO71OXV5CtCRGpC61E8EP/E68NyHT/
	 wNuryagFVfkFw==
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b8f96f6956aso845381666b.3
        for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 15:58:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVTDz62aGM5IlZKWpetLu8PRfZJh5voxxIQYKdM6/WR7WHSTyXOQozwqfFCYw2hTs1oYSI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4RBQFshpB2AVzvSh/a/299BMhauWMyLZBTfyFi0vNJskk3dfI
	frxIfW4oVKwjJ1vlMLAElc2AuejpL5O+lsh/ef5YyHhxsIrgWdbTgeYd4husYliF0OqrWYU8xca
	j6PtJQN5UGB50BGX21Z0Umem10UAzRjI=
X-Received: by 2002:a17:907:960c:b0:b8a:fa35:989f with SMTP id
 a640c23a62f3a-b9081b3e5f0mr837382666b.38.1771977528918; Tue, 24 Feb 2026
 15:58:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260224223405.3270433-1-yosry@kernel.org> <20260224223405.3270433-26-yosry@kernel.org>
In-Reply-To: <20260224223405.3270433-26-yosry@kernel.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 24 Feb 2026 15:58:37 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMwNEkmt9+RKP34hpSSzavyL6CLGuWj=rx4R4i1kzhSgQ@mail.gmail.com>
X-Gm-Features: AaiRm513oNEUi9hUjQRRXFADiAg2OnpP3oTeqyZEAPSTrOvGfUn9-7ZVNNDYW3s
Message-ID: <CAO9r8zMwNEkmt9+RKP34hpSSzavyL6CLGuWj=rx4R4i1kzhSgQ@mail.gmail.com>
Subject: Re: [PATCH v6 25/31] KVM: nSVM: Cache all used fields from VMCB12
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	URIBL_MULTI_FAIL(0.00)[mail.gmail.com:server fail,sea.lore.kernel.org:server fail];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71712-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry@kernel.org,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 1644218E360
X-Rspamd-Action: no action

> @@ -715,48 +732,48 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
>                 svm->nested.force_msr_bitmap_recalc = true;
>         }
>
> -       if (unlikely(new_vmcb12 || vmcb_is_dirty(vmcb12, VMCB_SEG))) {
> -               vmcb02->save.es = vmcb12->save.es;
> -               vmcb02->save.cs = vmcb12->save.cs;
> -               vmcb02->save.ss = vmcb12->save.ss;
> -               vmcb02->save.ds = vmcb12->save.ds;
> -               vmcb02->save.cpl = vmcb12->save.cpl;
> +       if (unlikely(new_vmcb12 || vmcb12_is_dirty(control, VMCB_SEG))) {

Internal AI review caught a bug here. We only copy clean bits in
__nested_copy_vmcb_control_to_cache() if Hyper-V extensions are used,
so this patch will treat everything as dirty. Not a correctness bug,
but a perf one. Probably need the following:

diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 2159f5fbfc314..3c9643c03b1a4 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -524,11 +524,11 @@ void __nested_copy_vmcb_control_to_cache(struct
kvm_vcpu *vcpu,
        to->asid           = from->asid;
        to->msrpm_base_pa &= ~0x0fffULL;
        to->iopm_base_pa  &= ~0x0fffULL;
+       to->clean = from->clean;

 #ifdef CONFIG_KVM_HYPERV
        /* Hyper-V extensions (Enlightened VMCB) */
        if (kvm_hv_hypercall_enabled(vcpu)) {
-               to->clean = from->clean;
                memcpy(&to->hv_enlightenments, &from->hv_enlightenments,
                       sizeof(to->hv_enlightenments));
        }

