Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EDAD6EAE10
	for <lists+kvm@lfdr.de>; Fri, 21 Apr 2023 17:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbjDUPc2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Apr 2023 11:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232573AbjDUPc0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Apr 2023 11:32:26 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F1640D8;
        Fri, 21 Apr 2023 08:32:24 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33LFSlwg006248;
        Fri, 21 Apr 2023 15:32:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=DiC1uOSoqIalRhh8cK0eUsv6YesR7A6aq8qd37tdKKk=;
 b=TSHyzeI4V/0d1hl5b1bNZFQpugq9+ih2PraWVtNu3SEkuOtu3n7J7teynWT39Pg+lXLd
 csP8bXMJTYRD7O65Caogz4P599eNGpZ30Mun6qOTM0wQtLDTj/2YvyPCvzi53pUZX/R5
 E7Ec7//e/nEvFPf5tVX5Qvl+IZR0WoQ+hlIhSkGiT2N2S4LJ7DzS8f1vXScDAZNCoWYk
 gQZbCf79MZ//fPxnxcenRD+qrr5odl/P7TlEaSZlNuMuLhtxLGkSlsGEje5k/GAeg7o+
 /wRyraPqnTw25Pz08X3n8GLTpfNRAxA3jYfyczRJpz/O8gvA28qaLxaUwLyzZE0wiuq0 Gw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3w5j870j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:23 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33LFSj0J006132;
        Fri, 21 Apr 2023 15:32:23 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q3w5j86wh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:23 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33KLakhe002549;
        Fri, 21 Apr 2023 15:32:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3pyk6fm53k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Apr 2023 15:32:21 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33LFWH1C25625328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Apr 2023 15:32:17 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C674420040;
        Fri, 21 Apr 2023 15:32:17 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55BB42004E;
        Fri, 21 Apr 2023 15:32:17 +0000 (GMT)
Received: from p-imbrenda (unknown [9.171.17.52])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with SMTP;
        Fri, 21 Apr 2023 15:32:17 +0000 (GMT)
Date:   Fri, 21 Apr 2023 16:10:08 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com,
        nrb@linux.ibm.com, david@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 2/7] lib: s390x: uv: Add intercept
 data check library function
Message-ID: <20230421161008.529523bc@p-imbrenda>
In-Reply-To: <20230421113647.134536-3-frankja@linux.ibm.com>
References: <20230421113647.134536-1-frankja@linux.ibm.com>
        <20230421113647.134536-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sQV6jPESeBbN6L6Sxj75FXrRT20tbGaZ
X-Proofpoint-ORIG-GUID: vtWOSTTS4TftQXc_7dttsIJdXFG_XWKD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-21_08,2023-04-21_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 mlxlogscore=999 impostorscore=0 mlxscore=0
 malwarescore=0 phishscore=0 suspectscore=0 clxscore=1015 bulkscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304210132
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 21 Apr 2023 11:36:42 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> When working with guests it's essential to check the SIE intercept
> data for the correct values. Fortunately on PV guests these values are
> constants so we can create check functions which test for the
> constants.
> 
> While we're at it let's make pv-diags.c use this new function.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/pv_icptdata.h | 42 +++++++++++++++++++++++++++++++++++++++++
>  s390x/pv-diags.c        | 14 ++++++--------
>  2 files changed, 48 insertions(+), 8 deletions(-)
>  create mode 100644 lib/s390x/pv_icptdata.h
> 
> diff --git a/lib/s390x/pv_icptdata.h b/lib/s390x/pv_icptdata.h
> new file mode 100644
> index 00000000..4746117e
> --- /dev/null
> +++ b/lib/s390x/pv_icptdata.h
> @@ -0,0 +1,42 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +/*
> + * Commonly used checks for PV SIE intercept data
> + *
> + * Copyright IBM Corp. 2023
> + * Author: Janosch Frank <frankja@linux.ibm.com>
> + */
> +
> +#ifndef _S390X_PV_ICPTDATA_H_
> +#define _S390X_PV_ICPTDATA_H_
> +
> +#include <sie.h>
> +
> +/*
> + * Checks the diagnose instruction intercept data for consistency with
> + * the constants defined by the PV SIE architecture
> + *
> + * Supports: 0x44, 0x9c, 0x288, 0x308, 0x500
> + */
> +static bool pv_icptdata_check_diag(struct vm *vm, int diag)
> +{
> +	int icptcode;
> +
> +	switch (diag) {
> +	case 0x44:
> +	case 0x9c:
> +	case 0x288:
> +	case 0x308:
> +		icptcode = ICPT_PV_NOTIFY;
> +		break;
> +	case 0x500:
> +		icptcode = ICPT_PV_INSTR;
> +		break;
> +	default:
> +		/* If a new diag is introduced add it to the cases above! */
> +		assert(0);
> +	}
> +
> +	return vm->sblk->icptcode == icptcode && vm->sblk->ipa == 0x8302 &&
> +	       vm->sblk->ipb == 0x50000000 && vm->save_area.guest.grs[5] == diag;
> +}
> +#endif
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 5165937a..096ac61f 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -9,6 +9,7 @@
>   */
>  #include <libcflat.h>
>  #include <snippet.h>
> +#include <pv_icptdata.h>
>  #include <sie.h>
>  #include <sclp.h>
>  #include <asm/facility.h>
> @@ -31,8 +32,7 @@ static void test_diag_500(void)
>  			size_gbin, size_hdr, SNIPPET_UNPACK_OFF);
>  
>  	sie(&vm);
> -	report(vm.sblk->icptcode == ICPT_PV_INSTR && vm.sblk->ipa == 0x8302 &&
> -	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x500,
> +	report(pv_icptdata_check_diag(&vm, 0x500),
>  	       "intercept values");
>  	report(vm.save_area.guest.grs[1] == 1 &&
>  	       vm.save_area.guest.grs[2] == 2 &&
> @@ -45,9 +45,8 @@ static void test_diag_500(void)
>  	 */
>  	vm.sblk->iictl = IICTL_CODE_OPERAND;
>  	sie(&vm);
> -	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> -	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
> -	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
> +	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	       vm.save_area.guest.grs[0] == PGM_INT_CODE_OPERAND,
>  	       "operand exception");
>  
>  	/*
> @@ -58,9 +57,8 @@ static void test_diag_500(void)
>  	vm.sblk->iictl = IICTL_CODE_SPECIFICATION;
>  	/* Inject PGM, next exit should be 9c */
>  	sie(&vm);
> -	report(vm.sblk->icptcode == ICPT_PV_NOTIFY && vm.sblk->ipa == 0x8302 &&
> -	       vm.sblk->ipb == 0x50000000 && vm.save_area.guest.grs[5] == 0x9c
> -	       && vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
> +	report(pv_icptdata_check_diag(&vm, 0x9c) &&
> +	       vm.save_area.guest.grs[0] == PGM_INT_CODE_SPECIFICATION,
>  	       "specification exception");
>  
>  	/* No need for cleanup, just tear down the VM */

