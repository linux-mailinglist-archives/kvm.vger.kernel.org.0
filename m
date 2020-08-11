Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79E1E2414A3
	for <lists+kvm@lfdr.de>; Tue, 11 Aug 2020 03:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728081AbgHKBse (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 10 Aug 2020 21:48:34 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:9359 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727985AbgHKBsd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 10 Aug 2020 21:48:33 -0400
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 33EC877B1A183CF848FE;
        Tue, 11 Aug 2020 09:48:31 +0800 (CST)
Received: from [127.0.0.1] (10.174.187.42) by DGGEMS402-HUB.china.huawei.com
 (10.3.19.202) with Microsoft SMTP Server id 14.3.487.0; Tue, 11 Aug 2020
 09:48:24 +0800
Subject: Re: [kvm-unit-tests PATCH v3 00/10] arm/arm64: Add IPI/LPI/vtimer
 latency test
To:     Marc Zyngier <maz@kernel.org>
CC:     <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>, <eric.auger@redhat.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20200731074244.20432-1-wangjingyi11@huawei.com>
 <957a4657-7e17-b173-ea4d-10c29ab9e3cd@huawei.com>
 <0bd81d1da9040fce660af46763507ac2@kernel.org>
From:   Jingyi Wang <wangjingyi11@huawei.com>
Message-ID: <54de9edf-3cca-f968-1ea8-027556b5f5ff@huawei.com>
Date:   Tue, 11 Aug 2020 09:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <0bd81d1da9040fce660af46763507ac2@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.187.42]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 8/5/2020 8:13 PM, Marc Zyngier wrote:
> On 2020-08-05 12:54, Jingyi Wang wrote:
>> Hi all,
>>
>> Currently, kvm-unit-tests only support GICv3 vLPI injection. May I ask
>> is there any plan or suggestion on constructing irq bypass mechanism
>> to test vLPI direct injection in kvm-unit-tests?
> 
> I'm not sure what you are asking for here. VLPIs are only delivered
> from a HW device, and the offloading mechanism isn't visible from
> userspace (you either have an enabled GICv4 implementation, or
> you don't).
> 
> There are ways to *trigger* device MSIs from userspace and inject
> them in a guest, but that's only a debug feature, which shouldn't
> be enabled on a production system.
> 
>          M.

Sorry for the late reply.

As I mentioned before, we want to add vLPI direct injection test
in KUT, meanwhile measure the latency of hardware vLPI injection.

Sure, vLPI is triggered by hardware. Since kernel supports sending
ITS INT command in guest to trigger vLPI, I wonder if it is possible
to add an extra interface to make a vLPI hardware-offload(just as
kvm_vgic_v4_set_forwarding() does). If so, vgic_its_trigger_msi()
can inject vLPI directly instead of using LR.

Thanks,
Jingyi

