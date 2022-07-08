Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 467BB56B520
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 11:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237593AbiGHJKO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 05:10:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbiGHJKN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 05:10:13 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FECCDEC;
        Fri,  8 Jul 2022 02:10:12 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2688juCD040879;
        Fri, 8 Jul 2022 09:10:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=KXHtKxUJIvRNwO4J5gvSc2w3rDaCTdwViNXFrB+t+UY=;
 b=AP/0XKvr2jtl8biTK5zr0JAtmtF2cdc4+osT0UvKm5eIntCw8Chc/uiaMwSsLBcRSsT1
 3WqQi1DCOp6kGdtv0SiCsYDjQlsSunoOhTxd3GGEyAcx2hTrW8gAwOzSUGHZzek64DtT
 UizSN9LFJ/K5sRNYBMKL3rxv1w4jEVQ5g7QxUtKaCPHDoQi9nBY61Ol1CMyLxkfFr7pu
 JDJzonqPLS22VmYUlL2lnMqlBSGiI0C28hR3+HHpv4ylcL/sCn7xfuQIkj9pN0B6T82k
 LK2P7eQxxldLZcE62TnSP8aeZsBKlNyv+fVC5uw4xz1a2uUw2zGopxADE6D0s8DzcJwa og== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6hby8hdt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 09:10:12 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2688kfQR001722;
        Fri, 8 Jul 2022 09:10:11 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6hby8hcj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 09:10:11 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 26897gml002509;
        Fri, 8 Jul 2022 09:10:09 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujskrky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 09:10:09 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26898j6223855520
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 09:08:45 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 900F45204F;
        Fri,  8 Jul 2022 09:10:05 +0000 (GMT)
Received: from [9.145.3.110] (unknown [9.145.3.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 404C552050;
        Fri,  8 Jul 2022 09:10:05 +0000 (GMT)
Message-ID: <c8f10e41-06f6-a563-8bb6-3b999d4d94d3@linux.ibm.com>
Date:   Fri, 8 Jul 2022 11:10:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: uv-host: Add uninitialized
 UV tests
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-3-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220706064024.16573-3-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hgcu5-qrRf0SinPSdD2b5_zSRlpTBWlT
X-Proofpoint-GUID: qTebMX5XW2Go5iimqBS-Uv1GtcC0Gvzo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_07,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2207080032
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/6/22 08:40, Janosch Frank wrote:
> Let's also test for rc 0x3
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 77 insertions(+), 2 deletions(-)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 983cb4a1..5aeacb42 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -101,6 +101,25 @@ static void test_priv(void)
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
> +	for (i = 0; cmds[i].name; i++) {
> +		if (cmds[i].cmd == UVC_CMD_INIT_UV)
> +			continue;
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
> @@ -468,13 +487,68 @@ static void test_invalid(void)
>   	report_prefix_pop();
>   }
>   
> +static void setup_test_clear(void)
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
> +	setup_test_clear();
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
> @@ -505,6 +579,7 @@ int main(void)
>   
>   	test_priv();
>   	test_invalid();
> +	test_uv_uninitialized();
>   	test_query();
>   	test_init();
>   
