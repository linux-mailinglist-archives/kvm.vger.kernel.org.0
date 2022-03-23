Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425A04E5008
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 11:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiCWKJJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 06:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiCWKJH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 06:09:07 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4307665A;
        Wed, 23 Mar 2022 03:07:37 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N8h7r6026346;
        Wed, 23 Mar 2022 10:07:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=GUf6CvudXkJOuNi8sUPB3T5yKZwqLwO5Khik7jSBxP0=;
 b=aCNFrynjZAaqGBaNZ7xqqW/X4GXfftYTiHjCCUjh/LT+O3w52l2u9rGSJ2TvbMX+OTeh
 7waEY8VbVsydIKzOXsnjoAuc5DGSQONVx/Da5360wTb+bV0WqoOQLclTJdXoFmU8YWuC
 we3qwdKRE2ZLNi6y0ipBwU+zKw2a0vgVjgLZlN86xQ93a4Wr86YXW9ffKLExEWvjYsgF
 Oag8KThAxL2+i+lXIfI/sC5BB8YcwU/9gSuQZokVVK97kkM2QmKWpcd0XyFHXbduw+9p
 4yqm9kC/kS3zePjIqx3RLMB0ytvUPFhGR5NrtmtmIhqTVFKPYXp0dtQcm5YeNKgiSxpG GQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx05eyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 10:07:36 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22NA6Fex004788;
        Wed, 23 Mar 2022 10:07:36 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyvx05exs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 10:07:36 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22NA2wrK018748;
        Wed, 23 Mar 2022 10:07:34 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej0a39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 10:07:34 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22NA7YQi32244002
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 10:07:34 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F10E852051;
        Wed, 23 Mar 2022 10:07:30 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.2.232])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 990A452052;
        Wed, 23 Mar 2022 10:07:30 +0000 (GMT)
Date:   Wed, 23 Mar 2022 11:07:28 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v3 5/5] s390x: uv-guest: Add attestation
 tests
Message-ID: <20220323110728.355735ab@p-imbrenda>
In-Reply-To: <4396b134-969e-a2f2-2347-cfe5d33925d5@linux.ibm.com>
References: <20220222145456.9956-1-seiden@linux.ibm.com>
        <20220222145456.9956-6-seiden@linux.ibm.com>
        <4396b134-969e-a2f2-2347-cfe5d33925d5@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: p0orVVVA0-kIdT-3wgRFTSirKuDPwN5F
X-Proofpoint-GUID: y74SqcD39_Oah4biG_njSaKdEiSSHrY-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-23_05,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 spamscore=0 malwarescore=0 adultscore=0 phishscore=0
 suspectscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230059
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Mar 2022 09:39:27 +0100
Janosch Frank <frankja@linux.ibm.com> wrote:

> On 2/22/22 15:54, Steffen Eiden wrote:
> > Adds several tests to verify correct error paths of attestation.
> > 
> > Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>  
> 
> I think this test deserves its own file: pv-attest.c

sounds like a good idea

> 
> But I'd leave the priv check in uv-guest.c.
> @Claudio: Any opinion about having all priv checks here and doing the 
> actual execution tests in pv-*.c files?

fine for me

maybe put a comment in pv-attest.c to explain that the priv check is
covered somewhere else already

> 
> > ---
> >   lib/s390x/asm/uv.h |   5 +-
> >   s390x/uv-guest.c   | 193 ++++++++++++++++++++++++++++++++++++++++++++-
> >   2 files changed, 196 insertions(+), 2 deletions(-)
> > 
> > diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> > index c330c0f8..e5f7aa72 100644
> > --- a/lib/s390x/asm/uv.h
> > +++ b/lib/s390x/asm/uv.h
> > @@ -108,7 +108,10 @@ struct uv_cb_qui {
> >   	u8  reserved88[158 - 136];	/* 0x0088 */
> >   	uint16_t max_guest_cpus;	/* 0x009e */
> >   	u64 uv_feature_indications;	/* 0x00a0 */
> > -	u8  reserveda8[200 - 168];	/* 0x00a8 */
> > +	uint8_t  reserveda8[224 - 168];	/* 0x00a8 */
> > +	uint64_t supp_att_hdr_ver;	/* 0x00e0 */
> > +	uint64_t supp_paf;		/* 0x00e8 */
> > +	uint8_t  reservedf0[256 - 240];	/* 0x00f0 */
> >   }  __attribute__((packed))  __attribute__((aligned(8)));
> >   
> >   struct uv_cb_cgc {
> > diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> > index 77057bd2..77edbba2 100644
> > --- a/s390x/uv-guest.c
> > +++ b/s390x/uv-guest.c
> > @@ -2,10 +2,11 @@
> >   /*
> >    * Guest Ultravisor Call tests
> >    *
> > - * Copyright (c) 2020 IBM Corp
> > + * Copyright IBM Corp. 2020, 2022
> >    *
> >    * Authors:
> >    *  Janosch Frank <frankja@linux.ibm.com>
> > + *  Steffen Eiden <seiden@linux.ibm.com>
> >    */
> >   
> >   #include <libcflat.h>
> > @@ -53,6 +54,15 @@ static void test_priv(void)
> >   	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> >   	report_prefix_pop();
> >   
> > +	report_prefix_push("attest");
> > +	uvcb.cmd = UVC_CMD_ATTESTATION;
> > +	uvcb.len = sizeof(struct uv_cb_attest);
> > +	expect_pgm_int();
> > +	enter_pstate();
> > +	uv_call_once(0, (uint64_t)&uvcb);
> > +	check_pgm_int_code(PGM_INT_CODE_PRIVILEGED_OPERATION);
> > +	report_prefix_pop();
> > +
> >   	report_prefix_pop();
> >   }
> >   
> > @@ -111,7 +121,187 @@ static void test_sharing(void)
> >   	cc = uv_call(0, (u64)&uvcb);
> >   	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
> >   	report_prefix_pop();
> > +}
> > +
> > +#define ARCB_VERSION_NONE 0
> > +#define ARCB_VERSION_1 0x0100
> > +#define ARCB_MEAS_NONE 0
> > +#define ARCB_MEAS_HMAC_SHA512 1
> > +#define MEASUREMENT_SIZE_HMAC_SHA512 64
> > +#define PAF_PHKH_ATT (1ULL << 61)
> > +#define ADDITIONAL_SIZE_PAF_PHKH_ATT 32
> > +/* arcb with one key slot and no nonce */
> > +struct uv_arcb_v1 {
> > +	uint64_t reserved0;		/* 0x0000 */
> > +	uint32_t req_ver;		/* 0x0008 */
> > +	uint32_t req_len;		/* 0x000c */
> > +	uint8_t  iv[12];		/* 0x0010 */
> > +	uint32_t reserved1c;		/* 0x001c */
> > +	uint8_t  reserved20[7];		/* 0x0020 */
> > +	uint8_t  nks;			/* 0x0027 */
> > +	uint32_t reserved28;		/* 0x0028 */
> > +	uint32_t sea;			/* 0x002c */
> > +	uint64_t plaint_att_flags;	/* 0x0030 */
> > +	uint32_t meas_alg_id;		/* 0x0038 */
> > +	uint32_t reserved3c;		/* 0x003c */
> > +	uint8_t  cpk[160];		/* 0x0040 */
> > +	uint8_t  key_slot[80];		/* 0x00e0 */
> > +	uint8_t  meas_key[64];		/* 0x0130 */
> > +	uint8_t  tag[16];		/* 0x0170 */
> > +} __attribute__((packed));
> > +
> > +struct attest_request_v1 {
> > +	struct uv_arcb_v1 arcb;
> > +	uint8_t measurement[MEASUREMENT_SIZE_HMAC_SHA512];
> > +	uint8_t additional[ADDITIONAL_SIZE_PAF_PHKH_ATT];
> > +};
> > +
> > +static void test_attest_v1(u64 supported_paf)
> > +{
> > +	struct uv_cb_attest uvcb = {
> > +		.header.cmd = UVC_CMD_ATTESTATION,
> > +		.header.len = sizeof(uvcb),
> > +	};
> > +	struct attest_request_v1 *attest_req = (void *)page;
> > +	struct uv_arcb_v1 *arcb = &attest_req->arcb;
> > +	int cc;
> > +
> > +	memset((void *)page, 0, PAGE_SIZE);
> > +
> > +	/*
> > +	 * Create a minimal arcb/uvcb such that FW has everything to start
> > +	 * unsealing the request. However, this unsealing will fail as the
> > +	 * kvm-unit-test framework provides no cryptography functions that
> > +	 * would be needed to seal such requests.
> > +	 */
> > +	arcb->req_ver = ARCB_VERSION_1;
> > +	arcb->req_len = sizeof(*arcb);
> > +	arcb->nks = 1;
> > +	arcb->sea = sizeof(arcb->meas_key);
> > +	arcb->plaint_att_flags = PAF_PHKH_ATT;
> > +	arcb->meas_alg_id = ARCB_MEAS_HMAC_SHA512;
> > +	uvcb.arcb_addr = (uint64_t)&attest_req->arcb;
> > +	uvcb.measurement_address = (uint64_t)attest_req->measurement;
> > +	uvcb.measurement_length = sizeof(attest_req->measurement);
> > +	uvcb.add_data_address = (uint64_t)attest_req->additional;
> > +	uvcb.add_data_length = sizeof(attest_req->additional);
> > +
> > +	uvcb.continuation_token = 0xff;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0101, "invalid continuation token");
> > +	uvcb.continuation_token = 0;
> > +
> > +	uvcb.user_data_length = sizeof(uvcb.user_data) + 1;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0102, "invalid user data size");
> > +	uvcb.user_data_length = 0;
> > +
> > +	uvcb.arcb_addr = get_ram_size() + PAGE_SIZE;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0103, "invalid address arcb");
> > +	uvcb.arcb_addr = page;
> > +
> > +	/* 0104 - 0105 need an unseal-able request */
> > +
> > +	arcb->req_ver = ARCB_VERSION_NONE;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0106, "unsupported version");
> > +	arcb->req_ver = ARCB_VERSION_1;
> > +
> > +	arcb->req_len += 1;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0107, "invalid arcb size 1");
> > +	arcb->req_len -= 1;
> > +
> > +	/*
> > +	 * The arcb needs to grow as well if number of key slots (nks)
> > +	 * is increased. However, this is not the case and there is no explicit
> > +	 * 'too many/less nks for that arcb size' error code -> expect 0x0107
> > +	 */
> > +	arcb->nks = 2;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0107, "invalid arcb size 2");
> > +	arcb->nks = 1;
> > +
> > +	arcb->nks = 0;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0108, "invalid num key slots");
> > +	arcb->nks = 1;
> > +
> > +	/*
> > +	 * Possible valid size (when using nonce).
> > +	 * However, req_len too small to host a nonce
> > +	 */
> > +	arcb->sea = 80;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0109, "invalid encrypted size 1");
> > +	arcb->sea = 17;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x0109, "invalid encrypted size 2");
> > +	arcb->sea = 64;
> > +
> > +	arcb->plaint_att_flags = supported_paf ^ GENMASK_ULL(63, 0);
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x010a, "invalid flag");
> > +	arcb->plaint_att_flags = PAF_PHKH_ATT;
> > +
> > +	arcb->meas_alg_id = ARCB_MEAS_NONE;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x010b, "invalid measurement algorithm");
> > +	arcb->meas_alg_id = ARCB_MEAS_HMAC_SHA512;
> >   
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x010c, "unable unseal");
> > +
> > +	uvcb.measurement_length = 0;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x010d, "invalid measurement size");
> > +	uvcb.measurement_length = sizeof(attest_req->measurement);
> > +
> > +	uvcb.add_data_length = 0;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc == 1 && uvcb.header.rc == 0x010e, "invalid additional size");
> > +	uvcb.add_data_length = sizeof(attest_req->additional);
> > +}
> > +
> > +static void test_attest(void)
> > +{
> > +	struct uv_cb_attest uvcb = {
> > +		.header.cmd = UVC_CMD_ATTESTATION,
> > +		.header.len = sizeof(uvcb),
> > +	};
> > +	const struct uv_cb_qui *uvcb_qui = uv_get_query_data();
> > +	int cc;
> > +
> > +	report_prefix_push("attest");
> > +
> > +	if (!uv_query_test_call(BIT_UVC_CMD_ATTESTATION)) {
> > +		report_skip("Attestation not supported.");
> > +		goto done;
> > +	}
> > +
> > +	/* Verify that the UV supports at least one header version */
> > +	report(uvcb_qui->supp_att_hdr_ver, "has hdr support");
> > +
> > +	memset((void *)page, 0, PAGE_SIZE);
> > +
> > +	uvcb.header.len -= 1;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc && uvcb.header.rc == UVC_RC_INV_LEN, "invalid uvcb size 1");
> > +	uvcb.header.len += 1;
> > +
> > +	uvcb.header.len += 1;
> > +	cc = uv_call(0, (uint64_t)&uvcb);
> > +	report(cc && uvcb.header.rc == UVC_RC_INV_LEN, "invalid uvcb size 2");
> > +	uvcb.header.len -= 1;
> > +
> > +	report_prefix_push("v1");
> > +	if (test_bit_inv(0, &uvcb_qui->supp_att_hdr_ver))
> > +		test_attest_v1(uvcb_qui->supp_paf);
> > +	else
> > +		report_skip("Attestation version 1 not supported");
> > +	report_prefix_pop();
> > +done:
> >   	report_prefix_pop();
> >   }
> >   
> > @@ -193,6 +383,7 @@ int main(void)
> >   	test_invalid();
> >   	test_query();
> >   	test_sharing();
> > +	test_attest();
> >   	free_page((void *)page);
> >   done:
> >   	report_prefix_pop();  
> 

