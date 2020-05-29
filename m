Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 452EF1E85F0
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 19:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgE2Rzk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 13:55:40 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5170 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgE2Rzh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 29 May 2020 13:55:37 -0400
Received: from hqpgpgate102.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5ed14c8d0001>; Fri, 29 May 2020 10:55:25 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate102.nvidia.com (PGP Universal service);
  Fri, 29 May 2020 10:55:37 -0700
X-PGP-Universal: processed;
        by hqpgpgate102.nvidia.com on Fri, 29 May 2020 10:55:37 -0700
Received: from [10.40.100.117] (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 29 May
 2020 17:55:33 +0000
Subject: Re: [PATCH] vfio/mdev: Fix reference count leak in
 add_mdev_supported_type.
To:     Cornelia Huck <cohuck@redhat.com>, <wu000273@umn.edu>
CC:     <kjlu@umn.edu>, Alex Williamson <alex.williamson@redhat.com>,
        Neo Jia <cjia@nvidia.com>,
        Dong Jia Shi <bjsdjshi@linux.vnet.ibm.com>,
        Jike Song <jike.song@intel.com>, <kvm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20200528020109.31664-1-wu000273@umn.edu>
 <20200528090220.6dc94bd7.cohuck@redhat.com>
X-Nvconfidentiality: public
From:   Kirti Wankhede <kwankhede@nvidia.com>
Message-ID: <526ecc5d-a94a-e684-84a3-67eec43a370a@nvidia.com>
Date:   Fri, 29 May 2020 23:25:29 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200528090220.6dc94bd7.cohuck@redhat.com>
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1590774925; bh=RTZtHjkM06WGBBJ+JbuIE8VUHTj8mmRxaF6r7TBEWMY=;
        h=X-PGP-Universal:Subject:To:CC:References:X-Nvconfidentiality:From:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=UzLoiBvdVAwmUXUZ7nUVmXcHU0jdqbW03/n5sM8zabEXEs6afuYsXIdcnD6ezYfo4
         jvBtx2QI1UZV6ftMTYyoNvXVU5bcABeN5ARsj0qbdWFYBA75baQS20Ve/vbGTAWJbc
         HB24Y06k5Eu3JRP8jhdyYZuox1u1wilQIDoK4weHRW7YSQs2gVOyO15/9ndfiFvKJE
         dJkMMmgBY6SS9+SoDijf/YHoa/q3jtCJ0hWTNqQWxRLaIOiVDXF7xwKaIEnciopv3m
         KjyOXhvVt6Bw/PeZr+wu/4EBE/UkmH0Dez23jIvaP+a38smPFxpE9cJ14UaV6TQqwb
         aP4YqPSSg5CHw==
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/28/2020 12:32 PM, Cornelia Huck wrote:
> On Wed, 27 May 2020 21:01:09 -0500
> wu000273@umn.edu wrote:
> 
>> From: Qiushi Wu <wu000273@umn.edu>
>>
>> kobject_init_and_add() takes reference even when it fails.
>> If this function returns an error, kobject_put() must be called to
>> properly clean up the memory associated with the object. Thus,
>> replace kfree() by kobject_put() to fix this issue. Previous
>> commit "b8eb718348b8" fixed a similar problem.
>>
>> Fixes: 7b96953bc640 ("vfio: Mediated device Core driver")
>> Signed-off-by: Qiushi Wu <wu000273@umn.edu>
>> ---
>>   drivers/vfio/mdev/mdev_sysfs.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Reviewed-by: Cornelia Huck <cohuck@redhat.com>
> 

Thanks for fixing.

Reviewed-by: Kirti Wankhede <kwankhede@nvidia.com>
