Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E6C7AC793
	for <lists+kvm@lfdr.de>; Sun, 24 Sep 2023 12:32:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbjIXKcU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 24 Sep 2023 06:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbjIXKcT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 24 Sep 2023 06:32:19 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B883CE;
        Sun, 24 Sep 2023 03:32:12 -0700 (PDT)
Received: from kwepemm000007.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Rtj1c4kWQzrRg3;
        Sun, 24 Sep 2023 18:29:56 +0800 (CST)
Received: from [10.174.185.179] (10.174.185.179) by
 kwepemm000007.china.huawei.com (7.193.23.189) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.31; Sun, 24 Sep 2023 18:32:07 +0800
Subject: Re: [GIT PULL] KVM fixes for Linux 6.6-rc3
To:     Paolo Bonzini <pbonzini@redhat.com>
CC:     <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <kvm@vger.kernel.org>
References: <20230924092700.1192123-1-pbonzini@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <5cfe9a47-f461-9a5e-09e3-b78fef16a6f6@huawei.com>
Date:   Sun, 24 Sep 2023 18:32:07 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20230924092700.1192123-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemm000007.china.huawei.com (7.193.23.189)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

On 2023/9/24 17:27, Paolo Bonzini wrote:
> ARM:
> 
> * Fix an UV boot crash
> 
> * Skip spurious ENDBR generation on_THIS_IP_
> 
> * Fix ENDBR use in putuser() asm methods
> 
> * Fix corner case boot crashes on 5-level paging
> 
> * and fix a false positive WARNING on LTO kernels"

Want to point out that this doesn't describe the *real* kvmarm stuff in
the original PR [*] and doesn't match what you had written in the merge
commit. Not sure what has gone wrong.

[*] https://lore.kernel.org/r/20230914144802.1637804-1-maz@kernel.org

Zenghui
