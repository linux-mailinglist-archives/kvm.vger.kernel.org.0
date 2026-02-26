Return-Path: <kvm+bounces-71957-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QBH6MSomoGk6fwQAu9opvQ
	(envelope-from <kvm+bounces-71957-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:53:30 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id AA06A1A4A0D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 11:53:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 444A73052B8D
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 10:52:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EF0313549;
	Thu, 26 Feb 2026 10:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="C56eflG1"
X-Original-To: kvm@vger.kernel.org
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65410314A9D;
	Thu, 26 Feb 2026 10:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772103147; cv=none; b=rBThRaxMHmldkHTeLPJz1/4hWweOOf4GJM+tqF0h6nRIrHpe6OM1ZjEximwlLUNcFvwJDDzp2MhLCLtPoQ/rCR+xfDWdhg4T+1rjY6TbzV/1YoBttrRLP6JHZHkHdWanhrQzOTP59+cB6eZdj+J97QVzAE0dF6/fz3/XqiwLMaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772103147; c=relaxed/simple;
	bh=mPAWysdOmD7VuvE81fi6zrmtct6dWFS9p5+F7H0xX6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tgmb4RzuQZrxz5UfZ6XDjPJhtX6h5rdIJI4JLG4wp1KV70lhSLecPcYlhlKwefkcUJJBQf1+DUTrUqDCzhWF/2NtkbgVVKVjrzfUqQHAIymbbiYYxMYBId7Cwy3qoCESeLMwYh7LA3CZFmUlTaPztXY+tBu+VsPwIuwmCx2bvuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=C56eflG1; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61Q1w8iL2962735;
	Thu, 26 Feb 2026 10:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:sender:subject:to; s=pp1; bh=Z2bEbfTCTOAjDi6vtSP3Ehu
	55WxkGqq9+GL96kkYwrg=; b=C56eflG1uwKSJRC3jcDPR3nc5EAoSRlljWssfXl
	Y8tyRwE6Ee2aFZqMD7jEzgZ/zYa4MqAwcBYkmayMXhp+mGZtlhWBmg5bw5I+zYbd
	Xa5X/ZqZoNWIgM5V85BSy0ZbfWaA74cMe3ViMEQZ7ZZr7OXSXFNvwrGgYEfr7HUV
	juKkngwJpWDIVwWOi6E9OO0gNEvIqbwkWKLDLpXmnu0kle8gBWuiFw17fPIhutAR
	cFsTU96vPhmUc+U74y8G5SCpEwZLRuqNia/qnEthqOQtLozFNrMSwHfc9cAl+5dU
	c5GOxvSDp00Rsyh6m5LA3Tk1NDE+wRQeJEA/5HEtVcWxeWw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cf24gn6fq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 10:52:25 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61Q7xidI027887;
	Thu, 26 Feb 2026 10:52:24 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4cfsr22hq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 26 Feb 2026 10:52:24 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61QAqKQr9109824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 26 Feb 2026 10:52:20 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 713F720043;
	Thu, 26 Feb 2026 10:52:20 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5A26920040;
	Thu, 26 Feb 2026 10:52:20 +0000 (GMT)
Received: from vela (unknown [9.87.150.251])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu, 26 Feb 2026 10:52:20 +0000 (GMT)
Received: from brueckner by vela with local (Exim 4.99.1)
	(envelope-from <brueckner@linux.ibm.com>)
	id 1vvYyh-00000000HAe-3Saq;
	Thu, 26 Feb 2026 11:52:19 +0100
Date: Thu, 26 Feb 2026 11:52:19 +0100
From: Hendrik Brueckner <brueckner@linux.ibm.com>
To: Christoph Schlameuss <schlameuss@linux.ibm.com>
Cc: linux-s390@vger.kernel.org,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
Subject: Re: [PATCH 2/4] s390/sclp: Detect ASTFLEIE 2 facility
Message-ID: <aaAl4-KefxaJ3sJu@linux.ibm.com>
References: <20260212-vsie-alter-stfle-fac-v1-0-d772be74a4da@linux.ibm.com>
 <20260212-vsie-alter-stfle-fac-v1-2-d772be74a4da@linux.ibm.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212-vsie-alter-stfle-fac-v1-2-d772be74a4da@linux.ibm.com>
Sender: Hendrik Brueckner <brueckner@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=TNRIilla c=1 sm=1 tr=0 ts=69a025e9 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VnNF1IyMAAAA:8
 a=I6XbcbOy5jN161PzrF0A:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: eL7MqYGrPwwAv5eXUIvlKjMsGeg9VH1o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI2MDA5NiBTYWx0ZWRfXzS1P9yFpyxj5
 JsKTT21sKkwUfVxN8DyZy0AFa85/WsIlEbnOLokrzplayJNx2Ddq+vPl5xiL8Vd4IidGySRHnCU
 DVNYKOWrRAt1sGeHft7qY6lwCjnRfKfsxi1FED5JhXGi/XCIYP5HZojb+rDEBNh3fcSwVmdfrEp
 IKxUi5hmVP2a0n4GsAjOC3MCTGwPJ/y3ZBNGO4rrthfvjn0SMzQm5e3GzknKn9vPsLUSz4fYFHc
 v86ggbXnR1iSQl/xcwyad78qlDrrdqRYNFNTVKM21qmJladfpu9yZ7QrUFQ8VJSe+2aDrCWGYlB
 wA7itDLmeP//00P0eaXeYjEc5RB5mCG/Jc+IOjoAKC5551KNMy6+ERChNVdNol0noTlzmUuyf6A
 ksMyvLWZG+R6FocExGetu9UqycNMLAmSIbtSwYpoQ5YllcQO0N7nz5HX5j5sp+GdDBvfxMSDC3C
 ZQ0pWcrOp9v1dfJnlvA==
X-Proofpoint-ORIG-GUID: eL7MqYGrPwwAv5eXUIvlKjMsGeg9VH1o
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-25_04,2026-02-25_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 adultscore=0 priorityscore=1501 impostorscore=0
 spamscore=0 clxscore=1015 bulkscore=0 lowpriorityscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602260096
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[ibm.com,none];
	R_DKIM_ALLOW(-0.20)[ibm.com:s=pp1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71957-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[ibm.com:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[brueckner@linux.ibm.com,kvm@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_TWELVE(0.00)[12];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[kvm];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AA06A1A4A0D
X-Rspamd-Action: no action

On Thu, Feb 12, 2026 at 10:24:56AM +0100, Christoph Schlameuss wrote:
> From: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> 
> Detect alternate STFLE interpretive execution facility 2.
> 
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> Signed-off-by: Christoph Schlameuss <schlameuss@linux.ibm.com>
> ---
>  arch/s390/include/asm/sclp.h   | 1 +
>  drivers/s390/char/sclp_early.c | 4 +++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 

Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>

