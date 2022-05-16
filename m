Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 975785287D8
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 17:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244658AbiEPPCa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 11:02:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232587AbiEPPC2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 11:02:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C690614D;
        Mon, 16 May 2022 08:02:27 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24GEVQQ7028008;
        Mon, 16 May 2022 15:02:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=QkMVbFtwZD1tLwGNk/dD7Wk+74tSw+UJgVhrzJFNTl8=;
 b=erjO93In25RVpIsXk+gYIn4tt6aXZPH+MD+uJ47Be+UNe8Rldm199nktnsuBTPVsP1pt
 oSfmzxeGyDfG/XaAO0EHRDKD1OyPSexUg/3uokOS6rtS9yls9Gzfd5sEo3RSWasf6Pbq
 qupWVLk+bWjK0xlVOFXTC11EG0K4j57UvBZlsMqfoJcLu+d9OB0Btgl2mQrN191+CCWU
 GhmtCj408xjLGAJqZw3HdNGt3JKvyfRnMbNuZIhGkx5XwiVeRO36TDpDUCjr0YIqETha
 ufvhwcLR5QZKfqSnWO3fH9uHB0OYHJcSOMVhF67CBKZPkmX0SuKsokvVFCmW11RdRjj1 TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3rey0ske-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:02:26 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24GEWWBP031064;
        Mon, 16 May 2022 15:02:26 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g3rey0sjq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:02:26 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24GF2LlA013520;
        Mon, 16 May 2022 15:02:23 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 3g2428t8cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 16 May 2022 15:02:23 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24GF1nUI35258826
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 May 2022 15:01:49 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 41A27A4055;
        Mon, 16 May 2022 15:02:20 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E256DA404D;
        Mon, 16 May 2022 15:02:19 +0000 (GMT)
Received: from [9.145.28.156] (unknown [9.145.28.156])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 16 May 2022 15:02:19 +0000 (GMT)
Message-ID: <a78d4b62-87a9-3095-b7bb-0d333a4657b2@linux.ibm.com>
Date:   Mon, 16 May 2022 17:02:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH 2/6] s390x: uv-host: Add uninitialized UV
 tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220513095017.16301-1-frankja@linux.ibm.com>
 <20220513095017.16301-3-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220513095017.16301-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Rwu05y3Vpjd0EcJMrYKYFyi3ADEmGFUE
X-Proofpoint-ORIG-GUID: 6cep35YawpwIowQtxfnuBgH9rqP_d4N1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-16_14,2022-05-16_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 mlxscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205160086
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/13/22 11:50, Janosch Frank wrote:
> Let's also test for rc 0x3
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
I, however, have some nits below.

> ---
>   s390x/uv-host.c | 78 +++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 76 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 0f0b18a1..f846fc42 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -83,6 +83,24 @@ static void test_priv(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_uv_uninitialized(void)
> +{
> +	struct uv_cb_header uvcb = {};
> +	int i;
> +
> +	report_prefix_push("uninitialized");
> +
> +	/* i = 1 to skip over initialize */
> +	for (i = 1; cmds[i].name; i++) {
> +		expect_pgm_int();
> +		uvcb.cmd = cmds[i].cmd;
> +		uvcb.len = cmds[i].len;
> +		uv_call_once(0, (uint64_t)&uvcb);
> +		report(uvcb.rc == UVC_RC_INV_STATE, "%s", cmds[i].name);
> +	}
> +	report_prefix_pop();
> +}
> +
>   static void test_config_destroy(void)
>   {
>   	int rc;
> @@ -477,13 +495,68 @@ static void test_invalid(void)
>   	report_prefix_pop();
>   }
>   
> +static void test_clear_setup(void)
maybe rename this to setup_test_clear(void)
I initially mistook this function as a test and not a setup function for
a test

> +{
> +	unsigned long vsize;
> +	int rc;
> +
> +	uvcb_cgc.header.cmd = UVC_CMD_CREATE_SEC_CONF;
> +	uvcb_cgc.header.len = sizeof(uvcb_cgc);
> +
> +	uvcb_cgc.guest_stor_origin = 0;
> +	uvcb_cgc.guest_stor_len = 42 * (1UL << 20);
> +	vsize = uvcb_qui.conf_base_virt_stor_len +
> +		((uvcb_cgc.guest_stor_len / (1UL << 20)) * uvcb_qui.conf_virt_var_stor_len);
> +
> +	uvcb_cgc.conf_base_stor_origin = (uint64_t)memalign(PAGE_SIZE * 4, uvcb_qui.conf_base_phys_stor_len);
> +	uvcb_cgc.conf_var_stor_origin = (uint64_t)memalign(PAGE_SIZE, vsize);
> +	uvcb_cgc.guest_asce = (uint64_t)memalign(PAGE_SIZE, 4 * PAGE_SIZE) | ASCE_DT_SEGMENT | REGION_TABLE_LENGTH | ASCE_P;
> +	uvcb_cgc.guest_sca = (uint64_t)memalign(PAGE_SIZE * 4, PAGE_SIZE * 4);
> +
> +	rc = uv_call(0, (uint64_t)&uvcb_cgc);
> +	assert(rc == 0);
> +
> +	uvcb_csc.header.len = sizeof(uvcb_csc);
> +	uvcb_csc.header.cmd = UVC_CMD_CREATE_SEC_CPU;
> +	uvcb_csc.guest_handle = uvcb_cgc.guest_handle;
> +	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
> +	uvcb_csc.state_origin = (unsigned long)memalign(PAGE_SIZE, PAGE_SIZE);
> +
> +	rc = uv_call(0, (uint64_t)&uvcb_csc);
> +	assert(rc == 0);
> +}
> +
>   static void test_clear(void)
>   {
> -	uint64_t *tmp = (void *)uvcb_init.stor_origin;
> +	uint64_t *tmp;
> +
> +	report_prefix_push("load normal reset");
> +
> +	/*
> +	 * Setup a config and a cpu so we can check if a diag308 reset
> +	 * clears the donated memory and makes the pages unsecure.
> +	 */
> +	test_clear_setup();
>   
>   	diag308_load_reset(1);
>   	sclp_console_setup();
> -	report(!*tmp, "memory cleared after reset 1");
> +
> +	tmp = (void *)uvcb_init.stor_origin;
> +	report(!*tmp, "uv init donated memory cleared");
> +
> +	tmp = (void *)uvcb_cgc.conf_base_stor_origin;
> +	report(!*tmp, "config base donated memory cleared");
> +
> +	tmp = (void *)uvcb_cgc.conf_base_stor_origin;
> +	report(!*tmp, "config variable donated memory cleared");
> +
> +	tmp = (void *)uvcb_csc.stor_origin;
> +	report(!*tmp, "cpu donated memory cleared after reset 1");
> +
> +	/* Check if uninitialized after reset */
> +	test_uv_uninitialized();
> +
> +	report_prefix_pop();
>   }
>   
>   static void setup_vmem(void)
> @@ -514,6 +587,7 @@ int main(void)
>   
>   	test_priv();
>   	test_invalid();
> +	test_uv_uninitialized();
>   	test_query();
>   	test_init();
IIRC this test must be done last, as a following test has an 
uninitialized UV. Maybe add a short comment for that here.
>   

