Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4BF1CEB1C
	for <lists+kvm@lfdr.de>; Tue, 12 May 2020 05:06:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728559AbgELDGR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 May 2020 23:06:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:4395 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728348AbgELDGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 May 2020 23:06:16 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 188011085950D5E99F69;
        Tue, 12 May 2020 11:06:14 +0800 (CST)
Received: from [127.0.0.1] (10.142.68.147) by DGGEMS406-HUB.china.huawei.com
 (10.3.19.206) with Microsoft SMTP Server id 14.3.487.0; Tue, 12 May 2020
 11:06:05 +0800
Subject: Re: [PATCH v26 01/10] acpi: nvdimm: change NVDIMM_UUID_LE to a common
 macro
To:     Igor Mammedov <imammedo@redhat.com>
CC:     =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <philmd@redhat.com>,
        <mst@redhat.com>, <xiaoguangrong.eric@gmail.com>,
        <peter.maydell@linaro.org>, <shannon.zhaosl@gmail.com>,
        <pbonzini@redhat.com>, <fam@euphon.net>, <rth@twiddle.net>,
        <ehabkost@redhat.com>, <mtosatti@redhat.com>,
        <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <qemu-arm@nongnu.org>, <zhengxiang9@huawei.com>,
        <linuxarm@huawei.com>, <Jonathan.Cameron@huawei.com>
References: <20200507134205.7559-1-gengdongjiu@huawei.com>
 <20200507134205.7559-2-gengdongjiu@huawei.com>
 <4f29e19c-cb37-05e6-0ae3-c019370e090b@redhat.com>
 <777c44a0-b977-a8fe-a3c6-5b217e9093af@huawei.com>
 <20200511214157.6a64526a@redhat.com>
From:   gengdongjiu <gengdongjiu@huawei.com>
Message-ID: <58878e68-22a3-376b-0ad3-1945c5c76758@huawei.com>
Date:   Tue, 12 May 2020 11:06:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <20200511214157.6a64526a@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.142.68.147]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/5/12 3:41, Igor Mammedov wrote:
> for future, adding RESEND doesn't make sence here. If you change patches then just bump version.

Igor,
    Thanks for the reminder, Just now I submitted a new patchset version to avoid this confusion.

