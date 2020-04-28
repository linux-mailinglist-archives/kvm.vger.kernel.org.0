Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC41E1BBB90
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 12:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726519AbgD1Kq5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 06:46:57 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61940 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726360AbgD1Kq5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Apr 2020 06:46:57 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03SAWfWP030704;
        Tue, 28 Apr 2020 06:46:54 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9nf7nr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 06:46:54 -0400
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03SAeVhT069021;
        Tue, 28 Apr 2020 06:46:53 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30mh9nf7m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 06:46:53 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 03SAkVhX002074;
        Tue, 28 Apr 2020 10:46:51 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 30mcu6wy2r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Apr 2020 10:46:51 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03SAkmHn17105076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Apr 2020 10:46:48 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 409A342042;
        Tue, 28 Apr 2020 10:46:48 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 861924203F;
        Tue, 28 Apr 2020 10:46:47 +0000 (GMT)
Received: from funtu.home (unknown [9.171.3.163])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 28 Apr 2020 10:46:47 +0000 (GMT)
Subject: Re: [PATCH v7 01/15] s390/vfio-ap: store queue struct in hash table
 for quick access
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        pmorel@linux.ibm.com, alex.williamson@redhat.com,
        kwankhede@nvidia.com, jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-2-akrowiak@linux.ibm.com>
 <20200424055732.7663896d.pasic@linux.ibm.com>
 <d15b4a8e-66eb-e4ce-c8ac-6885519940aa@linux.ibm.com>
 <20200427171739.76291a74.pasic@linux.ibm.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Message-ID: <30c824a4-2b3c-984d-406e-1791f7725914@linux.ibm.com>
Date:   Tue, 28 Apr 2020 12:46:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200427171739.76291a74.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-28_06:2020-04-27,2020-04-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 bulkscore=0
 spamscore=0 malwarescore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004280085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27.04.20 17:17, Halil Pasic wrote:
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
No. The code is looping through zcrypt_card and zcrypt_queue objects which
are build up and held by the zcrypt api and the zcrypt driver(s).
It does not deal with ap_card and ap_queue devices.

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
