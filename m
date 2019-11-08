Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2811F42FC
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 10:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbfKHJUe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 04:20:34 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730719AbfKHJUe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 04:20:34 -0500
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 28A226947E7A8AEF4C2F;
        Fri,  8 Nov 2019 17:20:33 +0800 (CST)
Received: from [127.0.0.1] (10.184.12.158) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Fri, 8 Nov 2019
 17:20:23 +0800
Subject: Re: [PATCH 1/2] KVM: vgic-v4: Track the number of VLPIs per vcpu
To:     Marc Zyngier <maz@kernel.org>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>,
        <linux-arm-kernel@lists.infradead.org>
References: <20191107160412.30301-1-maz@kernel.org>
 <20191107160412.30301-2-maz@kernel.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <157648bc-00ce-7bf0-9e23-1a3790712c8c@huawei.com>
Date:   Fri, 8 Nov 2019 17:20:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20191107160412.30301-2-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.184.12.158]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Marc,

On 2019/11/8 0:04, Marc Zyngier wrote:
> In order to find out whether a vcpu is likely to be the target of
> VLPIs (and to further optimize the way we deal with those), let's
> track the number of VLPIs a vcpu can receive.
> 
> This gets implemented with an atomic variable that gets incremented
> or decremented on map, unmap and move of a VLPI.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>

