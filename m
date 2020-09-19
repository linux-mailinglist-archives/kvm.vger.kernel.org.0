Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 828872709CB
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 03:56:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726219AbgISB4z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 21:56:55 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:53600 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726112AbgISB4z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Sep 2020 21:56:55 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0AB9E612F0CFAB66B981;
        Sat, 19 Sep 2020 09:56:52 +0800 (CST)
Received: from [10.174.185.226] (10.174.185.226) by
 DGGEMS414-HUB.china.huawei.com (10.3.19.214) with Microsoft SMTP Server id
 14.3.487.0; Sat, 19 Sep 2020 09:56:43 +0800
Subject: Re: [PATCH 1/2] vfio/pci: Remove redundant declaration of
 vfio_pci_driver
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <cohuck@redhat.com>, <wanghaibin.wang@huawei.com>
References: <20200917033128.872-1-yuzenghui@huawei.com>
 <20200917162240.037a1913@x1.home>
From:   Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <ac4c01e5-df0e-1a18-6a1e-d50f37ddafb7@huawei.com>
Date:   Sat, 19 Sep 2020 09:56:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200917162240.037a1913@x1.home>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.185.226]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020/9/18 6:22, Alex Williamson wrote:
> On Thu, 17 Sep 2020 11:31:27 +0800
> Zenghui Yu <yuzenghui@huawei.com> wrote:
> 
>> It was added by commit 137e5531351d ("vfio/pci: Add sriov_configure
>> support") and actually unnecessary. Remove it.
> 
> Looks correct, but I might clarify as:
> 
> s/unnecessary/duplicates a forward declaration earlier in the file/
> 
> I can change on commit if you approve.  Thanks,

Indeed. Please help to change it.


Thanks,
Zenghui
