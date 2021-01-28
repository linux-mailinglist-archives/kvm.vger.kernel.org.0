Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 705D4306D77
	for <lists+kvm@lfdr.de>; Thu, 28 Jan 2021 07:13:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbhA1GLW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 28 Jan 2021 01:11:22 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:11454 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbhA1GLV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 28 Jan 2021 01:11:21 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4DR96V4H7vzjDNG;
        Thu, 28 Jan 2021 14:09:38 +0800 (CST)
Received: from [10.174.184.214] (10.174.184.214) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Thu, 28 Jan 2021 14:10:28 +0800
Subject: Re: [RFC PATCH v1 2/4] vfio: Add a page fault handler
To:     Christoph Hellwig <hch@infradead.org>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        Eric Auger <eric.auger@redhat.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Kevin Tian <kevin.tian@intel.com>,
        <wanghaibin.wang@huawei.com>, <yuzenghui@huawei.com>
References: <20210125090402.1429-1-lushenming@huawei.com>
 <20210125090402.1429-3-lushenming@huawei.com>
 <20210127174223.GB1738577@infradead.org>
From:   Shenming Lu <lushenming@huawei.com>
Message-ID: <d4c51504-24ed-2592-37b4-f390b97fdd00@huawei.com>
Date:   Thu, 28 Jan 2021 14:10:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20210127174223.GB1738577@infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.184.214]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2021/1/28 1:42, Christoph Hellwig wrote:
> On Mon, Jan 25, 2021 at 05:04:00PM +0800, Shenming Lu wrote:
>> +EXPORT_SYMBOL_GPL(vfio_iommu_dev_fault_handler);
> 
> This function is only used in vfio.c itself, so it should not be
> exported, but rather marked static.
> .
> 

Yeah, it makes sense. Thanks,

Shenming
