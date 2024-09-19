Return-Path: <kvm+bounces-27170-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A77997C6A9
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 11:12:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D6741F27793
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2024 09:12:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1AC19B5B1;
	Thu, 19 Sep 2024 09:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vPUhqOG+"
X-Original-To: kvm@vger.kernel.org
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C844E199928
	for <kvm@vger.kernel.org>; Thu, 19 Sep 2024 09:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726737124; cv=none; b=lIk6FN14aMcY6ZfKQGuvmtTikGsoxnLbaB/qMhggpC/hjy8Gt58B+4dODtMUXhmzI1h4tYe6KimATb4TBH1rdvVbFl+Pc8xh5cSEtmTLqykK3E3mIKda1/WvbZXj4nC/A9uv/dpoJXy8M4/FNodNLkvqeWFBc014qmDUHW+hCfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726737124; c=relaxed/simple;
	bh=6rAF1Svpd8vBBvWUfaNilf4YD3O1FlwDk4ri/1NJPB8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=faiBuz5tpTBSxxSlFDsXjaPm4hm/PvionAOSM7hipRFu/OGOw5uASkpnHhf7GApMRJgUCx+an5qQKm4q/9YcgJjLG0nXCKoAy867UaKADOm56mE5CrZnR3pGmVNl+rqcmRzjv/UhPkxDT+hFt6DCGWBVyPKQJPvN64EtWNRjpmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vPUhqOG+; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Thu, 19 Sep 2024 02:11:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1726737120;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SDI9ysSiZI8BDMOOphPs7LmwKx7q2jcPwhENrySxiwA=;
	b=vPUhqOG+H9KeTsysJMAqMuCfqWmU7+3PlKqtZSPW8LoRbth3fH2oE43m92do6CRtAv7uN3
	ZY78LLhPQ0YyxTsc1iu/RCkzUYZbGXbWSIyoLn4ZYvt9KP1Jg5nLLNyObcneQ6la+xKuvU
	tTo0PBflMSVYjvp6s3e+kGGLM7mMPxA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Lilit Janpoladyan <lilitj@amazon.com>
Cc: kvm@vger.kernel.org, maz@kernel.org, james.morse@arm.com,
	suzuki.poulose@arm.com, yuzenghui@huawei.com,
	nh-open-source@amazon.com, kvmarm@lists.linux.dev
Subject: Re: [PATCH 0/8] *** RFC: ARM KVM dirty tracking device ***
Message-ID: <Zuvq18Nrgy6j_pZW@linux.dev>
References: <20240918152807.25135-1-lilitj@amazon.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240918152807.25135-1-lilitj@amazon.com>
X-Migadu-Flow: FLOW_OUT

Hi Lilit,

+cc kvmarm mailing list, get_maintainer is your friend :)

On Wed, Sep 18, 2024 at 03:27:59PM +0000, Lilit Janpoladyan wrote:
> An example of a device that tracks accesses to stage-2 translations and will
> implement page_tracking_device interface is AWS Graviton Page Tracking Agent
> (PTA). We'll be posting code for the Graviton PTA device driver in a separate
> series of patches.

In order to actually review these patches, we need to see an
implementation of such a page tracking device. Otherwise it's hard to
tell that the interface accomplishes the right abstractions.

Beyond that, I have some reservations about maintaining support for
features that cannot actually be tested outside of your own environment.

> When ARM architectural solution (FEAT_HDBSS feature) is available, we intend to
> use it via the same interface most likely with adaptations.

Will the PTA stuff eventually get retired once you get support for FEAT_HDBSS
in hardware?

I think the best way forward here is to implement the architecture, and
hopefully after that your legacy driver can be made to fit the
interface. The FVP implements FEAT_HDBSS, so there's some (slow)
reference hardware to test against.

This is a very interesting feature, so hopefully we can move towards
something workable.

-- 
Thanks,
Oliver

