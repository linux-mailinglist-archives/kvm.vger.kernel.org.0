Return-Path: <kvm+bounces-42015-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58902A71078
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 07:15:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA8C617425A
	for <lists+kvm@lfdr.de>; Wed, 26 Mar 2025 06:15:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 936DC15442A;
	Wed, 26 Mar 2025 06:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="OuiqmHTL"
X-Original-To: kvm@vger.kernel.org
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD0518D63A
	for <kvm@vger.kernel.org>; Wed, 26 Mar 2025 06:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742969720; cv=none; b=n+IRigZfSh+/yPYsud549UBqDhCBCH/0lDB5Btku2zCtXDHQKonCAuw/DkcNyo0DF8YAgeVFF5h+Yl9bccbcTK/UU74P+PwHh7AdA3v9+tGA0pUAUiBxXzchJ9OFG2xtCD5/cTwmPCqkK7KWNOM4AXekMyVQeDoE7gw1r5MXY98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742969720; c=relaxed/simple;
	bh=DW8Fy2HTTgoGtISvZcT+E3D97xdwk6+3h+vam6MJfPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U6QwLIxTpqgDeSu/0UZ9jOC59al2UPaPxaGlQNtLo83KSGXCW7BgmhYF3Xr3V5ibKzs4EjBj33R7Qeizmnz6EsP3EiKg5+LX6ynZph+CXFrti5507JZrB+trTejk1mv4lRGzl7k9cJdvJeJS4lJuNFiJUCDJRDu2QUXaT9CL2Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=OuiqmHTL; arc=none smtp.client-ip=95.215.58.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Date: Tue, 25 Mar 2025 23:14:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1742969702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=slCF2xs2ElnaTVorgRjJtJXFeYpLhzlPphzcbXRpqBA=;
	b=OuiqmHTL8r1gLM/KKEIjqAjSmMsNYpkvBf0rF1fapMbUROPNKPJrNCuIniEZweIt2hcbQL
	zVCmBXHOplOtEyzKqjZRA+blDaXiM047RrfHp6qItXfsJFcV6cpMoOiCI/Y01E5Hi1/f8w
	jCLrNhkoLu/Hgj/xfyHkzQiqiV4nuHw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Oliver Upton <oliver.upton@linux.dev>
To: "Emi Kisanuki (Fujitsu)" <fj0570is@fujitsu.com>
Cc: 'Steven Price' <steven.price@arm.com>,
	"'kvm@vger.kernel.org'" <kvm@vger.kernel.org>,
	"'kvmarm@lists.linux.dev'" <kvmarm@lists.linux.dev>,
	'Catalin Marinas' <catalin.marinas@arm.com>,
	'Marc Zyngier' <maz@kernel.org>, 'Will Deacon' <will@kernel.org>,
	'James Morse' <james.morse@arm.com>,
	'Suzuki K Poulose' <suzuki.poulose@arm.com>,
	'Zenghui Yu' <yuzenghui@huawei.com>,
	"'linux-arm-kernel@lists.infradead.org'" <linux-arm-kernel@lists.infradead.org>,
	"'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
	'Joey Gouly' <joey.gouly@arm.com>,
	'Alexandru Elisei' <alexandru.elisei@arm.com>,
	'Christoffer Dall' <christoffer.dall@arm.com>,
	'Fuad Tabba' <tabba@google.com>,
	"'linux-coco@lists.linux.dev'" <linux-coco@lists.linux.dev>,
	'Ganapatrao Kulkarni' <gankulkarni@os.amperecomputing.com>,
	'Gavin Shan' <gshan@redhat.com>,
	'Shanker Donthineni' <sdonthineni@nvidia.com>,
	'Alper Gun' <alpergun@google.com>,
	"'Aneesh Kumar K . V'" <aneesh.kumar@kernel.org>
Subject: Re: [PATCH v7 00/45] arm64: Support for Arm CCA in KVM
Message-ID: <Z-ObUJQn2dGsgSsO@linux.dev>
References: <20250213161426.102987-1-steven.price@arm.com>
 <TYCPR01MB11463C8CCEFEDAF79868E9BBCC3A62@TYCPR01MB11463.jpnprd01.prod.outlook.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYCPR01MB11463C8CCEFEDAF79868E9BBCC3A62@TYCPR01MB11463.jpnprd01.prod.outlook.com>
X-Migadu-Flow: FLOW_OUT

Hi Emi,

On Wed, Mar 26, 2025 at 02:14:35AM +0000, Emi Kisanuki (Fujitsu) wrote:
> Hi all,
> 
> I tested Linux-cca cca-host/v7 patch with our Internal simulator based on QEMU (with CCA and MPAM support).
> A panic occurred when starting Realm, but I don't think this is a problem with the cca-host/v7 patch.
> The location of the panic is [1].
> 
> [1]https://lore.kernel.org/linux-arm-kernel/20241030160317.2528209-4-joey.gouly@arm.com
> diff --git a/arch/arm64/kernel/cpuinfo.c b/arch/arm64/kernel/cpuinfo.c
> index 44718d0482b3..46ba30d42b9b 100644
> --- a/arch/arm64/kernel/cpuinfo.c
> +++ b/arch/arm64/kernel/cpuinfo.c
> @@ -478,6 +478,9 @@ static void __cpuinfo_store_cpu(struct cpuinfo_arm64 *info)
>  	if (id_aa64pfr0_32bit_el0(info->reg_id_aa64pfr0))
>  		__cpuinfo_store_cpu_32bit(&info->aarch32);
>  
> +	if (id_aa64pfr0_mpam(info->reg_id_aa64pfr0))
> +		info->reg_mpamidr = read_cpuid(MPAMIDR_EL1); /////// panic occurred here. 
> +
>  	cpuinfo_detect_icache_policy(info);
>  }
> 
> There was no problem with the cca-host/v5 patch (based on v6.12).
> This panic is caused by accessing MPAMIDR_EL1 when the chip supports MPAM.
> This functionality was enabled when the cca host patch base version was rebased from v6.12 to v6.13.
> 
> I am not familiar with TF-A, but I think this maybe a TF-A's bug.
> Because It seems TF-A sets MPAM3_EL3.TRAPLOWER to 0 during normal guest boot in manage_extensions_nonsecure_per_world function[2].
> However, TF-A does not set it to 0 during Realm guest boot in manage_extensions_secure_per_world function.
> Therefore, a trap occurs against EL3 (TF-A), and it is likely being processed as an invalid instruction (Undef).

Your instinct is correct that this is *not* a kernel bug. It is the
responsibility of the RMM to provide a consistent feature set to the
Realm.

Looks like this was addressed recently in TF-RMM by hiding FEAT_MPAM:

https://github.com/TF-RMM/tf-rmm/commit/7b0874403726d215c40054abfd5d8704049f8dac

Thanks,
Oliver

