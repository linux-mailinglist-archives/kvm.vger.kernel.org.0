Return-Path: <kvm+bounces-25375-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A6835964996
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 17:13:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D98691C20EE3
	for <lists+kvm@lfdr.de>; Thu, 29 Aug 2024 15:13:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 811D41B1515;
	Thu, 29 Aug 2024 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="psyIkPlf"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCBF1AE027
	for <kvm@vger.kernel.org>; Thu, 29 Aug 2024 15:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724944424; cv=none; b=V5blPwhceDJPR8CvuFc7lLNGjdhb66V+LjPWTUA0nLxoDaQ6U4n0381ThDOylUtOiyg8BocVE0q3e16XKH3SRvFVkufXnEA7VzYzVY8g1LleJBe9b7GPqbW8pFkvRCUJLuJ33d/8umxMGnFKItepbJ1Ua61qLPPl6Woitwe82+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724944424; c=relaxed/simple;
	bh=n4OF3sfmWGbdlNx+1jpSgHGw4vkxuzmfC9UyK6SEDg8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JdiRn17iD25CLdSL4VEHF/uZFpsR8AWFTYfdP2/wPa/SAVL+FoVGWWayXAJsHCm8SIi4gN2a38Rw9tsrYaLSa0S1VcRFJtwkTrc7Hp0IRnpKVSOlWhrbdOVQY/eulQbb0kKQVk6BJuQCO8BdViDcpJ459Lok3MI9wccBjUFN6a8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=psyIkPlf; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <861e94d5-b031-42e5-81ea-9ec059beba42@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724944419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aOnUvlpGbXcQcHB21rZB0Y8C2T9SAtY/z0Ucv2R5k9o=;
	b=psyIkPlfy2vA87Mg9OCwba5lo6+Np88nBNnOmZiewrQ2Il/Rx3Khux9Il6NH9iRoAvVZSW
	ailctqvh5nvPjom8xMpjaXctQfearFvX29DgsbWVwZPO8eJCfBlJEY00O0DuMSBYAuNSwB
	4i2gDnotKQZYPuOAQIKt0q+sj3yEVow=
Date: Thu, 29 Aug 2024 23:13:23 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH v2] Loongarch: KVM: Add KVM hypercalls documentation for
 LoongArch
To: maobibo <maobibo@loongson.cn>
Cc: Dandan Zhang <zhangdandan@uniontech.com>, pbonzini@redhat.com,
 corbet@lwn.net, zhaotianrui@loongson.cn, chenhuacai@kernel.org,
 kernel@xen0n.name, kvm@vger.kernel.org, loongarch@lists.linux.dev,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 guanwentao@uniontech.com, wangyuli@uniontech.com, baimingcong@uniontech.com,
 Xianglai Li <lixianglai@loongson.cn>, Mingcong Bai <jeffbai@aosc.io>
References: <DE6B1B9EAC9BEF4C+20240826054727.24166-1-zhangdandan@uniontech.com>
 <804a804c-f62d-4814-a174-51d19e3ea094@linux.dev>
 <29999cfc-6ec1-d881-277a-19f51f5c7b96@loongson.cn>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <29999cfc-6ec1-d881-277a-19f51f5c7b96@loongson.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

On 2024/8/28 09:07, maobibo wrote:
> Zenghui,
> 
> On 2024/8/27 上午1:00, Zenghui Yu wrote:
> >
> > On 2024/8/26 13:47, Dandan Zhang wrote:
> > > +KVM Hypercalls Documentation
> > > +============================
> > > +
> > > +The template for each hypercall is as follows:
> > > +
> > > +1. Hypercall name
> > > +2. Purpose
> > > +
> > > +1. KVM_HCALL_FUNC_PV_IPI
> >
> > Is it still a work-in-progress thing? I don't see it in mainline.
> It should be KVM_HCALL_FUNC_IPI here.

Good! So that I can probably read further. :-)

> > > +------------------------
> > > +
> > > +:Purpose: Send IPIs to multiple vCPUs.
> > > +
> > > +- a0: KVM_HCALL_FUNC_PV_IPI
> > > +- a1: Lower part of the bitmap for destination physical CPUIDs
> > > +- a2: Higher part of the bitmap for destination physical CPUIDs
> > > +- a3: The lowest physical CPUID in the bitmap
> >
> > - Is it a feature that implements IPI broadcast with a PV method?
> > - Don't you need to *at least* specify which IPI to send by issuing this
> >   hypercall?
> Good question. It should be documented here. PV IPI on LoongArch
> includes both PV IPI multicast sending and PV IPI receiving, and SWI is

Oh yup, I intended to say "multicast". Thanks for the explanation.

> used for PV IPI inject since there is no VM-exits accessing SWI registers.
> 
> >
> > But again, as I said I know nothing about loongarch.  I might have
> > missed some obvious points.
> >
> > > +
> > > +The hypercall lets a guest send multiple IPIs (Inter-Process
> > > Interrupts) with
> > > +at most 128 destinations per hypercall.The destinations are
> > > represented in a
> >                                            ^
> > Add a blank space.
> >
> > > +bitmap contained in the first two input registers (a1 and a2).
> > > +
> > > +Bit 0 of a1 corresponds to the physical CPUID in the third input
> > > register (a3)
> > > +and bit 1 corresponds to the physical CPUID in a3+1 (a4), and so on.
> >
> > This looks really confusing.  "Bit 63 of a1 corresponds to the physical
> > CPUID in a3+63 (a66)"?
> The description is problematic, thanks for pointing it out.
> It should be value of register a3 plus 1, rather than a4, how about
> *"the physical CPUID in a3 + 1"*  here?

Better than the original version, I think.

Thanks,
Zenghui

