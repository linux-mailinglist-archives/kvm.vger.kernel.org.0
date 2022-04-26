Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 049F150F977
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 12:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbiDZKDH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 06:03:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347935AbiDZKCl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 06:02:41 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A873ABFA;
        Tue, 26 Apr 2022 02:22:10 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23Q8osql020045;
        Tue, 26 Apr 2022 09:22:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=GIpsF1LivOkvFX18mvNNS6e13yzM32pKKFYJeIuKZL4=;
 b=WOQdO2lqEZT8z4FcH5OXvNTScgQ4ji3MPQJmYciHhK36xQX/nKF+LMxKLvVim3N2G+pW
 o3MUG5tyma3isdBF2rxJyW1JOgfWuemkzf/LKrSRC6AiWQN7rn6LR6OWqW9fYO+5WGd4
 u0oUZLDPLLNUJce1KzEiG6vpycYnxvCXRgylf5NTR9WjfmuOVUJbTw3qYX0UfX/vve33
 3Ftoi7Ej7qIBjUAjOdseuCq7x/m9qRCx6p/U1ZbksikXPFmpyj8z//bqtUXFfxoWj1MG
 5SV297qIs6Q49cV9gNY+ZbfbZ2jd2Pyu3Q1ndjf79KKDP8kPPOFctRlfpVJjcNgLzKRV 1g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpav33v07-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:22:10 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23Q8hTVv024673;
        Tue, 26 Apr 2022 09:22:09 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fpav33uyd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:22:09 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23Q9DBVp014653;
        Tue, 26 Apr 2022 09:22:07 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3fm938u794-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 26 Apr 2022 09:22:07 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23Q9M3d735979702
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 09:22:04 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DA027AE04D;
        Tue, 26 Apr 2022 09:22:03 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7480EAE055;
        Tue, 26 Apr 2022 09:22:03 +0000 (GMT)
Received: from [9.145.2.160] (unknown [9.145.2.160])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 26 Apr 2022 09:22:03 +0000 (GMT)
Message-ID: <ad44e7d2-6123-1981-b103-e5d9cc497c4c@linux.ibm.com>
Date:   Tue, 26 Apr 2022 11:22:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v4 5/5] s390x: uv-guest: Add attestation
 tests
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220421094527.32261-1-seiden@linux.ibm.com>
 <20220421094527.32261-6-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220421094527.32261-6-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GXhoBIory4I42xvg7eckhol3_3oqa7H9
X-Proofpoint-GUID: AJwKd9NS2CdJRAYkwFLM5rv4BSYn62g6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-26_02,2022-04-25_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 spamscore=0
 clxscore=1015 adultscore=0 impostorscore=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 lowpriorityscore=0 phishscore=0 priorityscore=1501
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260060
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/21/22 11:45, Steffen Eiden wrote:
> Adds several tests to verify correct error paths of attestation.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   lib/s390x/asm/uv.h |   5 +-
>   s390x/Makefile     |   1 +
>   s390x/pv-attest.c  | 225 +++++++++++++++++++++++++++++++++++++++++++++
>   s390x/uv-guest.c   |  13 ++-
>   4 files changed, 240 insertions(+), 4 deletions(-)
>   create mode 100644 s390x/pv-attest.c
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 7c8c399d..38920461 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -108,7 +108,10 @@ struct uv_cb_qui {
>   	u8  reserved88[158 - 136];	/* 0x0088 */
>   	uint16_t max_guest_cpus;	/* 0x009e */
>   	u64 uv_feature_indications;	/* 0x00a0 */
> -	u8  reserveda8[200 - 168];	/* 0x00a8 */
> +	uint8_t  reserveda8[224 - 168];	/* 0x00a8 */
> +	uint64_t supp_att_hdr_ver;	/* 0x00e0 */
> +	uint64_t supp_paf;		/* 0x00e8 */
> +	uint8_t  reservedf0[256 - 240];	/* 0x00f0 */
>   }  __attribute__((packed))  __attribute__((aligned(8)));
>   
>   struct uv_cb_cgc {
> diff --git a/s390x/Makefile b/s390x/Makefile
> index 8ff84db5..5a49d1e7 100644
> --- a/s390x/Makefile
> +++ b/s390x/Makefile
> @@ -29,6 +29,7 @@ tests += $(TEST_DIR)/mvpg-sie.elf
>   tests += $(TEST_DIR)/spec_ex-sie.elf
>   tests += $(TEST_DIR)/firq.elf
>   tests += $(TEST_DIR)/epsw.elf
> +tests += $(TEST_DIR)/pv-attest.elf
>   
>   pv-tests += $(TEST_DIR)/pv-diags.elf
>   
> diff --git a/s390x/pv-attest.c b/s390x/pv-attest.c
> new file mode 100644
> index 00000000..e31780a3
> --- /dev/null
> +++ b/s390x/pv-attest.c
> @@ -0,0 +1,225 @@
[...]
> +
> +static void test_attest_v1(uint64_t page)
> +{
> +	struct uv_cb_attest uvcb = {
> +		.header.cmd = UVC_CMD_ATTESTATION,
> +		.header.len = sizeof(uvcb),
> +	};
> +	const struct uv_cb_qui *uvcb_qui = uv_get_query_data();
> +	struct attest_request_v1 *attest_req = (void *)page;
> +	struct uv_arcb_v1 *arcb = &attest_req->arcb;
> +	int cc;
> +
> +	report_prefix_push("v1");
> +	if (!test_bit_inv(0, &uvcb_qui->supp_att_hdr_ver)) {
> +		report_skip("Attestation version 1 not supported");
> +		goto done;
> +	}
> +
> +	memset((void *)page, 0, PAGE_SIZE);
> +
> +	/*
> +	 * Create a minimal arcb/uvcb such that FW has everything to start
> +	 * unsealing the request. However, this unsealing will fail as the
> +	 * kvm-unit-test framework provides no cryptography functions that
> +	 * would be needed to seal such requests.
> +	 */
> +	arcb->req_ver = ARCB_VERSION_1;
> +	arcb->req_len = sizeof(*arcb);
> +	arcb->nks = 1;
> +	arcb->sea = sizeof(arcb->meas_key);
> +	arcb->plaint_att_flags = PAF_PHKH_ATT;
> +	arcb->meas_alg_id = ARCB_MEAS_HMAC_SHA512;
> +	uvcb.arcb_addr = (uint64_t)&attest_req->arcb;
> +	uvcb.measurement_address = (uint64_t)attest_req->measurement;
> +	uvcb.measurement_length = sizeof(attest_req->measurement);
> +	uvcb.add_data_address = (uint64_t)attest_req->additional;
> +	uvcb.add_data_length = sizeof(attest_req->additional);
> +
> +	uvcb.continuation_token = 0xff;
> +	cc = uv_call(0, (uint64_t)&uvcb);
> +	report(cc == 1 && uvcb.header.rc == 0x0101, "invalid continuation token");

Please don't add the 0 to the front of the rc values.

[...]

> @@ -111,8 +120,6 @@ static void test_sharing(void)
>   	cc = uv_call(0, (u64)&uvcb);
>   	report(cc == 0 && uvcb.header.rc == UVC_RC_EXECUTED, "unshare");
>   	report_prefix_pop();
> -
> -	report_prefix_pop();

That's unrelated, no?

>   }
>   
>   static struct {

