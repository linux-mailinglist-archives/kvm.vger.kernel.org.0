Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C605558FF0D
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 17:16:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235594AbiHKPQJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 11:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiHKPQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 11:16:07 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C562A48C8A
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 08:16:05 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27BEdMGL008975
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 15:16:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3fSCqcvyhZyhBJ3EBHcFplxqU1M7ThHjpwCHHIbmbQo=;
 b=nCUgBthoz42YVYqHUiWYfxn2wbD07k4KSNf8WTSBH3z2liJf115fcPl+3SETYK41KDJZ
 qYOGaKZV66oLQCJDxSduGnssAIWaVdJBMSjadTauNmCRgZe+MXWjuBuy9UyOXaEIkena
 4crZrrBpEl+t7GTA7UlSZx2Jo6EYSPzkfo/vwLWdCqG25vBZC3/UZKaV8qbDIozejOMZ
 8dxg90up3jF2LC2rfQjo7tXL8Oq4BBpwMIpDqoXz8XLGYQvpTWVT3J+SxACTAOysGHa0
 +U1Kn7R0jyqiBuJhS8CWuc3m2NJfpdm4nLegSsN6DKnR4c7w99fScpPy/mjiY7KrAj1m ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw2ywk5w5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 15:16:05 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27BEe2jH013822
        for <kvm@vger.kernel.org>; Thu, 11 Aug 2022 15:16:04 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3hw2ywk5v4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 15:16:04 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27BF5RVn018953;
        Thu, 11 Aug 2022 15:16:02 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3huwvf26tf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Aug 2022 15:16:02 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27BFGGh217301854
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 11 Aug 2022 15:16:16 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5735FAE04D;
        Thu, 11 Aug 2022 15:15:59 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DDBFEAE045;
        Thu, 11 Aug 2022 15:15:58 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.154])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 11 Aug 2022 15:15:58 +0000 (GMT)
Date:   Thu, 11 Aug 2022 17:15:57 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, seiden@linux.ibm.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v5] s390x: uv-host: Add access checks for
 donated memory
Message-ID: <20220811171557.541d17ef@p-imbrenda>
In-Reply-To: <20220811150039.29938-1-frankja@linux.ibm.com>
References: <20220811161716.358a68eb@p-imbrenda>
        <20220811150039.29938-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: _SMoS0dlUE3uPs0fpiHhlNZCt367WZDc
X-Proofpoint-GUID: oFQRm_lzvhMxMkbBi_Wr5k7cSxLMTidl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-11_11,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 phishscore=0
 impostorscore=0 lowpriorityscore=0 bulkscore=0 adultscore=0 mlxscore=0
 clxscore=1015 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208110051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 11 Aug 2022 15:00:39 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Let's check if the UV really protected all the memory we donated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
> This patch is clearly cursed :)
> ---
>  s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 37 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index dfcebe10..191e8b3f 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -45,6 +45,32 @@ static void cpu_loop(void)
>  	for (;;) {}
>  }
>  
> +/*
> + * Checks if a memory area is protected as secure memory.
> + * Will return true if all pages are protected, false otherwise.
> + */
> +static bool access_check_3d(uint8_t *access_ptr, uint64_t len)
> +{
> +	assert(!(len & ~PAGE_MASK));
> +	assert(!((uint64_t)access_ptr & ~PAGE_MASK));
> +
> +	while (len) {
> +		expect_pgm_int();
> +		READ_ONCE(*access_ptr);
> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +		expect_pgm_int();
> +		WRITE_ONCE(*access_ptr, 42);
> +		if (clear_pgm_int() != PGM_INT_CODE_SECURE_STOR_ACCESS)
> +			return false;
> +
> +		access_ptr += PAGE_SIZE;
> +		len -= PAGE_SIZE;
> +	}
> +
> +	return true;
> +}
> +
>  static struct cmd_list cmds[] = {
>  	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>  	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
> @@ -332,6 +358,10 @@ static void test_cpu_create(void)
>  	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
>  	       uvcb_csc.cpu_handle, "success");
>  
> +	rc = access_check_3d((uint8_t *)uvcb_csc.stor_origin,
> +			     uvcb_qui.cpu_stor_len);
> +	report(rc, "Storage protection");
> +
>  	tmp = uvcb_csc.stor_origin;
>  	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
>  	rc = uv_call(0, (uint64_t)&uvcb_csc);
> @@ -430,6 +460,13 @@ static void test_config_create(void)
>  	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>  	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
>  
> +	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_base_stor_origin,
> +			     uvcb_qui.conf_base_phys_stor_len);
> +	report(rc, "Base storage protection");
> +
> +	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_var_stor_origin, vsize);
> +	report(rc, "Variable storage protection");
> +
>  	uvcb_cgc.header.rc = 0;
>  	uvcb_cgc.header.rrc = 0;
>  	tmp = uvcb_cgc.guest_handle;

