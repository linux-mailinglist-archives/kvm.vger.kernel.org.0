Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F2D3F4E51
	for <lists+kvm@lfdr.de>; Mon, 23 Aug 2021 18:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhHWQ12 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Aug 2021 12:27:28 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhHWQ11 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 23 Aug 2021 12:27:27 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17NG3jFR039121;
        Mon, 23 Aug 2021 12:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O5MP+UlX1unDqxtlVtYwAxDZSREseyiGudmW49oQKKc=;
 b=Mwbw1qvnsKZrOuVFQO5QLK2/XgF+IlmV53yj+khmKukWSybmhTE4sQR7O5lBYIk6tZE+
 FF6NJxivIYhiO7EV+li204/9V+BmDgsSoO+rO4bT+6j2Rl6otH8svmGQ7x+PTE3/Rr9e
 Z4UT3rKC/PWZFaF4hKDVAE3gA/48vijXt2Zxc1w+2T6v3iMrVCsAJ2ti6CZrpaB1iY5z
 PYr17hN0iqYD5SNwr7sjeM6mDTw/y8w0qKhk3iS3BnSzBaFTarPLRbU6JxqmA3PrgEog
 +4bolVMOE/MXYofFGRsLqncZIaQSIspMwlTxk1P+tXiGIUo5wBL5mRsrT0xDP13f7in5 aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3akeg06mrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 12:26:43 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17NG46b5041580;
        Mon, 23 Aug 2021 12:26:42 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3akeg06mqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 12:26:42 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17NGMbxZ007341;
        Mon, 23 Aug 2021 16:26:41 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma02dal.us.ibm.com with ESMTP id 3ajs4btb35-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 23 Aug 2021 16:26:41 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17NGQdAl50987276
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Aug 2021 16:26:39 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9BA16C6066;
        Mon, 23 Aug 2021 16:26:39 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC927C606C;
        Mon, 23 Aug 2021 16:26:38 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.11.57])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 23 Aug 2021 16:26:38 +0000 (GMT)
Subject: Re: [PATCH] vfio-pci/zdev: Remove repeated verbose license text
To:     Alex Williamson <alex.williamson@redhat.com>,
        Cai Huoqing <caihuoqing@baidu.com>
Cc:     farman@linux.ibm.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20210822043500.561-1-caihuoqing@baidu.com>
 <20210823102056.49daf260.alex.williamson@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <376bdae4-b60b-25ad-86ba-d5ee918c2ef8@linux.ibm.com>
Date:   Mon, 23 Aug 2021 12:26:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210823102056.49daf260.alex.williamson@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: mYOTunyo1fcYbhH8OanYdYkJMpx0PB7w
X-Proofpoint-GUID: 4HdrwisnJS2yxUneimdp1Z53n5o2ceQR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-23_03:2021-08-23,2021-08-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 spamscore=0 impostorscore=0 mlxlogscore=999 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108230110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/23/21 12:20 PM, Alex Williamson wrote:
> On Sun, 22 Aug 2021 12:35:00 +0800
> Cai Huoqing <caihuoqing@baidu.com> wrote:
> 
>> remove it because SPDX-License-Identifier is already used
>>
>> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
>> ---
>>   drivers/vfio/pci/vfio_pci_zdev.c | 5 -----
>>   1 file changed, 5 deletions(-)
>>
>> diff --git a/drivers/vfio/pci/vfio_pci_zdev.c b/drivers/vfio/pci/vfio_pci_zdev.c
>> index 7b011b62c766..dfd8d826223d 100644
>> --- a/drivers/vfio/pci/vfio_pci_zdev.c
>> +++ b/drivers/vfio/pci/vfio_pci_zdev.c
>> @@ -5,11 +5,6 @@
>>    * Copyright (C) IBM Corp. 2020.  All rights reserved.
>>    *	Author(s): Pierre Morel <pmorel@linux.ibm.com>
>>    *                 Matthew Rosato <mjrosato@linux.ibm.com>
>> - *
>> - * This program is free software; you can redistribute it and/or modify
>> - * it under the terms of the GNU General Public License version 2 as
>> - * published by the Free Software Foundation.
>> - *
>>    */
>>   #include <linux/io.h>
>>   #include <linux/pci.h>
> 
> The SPDX license for this file is actually GPL-2.0+ but the text here
> matches the more restrictive GPL-2.0.  I'm not a lawyer, but I'd expect
> the more restrictive license holds, so removing this text might
> actually change the license.  Should this also correct the SPDX
> license?  Perhaps we need clarification from the authors.  Thanks,
> 
> Alex
> 

Oh, good catch.  Yeah, I think if you're going to remove the verbose 
text, then the identifier should be 'SPDX-License-Identifier: 
GPL-2.0-only' to match the verbose text you're removing.
