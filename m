Return-Path: <kvm+bounces-68139-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BBCAD22023
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 02:24:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FBE7307CA49
	for <lists+kvm@lfdr.de>; Thu, 15 Jan 2026 01:22:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B55C20E31C;
	Thu, 15 Jan 2026 01:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="oh0YC/1v"
X-Original-To: kvm@vger.kernel.org
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDFF32F872
	for <kvm@vger.kernel.org>; Thu, 15 Jan 2026 01:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768440148; cv=none; b=l1zet5wB+eGsp5D6EGCO1+9I9xEpE67YmX+HsKR241hThvP/EPsOCnkbdwIukB6ZjkxixbCFaHyUA702GH/mH4iSOmNaNsXuYQvLAKGdbBDTyX/BtndRulVQGiet4qrt0JwmtGFsVvVLKO4xfRrmmspo1xJaUSspWntLnGikyTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768440148; c=relaxed/simple;
	bh=N1J0f/iFcs43ebyqYTOa0fi+17nR1YvFDrUkobPK4bw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uxVOuMSLPuXLcLmYKnRmWYpVzoxO255tolLn1hPkVqJGHoqrf07DEvnUV3itW1r3zSTkHxl50Yow/A+ZhuQele6wzwO2nSQcICRhEPLy7y4OrJ4CGhDK7DUfeXH7CIYeKuEQKQCITAFBfW3XgocSig7sNFrHOn/eZxoz4hiGUBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=oh0YC/1v; arc=none smtp.client-ip=91.218.175.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 15 Jan 2026 01:22:21 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768440145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rShAFDMi2rOQoa5IIqmo5MxTSGnHRqDV1Mi6Q3ot2y0=;
	b=oh0YC/1vub3zttiko5ARP65Sp739mxDwEGo1OOuZBv8ntamIa558+gIERHuq5Ba4PT7uZs
	raLNY/qw/nLtYWys3OSpyChppuJe6wXbH/WM03mawo6hZV85KVnyNS1qGD4y7JiC5qCON2
	4LHEQedGtQZrL04PLAtodph2RURZLD4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: bugzilla-daemon@kernel.org
Cc: kvm@vger.kernel.org
Subject: Re: [Bug 220964] New: nSVM: missing sanity checks in svm_leave_smm()
Message-ID: <zfj3qetsr454pgifwcxchnoxld4udzltf7wu6zh4javwknjagc@ctudrrld3dn6>
References: <bug-220964-28872@https.bugzilla.kernel.org/>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bug-220964-28872@https.bugzilla.kernel.org/>
X-Migadu-Flow: FLOW_OUT

On Sat, Jan 10, 2026 at 08:03:07PM +0000, bugzilla-daemon@kernel.org wrote:
> https://bugzilla.kernel.org/show_bug.cgi?id=220964
> 
>             Bug ID: 220964
>            Summary: nSVM: missing sanity checks in svm_leave_smm()
>            Product: Virtualization
>            Version: unspecified
>           Hardware: AMD
>                 OS: Linux
>             Status: NEW
>           Severity: normal
>           Priority: P3
>          Component: kvm
>           Assignee: virtualization_kvm@kernel-bugs.osdl.org
>           Reporter: max@m00nbsd.net
>         Regression: No
> 
> In svm_leave_smm():
> 
>     svm_copy_vmrun_state(&svm->vmcb01.ptr->save, map_save.hva + 0x400);
> ...
>     nested_copy_vmcb_control_to_cache(svm, &vmcb12->control);
>     nested_copy_vmcb_save_to_cache(svm, &vmcb12->save);
>     ret = enter_svm_guest_mode(vcpu, smram64->svm_guest_vmcb_gpa, vmcb12,
> false);
> 
> map_save.hva and vmcb12 are guest mappings, but there is no sanity check
> performed on the copied control/save areas. It seems that this allows the guest
> to modify restricted values (intercepts, EFER, CR4) and gain access to CPU
> features the host may not support or expose.

This was reported by Sean in
https://lore.kernel.org/kvm/aThIQzni6fC1qdgj@google.com/.

I think the following patch should fix it:
https://lore.kernel.org/kvm/20260115011312.3675857-14-yosry.ahmed@linux.dev/.

> 
> nested_copy_vmcb_control_to_cache() and nested_vmcb_check_controls() ought to
> be combined into one function, same with nested_copy_vmcb_save_to_cache() and
> nested_vmcb_check_save(), to eliminate the risk that a copy is made without
> sanity check.
> 
> -- 
> You may reply to this email to add a comment.
> 
> You are receiving this mail because:
> You are watching the assignee of the bug.

