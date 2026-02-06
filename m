Return-Path: <kvm+bounces-70454-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SAwGKC4NhmkRJQQAu9opvQ
	(envelope-from <kvm+bounces-70454-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:47:58 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1453CFFE1E
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 16:47:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 04DF1304C056
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 15:46:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78A8C2D8DDF;
	Fri,  6 Feb 2026 15:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ahdB3YrP"
X-Original-To: kvm@vger.kernel.org
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880BB2417D1
	for <kvm@vger.kernel.org>; Fri,  6 Feb 2026 15:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770392757; cv=none; b=FvSVaTsR2sbDsa6N44IuvjQi+8uYSSDVv0loExzXZdT+InE9mtesQO5j4HM/f7v7NuV4xcXgT3//CDMaXe/QWDLQH7ZVIcbD5Ix0gfvfckKkqAxH8COOcJ0P4QqoEKAP6Eteu9C0K7X1ENUxkZSzHT9W/wxb2ad29hA1GvacxYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770392757; c=relaxed/simple;
	bh=DMzu5EhixXGoR1VK/qRmxPTVat7cpEMbgxJxBzibS6c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfXCRVwBioI7E/+c/nOgB0vmggpaxRegucdMY97nNi/PFIXlp8v0bWnNs6r1tNswKoRoIDNStHGe3gPQMZHzSd/29TdL8VB8lmSgaTqfZ4BxkoRx+djJg5ykP7ciUVuyeD2pUsERbtsoEhwxM+6ZHdIKv5z3RN//bFpgTtYJReE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ahdB3YrP; arc=none smtp.client-ip=95.215.58.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Fri, 6 Feb 2026 15:45:42 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770392745;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dW4EG/KgJJjxs4LiKc2bRO5TkZrSx/ntjEzII2qN6Ks=;
	b=ahdB3YrPlKp8g8g94x1c+HH8Pmn6SdN7efbhZXNvO6poOVtZtoXRcIjKIDCM8rdLR5qQmc
	Ok/vhwlmEndaBMqVeXxq25il433AdRiyuoFo3QYCjtt3p87lDS9l6EeHVuCHOVo0KCJGgV
	Um1xgeo4ombG42LtzpJ/b79X3Or700M=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 22/26] KVM: SVM: Use BIT() and GENMASK() for
 definitions in svm.h
Message-ID: <nq4vzcgi42ydmofxntz24k4wjohls4ksnetegiamzazkg2gg3i@xl6rik6ayfxv>
References: <20260115011312.3675857-1-yosry.ahmed@linux.dev>
 <20260115011312.3675857-23-yosry.ahmed@linux.dev>
 <aYVF0YfqlRktzM7S@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYVF0YfqlRktzM7S@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70454-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,linux.dev:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 1453CFFE1E
X-Rspamd-Action: no action

On Thu, Feb 05, 2026 at 05:37:21PM -0800, Sean Christopherson wrote:
> On Thu, Jan 15, 2026, Yosry Ahmed wrote:
> > Use BIT() and GENMASK() (and *_ULL() variants) to define the bitmasks in
> > svm.h.
> 
> Oh, hey, just what I was talking about.  But why is this buried as patch 22/26?
> AFAICT, it's got nothing to do with the rest of the series.
> 
> > Opportunistically switch the definitions of AVIC_ENABLE_{SHIFT/MASK}
> > and X2APIC_MODE_{SHIFT/MASK}, as well as SVM_EVTINJ_VALID and
> > SVM_EVTINJ_VALID_ERR, such that the bitmasks are defined in the correct
> > order.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
> > ---
> >  arch/x86/include/asm/svm.h | 78 +++++++++++++++++++-------------------
> >  1 file changed, 39 insertions(+), 39 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
> > index 770c7aed5fa5..0bc26b2b3fd7 100644
> > --- a/arch/x86/include/asm/svm.h
> > +++ b/arch/x86/include/asm/svm.h
> > @@ -189,39 +189,39 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
> >  #define V_TPR_MASK 0x0f
> >  
> >  #define V_IRQ_SHIFT 8
> > -#define V_IRQ_MASK (1 << V_IRQ_SHIFT)
> > +#define V_IRQ_MASK BIT(V_IRQ_SHIFT)
> 
> I vote (and if anyone disagrees, their vote doesn't count) to purge the _SHIFT
> and _MASK crud.  There is zero reason to define the shifts.
> 
> And then when we rename, I would like to try and find better names, e.g. maybe
> things like V_GIF and V_ENABLE_GIF_VIRTUALIZATION?
> 
> Anyways, that's partly why I asked why this patch is here.  If we're changing
> things, then I'd like to do some cleanup.  But this series is already a chonker,
> so I'd much prefer to do any cleanup in a separate series.

Makes sense, will drop this patch.

