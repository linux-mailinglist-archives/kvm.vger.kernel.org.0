Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D211E41D534
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 10:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348964AbhI3II5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 04:08:57 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:24160 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349254AbhI3IIS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 04:08:18 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4HKm4p4KzQz1DHQH;
        Thu, 30 Sep 2021 16:05:14 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:06:34 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 16:06:31 +0800
Subject: Re: [PATCH v7 12/15] KVM: arm64: selftests: Add basic GICv3 support
To:     Raghavendra Rao Ananta <rananta@google.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>,
        "Andrew Jones" <drjones@redhat.com>,
        James Morse <james.morse@arm.com>,
        "Alexandru Elisei" <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        <kvm@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
        Peter Shier <pshier@google.com>,
        <linux-kernel@vger.kernel.org>, Will Deacon <will@kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20210914223114.435273-1-rananta@google.com>
 <20210914223114.435273-13-rananta@google.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ab2a7213-1857-6761-594d-958af864a23a@huawei.com>
Date:   Thu, 30 Sep 2021 16:06:31 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210914223114.435273-13-rananta@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/9/15 6:31, Raghavendra Rao Ananta wrote:
> +static inline void *gicr_base_gpa_cpu(void *redist_base, uint32_t cpu)
> +{
> +	/* Align all the redistributors sequentially */
> +	return redist_base + cpu * SZ_64K * 2;
> +}
> +
> +static void gicv3_cpu_init(unsigned int cpu, void *redist_base)
> +{
> +	void *sgi_base;
> +	unsigned int i;
> +	void *redist_base_cpu;
> +
> +	GUEST_ASSERT(cpu < gicv3_data.nr_cpus);
> +
> +	redist_base_cpu = gicr_base_gpa_cpu(redist_base, cpu);

This is not 'gpa' and I'd rather open-code it directly as there's
just a single caller.

Zenghui
