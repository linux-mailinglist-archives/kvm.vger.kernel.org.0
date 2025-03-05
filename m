Return-Path: <kvm+bounces-40161-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8704AA501DA
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 15:26:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ED43C3B2604
	for <lists+kvm@lfdr.de>; Wed,  5 Mar 2025 14:24:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED14B24C061;
	Wed,  5 Mar 2025 14:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XDa/ZB7O"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938661624D2
	for <kvm@vger.kernel.org>; Wed,  5 Mar 2025 14:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741184649; cv=none; b=q5063nAi6gZASJSIJGszVaiojmtis0O1gkFtSYjmK7C7zfue9gybuz1nDWrMlpILimViWrqe9Abb6XiUEYE29ehgbAr7n13qeeaAvr9f+DI9vKUew3Ai8htsyOiKQfrWFK6YThZWe232HqnxdaOy9DMsRnKj/VLZuoZ0rEoIf+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741184649; c=relaxed/simple;
	bh=x05EX333NKXOFTqc+uZagDz/CRKZvPUFB+nBn2iqWig=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BRYwSGTLjINpAZZGRwstrC5Yj+Do2sF3lngoq4N1wtk8gVZFnASE1+yIgxC8xtb5UKvmd7JoiTWUXMG7Fnjg6S0I+0ZhyrfbDYKaHEuePQeL4hE8EZ4zFTP9K6GIlwEpLyUkFzk5xZ0RLSAcFEOF8dg8nMcuZbqLz2G6TqpnIgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XDa/ZB7O; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1741184648; x=1772720648;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=x05EX333NKXOFTqc+uZagDz/CRKZvPUFB+nBn2iqWig=;
  b=XDa/ZB7Oa7wlrjAdPWGewxarB5PgTqLFJOd7OV5P8Aq9ahR3dPYVPurN
   UgYSlyEQXEdQdnk+RclLPYMQVBYs4SYX4Y7e5A3b6lcnDL537sCmj/3bR
   DbMEJSN7eNSd12b9yV0/z7gZxVfjZ/Xo4/p8jIvzIVE+Ut4TdO8kcEY7N
   w3rgt8CgS4eT5Pxo8q5UDOzryIWNjzRcivvpYrn/RBVQ0yik3tLQjnKbC
   dQbUJzS2zjhkaoqP8nY++hmqwtMJhmRsSSDzUuJ+hqJDy2ffDDNv77iDK
   TByD7HJTJklG1UiCKAe5rBeMLu5TLNIjhltbjMKCg/7nNUSa7AWm7l/rT
   g==;
X-CSE-ConnectionGUID: 8CVxe2zsSPOm2wWpe5n6ew==
X-CSE-MsgGUID: KzusLbJHRZC6KPNpQNhfcA==
X-IronPort-AV: E=McAfee;i="6700,10204,11363"; a="42012953"
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="42012953"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Mar 2025 06:24:07 -0800
X-CSE-ConnectionGUID: oJrAzU2STQK/lNbn55v2gQ==
X-CSE-MsgGUID: 80ywhNNrQOCT2LwTfPLMPw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,223,1736841600"; 
   d="scan'208";a="123740616"
Received: from liuzhao-optiplex-7080.sh.intel.com (HELO localhost) ([10.239.160.39])
  by orviesa004.jf.intel.com with ESMTP; 05 Mar 2025 06:24:03 -0800
Date: Wed, 5 Mar 2025 22:44:10 +0800
From: Zhao Liu <zhao1.liu@intel.com>
To: Dongli Zhang <dongli.zhang@oracle.com>
Cc: qemu-devel@nongnu.org, kvm@vger.kernel.org, pbonzini@redhat.com,
	mtosatti@redhat.com, sandipan.das@amd.com, babu.moger@amd.com,
	likexu@tencent.com, like.xu.linux@gmail.com,
	zhenyuw@linux.intel.com, groug@kaod.org, khorenko@virtuozzo.com,
	alexander.ivanov@virtuozzo.com, den@virtuozzo.com,
	davydov-max@yandex-team.ru, xiaoyao.li@intel.com,
	dapeng1.mi@linux.intel.com, joe.jin@oracle.com
Subject: Re: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
 "-pmu" is configured
Message-ID: <Z8hjOgFURpgApBX5@intel.com>
References: <20250302220112.17653-1-dongli.zhang@oracle.com>
 <20250302220112.17653-5-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250302220112.17653-5-dongli.zhang@oracle.com>

On Sun, Mar 02, 2025 at 02:00:12PM -0800, Dongli Zhang wrote:
> Date: Sun,  2 Mar 2025 14:00:12 -0800
> From: Dongli Zhang <dongli.zhang@oracle.com>
> Subject: [PATCH v2 04/10] target/i386/kvm: set KVM_PMU_CAP_DISABLE if
>  "-pmu" is configured
> X-Mailer: git-send-email 2.43.5
> 
> Although AMD PERFCORE and PerfMonV2 are removed when "-pmu" is configured,
> there is no way to fully disable KVM AMD PMU virtualization. Neither
> "-cpu host,-pmu" nor "-cpu EPYC" achieves this.
> 
> As a result, the following message still appears in the VM dmesg:
> 
> [    0.263615] Performance Events: AMD PMU driver.
> 
> However, the expected output should be:
> 
> [    0.596381] Performance Events: PMU not available due to virtualization, using software events only.
> [    0.600972] NMI watchdog: Perf NMI watchdog permanently disabled
> 
> This occurs because AMD does not use any CPUID bit to indicate PMU
> availability.
> 
> To address this, KVM_CAP_PMU_CAPABILITY is used to set KVM_PMU_CAP_DISABLE
> when "-pmu" is configured.
> 
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
> Changed since v1:
>   - Switch back to the initial implementation with "-pmu".
> https://lore.kernel.org/all/20221119122901.2469-3-dongli.zhang@oracle.com
>   - Mention that "KVM_PMU_CAP_DISABLE doesn't change the PMU behavior on
>     Intel platform because current "pmu" property works as expected."
> 
>  target/i386/kvm/kvm.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)

Overall LGTM. And with Xiaoyao's comment fixed :-)

Reviewed-by: Zhao Liu <zhao1.liu@intel.com>

Thanks,
Zhao


