Return-Path: <kvm+bounces-70433-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGnJNIrDhWnAGAQAu9opvQ
	(envelope-from <kvm+bounces-70433-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:33:46 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 97169FCADA
	for <lists+kvm@lfdr.de>; Fri, 06 Feb 2026 11:33:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 07E113038F1D
	for <lists+kvm@lfdr.de>; Fri,  6 Feb 2026 10:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04B9A376BF6;
	Fri,  6 Feb 2026 10:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="N+owi2vS"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C78D360732;
	Fri,  6 Feb 2026 10:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770374015; cv=none; b=LiofojVTAxSAatbVBvWgk6aGBLuIbySa6IMnbkYycoNyyuEoFnpBVcEdQKQm1Q48DMpFUXLH3w/5G4R60yQ7ZACgUC+jIwKfV9ceuswhTsgoFXXcwhl2UNQI7r9PQ8OfBdmu0MCzYMIi61IYOwEG3NuMe2DaRYCnk6+iIpk5zDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770374015; c=relaxed/simple;
	bh=/eM4ghd2VLf872pOKR0YkQJNHFQCiGj3uYm/PHzMCn8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oLxNE1vJmNhXbF1ormjkMp2gPxFFUESS8NsMKQFJrJME9g4oyicrqz7ynQWI5AQAHxbpfOHbY23aahahHAKmaVEdsOnqnAZeHNgUh0DtxZg+I9/cjBS3jqE4OkTmxVh0uoMwB77ixxxhX0JGld+6p1lF6eiC5eDF7/qTLRtABx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=N+owi2vS; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 6164ueai004522;
	Fri, 6 Feb 2026 10:33:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=1p41yU
	0utLRgiOtAbcj/foA03AXbD0ro8dHIDV2yS2o=; b=N+owi2vSGVeu1JBUFFbwGH
	IS672tRO3uXIaz6EVYpJdeqEakV9VbUtqTDQePwMI3MKI0e6YuWYwiakqYTAgZ/8
	jfZrRt7KJfsTONHrW4z8bREFzVG6Id9yWyDMYO339ezXMLS3f+PJ3qjGOiHjkYw5
	rVmmT+6sgM4a1t7McVcvB7Fe38+QmoN8nR7DbksvWbF+ZIQVycDSL+YBVmEjl24/
	HryPrTvBkxxpPWs36xaj2/NxC2uSrW92lFRKDXMiywe0vmoIdB5VA9K2Pi3OmlmH
	0aM/NLaMNhLjsrQaFibTQHdFNtbDwIGF07IYZNdS5Ilq0zE30FV7Un1t8BvIWiwA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h7x5f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 10:33:26 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616AXQ5o011693;
	Fri, 6 Feb 2026 10:33:26 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185h7x59-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 10:33:26 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 6168PT89005933;
	Fri, 6 Feb 2026 10:33:25 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9jnfrb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 10:33:25 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616AXNgM52232524
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 10:33:23 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 907EB2004B;
	Fri,  6 Feb 2026 10:33:23 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A3F220043;
	Fri,  6 Feb 2026 10:33:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.36.153])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with SMTP;
	Fri,  6 Feb 2026 10:33:22 +0000 (GMT)
Date: Fri, 6 Feb 2026 11:33:19 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Heiko Carstens <hca@linux.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, Oliver Upton <oupton@kernel.org>,
        Sean
 Christopherson <seanjc@google.com>,
        Anup Patel <anup@brainfault.org>,
        Binbin Wu <binbin.wu@linux.intel.com>, Marc Zyngier <maz@kernel.org>,
        Jiaqi
 Yan <jiaqiyan@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: s390: add explicit padding to struct
 kvm_s390_keyop
Message-ID: <20260206113319.49a600f2@p-imbrenda>
In-Reply-To: <20260206091751.3973615-1-arnd@kernel.org>
References: <20260206091751.3973615-1-arnd@kernel.org>
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
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=6985c376 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=H89wNOMt5Vhrhf4zh90A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: ViOT9jI8OiAUdCB-UQ843pT_KR-3y4Nk
X-Proofpoint-ORIG-GUID: OwnPD8PrGShkfWHpCpWinvwFVk4RXQBt
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDA3MCBTYWx0ZWRfXz4KQpdSNmR2O
 pfDu9K/C/oX9FRewe1w61N2/YkTltW7FaNNOJIRkdOil5HDzsZL48VH3PWEWkR6bHjuEKKdpk4Q
 aswJlpZJ6YDgR/GUIbHpDnFXqMCTo5fxnBqt2mDL95s43sXwKxOScmiZFuVSbIwbelWGXmeIRUA
 Q+mn43KbAY8pfwJMexz7Des9hh4XzEPPQW4jysGhGurswLVM5AchnWCte8HzL2AhIp5WHbwRbDd
 oCsIOV9VFU8yZKOvPAbj7swVxqWmP7lqwz6koSJz7eVhz9cAheM1WDm3uc8dyZLyD4nA6zWZ10Z
 MIASCbMtNHbNxKkz9dHN5AUuoKGYwfIrHH18AV4RO2ioqGST4rS/FiQXeoiAxf3q8z1ilIY9roa
 uK5oZgJUoz24JcM/zx3xswlk+hLGPhXosEwfNlR8Pd96shXFTGYqq2e8uyyoe/aSWb1GAB2q0p+
 K07qquazuuvVIgY26hg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_03,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060070
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70433-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	DKIM_TRACE(0.00)[ibm.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_TWELVE(0.00)[13];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,arndb.de:email]
X-Rspamd-Queue-Id: 97169FCADA
X-Rspamd-Action: no action

On Fri,  6 Feb 2026 10:17:30 +0100
Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> The newly added structure causes a warning about implied padding:
> 
> ./usr/include/linux/kvm.h:1247:1: error: padding struct size to alignment boundary with 6 bytes [-Werror=padded]
> 
> The padding can lead to leaking kernel data and ABI incompatibilies
> when used on x86. Neither of these is a problem in this specific
> patch, but it's best to avoid it and use explicit padding fields
> in general.
> 
> Fixes: 0ee4ddc1647b ("KVM: s390: Storage key manipulation IOCTL")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> I have a long series to add annotations to all existing structures,
> but that will take a while. For now, I'm sending fixes when new
> instances show up in linux-next.
> ---
>  include/uapi/linux/kvm.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
> index a68b1741045c..1225fbd017e5 100644
> --- a/include/uapi/linux/kvm.h
> +++ b/include/uapi/linux/kvm.h
> @@ -1255,6 +1255,7 @@ struct kvm_s390_keyop {
>  	__u64 guest_addr;
>  	__u8  key;
>  	__u8  operation;
> +	__u8  pad[6];
>  };
>  
>  /*


