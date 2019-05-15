Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C777F1F583
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbfEONXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 09:23:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60012 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726407AbfEONXG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 09:23:06 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FDJ0ZQ133173
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:23:04 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sgj7mmy8w-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:22:57 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 14:22:24 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e12.ny.us.ibm.com (146.89.104.199) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 14:22:22 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FDL6dV28180632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 13:21:06 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CF64B206E;
        Wed, 15 May 2019 13:21:06 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 643B5B2065;
        Wed, 15 May 2019 13:21:06 +0000 (GMT)
Received: from [9.60.85.4] (unknown [9.60.85.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 13:21:06 +0000 (GMT)
Subject: Re: [PATCH v2 0/7] s390: vfio-ccw fixes
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190515144530.5603097b.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Wed, 15 May 2019 09:21:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515144530.5603097b.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051513-0060-0000-0000-000003409B26
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011102; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203678; UDB=6.00631831; IPR=6.00984604;
 MB=3.00026903; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-15 13:22:23
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051513-0061-0000-0000-0000495BAB89
Message-Id: <8a3e8e4d-2f47-2180-67ec-83934277f088@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150085
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/19 8:45 AM, Cornelia Huck wrote:
> On Wed, 15 May 2019 01:42:41 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> The attached are a few fixes to the vfio-ccw kernel code for potential
>> errors or architecture anomalies.  Under normal usage, and even most
>> abnormal usage, they don't expose any problems to a well-behaved guest
>> and its devices.  But, they are deficiencies just the same and could
>> cause some weird behavior if they ever popped up in real life.
>>
>> I have tried to arrange these patches in a "solves a noticeable problem
>> with existing workloads" to "solves a theoretical problem with
>> hypothetical workloads" order.  This way, the bigger ones at the end
>> can be discussed without impeding the smaller and more impactful ones
>> at the start.
>>
>> Per the conversations on patch 7, the last several patches remain
>> unchanged.  They continue to buid an IDAL for each CCW, and only pin
>> guest pages and assign the resulting addresses to IDAWs if they are
>> expected to cause a data transfer.  This will avoid sending an
>> unmodified guest address, which may be invalid but anyway is not mapped
>> to the same host address, in the IDAL sent to the channel subsystem and
>> any unexpected behavior that may result.
>>
>> They are based on 5.1.0, not Conny's vfio-ccw tree even though there are
>> some good fixes pending for 5.2 there.  I've run this series both with
>> and without that code, but couldn't decide which base would provide an
>> easier time applying patches.  "I think" they should apply fine to both,
>> but I apologize in advance if I guessed wrong!  :)
> 
> They also should apply on current master, no? My 5.2 branch should be
> all merged by now :)

Yeah, I just haven't updated my branches yet.  :)

> 
> Nothing really jumped out at me; I'm happy to queue the patches if I
> get some more feedback.
> 
>>
>>
>> Changelog:
>>   v1 -> v2:
>>    - Patch 1:
>>       - [Cornelia] Added a code comment about why we update the SCSW when
>>         we've gone past the end of the chain for normal, successful, I/O
>>    - Patch 2:
>>       - [Cornelia] Cleaned up the cc info in the commit message
>>       - [Pierre] Added r-b
>>    - Patch 3:
>>       - [Cornelia] Update the return code information in prologue of
>>         pfn_array_pin(), and then only call vfio_unpin_pages() if we
>>         pinned anything, rather than silently creating an error
>>         (this last bit was mentioned on patch 6, but applied here)
>>       - [Eric] Clean up the error exit in pfn_array_pin()
>>    - Patch 4-7 unchanged
>>
>> Eric Farman (7):
>>    s390/cio: Update SCSW if it points to the end of the chain
>>    s390/cio: Set vfio-ccw FSM state before ioeventfd
>>    s390/cio: Split pfn_array_alloc_pin into pieces
>>    s390/cio: Initialize the host addresses in pfn_array
>>    s390/cio: Allow zero-length CCWs in vfio-ccw
>>    s390/cio: Don't pin vfio pages for empty transfers
>>    s390/cio: Remove vfio-ccw checks of command codes
>>
>>   drivers/s390/cio/vfio_ccw_cp.c  | 159 +++++++++++++++++++++++---------
>>   drivers/s390/cio/vfio_ccw_drv.c |   6 +-
>>   2 files changed, 119 insertions(+), 46 deletions(-)
>>
> 

