Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861541290D4
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 03:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfLWCGu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 22 Dec 2019 21:06:50 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2535 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726215AbfLWCGu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 22 Dec 2019 21:06:50 -0500
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 21A7A9D47367D63EB243;
        Mon, 23 Dec 2019 10:06:47 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 23 Dec 2019 10:06:46 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Mon, 23
 Dec 2019 10:06:46 +0800
Subject: Re: [PATCH 1/5] KVM: arm64: Document PV-lock interface
To:     Markus Elfring <Markus.Elfring@web.de>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>
CC:     <linux-kernel@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        "Marc Zyngier" <maz@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Steven Price <steven.price@arm.com>,
        "Suzuki K. Poulose" <suzuki.poulose@arm.com>,
        Will Deacon <will@kernel.org>
References: <20191217135549.3240-2-yezengruan@huawei.com>
 <2337a083-499f-7778-7bf3-9f525a04e17a@web.de>
From:   yezengruan <yezengruan@huawei.com>
Message-ID: <6d798e02-7ab2-fc58-9f75-ee74de97ae72@huawei.com>
Date:   Mon, 23 Dec 2019 10:06:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <2337a083-499f-7778-7bf3-9f525a04e17a@web.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Markus,

On 2019/12/20 22:32, Markus Elfring wrote:
> …
>> +++ b/Documentation/virt/kvm/arm/pvlock.rst
> …
>> +Paravirtualized lock support for arm64
>> +======================================
>> +
>> +KVM/arm64 provids some …
> …
> 
> I suggest to avoid a typo here.

Thanks for posting this.

> 
> Regards,
> Markus
> 

Thanks,

Zengruan

