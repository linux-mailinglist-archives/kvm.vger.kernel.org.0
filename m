Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0891BB0C0
	for <lists+kvm@lfdr.de>; Mon, 27 Apr 2020 23:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgD0VtE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Apr 2020 17:49:04 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55364 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726182AbgD0VtE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 27 Apr 2020 17:49:04 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03RLVjbT140338;
        Mon, 27 Apr 2020 17:49:01 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30me4vybfc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 17:49:01 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03RLn1oj041440;
        Mon, 27 Apr 2020 17:49:01 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30me4vybf4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 17:49:01 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03RLmlpX005631;
        Mon, 27 Apr 2020 21:49:00 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 30mcu66h40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 Apr 2020 21:49:00 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03RLmxRE14942958
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Apr 2020 21:48:59 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1C549124054;
        Mon, 27 Apr 2020 21:48:59 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 95A15124052;
        Mon, 27 Apr 2020 21:48:58 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.200.21])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 27 Apr 2020 21:48:58 +0000 (GMT)
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
To:     Halil Pasic <pasic@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-2-akrowiak@linux.ibm.com>
 <20200424055732.7663896d.pasic@linux.ibm.com>
 <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
 <20200427171739.76291a74.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <6ea12752-d23f-abe4-8d5f-3e7738984576@linux.ibm.com>
Date:   Mon, 27 Apr 2020 17:48:58 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200427171739.76291a74.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-27_16:2020-04-27,2020-04-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 mlxlogscore=999
 suspectscore=3 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004270172
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/27/20 11:17 AM, Halil Pasic wrote:
> On Mon, 27 Apr 2020 15:05:23 +0200
> Harald Freudenberger <freude@linux.ibm.com> wrote:
>
>> On 24.04.20 05:57, Halil Pasic wrote:
>>> On Tue,  7 Apr 2020 15:20:01 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> Rather than looping over potentially 65535 objects, let's store the
>>>> structures for caching information about queue devices bound to the
>>>> vfio_ap device driver in a hash table keyed by APQN.
>>> @Harald:
>>> Would it make sense to make the efficient lookup of an apqueue base
>>> on its APQN core AP functionality instead of each driver figuring it out
>>> on it's own?
>>>
>>> If I'm not wrong the zcrypt device/driver(s) must the problem of
>>> looking up a queue based on its APQN as well.
>>>
>>> For instance struct ep11_cprb has a target_id filed
>>> (arch/s390/include/uapi/asm/zcrypt.h).
>>>
>>> Regards,
>>> Halil
>> Hi Halil
>>
>> no, the zcrypt drivers don't have this problem. They build up their own device object which
>> includes a pointer to the base ap device.
> I'm a bit confused. Doesn't your code loop first trough the ap_card
> objects to find the APID portion of the APQN, and then loop the queue
> list of the matching card to find the right ap_queue object? Or did I
> miss something? Isn't that what _zcrypt_send_ep11_cprb() does? Can you
> point me to the code that avoids the lookup (by apqn) for zcrypt?

The code you reference, _zcrypt_send_ep11_cprb(), does loop through
each queue associated with each card, but it doesn't appear to be 
looking for
a queue with a particular APQN. It appears to be looking for a queue
meeting a specific set of conditions. At least that's my take after 
taking a very
brief look at the code, so I'm not sure that applies here.

>
>
> If you look at the new function of vfio_ap_get_queue(unsigned long apqn)
> it basically about finding the queue based on the apqn, with the
> difference that it is vfio specific.
>
> Regards,
> Halil
>
>> However, this is not a big issue, as the ap_bus holds a list of ap_card objects and within each
>> ap_card object there exists a list of ap_queues.
>
>
>

