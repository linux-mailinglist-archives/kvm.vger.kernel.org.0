Return-Path: <kvm+bounces-20720-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 27EFF91CA84
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 04:24:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA2881F22B12
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:24:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2604AD49;
	Sat, 29 Jun 2024 02:24:32 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92A9749C
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 02:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627872; cv=none; b=n0BD75qrq2CL1kH692UQIlX06NIE/+cqJh9uQk5YiAQUtxIyAPXZDL0zbYDwOdn4uqbTibUVNumCBdBTm9ut7JH9vgdrOFpCEqUQE+vOZZIcf8dXHHH8WUfKuOAYXvzyWnbEyjjRbIN2yjImh6yIV40kfaZHA9Y9+Io+5r6dTRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627872; c=relaxed/simple;
	bh=/jYutR5A2lZINKgNdaup3XkyQHZCYecGXaEztbu95Nc=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=slm0BrUGBLwc+MxRg5svdkgc1wwGxcICETCGFkwHKFqFAtVGpQK1jQJUJSEArAgEAKfhvahGxCC0q8kRvN4TUvSz8+7IT4YXHedUGDGWuWfi+2xMs4pEKodBILSiTPS0ezaa3wuJu5whpINQtBqgNJrSfpJAaWqYwRFlhj/gGPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W9x0n6zPFzdbjt;
	Sat, 29 Jun 2024 10:22:49 +0800 (CST)
Received: from kwepemm600007.china.huawei.com (unknown [7.193.23.208])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C6F8140135;
	Sat, 29 Jun 2024 10:24:25 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.39; Sat, 29 Jun 2024 10:24:24 +0800
Subject: Re: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
To: Oliver Upton <oliver.upton@linux.dev>
CC: <kvmarm@lists.linux.dev>, Marc Zyngier <maz@kernel.org>, James Morse
	<james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	<kvm@vger.kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
References: <20240628222147.3153682-1-oliver.upton@linux.dev>
 <63685fc4-38fb-f938-959d-2c1f96cff6b1@huawei.com>
 <Zn9t3N4CxcqblFYO@linux.dev>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <94c91bb9-9e4e-d7c9-9cc0-30bdfe04c5ee@huawei.com>
Date: Sat, 29 Jun 2024 10:24:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Zn9t3N4CxcqblFYO@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemm600007.china.huawei.com (7.193.23.208)

On 2024/6/29 10:13, Oliver Upton wrote:
> On Sat, Jun 29, 2024 at 09:32:53AM +0800, Zenghui Yu wrote:
> > On 2024/6/29 6:21, Oliver Upton wrote:
> > > Ensure updates to the KVM/arm64 documentation get sent to the right
> > > place.
> > >
> > > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > > ---
> > >  MAINTAINERS | 1 +
> > >  1 file changed, 1 insertion(+)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index aacccb376c28..05d71b852857 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -12078,6 +12078,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> > >  L:	kvmarm@lists.linux.dev
> > >  S:	Maintained
> > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
> > > +F:	Documentation/virt/kvm/arm/
> > >  F:	arch/arm64/include/asm/kvm*
> > >  F:	arch/arm64/include/uapi/asm/kvm*
> > >  F:	arch/arm64/kvm/
> >
> > Should we include the vgic documentation (in
> > Documentation/virt/kvm/devices/) as well? They're indeed KVM/arm64
> > stuff.
> 
> Heh, yet another fine example for why I shouldn't send patches on a
> Friday evening :)
> 
> Yes, we'll want to fold those in too, thanks for spotting this.

With that added:

Acked-by: Zenghui Yu <yuzenghui@huawei.com>

