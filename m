Return-Path: <kvm+bounces-73336-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CBSSGq0Ar2kLLgIAu9opvQ
	(envelope-from <kvm+bounces-73336-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:17:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0C0D823D87D
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 18:17:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 9F97F30C1F8A
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 17:12:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D33633E5EF6;
	Mon,  9 Mar 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="LQ5rLO/P"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF7F03BD62E;
	Mon,  9 Mar 2026 17:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773076343; cv=none; b=NeTY0fKspXzwh8SL0Yuzg1VEci2WLl6SwalgBUHfqcAZh2MCDqO3osguG7/1kITs/CjdAgLkmsnzXEdEI6P8yyphwO8tWiEsPN9hjE5RnwQUUNlX90JNV92zmAC6hpGdpj211BJxxZ4hlVwFr6GMJ0bQsFM0NTcQQbMPkTb3Kb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773076343; c=relaxed/simple;
	bh=HHI/b/BHoNY68hDYXcMoWImRNCLeWTTEGc2by1oLW2o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bw9qZ3+bESXsh7tN7xf4VNeoHpJ+Ho9mDhpk/yDJzPCQmUZ5h1MpuBFHJFyiqRbo8GxE6nCeHrT3jPOeoxejFWF5F5oDbNb8LCwVnc1QL1TIjH795PKBVitayLkfU+q1bdWOvvHWDtsPQBLhX83qggJm8m2tV4Ipa701ETN+FJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=LQ5rLO/P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629EKFvQ1027783;
	Mon, 9 Mar 2026 17:12:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=stwg3m
	xGggs/iPfLxSRIA4R/lwE4PjXHw5h5eboBw/8=; b=LQ5rLO/Pn8xu/u3gEyK4rT
	DJ43eds4Cfif1ZORV8ojxRWvXbzMzoPe9c+66PgmnYYssoAjv36kwRV6lzt0I6K6
	EBmfXQB4UQvKajEHY9kaDuE5qYblPs+ux3W2gfXs2Fp6I2yqM2hjrVq+6usHjfwI
	N+DMorr12xEfprmQFAjvnk3mvUyiRJZW2Zkw2dVzi3TaNi9Fp6fC5Xf+BWdZbz+K
	t0GomUInMiW6nYqFsKDgjw+dmi5T81SBLEH3+59vE5sdGOB64lIDf3ZoyUxUUpuE
	UnH9gGNNFZwdOlkQiUacKKz5s4uHqamkSlgJ44bE0+8G1ED+ZBGFI27/P6PC2rzw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcun7dau-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:12:18 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 629DjuFK029625;
	Mon, 9 Mar 2026 17:12:17 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4csp6ujgd4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 17:12:17 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629HCG3L34931196
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 17:12:16 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A429458059;
	Mon,  9 Mar 2026 17:12:16 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 686135805B;
	Mon,  9 Mar 2026 17:12:15 +0000 (GMT)
Received: from [9.61.247.193] (unknown [9.61.247.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 17:12:15 +0000 (GMT)
Message-ID: <0ecd8210-e97a-4a5a-a9f2-513b7a323984@linux.ibm.com>
Date: Mon, 9 Mar 2026 13:12:14 -0400
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
To: Christian Borntraeger <borntraeger@linux.ibm.com>, imbrenda@linux.ibm.com,
        frankja@linux.ibm.com, david@kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com
References: <20260308030438.88580-1-freimuth@linux.ibm.com>
 <20260308030438.88580-2-freimuth@linux.ibm.com>
 <1a56eea9-b339-460f-8007-985a432d944c@linux.ibm.com>
Content-Language: en-US
From: Douglas Freimuth <freimuth@linux.ibm.com>
In-Reply-To: <1a56eea9-b339-460f-8007-985a432d944c@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 6Mk6PtpB6Z6gImVdmrg4W8EoPoFNDFwH
X-Authority-Analysis: v=2.4 cv=Hp172kTS c=1 sm=1 tr=0 ts=69aeff72 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=LTlFiCIWV38VnAT-2UoA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE1MyBTYWx0ZWRfXxpyuqYsH+Ojc
 WMXG6xuP7IhBjccQRWOCuYIwW/Ie+ohvX22681eCAh80xOml6XHmr9/42Cem7AKB14SUhPtb+PU
 6aBGttY1nNebuL4gnGGrSH5GlHdZNhKXqgnGuH0Qn6TGq48Vm2zAaJHeRHVPE9AtEPidPbNrGhM
 w6zjHMXPG6FWCMB7xWNG2Y05fiPSLf1vhWL62OzK7+UyqoXSswh1CaQ6p+DQ34dV9Fd6YF0mQUi
 OildGwU3ITM7/P3jZMqg1NXgjGybIgxfTiKgwBlfib7slPwabsQbPFQKx5vOz1Xy1dthFkMCvbS
 9XgbKWFAJpLrJZuOvikPaN7IELpgNAVgiDqXFPPiI6CEPT+MO1bAGnNlsCcZ6vrP5h369MzO4YZ
 nXsuOCkaUK9HF0FIaQiAtcEG4DtqM+Xx4504La8HPeucE5R4dtN2/KenrVpCL90kLccuYt9a/7B
 ZVRbMK8a+IgrjS3+y6w==
X-Proofpoint-ORIG-GUID: 6Mk6PtpB6Z6gImVdmrg4W8EoPoFNDFwH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_04,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 spamscore=0 phishscore=0 clxscore=1015 priorityscore=1501 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090153
X-Rspamd-Queue-Id: 0C0D823D87D
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-73336-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[freimuth@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action



On 3/9/26 5:27 AM, Christian Borntraeger wrote:
> Am 08.03.26 um 04:04 schrieb Douglas Freimuth:
>> Fencing of Fast Inject in Secure Execution environments is enabled in
>> this patch by not mapping adapter indicator pages. In Secure Execution
> [...]
> 
>> @@ -2477,14 +2572,28 @@ static int modify_io_adapter(struct kvm_device 
>> *dev,
>>           if (ret > 0)
>>               ret = 0;
>>           break;
>> -    /*
>> -     * The following operations are no longer needed and therefore 
>> no-ops.
>> -     * The gpa to hva translation is done when an IRQ route is set 
>> up. The
>> -     * set_irq code uses get_user_pages_remote() to do the actual write.
>> -     */
>>       case KVM_S390_IO_ADAPTER_MAP:
>>       case KVM_S390_IO_ADAPTER_UNMAP:
>> -        ret = 0;
>> +        mutex_lock(&dev->kvm->lock);
>> +        if (kvm_s390_pv_is_protected(dev->kvm)) {
>> +            mutex_unlock(&dev->kvm->lock);
>> +            break;
>> +        }
> 
> 
> I guess this works for a well behaving userspaces, but a bad QEMU could 
> in theory
> not do the unmap on switch to secure.
> Shall we maybe do -EINVAL on KVM_PV_ENABLE if there are still mapping 
> left, or
> to make it easier for userspace remove the old ADAPTER maps?
> 

Christian, thank you for your input. For this scenario, I will look into 
adding/testing removing the old adapter maps. I will start in 
kvm_s390_handle_pv() for CASE KVM_PV_ENABLE and I will essentially use 
most of the functionality in kvm_s390_destroy_adapters() where the maps 
are deleted if they exist.

Discussion: During development and test I realized it appears a guest 
can only change state between non-SE and SE during a reboot. Thus the 
unmap and map is called which hits the fencing in the current patch. 
Additionally, a more draconian fencing could possibly be done if needed, 
by checking for the existence of SE firmware in the CMDLINE and prevent 
any mapping from occurring on those systems that support SE.

