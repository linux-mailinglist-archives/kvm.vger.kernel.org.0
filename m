Return-Path: <kvm+bounces-3874-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C4C6F808C0E
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 16:40:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7DDD12818D0
	for <lists+kvm@lfdr.de>; Thu,  7 Dec 2023 15:40:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 370DE45972;
	Thu,  7 Dec 2023 15:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="s7Fut6+P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F83810D5;
	Thu,  7 Dec 2023 07:40:04 -0800 (PST)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7FHtH8025281;
	Thu, 7 Dec 2023 15:40:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rkRj8pVsaD6b8QXN81yllYNtF+rqaDLpZadPEoFqXio=;
 b=s7Fut6+P2xsA5R3YacKIje8QVDNutBeH7vixi2siHc1CckLuJLcpzR9RQtkZbTIqtW9N
 b9Szq2MltzA/1kIAlfKP1lGNLBzPOYW/4s6n9NxLnoTxq5+uzFWO2sE8S3n7mZbGjTaQ
 KnrTuWzW+VSlAyflfIp/yheC3NNos1bC1qG0M8Fk5A6T23V36LLFOx8/L4bTZH0SDGgm
 E/ZznJ1TIx5j7bzY3EZxE4jTTJlA4qS5JYbxmbWZiV9C/iV3itm7C5ERoiZ/uvKeM4nn
 Z+Dr3X0/v2QVJRWG/62gA2DO6vVaqT/hQgR81bX/wkUQLKJ7opvhZF8bQKEIPg7wcTOP YQ== 
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3uug4thm5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 15:40:03 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B7EKGaK013754;
	Thu, 7 Dec 2023 15:40:02 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3utau4c0fw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 07 Dec 2023 15:40:02 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B7Fe1gD21561786
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 7 Dec 2023 15:40:01 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4703958055;
	Thu,  7 Dec 2023 15:40:01 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E9C9A5804B;
	Thu,  7 Dec 2023 15:39:53 +0000 (GMT)
Received: from [9.61.158.74] (unknown [9.61.158.74])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  7 Dec 2023 15:39:53 +0000 (GMT)
Message-ID: <a62458b8-753d-43ad-b231-a359c9406c92@linux.ibm.com>
Date: Thu, 7 Dec 2023 10:39:50 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: fix cc for successful PQAP
Content-Language: en-US
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
From: Anthony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20231201181657.1614645-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: NHnbsNQI7-sJ8DbnO-Te3DKcuZVrH1au
X-Proofpoint-ORIG-GUID: NHnbsNQI7-sJ8DbnO-Te3DKcuZVrH1au
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-07_12,2023-12-07_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 priorityscore=1501 mlxscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2312070129


On 12/1/23 1:16 PM, Eric Farman wrote:
> The various errors that are possible when processing a PQAP
> instruction (the absence of a driver hook, an error FROM that
> hook), all correctly set the PSW condition code to 3. But if
> that processing works successfully, CC0 needs to be set to
> convey that everything was fine.
>
> Fix the check so that the guest can examine the condition code
> to determine whether GPR1 has meaningful data.
>
> Fixes: e5282de93105 ("s390: ap: kvm: add PQAP interception for AQIC")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>
> ---
>   arch/s390/kvm/priv.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/arch/s390/kvm/priv.c b/arch/s390/kvm/priv.c
> index 621a17fd1a1b..f875a404a0a0 100644
> --- a/arch/s390/kvm/priv.c
> +++ b/arch/s390/kvm/priv.c
> @@ -676,8 +676,12 @@ static int handle_pqap(struct kvm_vcpu *vcpu)
>   	if (vcpu->kvm->arch.crypto.pqap_hook) {
>   		pqap_hook = *vcpu->kvm->arch.crypto.pqap_hook;
>   		ret = pqap_hook(vcpu);
> -		if (!ret && vcpu->run->s.regs.gprs[1] & 0x00ff0000)
> -			kvm_s390_set_psw_cc(vcpu, 3);
> +		if (!ret) {
> +			if (vcpu->run->s.regs.gprs[1] & 0x00ff0000)
> +				kvm_s390_set_psw_cc(vcpu, 3);
> +			else
> +				kvm_s390_set_psw_cc(vcpu, 0);
> +		}


The cc is not set if pqap_hook returns a non-zero rc; however, this 
point may be moot given the only non-zero rc is -EOPNOTSUPP. I'm a bit 
foggy on what happens when non-zero return codes are passed up the stack.


>   		up_read(&vcpu->kvm->arch.crypto.pqap_hook_rwsem);
>   		return ret;
>   	}

