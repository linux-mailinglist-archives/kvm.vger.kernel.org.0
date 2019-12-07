Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88E7B115C2A
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2019 13:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLGMKp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 7 Dec 2019 07:10:45 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44466 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726263AbfLGMKp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 7 Dec 2019 07:10:45 -0500
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id BC182A40469D3AC3E506;
        Sat,  7 Dec 2019 20:10:41 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS408-HUB.china.huawei.com
 (10.3.19.208) with Microsoft SMTP Server id 14.3.439.0; Sat, 7 Dec 2019
 20:10:31 +0800
Subject: Re: [RESEND PATCH v21 1/6] hw/arm/virt: Introduce a RAS machine
 option
To:     Peter Maydell <peter.maydell@linaro.org>,
        Xiang Zheng <zhengxiang9@huawei.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Igor Mammedov <imammedo@redhat.com>,
        Shannon Zhao <shannon.zhaosl@gmail.com>,
        Laszlo Ersek <lersek@redhat.com>,
        James Morse <james.morse@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        "Richard Henderson" <rth@twiddle.net>,
        Eduardo Habkost <ehabkost@redhat.com>,
        "Jonathan Cameron" <jonathan.cameron@huawei.com>,
        "xuwei (O)" <xuwei5@huawei.com>, kvm-devel <kvm@vger.kernel.org>,
        QEMU Developers <qemu-devel@nongnu.org>,
        qemu-arm <qemu-arm@nongnu.org>, Linuxarm <linuxarm@huawei.com>,
        <wanghaibin.wang@huawei.com>
References: <20191111014048.21296-1-zhengxiang9@huawei.com>
 <20191111014048.21296-2-zhengxiang9@huawei.com>
 <CAFEAcA8fkc+0RhOH7780sREPUOaCvE-rpUkwFN0-hwsVD7RiMg@mail.gmail.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <8219fac5-107c-32de-e9d2-2178bd8639a8@huawei.com>
Date:   Sat, 7 Dec 2019 20:10:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <CAFEAcA8fkc+0RhOH7780sREPUOaCvE-rpUkwFN0-hwsVD7RiMg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org


> 
> I think we could make the user-facing description of
> the option a little clearer: something like
> "Set on/off to enable/disable reporting host memory errors
> to a KVM guest using ACPI and guest external abort exceptions"
> 
> ?
Peter, sorry for the late response.
sure, we have already updated it, and will send PATCH V22.

> 
> Otherwise
> Reviewed-by: Peter Maydell <peter.maydell@linaro.org>
> 
> thanks
> -- PMM
> .
> 

