Return-Path: <kvm+bounces-73274-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id uBmYCYqTrmmmGQIAu9opvQ
	(envelope-from <kvm+bounces-73274-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:31:54 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6619236321
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 10:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0C6130602C2
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 09:27:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DDB37A487;
	Mon,  9 Mar 2026 09:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eraczvU4"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC91378800;
	Mon,  9 Mar 2026 09:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773048453; cv=none; b=dOsGJEQZ7SB1xMwHAS8Fam8pSfWGn7IgE4p6LR/jLqrYMlUtIP6mKTYRgHa9qRZW/mr8Z3Uin9OKY/3nhLUu4JcEdhRTodQ1cOJGOLvEmy1Jww3j+4eUhw2gV6PhVR+DtBRVMCkdmlQHdBm+aCqasBRDCOgO8EWaHV4IbNgE6u0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773048453; c=relaxed/simple;
	bh=z6KjXdQAWcfCE1S74Oo4FfWIEzQOdxioqqMMS9/NxiY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GsbCqxrk7W0yeTz39KdP1EmQGzg70GFs/wKMEjw96xx+TkG+cqlLAWxKPjLfezhDkoHggbtLzNIWrsWKX+SmKKG2Di+NZbfdWQel9HLslMLXYLgK4Q8uqzXIv9Gz6A1hPBkEfXRG3FK5/vJfJONNhCOO/PsZOowDBkWNkumGw3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eraczvU4; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628MknfX1601192;
	Mon, 9 Mar 2026 09:27:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=cRcVMw
	V5pt1zVlDD5PHIjSrJMb5sl82uanKbhUeAdkI=; b=eraczvU4tR148NqNAPnUHR
	Ndd3SN92OBqWlDAw3Zznr0j7bwwbjQ9Tu/JbYv8PFxdzGJL0Q+3Cbjcn0qAOIGf/
	z77EarLluRbe5QjkmMt+7Ti5Sxy/UuBu38MukxkvcHgQFGeMitWdxRI5hntk+XtV
	np4foxYwnbScOFLqadpQ7sVFBBF1LiVxZ+1KE+HPQZ5nxjGE2QXmzriGsro6Ricy
	I3nVftM9BtKscSsy+lPICyp7dFGw2+lF/+DcLGqxXHQIJZekE2GdbTmbHg1QEfeJ
	uZUbMOB6CDeuvsq/N7et4VtBgs5kacykto0rGCCu0itP/WCiC5wzhhdEVNDqok9w
	==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcvr5py2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 09:27:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6298e4tT009467;
	Mon, 9 Mar 2026 09:27:27 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4crxqy4f7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 09:27:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6299RNJm24772942
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 09:27:23 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CEFB620043;
	Mon,  9 Mar 2026 09:27:23 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6B71320040;
	Mon,  9 Mar 2026 09:27:23 +0000 (GMT)
Received: from [9.52.200.39] (unknown [9.52.200.39])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  9 Mar 2026 09:27:23 +0000 (GMT)
Message-ID: <1a56eea9-b339-460f-8007-985a432d944c@linux.ibm.com>
Date: Mon, 9 Mar 2026 10:27:23 +0100
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
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260308030438.88580-2-freimuth@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDA4MyBTYWx0ZWRfX+QOtr36oeh04
 v961F88DKc0f1R+H0BUJ/F/egAqFKNnvKxm+rGC2FhrlAhWCSa2gnTIeIs541IBkP6QdleUlb+o
 6lIUOvJ+xVkgo5DM1pShGURu2dVyq7tpFiOm6OO8lfr9RDO3quBRIg0RTZIpLwiW0YLdkIIGo9q
 0qU0O1OlZMa/JUaWPOINx6w5eawoiWBPJw9BWBvdWWlAZhAzGNZsT0A5N+8DMNxhnJMKYWMyqGq
 ghoUgmsVzUCepHmVuwSmf34g6ELAmZplKK2q+Y9ehWSeFaDlZz6XwaNVEKNN+gYREKJFdSqzGED
 AfCzEXHHWYZ/YAf4tKn6nLVIPxVN7eW5PG6P07xe2Zy4kFsgxbHsZox2ond+qXMWfZqW4fWhOPB
 LGixgNQ7csfFopxADV9WUX0M0BclkGh6u0faREJMgDqZi9SiBIhu+ZYXEjSHFSqucr1IhBL1c1/
 LIfbPuCWol1fkuLi2YA==
X-Proofpoint-GUID: eDlid3UkSl1MSbacCBloDnZQ53StUZTm
X-Proofpoint-ORIG-GUID: eDlid3UkSl1MSbacCBloDnZQ53StUZTm
X-Authority-Analysis: v=2.4 cv=QoFTHFyd c=1 sm=1 tr=0 ts=69ae9280 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=lFrdhxbFXSv4YG0I5mYA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-06_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 priorityscore=1501 phishscore=0
 lowpriorityscore=0 adultscore=0 clxscore=1015 malwarescore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603090083
X-Rspamd-Queue-Id: C6619236321
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
	TAGGED_FROM(0.00)[bounces-73274-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,linux.ibm.com:mid];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.961];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

Am 08.03.26 um 04:04 schrieb Douglas Freimuth:
> Fencing of Fast Inject in Secure Execution environments is enabled in
> this patch by not mapping adapter indicator pages. In Secure Execution
[...]

> @@ -2477,14 +2572,28 @@ static int modify_io_adapter(struct kvm_device *dev,
>   		if (ret > 0)
>   			ret = 0;
>   		break;
> -	/*
> -	 * The following operations are no longer needed and therefore no-ops.
> -	 * The gpa to hva translation is done when an IRQ route is set up. The
> -	 * set_irq code uses get_user_pages_remote() to do the actual write.
> -	 */
>   	case KVM_S390_IO_ADAPTER_MAP:
>   	case KVM_S390_IO_ADAPTER_UNMAP:
> -		ret = 0;
> +		mutex_lock(&dev->kvm->lock);
> +		if (kvm_s390_pv_is_protected(dev->kvm)) {
> +			mutex_unlock(&dev->kvm->lock);
> +			break;
> +		}


I guess this works for a well behaving userspaces, but a bad QEMU could in theory
not do the unmap on switch to secure.
Shall we maybe do -EINVAL on KVM_PV_ENABLE if there are still mapping left, or
to make it easier for userspace remove the old ADAPTER maps?


