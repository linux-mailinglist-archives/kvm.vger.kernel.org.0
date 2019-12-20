Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96EA9127682
	for <lists+kvm@lfdr.de>; Fri, 20 Dec 2019 08:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726002AbfLTHeb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Dec 2019 02:34:31 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:8160 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725874AbfLTHeb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Dec 2019 02:34:31 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 3DF20FFEDCEF0B4DF2E7;
        Fri, 20 Dec 2019 15:34:29 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Fri, 20 Dec 2019
 15:34:22 +0800
Subject: Re: [kvm-unit-tests PATCH 05/16] arm/arm64: ITS: Introspection tests
To:     Auger Eric <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <andre.przywara@arm.com>, <drjones@redhat.com>,
        <alexandru.elisei@arm.com>, <thuth@redhat.com>,
        <peter.maydell@linaro.org>
References: <20191216140235.10751-1-eric.auger@redhat.com>
 <20191216140235.10751-6-eric.auger@redhat.com>
 <c133ebe6-10f4-2ff7-f75f-75b755397785@huawei.com>
 <6542297b-74d2-f3c2-63d8-04bb284414df@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <c164db0f-2e18-093f-8886-4746cb197fe2@huawei.com>
Date:   Fri, 20 Dec 2019 15:34:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <6542297b-74d2-f3c2-63d8-04bb284414df@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/12/18 16:34, Auger Eric wrote:
> Hi Zenghui,
> 
> On 12/18/19 4:46 AM, Zenghui Yu wrote:
>> Hi Eric,
>>
>> I have to admit that this is the first time I've looked into
>> the kvm-unit-tests code, so only some minor comments inline :)
> 
> no problem. Thank you for looking at this.
> 
> By the way, with patch 16 I was able to test yout fix: "KVM: arm/arm64:
> vgic: Don't rely on the wrong pending table". Reverting it produced an
> error.

which is great! Thanks for your work!


Zenghui

