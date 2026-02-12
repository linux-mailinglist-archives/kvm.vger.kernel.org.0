Return-Path: <kvm+bounces-71013-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4NA2Ma9DjmmPBQEAu9opvQ
	(envelope-from <kvm+bounces-71013-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:18:39 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 89D74131305
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 22:18:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F3E76306C7DB
	for <lists+kvm@lfdr.de>; Thu, 12 Feb 2026 21:18:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9039232C33F;
	Thu, 12 Feb 2026 21:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jGUY/XZq"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A8C205E3B
	for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 21:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770931107; cv=none; b=IKl6A1R2MQiTSD8u54Rhlsjj4T+SveRYjn//knmxzpy3/SIYV/E7bBLjVYJY98ygzc6uaUtQNj5c+F/p4MjUzDShfTAewY5w/cA5Ditco4LUMdom7fSrMXPwy1/03bMuyr1/z8qa8M0BJ7/TkHxQtahvo+N9hW4sbGm+3yLvpKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770931107; c=relaxed/simple;
	bh=93r6rq1czHnX8/8tt4tXPL4Wx8lNSzgeFQPMg/+I/fw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=i/DzIJ3WODseAr4uBTFpzGspf1lAas9Ip9vzk3ctYONd/o8IYtDlECmUMgqGxofghEW0ceSKe/R2lB8vMmjVyPy3eb1VKkArcn7LU6kDm3NcAeGLFGAyKK30vZRE/SEJTDykd85MMHRf/x9ZaPVQypK5DwtzjZPvnPdYBHiGHfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jGUY/XZq; arc=none smtp.client-ip=209.85.216.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35449510446so224481a91.0
        for <kvm@vger.kernel.org>; Thu, 12 Feb 2026 13:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770931106; x=1771535906; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rQIvaW1dQkOQtfQr2mtZP5JGWAsXUY8BUQ9NRLDAah0=;
        b=jGUY/XZqbq+q/h39Hd+OJFoFodvxZ9kMaeQAR05NvGNG8z9Fnrm480tgnlchNqRZzr
         60Cjyt2Ep/EH2y96SZJhwkC9qa/13xrryssWWQHEO1WgVJupNjWIuS/KSLZGYoqqOgkG
         vnbR2jLffMaIHWwwIL4gwrnWExiVppb/caJEQANaka2lXkpvmt/5naVHYjaJg6jOdaTL
         p1KbhJz4FbEbVs4t2S+JjwbYFTIMTDF8ueIYJJ4AKEizWRw1Fmir4lKo+mIgDgBPA8pJ
         1zOcngPWVLZii36h4O+KOvgrdoDowyj3rUMhmfzY0Fi/xpjlhOn+zGvboNAPs0sqLW79
         XQpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770931106; x=1771535906;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rQIvaW1dQkOQtfQr2mtZP5JGWAsXUY8BUQ9NRLDAah0=;
        b=MWfST7UO44T/yfLkw+YhnWRhWcgKxDL2TjVyCJegCgnJQy+leneiHjkO1chUY0FATo
         /4G+4CH7hQCY3ruBXO3oMU3i3DLJH29U8ifKaaK5yLCJoYnBmyzCVp5QS7ZyQdX4sS2k
         wDEWastHSPFUwOK5Uoo5o6BopPUJNvj0welV2K0QdlTor/7XcbhgcbHdhMVZ9CZS/uKM
         ylTyc15bNZMlZYYMVmOTkjdY22JxG4vMwASb9jLJDmVnX+mQwS/bnzMmfOF2K2W+vPXN
         tQQn4pIm6JLP0qQm8iGPrcQinr4uud6UFgE4QS6yysXbanw/f/cwq4ecsZs2J4h9QuPQ
         +0Yg==
X-Forwarded-Encrypted: i=1; AJvYcCVTddTfdOUoB0llU6T60PIwohiz7UDPWXgALio0t7Am7G3xhNXtct1Q2OFCOY680rfVRuw=@vger.kernel.org
X-Gm-Message-State: AOJu0YyBoGf/eiUA7DEs5MSAK/499F6n7VdLeWWRmNr2WykT8s3p2hey
	VgoGYkq3G/Wby5KgdnhroumNCcCIbgbPp56Ly2VTTO/bXtjxRNA1XIbZLeUjNhTaR3gCPsYwoIz
	MG99oog==
X-Received: from pjsh12.prod.google.com ([2002:a17:90a:2ecc:b0:354:c3a6:280d])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3dc6:b0:354:a57c:65db
 with SMTP id 98e67ed59e1d1-356a7aa26a6mr355645a91.20.1770931106029; Thu, 12
 Feb 2026 13:18:26 -0800 (PST)
Date: Thu, 12 Feb 2026 13:18:24 -0800
In-Reply-To: <aY5DHUQl3jWnk3TN@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260122045755.205203-1-chengkev@google.com> <20260122045755.205203-3-chengkev@google.com>
 <aY5DHUQl3jWnk3TN@google.com>
Message-ID: <aY5DoEINs4PhXv7_@google.com>
Subject: Re: [PATCH V3 2/5] KVM: SVM: Inject #UD for STGI if EFER.SVME=0 and
 SVM Lock and DEV are not available
From: Sean Christopherson <seanjc@google.com>
To: Kevin Cheng <chengkev@google.com>
Cc: pbonzini@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71013-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 89D74131305
X-Rspamd-Action: no action

On Thu, Feb 12, 2026, Sean Christopherson wrote:
> On Thu, Jan 22, 2026, Kevin Cheng wrote:
> > The AMD APM states that STGI causes a #UD if SVM is not enabled and
> > neither SVM Lock nor the device exclusion vector (DEV) are supported.
> > Support for DEV is part of the SKINIT architecture. Fix the STGI exit
> > handler by injecting #UD when these conditions are met.
> 
> This is entirely pointless.  SVML and SKINIT can never bet set in guest caps.
> There are many things that are documented in the SDM/APM that don't have "correct"
> handling in KVM, because they're completely unsupported.
> 
> _If_ this is causing someone enough heartburn to want to "fix", just add a comment
> in nested_svm_check_permissions() stating that KVM doesn't support SVML or SKINIT.

Case in point, patch 4 is flawed because it forces interception of STGI if
EFER.SVME=0.  I.e. by trying to handle the impossible, you're introducing new
and novel ways for KVM to do things "wrong".

