Return-Path: <kvm+bounces-70261-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8LSxDUyQg2lCpQMAu9opvQ
	(envelope-from <kvm+bounces-70261-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:30:36 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C3782EBAAF
	for <lists+kvm@lfdr.de>; Wed, 04 Feb 2026 19:30:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id A13F43006799
	for <lists+kvm@lfdr.de>; Wed,  4 Feb 2026 18:30:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2842427A05;
	Wed,  4 Feb 2026 18:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DBcqGNdp"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FBA2427A03
	for <kvm@vger.kernel.org>; Wed,  4 Feb 2026 18:30:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770229832; cv=none; b=NUYuIwDlwVW+Br7M+4ytH73tCcrDo3Rl0GRPs8oWjg3JjGLvIij9LPw2lKL2M9lD9KE4f6jjC19qEDyx4aAVMVx3lDk4fPRN51cCDsvfNCU0Ec0/VmCNuouCr8NZYxahLgbktbPCm0rPMvFlbkGxUjK0P+buqHSY1kRz9yVzrSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770229832; c=relaxed/simple;
	bh=9vCUfVJxy88yJolV/N2/ynVlDk12SGIFXom5P3qNZwk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ERO/qvwtNE6d3jzuVSmUsAGxowy5dyzr2u02ojs7ehaoHlXn656Ak8G+M5fV8zhhSw8TYFjIsoiquYg8H9MC0M08E49aog0WhX8G8gvMDirUAEkc/aEJ3NQBwTlTroH+CcVo0g43pt+uFMZpygbSYQeB4oxHB6QsNHHh/JntlHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DBcqGNdp; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Wed, 4 Feb 2026 18:30:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770229830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iYoD/3j+PTdqFG3avWr+dBfV/T1KKvzGCclPHdrs5lQ=;
	b=DBcqGNdpMiKbwQAmqmVB+2WPLSYtiEUMjMB35RQE4pTrttw9Zx6Q0xNGsgAYrToCYNRhvH
	iTU68CuCxIkkbdqFsTOx89uIo0y3yEXcRGK3z098W4fM3iBtq8Qrvagqn+iTVb6m934Taf
	2Es9lJkq39e+V8X6rBvDefrYLNK85R0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Kevin Cheng <chengkev@google.com>, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] nSVM: Minor cleanups for intercepts code
Message-ID: <zdqwo6kr2ftkb64dp4irbw5jakxrrg6qhzf5ibamrfhqek4wrw@rzp2p7luf6xd>
References: <20260112182022.771276-1-yosry.ahmed@linux.dev>
 <aYOGNr6Tag6tU9HP@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYOGNr6Tag6tU9HP@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70261-lists,kvm=lfdr.de];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.dev:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: C3782EBAAF
X-Rspamd-Action: no action

On Wed, Feb 04, 2026 at 09:47:34AM -0800, Sean Christopherson wrote:
> On Mon, Jan 12, 2026, Yosry Ahmed wrote:
> > A few minor cleanups for nested intercepts code, namely making
> > recalc_intercepts() more readable and renaming it, and using
> > vmcb12_is_intercept() instead of open-coding it.
> 
> I'll send a v2.  Fixing the vmcb_mark_dirty() bug yields a fairly different
> overall sequence:

Sounds great to me :)

> 
>   KVM: SVM: Explicitly mark vmcb01 dirty after modifying VMCB intercepts
>   KVM: SVM: Separate recalc_intercepts() into nested vs. non-nested parts
>   KVM: nSVM: WARN and abort vmcb02 intercepts recalc if vmcb02 isn't active
>   KVM: nSVM: Directly (re)calc vmcb02 intercepts from nested_vmcb02_prepare_control()
>   KVM: nSVM: Use intuitive local variables in nested_vmcb02_recalc_intercepts()
>   KVM: nSVM: Use vmcb12_is_intercept() in nested_sync_control_from_vmcb02()

