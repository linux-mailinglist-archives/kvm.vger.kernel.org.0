Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAA5410E7DA
	for <lists+kvm@lfdr.de>; Mon,  2 Dec 2019 10:42:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727378AbfLBJmZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Dec 2019 04:42:25 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:33080 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726534AbfLBJmZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Dec 2019 04:42:25 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C0DFB2BF3217283C8798;
        Mon,  2 Dec 2019 17:42:22 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Mon, 2 Dec 2019
 17:42:15 +0800
Subject: Re: vfio_pin_map_dma cause synchronize_sched wait too long
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     <qemu-devel@nongnu.org>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        "Longpeng(Mike)" <longpeng.mike@gmail.com>,
        Gonglei <arei.gonglei@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>
References: <2e53a9f0-3225-d416-98ff-55bd337330bc@huawei.com>
 <34c53520-4144-fe71-528a-8df53e7f4dd1@redhat.com>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <561fb205-16be-ae87-9cfe-61e6a3b04dc5@huawei.com>
Date:   Mon, 2 Dec 2019 17:42:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <34c53520-4144-fe71-528a-8df53e7f4dd1@redhat.com>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ÔÚ 2019/12/2 17:31, Paolo Bonzini Ð´µÀ:
> On 02/12/19 10:10, Longpeng (Mike) wrote:
>>
>> Suppose there're two VMs: VM1 is bind to node-0 and calling vfio_pin_map_dma(),
>> VM2 is a migrate incoming VM which bind to node-1. We found the vm_start( QEMU
>> function) of VM2 will take too long occasionally, the reason is as follow.
> 
> Which part of vfio_pin_map_dma is running?  There is already a

I need more analysis to find which part.

> cond_resched in vfio_iommu_map.  Perhaps you could add one to
> vfio_pin_pages_remote and/or use vfio_pgsize_bitmap to cap the number of
> pages that it returns.

Um ... There's only one running task (qemu-kvm of the VM1) on that CPU, so maybe
the cond_resched() is ineffective ?

> > Paolo
> 
> 
> 


-- 
Regards,
Longpeng(Mike)

