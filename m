Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13B1DA902
	for <lists+kvm@lfdr.de>; Wed, 20 May 2020 06:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgETESZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 May 2020 00:18:25 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:4823 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725785AbgETESZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 May 2020 00:18:25 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 24DE0BE1E417F974CF3B;
        Wed, 20 May 2020 12:17:18 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.58) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.487.0; Wed, 20 May 2020
 12:17:10 +0800
Subject: Re: [kvm-unit-tests PATCH 6/6] arm64: microbench: Add vtimer latency
 test
To:     Andrew Jones <drjones@redhat.com>
CC:     <kvm@vger.kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <maz@kernel.org>, <wanghaibin.wang@huawei.com>,
        <yuzenghui@huawei.com>, <eric.auger@redhat.com>
References: <20200517100900.30792-1-wangjingyi11@huawei.com>
 <20200517100900.30792-7-wangjingyi11@huawei.com>
 <20200518070507.pvs4iol34wc2zjkz@kamzik.brq.redhat.com>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <b54b95c3-3403-f625-a592-fd2eddb96f50@huawei.com>
Date:   Wed, 20 May 2020 12:16:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200518070507.pvs4iol34wc2zjkz@kamzik.brq.redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.58]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 5/18/2020 3:05 PM, Andrew Jones wrote:
> On Sun, May 17, 2020 at 06:09:00PM +0800, Jingyi Wang wrote:
>> Triggers PPIs by setting up a 10msec timer and test the latency.
>> For this test can be time consuming, we add time limit for loop_test
>> to make sure each test should be done in a certain time(5 sec here).
> 
> Having a time limit for the micro-bench tests might be a good idea, as
> the overall unit test timeout configured by unittests.cfg can't measure
> each individual micro-bench test separately, but it seems what we're
> really doing here is saying that we can't do 65536 10ms long vtimer-ppi
> tests, so let's do 500 instead -- however by using time to dictate the
> count.
> 
> I think I'd rather see NTIMES be changed to a micro-bench test parameter
> that defaults to 65536, but for the vtimer-ppi test it can be set to
> something much smaller.
> 
> Also, please create a separate patch for the loop_test()/ntimes changes.
> If you'd still like to do a per micro-bench test timeout as well, then
> please create a separate patch for that too.
> 
> Thanks,
> drew
> 

Thanks for your review, I will update that in the next version.

Thanks,
Jingyi

