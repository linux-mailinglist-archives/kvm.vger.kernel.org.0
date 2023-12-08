Return-Path: <kvm+bounces-3915-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A7AB80A551
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 15:21:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CA6641F21348
	for <lists+kvm@lfdr.de>; Fri,  8 Dec 2023 14:21:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E361DFD7;
	Fri,  8 Dec 2023 14:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="F8ob1n3G"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F48171D;
	Fri,  8 Dec 2023 06:21:17 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8DKQxG015335;
	Fri, 8 Dec 2023 14:21:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7prP1ZPaFrX9dJQHxUFlI0YQ9pGd5ZixGsXP58BtELA=;
 b=F8ob1n3GgqTFPaA7dDYP25bjGodNYQAwLs7dkjVByLv5+FpiL6mIeQaHNrubgGoC3fG3
 xpcEiK9AGSOtmmIU6ALVJNP/mkEywHH3DgHJGUN96FEwQHTh1Pge3htTJls52RDjWLIa
 JPWb0ZpFeYfKIYyjIEaPkLZrTCbgh1NMGc/D1Bvxp6e3JX+93i8Rv0J+gdrS+cxgd1Xy
 5s8qTJGl2OS1SadcZlj2sRJsXcF8cs/1RYPcxgtcfRC9T0Z/+hdxmig/VbGndSEj7K+W
 8eQMCapnoFLMBQ0WKgypqDdW+/ulmiEitrZrCX21UkkmQ9FQtZT5YcEGo3OabPAnxpZG /Q== 
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uv0cu8asg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 14:21:15 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B8D537i004735;
	Fri, 8 Dec 2023 14:21:13 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utav4t0w2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 08 Dec 2023 14:21:13 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B8ELCm952888136
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 8 Dec 2023 14:21:13 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B98ED58054;
	Fri,  8 Dec 2023 14:21:12 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9E365805A;
	Fri,  8 Dec 2023 14:21:11 +0000 (GMT)
Received: from [9.61.43.82] (unknown [9.61.43.82])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  8 Dec 2023 14:21:11 +0000 (GMT)
Message-ID: <918b6276-f423-49c8-8719-4517e9d23bad@linux.ibm.com>
Date: Fri, 8 Dec 2023 09:21:11 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
Content-Language: en-US
To: Eric Farman <farman@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20231201181657.1614645-1-farman@linux.ibm.com>
 <fe3082f7-70fd-479f-b6a2-d753d271d6d5@linux.ibm.com>
 <0fe89d1a4ef539bef4bdf2302faf23f6d5848bf2.camel@linux.ibm.com>
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <0fe89d1a4ef539bef4bdf2302faf23f6d5848bf2.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: XVvNz0tTnDGwb4mHg4tUVcQyXhZeIeSd
X-Proofpoint-ORIG-GUID: XVvNz0tTnDGwb4mHg4tUVcQyXhZeIeSd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-08_09,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=815 spamscore=0 clxscore=1015 phishscore=0 suspectscore=0
 impostorscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2312080118


On 12/8/23 6:24 AM, Eric Farman wrote:
> On Fri, 2023-12-08 at 11:31 +0100, Janosch Frank wrote:
>> On 12/1/23 19:16, Eric Farman wrote:
>>> The various errors that are possible when processing a PQAP
>>> instruction (the absence of a driver hook, an error FROM that
>>> hook), all correctly set the PSW condition code to 3. But if
>>> that processing works successfully, CC0 needs to be set to
>>> convey that everything was fine.
>>>
>>> Fix the check so that the guest can examine the condition code
>>> to determine whether GPR1 has meaningful data.
>>>
>> Hey Eric, I have yet to see this produce a fail in my AP KVM unit
>> tests.
>> If you find some spare time I'd like to discuss how I can extend my
>> test
>> so that I can see the fail before it's fixed.
>>
> Hi Janosch, absolutely. I had poked around kvm-unit-tests before I sent
> this up to see if I could adapt something to show this scenario, but
> came up empty and didn't want to go too far down that rabbit hole
> creating something from scratch. I'll ping you offline to find a time
> to talk.


If this is recreateable, I'd like to know how. I don't see any code path 
that would cause this result.


>
> Eric
>

