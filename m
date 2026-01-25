Return-Path: <kvm+bounces-69058-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id F+yzGpXQdWlTIwEAu9opvQ
	(envelope-from <kvm+bounces-69058-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 09:13:09 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5446F8000E
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 09:13:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id DBDAB3002509
	for <lists+kvm@lfdr.de>; Sun, 25 Jan 2026 08:13:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A3D73161B2;
	Sun, 25 Jan 2026 08:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="e9uwZuuH"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C670D226CEB
	for <kvm@vger.kernel.org>; Sun, 25 Jan 2026 08:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769328782; cv=none; b=HnkclGhE+mxeX8piglb4ZbbJZL84M7Oso26ZrKXIutty4GQzNv442HmmFBPPows9wcJNMP0WHkRJeWu9J3BH7jLzi7VHsN+7zxzxuu3QjcTzqi9taj8WMzRFYb0lYejnQSAaGTuCV5UIqYFpIboCev+9V5RfgV0KtHfZz4BZiqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769328782; c=relaxed/simple;
	bh=Jn8uqfx7qSGHxVBxgUF6hCOAJlmyJYwvFLs0epqJEVI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG67rzfrakM5efMVRgOVvYWqwUyr5ExtCTROVT5wHjdNvXDBesFNbNfXlHITqb8Ge1nz7QK9cdDlYrkEQ14nRHmqQ4zPfMDWVYl04lBOeJ+tyy5nMYGnUOTWWTNBA7pY1f2HOA9CcrVwK1WpKRz87GUd41hURtsDp7EjEwU4w4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=e9uwZuuH; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769328780; x=1800864780;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=Jn8uqfx7qSGHxVBxgUF6hCOAJlmyJYwvFLs0epqJEVI=;
  b=e9uwZuuH4tPTy3B0cA2lwutkZJOdBzH/kiI/ggV3T5AZXxvsQOTM12z0
   6P1eIn7syUqibpdwIin0kFhDxq5Q8+hCIpMOrDE+X3N/YxLJl9ms1q6Jg
   MR7ox8Ohsl0Axqa8HCAGjHHZ9Vjujtn2d8JZAPonRPumVSube0Ard5z9d
   yvmgr2zsS5M3H7bO3LOnglhm89qx+fc0e8jcP72KpXI5uqSDqi02leyoc
   WSEgzyyn/42mIQ8aDZgSUDyFqOpMOT2rJdC5m89/RWyg3qBqyvMb2ZqA4
   hm2+0thMhaXM6ek/LawZCwaIbQepffaYr7ezi+HNkHqXhVF9sA+ccZA53
   g==;
X-CSE-ConnectionGUID: SJrcGxwzQKiHTcgYBR5T+w==
X-CSE-MsgGUID: F87QosObTtiokUGFPsyGtg==
X-IronPort-AV: E=McAfee;i="6800,10657,11681"; a="73114045"
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="73114045"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2026 00:12:59 -0800
X-CSE-ConnectionGUID: ZGNQJYr6S9ijwnHjVJpHAQ==
X-CSE-MsgGUID: 6TvzgI8YR9iGQ+vdvlFsiQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,252,1763452800"; 
   d="scan'208";a="207303516"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa006.fm.intel.com with ESMTP; 25 Jan 2026 00:12:57 -0800
Date: Sun, 25 Jan 2026 16:38:30 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: "Chen, Zide" <zide.chen@intel.com>,
	"Mi, Dapeng" <dapeng1.mi@linux.intel.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org,
	Paolo Bonzini <pbonzini@redhat.com>, Peter Xu <peterx@redhat.com>,
	Fabiano Rosas <farosas@suse.de>, xiaoyao.li@intel.com,
	Dongli Zhang <dongli.zhang@oracle.com>
Subject: Re: [PATCH 6/7] target/i386: Make some PEBS features user-visible
Message-ID: <aXXWhqUuPQaxDKCV@intel.com>
References: <20260117011053.80723-1-zide.chen@intel.com>
 <20260117011053.80723-7-zide.chen@intel.com>
 <56dd6056-e3e2-46cd-9426-87c7889bed49@linux.intel.com>
 <513c6944-b80a-46f2-ad6c-4de77dac4b09@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <513c6944-b80a-46f2-ad6c-4de77dac4b09@intel.com>
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[intel.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64];
	R_DKIM_ALLOW(-0.20)[intel.com:s=Intel];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[intel.com:+];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69058-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[zhao1.liu@intel.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[intel.com:mid,intel.com:dkim]
X-Rspamd-Queue-Id: 5446F8000E
X-Rspamd-Action: no action

Hi Zide & Dapeng,

> On 1/18/2026 7:30 PM, Mi, Dapeng wrote:
> > 
> > On 1/17/2026 9:10 AM, Zide Chen wrote:
> >> Populate selected PEBS feature names in FEAT_PERF_CAPABILITIES to make
> >> the corresponding bits user-visible CPU feature knobs, allowing them to
> >> be explicitly enabled or disabled via -cpu +/-<feature>.
> >>
> >> Once named, these bits become part of the guest CPU configuration
> >> contract.  If a VM is configured with such a feature enabled, migration
> >> to a destination that does not support the feature may fail, as the
> >> destination cannot honor the guest-visible CPU model.
> >>
> >> The PEBS_FMT bits are intentionally not exposed. They are not meaningful
> >> as user-visible features, and QEMU registers CPU features as boolean
> >> QOM properties, which makes them unsuitable for representing and
> >> checking numeric capabilities.
> > 
> > Currently KVM supports user space sets PEBS_FMT (see vmx_set_msr()), but
> > just requires the guest PEBS_FMT is identical with host PEBS_FMT.
> 
> My mistake — this is indeed problematic.
> 
> There are four possible ways to expose pebs_fmt to the guest when
> cpu->migratable = true:
> 
> 1. Add a pebs_fmt option similar to lbr_fmt.
> This may work, but is not user-friendly and adds unnecessary complexity.
> 
> 2. Set feat_names[8] = feat_names[9] = ... = "pebs-fmt".
> This violates the implicit rule that feat_names[] entries should be
> unique, and target/i386 does not support numeric features.
> 
> 3. Use feat_names[8..11] = "pebs-fmt[1/2/3/4]".
> This has two issues:
> - It exposes pebs-fmt[1/2/3/4] as independent features, which is
> semantically incorrect.
> - Migration may fail incorrectly; e.g., migrating from pebs_fmt=2 to a
> more capable host (pebs_fmt=4) would be reported as missing pebs-fmt2.

For 2) & 3), I think if it's necessary, maybe it's time to re-consider
the previous multi-bits property:

https://lore.kernel.org/qemu-devel/20230106083826.5384-4-lei4.wang@intel.com/

But as for now, I think 1) is also okay. Since lbr-fmt seems very
similar to pebs-fmt, it's best to have them handle these fmt things in a
similar manner, otherwise it can make code maintenance troublesome.

> Given this, I propose the below changes. This may allow migration to a
> less capable destination, which is not ideal, but it avoids false
> “missing feature” bug and preserves the expectation that ensuring
> destination compatibility is the responsibility of the management
> application or the user.
> 
> BTW, I am not proposing a generic “x86 CPU numeric feature” mechanism at
> this time, as it is unclear whether lbr_fmt and pebs_fmt alone justify
> such a change.
> 
> diff --git a/target/i386/cpu.c b/target/i386/cpu.c
> index 015ba3fc9c7b..b6c95d5ceb31 100644
> --- a/target/i386/cpu.c
> +++ b/target/i386/cpu.c
> @@ -1629,6 +1629,7 @@ FeatureWordInfo feature_word_info[FEATURE_WORDS] = {
>          .msr = {
>              .index = MSR_IA32_PERF_CAPABILITIES,
>          },
> +       .migratable_flags = PERF_CAP_PEBS_FMT,

About the migration issue, I wonder whether it's necessary to migrate
pebs-fmt? IIUC, it seems not necessary: the guest's pebs-fmt depends on
host's pebs-fmt, but I'm sure what will happens when guest migrates to
a mahince with different pebs-fmt.

note, lbr-fmt seems not be migrated.

Thanks,
Zhao


