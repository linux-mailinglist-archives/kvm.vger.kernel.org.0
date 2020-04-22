Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E8D1B3B02
	for <lists+kvm@lfdr.de>; Wed, 22 Apr 2020 11:17:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgDVJRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Apr 2020 05:17:45 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:32908 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726124AbgDVJRo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Apr 2020 05:17:44 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03M92eJi022139
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:17:44 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30gcbgdx6f-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 22 Apr 2020 05:17:44 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pmorel@linux.ibm.com>;
        Wed, 22 Apr 2020 10:17:36 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 22 Apr 2020 10:17:31 +0100
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03M9Haa747382684
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 09:17:36 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D1820A404D;
        Wed, 22 Apr 2020 09:17:36 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7C8E9A4040;
        Wed, 22 Apr 2020 09:17:36 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.55.142])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Apr 2020 09:17:36 +0000 (GMT)
Subject: Re: [kvm-unit-tests PATCH v5 00/10] s390x: Testing the Channel
 Subsystem I/O
To:     Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, thuth@redhat.com, cohuck@redhat.com
References: <1582200043-21760-1-git-send-email-pmorel@linux.ibm.com>
 <028ece05-1429-7761-cf4e-6fabc34e6aa0@linux.ibm.com>
 <4a5f0636-cd73-164a-8c7a-ca5679f01e56@redhat.com>
 <2c30fd52-876d-91b0-9a69-363efabdb86e@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Date:   Wed, 22 Apr 2020 11:17:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2c30fd52-876d-91b0-9a69-363efabdb86e@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20042209-0028-0000-0000-000003FCD6BC
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20042209-0029-0000-0000-000024C29D23
Message-Id: <57fae80f-e298-6763-9f1d-b6f7f92681ed@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-22_03:2020-04-21,2020-04-22 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 mlxlogscore=999
 clxscore=1015 suspectscore=0 malwarescore=0 spamscore=0 impostorscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004220073
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2020-04-22 09:43, Janosch Frank wrote:
> On 4/21/20 6:18 PM, David Hildenbrand wrote:
>> On 21.04.20 18:13, Pierre Morel wrote:
>>>
>>>
>>> On 2020-02-20 13:00, Pierre Morel wrote:
>>>
>>> ...snip...
>>>
>>>>
>>>>
>>>> Pierre Morel (10):
>>>>     s390x: saving regs for interrupts
>>>>     s390x: Use PSW bits definitions in cstart
>>>>     s390x: cr0: adding AFP-register control bit
>>>>     s390x: export the clock get_clock_ms() utility
>>>
>>> Please can you consider applying these 4 patches only.
>>> I will send some changes I made for the patches on css tests.
>>>
>>
>> The first one requires a little more brain power - can anybody at IBM
>> help reviewing that?
>>
> 
> I'll try to understand it :)
> 
> But I think we need a new series anyway.
> @Pierre: You told me, that you removed delay() and this series still has
> it. With the changes needed to the second patch and the delay change we
> need all information to make decisions, so a new version of the series
> would make sense.
> 
> 

Yes, this is clear, the next series will have some modifications for the 
css part.
Also I will send two series, first the general patches with bug fixes 
and comments and in a separate series the css specific patches.

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen

