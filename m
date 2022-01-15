Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60BA148F383
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 01:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiAOAbc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 19:31:32 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26862 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230473AbiAOAbb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jan 2022 19:31:31 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20F0RKQ4027399;
        Sat, 15 Jan 2022 00:31:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=V7n77PggV3wohoM0Q9M5PGVIEWZcBEpdK6OGfj0DKPE=;
 b=n4NRilMSntpLm6+ED3wHZJX7n1PdPA9UvdnX85+vMTFFKZJ99AQArRf0ODONfyf++cM0
 iOz4rN+Jwyk2RiBtOlOe1BVGlGqDLmmPu8KfYmteJcvEvUdIWYvs3OF7ii5YDCugZps0
 W3y2403ZHL+Tb6zHVAlZ8z4cURaN/R7ya7tgOEWegqOzTZx6oQJp+A2FyCe5q9XfsXLc
 FkowkeBOXFZndqyGDImVoE0N42fA12Ckie+HSt722MB82qvfke201qUVGj6zE1vTY+/Q
 SwNNMw4TRwgDaOuUGnx7HoO2+Go8x2BddswPVMXuLO6xBfiOuVJQYLgf8dN8i6y3lB8K tw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkkr9g1fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jan 2022 00:31:28 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20F0UFhr004054;
        Sat, 15 Jan 2022 00:31:27 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dkkr9g1f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jan 2022 00:31:27 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20F0CKeP019623;
        Sat, 15 Jan 2022 00:31:26 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04dal.us.ibm.com with ESMTP id 3df28da0nv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 15 Jan 2022 00:31:26 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20F0VP9B31523266
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 Jan 2022 00:31:25 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E7EB8B206B;
        Sat, 15 Jan 2022 00:31:24 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 56362B206A;
        Sat, 15 Jan 2022 00:31:23 +0000 (GMT)
Received: from [9.160.163.221] (unknown [9.160.163.221])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 15 Jan 2022 00:31:23 +0000 (GMT)
Message-ID: <1cbbe637-b04b-dcea-8773-39c56cf0664d@linux.ibm.com>
Date:   Fri, 14 Jan 2022 19:31:22 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 06/15] s390/vfio-ap: refresh guest's APCB by filtering
 APQNs assigned to mdev
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-7-akrowiak@linux.ibm.com>
 <20211227095301.34a91ca4.pasic@linux.ibm.com>
 <831f8897-b7cd-8240-c607-be3a106bad5c@linux.ibm.com>
 <20220112125217.108e0fba.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20220112125217.108e0fba.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 88fXMtEUQe22qiLnx7pYhqwmuCbWelLD
X-Proofpoint-GUID: f15oPun15kPacUHO2ueiQKDDJMkcfUBj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-14_07,2022-01-14_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 lowpriorityscore=0 clxscore=1015 phishscore=0 mlxscore=0 adultscore=0
 malwarescore=0 spamscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2201150001
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/12/22 06:52, Halil Pasic wrote:
> On Tue, 11 Jan 2022 16:19:06 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>> Also we could probably do the filtering incrementally. In a sense that
>>> at a time only so much changes, and we know that the invariant was
>>> preserved without that change. But that would probably end up trading
>>> complexity for cycles. I will trust your judgment and your tests on this
>>> matter.
>> I am not entirely clear on what you are suggesting. I think you are
>> suggesting that there may not be a need to look at every APQN
>> assigned to the mdev when an adapter or domain is assigned or
>> unassigned or a queue is probed or removed. Maybe you can clarify
>> what you are suggesting here.
> Exactly. For example if we have the following assigned
> adapters:
> 1, 2, 3
> domains:
> 1, 2, 3
> and the operation we are trying to perform is assign domain 4, then it
> is sufficient to have a look at the queues with the APQNs (1,4), (2,4)
> and (3, 4). We don't have to examine all the 14 queues.
>
> When an unassign dapter is performed, there is no need to do the
> re-filtering, because there is nothing that can pop-back or go away. And
> on unassign domain is performed, then all we care about are the queues
> of that domain on the filtered adapters.
>
> Similarly if after that successful assign the queue (3,4) gets removed
> (from vfio_ap) and then added back again and probed, we only have to
> look at the queues (3, 1), (3, 2), (3, 3).
>
> But I'm OK with the current design of this. It is certainly conceptually
> simpler to say we have a master-copy and we filter that master-copy based
> on the very same rules every time something changes. I'm really fine
> either way as log as it works well. :D
>
> Regards,
> Halil

I spent a day messing with this and was able to make it work, so
the next implementation will incorporate your idea here.


