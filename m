Return-Path: <kvm+bounces-71554-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id gKfBESbznGkvMQQAu9opvQ
	(envelope-from <kvm+bounces-71554-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:39:02 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CD70F18046A
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6047A3113F7F
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:38:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AB37231830;
	Tue, 24 Feb 2026 00:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zKoqDksO"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D7822D4C8
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771893486; cv=none; b=pVodcdU/Sv5mjxWLgybKBGv1MsgJrIQMM+rlNqymXRkDJ1q0Ogis+omtTmcavX2gHSsIUSqRNT43Vwl1Ak/VMV+NZX5UiaC2STo9Pod57q2PF+LahMYryTjCw8pnO+0k+hqMA8QiIOrdbq7z8E5LXWeK2yr4nlJ/KX4GalhiO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771893486; c=relaxed/simple;
	bh=95et0iiZOFvEmrwQk1B0aEKVgA5Luw2xyZ7YltWllHw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VErnv0Ih/OyChm6f6fXuXeITBrc26pd7E5nVzrDL9MRTTUrY/myFOFYlcvlbldZgktviAnIu7l2O/O6N0ZEx3cmBSPaFpZQjfgOgZWHqlooCZsES0POkBb2d37rCSapfu92upaf097FW8Bqa4gkor2KH6l9knwiBfv1pTXE/aV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zKoqDksO; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2ad7e454f38so210627745ad.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771893484; x=1772498284; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mRUtYfiuCHkE01sKVfZHqk1HVPwnQ18HuftgTQ+yBvY=;
        b=zKoqDksOgtZ+EHEyMXmGtvjdFyR+nXBkGjpV3iRQBgPirCiu+7sAn3JpbaYU8r00+T
         OPUWLBvuXGpBV5AM3NdvZU91FPE42VG9od5T7dQC7/Wcb7WW5hJR4dwmw4teiVhnQsts
         gEpmcvFCHcpoC2IDXG/o1y6sXDKcq1ZiZAyLhTQZxB+acA7fq+fL3DyYu927E0p8HFNN
         0CYwA5uL6D3TAiUBusV8Jbo+jUhp3i3S/mGD61SaVSHF2Ud0jhBF+muR3/3uED5be9bW
         nVypl8g3vSLLoSr56lyMJs54YcHjvShIMiLPn64y2xa1Zv5XnFGyin7cSckn/g7IX1zt
         SzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771893484; x=1772498284;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mRUtYfiuCHkE01sKVfZHqk1HVPwnQ18HuftgTQ+yBvY=;
        b=UKGQ/2oR0o0SElfrqVD5tKlS0hAQWpbFRmSaGPpsVsA2HiqkvbRbvrcQZx3qCs6OH0
         yavsojBTAOyHlb8tlSl2NMx3OKfQuH1AGElPhVJPUm112mYvSPQkxjTCWjy3TZjXAfoY
         W4+XBmOFTKJWKRsSJ3zDmRph3oUDF/SjnP7LB3dCp0rNeJPpycecPhsBDXPxcrM0qf/f
         ZYKEX6ZrFnHB2/ZWzAcM4a3mfcbFKtJiwKcKbi/BNIZSNfIPqwgVEYox1qVf+qUFBn9B
         T5U5lEul58u4xFj5N3wZaYUguEWyKoYFshwK2x4Ib/PJjL106CGk1QyciclqrLo2ies/
         Xj/g==
X-Forwarded-Encrypted: i=1; AJvYcCWqQsH9RWouLQAOhL+yQzpJRLKb1Bz1eRn5/qZKtuB7d9ZBNJ8zo4AGalFJk0EPDPAj7pA=@vger.kernel.org
X-Gm-Message-State: AOJu0YyQOT/hM0ovabPeS0nRCjpZw+Pk8w6rq67bb56tQHqmnHCmbgj4
	rqfjI/5YADNVLajumktO21pMMlia2NSqBWlkhptl3lnTMS2N4Vk74hFNQmKzoGIJaiOBMlxJ+FX
	FLMk/yw==
X-Received: from pjbay5.prod.google.com ([2002:a17:90b:305:b0:352:de4e:4038])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2acc:b0:2a0:9755:2e97
 with SMTP id d9443c01a7336-2ad7444c497mr102963395ad.15.1771893483878; Mon, 23
 Feb 2026 16:38:03 -0800 (PST)
Date: Mon, 23 Feb 2026 16:38:02 -0800
In-Reply-To: <20260206190851.860662-8-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260206190851.860662-1-yosry.ahmed@linux.dev> <20260206190851.860662-8-yosry.ahmed@linux.dev>
Message-ID: <aZzy6mIkYunIUyZV@google.com>
Subject: Re: [PATCH v5 07/26] KVM: nSVM: Triple fault if restore host CR3
 fails on nested #VMEXIT
From: Sean Christopherson <seanjc@google.com>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	MV_CASE(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71554-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[google.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CD70F18046A
X-Rspamd-Action: no action

On Fri, Feb 06, 2026, Yosry Ahmed wrote:
> @@ -1140,7 +1140,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>  
>  	if (kvm_vcpu_map(vcpu, gpa_to_gfn(vmcb12_gpa), &map)) {
>  		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);
> -		return 1;
> +		return;
>  	}

And then here I think we can do the same thing, e.g.

	if (nested_svm_load_cr3(vcpu, vmcb01->save.cr3, false, true))
		kvm_make_request(KVM_REQ_TRIPLE_FAULT, vcpu);

