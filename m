Return-Path: <kvm+bounces-3880-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E88C809252
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 21:32:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8AC35282105
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 20:32:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E14524B6;
	Thu,  7 Dec 2023 20:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NG/uwE8Q"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5095B171C;
	Thu,  7 Dec 2023 12:31:55 -0800 (PST)
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7J14EH000673;
	Thu, 7 Dec 2023 20:31:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Xzp5Z/pXwD5A9wQql64YfTNz4MLSPL3TXj2vLWKtBxY=;
 b=NG/uwE8Qx6DPqeJORLFTT61BnrfMLjaU3CAmvol9FegVhu77OsRcAIysLP0c+idJjR7X
 paBj+gWGKzovNfGZCA0rmeU5R4swLEsc4v8WKpNgX+ACExL0Xb9Bj+Gt83bIaNUpP8B6
 Gx8E2x9n+7JrAa0VHaiyAEi45wO0flDJSvXBTM2TD1c3iyYCjA2W/E9fmGkA5KaIOJBd
 uXToMuuN/3rUneI8MnBP3Hj/OTTOggZFdTRxN+T8VBZeL7lhoyyuciXK/ips1utD5jXF
 eYVq/19SzUO08TcCS0fKbmELcNmCPBzlVMBn0dHcY6aGQ5K+Cz+tz9VKicYu/mkAVDxX oQ== 
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uukmnj37s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 20:31:54 +0000
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7Jd2iT027000;
	Thu, 7 Dec 2023 20:31:53 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 3utav35h6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 20:31:53 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B7KVrN551053170
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Dec 2023 20:31:53 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F07975805A;
	Thu,  7 Dec 2023 20:31:52 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3886B58052;
	Thu,  7 Dec 2023 20:31:52 +0000 (GMT)
Received: from [9.61.14.138] (unknown [9.61.14.138])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Dec 2023 20:31:52 +0000 (GMT)
Message-ID: <78fd1f4d-bd20-413f-8d89-b365ae7c489b@linux.ibm.com>
Date: Thu, 7 Dec 2023 15:31:51 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
To: Eric Farman <farman@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Halil Pasic
 <pasic@linux.ibm.com>,
        Jason Herne <jjherne@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20231201181657.1614645-1-farman@linux.ibm.com>
 <a62458b8-753d-43ad-b231-a359c9406c92@linux.ibm.com>
 <bbc29010083e36591ec1029d6f50516182cd7eaa.camel@linux.ibm.com>
Content-Language: en-US
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <bbc29010083e36591ec1029d6f50516182cd7eaa.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IN4GQ4pSkxy11xpv97x_FZOP5k4LvqjV
X-Proofpoint-ORIG-GUID: IN4GQ4pSkxy11xpv97x_FZOP5k4LvqjV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_17,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 suspectscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 spamscore=0 phishscore=0 bulkscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312070173


On 12/7/23 11:11 AM, Eric Farman wrote:
> On Thu, 2023-12-07 at 10:39 -0500, Anthony Krowiak wrote:
>> On 12/1/23 1:16 PM, Eric Farman wrote:
>>> The various errors that are possible when processing a PQAP
>>> instruction (the absence of a driver hook, an error FROM that
>>> hook), all correctly set the PSW condition code to 3. But if
>>> that processing works successfully, CC0 needs to be set to
>>> convey that everything was fine.
>>>
>>> Fix the check so that the guest can examine the condition code
>>> to determine whether GPR1 has meaningful data.
>>>
>>> Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for
>>> AQIC")
>>> Signed-off-by: Eric Farman <farman@linux.ibm.com>
>>> ---
>>>    arch/s390/kvm/priv.c | 8 ++++++--
>>>    1 file changed, 6 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
>>> index 621a17fd1a1b..f875a404a0a0 100644
>>> --- a/arch/s390/kvm/priv.c
>>> +++ b/arch/s390/kvm/priv.c
>>> @@ -676,8 +676,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>>>          if (vcpu->kvm->arch.crypto.pqap_hook) {
>>>                  pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
>>>                  ret = pqap_hook(vcpu);
>>> -               if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>>> -                       kvm_s390_set_psw_cc(vcpu, 3);
>>> +               if (!ret) {
>>> +                       if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
>>> +                               kvm_s390_set_psw_cc(vcpu, 3);
>>> +                       else
>>> +                               kvm_s390_set_psw_cc(vcpu, 0);
>>> +               }
>>
>> The cc is not set if pqap_hook returns a non-zero rc; however, this
>> point may be moot given the only non-zero rc is -EOPNOTSUPP. I'm a
>> bit
>> foggy on what happens when non-zero return codes are passed up the
>> stack.
> Right, a non-zero RC will get reflected to the interception handlers,
> where EOPNOTSUPP instructs control to be given to userspace. So not
> setting a condition code is correct here, as userspace will be expected
> to do that.


Thanks for confirming that. With that said:

Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>


>
>>
>>>                  up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
>>>                  return ret;
>>>          }

