Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5816A1639DA
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 03:10:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbgBSCKA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Feb 2020 21:10:00 -0500
Received: from szxga07-in.huawei.com ([45.249.212.35]:44634 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726698AbgBSCKA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Feb 2020 21:10:00 -0500
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 2128C5D71AAFCBFCA923;
        Wed, 19 Feb 2020 10:09:57 +0800 (CST)
Received: from [127.0.0.1] (10.177.246.209) by DGGEMS404-HUB.china.huawei.com
 (10.3.19.204) with Microsoft SMTP Server id 14.3.439.0; Wed, 19 Feb 2020
 10:09:47 +0800
Subject: Re: [PATCH] mm/hugetlb: avoid get wrong ptep caused by race
To:     Matthew Wilcox <willy@infradead.org>
CC:     <mike.kravetz@oracle.com>, <akpm@linux-foundation.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <arei.gonglei@huawei.com>, <weidong.huang@huawei.com>,
        <weifuqiang@huawei.com>, <kvm@vger.kernel.org>
References: <1582027825-112728-1-git-send-email-longpeng2@huawei.com>
 <20200218205239.GE24185@bombadil.infradead.org>
From:   "Longpeng (Mike)" <longpeng2@huawei.com>
Message-ID: <593d82a3-1d1e-d8f2-6b90-137f10441522@huawei.com>
Date:   Wed, 19 Feb 2020 10:09:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20200218205239.GE24185@bombadil.infradead.org>
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.246.209]
X-CFilter-Loop: Reflected
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ÔÚ 2020/2/19 4:52, Matthew Wilcox Ð´µÀ:
> On Tue, Feb 18, 2020 at 08:10:25PM +0800, Longpeng(Mike) wrote:
>>  {
>> -	pgd_t *pgd;
>> -	p4d_t *p4d;
>> -	pud_t *pud;
>> -	pmd_t *pmd;
>> +	pgd_t *pgdp;
>> +	p4d_t *p4dp;
>> +	pud_t *pudp, pud;
>> +	pmd_t *pmdp, pmd;
> 
> Renaming the variables as part of a fix is a really bad idea.  It obscures
> the actual fix and makes everybody's life harder.  Plus, it's not even
> renaming to follow the normal convention -- there are only two places
> (migrate.c and gup.c) which follow this pattern in mm/ while there are
> 33 that do not.
> 
Good suggestion, I've never noticed this, thanks.
By the way, could you give an example if we use this way to fix the bug?

> 
> .
> 


-- 
Regards,
Longpeng(Mike)

