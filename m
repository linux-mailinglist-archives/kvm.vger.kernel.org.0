Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5827A4A40
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:57:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241567AbjIRM5A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241683AbjIRM4h (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:56:37 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AACB9C3
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 05:56:31 -0700 (PDT)
Received: from kwepemm600007.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Rq4W50wxgz15NK4;
        Mon, 18 Sep 2023 20:54:25 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm600007.china.huawei.com (7.193.23.208) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Mon, 18 Sep 2023 20:56:27 +0800
Subject: Re: [PATCH] KVM: arm64: Don't use kerneldoc comment for
 arm64_check_features()
To:     Oliver Upton <oliver.upton@linux.dev>
CC:     <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
        Marc Zyngier <maz@kernel.org>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Jing Zhang <jingzhangos@google.com>
References: <20230913165645.2319017-1-oliver.upton@linux.dev>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <e6b263fb-29fe-143b-b0ea-0fbc772fecb2@huawei.com>
Date:   Mon, 18 Sep 2023 20:56:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230913165645.2319017-1-oliver.upton@linux.dev>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600007.china.huawei.com (7.193.23.208)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2023/9/14 0:56, Oliver Upton wrote:
> A double-asterisk opening mark to the comment (i.e. '/**') indicates a
> comment block is in the kerneldoc format. There's automation in place to
> validate that kerneldoc blocks actually adhere to the formatting rules.
> 
> The function comment for arm64_check_features() isn't kerneldoc; use a
> 'regular' comment to silence automation warnings.
> 
> Link: https://lore.kernel.org/all/202309112251.e25LqfcK-lkp@intel.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>  arch/arm64/kvm/sys_regs.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
