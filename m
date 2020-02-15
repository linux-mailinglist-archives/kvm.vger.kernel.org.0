Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BAD9215FC7B
	for <lists+kvm@lfdr.de>; Sat, 15 Feb 2020 04:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbgBODl7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Feb 2020 22:41:59 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:10180 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727641AbgBODl7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Feb 2020 22:41:59 -0500
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 7B2EBC6613FE84DAD0A9;
        Sat, 15 Feb 2020 11:41:55 +0800 (CST)
Received: from [127.0.0.1] (10.173.222.27) by DGGEMS401-HUB.china.huawei.com
 (10.3.19.201) with Microsoft SMTP Server id 14.3.439.0; Sat, 15 Feb 2020
 11:41:47 +0800
Subject: Re: [PATCH kvm-unit-tests v3] arm64: timer: Speed up gic-timer-state
 check
To:     Andrew Jones <drjones@redhat.com>, <kvm@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
CC:     <alexandru.elisei@arm.com>, <andre.przywara@arm.com>,
        <eric.auger@redhat.com>
References: <20200213093257.23367-1-drjones@redhat.com>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <cb4b85c1-7b25-f930-f09d-3ef86bc33930@huawei.com>
Date:   Sat, 15 Feb 2020 11:41:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200213093257.23367-1-drjones@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.222.27]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Drew,

On 2020/2/13 17:32, Andrew Jones wrote:
> Let's bail out of the wait loop if we see the expected state
> to save over six seconds of run time. Make sure we wait a bit
> before reading the registers and double check again after,
> though, to somewhat mitigate the chance of seeing the expected
> state by accident.
> 
> We also take this opportunity to push more IRQ state code to
> the library.
> 
> Cc: Zenghui Yu <yuzenghui@huawei.com>

Please feel free to replace this with:

Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Tested-by: Zenghui Yu <yuzenghui@huawei.com>

> Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Andrew Jones <drjones@redhat.com>


Thanks

