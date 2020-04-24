Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 958121B7C61
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 19:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728589AbgDXRHs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 13:07:48 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:14078 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726793AbgDXRHs (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Apr 2020 13:07:48 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03OH3ffZ063118;
        Fri, 24 Apr 2020 13:07:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jvfvtv25-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 13:07:45 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03OH3nDY063505;
        Fri, 24 Apr 2020 13:07:45 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30jvfvtv1v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 13:07:45 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03OH6Rw5008665;
        Fri, 24 Apr 2020 17:07:44 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma01wdc.us.ibm.com with ESMTP id 30fs66u2ad-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 24 Apr 2020 17:07:44 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03OH7e5a58982736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 24 Apr 2020 17:07:41 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 704AE136063;
        Fri, 24 Apr 2020 17:07:40 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 140F1136055;
        Fri, 24 Apr 2020 17:07:38 +0000 (GMT)
Received: from cpe-66-24-59-227.stny.res.rr.com (unknown [9.85.130.212])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 24 Apr 2020 17:07:38 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Halil Pasic <pasic@linux.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <20200414145851.562867ae.cohuck@redhat.com>
 <35d8c3cb-78bb-8f84-41d8-c6e59d201ba0@linux.ibm.com>
 <20200416113721.124f9843.cohuck@redhat.com>
 <20200424053338.658b2a05.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <195d237d-c668-48ca-1125-08eafc0011db@linux.ibm.com>
Date:   Fri, 24 Apr 2020 13:07:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200424053338.658b2a05.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-24_08:2020-04-24,2020-04-24 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 adultscore=0 impostorscore=0 mlxlogscore=999 spamscore=0 clxscore=1015
 phishscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004240133
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/23/20 11:33 PM, Halil Pasic wrote:
> On Thu, 16 Apr 2020 11:37:21 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
>
>> On Wed, 15 Apr 2020 13:10:10 -0400
>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>
>>> On 4/14/20 8:58 AM, Cornelia Huck wrote:
>>>> On Tue,  7 Apr 2020 15:20:03 -0400
>>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>>> +
>>>>> +	if (ap_drv->in_use)
>>>>> +		if (ap_drv->in_use(newapm, ap_perms.aqm))
>>>> Can we log the offending apm somewhere, preferably with additional info
>>>> that allows the admin to figure out why an error was returned?
>>> One of the things on my TODO list is to add logging to the vfio_ap
>>> module which will track all significant activity within the device
>>> driver. I plan to do that with a patch or set of patches specifically
>>> put together for that purpose. Having said that, the best place to
>>> log this would be in the in_use callback in the vfio_ap device driver
>>> (see next patch) where the APQNs that are in use can be identified.
>>> For now, I will log a message to the dmesg log indicating which
>>> APQNs are in use by the matrix mdev.
>> Sounds reasonable. My main issue was what an admin was supposed to do
>> until logging was in place :)
> Logging may not be the right answer here. Imagine somebody wants to build
> a nice web-tool for managing this stuff at scale -- e.g. something HMC. I
> don't think the solution is to let this tool parse the kernel messages
> and try to relate that to its own transactions.

I don't believe there is no right or wrong answer here; I simply don't
see the relevance of discussing a tool in this context. We are talking
about a sysfs attribute interface here, so - correct me if I'm
mistaken - our options for notifying the user that a queue is in use are
limited to the return code from the sysfs interface and logging. I would
expect that a tool would have to do something similar to the callback
implemented in the vfio_ap device driver and check the APQNs
removed against the APQNs assigned to the mdevs to determine which
is in use.

>
> But I do agree, having a way to report why "won't do" to the end user is
> important for usability.
>
> Regards,
> Halil
>
>>>>   
>>>>> +			rc = -EADDRINUSE;
>>>>> +
>>>>> +	module_put(drv->owner);
>>>>> +
>>>>> +	return rc;
>>>>> +}

