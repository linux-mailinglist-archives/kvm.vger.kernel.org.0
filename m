Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03ACD7AA24F
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbjIUVPv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbjIUVPY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:15:24 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0293C0A
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 10:06:49 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4Rrwhw6CMrzVl4D;
        Thu, 21 Sep 2023 21:09:20 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Thu, 21 Sep 2023 21:12:19 +0800
Subject: Re: [PATCH v2 02/11] KVM: arm64: vgic-its: Treat the collection
 target address as a vcpu_id
To:     Marc Zyngier <maz@kernel.org>
CC:     <kvmarm@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>,
        <kvm@vger.kernel.org>, James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Joey Gouly <joey.gouly@arm.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Xu Zhao <zhaoxu.35@bytedance.com>,
        Eric Auger <eric.auger@redhat.com>
References: <20230920181731.2232453-1-maz@kernel.org>
 <20230920181731.2232453-3-maz@kernel.org>
 <d1d5ba61-1fac-a701-38db-b8bd5dcebeb8@huawei.com>
 <861qerpx3o.wl-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ac1d5bfb-39e1-650b-9ed1-bbcfbced277a@huawei.com>
Date:   Thu, 21 Sep 2023 21:12:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <861qerpx3o.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
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

On 2023/9/21 19:46, Marc Zyngier wrote:
> I have this additional hack which I plan to put on top.

Looks good. :-)
