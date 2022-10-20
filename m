Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A9605950
	for <lists+kvm@lfdr.de>; Thu, 20 Oct 2022 10:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiJTIH0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Oct 2022 04:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiJTIHY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Oct 2022 04:07:24 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 228B317C173
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 01:07:21 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29K7nouV022759
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mlQp9ERXWa+FvW3ZEIjVUPQ9ghAVzVSx275BU6ubdtw=;
 b=Z4wRor+tqw/QBrwec7Q7Qa2+PXi8BoLguJm2vYk9TB07sUFEkZwkkACz5pjfG+ATjUSE
 dEc4jILwz4UjoTOfhiKJVs09Q7mn9C0I4YcFcqOpZczrTtp+wTm0v4Lhtv2EfyqjNTJZ
 xE25T8mvMKglEZp9KEqmPrnEFpoytFXtV5/4AjYHjTdrAT+3lkys5Hqb9w64dj4OS2To
 1bvkgbULHpe45+Og532t0rdN5zHe/Tp3J3EF3urBvpzG058ZZpk0fY19CqJOTU28iPZN
 cVuan3cBtcLffvg1CSXtEEQQDHp9X/Jn2Vr7deB3l/YJ65143MNqZzr5ZLSdGqFF1rJ5 fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q0mfg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:19 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29K7ojqo026236
        for <kvm@vger.kernel.org>; Thu, 20 Oct 2022 08:07:19 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kb29q0mdn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:07:19 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29K85FrX011847;
        Thu, 20 Oct 2022 08:07:17 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04ams.nl.ibm.com with ESMTP id 3k7mg98er9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 20 Oct 2022 08:07:17 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29K87Emv62980446
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Oct 2022 08:07:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C476AE051;
        Thu, 20 Oct 2022 08:07:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6A1EAE04D;
        Thu, 20 Oct 2022 08:07:13 +0000 (GMT)
Received: from [9.152.224.253] (unknown [9.152.224.253])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 20 Oct 2022 08:07:13 +0000 (GMT)
Message-ID: <fad9b0a5-4e2c-4c72-600a-7c95c9096a53@linux.ibm.com>
Date:   Thu, 20 Oct 2022 10:07:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [kvm-unit-tests PATCH v3 1/8] s390x: uv-host: Add access checks
 for donated memory
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>, kvm@vger.kernel.org
Cc:     imbrenda@linux.ibm.com, nrb@linux.ibm.com, scgl@linux.ibm.com,
        thuth@redhat.com
References: <20221017093925.2038-1-frankja@linux.ibm.com>
 <20221017093925.2038-2-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
In-Reply-To: <20221017093925.2038-2-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: T3QAOJcmO0VrYrMavP1PWPba-Rt6F9Hp
X-Proofpoint-GUID: 9VcNQc3I1gbZwroeDG4CjPWNZ-VCcEfU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-20_02,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501 mlxscore=0
 malwarescore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210200047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/17/22 11:39, Janosch Frank wrote:
> Let's check if the UV really protected all the memory we donated.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
LGTM.
Reviewed-by; Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 37 +++++++++++++++++++++++++++++++++++++
>   1 file changed, 37 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index a1a6d120..622c7f7e 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -43,6 +43,32 @@ static void cpu_loop(void)
>   	for (;;) {}
>   }
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
>   static struct cmd_list cmds[] = {
>   	{ "init", UVC_CMD_INIT_UV, sizeof(struct uv_cb_init), BIT_UVC_CMD_INIT_UV },
>   	{ "create conf", UVC_CMD_CREATE_SEC_CONF, sizeof(struct uv_cb_cgc), BIT_UVC_CMD_CREATE_SEC_CONF },
> @@ -194,6 +220,10 @@ static void test_cpu_create(void)
>   	report(rc == 0 && uvcb_csc.header.rc == UVC_RC_EXECUTED &&
>   	       uvcb_csc.cpu_handle, "success");
>   
> +	rc = access_check_3d((uint8_t *)uvcb_csc.stor_origin,
> +			     uvcb_qui.cpu_stor_len);
> +	report(rc, "Storage protection");
> +
>   	tmp = uvcb_csc.stor_origin;
>   	uvcb_csc.stor_origin = (unsigned long)memalign(PAGE_SIZE, uvcb_qui.cpu_stor_len);
>   	rc = uv_call(0, (uint64_t)&uvcb_csc);
> @@ -292,6 +322,13 @@ static void test_config_create(void)
>   	rc = uv_call(0, (uint64_t)&uvcb_cgc);
>   	report(rc == 0 && uvcb_cgc.header.rc == UVC_RC_EXECUTED, "successful");
>   
> +	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_base_stor_origin,
> +			     uvcb_qui.conf_base_phys_stor_len);
> +	report(rc, "Base storage protection");
> +
> +	rc = access_check_3d((uint8_t *)uvcb_cgc.conf_var_stor_origin, vsize);
> +	report(rc, "Variable storage protection");
> +
>   	uvcb_cgc.header.rc = 0;
>   	uvcb_cgc.header.rrc = 0;
>   	tmp = uvcb_cgc.guest_handle;
