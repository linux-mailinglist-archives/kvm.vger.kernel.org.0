Return-Path: <kvm+bounces-72028-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id WPhyFKtyoGlZjwQAu9opvQ
	(envelope-from <kvm+bounces-72028-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:19:55 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 8F76E1AA05C
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 17:19:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3A5BE31F41A9
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 16:12:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51F1F423A8F;
	Thu, 26 Feb 2026 15:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="lPOKPeBL"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A77742B72A;
	Thu, 26 Feb 2026 15:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772121560; cv=none; b=sEVTdt8OUg0tS5YP2d6PzXH5QqHNSnK1Q7NejLRmO1Vg5GEL4/vXjvAqeG0gDWJu7zdwNmwfskgB5CTetFQCJmZh/GWfwGfNjBnmtAB3R7WQzYSKTwbCHcsjM+4VLHOXNBei9mN97LuRCBeuOwH7J4895oS4T4AGRW0krYMQwDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772121560; c=relaxed/simple;
	bh=BglG78IulTmphOGQTtH1M99mydRcDoZLE4d8gHIxNFU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A2ONTwqzn+jQofscoJyjuVFmvruGy0fwLSt+GH37COKeHAE4tV03HNi/MonUyXmJdrKxN+uZJ2nkrKi4fgA/9CnsLgqZYUS4UdzfYcV1LNndYAWxVF2BsQUUsaW+7DdvZ5YyEX1kZbmtO6Zw1E6USDodE5F8szkcvs1h/VN/hf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=lPOKPeBL; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q7KnMW2713432;
	Thu, 26 Feb 2026 15:59:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=EH6WtJ
	3dEUptsGQIh9fbaYV+2C/P3bVvfgfRPFSQRH4=; b=lPOKPeBLkpvLD+4k7HZzXV
	Un1cRvySRkCG0yZPuVaKD3WTgSV3IWOKiJ/XLnyBCpdiOmQrJwKpY+R397CcfYBX
	jgoa1kS6WuUUf0baYWTj8FQWPTUF+YI43j0vnGvFIpwkEPCJSACxV3BpguuqE1hF
	hjXiQsGkNKtd8avjKzshfk7uS2ZxdwndvBxmojONw4ko7sWeC6QwM1v8B1Dlz40h
	rfh4zOp36xBrNr2/xNItx3AFRa7zscQWPvUn5TyAPyF/yicymAp2bbZW5O5iv427
	ySmO77RJseboA1++wX8aAhGsQIPGskhQQIaw63Rs1NejeW5QiEeyKd8Nm5DMvSvA
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf34cekcw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 15:59:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61QDPa7L030256;
	Thu, 26 Feb 2026 15:59:07 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfrhkmbwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 15:59:07 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QFx2Eo56688976
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 15:59:03 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E0B1D20043;
	Thu, 26 Feb 2026 15:59:02 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BCDE020040;
	Thu, 26 Feb 2026 15:59:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.52.223.175])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 26 Feb 2026 15:59:02 +0000 (GMT)
Date: Thu, 26 Feb 2026 16:59:01 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, borntraeger@linux.ibm.com,
        freimuth@linux.ibm.com, mjrosato@linux.ibm.com
Subject: Re: [PATCH 1/2] KVM: s390: Limit adapter indicator access to mapped
 page
Message-ID: <20260226165901.68438340@p-imbrenda>
In-Reply-To: <20260217090230.8116-2-frankja@linux.ibm.com>
References: <20260217090230.8116-1-frankja@linux.ibm.com>
	<20260217090230.8116-2-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDEzNiBTYWx0ZWRfXwolwzqkwN5IK
 1GdJCXVe7g5+TWSj1vSCRiljY3RUE2wXB9tpD2y8uooQdpQvUIq6/9RUvEURlnbgFDr/90fBoM7
 HMpUYD11XIggvfaNsPEvWGbYtmby1B/t9hSL1rrF+kqt+p9XbuiLKE+VWhkwfFh3qNLXKEbCMlZ
 ULRE8anCCIcwSE05FsWQcEQ09f/P0G/a71wXF2MM3/Jl0vhLTK8tCywBjlz7yCXBeZupUWXPsMP
 WrdoHO/G8bFtjNoI+oKVuKxpz7RFXNdj9q/BK/6GUd+VZN5Hw6V6xuihq5Nvn4F073R5szHZIzG
 c7+AP7PKG3vh/sH5bAmnF0SCIDwkE24MqpVHM4HOzpzU9MbC5xcS5vnw4BPbKWeiotqK/uOQCYT
 9xLgy3mnTtAY7hcIYD66otQ3kU5NHF+/BJyNzqT2j6Dh4xXV2vsNEyzFcuMcbbdanM7UpFQhtAw
 F0wfmC2pY+zExQh+JPg==
X-Proofpoint-ORIG-GUID: XRIAn-_6n7pMuhJl3Xl2ufoiAdlhoyOJ
X-Authority-Analysis: v=2.4 cv=F9lat6hN c=1 sm=1 tr=0 ts=69a06dcb cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=G87O5jEwh3kmkZiQiTUA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: XRIAn-_6n7pMuhJl3Xl2ufoiAdlhoyOJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-26_01,2026-02-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 phishscore=0 bulkscore=0 adultscore=0 spamscore=0
 clxscore=1015 suspectscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602260136
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_RHS_NOT_FQDN(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-72028-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: 8F76E1AA05C
X-Rspamd-Action: no action

On Tue, 17 Feb 2026 09:54:22 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> While we check the address for errors, we don't seem to check the bit
> offsets and since they are 32 and 64 bits a lot of memory can be
> reached indirectly via those offsets.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Fixes: 84223598778b ("KVM: s390: irq routing for adapter interrupts.")

Suggested-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Reported-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

:)

> ---
>  arch/s390/kvm/interrupt.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 1c2bb5cd7e12..cd4851e33a5b 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -2724,6 +2724,9 @@ static unsigned long get_ind_bit(__u64 addr, unsigned long bit_nr, bool swap)
>  
>  	bit = bit_nr + (addr % PAGE_SIZE) * 8;
>  
> +	/* kvm_set_routing_entry() should never allow this to happen */
> +	WARN_ON_ONCE(bit > (PAGE_SIZE * BITS_PER_BYTE - 1));
> +
>  	return swap ? (bit ^ (BITS_PER_LONG - 1)) : bit;
>  }
>  
> @@ -2852,6 +2855,7 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			  struct kvm_kernel_irq_routing_entry *e,
>  			  const struct kvm_irq_routing_entry *ue)
>  {
> +	const struct kvm_irq_routing_s390_adapter *adapter;
>  	u64 uaddr_s, uaddr_i;
>  	int idx;
>  
> @@ -2862,6 +2866,14 @@ int kvm_set_routing_entry(struct kvm *kvm,
>  			return -EINVAL;
>  		e->set = set_adapter_int;
>  
> +		adapter = &ue->u.adapter;
> +		if (adapter->summary_addr + BITS_TO_BYTES(adapter->summary_offset) >=
> +		    (adapter->summary_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +		if (adapter->ind_addr + BITS_TO_BYTES(adapter->ind_offset) >=
> +		    (adapter->ind_addr & PAGE_MASK) + PAGE_SIZE)
> +			return -EINVAL;
> +
>  		idx = srcu_read_lock(&kvm->srcu);
>  		uaddr_s = gpa_to_hva(kvm, ue->u.adapter.summary_addr);
>  		uaddr_i = gpa_to_hva(kvm, ue->u.adapter.ind_addr);


