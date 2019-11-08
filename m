Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16ED1F41A4
	for <lists+kvm@lfdr.de>; Fri,  8 Nov 2019 09:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfKHILZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Nov 2019 03:11:25 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:5747 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726072AbfKHILZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Nov 2019 03:11:25 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 0B11D5CF9E69D6D25DA8;
        Fri,  8 Nov 2019 16:11:24 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 8 Nov 2019
 16:11:14 +0800
Subject: Re: [PATCH v21 3/6] ACPI: Add APEI GHES table generation support
To:     Xiang Zheng <zhengxiang9@huawei.com>, <pbonzini@redhat.com>,
        <mst@redhat.com>, <imammedo@redhat.com>,
        <shannon.zhaosl@gmail.com>, <peter.maydell@linaro.org>,
        <lersek@redhat.com>, <james.morse@arm.com>, <mtosatti@redhat.com>,
        <rth@twiddle.net>, <ehabkost@redhat.com>,
        <jonathan.cameron@huawei.com>, <xuwei5@huawei.com>,
        <kvm@vger.kernel.org>, <qemu-devel@nongnu.org>,
        <qemu-arm@nongnu.org>, <linuxarm@huawei.com>
CC:     <wanghaibin.wang@huawei.com>
References: <20191104121458.29208-1-zhengxiang9@huawei.com>
 <20191104121458.29208-4-zhengxiang9@huawei.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <3068b1f2-7175-485a-a9a1-dcba0bf82dea@huawei.com>
Date:   Fri, 8 Nov 2019 16:11:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20191104121458.29208-4-zhengxiang9@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2019/11/4 20:14, Xiang Zheng wrote:
> From: Dongjiu Geng <gengdongjiu@huawei.com>
> 
> This patch implements APEI GHES Table generation via fw_cfg blobs. Now
> it only supports ARMv8 SEA, a type of GHESv2 error source. Afterwards,
> we can extend the supported types if needed. For the CPER section,
> currently it is memory section because kernel mainly wants userspace to
> handle the memory errors.
> 
> This patch follows the spec ACPI 6.2 to build the Hardware Error Source
> table. For more detailed information, please refer to document:
> docs/specs/acpi_hest_ghes.rst
> 
> Suggested-by: Laszlo Ersek <lersek@redhat.com>
> Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>

Hi Xiang,
   please add "Reviewed-by: Michael S. Tsirkin <mst@redhat.com> " which from Michael, thanks.

