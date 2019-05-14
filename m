Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6683C1CF13
	for <lists+kvm@lfdr.de>; Tue, 14 May 2019 20:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727580AbfENS3j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 May 2019 14:29:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50956 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727550AbfENS3i (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 14 May 2019 14:29:38 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4EIRjEr037821
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 14:29:37 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2sg099795h-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 14 May 2019 14:29:37 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <farman@linux.ibm.com>;
        Tue, 14 May 2019 19:29:36 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 14 May 2019 19:29:34 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x4EITXpg36503978
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 May 2019 18:29:33 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 51B4F112061;
        Tue, 14 May 2019 18:29:33 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 03CA9112062;
        Tue, 14 May 2019 18:29:32 +0000 (GMT)
Received: from [9.85.182.11] (unknown [9.85.182.11])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 14 May 2019 18:29:32 +0000 (GMT)
Subject: Re: [PATCH 7/7] s390/cio: Remove vfio-ccw checks of command codes
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>,
        Farhan Ali <alifm@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20190503134912.39756-1-farman@linux.ibm.com>
 <20190503134912.39756-8-farman@linux.ibm.com>
 <8625f759-0a2d-09af-c8b5-5b312d854ba1@linux.ibm.com>
 <7c897993-d146-bf8e-48ad-11a914a04716@linux.ibm.com>
 <bba6c0a8-2346-cd99-b8ad-f316daac010b@linux.ibm.com>
 <7ac9fb43-8d7a-9e04-8cba-fa4c63dfc413@linux.ibm.com>
 <1f2e4272-8570-f93f-9d67-a43dcb00fc55@linux.ibm.com>
 <5c2b74a9-e1d9-cd63-1284-6544fa4376d9@linux.ibm.com>
 <20190510134718.3f727571.cohuck@redhat.com>
 <85fe257b-721a-f900-32fa-011845f242ed@linux.ibm.com>
 <20190514162913.6db90f44.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Date:   Tue, 14 May 2019 14:29:32 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514162913.6db90f44.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19051418-0052-0000-0000-000003BF3379
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011098; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000285; SDB=6.01203304; UDB=6.00631605; IPR=6.00984227;
 MB=3.00026887; MTD=3.00000008; XFM=3.00000015; UTC=2019-05-14 18:29:36
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19051418-0053-0000-0000-000060E55B46
Message-Id: <59c0f455-7b2f-5a85-1107-d8be5b85c16a@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-14_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905140125
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/14/19 10:29 AM, Cornelia Huck wrote:
> On Fri, 10 May 2019 10:24:31 -0400
> Eric Farman <farman@linux.ibm.com> wrote:
> 
>> On 5/10/19 7:47 AM, Cornelia Huck wrote:
>>> On Wed, 8 May 2019 11:22:07 +0200
>>> Pierre Morel <pmorel@linux.ibm.com> wrote:
>>>    
>>>> For the NOOP its clearly stated that it does not start a data transfer.
>>>> If we pin the CDA, it could then eventually be the cause of errors if
>>>> the address indicated by the CDA is not accessible.
>>>>
>>>> The NOOP is a particular CONTROL operation for which no data is transfered.
>>>> Other CONTROL operation may start a data transfer.
>>>
>>> I've just looked at the documentation again.
>>>
>>> The Olde Common I/O Device Commands document indicates that a NOOP
>>> simply causes channel end/device end.
>>>
>>> The PoP seems to indicate that the cda is always checked (i.e. does it
>>> point to a valid memory area?), but I'm not sure whether the area that
>>> is pointed to is checked for accessibility etc. as well, even if the
>>> command does not transfer any data.
>>>
>>> Has somebody tried to find out what happens on Real Hardware(tm) if you
>>> send a command that is not supposed to transfer any data where the cda
>>> points to a valid, but not accessible area?
>>
>> Hrm...  The CDA itself?  I don't think so.  Since every CCW is converted
>> to an IDAL in vfio-ccw, we guarantee that it's pointing to something
>> valid at that point.
>>
>> So, I hacked ccwchain_fetch_direct() to NOT set the IDAL flag in a NOP
>> CCW, and to leave the CDA alone.  This means it will still contain the
>> guest address, which is risky but hey it's a test system.  :)  (I
>> offline'd a bunch of host memory too, to make sure I had some
>> unavailable addresses.)
>>
>> In my traces, the non-IDA NOP CCWs were issued to the host with and
>> without the skip flag, with zero and non-zero counts, and with zero and
>> non-zero CDAs.  All of them work just fine, including the ones who's
>> addresses fall into the offline space.  Even the combination of no skip,
>> non-zero count, and zero cda.
>>
>> I modified that hack to do the same for a known invalid control opcode,
>> and it seemed to be okay too.  We got an (expected) invalid command
>> before we noticed any problem with the provided address.
> 
> That's interesting; I would not have arrived at this by interpreting
> the PoP...
> 
>>>
>>> In general, I think doing the translation (and probably already hitting
>>> errors there) is better than sending down a guest address.
>>>    
>>
>> I mostly agree, but I have one test program that generates invalid GUEST
>> addresses with its NOP CCWs, since it doesn't seem to care about whether
>> they're valid or not.  So any attempt to pin them will end badly, which
>> is why I call that opcode out in ccw_does_data_transfer(), and just send
>> invalid IDAWs with it.
> 
> So, without the attempt to pin they do not fail? 

Correct.

> Maybe the right
> approach would be to rewrite the cda before sending the ccws?
> 

That would be my vote.  (And it's what this series does.  :)

