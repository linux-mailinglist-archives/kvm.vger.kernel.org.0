Return-Path: <kvm+bounces-20897-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA159261E9
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 15:34:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3CAEBB22256
	for <lists+kvm@lfdr.de>; Wed,  3 Jul 2024 13:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D38B176FBD;
	Wed,  3 Jul 2024 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="kXOm1Kdc"
X-Original-To: kvm@vger.kernel.org
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E431C136648
	for <kvm@vger.kernel.org>; Wed,  3 Jul 2024 13:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720013678; cv=none; b=aRa0FwEuQ6krJF1lJlbvS3SDFpOZZeU3V2VDQSAWNyzdX76IKVWOfbldoSBcvXWLPyXNW4TReY6DXdL8/d2Vv6+IpHEvZ0WPX20GSkBSjkNfajmgzu3MCnm0DKj5o3XtyJfG49DtKlVpyBH8dj70LtaI5h8JdDEbDg4Hk0xhxKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720013678; c=relaxed/simple;
	bh=SKoc1LSqvq1gRLT5j4Z9rzcwc5E+BErt9c5EOhhnE+0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c/JTlu4uw+qA5z+H47PI/cSjgGG3ojHCtqwsSQXRgp1jdV2Vgyqy/jOsRQvZxcNLU2yq3FKX+fNGbRhSHvuoy0wGqKf163jb8LFln4yLEWhf7H9uX/VxTmDXtlFLYDp/b9fYLZqjatedPEe//ik0DWCwGM8WZh5bxeGSzg8RAGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=kXOm1Kdc; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: yuzenghui@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720013672;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mfZjrBnjQAc2g3737Msklio3dXfCX7+a7lHHtBciKYY=;
	b=kXOm1Kdck0wb6gfJ1SjCEZ99lovuT69IkQG6pCczWL/ENrNSQ21LTZhSou5Uq+5XxmqCPY
	haa/1oM3ox334IEZe67f7Azug9Bg9i0pEFqIxcTIdplzTrl800C/p9bZrI7EOTNS+KgFCj
	+YokTjQm0wIG/0vkpcSzuZ6llQwIg64=
X-Envelope-To: alex.bennee@linaro.org
X-Envelope-To: pbonzini@redhat.com
X-Envelope-To: drjones@redhat.com
X-Envelope-To: thuth@redhat.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: qemu-arm@nongnu.org
X-Envelope-To: linux-arm-kernel@lists.infradead.org
X-Envelope-To: christoffer.dall@arm.com
X-Envelope-To: maz@kernel.org
X-Envelope-To: anders.roxell@linaro.org
X-Envelope-To: alexandru.elisei@arm.com
X-Envelope-To: eric.auger@redhat.com
X-Envelope-To: kvmarm@lists.linux.dev
Date: Wed, 3 Jul 2024 08:34:27 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Andrew Jones <andrew.jones@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>, 
	pbonzini@redhat.com, drjones@redhat.com, thuth@redhat.com, kvm@vger.kernel.org, 
	qemu-arm@nongnu.org, linux-arm-kernel@lists.infradead.org, christoffer.dall@arm.com, 
	maz@kernel.org, Anders Roxell <anders.roxell@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Eric Auger <eric.auger@redhat.com>, 
	"open list:ARM" <kvmarm@lists.linux.dev>
Subject: Re: [kvm-unit-tests PATCH v1 2/2] arm/mmu: widen the page size check
 to account for LPA2
Message-ID: <20240703-09f98f39f0aa78a0beb48696@orel>
References: <20240702163515.1964784-1-alex.bennee@linaro.org>
 <20240702163515.1964784-3-alex.bennee@linaro.org>
 <28936f0c-5745-14b3-1ecf-ae1e01c5b28f@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <28936f0c-5745-14b3-1ecf-ae1e01c5b28f@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 03, 2024 at 11:52:05AM GMT, Zenghui Yu wrote:
> Hi Alex,
> 
> [ Please don't send patches to the old kvmarm@lists.cs.columbia.edu as
> it had been dropped since early 2023. [1] ]
> 
> On 2024/7/3 0:35, Alex Bennée wrote:
> > If FEAT_LPA2 is enabled there are different valid TGran values
> > possible to indicate the granule is supported for 52 bit addressing.
> > This will cause most tests to abort on QEMU's -cpu max with the error:
> > 
> >   lib/arm/mmu.c:216: assert failed: system_supports_granule(PAGE_SIZE): Unsupported translation granule 4096
> > 
> > Expand the test to tale this into account.
> > 
> > Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> > Cc: Anders Roxell <anders.roxell@linaro.org>
> 
> There's a similar patch on the list [2], haven't been merged in master
> though.

Drat, I queued that, and several other patches, and then, for whatever
reason, I delayed the merge (I was probably just waiting for the gitlab
pipeline to finish...) and then forgot to actually merge... I've merged
now.

Please don't hesitate to ping me on patches that linger too long. I
sometimes need that interrupt to trigger my context switch!

Thanks,
drew

> 
> [1] https://git.kernel.org/torvalds/c/960c3028a1d5
> [2]
> https://lore.kernel.org/all/20240402132739.201939-6-andrew.jones@linux.dev

