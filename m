Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DECFB1F5B9
	for <lists+kvm@lfdr.de>; Wed, 15 May 2019 15:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbfEONkg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 May 2019 09:40:36 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37224 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726635AbfEONkg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 15 May 2019 09:40:36 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4FDeW8W071778
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:40:35 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sghqjybpb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 15 May 2019 09:40:34 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Wed, 15 May 2019 14:36:05 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 15 May 2019 14:36:03 +0100
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4FDa23636044802
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 May 2019 13:36:02 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 29B1AB2066;
        Wed, 15 May 2019 13:36:02 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F3BB1B2065;
        Wed, 15 May 2019 13:36:01 +0000 (GMT)
Received: from [9.60.85.4] (unknown [9.60.85.4])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed, 15 May 2019 13:36:01 +0000 (GMT)
Subject: Re: [PATCH v2 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>,
        Pierre Morel <pmorel@linux.ibm.com>,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org
References: <20190514234248.36203-1-farman@linux.ibm.com>
 <20190514234248.36203-8-farman@linux.ibm.com>
 <20190515144305.46a2ecb1.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Wed, 15 May 2019 09:36:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190515144305.46a2ecb1.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051513-0064-0000-0000-000003DEC55A
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011102; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203682; UDB=6.00631834; IPR=6.00984608;
 MB=3.00026903; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-15 13:36:04
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051513-0065-0000-0000-00003D7AA9C6
Message-Id: <1f0e2084-2e3d-bc97-f8cf-a40f194d7288@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-15_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905150086
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/15/19 8:43 AM, Cornelia Huck wrote:
> On Wed, 15 May 2019 01:42:48 +0200
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> If the CCW being processed is a No-Operation, then by definition no
>> data is being transferred.  Let's fold those checks into the normal
>> CCW processors, rather than skipping out early.
>>
>> Likewise, if the CCW being processed is a "test" (an invented
>> definition to simply mean it ends in a zero), let's permit that to go
>> through to the hardware.  There's nothing inherently unique about
>> those command codes versus one that ends in an eight [1], or any other
>> otherwise valid command codes that are undefined for the device type
>> in question.
> 
> Hm... let's tweak that a bit? It's not that "test" is an invented
> category; it's just that this has not been a valid command for
> post-s/370 and therefore should not get any special treatment and just
> be sent to the hardware?

Agreed, I should've re-read that one before I sent it...  How about:

Likewise, if the CCW being processed is a "test" (a category defined
here as an opcode that contains zero in the lowest four bits) then no
special processing is necessary as far as vfio-ccw is concerned.
These command codes have not been valid since the S/370 days, meaning
they are invalid in the same way as one that ends in an eight [1] or
an otherwise valid command code that is undefined for the device type
in question.  Considering that, let's just process "test" CCWs like
any other CCW, and send everything to the hardware.

> 
>>
>> [1] POPS states that a x08 is a TIC CCW, and that having any high-order
>> bits enabled is invalid for format-1 CCWs.  For format-0 CCWs, the
>> high-order bits are ignored.
>>
>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>> ---
>>   drivers/s390/cio/vfio_ccw_cp.c | 11 +++++------
>>   1 file changed, 5 insertions(+), 6 deletions(-)
> 

