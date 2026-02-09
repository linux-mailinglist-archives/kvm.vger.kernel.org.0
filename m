Return-Path: <kvm+bounces-70620-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id COW6EXoWimlrGAAAu9opvQ
	(envelope-from <kvm+bounces-70620-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:16:42 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B50C0112FBD
	for <lists+kvm@lfdr.de>; Mon, 09 Feb 2026 18:16:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3ADAF302087A
	for <lists+kvm@lfdr.de>; Mon,  9 Feb 2026 17:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E161D385EEA;
	Mon,  9 Feb 2026 17:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qvLkadHt"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFCD43806AA;
	Mon,  9 Feb 2026 17:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770657379; cv=none; b=D81muHvdLl1TebBgGSLCSzgjl9jmd9QHJNTsgPOriHfx+jwIsq1tMh2amNYYJq5GWT0ZDhKGoCKbZ1N6i83PbTgoz4yuiFjdPoberBeHf65DFgNmtq1Xo93cFmgdzJq/33RbpXx6SVeiwh7FeSqzzkDEbdfQ7Nc4gBzlMBScmvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770657379; c=relaxed/simple;
	bh=S/3dy0LZvzdYg2cl05G3RhIvBpiAacPctOuBf3b6pXU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kPikyTVoWnCVgjnbe8u9bVy+s6lbrv2sSO1mqkbZUpg7tZrdWRRAbWdfyHc6pBsO0T24j7GilR6gXlwmu5r9HLhNNSF7Nwe5LNM7HxdFgFrygqjos9qRfz/oBYfyT9PUT2Quuh293WOVKcWfo9H+DS6S2R72e+LjjiaxmquJ324=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qvLkadHt; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 619ExF2U241452;
	Mon, 9 Feb 2026 17:16:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=Bj5D5t
	CmPYGSPf0QKj4iOIQS13T3lX2tNxirF5p+FYw=; b=qvLkadHtJ84XugAw4PkCi5
	sZBplVI6o0zNpsfYgOwnU3Hl9Ok9hCPLThY4y4zm4WLuKDq+Yqg5lfC0BWDyt2Yy
	fqc8gcRYgPA7ZFfVe2iT8Rprd89FSHjIEozuhvVvduaFC+jO2uVF46flhikbEDxV
	4/EtoUnuR80jzAzkS+MEjdmY+T6oHZNuNalY5iDDPTzO4K6aj3rTPfstx4ZkeG1E
	4TWGj0eFhin0vG1GTcPvSeIJrKEXnI0RbBrDA1bSozq4H3PLC4AHgsdgZI1jHpX9
	AtEP16Q6ejaC6PkQKtgOXvZxevAYwzNJ5YbmgLWnR4HYU1Iom1mhllP2XGyx2HRg
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696upwhq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:16:17 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 619EBXJJ019225;
	Mon, 9 Feb 2026 17:16:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxjwvb5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 09 Feb 2026 17:16:16 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 619HGCA234800062
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 9 Feb 2026 17:16:13 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DE0EA20043;
	Mon,  9 Feb 2026 17:16:12 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4AFEE20040;
	Mon,  9 Feb 2026 17:16:12 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.49.104])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with SMTP;
	Mon,  9 Feb 2026 17:16:12 +0000 (GMT)
Date: Mon, 9 Feb 2026 18:16:10 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Andreas
 Grapentin <gra@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
Subject: Re: [PATCH v1 1/1] KVM: s390: Increase permitted SE header size to
 1 MiB
Message-ID: <20260209181610.550b8ff0@p-imbrenda>
In-Reply-To: <20260209152925.578872-1-seiden@linux.ibm.com>
References: <20260209152925.578872-1-seiden@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA5MDE0MSBTYWx0ZWRfXyVgTMZVWs59l
 mKJk0mGhiuKhtd9ZSk+7XREZUJVsmJsmMbIpBLAEb9pjxq0mFZ6oXjnRgTE3iuwa9NO6gGkO6bw
 t43Rk9ZOSvcuCccm8BJLlXsdxu9X0AOkglVFmji6rXigKV7YbDHSTGyeqqdw8CaB15ZRcXn9s4O
 CT/O2QAoHYWdZr+tD6VszA7kYTcQOyCKN48HgYNZKBGVHbVLXI8bq3yOLne/aNGjXJzSQKMMc3Z
 tN47vv/+bQHNG5XcFo6sIiboeaTF7/tHGRb4AVVN0TWUcwHih231JTHcahIduPYm4Yt0/qqIaql
 yOCHGLTNDlVCbztC3XQc//eLI46e1SsM/HbjPOXB+PiwMMjIJzc0daoWlTucOYgZ4pXO/NEWuz7
 2ssYRnvELEIup/F0lJc86vkAVpLPBUE0cfIY3EdOZU0lqNIe392JUW+hmYAi3ylzRjSK3GDq6gP
 S3awOmY9Lme/q21yvLw==
X-Proofpoint-ORIG-GUID: -bdRg4JV-HfEOiun5W4b7CfV-1t40n8v
X-Proofpoint-GUID: -bdRg4JV-HfEOiun5W4b7CfV-1t40n8v
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698a1661 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=yz80Hj2ai0dgsENxVL4A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-09_01,2026-02-09_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602090141
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-70620-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	HAS_ORG_HEADER(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[imbrenda@linux.ibm.com,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	RCPT_COUNT_SEVEN(0.00)[8];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_SEVEN(0.00)[11]
X-Rspamd-Queue-Id: B50C0112FBD
X-Rspamd-Action: no action

On Mon,  9 Feb 2026 16:29:25 +0100
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Relax the maximum allowed Secure Execution (SE) header size from
> 8 KiB to 1 MiB. This allows individual secure guest images to run on a
> wider range of physical machines.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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


