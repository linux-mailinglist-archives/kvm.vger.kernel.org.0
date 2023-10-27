Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 262C77D906C
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 09:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbjJ0H5j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 03:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231233AbjJ0H5h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 03:57:37 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF386196
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 00:57:34 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4SGw186RG3zrTrv;
        Fri, 27 Oct 2023 15:54:36 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Fri, 27 Oct 2023 15:57:31 +0800
Subject: Re: [PATCH v2] KVM: arm64: Add tracepoint for MMIO accesses where
 ISV==0
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
References: <20231026205306.3045075-1-oliver.upton@linux.dev>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <bea04979-01d3-fa30-bb81-ea67119a9612@huawei.com>
Date:   Fri, 27 Oct 2023 15:57:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20231026205306.3045075-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
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

On 2023/10/27 4:53, Oliver Upton wrote:
> It is a pretty well known fact that KVM does not support MMIO emulation
> without valid instruction syndrome information (ESR_EL2.ISV == 0). The
> current kvm_pr_unimpl() is pretty useless, as it contains zero context
> to relate the event to a vCPU.
> 
> Replace it with a precise tracepoint that dumps the relevant context
> so the user can make sense of what the guest is doing.
> 
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>

Acked-by: Zenghui Yu <yuzenghui@huawei.com>
