Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3104518139F
	for <lists+kvm@lfdr.de>; Wed, 11 Mar 2020 09:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgCKIqn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Mar 2020 04:46:43 -0400
Received: from szxga05-in.huawei.com ([45.249.212.191]:11659 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728122AbgCKIqn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Mar 2020 04:46:43 -0400
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id BA91D104182C4D7121A1;
        Wed, 11 Mar 2020 16:46:34 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.487.0; Wed, 11 Mar 2020
 16:46:25 +0800
Subject: Re: [kvm-unit-tests PATCH v5 07/13] arm/arm64: ITS:
 its_enable_defaults
To:     Eric Auger <eric.auger@redhat.com>, <eric.auger.pro@gmail.com>,
        <maz@kernel.org>, <kvmarm@lists.cs.columbia.edu>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>
CC:     <drjones@redhat.com>, <andre.przywara@arm.com>,
        <peter.maydell@linaro.org>, <alexandru.elisei@arm.com>,
        <thuth@redhat.com>
References: <20200310145410.26308-1-eric.auger@redhat.com>
 <20200310145410.26308-8-eric.auger@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <59c072ae-c779-8e6e-7c22-427e087b4b64@huawei.com>
Date:   Wed, 11 Mar 2020 16:46:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200310145410.26308-8-eric.auger@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/3/10 22:54, Eric Auger wrote:
> its_enable_defaults() enable LPIs at distributor level

redistributor level

> and ITS level.
> 
> gicv3_enable_defaults must be called before.
> 
> Signed-off-by: Eric Auger<eric.auger@redhat.com>

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>


Thanks

