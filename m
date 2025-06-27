Return-Path: <kvm+bounces-50935-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 341C3AEACCF
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 04:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 04ED53B42B1
	for <lists+kvm@lfdr.de>; Fri, 27 Jun 2025 02:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01CB2191F89;
	Fri, 27 Jun 2025 02:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="f4Dr3Kah"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19C171419A9
	for <kvm@vger.kernel.org>; Fri, 27 Jun 2025 02:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750991002; cv=none; b=uoqwv701rjpMnc3/KCWP+vUOa+fkUT9X4PTMdF3uEM4Bq+VgqYhJt3u5s7ZMmhXFvjfY6nokuk9/ERx6ayomnQh/8ZBi6VahaETQm1qjySKT2Uwsb65v4RJ2gj5yhcybfSfiIXag1/656EwzNqRnDukJy0XamjehESjlVFBAJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750991002; c=relaxed/simple;
	bh=khoZeGPwgU5Hra3XCMmdt3c5kfTHgJq0dsqQgxHsB5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qbcTuAosWy1Um+2PXXV+ZcvCLhJxOWershsm/7uL/es8tOZsng3Fy3NU38scYjs/6+1MAjmdEV3Kv3Pt+m8jXH+p7O7XwFns1kQ7Zo3/Pyq5GHzUNFQ03ofnbK3vhGUApwmBiErvAhj+F26yYRkZu02Ml1o3k/26bLo49o6OsaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=f4Dr3Kah; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750991000; x=1782527000;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=khoZeGPwgU5Hra3XCMmdt3c5kfTHgJq0dsqQgxHsB5o=;
  b=f4Dr3Kah/rKipDUNU/eGtLla8/k8IeHsGSgN1HEypknjnl1EtKHRscLY
   dLXZfp0e4b+cvoC1RY2eIi+z/3EKSF1RPO1nGFa0cRQd3E40oW2zudW8q
   KUmaMa11ZjX1yluCeFLvy3h1V79gIGrwnppCZ/RTlc0PqhI5/QI6TWZwd
   zJ/ubJTPqb7lRpe4IoG6wDz38ZJgukyXi5SHSa1e3nBSr7c43QFMSXg8U
   nkmTFGt8xm4ieXde0tZACoEL/rqsT53gzUJ6/HNx9YbkRmtL2IQYRqUAV
   5wztOVJnOp1qaWkxThs7a8+vt+cEHHYP7R+c0XsY+uMvJROC/jnWPBD4w
   Q==;
X-CSE-ConnectionGUID: mf8vXNv/SgWw1K/H+Pgm4Q==
X-CSE-MsgGUID: irE2TmC6RLK3wrznTneHIg==
X-IronPort-AV: E=McAfee;i="6800,10657,11476"; a="63560026"
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="63560026"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2025 19:23:19 -0700
X-CSE-ConnectionGUID: GuD71LP5TS6Kmux6WRhQIA==
X-CSE-MsgGUID: Nym2nvKITvO+CD4KyKSRmQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,269,1744095600"; 
   d="scan'208";a="183575212"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by fmviesa001.fm.intel.com with ESMTP; 26 Jun 2025 19:23:15 -0700
Date: Fri, 27 Jun 2025 10:44:38 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Ewan Hai <ewanhai-oc@zhaoxin.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Daniel P =?iso-8859-1?Q?=2E_Berrang=E9?= <berrange@redhat.com>,
	Igor Mammedov <imammedo@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Philippe =?iso-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>,
	Babu Moger <babu.moger@amd.com>, Pu Wen <puwen@hygon.cn>,
	Tao Su <tao1.su@intel.com>, Yi Lai <yi1.lai@intel.com>,
	Dapeng Mi <dapeng1.mi@intel.com>, qemu-devel@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PATCH 05/16] i386/cpu: Consolidate CPUID 0x4 leaf
Message-ID: <aF4FlifQciTFxNpv@intel.com>
References: <20250620092734.1576677-1-zhao1.liu@intel.com>
 <20250620092734.1576677-6-zhao1.liu@intel.com>
 <fe3c59c0-446c-4e93-9a8b-32c5314df401@zhaoxin.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe3c59c0-446c-4e93-9a8b-32c5314df401@zhaoxin.com>

> > +/* Encode cache info for CPUID[4] */
> 
> Maybe this should be /* Encode cache info for CPUID[2] */ ?
> I'm not sure.

Yep, you're right! The following function is used to encode CPUID[2]
as its name indicates.

> > +static void encode_cache_cpuid2(X86CPU *cpu,
> > +                                uint32_t *eax, uint32_t *ebx,
> > +                                uint32_t *ecx, uint32_t *edx)
> > +{

Thanks,
Zhao


