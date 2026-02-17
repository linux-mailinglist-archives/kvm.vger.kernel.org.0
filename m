Return-Path: <kvm+bounces-71162-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aFeOB/eXlGkoFwIAu9opvQ
	(envelope-from <kvm+bounces-71162-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:31:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 4950714E338
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 17:31:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BD44E30074C6
	for <lists+kvm@lfdr.de>; Tue, 17 Feb 2026 16:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D485B36EA95;
	Tue, 17 Feb 2026 16:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FLFrbygh"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1A92DF136
	for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771345905; cv=none; b=hVUjmfOXRDOf5EsSsq6yA3ldIs+xV0st4OZ2oQh3FsOSrkGwlfyySIRMKQ5f5mPqSIHBZMMmtwXsdYFIpmVN2XahS7xoKDkNMbDSKEfqlk8WLD5FNFDH1WbOeMfveIQck5kkofVlQtZNFqPmtJkF00ghuef9mYNvDntx1pJ9jlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771345905; c=relaxed/simple;
	bh=SGREBuuKhZojW/qxb3YvvKLZ4Emj2RxLhOOQtbx0/ag=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=aiOv9GN83OJ7Bb0f07fkyZeP854cZcasgoZL9/mr5ns8jHUmhfVoRzvfBugOSFK2j6zNXMu2SN9bRBZjgteCRqAG1gj+7JPffh9LQshnxRrLRgNqhDXjILO9e0ozmK+y7fav56HJHBYXEwdXy68bp3nCX7sMfx0TR10JYDuKKX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FLFrbygh; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a79164b686so58001555ad.0
        for <kvm@vger.kernel.org>; Tue, 17 Feb 2026 08:31:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771345902; x=1771950702; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3VZfOz+HSVZa7yIGW57B4e3fv7GIVEIIOWdcsv8P8bE=;
        b=FLFrbyghd5p5Pu7OhJZNo3LLDlG1GvUzlaLBp4sH3GSwMFB9Ae8O9fDImkqDQb/b81
         WjR3lVm6BbC/XdJNcQlcbqOzet8Rf21+tK9Pp/+bjIHz3cQUXmSaB6/KCINfLwBSGrJy
         gTpy0eYR1Us/6mEznPt1jaX9/969KRNIcEKFhoD6jq4HQ3SglrIwaAqkFHFQFT2nVPhu
         Zq+TPZSEmddM5VuoHu2YhU+Cz9nQ7ILCDedc1zbaZ7LLq/wnaAc3NW0pg/eT5ZEMhTyZ
         e/UFHk8C2Xv9/ORvnuKaEdQQRyxaywbwxdWFp1tRI1VFigxTD7cPsgQCBwhn833BbTeb
         H1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771345902; x=1771950702;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3VZfOz+HSVZa7yIGW57B4e3fv7GIVEIIOWdcsv8P8bE=;
        b=rMgi3pm1Kvxt0grz8zWmOPMkZQQ5LgZpmYh2ZNBM0Kt1ozZlsz890KbIIubODk1qZ8
         fpkztvR9pz1fg7JWxX63mMJx2lOYlPKBxz6uhf2EKpxh5TxlFXIPLJipdqHFIf+EukR0
         fdVNielVWRHC5V/VjEfkNLbe7F/BOfWFGX7xC4RXh6UDz5PaMXhc0WVJ6lNSmVdcATu9
         Aji12YdVJs5d9PVfAgxRq96Um2e9BDkshBXOCht1rDhmGrdmb17COhJSoCwQmCOrxsE3
         7xMkceBTNrEiQIA4iYYmQ5Y58je1JVcqqJaNvNEtC89pJor4uy4dcd4DL4tnTH2b4KLf
         2FHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnqng9W9VMpL19TBY1fN09VZ53n5pzBXyLEXIoz0COS1m1VAg2whYup4NeX0QHVrpJ/aE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOIrm24hxu7qUjp3QAHkn/AyA56KFi57GZCoGqKQfQsayHje3g
	t9VD8rceUY8WjPtkJon08+q9YUJ9eUTbsW9OmSP3+8wOb7yUsuaciZW95SPh2DCDdo0TAzcsneg
	fz1NmDw==
X-Received: from plbmi8.prod.google.com ([2002:a17:902:fcc8:b0:29f:1bbb:de14])
 (user=seanjc job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:3843:b0:2aa:d671:e613
 with SMTP id d9443c01a7336-2ab50586724mr116397175ad.38.1771345902214; Tue, 17
 Feb 2026 08:31:42 -0800 (PST)
Date: Tue, 17 Feb 2026 08:31:40 -0800
In-Reply-To: <699383e5939ed_2f4a1006f@dwillia2-mobl4.notmuch>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260214012702.2368778-1-seanjc@google.com> <20260214012702.2368778-6-seanjc@google.com>
 <699383e5939ed_2f4a1006f@dwillia2-mobl4.notmuch>
Message-ID: <aZSX7OU58Gj0fQSy@google.com>
Subject: Re: [PATCH v3 05/16] x86/virt: Force-clear X86_FEATURE_VMX if
 configuring root VMCS fails
From: Sean Christopherson <seanjc@google.com>
To: dan.j.williams@intel.com
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	Kiryl Shutsemau <kas@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-coco@lists.linux.dev, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, Chao Gao <chao.gao@intel.com>, 
	Xu Yilun <yilun.xu@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MV_CASE(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-71162-lists,kvm=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	RCPT_COUNT_TWELVE(0.00)[17];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[seanjc@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,intel.com:email]
X-Rspamd-Queue-Id: 4950714E338
X-Rspamd-Action: no action

On Mon, Feb 16, 2026, dan.j.williams@intel.com wrote:
> Sean Christopherson wrote:
> > If allocating and configuring a root VMCS fails, clear X86_FEATURE_VMX in
> > all CPUs so that KVM doesn't need to manually check root_vmcs.  As added
> > bonuses, clearing VMX will reflect that VMX is unusable in /proc/cpuinfo,
> > and will avoid a futile auto-probe of kvm-intel.ko.
> > 
> > WARN if allocating a root VMCS page fails, e.g. to help users figure out
> > why VMX is broken in the unlikely scenario something goes sideways during
> > boot (and because the allocation should succeed unless there's a kernel
> > bug).  Tweak KVM's error message to suggest checking kernel logs if VMX is
> > unsupported (in addition to checking BIOS).
> > 
> > Signed-off-by: Sean Christopherson <seanjc@google.com>
> [..]
> > diff --git a/arch/x86/virt/hw.c b/arch/x86/virt/hw.c
> > index 56972f594d90..40495872fdfb 100644
> > --- a/arch/x86/virt/hw.c
> > +++ b/arch/x86/virt/hw.c
> [..]
> > @@ -56,7 +56,7 @@ static __init int x86_vmx_init(void)
> >  		struct vmcs *vmcs;
> >  
> >  		page = __alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> > -		if (!page) {
> > +		if (WARN_ON_ONCE(!page)) {
> 
> Is the warn_alloc() deep in this path not sufficient? Either way, this
> patch looks good to me.

Not sure, I don't have much experience with warn_alloc() in practice.  Reading
the code, my initial reaction is that I don't want to rely on warn_alloc() since
it's ratelimited.  Multiple allocation failures during boot seems unlikely, but
at the same time, the cost of the WARN_ON_ONCE() here is really just the handful
of bytes for the bug_table entry.

