Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885B47CD56B
	for <lists+kvm@lfdr.de>; Wed, 18 Oct 2023 09:17:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbjJRHRd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Oct 2023 03:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjJRHRc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Oct 2023 03:17:32 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F24B6
        for <kvm@vger.kernel.org>; Wed, 18 Oct 2023 00:17:29 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4S9MVx0Tt7zvPsr;
        Wed, 18 Oct 2023 15:12:41 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Wed, 18 Oct 2023 15:17:24 +0800
Subject: Re: [PATCH v2 5/5] KVM: arm64: Load the stage-2 MMU context in
 kvm_vcpu_load_vhe()
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20231012205422.3924618-1-oliver.upton@linux.dev>
 <20231012205422.3924618-6-oliver.upton@linux.dev>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <3f841c7a-b9ef-1dbf-ca0f-17dbeb3b73ff@huawei.com>
Date:   Wed, 18 Oct 2023 15:17:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20231012205422.3924618-6-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/10/13 4:54, Oliver Upton wrote:
> Hoist __stage2_load() into kvm_vcpu_load_vhe(), thus avoiding a reload

nit: s/__stage2_load/__load_stage2/
