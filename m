Return-Path: <kvm+bounces-20719-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1190891CA7B
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 04:14:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A3FFB227C2
	for <lists+kvm@lfdr.de>; Sat, 29 Jun 2024 02:14:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B806FB9;
	Sat, 29 Jun 2024 02:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Jrv9xb8L"
X-Original-To: kvm@vger.kernel.org
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3213DAD21
	for <kvm@vger.kernel.org>; Sat, 29 Jun 2024 02:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719627237; cv=none; b=YOhs6gidciZlWdMRR5op0VQLj/62YVFqYrMIgT7Mo4yjV8HN9zSU6sYFMorMCQdznMAR8HS4VcJER7RCEHcSQW9wZ/RKlazAaLuYc1xCIRSmebo3hAPi6G/gcllFK9iF7zHEcbF0Vs0TzLXqUyPxfFonDzEwZih0YrvS0ZWAzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719627237; c=relaxed/simple;
	bh=VjlQWayZ0a1t13wS5samrwVIhFTK5Imu4pJ0D2waseo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lXcRRGWvZH8n3k0W4GIgkyAIde1PUJ0apoa0B6Y/+1eeVfC5i8QRulFGfgWNyaL068mRd/MW9dwbassOKEpR4j535lJS3ZqdHhC8E1YM97HIP+7EwRtPhtPb14qXjI6yRmLO24OTNqmgZAuwNX7ORMq7DE1/5ZL8Kh/ZBYSg6kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Jrv9xb8L; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: yuzenghui@huawei.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1719627233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dsMiJ/DfctyapYO4Kt94I2y8UbU+q2nlWIvz9jErSoY=;
	b=Jrv9xb8LaHCeQqBJ+StqsJnNwRSAP+i/EttSuvma7TC6sYuTl6+eeyFb41m8+T2UplvTiP
	g1cNtvZX/3vCD7ZmzpJvnBFjMamOgkd+9G+3RXB1wU89NrDIVgF+2hFaPuiAbtgMG3d0Zd
	EAcNmJQax7Ky3Gqx0aBCGs/OVUUlwqo=
X-Envelope-To: kvmarm@lists.linux.dev
X-Envelope-To: maz@kernel.org
X-Envelope-To: james.morse@arm.com
X-Envelope-To: suzuki.poulose@arm.com
X-Envelope-To: kvm@vger.kernel.org
X-Envelope-To: pbonzini@redhat.com
Date: Sat, 29 Jun 2024 02:13:48 +0000
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: Zenghui Yu <yuzenghui@huawei.com>
Cc: kvmarm@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] MAINTAINERS: Include documentation in KVM/arm64 entry
Message-ID: <Zn9t3N4CxcqblFYO@linux.dev>
References: <20240628222147.3153682-1-oliver.upton@linux.dev>
 <63685fc4-38fb-f938-959d-2c1f96cff6b1@huawei.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63685fc4-38fb-f938-959d-2c1f96cff6b1@huawei.com>
X-Migadu-Flow: FLOW_OUT

On Sat, Jun 29, 2024 at 09:32:53AM +0800, Zenghui Yu wrote:
> On 2024/6/29 6:21, Oliver Upton wrote:
> > Ensure updates to the KVM/arm64 documentation get sent to the right
> > place.
> > 
> > Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index aacccb376c28..05d71b852857 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -12078,6 +12078,7 @@ L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
> >  L:	kvmarm@lists.linux.dev
> >  S:	Maintained
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
> > +F:	Documentation/virt/kvm/arm/
> >  F:	arch/arm64/include/asm/kvm*
> >  F:	arch/arm64/include/uapi/asm/kvm*
> >  F:	arch/arm64/kvm/
> 
> Should we include the vgic documentation (in
> Documentation/virt/kvm/devices/) as well? They're indeed KVM/arm64
> stuff.

Heh, yet another fine example for why I shouldn't send patches on a
Friday evening :)

Yes, we'll want to fold those in too, thanks for spotting this.

-- 
Thanks,
Oliver

