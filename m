Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5B3617570
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 05:19:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbiKCESi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 00:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiKCESa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 00:18:30 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D5DCE14;
        Wed,  2 Nov 2022 21:18:29 -0700 (PDT)
Received: from kwepemi500012.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4N2r8t1XfJz15MKY;
        Thu,  3 Nov 2022 12:18:22 +0800 (CST)
Received: from [10.67.110.108] (10.67.110.108) by
 kwepemi500012.china.huawei.com (7.221.188.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 3 Nov 2022 12:18:25 +0800
Message-ID: <26cda02a-af8d-5976-9d3a-a595c0ed2fb6@huawei.com>
Date:   Thu, 3 Nov 2022 12:18:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 2/2] KVM: x86: Fix a typo about the usage of kvcalloc()
To:     Bagas Sanjaya <bagasdotme@gmail.com>
CC:     <seanjc@google.com>, <pbonzini@redhat.com>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>,
        <hpa@zytor.com>, <x86@kernel.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20221103011749.139262-1-liaochang1@huawei.com>
 <Y2Mpgm+zEetfZlWM@debian.me>
From:   "liaochang (A)" <liaochang1@huawei.com>
In-Reply-To: <Y2Mpgm+zEetfZlWM@debian.me>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.108]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500012.china.huawei.com (7.221.188.12)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



在 2022/11/3 10:37, Bagas Sanjaya 写道:
> This isn't typofix as suggested from the patch subject, right?

Well, since kvcalloc uses the product of 1st and 2nd argument to do allocation,
hence current code supposes to work well, but the usage is obviously no sense,
that is why i name it a 'typo' and make it correct ;)

-- 
BR,
Liao, Chang
