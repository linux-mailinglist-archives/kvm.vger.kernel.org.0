Return-Path: <kvm+bounces-70311-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QJ1zE8xYhGl92gMAu9opvQ
	(envelope-from <kvm+bounces-70311-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 09:46:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AD3B6F0015
	for <lists+kvm@lfdr.de>; Thu, 05 Feb 2026 09:46:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A15B830125D5
	for <lists+kvm@lfdr.de>; Thu,  5 Feb 2026 08:45:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C2EC31AF36;
	Thu,  5 Feb 2026 08:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fQQ7DqjT"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B6739FD4;
	Thu,  5 Feb 2026 08:45:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770281148; cv=none; b=RyNU8h9TIBBHryAoT/kPNnXjvPQul5BDbnMce9OQogoum40rV5W2H5/nVLDfCsJdgs0E2hrPkKLqdF3bL3SkgYhk+1vmDPqFY1c38Iw7OAmoTavY2ALmg11bj/JR2PNlKHKxd9gpN/W3HJbSTVRdvB2MC+Q+A6d7G4aESLpM5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770281148; c=relaxed/simple;
	bh=g9RuaGYqUYBnwLnrwzUoVTNzFaCa3kHkguYYbxgeL9o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BehRjDWU4pPJdqDWM7nT5eTdD4bKOh2QhFJ6jltJdJG7RMCMGjgturzVrFmBBvxwYdwn74CkAKe+xtyMqFedZxOX/V/hJQcDD5cTDyaFlJOo9QJ2+gJLU9GugICuv1QWwh3Bm51WbBHCrkZIkdW2jTnu0Hj3D8ALMpbpOJhswC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fQQ7DqjT; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fugNcIq91z91zlP18EL4UwOiWpTOJo086a+OO6V5k0k=; b=fQQ7DqjT6Sde/WdpJkoeFuhQrx
	m2xzlztr1g+INZLnpQK/Oa/KDLrOrn8s94pFRnPi2obcXCEJEcbXRjJg7tULOGgTaiZm2hOk9L2E9
	BFN+ulIy5us/hgxdzTP8pxgiuD2p5wnocAW3xXbkRxbweBVwjKPMKM5I6NpByGocdCRtlKwmGXdfi
	TL2qc/4v5CuBITQhtENgGHSHed9CKHWeYwrY0VoiRM/9mdw+r1ydooM0Bi8uT0N7VkZ1OUe6wHB1e
	y0PU2Mgmh2z8kCO/wb3E6/HyQVS1mJ1qiIRnQ1suFVqtjTKIE98yDjcwx+fxXn/DTvInI3NKLMlpq
	Uk9TS/5A==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vnuze-00000001n2I-1Ize;
	Thu, 05 Feb 2026 08:45:43 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id C3C8C300BD2; Thu, 05 Feb 2026 09:45:41 +0100 (CET)
Date: Thu, 5 Feb 2026 09:45:41 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [PATCH v2] s390: remove kvm_types.h from Kbuild
Message-ID: <20260205084541.GD232055@noisy.programming.kicks-ass.net>
References: <20260205073119.1886986-1-rdunlap@infradead.org>
 <20260205075144.7870B7f-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205075144.7870B7f-hca@linux.ibm.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[infradead.org,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[infradead.org:s=desiato.20200630];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[infradead.org:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70311-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[peterz@infradead.org,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TO_DN_SOME(0.00)[]
X-Rspamd-Queue-Id: AD3B6F0015
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 08:51:44AM +0100, Heiko Carstens wrote:
> On Wed, Feb 04, 2026 at 11:31:19PM -0800, Randy Dunlap wrote:
> > kvm_types.h is mandatory in include/asm-generic/Kbuild so having it
> > in another Kbuild file causes a warning. Remove it from the arch/
> > Kbuild file to fix the warning.
> > 
> > ../scripts/Makefile.asm-headers:39: redundant generic-y found in ../arch/s390/include/asm/Kbuild: kvm_types.h
> > 
> > Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> > ---
> > v2: add more Cc:s
> > 
> > Cc: kvm@vger.kernel.org
> > Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> > Cc: Sean Christopherson <seanjc@google.com>
> > Cc: Paolo Bonzini <pbonzini@redhat.com>
> > Cc: Heiko Carstens <hca@linux.ibm.com>
> > Cc: Vasily Gorbik <gor@linux.ibm.com>
> > Cc: Alexander Gordeev <agordeev@linux.ibm.com>
> > Cc: Christian Borntraeger <borntraeger@linux.ibm.com>
> > Cc: Sven Schnelle <svens@linux.ibm.com>
> > Cc: linux-s390@vger.kernel.org
> 
> The additional cc's still miss Peter :)
> 
> https://lore.kernel.org/all/20260205074643.7870A22-hca@linux.ibm.com/

I managed to invoke the right b4 incantation and it should be applied to
tpi/perf/core.

