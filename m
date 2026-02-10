Return-Path: <kvm+bounces-70725-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qKkFEug7i2neRgAAu9opvQ
	(envelope-from <kvm+bounces-70725-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:08:40 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B8BD11BB99
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 15:08:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 6A42630428B2
	for <lists+kvm@lfdr.de>; Tue, 10 Feb 2026 14:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A93E366DA8;
	Tue, 10 Feb 2026 14:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="EKeKlmjU"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AF41B0439;
	Tue, 10 Feb 2026 14:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770732469; cv=none; b=ilQt61DAeZ4yQuARVEMiSs9yLnhAadQZMAItQCWzGdnFcLNWdFGAEPcQN44VLd9m4cq7frXmsMu8XXR/uZ6tDRG3PFXXvZDPsIDeZQDWDi9LTTz9qmMyO2Gb1cKpIJICrRDKELy1xN6CZe8zmAdW0CMjzpWvdDAwTyU2vMhOHWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770732469; c=relaxed/simple;
	bh=F8iuOjkyX7jHZzstiyL4Uhmt4AwUVMu6fTe4EIdjJG4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k0EDgf35z/G26odJUcs9iPl3SOWA2aXDgMfWx3uTbcNXXpQssnj4xz+4CNBOQdom+Q2j0Afvhj6PkZTmJjwtr24KE9J6zLeBt0EA1TeRC47sNqTAf+BXP9Qt9LyMA69STG7GZ3E1q1pPbuhScPSikI6piHbnB0KE99aQ5vMQyMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=EKeKlmjU; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61A9aOOJ205004;
	Tue, 10 Feb 2026 14:07:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:sender:subject:to; s=pp1; bh=Yc60JAGw94y/yuGFA4Xnxdl
	WAI3EoSHMi0uznrK6hdc=; b=EKeKlmjUPtNV5mrhxr6LuM3C0WPnWbkcdECq9g/
	BJ6oZxudY+4o/58vqQl81MFD6U3rIhal7l/xb390P3bFrofBGpzpIy0GYbaP7fO3
	jFi7qSPTfwcKjyPa5VHi/+c3AsiLu53tMDjfjf/4jguSC7DIkM/KDg/IRckdW28f
	zCZeUowiiLTDFDYF67hI6Sc7Uo/43MG63BnUNWj8IItPND/fHizqFhKRz835yTJl
	KoP3fJjEIOhdIDkgNsGeu7Guge+MnyLvb9BZaLYqZXKnGoLGznh4ncA7p/SAHhGl
	0F4FFAGB44oFlzomPnbqwPBtAh3KsDOJXIEUgCREi3TamqA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v2cq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 14:07:46 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61ABYT9s019258;
	Tue, 10 Feb 2026 14:07:46 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk1cye-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Feb 2026 14:07:46 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61AE7gpC61669866
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Feb 2026 14:07:42 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 775822004B;
	Tue, 10 Feb 2026 14:07:42 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5EE7720043;
	Tue, 10 Feb 2026 14:07:42 +0000 (GMT)
Received: from vela (unknown [9.111.81.59])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 10 Feb 2026 14:07:42 +0000 (GMT)
Received: from brueckner by vela with local (Exim 4.99.1)
	(envelope-from <brueckner@linux.ibm.com>)
	id 1vpoOz-00000000EIn-3VBs;
	Tue, 10 Feb 2026 15:07:41 +0100
Date: Tue, 10 Feb 2026 15:07:41 +0100
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Andreas Grapentin <gra@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Increase permitted SE header size to 1
 MiB
Message-ID: <aYs7raKCpf0YG4GO@linux.ibm.com>
References: <20260209152925.578872-1-seiden@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209152925.578872-1-seiden@linux.ibm.com>
Sender: Hendrik Brueckner <brueckner@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: SvxLixL66tTjFGzIUw25Nzy1jdS-SOYb
X-Proofpoint-ORIG-GUID: SvxLixL66tTjFGzIUw25Nzy1jdS-SOYb
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698b3bb2 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=ycHnYxuuFyCDzNjIPycA:9 a=CjuIK1q_8ugA:10 a=ZXulRonScM0A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjEwMDExNiBTYWx0ZWRfX7C5TJzEF5I7k
 znJ3OArLcznuxQOPT0fjR23K4obggAfJ1vktrsoZwiSXtLHgjjr5QRfZvlAd4Wbjp5gFVaTuotr
 XfPN3WjOdYTWwFApDZSUMtwh6a//TilJ9Dbo/tP97t3FX1WctETFhnqA/oBxLCfrl1SJH57K65A
 og+QbYEWU/htZuRLstq/jX5WRJImmgAPRwXZUTs9gOmntg2gQRxCKxCXR5OgAQi56phR/iKKGEO
 P1OznwYVkbqAPlO0bShFoEm2UHr4s9HScgPIC18ZCZEieWTI3IJcaCrMnqjsUZTZWnWHjpiCdr+
 BBJNREuuPYUW+7lz4R4rGRixMVRgK2pnw8FonSQjyRvwsx4PdZDBQzz3DBeURtUhjEkUvY5TgIj
 SURCnxA9K3MybrQ2EVrJM05haCKMBasMWR1VxR2k3yrRalqROZ06awzdS1UeiohfBXY6XZ4LQ8H
 w02eaVYuev/eGtZzU4Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-10_01,2026-02-10_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1011 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602100116
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
	DKIM_TRACE(0.00)[ibm.com:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-70725-lists,kvm=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brueckner@linux.ibm.com,kvm@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_COUNT_TWELVE(0.00)[12];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.ibm.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9B8BD11BB99
X-Rspamd-Action: no action

On Mon, Feb 09, 2026 at 04:29:25PM +0100, Steffen Eiden wrote:
> Relax the maximum allowed Secure Execution (SE) header size from
> 8 KiB to 1 MiB. This allows individual secure guest images to run on a
> wider range of physical machines.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  arch/s390/kvm/kvm-s390.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 56a50524b3ee..3428a8d427b2 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -2744,9 +2744,9 @@ static int kvm_s390_handle_pv(struct kvm *kvm, struct kvm_pv_cmd *cmd)
>  		if (copy_from_user(&parms, argp, sizeof(parms)))
>  			break;
>  
> -		/* Currently restricted to 8KB */
> +		/* Currently restricted to 1MiB */
>  		r = -EINVAL;
> -		if (parms.length > PAGE_SIZE * 2)
> +		if (parms.length > SZ_1M)
>  			break;
>  
>  		r = -ENOMEM;

Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>

