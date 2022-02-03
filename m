Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3914A8A41
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352939AbiBCRiN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:38:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:48806 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1352920AbiBCRiL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 12:38:11 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213GcsMd016931;
        Thu, 3 Feb 2022 17:38:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5oZx6YFpn3eKxZhOkd0TDEEJ4+ZH15Mpmh+5emYAjdk=;
 b=dm6td5QNoDak1HaQ2raFqPQD83BeHGtfMqaTPRV8VLsslxX8FtvwxkiYBMwzass5vzPL
 wncX3HH+F2vD4h5du2XHlIR+7LkY9tyt9IvgdAqKDwtPUHw5/JqoGbChKl1vXwud7L6H
 6cxyBnnN8yyZW5cjJR3SdiHJVyAc3KkNqVZi/EppwPxEbGr0Ob4vUrCsQwLqCFd+VTl4
 +3FYbQL6qVi9jwXbvDM0SkZbAuPmK66umS6X+G/X3Amf1hcUwRWZ1TcnUfRuy5a0nZ0m
 81S7UARqYk6pdngfTf/lrSn1TMe3aruYD/yWwbtI0olLE8RFo56M02cP3kdagbMHh+uy xA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrtk6v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:10 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213HXcu7028136;
        Thu, 3 Feb 2022 17:38:10 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dywrrtk61-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:10 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213HX9g9002061;
        Thu, 3 Feb 2022 17:38:08 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3dvw79xn65-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:08 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213Hc4JW39649786
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 17:38:04 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C4CE5A406D;
        Thu,  3 Feb 2022 17:38:04 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 614ABA4051;
        Thu,  3 Feb 2022 17:38:04 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 17:38:04 +0000 (GMT)
Date:   Thu, 3 Feb 2022 18:37:51 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 4/4] s390x: uv-guest: Add attestation
 tests
Message-ID: <20220203183751.21c402ac@p-imbrenda>
In-Reply-To: <20220203091935.2716-5-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
        <20220203091935.2716-5-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yk3GWL8KXi0c1oLhrhwhD215qW2SoSGT
X-Proofpoint-GUID: aje3MBsa-f1dyQ6i9DoF9jap7kdV09NB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 clxscore=1015 impostorscore=0 adultscore=0 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Feb 2022 09:19:35 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Adds several tests to verify correct error paths of attestation.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>  lib/s390x/asm/uv.h |   5 +-
>  s390x/uv-guest.c   | 174 ++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 177 insertions(+), 2 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 7afbcffd..7fe55052 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -108,7 +108,10 @@ struct uv_cb_qui {
>  	u8  reserved88[158 - 136];	/* 0x0088 */
>  	uint16_t max_guest_cpus;	/* 0x009e */
>  	u64 uv_feature_indications;	/* 0x00a0 */
> -	u8  reserveda8[200 - 168];	/* 0x00a8 */
> +	u8  reserveda8[224 - 168];	/* 0x00a8 */

please use uint*_t types everywhere. as you notice, we are already
inconsistent, so let's just use the new ones for all new code

> +	u64 supported_att_hdr_versions;	/* 0x00e0 */
> +	u64 supported_paf;		/* 0x00e8 */
> +	u8  reservedf0[256 - 240];	/* 0x00f0 */
>  }  __attribute__((packed))  __attribute__((aligned(8)));
>  
>  struct uv_cb_cgc {
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 97ae4687..3fca9d21 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -2,10 +2,11 @@
>  /*
>   * Guest Ultravisor Call tests
>   *
> - * Copyright (c) 2020 IBM Corp
> + * Copyright IBM Corp. 2020, 2022
>   *
>   * Authors:
>   *  Janosch Frank <frankja@linux.ibm.com>
> + *  Steffen Eiden <seiden@linux.ibm.com>
>   */
>  
>  #include <libcflat.h>
> @@ -53,6 +54,15 @@ static void test_priv(void)
>  	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
>  	report_prefix_pop();
>  
> +	report_prefix_push("attest");
> +	uvcb.cmd = UVC_CMD_ATTESTATION;
> +	uvcb.len = sizeof(struct uv_cb_attest);
> +	expect_pgm_int();
> +	enter_pstate();
> +	uv_call_once(0, (u64)&uvcb);

please use uint*_t types :)

> +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> +	report_prefix_pop();
> +
>  	report_prefix_pop();
>  }
>  
> @@ -111,7 +121,168 @@ static void test_sharing(void)
>  	cc = uv_call(0, (u64)&uvcb);
>  	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
>  	report_prefix_pop();
> +}
> +
> +#define ARCB_VERSION_1 0x0100
> +#define ARCB_HMAC_SHA512 1
> +/* arcb with one key slot and no nonce */
> +struct uv_arcb_v1 {
> +	uint64_t	reserved0;		/* 0x0000 */
> +	uint32_t	req_ver;		/* 0x0008 */
> +	uint32_t	req_len;		/* 0x000c */
> +	uint8_t		iv[12];			/*
> 0x0010 */
> +	uint32_t	reserved1c;		/* 0x001c */
> +	uint8_t		reserved20[7];		/*
> 0x0020 */
> +	uint8_t		nks;			/* 0x0027
> */
> +	uint32_t	reserved28;		/* 0x0028 */
> +	uint32_t	sea;			/* 0x002c */
> +	uint64_t	plaint_att_flags;	/* 0x0030 */
> +	uint32_t	meas_alg_id;		/* 0x0038 */
> +	uint32_t	reserved3c;		/* 0x003c */
> +	uint8_t		cpk[160];		/* 0x0040 */
> +	uint8_t		key_slot[80];		/*
> 0x00e0 */
> +	uint8_t		meas_key[64];		/*
> 0x0130 */
> +	uint8_t		tag[16];		/* 0x0170 */
> +} __attribute__((packed));
> +
> +static void test_attest_v1(u64 supported_paf)
> +{
> +	struct uv_cb_attest uvcb = {
> +		.header.cmd = UVC_CMD_ATTESTATION,
> +		.header.len = sizeof(uvcb),
> +	};
> +	struct uv_arcb_v1 *arcb = (void *)page;
> +	uint64_t measurement = page + sizeof(*arcb);
> +	size_t measurement_size = 64;
> +	uint64_t additional = measurement + measurement_size;
> +	size_t additional_size = 32;

I wonder it it would be easier to create a struct with an embedded
struct uv_arcb_v1 to represent the measurement and the additional data.
that way you won't need to do all these hacky calculations and magic
numbers, you could just do something like 

measurement = (uint64_t)&arcb_extended.measurement;

which, while longer, is probably easier to understand.

and the sizes maybe could become #defines

> +	uint64_t plaint_att_flags = 1ULL << 61;
> +	int cc;
> +
> +	memset((void *) page, 0, PAGE_SIZE);

please no extra space between the ) and the p

> +
> +	/* create a minimal arcb/uvcb such that FW has everything to start unsealing the request. */
> +	arcb->req_ver = ARCB_VERSION_1;
> +	arcb->req_len = sizeof(*arcb);
> +	arcb->nks = 1;
> +	arcb->sea = sizeof(arcb->meas_key);
> +	arcb->plaint_att_flags = plaint_att_flags;
> +	arcb->meas_alg_id = ARCB_HMAC_SHA512;
> +	uvcb.arcb_addr = page;
> +	uvcb.measurement_address = measurement;
> +	uvcb.measurement_length = measurement_size;
> +	uvcb.add_data_address = additional;
> +	uvcb.add_data_length = additional_size;

are you using those variables somewhere else? could you just assign
directly to the uvcb instead?

> +
> +	uvcb.continuation_token = 0xff;
> +	cc = uv_call(0, (u64)&uvcb);

please use uint*_t types everywhere

> +	report(cc == 1 && uvcb.header.rc == 0x0101, "invalid continuation token");
> +	uvcb.continuation_token = 0;
> +
> +	uvcb.user_data_length = sizeof(uvcb.user_data) + 1;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0102, "invalid user data size");
> +	uvcb.user_data_length = 0;
> +
> +	uvcb.arcb_addr = 0;

is 0 really not a valid address?

and what about an address outside memory?

> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0103, "invalid address arcb");
> +	uvcb.arcb_addr = page;
> +
> +	/* 0104 - 0105 need an unseal-able request */
> +
> +	/* version 0000 is an illegal version number */
> +	arcb->req_ver = 0x0000;

just 0 is ok

> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0106, "unsupported version");
> +	arcb->req_ver = ARCB_VERSION_1;
> +
> +	arcb->req_len += 1;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0107, "invalid arcb size 1");
> +	arcb->req_len -= 1;
> +	arcb->nks = 2;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0107, "invalid arcb size 2");

you say invalid arcb size, but you are changing the number of nks. I
think I understand why, but maybe it's better to add a comment to
explain what you are doing.

> +	arcb->nks = 1;
> +
> +	arcb->nks = 0;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0108, "invalid num key slots");
> +	arcb->nks = 1;
> +
> +	/* possible valid size (when using nonce). However, req_len too small to host a nonce */
> +	arcb->sea = 80;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0109, "invalid encrypted size 1");
> +	arcb->sea = 17;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0109, "invalid encrypted size 2");
> +	arcb->sea = 64;
> +
> +	arcb->plaint_att_flags = supported_paf ^ ((u64) -1);

so you are trying to flip the lower 32 bits?
why not just supported_paf ^ ~0 ?

although a more readable form would probably be
supported_paf ^ GENMASK_ULL(31, 0)

> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x010a, "invalid flag");
> +	arcb->plaint_att_flags = plaint_att_flags;
> +
> +	/* reserved value */
> +	arcb->meas_alg_id = 0;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x010b, "invalid measurement algorithm");
> +	arcb->meas_alg_id = ARCB_HMAC_SHA512;
> +
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x010c, "unable unseal");
>  
> +	uvcb.measurement_length = 0;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x010d, "invalid measurement size");
> +	uvcb.measurement_length = measurement_size;
> +
> +	uvcb.add_data_length = 0;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x010e, "invalid additional size");
> +	uvcb.add_data_length = additional_size;
> +}
> +
> +static void test_attest(void)
> +{
> +	struct uv_cb_attest uvcb = {
> +		.header.cmd = UVC_CMD_ATTESTATION,
> +		.header.len = sizeof(uvcb),
> +	};
> +	const struct uv_cb_qui *uvcb_qui = uv_get_query_data();
> +	int cc;
> +
> +	report_prefix_push("attest");
> +
> +	if (!uv_query_test_call(BIT_UVC_CMD_ATTESTATION)) {
> +		report_skip("Attestation not supported.");
> +		goto done;
> +	}
> +
> +	/* Verify that the uv supports at least one header version */
> +	report(uvcb_qui->supported_att_hdr_versions, "has hdr support");
> +
> +	memset((void *) page, 0, PAGE_SIZE);

please no extra space between ) and p

> +
> +	uvcb.header.len -= 1;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc && uvcb.header.rc == UVC_RC_INV_LEN, "invalid uvcb size 1");
> +	uvcb.header.len += 1;
> +
> +	uvcb.header.len += 1;
> +	cc = uv_call(0, (u64)&uvcb);
> +	report(cc && uvcb.header.rc == UVC_RC_INV_LEN, "invalid uvcb size 2");
> +	uvcb.header.len -= 1;
> +
> +	report_prefix_push("v1");
> +	if (test_bit_inv(0, &uvcb_qui->supported_att_hdr_versions))
> +		test_attest_v1(uvcb_qui->supported_paf);
> +	else
> +		report_skip("Attestation version 1 not supported");
> +	report_prefix_pop();
> +done:
>  	report_prefix_pop();
>  }
>  
> @@ -179,6 +350,7 @@ int main(void)
>  	test_invalid();
>  	test_query();
>  	test_sharing();
> +	test_attest();
>  	free_page((void *)page);
>  done:
>  	report_prefix_pop();

