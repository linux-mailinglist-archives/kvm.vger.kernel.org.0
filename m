Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 250663DA63B
	for <lists+kvm@lfdr.de>; Thu, 29 Jul 2021 16:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237225AbhG2OXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Jul 2021 10:23:18 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:8386 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237087AbhG2OXR (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Jul 2021 10:23:17 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16TELIsL191620;
        Thu, 29 Jul 2021 10:23:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MkxGArw8ZIa9XPx7rLjz9RvGnzom0zK0Gh/KR8Vh2hI=;
 b=dmTtLaAQJJYSTzFO8FOV5KXotoUlWTLG6LhKi3onfWZgijZ48rrKdCcU+pfiztsLw+sH
 EiAwTI/4F90KoTf6f+xAUgdKCUBbtA/N0JDPkMRYPGGVexkvcaAiSBRd3e/j1+eiK+va
 wGYkgK+Es32Wgcy7KnEKHlD5rqkAgm+ahjvI+Bm7vFAC3Dqoe83R5zg4npgBHrFuL+0t
 xRYGDy8PpPkr2Nlb5lWTqFEel73Hbg80X/FxXsPqnPqEt3yz5FiEZDbzkI2oTz1ZJbib
 cjdRRlnZdlxRJsD1WujSBcpvyAO/whOqiJcTsO5n6huyDhCp2irmkeY9RV/oZPWrQlgf Xw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3tw7qewk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:13 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16TEMOFj003770;
        Thu, 29 Jul 2021 10:23:13 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a3tw7qeve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 10:23:12 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16TEExCh016553;
        Thu, 29 Jul 2021 14:23:11 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3a235khrww-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 29 Jul 2021 14:23:11 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16TEKRqU27656632
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 14:20:27 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D2AD4A404D;
        Thu, 29 Jul 2021 14:23:08 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8A8E6A4051;
        Thu, 29 Jul 2021 14:23:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.151])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 29 Jul 2021 14:23:08 +0000 (GMT)
Date:   Thu, 29 Jul 2021 16:23:00 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/4] lib: s390x: sie: Move sie function
 into library
Message-ID: <20210729162300.72bb4af9@p-imbrenda>
In-Reply-To: <20210729134803.183358-5-frankja@linux.ibm.com>
References: <20210729134803.183358-1-frankja@linux.ibm.com>
        <20210729134803.183358-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8_h1RgwBxgUnVGHw1s-3yOC0jvX5Mdfw
X-Proofpoint-GUID: VmaCcuGtwHqfTXYNCHjp49web2psUJ3B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-29_10:2021-07-29,2021-07-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 adultscore=0 spamscore=0 impostorscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290089
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Jul 2021 13:48:03 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Time to deduplicate more code.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/sie.c  | 13 +++++++++++++
>  lib/s390x/sie.h  |  1 +
>  s390x/mvpg-sie.c | 13 -------------
>  s390x/sie.c      | 17 -----------------
>  4 files changed, 14 insertions(+), 30 deletions(-)
> 
> diff --git a/lib/s390x/sie.c b/lib/s390x/sie.c
> index ec0c4867..d971e825 100644
> --- a/lib/s390x/sie.c
> +++ b/lib/s390x/sie.c
> @@ -43,6 +43,19 @@ void sie_handle_validity(struct vm *vm)
>  	validity_expected = false;
>  }
>  
> +void sie(struct vm *vm)
> +{
> +	/* Reset icptcode so we don't trip over it below */
> +	vm->sblk->icptcode = 0;
> +
> +	while (vm->sblk->icptcode == 0) {
> +		sie64a(vm->sblk, &vm->save_area);
> +		sie_handle_validity(vm);
> +	}
> +	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> +	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> +}
> +
>  /* Initializes the struct vm members like the SIE control block. */
>  void sie_guest_create(struct vm *vm, uint64_t guest_mem, uint64_t
> guest_mem_len) {
> diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> index 946bd164..ca514ef3 100644
> --- a/lib/s390x/sie.h
> +++ b/lib/s390x/sie.h
> @@ -198,6 +198,7 @@ struct vm {
>  extern void sie_entry(void);
>  extern void sie_exit(void);
>  extern void sie64a(struct kvm_s390_sie_block *sblk, struct
> vm_save_area *save_area); +void sie(struct vm *vm);
>  void sie_expect_validity(void);
>  void sie_check_validity(uint16_t vir_exp);
>  void sie_handle_validity(struct vm *vm);
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 71ae4f88..70d2fcfa 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -32,19 +32,6 @@ extern const char
> _binary_s390x_snippets_c_mvpg_snippet_gbin_start[]; extern const char
> _binary_s390x_snippets_c_mvpg_snippet_gbin_end[]; int binary_size;
>  
> -static void sie(struct vm *vm)
> -{
> -	/* Reset icptcode so we don't trip over it below */
> -	vm->sblk->icptcode = 0;
> -
> -	while (vm->sblk->icptcode == 0) {
> -		sie64a(vm->sblk, &vm->save_area);
> -		sie_handle_validity(vm);
> -	}
> -	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> -	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> -}
> -
>  static void test_mvpg_pei(void)
>  {
>  	uint64_t **pei_dst = (uint64_t **)((uintptr_t) vm.sblk +
> 0xc0); diff --git a/s390x/sie.c b/s390x/sie.c
> index 9cb9b055..ed2c3263 100644
> --- a/s390x/sie.c
> +++ b/s390x/sie.c
> @@ -24,22 +24,6 @@ static u8 *guest;
>  static u8 *guest_instr;
>  static struct vm vm;
>  
> -
> -static void sie(struct vm *vm)
> -{
> -	while (vm->sblk->icptcode == 0) {
> -		sie64a(vm->sblk, &vm->save_area);
> -		sie_handle_validity(vm);
> -	}
> -	vm->save_area.guest.grs[14] = vm->sblk->gg14;
> -	vm->save_area.guest.grs[15] = vm->sblk->gg15;
> -}
> -
> -static void sblk_cleanup(struct vm *vm)
> -{
> -	vm->sblk->icptcode = 0;
> -}
> -
>  static void test_diag(u32 instr)
>  {
>  	vm.sblk->gpsw.addr = PAGE_SIZE * 2;
> @@ -51,7 +35,6 @@ static void test_diag(u32 instr)
>  	report(vm.sblk->icptcode == ICPT_INST &&
>  	       vm.sblk->ipa == instr >> 16 && vm.sblk->ipb == instr
> << 16, "Intercept data");
> -	sblk_cleanup(&vm);
>  }
>  
>  static struct {

