Return-Path: <kvm+bounces-71845-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aHBdCykkn2mPZAQAu9opvQ
	(envelope-from <kvm+bounces-71845-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:32:41 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE8B19AB47
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 17:32:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5F1E9301D30E
	for <lists+kvm@lfdr.de>; Wed, 25 Feb 2026 16:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C97773D5233;
	Wed, 25 Feb 2026 16:27:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sF3bpwcy"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA35A3D6462;
	Wed, 25 Feb 2026 16:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772036836; cv=none; b=SBIv0NMAISntbonajXcOBDkIH/CRMKcxXhLEkorSm41QI2lAonwsZCf5WeRUsHASTfmb5Qk1M6PT9H/ihwCJYALZOqi1IYeUV7rcTl1IoUwGXC4MluQMHoqH7r7ukxCLfvxszPUir3E7EvFB0T5atFgdLciNs5WxyQYj8Wvevm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772036836; c=relaxed/simple;
	bh=KkYVBO/6As3T5y3cUNvo3NyMGXxBzv7EPF5rfPY0P6s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZS7vPYc6oOoE+LG/A/D595Uyaor5ThvKezAVDaM0poYC6BF9oPqbThXhJKgMqiUoyfBu+Cju9LAoxWVROQoDrGNLUjndCT6rmTo5KJ770lV8yi78SyAY1eX22yLAvK7/73gKH+dKjGu/RptAd8hrh3L+PBWigspajyCabKUXKYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sF3bpwcy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61PEijmV3015564;
	Wed, 25 Feb 2026 16:27:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=nRrPhj
	U47o4X91zItvqVwyVs6H8F1wG8S+K4S7XJ6sQ=; b=sF3bpwcyHIvHEcteBsjQW+
	ETCSXuud4bF+sQEzKX7VvMCaRSTXi1mLf2227qbECdKZIue5Z4bHWpXCb6VV7CK2
	bHENLLJ7lEhuLPcL/k/DzUiSrwXjWwxELIKJG8+ZY6IUcwr+kIErjqlYaeTxmF/l
	BTfZ/rlHo705mQo9ECXI1Yljrd3pTqNaDCIak4lZ7WhEITvHART5PXp9u3/ch1v4
	L19aBGBhg585u3nN7dKP+/5FoNkUTL0h/v9LChyfKpUyc/XnVE/lwpqKWG1ti5k+
	RauP/Q9wtrPm8U4K67yqcxn0yspz2My9wETcV0tehA83Oevwe4zavGmlgc2pimXg
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf4bs0c3k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 16:27:10 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61PCZ3Xt001659;
	Wed, 25 Feb 2026 16:27:09 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4cfr1n63pv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Feb 2026 16:27:09 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61PGR56845744538
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Feb 2026 16:27:06 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D9CA02004B;
	Wed, 25 Feb 2026 16:27:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C81420040;
	Wed, 25 Feb 2026 16:27:05 +0000 (GMT)
Received: from [9.57.233.77] (unknown [9.57.233.77])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Feb 2026 16:27:04 +0000 (GMT)
Message-ID: <219c1772-f8ba-43bc-88ef-4c79b112cbee@linux.ibm.com>
Date: Wed, 25 Feb 2026 11:27:04 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] KVM: s390: only deliver service interrupt with payload
To: Eric Farman <farman@linux.ibm.com>, Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20260225152013.1108842-1-farman@linux.ibm.com>
Content-Language: en-US
From: Christian Borntraeger <borntraeger@linux.ibm.com>
In-Reply-To: <20260225152013.1108842-1-farman@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _WLH0TnptSEbGWAn4btYmhpDKFz5Yn6y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI1MDE1NSBTYWx0ZWRfX+YadXMYIM80o
 zoc2nT7UaHmdkgdBqkiHYfYWkrHSac0EKv4bslsIzgMbaK63TnZcBFHwXcYL5JzmFST1m+Fn62u
 kshU+8NjR8Rd4ayc3B28HT9irDlAMq65yR+1bifmIy2F7hcdYEAl3ZL0Lu+YrTIw8UZPJCFt/Va
 cadwWyqHimXkf50OtvxQxj5puOa+N7WIXgUdR79A0bNpDUbpfYiQ0/Qz3V2Wt/U9Z47alu6DQtc
 P/FN89M8YZUmqqMxH5WZcVNsz/f5DAcIW8wjxvq1Uk8mPub4kPfd4+MiVuTpEaWrEHD1G8QVkSF
 GM33Xx3LKcjJK6ChuImjznqQTV71P9Xq6JddZRcxROWRS7Lqic78N7n9S4E270KYTQtIg5CbQWP
 Td4qvU/+VgBMjhUCmDjQMJKZ+QjgoQ9weWugCkS9t8ZKKiU9eja8fcQmVntfmqUIuYo430afM2S
 FY4Z6CWaJN3Eb4ms58g==
X-Authority-Analysis: v=2.4 cv=eNceTXp1 c=1 sm=1 tr=0 ts=699f22de cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=gOxyaswGBdB1klpJvm0A:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: _WLH0TnptSEbGWAn4btYmhpDKFz5Yn6y
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_02,2026-02-25_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 phishscore=0 suspectscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 malwarescore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602250155
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TO_DN_SOME(0.00)[];
	TAGGED_FROM(0.00)[bounces-71845-lists,kvm=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[borntraeger@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	PRECEDENCE_BULK(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: BDE8B19AB47
X-Rspamd-Action: no action

Am 25.02.26 um 10:20 schrieb Eric Farman:
> Routine __inject_service() may set both the SERVICE and SERVICE_EV
> pending bits, and in the case of a pure service event the corresponding
> trip through __deliver_service_ev() will clear the SERVICE_EV bit only.
> This necessitates an additional trip through __deliver_service() for
> the other pending interrupt bit, however it is possible that the
> external interrupt parameters are zero and there is nothing to be
> delivered to the guest.
> 
> To avoid sending empty data to the guest, let's only write out the SCLP
> data when there is something for the guest to do, otherwise bail out.
> 
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Acked-by: Christian Borntraeger <borntraeger@linux.ibm.com>


> ---
>   arch/s390/kvm/interrupt.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/arch/s390/kvm/interrupt.c b/arch/s390/kvm/interrupt.c
> index 18932a65ca68..dd0413387a9e 100644
> --- a/arch/s390/kvm/interrupt.c
> +++ b/arch/s390/kvm/interrupt.c
> @@ -956,6 +956,9 @@ static int __must_check __deliver_service(struct kvm_vcpu *vcpu)
>   		set_bit(IRQ_PEND_EXT_SERVICE, &fi->masked_irqs);
>   	spin_unlock(&fi->lock);
>   
> +	if (!ext.ext_params)
> +		return 0;
> +
>   	VCPU_EVENT(vcpu, 4, "deliver: sclp parameter 0x%x",
>   		   ext.ext_params);
>   	vcpu->stat.deliver_service_signal++;


