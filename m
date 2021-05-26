Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F46C391A0E
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 16:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234539AbhEZOYx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 10:24:53 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:6719 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbhEZOYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 May 2021 10:24:52 -0400
Received: from dggems702-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FqtPP1MTZzncdM;
        Wed, 26 May 2021 22:19:37 +0800 (CST)
Received: from dggema764-chm.china.huawei.com (10.1.198.206) by
 dggems702-chm.china.huawei.com (10.3.19.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Wed, 26 May 2021 22:23:14 +0800
Received: from [10.174.185.179] (10.174.185.179) by
 dggema764-chm.china.huawei.com (10.1.198.206) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 26 May 2021 22:23:13 +0800
Subject: Re: [kvm-unit-tests PATCH v2 2/4] scripts/arch-run: don't use
 deprecated server/nowait options
To:     =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
CC:     <kvm@vger.kernel.org>, <shashi.mallela@linaro.org>,
        <alexandru.elisei@arm.com>, <eric.auger@redhat.com>,
        <qemu-arm@nongnu.org>, <linux-arm-kernel@lists.infradead.org>,
        <kvmarm@lists.cs.columbia.edu>, <christoffer.dall@arm.com>,
        <maz@kernel.org>
References: <20210525172628.2088-1-alex.bennee@linaro.org>
 <20210525172628.2088-3-alex.bennee@linaro.org>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <d6c6defe-1ad6-6c23-05a4-ed5966f75f28@huawei.com>
Date:   Wed, 26 May 2021 22:23:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20210525172628.2088-3-alex.bennee@linaro.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.185.179]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggema764-chm.china.huawei.com (10.1.198.206)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/5/26 1:26, Alex Bennée wrote:
> The very fact that QEMU drops the deprecation warning while running is
> enough to confuse the its-migration test into failing. The boolean
> options server and wait have accepted the long form options for a long
> time.
> 
> Signed-off-by: Alex Bennée <alex.bennee@linaro.org>
> Cc: Shashi Mallela <shashi.mallela@linaro.org>

This works for me.

Tested-by: Zenghui Yu <yuzenghui@huawei.com>
