Return-Path: <kvm+bounces-36470-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C2631A1B138
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 09:00:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0F36116A5F6
	for <lists+kvm@lfdr.de>; Fri, 24 Jan 2025 08:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97A31DB356;
	Fri, 24 Jan 2025 08:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iPVrV5a8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3961D9A6F
	for <kvm@vger.kernel.org>; Fri, 24 Jan 2025 08:00:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737705626; cv=none; b=U59DOafGt7X2VovTWmmXxM9BKwyhMhXD/rErFGBWDtYn6dqEczJv5FBYQYAmUSyZRXNpoa8byETmjqPND8R8wGWqazx0QdC1u6P8xSgB7cC1HSHUTYrrmQHdzD2+2gMmqqR9li/vh5vprje//gNZzp52OZP62iaucgtzy2ulGIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737705626; c=relaxed/simple;
	bh=vraGi2N1692lrsWeJJ0uu42/dKCVO3ev6i4xeRW/SPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RZZxaSvXNQy7YM1x/UG6DhNO3niz2laS2XJK8KhM+fZKV3ban1y87AC7rib2jbfZiSTv3pwf++ddoouibv1O/4xg/2aHuiXzr58VodOdTBT7EvILRTNDuQuCYobIVTPUEAacd4GNatLiacdxnA+TOQJjOVSp0ODzD1/XzmUzkDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iPVrV5a8; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1737705624; x=1769241624;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vraGi2N1692lrsWeJJ0uu42/dKCVO3ev6i4xeRW/SPE=;
  b=iPVrV5a854HuRzt/0skKPckXerUroBqU9xLIkAhoYXg7yQhCkUCNSFjt
   qrb6xUoHlt/GusO6L2oOlg5q91Xd/UJbLHlQW9fhxFtEJGehIh1kTFoDQ
   6L2Y5fK5jqfe5xkWGcoPKCTvPoNHvL7mBN1NW8MHUQAOH1dYGHMaBVFA2
   ZzS60HPsVk1Z2CRdBkzAcV66Ud1xRiVJWr57fwqIxZR8f4uyC85dOSiC7
   dJNTiFRfEJjFY77cyc8qu9DZcqdaWoKhKXygPJgwURPgJ1RGaUchOjLnq
   7Zwi9f8qFfUciJd3kPZWsAehGFRPPs/FTTIpUVO96qw4SSwUy3YsMDKby
   Q==;
X-CSE-ConnectionGUID: xbWyt1fOROOfyWAYwEXTNg==
X-CSE-MsgGUID: ZfH5HfeUStSCj1xoldAltQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11324"; a="55777004"
X-IronPort-AV: E=Sophos;i="6.13,230,1732608000"; 
   d="scan'208";a="55777004"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 00:00:23 -0800
X-CSE-ConnectionGUID: bE10kcECQN2Wk7Meqpyilw==
X-CSE-MsgGUID: 6kwZ9b72RjmqMF9SAtVmrg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="108589618"
Received: from ly-workstation.sh.intel.com (HELO ly-workstation) ([10.239.161.23])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2025 00:00:19 -0800
Date: Fri, 24 Jan 2025 16:00:13 +0800
From: "Lai, Yi" <yi1.lai@linux.intel.com>
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Eric Blake <eblake@redhat.com>,
	Markus Armbruster <armbru@redhat.com>,
	Michael Roth <michael.roth@amd.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>, Eric Auger <eauger@redhat.com>,
	Peter Maydell <peter.maydell@linaro.org>,
	Laurent Vivier <lvivier@redhat.com>, Thomas Huth <thuth@redhat.com>,
	Sebastian Ott <sebott@redhat.com>, Gavin Shan <gshan@redhat.com>,
	qemu-devel@nongnu.org, kvm@vger.kernel.org, qemu-arm@nongnu.org,
	Dapeng Mi <dapeng1.mi@intel.com>, Yi Lai <yi1.lai@intel.com>
Subject: Re: [RFC v2 0/5] accel/kvm: Support KVM PMU filter
Message-ID: <Z5NIjXYCvNtYohc+@ly-workstation>
References: <20250122090517.294083-1-zhao1.liu@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250122090517.294083-1-zhao1.liu@intel.com>

On Wed, Jan 22, 2025 at 05:05:12PM +0800, Zhao Liu wrote:
> Hi folks,
> 
> Sorry for the long wait, but RFC v2 is here at last.
> 
> Compared with v1 [1], v2 mianly makes `action` as a global parameter,
> and all events (and fixed counters) are based on a unified action.
> 
> Learned from the discussion with Shaoqin in v1, current pmu-filter QOM
> design could meet the requirements from the ARM KVM side.
> 
>

Tested the v2 patches series with v6.13 kernel.

The 3 supported event formats work correctly with both action "allow" and
"deny". The x86-fixed-counter support also works as expected.

Regards,
Yi Lai

> Background
> ==========
> 
> I picked up Shaoqing's previous work [2] on the KVM PMU filter for arm,
> and now is trying to support this feature for x86 with a JSON-compatible
> API.
> 
> While arm and x86 use different KVM ioctls to configure the PMU filter,
> considering they all have similar inputs (PMU event + action), it is
> still possible to abstract a generic, cross-architecture kvm-pmu-filter
> object and provide users with a sufficiently generic or near-consistent
> QAPI interface.
> 
> That's what I did in this series, a new kvm-pmu-filter object, with the
> API like:
> 
> -object '{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","events":[{"format":"raw","code":"0xc4"}]}'
> 
> For i386, this object is inserted into kvm accelerator and is extended
> to support fixed-counter and more formats ("x86-default" and
> "x86-masked-entry"):
> 
> -accel kvm,pmu-filter=f0 \
> -object pmu='{"qom-type":"kvm-pmu-filter","id":"f0","action":"allow","x86-fixed-counter":{"bitmap":"0x0"},"events":[{"format":"x86-masked-entry","select":"0xc4","mask":"0xff","match":"0","exclude":true},{"format":"x86-masked-entry","select":"0xc5","mask":"0xff","match":"0","exclude":true}]}'
> 
> This object can still be added as the property to the arch CPU if it is
> desired as a per CPU feature (as Shaoqin did for arm before).
> 
> 
> Introduction
> ============
> 
> 
> Formats supported in kvm-pmu-filter
> -----------------------------------
> 
> This series supports 3 formats:
> 
> * raw format (general format).
> 
>   This format indicates the code that has been encoded to be able to
>   index the PMU events, and which can be delivered directly to the KVM
>   ioctl. For arm, this means the event code, and for i386, this means
>   the raw event with the layout like:
> 
>       select high bit | umask | select low bits
> 
> * x86-default format (i386 specific)
> 
>   x86 commonly uses select&umask to identify PMU events, and this format
>   is used to support the select&umask. Then QEMU will encode select and
>   umask into a raw format code.
> 
> * x86-masked-entry (i386 specific)
> 
>   This is a special format that x86's KVM_SET_PMU_EVENT_FILTER supports.
> 
> 
> Hexadecimal value string
> ------------------------
> 
> In practice, the values associated with PMU events (code for arm, select&
> umask for x86) are often expressed in hexadecimal. Further, from linux
> perf related information (tools/perf/pmu-events/arch/*/*/*.json), x86/
> arm64/riscv/nds32/powerpc all prefer the hexadecimal numbers and only
> s390 uses decimal value.
> 
> Therefore, it is necessary to support hexadecimal in order to honor PMU
> conventions.
> 
> However, unfortunately, standard JSON (RFC 8259) does not support
> hexadecimal numbers. So I can only consider using the numeric string in
> the QAPI and then parsing it to a number.
> 
> To achieve this, I defined two versions of PMU-related structures in
> kvm.json:
>  * a native version that accepts numeric values, which is used for
>    QEMU's internal code processing,
> 
>  * and a variant version that accepts numeric string, which is used to
>    receive user input.
> 
> kvm-pmu-filter object will take care of converting the string version
> of the event/counter information into the numeric version.
> 
> The related implementation can be found in patch 1.
> 
> 
> CPU property v.s. KVM property
> ------------------------------
> 
> In Shaoqin's previous implementation [2], KVM PMU filter is made as a
> arm CPU property. This is because arm uses a per CPU ioctl
> (KVM_SET_DEVICE_ATTR) to configure KVM PMU filter.
> 
> However, for x86, the dependent ioctl (KVM_SET_PMU_EVENT_FILTER) is per
> VM. In the meantime, considering that for hybrid architecture, maybe in
> the future there will be a new per vCPU ioctl, or there will be
> practices to support filter fixed counter by configuring CPUIDs.
> 
> Based on the above thoughts, for x86, it is not appropriate to make the
> current per-VM ioctl-based PMU filter a CPU property. Instead, I make it
> a kvm property and configure it via "-accel kvm,pmu-filter=obj_id".
> 
> So in summary, it is feasible to use the KVM PMU filter as either a CPU
> or a KVM property, depending on whether it is used as a CPU feature or a
> VM feature.
> 
> The kvm-pmu-filter object, as an abstraction, is general enough to
> support filter configurations for different scopes (per-CPU or per-VM).
> 
> [1]: https://lore.kernel.org/qemu-devel/20240710045117.3164577-1-zhao1.liu@intel.com/
> [2]: https://lore.kernel.org/qemu-devel/20240409024940.180107-1-shahuang@redhat.com/
> 
> Thanks and Best Regards,
> Zhao
> ---
> Zhao Liu (5):
>   qapi/qom: Introduce kvm-pmu-filter object
>   i386/kvm: Support basic KVM PMU filter
>   i386/kvm: Support event with select & umask format in KVM PMU filter
>   i386/kvm: Support event with masked entry format in KVM PMU filter
>   i386/kvm: Support fixed counter in KVM PMU filter
> 
>  MAINTAINERS              |   1 +
>  accel/kvm/kvm-pmu.c      | 386 +++++++++++++++++++++++++++++++++++++++
>  accel/kvm/meson.build    |   1 +
>  include/system/kvm-pmu.h |  44 +++++
>  include/system/kvm_int.h |   2 +
>  qapi/kvm.json            | 246 +++++++++++++++++++++++++
>  qapi/meson.build         |   1 +
>  qapi/qapi-schema.json    |   1 +
>  qapi/qom.json            |   3 +
>  target/i386/kvm/kvm.c    | 176 ++++++++++++++++++
>  10 files changed, 861 insertions(+)
>  create mode 100644 accel/kvm/kvm-pmu.c
>  create mode 100644 include/system/kvm-pmu.h
>  create mode 100644 qapi/kvm.json
> 
> -- 
> 2.34.1
> 

