Return-Path: <kvm+bounces-485-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BF66A7E03C9
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 14:33:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E341E1C21084
	for <lists+kvm@lfdr.de>; Fri,  3 Nov 2023 13:33:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2F611863E;
	Fri,  3 Nov 2023 13:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="KpK0XXta"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF69182BD
	for <kvm@vger.kernel.org>; Fri,  3 Nov 2023 13:33:39 +0000 (UTC)
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AB713E;
	Fri,  3 Nov 2023 06:33:38 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3DBQhZ015640;
	Fri, 3 Nov 2023 13:33:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=1GxqP5srCmKGHZWSCieYIFgeXBhh3HwW+uIukvVG/OE=;
 b=KpK0XXta2Sl405n2DbeNYFPjU99p47xTxUHT5yyKrY5JK78zkGUXKik8As+NiZmKU3dp
 3BZQJdmBDho1GrMRL51TBoqcd5/FG3+m06nEVB+LPIcLMP4qDdh5Qx5qNx5Gyfykbu7w
 reSxt5jFY2wKxuoAEBItKtpdNKFwR0rSyoTddwhCHWMV97PfMbQq5cmb7u3mHfB9BRnM
 ih8ExEbHk3vaDPbU3wUaIdMyXJHRlGszAUqSMu8jfypN2CdDa7r+XQmPCywVvmmM1toM
 8wy0EIS13xU/Y37Wu9SgAnc64y+/9h68j9fNmPZuWiMPOf0smwZ/GQHJdAIwjUiHpNch kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u513r20n6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:37 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 3A3DBhHQ018374;
	Fri, 3 Nov 2023 13:33:37 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3u513r20m3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:37 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3A3CpNfo011536;
	Fri, 3 Nov 2023 13:33:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3u1e4me2e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 03 Nov 2023 13:33:35 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3A3DXWNY10486500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 3 Nov 2023 13:33:32 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 68C5E20043;
	Fri,  3 Nov 2023 13:33:32 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 35C8820040;
	Fri,  3 Nov 2023 13:33:32 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.66])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  3 Nov 2023 13:33:32 +0000 (GMT)
Date: Fri, 3 Nov 2023 14:33:24 +0100
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Nico Boehr <nrb@linux.ibm.com>
Cc: frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: sie: ensure guests are
 aligned to 2GB
Message-ID: <20231103143324.6e26e387@p-imbrenda>
In-Reply-To: <20231103064132.11358-3-nrb@linux.ibm.com>
References: <20231103064132.11358-1-nrb@linux.ibm.com>
	<20231103064132.11358-3-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -MLVYhdlTpF9e7AoYOoulSOvc5mYMYXc
X-Proofpoint-ORIG-GUID: wPVBxem3Cgxnt7apWNCbQFHdi7TC8b3F
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.987,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-11-03_12,2023-11-02_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 lowpriorityscore=0 adultscore=0 phishscore=0
 impostorscore=0 malwarescore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2310240000 definitions=main-2311030114

On Fri,  3 Nov 2023 07:35:47 +0100
Nico Boehr <nrb@linux.ibm.com> wrote:

[...]

> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index b44febdeaaac..bd907a0ffefa 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -15,6 +15,8 @@
>  #include <asm/page.h>
>  #include <libcflat.h>
>  #include <alloc_page.h>
> +#include <vmalloc.h>
> +#include <sclp.h>
>  
>  void sie_expect_validity(struct vm *vm)
>  {
> @@ -111,6 +113,46 @@ void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t guest_mem_len)
>  	vm->sblk->crycbd = (uint32_t)(uintptr_t)vm->crycb;
>  }
>  
> +/*

/**
  * sie_guest_alloc - Allocate memory [...]

> + * Allocate memory for a guest and map it in virtual address space such that
> + * it is properly aligned.
> + * @guest_size the desired size of the guest in bytes.

 * @guest_size: the desired [...]

> + */

let's try to use a consistent style for comments. in many places we use
the kerneldoc style -- let's stick to that

in the future we should pay more attention to the style, there are
several places where we have __almost__ kerneldoc style.

> +uint8_t *sie_guest_alloc(uint64_t guest_size)
> +{
> +	pgd_t *root;
> +	u8 *guest_phys, *guest_virt;
> +	static unsigned long guest_counter = 1;
> +	unsigned long i;

reverse Christmas tree, please

> +
> +	setup_vm();
> +	root = (pgd_t *)(stctg(1) & PAGE_MASK);
> +
> +	/*
> +	 * Start of guest memory in host virtual space needs to be aligned to
> +	 * 2GB for some environments. It also can't be at 2GB since the memory
> +	 * allocator stores its page_states metadata there.
> +	 * Thus we use the next multiple of 4GB after the end of physical
> +	 * mapping. This also leaves space after end of physical memory so the
> +	 * page immediately after physical memory is guaranteed not to be
> +	 * present.
> +	 */
> +	guest_virt = (uint8_t *)ALIGN(get_ram_size() + guest_counter * 4UL * SZ_1G, SZ_2G);
> +	guest_counter++;
> +
> +	guest_phys = alloc_pages(get_order(guest_size) - 12);
> +	/*
> +	 * Establish a new mapping of the guest memory so it can be 2GB aligned
> +	 * without actually requiring 2GB physical memory.
> +	 */
> +	for (i = 0; i <= guest_size; i += PAGE_SIZE) {

i < guest_size ?

> +		install_page(root, __pa(guest_phys + i), guest_virt + i);
> +	}
> +	memset(guest_virt, 0, guest_size);
> +
> +	return guest_virt;
> +}
> +
>  /* Frees the memory that was gathered on initialization */
>  void sie_guest_destroy(struct vm *vm)
>  {

[...]

