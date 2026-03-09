Return-Path: <kvm+bounces-73349-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oCTIJxAPr2kYNQIAu9opvQ
	(envelope-from <kvm+bounces-73349-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:18:56 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0482223E7FA
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 19:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7470530C19F8
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 18:16:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B112344031;
	Mon,  9 Mar 2026 18:15:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WRPQrv6L"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ADB233F8C3;
	Mon,  9 Mar 2026 18:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773080157; cv=none; b=O7+CeAKTpSfsK8UZ3gTZ/2Smek9wWG5QLZNWRWL3YdwpVC7HzxEixXTda/c0PqLj+g34VrPQlRDNSn68RKOEd0K/Ht0NtcO1wiqrO+ZVe4mUhEgMOXhhsEevddH/Vf5upZxq2zAglKlKdtJAD/vuvZMukQm56CYRG0Tm+rvzWmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773080157; c=relaxed/simple;
	bh=S3zDMOWK6h4tMVI8QZlaZgJ+M+yVeeg5rrKz9pWNUwk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CZZ4vD53NMHPYsJoYIJWNULpUg64ui840SUXrUOt1Ils0oxBcjTw3pm/L+O9D1MlZUcFH8Q1OGjviPmulNz4yaOvkb5Ixsz4BtN7mKbzq5HcAnBFNlMO4lxQdX1YZYi+fyGBRGCf1Z52nhvLOZXFfmmIsjTdiYUjLLvm82i6wm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WRPQrv6L; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 629G1bLe1601192;
	Mon, 9 Mar 2026 18:15:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nSfjrE
	C7t8h32bKx9sVrqabpE6raJCYESdQIDBERNNE=; b=WRPQrv6Lv62Fnb+IGNbEUk
	V+D0u0SEj94nR5lwL6tlSQ25ORO6ASn7zo4E8jENMcOBI5wXDcldSQ9UKVqpeMnS
	BKFeq2qWFjftcKnwFIlS6yRrCa02cRrdUbtCF0THGw2zm1/uC4hFnjG5VysjDhT5
	ENpgZw+8e8Moxsm33E3iREO2yxMS3hxxBmGwHFlc1tCRrQRP3DzPvyuxyPOOYjNg
	frTytzKG2BM3Ovn98oyfbvSLFfDwhpLuu4OI80M/eH//Mwrf1XOoKyLCRf6YYwqZ
	GI+OWhUebHvSNHowNE3Es0KVyjKmnsr1OJPCmv7WIVyYQN72ew0kZuccaZEfqS1Q
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvr7msy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 18:15:52 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 629Fkun0015706;
	Mon, 9 Mar 2026 18:15:52 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs121wsc5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 18:15:52 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629IFmYx46858500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 18:15:48 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 88DA620043;
	Mon,  9 Mar 2026 18:15:48 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E134720040;
	Mon,  9 Mar 2026 18:15:47 +0000 (GMT)
Received: from [9.111.59.188] (unknown [9.111.59.188])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 18:15:47 +0000 (GMT)
Message-ID: <af6dd289-eb40-4c3d-acd2-c0b698cc4f73@linux.ibm.com>
Date: Mon, 9 Mar 2026 19:15:47 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/3] Add map/unmap ioctl and clean mappings post-guest
To: Douglas Freimuth <freimuth@linux.ibm.com>, imbrenda@linux.ibm.com,
        frankja@linux.ibm.com, david@kernel.org, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, svens@linux.ibm.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: mjrosato@linux.ibm.com
References: <20260308030438.88580-1-freimuth@linux.ibm.com>
 <20260308030438.88580-2-freimuth@linux.ibm.com>
 <1a56eea9-b339-460f-8007-985a432d944c@linux.ibm.com>
 <0ecd8210-e97a-4a5a-a9f2-513b7a323984@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <0ecd8210-e97a-4a5a-a9f2-513b7a323984@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDE2MiBTYWx0ZWRfX/ms5FSpF2Dm6
 +1/BC/tghUcJa3Dbilehn3eXiT+gA7BDYkQPEMVecJtDBKPxT7aRd8EL42R4txTK37EaoN58G+r
 CsYLhH6UlaX8VOqJb060gnHSfFNSnQ3R56RiTmS6fbd6IWmi9+9jthDzGobDWDiYX0Jwlog25uN
 FXQpsqokxAGTNkT4Nt0l6Ix/lKlaNTxMiW56YLD8NbEcwtC8AYYehhZVXdtD3QgdjEv3gfDErhe
 zV4BnDU6foKJ6f+TBula/jgS5hu960J1MBywZ/+JDcUKJO93fqgiJ7SpfnTSAaiQ/qiOD+FShpL
 Vtzr86KX9xNNHwrUu/lyY1ODJpTTA6xKtkAM0Tbk44p5GjsPFpgwLMdboyp/pa+uKMxJFHl/xsc
 9GA2XyZ+gskh3+mUiyOZAqTV04uaNtryd9w2E+q+H+81Mihbj8/1uU/HDtkiEbI43SAnpWV4FgC
 zkjpx84Ny9/xyG3Dbuw==
X-Proofpoint-GUID: bqXFKnbdV3IISl5qvfBNk1oi80o_Kog3
X-Proofpoint-ORIG-GUID: bqXFKnbdV3IISl5qvfBNk1oi80o_Kog3
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69af0e59 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=4C_WRym88NEJYY1sSFAA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603090162
X-Rspamd-Queue-Id: 0482223E7FA
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	TAGGED_FROM(0.00)[bounces-73349-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action



Am 09.03.26 um 18:12 schrieb Douglas Freimuth:
> 
> 
> On 3/9/26 5:27 AM, Christian Borntraeger wrote:
>> Am 08.03.26 um 04:04 schrieb Douglas Freimuth:
>>> Fencing of Fast Inject in Secure Execution environments is enabled in
>>> this patch by not mapping adapter indicator pages. In Secure Execution
>> [...]
>>
>>> @@ -2477,14 +2572,28 @@ static int modify_io_adapter(struct kvm_device *dev,
>>>           if (ret > 0)
>>>               ret = 0;
>>>           break;
>>> -    /*
>>> -     * The following operations are no longer needed and therefore no-ops.
>>> -     * The gpa to hva translation is done when an IRQ route is set up. The
>>> -     * set_irq code uses get_user_pages_remote() to do the actual write.
>>> -     */
>>>       case KVM_S390_IO_ADAPTER_MAP:
>>>       case KVM_S390_IO_ADAPTER_UNMAP:
>>> -        ret = 0;
>>> +        mutex_lock(&dev->kvm->lock);
>>> +        if (kvm_s390_pv_is_protected(dev->kvm)) {
>>> +            mutex_unlock(&dev->kvm->lock);
>>> +            break;
>>> +        }
>>
>>
>> I guess this works for a well behaving userspaces, but a bad QEMU could in theory
>> not do the unmap on switch to secure.
>> Shall we maybe do -EINVAL on KVM_PV_ENABLE if there are still mapping left, or
>> to make it easier for userspace remove the old ADAPTER maps?
>>
> 
> Christian, thank you for your input. For this scenario, I will look into adding/testing removing the old adapter maps. I will start in kvm_s390_handle_pv() for CASE KVM_PV_ENABLE and I will essentially use most of the functionality in kvm_s390_destroy_adapters() where the maps are deleted if they exist.

Right, maybe just add a unmap_all_adapters function and call that.

> 
> Discussion: During development and test I realized it appears a guest can only change state between non-SE and SE during a reboot. Thus the unmap and map is called which hits the fencing in the current patch. Additionally, a more draconian fencing could possibly be done if needed, by checking for the existence of SE firmware in the CMDLINE and prevent any mapping from occurring on those systems that support SE.

Yes, diagnose 308 code 10 switches in a reboot like style to secure and diagnose 308 code 3 or 4 switch back to non secure.


