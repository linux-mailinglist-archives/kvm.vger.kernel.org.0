Return-Path: <kvm+bounces-73293-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IB1eCi3MrmkDJAIAu9opvQ
	(envelope-from <kvm+bounces-73293-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:33:33 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C4CA6239CD7
	for <lists+kvm@lfdr.de>; Mon, 09 Mar 2026 14:33:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B6E5C3050212
	for <lists+kvm@lfdr.de>; Mon,  9 Mar 2026 13:31:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 943F635C19B;
	Mon,  9 Mar 2026 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="bxCZkHhV"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24E520B22;
	Mon,  9 Mar 2026 13:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773063104; cv=none; b=LWfFNpQbVvHYO4dDGpnczlgqH7oe9LpKdoQgJY5ZfS/ZWeCwcAwAHYRomaULQbB8TF2k1Ak9F5sNsUbeNPwBCkUG1uxtBB+6Hy55j7+6uu8AYJOohPI7oieLclLt2mKtL0l8xv0cPvpSrws8SIxA2IDnfAhAX9tbQ9ZsXf2m3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773063104; c=relaxed/simple;
	bh=6BNPmUyzSbSNypouwU29Ish4OEWhUbIEgWdZ+sIYifE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tIBS0lkthMG1vBa5of5SHCnhrcoHrFwCP55pTyNB3+2sLok6xGLXP9pvW6gGTwIDAxwmqinhHs2n5ZJqG3TXamQYwayZB2sEVXTgDhSK2LXMBClhgXPw5opze1qOK12s/FIPPaIAfTXx2GwZ0elF93py0Ug3ZhEAvMoDmnqu3OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=bxCZkHhV; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 628Jehhn1200596;
	Mon, 9 Mar 2026 13:31:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=hHqTiuRqBrT9mk7+wPR2kot50c6/t8
	Vgdo77Q8CvCq8=; b=bxCZkHhVWfaE1KN+igvdqZCHGPQbsB5CtmwD3yF3J+wn1o
	ptDzjiHnC4PGtbCUjSRjmGD2CLoVPb2s0aGr55+SB3Ra6nCbltGdQq913LvGmIpH
	UExuwZ/rm0/hLBCnwQVx7HBOwSMd5InMHtUIUSIotUPtx+DS8FxZxg+iBHq2HC2G
	OED5L5ot2fzOMUz3AgZekN5G2Ai0Mmsu0+wgSkWSF9b/CGYN+w9LOBZFMeL2La9d
	+83ODYyRAky7pRk7oJ7PfZ8sJg1A/lyfdvhZ5gAxeDy0eTGyDCdpzmZJALIMHzyT
	P+CKs//1+z+RD21OFpBNX9ccmqKSW4DGGoY6nWoA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4crcyw6pw5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 13:31:42 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 629B7lij015706;
	Mon, 9 Mar 2026 13:31:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cs121vtn5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Mar 2026 13:31:41 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 629DVbtX15466772
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Mar 2026 13:31:37 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 250ED2004B;
	Mon,  9 Mar 2026 13:31:37 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BA8DC20040;
	Mon,  9 Mar 2026 13:31:36 +0000 (GMT)
Received: from osiris (unknown [9.111.32.176])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  9 Mar 2026 13:31:36 +0000 (GMT)
Date: Mon, 9 Mar 2026 14:31:35 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Janosch Frank <frankja@linux.ibm.com>
Cc: kvm@vger.kernel.org, linux-s390@vger.kernel.org, imbrenda@linux.ibm.com,
        borntraeger@linux.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390/mm: add missing secure storage access fixups for
 donated memory
Message-ID: <20260309133135.30265H8b-hca@linux.ibm.com>
References: <20260309125311.31937-5-frankja@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260309125311.31937-5-frankja@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzA5MDEyMyBTYWx0ZWRfX+VXydZnQyvU6
 jXuCQom8XMiLEXsL1Ty7UZRNGQogDO4E2EDudzm8VvLkpQYzOyTZKRLs1sdy84T329U2AC5/8Py
 orgAvveaOTtAOgjptKHxXXDp8g3idL/kdFflHCD//5uFqtlEhCaWl4hKCstz/Nmu9nG3LF8gdaZ
 qJJlcuVF53AWEjlTDW7WuLoHujccSyrYtwFvewH4va9jyPVXGe8rHTV6Y7Tu/V9Gg2zf1aCl5Sc
 /i6mv1rnJxq0kkwPaki2EpUaSKBS1onhJj8h6xFpuDKdijFZam62MPA74vW1F3qeGE5N1d1w2sE
 AtibHUpEhqSZKyPT5TivMo9XffGXV4hkYXIfjy/XFHwxlszrJfX9Y4QO1PnlL8X3bh5Hu+Z3Xe+
 G5Kp0NHpdy9u+Bc0VUU/JSLKHANEZNfljpNBRvvqElhS1cfP58v2Wyo/j3eT/tZXc5KPq7e2fCV
 WOokqXGl2E9q8vcLGyQ==
X-Authority-Analysis: v=2.4 cv=QaVrf8bv c=1 sm=1 tr=0 ts=69aecbbe cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VnNF1IyMAAAA:8
 a=TrE2I5bt53qSS1KpehMA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: lJCR9h8VoHXjYYwetiKv_zc0gPVA2bJ5
X-Proofpoint-ORIG-GUID: lJCR9h8VoHXjYYwetiKv_zc0gPVA2bJ5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-09_03,2026-03-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 bulkscore=0 lowpriorityscore=0 priorityscore=1501 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2602130000 definitions=main-2603090123
X-Rspamd-Queue-Id: C4CA6239CD7
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-73293-lists,kvm=lfdr.de];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[ibm.com:+];
	MISSING_XM_UA(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[hca@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	NEURAL_HAM(-0.00)[-0.953];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Action: no action

On Mon, Mar 09, 2026 at 12:53:15PM +0000, Janosch Frank wrote:
> There are special cases where secure storage access exceptions happen
> in a kernel context for pages that don't have the PG_arch_1 bit
> set. That bit is set for non-exported guest secure storage (memory)
> but is absent on storage donated to the Ultravisor since the kernel
> isn't allowed to export donated pages.
> 
> Prior to this patch we would try to export the page by calling
> arch_make_folio_accessible() which would instantly return since the
> arch bit is absent signifying that the page was already exported and
> no further action is necessary. This leads to secure storage access
> exception loops which can never be resolved.
> 
> With this patch we unconditionally try to export and if that fails we
> fixup.
> 
> Fixes: 084ea4d611a3 ("s390/mm: add (non)secure page access exceptions handlers")
> Reported-by: Heiko Carstens <hca@linux.ibm.com>
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/mm/fault.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
> index a52aa7a99b6b..71bad4257aab 100644
> --- a/arch/s390/mm/fault.c
> +++ b/arch/s390/mm/fault.c
> @@ -441,10 +441,15 @@ void do_secure_storage_access(struct pt_regs *regs)
>  		folio = phys_to_folio(addr);
>  		if (unlikely(!folio_try_get(folio)))
>  			return;
> -		rc = arch_make_folio_accessible(folio);
> +		rc = uv_convert_from_secure(folio_to_phys(folio));
>  		folio_put(folio);
> +		/*
> +		 * There are some valid fixup types for kernel
> +		 * accesses to donated secure memory. zeropad is one
> +		 * of them.
> +		 */
>  		if (rc)
> -			BUG();
> +			return handle_fault_error(regs, 0);

This context doesn't hold mmlock, so it should be:

			return handle_fault_error_nolock(regs, 0);

And, yes, you can blame me, since I proposed the wrong call off-list.

