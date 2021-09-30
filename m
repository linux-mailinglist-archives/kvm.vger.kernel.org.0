Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BE3341D688
	for <lists+kvm@lfdr.de>; Thu, 30 Sep 2021 11:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349499AbhI3Jmr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Sep 2021 05:42:47 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24205 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233877AbhI3Jmq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Sep 2021 05:42:46 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HKpBK4pYVz8tXd;
        Thu, 30 Sep 2021 17:40:09 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Thu, 30 Sep 2021 17:41:02 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Thu, 30 Sep 2021 17:41:01 +0800
Subject: Re: [PATCH v7 15/15] KVM: arm64: selftests: arch_timer: Support vCPU
 migration
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
 <20210914223114.435273-16-rananta@google.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <61419b8f-4da9-955e-b8e3-1d401d91ab1a@huawei.com>
Date:   Thu, 30 Sep 2021 17:41:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210914223114.435273-16-rananta@google.com>
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
>  static void test_run(struct kvm_vm *vm)
>  {
>  	int i, ret;
> +	pthread_t pt_vcpu_migration;
> +
> +	pthread_mutex_init(&vcpu_done_map_lock, NULL);
> +	vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);

This one fails to build.

aarch64/arch_timer.c: In function 'test_run':
aarch64/arch_timer.c:321:18: warning: implicit declaration of function 
'bitmap_alloc'; did you mean 'bitmap_zalloc'? 
[-Wimplicit-function-declaration]
   vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
                   ^~~~~~~~~~~~
                   bitmap_zalloc
aarch64/arch_timer.c:321:16: warning: assignment makes pointer from 
integer without a cast [-Wint-conversion]
   vcpu_done_map = bitmap_alloc(test_args.nr_vcpus);
                 ^
