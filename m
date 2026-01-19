Return-Path: <kvm+bounces-68460-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5D8D39CE9
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 04:30:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0165F3009952
	for <lists+kvm@lfdr.de>; Mon, 19 Jan 2026 03:30:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 185E727FD4B;
	Mon, 19 Jan 2026 03:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WBkRICnE"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC0FC23EAB7
	for <kvm@vger.kernel.org>; Mon, 19 Jan 2026 03:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768793446; cv=none; b=fY1UMqzpGOqLOCoL4Xt6lpep2LC3jBcPW9An6WrrtckZYLswqSQqjY1lRxiaaw3EIE2vtfWX7bQWp63m1HX6YNMUj96v8eX+BNPm+cs3BV6DbCCUq/OET6sakqmw3mcdysBfo08SQTQp/PtM72IC9HwVqhiGrNa7NSzhJVmCzRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768793446; c=relaxed/simple;
	bh=OfXCEHYlRp+JTpvjm0NXTxZjdeirxLS3UZ4QDUM1bVQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B15pmF1QnxOIMVQ6NFiP3p1qBQixt9nYVlE5QTlMSiAepwiVHpnu8iNbztynYLP4t9Jiv6bIh9w25yj/JHZqEJKKH2buNS4xDmkFb0BVzI/EDsj5cTrTi7j5HBv0dsRsk6tUejc7k/V+mLBDVWW64onSfSXENGz02wxt4dt8y2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WBkRICnE; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768793444; x=1800329444;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=OfXCEHYlRp+JTpvjm0NXTxZjdeirxLS3UZ4QDUM1bVQ=;
  b=WBkRICnEWvQHQiFSHSx2aF1px5QWp0bOYqmyL1KnsX2PkwjzeYx0wc2O
   DB3GJk+W8lDjC08e7WsIrUmsvgjdEc/Y5gbW3z6xG15omnTL7xRaxFwPo
   AlZQkTyaN/XTTRCmJjvxOicXN2SGV9A1Q0melMUX96LJYa8fS80dN3V36
   MQUUKplfqi6ko0AJ6j402j/LG4qsO4wdsXSaOQt1LaUMsyFOMaryQOLuV
   dBF0CLHtU3gfMT7A8GQNEppY7c7ykCP812vi6QjoAMyukGIZsUP6VrfNI
   BtLhUOVALTcBMtHGmd8U13nXFWYK/O9qit6IAKMM2RE2l3OyXf64JewjH
   w==;
X-CSE-ConnectionGUID: BBcs8y5wQDab5Pzkf04EbA==
X-CSE-MsgGUID: IPxMn0YwT56pptGbd1Craw==
X-IronPort-AV: E=McAfee;i="6800,10657,11675"; a="70050152"
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="70050152"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 19:30:44 -0800
X-CSE-ConnectionGUID: nvZgRvrQSauorqIvBYZZPQ==
X-CSE-MsgGUID: GP7cXY/CRMSv47o2nKtxtA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,237,1763452800"; 
   d="scan'208";a="243324046"
Received: from dapengmi-mobl1.ccr.corp.intel.com (HELO [10.124.240.14]) ([10.124.240.14])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2026 19:30:42 -0800
Message-ID: <56dd6056-e3e2-46cd-9426-87c7889bed49@linux.intel.com>
Date: Mon, 19 Jan 2026 11:30:39 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] target/i386: Make some PEBS features user-visible
To: Zide Chen <zide.chen@intel.com>, qemu-devel@nongnu.org,
 kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Zhao Liu <zhao1.liu@intel.com>, Peter Xu <peterx@redhat.com>,
 Fabiano Rosas <farosas@suse.de>
Cc: xiaoyao.li@intel.com, Dongli Zhang <dongli.zhang@oracle.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-7-zide.chen@intel.com>
Content-Language: en-US
From: "Mi, Dapeng" <dapeng1.mi@linux.intel.com>
In-Reply-To: <20260117011053.80723-7-zide.chen@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit


On 1/17/2026 9:10 AM, Zide Chen wrote:
> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
> the corresponding bits user-visible CPU feature knobs, allowing them to
> be explicitly enabled or disabled via -cpu +/-<feature>.
>
> Once named, these bits become part of the guest CPU configuration
> contract.  If a VM is configured with such a feature enabled, migration
> to a destination that does not support the feature may fail, as the
> destination cannot honor the guest-visible CPU model.
>
> The PEBS_FMT bits are intentionally not exposed. They are not meaningful
> as user-visible features, and QEMU registers CPU features as boolean
> QOM properties, which makes them unsuitable for representing and
> checking numeric capabilities.

Currently KVM supports user space sets PEBS_FMT (see vmx_set_msr()), but
just requires the guest PEBS_FMT is identical with host PEBS_FMT.

IIRC, many places in KVM judges whether guest PEBS is enabled by checking
the guest PEBS_FMT. If we don't expose PEBS_FMT to user space, how does KVM
get the guest PEBS_FMT?


>
> Co-developed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
> Signed-off-by: Zide Chen <zide.chen@intel.com>
> ---
>  target/i386/cpu.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index f1ac98970d3e..fc6a64287415 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1618,10 +1618,10 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .type = MSR_FEATURE_WORD,
>          .feat_names = {
>              NULL, NULL, NULL, NULL,
> +            NULL, NULL, "pebs-trap", "pebs-arch-reg"
>              NULL, NULL, NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> -            NULL, "full-width-write", NULL, NULL,
> -            NULL, NULL, NULL, NULL,
> +            NULL, "full-width-write", "pebs-baseline", NULL,
> +            NULL, "pebs-timing-info", NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,
>              NULL, NULL, NULL, NULL,

