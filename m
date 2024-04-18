Return-Path: <kvm+bounces-15115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FF288A9F94
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 18:07:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 342C7281DF5
	for <lists+kvm@lfdr.de>; Thu, 18 Apr 2024 16:07:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6664E171081;
	Thu, 18 Apr 2024 16:06:27 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A39E516F84D;
	Thu, 18 Apr 2024 16:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713456386; cv=none; b=qNKkeFtdrn4oijZ5/EQZAUC8gRWa5H3aOvDkovdSsFQX6FXyytsC977uJT0l5zRq9W71B4l3ifk18M+YG8PkUa1MWfHU/v9DyAnUgzgVPet2mtHv4aj/Mp+Lqgzx/tbSdnygBvU6Lw4U1kHA8ZtjwQgjs4/MCYEflc6XYUPpxMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713456386; c=relaxed/simple;
	bh=h09iCW/axBdidz8NSHC6ATGFyq1RaAUUpwPJbfK8h20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=thDgwRCMnSTz58LhFUOguutczdjKKOiW+yu+jezt1QGuWASXtFYJ0ezRwu/fWuJu3w0QR1t6FgWDLAU3PsQUq1ozq0HYIHQ2A6ZyCCrwtJkWdldiLqhKAj9wtvnJpNSxTp+BfNLwN2VNX7/VPGbYA5QyHeJ//zSgg/LiDVneYtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 071022F;
	Thu, 18 Apr 2024 09:06:53 -0700 (PDT)
Received: from [10.57.84.16] (unknown [10.57.84.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CEBC3F64C;
	Thu, 18 Apr 2024 09:06:22 -0700 (PDT)
Message-ID: <23173718-1e44-49ce-9666-4443c7295ed8@arm.com>
Date: Thu, 18 Apr 2024 17:06:20 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm
 guest
Content-Language: en-GB
To: kernel test robot <lkp@intel.com>, Steven Price <steven.price@arm.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Catalin Marinas <catalin.marinas@arm.com>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Zenghui Yu <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Jean-Philippe Brucker <jean-philippe@linaro.org>
References: <20240412084309.1733783-34-steven.price@arm.com>
 <202404140723.GKwnJxeZ-lkp@intel.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <202404140723.GKwnJxeZ-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 14/04/2024 00:44, kernel test robot wrote:
> Hi Steven,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on kvmarm/next]
> [also build test ERROR on kvm/queue arm64/for-next/core linus/master v6.9-rc3 next-20240412]
> [cannot apply to kvm/linux-next]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Steven-Price/KVM-Prepare-for-handling-only-shared-mappings-in-mmu_notifier-events/20240412-170311
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git next
> patch link:    https://lore.kernel.org/r/20240412084309.1733783-34-steven.price%40arm.com
> patch subject: [PATCH v2 33/43] arm64: rme: Enable PMU support with a realm guest
> config: arm64-randconfig-r064-20240414 (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/config)
> compiler: clang version 19.0.0git (https://github.com/llvm/llvm-project 8b3b4a92adee40483c27f26c478a384cd69c6f05)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20240414/202404140723.GKwnJxeZ-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202404140723.GKwnJxeZ-lkp@intel.com/

I guess the problem is with CONFIG_HW_PERF_EVENT not set, arm_pmu is an
empty struct, triggering all these errors.

Suzuki



