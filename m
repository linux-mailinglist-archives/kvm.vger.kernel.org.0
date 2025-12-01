Return-Path: <kvm+bounces-65049-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28820C99915
	for <lists+kvm@lfdr.de>; Tue, 02 Dec 2025 00:17:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 84DD23A2F3D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 23:17:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7F93290DBB;
	Mon,  1 Dec 2025 23:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cq+ULEt8"
X-Original-To: kvm@vger.kernel.org
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E621EC018
	for <kvm@vger.kernel.org>; Mon,  1 Dec 2025 23:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764631020; cv=none; b=gBYAY/S3GLldC7SY33JVllBV9k4eOJazdr7amx9R8A1U3aTAuChavyLABKHl5ESA34M8WjfMJDBs7T4Cj3KxI56Y+z+AggGvwtoXdoXyOMMJKNLRD+8wBHp/CIPmU8AwS0+bVSJsxL8tZ7g4HCip8CtSFGudYxCs11ZWwbx8A2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764631020; c=relaxed/simple;
	bh=1KLyi85UmFzTZFUsXb82Lsd70mhIYwu67P6P78TQTYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VveM91vBtQoa1CqTPB9KJts4hV/mPMUH8Cp0m69fojAtHQQOE5OBFj6CI4eZDvaQ8fUef1+FwNz2fct+O9xdOV3KFGcxjKnuarj62Mp6sFeN9QdGSZt+YsO/mPOz5WTX+tjERpO5umD9EDCHmjic1qphvTJTqQT7m3fmHl+BU5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cq+ULEt8; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Mon, 1 Dec 2025 17:16:40 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1764631016;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1KLyi85UmFzTZFUsXb82Lsd70mhIYwu67P6P78TQTYA=;
	b=cq+ULEt8h6+yhwbAxcraNneWQG/qcmSc3/vgwxWQ+q5zWbhoGE4v9A42gEeh+G4KQ6uYco
	UXKJF0T2apAN+LYsm1Np9PACcs2uuBahH62gI2vK/nqoIuYQe3TRJcSXplGOK9fNaonUTf
	PLFDpayr5rOn3tQ4qd1YypsQzW75dOc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Joey Gouly <joey.gouly@arm.com>
Cc: Eric Auger <eric.auger@redhat.com>, kvm@vger.kernel.org, 
	alexandru.elisei@arm.com, kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm64: EL2 support
Message-ID: <20251201-2ae3e986e3c1242e7bafc247@orel>
References: <20250925141958.468311-1-joey.gouly@arm.com>
 <44fac47f-1df1-4119-8bf0-1db96cda18ef@redhat.com>
 <20251127110832.GA3240191@e124191.cambridge.arm.com>
 <3a39738e-ed33-49fa-9f1c-0bbba6979038@redhat.com>
 <20251127145207.GA3265987@e124191.cambridge.arm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127145207.GA3265987@e124191.cambridge.arm.com>
X-Migadu-Flow: FLOW_OUT

On Thu, Nov 27, 2025 at 02:52:07PM +0000, Joey Gouly wrote:
...
> I will send out a new version with this fix, missing sob/reviews/acks, after you've had a look!
>

Also please run checkpatch on the series if you haven't already. I think
it should have complained about the C++ comments, for example. And, in
any case, please change the C++ comments to C comments and generally use
the kernel's coding style.

Thanks,
drew

