Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8153356B637
	for <lists+kvm@lfdr.de>; Fri,  8 Jul 2022 12:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237743AbiGHKDA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Jul 2022 06:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiGHKC7 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Jul 2022 06:02:59 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4971D83F1A;
        Fri,  8 Jul 2022 03:02:57 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2689KHdI005085;
        Fri, 8 Jul 2022 10:02:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Ej60TAw/aUXr4NVdlLV5f1zj4O1v6kWksXzr8maA3/A=;
 b=itMbQRaaoDJQ++9f8NZt2AM6nSn82Egr2YudmY2Ia/rD7SvKvL0XZ/DB1Xyw5gMoGCds
 /PQPerz9dZq2ZwOpyZc49q34UTi/x878jnIsCGd5wpqzXIDAPJfkF9ANyv7IjaqwHf2R
 4um8ueKFYgw7pT2/0cOE/PTuulQDv8WEWovi9w1Q78hrTl6AZ/Gl75bzkU1Y+XNMIxp0
 cc33AwCBU4TCB4HuzIA3+f+6UpTlJSAQ9qscfbfxSYZimoRA92+ztd6wnUPLY88FAjLw
 vAHvKMiLlx1k3gJ1MbBFNgBWGw4VPuAzdV0ayMy1GwmgD5qOUoIShBl1IbEJeUQhYGcM gA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6g31bu8a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:02:56 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2689o3J6030527;
        Fri, 8 Jul 2022 10:02:56 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3h6g31bu7g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:02:55 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2689bkdq026635;
        Fri, 8 Jul 2022 10:02:54 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3h4ujsktek-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 08 Jul 2022 10:02:54 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 268A2oVq16515342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 8 Jul 2022 10:02:50 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8C04352050;
        Fri,  8 Jul 2022 10:02:50 +0000 (GMT)
Received: from [9.145.3.110] (unknown [9.145.3.110])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id D3C3D5204F;
        Fri,  8 Jul 2022 10:02:49 +0000 (GMT)
Message-ID: <7ea8c27d-8448-1c86-5569-e7c80f871832@linux.ibm.com>
Date:   Fri, 8 Jul 2022 12:02:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [kvm-unit-tests PATCH v2 3/8] s390x: uv-host: Test uv immediate
 parameter
Content-Language: en-US
To:     Janosch Frank <frankja@linux.ibm.com>,
        kvm390 mailing list 
        <kvm390-list@tuxmaker.boeblingen.de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        imbrenda@linux.ibm.com, thuth@redhat.com, nrb@linux.ibm.com,
        scgl@linux.ibm.com
References: <20220706064024.16573-1-frankja@linux.ibm.com>
 <20220706064024.16573-4-frankja@linux.ibm.com>
From:   Steffen Eiden <seiden@linux.ibm.com>
Organization: IBM
In-Reply-To: <20220706064024.16573-4-frankja@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 78t6wQRLAy3wJv0on6y_cGurcMfyyNsP
X-Proofpoint-ORIG-GUID: xof1OZhbS66PgbjuU4elc41GS9kKbbtr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_08,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 priorityscore=1501 phishscore=0
 impostorscore=0 bulkscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2207080036
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
> Let's check if we get a specification PGM exception if we set a
> non-zero i3 when doing a UV call.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
Reviewed-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
>   s390x/uv-host.c | 23 +++++++++++++++++++++++
>   1 file changed, 23 insertions(+)
> 
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 5aeacb42..0762e690 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -82,6 +82,28 @@ static struct cmd_list cmds[] = {
>   	{ NULL, 0, 0 },
>   };
>   
> +static void test_i3(void)
> +{
> +	struct uv_cb_header uvcb = {
> +		.cmd = UVC_CMD_INIT_UV,
> +		.len = sizeof(struct uv_cb_init),
> +	};
> +	unsigned long r1 = 0;
> +	int cc;
> +
> +	report_prefix_push("i3");
> +	expect_pgm_int();
> +	asm volatile(
> +		"0:	.insn rrf,0xB9A40000,%[r1],%[r2],4,2\n"
> +		"		ipm	%[cc]\n"
> +		"		srl	%[cc],28\n"
> +		: [cc] "=d" (cc)
> +		: [r1] "a" (r1), [r2] "a" (&uvcb)
> +		: "memory", "cc");
> +	check_pgm_int_code(PGM_INT_CODE_SPECIFICATION);
> +	report_prefix_pop();
> +}
> +
>   static void test_priv(void)
>   {
>   	struct uv_cb_header uvcb = {};
> @@ -577,6 +599,7 @@ int main(void)
>   		goto done;
>   	}
>   
> +	test_i3();
>   	test_priv();
>   	test_invalid();
>   	test_uv_uninitialized();
