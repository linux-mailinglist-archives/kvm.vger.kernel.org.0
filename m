Return-Path: <kvm+bounces-30326-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A65DC9B9535
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 17:23:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6B2652812F5
	for <lists+kvm@lfdr.de>; Fri,  1 Nov 2024 16:23:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84CD21CB51D;
	Fri,  1 Nov 2024 16:22:58 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FEA31CB326;
	Fri,  1 Nov 2024 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730478178; cv=none; b=XYQybGn09rHylEfVTGm9kLC+sIIMLrEmeDKnCVdCxQUGJsGbKUoYdrcTcDyDdoW2MEkExbTD9QfVwkskJ+ztxvL1DjZQ3PcGojwREfN8lmI7LoMRyPLLpqhAlVhesdMyO/KUuTROg/Md5zPkfMI8k/9iBH5NzfBDxbxzenFA/go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730478178; c=relaxed/simple;
	bh=1CK+Pj/7Vm/XZD+AgmGRgSHzdRtBShTZGZhCe1Ise10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A/b5pf/N7JxT2bcn6oT5zxx6NpQJGeVAN2dgqdrhy+hhIerwGilWGUpAl3ugbAImBcSww+QWRoAFZ0Dr0uI0ZbOFwGpSukM+0WZb/SPsMEdR4kIVd8qPr5EduZzQ8bOOGQ/SOBxC4Yj+9g1zMOXHYrd/Mh3VPbv1F0zyI6uZ5bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 63407FEC;
	Fri,  1 Nov 2024 09:23:24 -0700 (PDT)
Received: from [10.1.33.21] (e122027.cambridge.arm.com [10.1.33.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53A63F73B;
	Fri,  1 Nov 2024 09:22:47 -0700 (PDT)
Message-ID: <a5967441-0ea7-4c17-a87b-3f95c0ef0642@arm.com>
Date: Fri, 1 Nov 2024 16:22:46 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/43] arm64: RME: ioctls to create and configure
 realms
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>
References: <20241004152804.72508-1-steven.price@arm.com>
 <20241004152804.72508-10-steven.price@arm.com> <yq5acyjic9dm.fsf@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yq5acyjic9dm.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 30/10/2024 07:55, Aneesh Kumar K.V wrote:
> Steven Price <steven.price@arm.com> writes:
> 
>> +
>> +out_undelegate_tables:
>> +	while (--i >= 0) {
>> +		phys_addr_t pgd_phys = kvm->arch.mmu.pgd_phys + i * PAGE_SIZE;
>> +
>> +		WARN_ON(rmi_granule_undelegate(pgd_phys));
>> +	}
>> +	WARN_ON(rmi_granule_undelegate(rd_phys));
>> +free_rd:
>> +	free_page((unsigned long)rd);
>> +	return r;
>> +}
>> +
> 
> we should avoid that free_page on an undelegate failure? rd_phys we can
> handle here. Not sure how to handle the pgd_phys.

Good point. I think for pgd_phys setting kvm->arch.mmu.pgt=NULL should
be sufficient to prevent the pages being freed.

Thanks,
Steve


