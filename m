Return-Path: <kvm+bounces-5525-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E97F822C50
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 12:43:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF66C1F2424E
	for <lists+kvm@lfdr.de>; Wed,  3 Jan 2024 11:43:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4706518EB5;
	Wed,  3 Jan 2024 11:43:24 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0498818EA0;
	Wed,  3 Jan 2024 11:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F718C15;
	Wed,  3 Jan 2024 03:44:07 -0800 (PST)
Received: from [10.57.45.90] (unknown [10.57.45.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6DA563F7A6;
	Wed,  3 Jan 2024 03:43:17 -0800 (PST)
Message-ID: <70c8336b-1244-45bd-b078-bb07f771741c@arm.com>
Date: Wed, 3 Jan 2024 11:43:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] kvm: arm64: introduce new flag for non-cacheable
 IO memory
Content-Language: en-GB
To: ankita@nvidia.com, jgg@nvidia.com, maz@kernel.org,
 oliver.upton@linux.dev, yuzenghui@huawei.com, catalin.marinas@arm.com,
 will@kernel.org, alex.williamson@redhat.com, kevin.tian@intel.com,
 yi.l.liu@intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 gshan@redhat.com, linux-mm@kvack.org, lpieralisi@kernel.org
Cc: aniketa@nvidia.com, cjia@nvidia.com, kwankhede@nvidia.com,
 targupta@nvidia.com, vsethi@nvidia.com, acurrid@nvidia.com,
 apopple@nvidia.com, jhubbard@nvidia.com, danw@nvidia.com, mochs@nvidia.com,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
References: <20231208164709.23101-1-ankita@nvidia.com>
 <20231208164709.23101-2-ankita@nvidia.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20231208164709.23101-2-ankita@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/12/2023 16:47, ankita@nvidia.com wrote:
> From: Ankit Agrawal <ankita@nvidia.com>
> 
> For various reasons described in the cover letter, and primarily to

Cover letter is not part of the git history. It doesn't hurt to repeat
the same here for the sake of referring, given how important that is.


Suzuki


