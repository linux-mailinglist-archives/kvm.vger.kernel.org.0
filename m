Return-Path: <kvm+bounces-34828-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 89281A06443
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 19:22:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 38A061889886
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 18:22:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8F2C201269;
	Wed,  8 Jan 2025 18:21:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D6ozJTfw"
X-Original-To: kvm@vger.kernel.org
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C598B200BA2;
	Wed,  8 Jan 2025 18:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736360500; cv=none; b=g7VPZdQi7hobddJZrukUaahpwnE3yOYjUiynLlsSnsL5CruTxce3a+p8z9pbOfygOJhDHZiLJWbEcJeu3RMZW6/2q5k1vX0uJ0cBSi6Z1MrnBP7fFrZFqMN71T4XRq66g7xa+nIiYU8/UVkAxlNxchmnAndzxI8Jjszf9BZ7wG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736360500; c=relaxed/simple;
	bh=9l+kjI1T98FjMCX1sgv8vWzLkgqVgN5X+s3YH21yUOg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I1piaVl3v/VfV30d2rLtsV0RLfDsUZ67gDsDE3bc/VVZWHTu4xwyoYJwPCQO+i++7m27TkUCByJFoinbiQGixr8vHBq0h5uzDAtBsHG3q7ezUhzYf7ilmsn3pE8qna1ThN/r3iogubntTn7Cf4Aqni9lU9of/bLutnUBv3dnGs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=D6ozJTfw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 508ETGov027322;
	Wed, 8 Jan 2025 18:21:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=QA4heh
	X9HssXEkVVG9NIh2+E4O2OkR8TAAF5vdE6a2c=; b=D6ozJTfwte3K0sXvEI2hJV
	lp7cRboffmf1D7i7qtLytDAZjJ5lsryvAImmI7kXYAyR9qUoOztTWwz2f+rVN/Ti
	HgycCjCEDXBxjYo8D0X7XEbFa4kkU+WKFLzSglYPqJrKy3UHNPKXlusMiSz7SOn7
	OWx1W43lY9e2DbHYeQvWrH03JRzkx8SexmVXe9o6b3sIwR9rIB/jySjNgzWlLjuW
	U1Sv90cTWRXR/JT18KpKNojFO6AMeXEesGWL+57nteEOi36dAyc3/FiIbtnQfglv
	9ePwSG8xiZPzGM2v/QiQQIRbhcfXGkVJqz5UK5xhhvLEybif/vMWLChCu4Ru9Ftw
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 441edj4hjk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:21:34 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 508H1cBE016669;
	Wed, 8 Jan 2025 18:21:33 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43ygtm116e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Jan 2025 18:21:33 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 508ILTjk55837182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Jan 2025 18:21:29 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D54E2004B;
	Wed,  8 Jan 2025 18:21:29 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2EC7A20040;
	Wed,  8 Jan 2025 18:21:29 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Jan 2025 18:21:29 +0000 (GMT)
Date: Wed, 8 Jan 2025 19:17:21 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Christian Borntraeger
 <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        "Matthew Wilcox (Oracle)"
 <willy@infradead.org>
Subject: Re: [PATCH v1 4/4] KVM: s390: vsie: stop using "struct page" for
 vsie page
Message-ID: <20250108191721.4d842c4a@p-imbrenda>
In-Reply-To: <20250107154344.1003072-5-david@redhat.com>
References: <20250107154344.1003072-1-david@redhat.com>
	<20250107154344.1003072-5-david@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: BsPmEVPKVixIV5rNJoVG2dX66TWSZxzm
X-Proofpoint-ORIG-GUID: BsPmEVPKVixIV5rNJoVG2dX66TWSZxzm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 mlxlogscore=923 phishscore=0 malwarescore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 adultscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2501080148

On Tue,  7 Jan 2025 16:43:44 +0100
David Hildenbrand <david@redhat.com> wrote:

[...]

> @@ -1438,7 +1432,8 @@ static struct vsie_page *get_vsie_page(struct kvm *kvm, unsigned long addr)
>  	vsie_page->scb_gpa = ULONG_MAX;
>  
>  	/* Double use of the same address or allocation failure. */
> -	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9, page)) {
> +	if (radix_tree_insert(&kvm->arch.vsie.addr_to_page, addr >> 9,
> +			      vsie_page)) {

this is less than 100 columns, could have staid on one line

>  		put_vsie_page(vsie_page);
>  		mutex_unlock(&kvm->arch.vsie.mutex);
>  		return NULL;
> @@ -1519,20 +1514,18 @@ void kvm_s390_vsie_init(struct kvm *kvm)
>  void kvm_s390_vsie_destroy(struct kvm *kvm)
>  {
>  	struct vsie_page *vsie_page;
> -	struct page *page;
>  	int i;
>  
>  	mutex_lock(&kvm->arch.vsie.mutex);
>  	for (i = 0; i < kvm->arch.vsie.page_count; i++) {
> -		page = kvm->arch.vsie.pages[i];
> +		vsie_page = kvm->arch.vsie.pages[i];
>  		kvm->arch.vsie.pages[i] = NULL;
> -		vsie_page = page_to_virt(page);
>  		release_gmap_shadow(vsie_page);
>  		/* free the radix tree entry */
>  		if (vsie_page->scb_gpa != ULONG_MAX)
>  			radix_tree_delete(&kvm->arch.vsie.addr_to_page,
>  					  vsie_page->scb_gpa >> 9);
> -		__free_page(page);
> +		free_page((unsigned long)vsie_page);
>  	}
>  	kvm->arch.vsie.page_count = 0;
>  	mutex_unlock(&kvm->arch.vsie.mutex);


