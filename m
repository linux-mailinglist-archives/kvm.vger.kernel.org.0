Return-Path: <kvm+bounces-70457-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8NWLCE0Rhmk1JgQAu9opvQ
	(envelope-from <kvm+bounces-70457-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:05:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2491E100029
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 17:05:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 75BB0300E44D
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 16:05:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12F17305E28;
	Fri,  6 Feb 2026 16:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kbzg0cdJ"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96CD7301465;
	Fri,  6 Feb 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770393910; cv=none; b=hkWLBHu6H9kHZG5Cj7Az45p9bnzsK1YAd1Pk4nqXAMIciqESZ2TtSnzGmbSaa7FgCVGgxJK/9VvyTxShfIV+qp3UleWoWqhT0dytKtVHEFqe7g8VsnpBJzMy9C6sGt4ximDxWLuSsWJYNpvyfq/PwxFRCctC+u1bvDiOuNsyvDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770393910; c=relaxed/simple;
	bh=1bOmNc9DmWiLB6nVSU6Ki7sQyWSJAIyCy7FV8VTbnv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bh3veoBL4yvi7rRBQd9FgJJqBANVs+ui6FbRTnc+8q/J+Tvcx26igZn3y6z/736zR6qi2i6AXDsAulCLGVHt9tW3PVvGvrV1fzjcnZt7xYiJqVRsqxNsl7MXsjstrcomq3kXszFkSew8XvWJM66vHRfHMQ1qBkvUiUhCNONN/aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kbzg0cdJ; arc=none smtp.client-ip=91.218.175.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Feb 2026 16:04:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770393907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=sxhE4THCAs7hZgx6+N9EIZ9HGOEd4g+ul0EmfrNmZEA=;
	b=kbzg0cdJ4k29Y9+ASvwoR7xdfVzPW9bD2XQE9QH30F6kgf3ld5pmZj3jWx4aRzsvfTEb4F
	P9TFYE8Pj8PUO2aLCxlLP92/xYeXysbvC9ujSC7lDBqs1c0kpTI76Rut3Cq161cK/yPhD8
	LULCs/27hODNg9pN7PTyNnhr44jtOIY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 21/26] KVM: SVM: Rename vmcb->virt_ext to
 vmcb->misc_ctl2
Message-ID: <k6wja36wxzcgyef255vl7rds56hfs25gvueqo7xoyhget2suz2@vvio2nz6zjo5>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-22-yosry.ahmed@linux.dev>
 <aYVEVRV-ASogp5dF@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYVEVRV-ASogp5dF@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70457-lists,kvm=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	DKIM_TRACE(0.00)[linux.dev:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[yosry.ahmed@linux.dev,kvm@vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	NEURAL_HAM(-0.00)[-0.995];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:dkim,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2491E100029
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 05:31:01PM -0800, Sean Christopherson wrote:
> On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > @@ -244,6 +241,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
> >  #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
> >  #define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
> >  
> > +#define SVM_MISC_CTL2_LBR_CTL_ENABLE		BIT_ULL(0)
> > +#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE	BIT_ULL(1)
> 
> Since you're changing names anyways, What do you think about shortening things
> a bit, and using the more standard syle of <scope>_<action>_<flag>?  E.g.
> 
>   #define SVM_MISC2_ENABLE_LBR_VIRTUALIZATION	BIT_ULL(0)
>   #define SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE	BIT_ULL(1)

SVM_MISC2_ENABLE_LBR_VIRTUALIZATION is actually longer, how about
SVM_MISC2_ENABLE_V_LBR? Shorter and more consistent with
SVM_MISC2_ENABLE_V_VMLOAD_VMSAVE.

> 
> Yeah, it diverges from many of the other bits in here, but frankly the names in
> this file are *awful*.
> 
> Actually, maybe that would prompt me to send a cleanup, because the fact that we
> have this set of flags is beyond ridiculous (I geniunely don't remember what
> V_GIF_MASK tracks, off the top of my head).  And in isolation, I can't remember
> iof V_IRQ_MASK is an enable flag or a "IRQs are masked" flagged.
> 
> #define V_IRQ_MASK
> #define V_INTR_MASKING_MASK
> #define V_GIF_MASK
> #define V_GIF_ENABLE_MASK

Yeah I had to open the APM a few times while looking at them before to
figure out which is which :')

