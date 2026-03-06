Return-Path: <kvm+bounces-72981-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOTZJgZSqmlNPQEAu9opvQ
	(envelope-from <kvm+bounces-72981-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 05:03:18 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 23EE421B5DC
	for <lists+kvm@lfdr.de>; Fri, 06 Mar 2026 05:03:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 21C0E3029ADC
	for <lists+kvm@lfdr.de>; Fri,  6 Mar 2026 04:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3205536CDF9;
	Fri,  6 Mar 2026 04:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G90NKqhI"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECFF36B041;
	Fri,  6 Mar 2026 04:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772769777; cv=none; b=IUP1BpMxlq1C1fMNDXQ09GUR7eq7WnA3DXPUADlgr163jXnV6C1xGwgGSpoUL83KYdopXAiHSAhM7XnaoswvWFhiFCvyoHqAexZpBQFz9HLDz2atMdZ3ZKyUSN789xfyOOyl7/SL3ZpuaVVSp8WS5wP8sQu9nSqd1hFx09FAElg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772769777; c=relaxed/simple;
	bh=1i/CkAnVr2+PO/HNNzEjdeb37T8n0nAudpZEV1VXW18=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HOj8j2Vu00V+KWNki6Ypxp/yitUYzyprubbTbXQETTanVXlloCYqX7asq9pZ9bS15vLO0oGQbUPd6mFgrwy/A0dGJrGA0V36VK5yQtRkVyeCS9pGPgf1XgoolujU/kkc5N2FZoIAMj7Dzs7V16nYMbFuyhMtyATAcluS3BkeXVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G90NKqhI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 625HmObr1924065;
	Fri, 6 Mar 2026 04:02:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=UtUNkw
	0MUz2/AtsXvYufy1POqUwRsR6hIlEgXa74mBc=; b=G90NKqhIChlSJJ+/crnnEj
	h0Ps2O9yGtDnnpgCwhfbXUJpkY+AWv84sZZlKCmIYOTKD3R/87leilKxveTU75Ko
	zYK+YY5gqPMwe36diSg+TB0RCGYPPut9U8RbF1G47fr4N2ucLQwW50kwVc4XXRk6
	7EEL9a8jpV9wN4t4NGAo/cxHI52axctBolgOoPGi3EJ0z9Mez7X0J0luHnyhgkh5
	pHlHzboM4KYONvlSkQ8H7iMCXd1MgcFkiDMwDXmseVJ2v4vqyATdbwa1OzYfJ1uO
	1Kw3PhRqRQjF7eOCIa2S0qDcjZMrTy1gSSuzriL466cfdUdnbbHxauGoPBGk+Vrg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cksjdpr7v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 04:02:48 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 62600ARw027662;
	Fri, 6 Mar 2026 04:02:47 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cmcwjp2bc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Mar 2026 04:02:47 +0000
Received: from smtpav01.dal12v.mail.ibm.com (smtpav01.dal12v.mail.ibm.com [10.241.53.100])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 62642OB664684450
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Mar 2026 04:02:25 GMT
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A0C2E58062;
	Fri,  6 Mar 2026 04:02:46 +0000 (GMT)
Received: from smtpav01.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3A3C658057;
	Fri,  6 Mar 2026 04:02:44 +0000 (GMT)
Received: from [9.109.209.83] (unknown [9.109.209.83])
	by smtpav01.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Mar 2026 04:02:43 +0000 (GMT)
Message-ID: <06e74ae1-f2ad-44b9-943e-d81f6e9a638f@linux.ibm.com>
Date: Fri, 6 Mar 2026 09:32:42 +0530
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] KVM: PPC: e500: Fix build error due to crappy KVM
 code
To: Sean Christopherson <seanjc@google.com>
Cc: linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <kees@kernel.org>
References: <20260303190339.974325-1-seanjc@google.com>
 <177272543796.1535167.14939828079649935273.b4-ty@google.com>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <177272543796.1535167.14939828079649935273.b4-ty@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=M9BA6iws c=1 sm=1 tr=0 ts=69aa51e8 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=NEAV23lmAAAA:8
 a=jQXK01wa9qvNmsbPlo4A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0Az0gzEXROmdiPSJ5PQfQiwjWwAlhAIz
X-Proofpoint-GUID: xz7hjrzrD_28MSnVOOToB6SC6GibOsrh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA2MDAzMiBTYWx0ZWRfX38kdr00v9uZu
 /VWvHSkAgYHvsILWCR+Z5RbssF6Fi5ym7yEa3kBx6rE2zDAjCQzagfi42Vn6MKvbreW8EGF4x+j
 DtHTu5TsI3hHNNlVkFX8eNMBBmEZ8Xc9548S/M7qCMMDza3zp6iyUbgxfVnk9PoXGoRkWB6bGGG
 68vkFHArZhW1RI+DJybrd8qRnOKZTjkDpld1F4ZjYHYVlzdHjzhwVIIuih983pjyW+p2LzWGKi5
 m6TFCqA2JWQpKF7LppTaCUQ2zcL4r6WA8hjzyTIwo4xIHmr/TxINRFw22Q2fRgVHrzgtpXbjKEh
 NnWKDTi+mu71zuIZ9AZRwduXlqUj1L1LMWsx9aeU6IroTb7PLrTb+3+zqx0MYSP1yCXz/d88tOH
 cuxMgXFdeY0g7LYZpAvR3IN1KxW7/h/vt630hgeeCoJm0kxfaT0dm+pyOoYCHHSDlr8igamild5
 LxjujnVAVM+LlPUXNOQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-06_01,2026-03-04_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0
 bulkscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603060032
X-Rspamd-Queue-Id: 23EE421B5DC
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_RCPT(0.00)[kvm];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11];
	RCVD_TLS_LAST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[maddy@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-72981-lists,kvm=lfdr.de];
	DKIM_TRACE(0.00)[ibm.com:+]
X-Rspamd-Action: no action


On 3/5/26 10:37 PM, Sean Christopherson wrote:
> On Tue, 03 Mar 2026 11:03:37 -0800, Sean Christopherson wrote:
>> Fix an e500 build error that was introduced by the recent kmalloc_obj()
>> conversion, but in reality is due to crappy KVM code that has existed for
>> ~13 years.
>>
>> I'm taking this through kvm-x86 fixes, because it's breaking my testing setup,
>> and obviously no one cares about KVM e500 since PPC_WERROR is default 'y' and
>> needs to be explicitly disabled via PPC_DISABLE_WERROR.
>>
>> [...]
> Applied to kvm-x86 fixes, thanks!
>
> [1/2] KVM: PPC: e500: Fix build error due to using kmalloc_obj() with wrong type
>        https://github.com/kvm-x86/linux/commit/a223ccf0af6e
> [2/2] KVM: PPC: e500: Rip out "struct tlbe_ref"
>        https://github.com/kvm-x86/linux/commit/3271085a7f10
I added this to my fixes-test, will pull it since you are taking it.

Maddy

> --
> https://github.com/kvm-x86/linux/tree/next

