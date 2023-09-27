Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5ED57B03E3
	for <lists+kvm@lfdr.de>; Wed, 27 Sep 2023 14:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231644AbjI0MV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Sep 2023 08:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbjI0MV4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Sep 2023 08:21:56 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67928139
        for <kvm@vger.kernel.org>; Wed, 27 Sep 2023 05:21:51 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4RwbGv45skzNnM4;
        Wed, 27 Sep 2023 20:17:59 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 27 Sep 2023 20:21:48 +0800
Subject: Re: [PATCH kvmtool] arm: Initialize target in kvm_cpu__arch_init
To:     Mostafa Saleh <smostafa@google.com>
References: <20230927112117.3935537-1-smostafa@google.com>
CC:     <kvm@vger.kernel.org>, <will@kernel.org>,
        <julien.thierry.kdev@gmail.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <14f6ab95-7de0-9c4d-3d90-5c98923dbd77@huawei.com>
Date:   Wed, 27 Sep 2023 20:21:47 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230927112117.3935537-1-smostafa@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/27 19:21, Mostafa Saleh wrote:
> arm/kvm-cpu.c: In function ‘kvm_cpu__arch_init’:
> arm/kvm-cpu.c:119:41: error: ‘target’ may be used uninitialized [-Werror=maybe-uninitialized]
>   119 |         vcpu->cpu_compatible    = target->compatible;
>       |                                   ~~~~~~^~~~~~~~~~~~
> arm/kvm-cpu.c:40:32: note: ‘target’ was declared here
>    40 |         struct kvm_arm_target *target;
>       |                                ^~~~~~

Already addressed by 426e875213d3 ("arm/kvm-cpu: Fix new build
warning").

Zenghui
