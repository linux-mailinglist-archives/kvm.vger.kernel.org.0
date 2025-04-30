Return-Path: <kvm+bounces-44878-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C2CCAA46CD
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 11:19:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D15201BA5637
	for <lists+kvm@lfdr.de>; Wed, 30 Apr 2025 09:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7971C221554;
	Wed, 30 Apr 2025 09:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FmVVrpX3"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D4C288CC;
	Wed, 30 Apr 2025 09:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746004645; cv=none; b=DkdgxIT3hRuVFklGnFICk2a2Jo94nVjDSgVCUULIyQEmnnXKJNVz8RK8o81TxJycx28ebfrMOFwZDK92wgYS+fyikj24hdBDH+WUl77gGWtiIBXngvndHyqRdmJBq3m+jpqyc6OH58vug2afb82AcEZsZAXR7jRldduHob+q98k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746004645; c=relaxed/simple;
	bh=0MRDc7XkKAhdLo9NoWiZ7a37tKdrUj31jPMIXHPElEQ=;
	h=From:Date:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RRBgKXohTast61fKl91rf3h/rwcItulzGAOl+ke5XhQwtP25bSfVXUz87MaiXjeom57bwORqkQlTji+OM/ywpXf8NxybgKyN73F8GhzrAjA5rD5xwNd/4BaGrjR/vQRTnuPUs2Quz1qniNn+W65J5pQbPlqUFBGrjCtDvTQK2kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FmVVrpX3; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746004644; x=1777540644;
  h=from:date:to:cc:subject:in-reply-to:message-id:
   references:mime-version:content-id;
  bh=0MRDc7XkKAhdLo9NoWiZ7a37tKdrUj31jPMIXHPElEQ=;
  b=FmVVrpX31idIr+m1wN1XNNIjWkNf4aLWdVD/AxCrITc/5edUx6E0zNP8
   aDIYb8DZbnlk1HuNqZvJVBIEUfB1iNau/84wrUaIOFqxfwY4MhRnCC+Yg
   0XgjPd3e8V9CMTZhrBbmPEij4eQYVnsQqhqa0KqZpC2KV/BuPRZPpkid2
   NufZNOoersoL9rdQEkBBwE1TJlC/0oEv7X2bfxTgiMJNaAZ9qJFaBOITF
   h2mZSuqvzT40KyLxAyAi4yj7Hz7mw3Bl2tr4C2uuHKvPE1XznOTY3NuZk
   U360C4u8lFW8pGfAIjedX0IdhMo1gfqVtQpjfwbtb27FVl5h8M9IQsstS
   A==;
X-CSE-ConnectionGUID: 6FmHRodMRnS6OZ1GM+ACqg==
X-CSE-MsgGUID: Y20vUwSeT2+ehYln9NDrSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11418"; a="73044385"
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="73044385"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 02:17:22 -0700
X-CSE-ConnectionGUID: /a7mAvi6S1y/UJBA/L4NuA==
X-CSE-MsgGUID: NSdWhcCYRFm9Gy2+IE0YuA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,251,1739865600"; 
   d="scan'208";a="139249217"
Received: from ijarvine-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.97])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2025 02:17:10 -0700
From: =?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Date: Wed, 30 Apr 2025 12:17:06 +0300 (EEST)
To: Xin Li <xin@zytor.com>
cc: LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org, 
    linux-perf-users@vger.kernel.org, linux-hyperv@vger.kernel.org, 
    virtualization@lists.linux.dev, linux-pm@vger.kernel.org, 
    linux-edac@vger.kernel.org, xen-devel@lists.xenproject.org, 
    linux-acpi@vger.kernel.org, linux-hwmon@vger.kernel.org, 
    Netdev <netdev@vger.kernel.org>, platform-driver-x86@vger.kernel.org, 
    tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, 
    dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, 
    acme@kernel.org, jgross@suse.com, andrew.cooper3@citrix.com, 
    peterz@infradead.org, namhyung@kernel.org, mark.rutland@arm.com, 
    alexander.shishkin@linux.intel.com, jolsa@kernel.org, irogers@google.com, 
    adrian.hunter@intel.com, kan.liang@linux.intel.com, wei.liu@kernel.org, 
    ajay.kaher@broadcom.com, bcm-kernel-feedback-list@broadcom.com, 
    tony.luck@intel.com, pbonzini@redhat.com, vkuznets@redhat.com, 
    seanjc@google.com, luto@kernel.org, boris.ostrovsky@oracle.com, 
    kys@microsoft.com, haiyangz@microsoft.com, decui@microsoft.com, 
    dapeng1.mi@linux.intel.com
Subject: Re: [PATCH v4 01/15] x86/msr: Add missing includes of <asm/msr.h>
In-Reply-To: <c16677bd-ee63-4032-8825-7d2789dd7555@zytor.com>
Message-ID: <d1bf0657-1cc5-b6ec-5601-f31efefacd9a@linux.intel.com>
References: <20250427092027.1598740-1-xin@zytor.com> <20250427092027.1598740-2-xin@zytor.com> <a1917b37-e41e-d303-749b-4007cda01605@linux.intel.com> <c16677bd-ee63-4032-8825-7d2789dd7555@zytor.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323328-830254077-1746003796=:7433"
Content-ID: <b1309532-f075-10c2-3416-1951dccf3d32@linux.intel.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-830254077-1746003796=:7433
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <d13050cf-2b1d-6913-5e66-9452e1353593@linux.intel.com>

On Wed, 30 Apr 2025, Xin Li wrote:

> On 4/29/2025 2:45 AM, Ilpo J=E4rvinen wrote:
> > >   arch/x86/events/msr.c                                         | 3 +=
++
> > >   arch/x86/events/perf_event.h                                  | 1 +
> > >   arch/x86/events/probe.c                                       | 2 +=
+
> > Under arch/x86/events/ a few files seem to be missing the include?
>=20
>=20
> Most C files in arch/x86/events/ include arch/x86/events/perf_event.h,
> thus they don't need to include <asm/msr.h> directly once
> arch/x86/events/perf_event.h includes <asm/msr.h>, and this patch does
> that.
>=20
>=20
> The following files include arch/x86/events/intel/uncore.h which includes
> arch/x86/events/perf_event.h, thus no change needed:
>     arch/x86/events/intel/uncore.c
>     arch/x86/events/intel/uncore_discovery.c
>     arch/x86/events/intel/uncore_nhmex.c
>     arch/x86/events/intel/uncore_snb.c
>     arch/x86/events/intel/uncore_snbep.c
>=20
> The following 2 files don't include arch/x86/events/perf_event.h so they
> include <asm/msr.h> directly with this patch:
>     arch/x86/events/msr.c
>     arch/x86/events/probe.c
>=20
> arch/x86/events/amd/uncore.c doesn't include
> arch/x86/events/perf_event.h but includes <asm/msr.h> already.
>=20
>=20
> So we are good in this directory, but it should be a separate patch with
> the above explanation then.

Hi,

While this is not my subsystem so don't have the final say here, you had=20
to explain quite much to prove that (and reviewer would have to go through=
=20
the same places to check). Wouldn't it be much simpler for all if all=20
those .c files would just include <asm/msr.h> directly? No need to explain=
=20
anything then.

Also, similar to what you're doing for some tsc related things in this=20
series, somebody could in the future decide that hey, these static inline=
=20
functions (that use .*msr.*) belong to some other file, allowing msr.h to=
=20
be removed from arch/x86/events/perf_event.h. Again, we'd need to add=20
asm/msr.h into more .c files. This is the problem with relying on indirect=
=20
includes, they create hard to track dependencies for #includes done in .h=
=20
files. If we actively encourage to depend on indirect #include=20
dependencies like that, it makes it very hard to  _remove_ any #include=20
from a header file (as you have yourself discovered).

--=20
 i.
--8323328-830254077-1746003796=:7433--

