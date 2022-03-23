Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD14E4E01
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 09:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242572AbiCWIUc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 04:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237876AbiCWIUa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 04:20:30 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7AC22DD62;
        Wed, 23 Mar 2022 01:19:00 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22N87AqE037394;
        Wed, 23 Mar 2022 08:19:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=IFvjhkMkomB+V3+M1ld+H2efCcaunX/EJbMXOTUl9zU=;
 b=iOKypx7B4BKlBjh5N+IdiDBc+a/GPO/O5Mt+L2t9dvxLL5nA3IkRNPHo5JIJrbJdp05W
 BCfPnHqGBRjjJyUQ8U+ElU0FtkJRU+JQA0FILHf8Z005eXpXKapwhfhMPw1/RSkK5vIx
 urpI8CEaXqNBfr2Oivz+Gjoke6EykiS4c+0YO4LG2e3AxhQ4ngK9373mQL1eI+ljLTV5
 BKcx/SqRXZfYh1I987aq457I7bRff6lpRF8o42k/HkjqeZU9WGBhgDYqqAdhZug1oMpM
 tXMZyPmho67GvbtMoyJS2V+bHXHWaW02CTPQ/BTwuOwtr7/QpGwoAvEHzGV29LadtNsK EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyv2amb8x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:19:00 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22N83DCq013918;
        Wed, 23 Mar 2022 08:19:00 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3eyv2amb83-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:18:59 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22N8CxLg004381;
        Wed, 23 Mar 2022 08:18:57 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3ew6ej032w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Mar 2022 08:18:57 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22N8Is8Y21430562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Mar 2022 08:18:54 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1A23111C04A;
        Wed, 23 Mar 2022 08:18:54 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCCCB11C050;
        Wed, 23 Mar 2022 08:18:53 +0000 (GMT)
Received: from [9.145.94.199] (unknown [9.145.94.199])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Mar 2022 08:18:53 +0000 (GMT)
Message-ID: <43eac0fb-4635-1e19-90ce-38386aa5b216@linux.ibm.com>
Date:   Wed, 23 Mar 2022 09:18:53 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v3 1/5] s390x: uv-host: Add attestation
 test
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
References: <20220222145456.9956-1-seiden@linux.ibm.com>
 <20220222145456.9956-2-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220222145456.9956-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OObt4C8Fwetac6fGLoWTNrDOi8ASiNbi
X-Proofpoint-GUID: c9-izhULmiEnV9X60JZpas6N8nDAl2mn
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-22_08,2022-03-22_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 priorityscore=1501 phishscore=0 adultscore=0 mlxlogscore=999 spamscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203230047
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/22/22 15:54, Steffen Eiden wrote:
> Adds an invalid command test for attestation in the uv-host.

I'm still fine with this test but I'd suggest changing the title to:
s390x: uv-host: Add invalid command attestation check

Just so it doesn't sound the same as the last patch in the series.

> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
> Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   lib/s390x/asm/uv.h | 23 ++++++++++++++++++++++-
>   s390x/uv-host.c    |  1 +
>   2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 70bf65c4..c330c0f8 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -1,7 +1,7 @@
>   /*
>    * s390x Ultravisor related definitions
>    *
> - * Copyright (c) 2020 IBM Corp
> + * Copyright IBM Corp. 2020, 2022
>    *
>    * Authors:
>    *  Janosch Frank <frankja@linux.ibm.com>
> @@ -47,6 +47,7 @@
>   #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>   #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>   #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
> +#define UVC_CMD_ATTESTATION		0x1020
>   
>   /* Bits in installed uv calls */
>   enum uv_cmds_inst {
> @@ -71,6 +72,7 @@ enum uv_cmds_inst {
>   	BIT_UVC_CMD_UNSHARE_ALL = 20,
>   	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>   	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_ATTESTATION = 28,
>   };
>   
>   struct uv_cb_header {
> @@ -178,6 +180,25 @@ struct uv_cb_cfs {
>   	u64 paddr;
>   }  __attribute__((packed))  __attribute__((aligned(8)));
>   
> +/* Retrieve Attestation Measurement */
> +struct uv_cb_attest {
> +	struct uv_cb_header header;	/* 0x0000 */
> +	uint64_t reserved08[2];		/* 0x0008 */
> +	uint64_t arcb_addr;		/* 0x0018 */
> +	uint64_t continuation_token;	/* 0x0020 */
> +	uint8_t  reserved28[6];		/* 0x0028 */
> +	uint16_t user_data_length;	/* 0x002e */
> +	uint8_t  user_data[256];	/* 0x0030 */
> +	uint32_t reserved130[3];	/* 0x0130 */
> +	uint32_t measurement_length;	/* 0x013c */
> +	uint64_t measurement_address;	/* 0x0140 */
> +	uint8_t config_uid[16];		/* 0x0148 */
> +	uint32_t reserved158;		/* 0x0158 */
> +	uint32_t add_data_length;	/* 0x015c */
> +	uint64_t add_data_address;	/* 0x0160 */
> +	uint64_t reserved168[4];	/* 0x0168 */
> +}  __attribute__((packed))  __attribute__((aligned(8)));
> +
>   /* Set Secure Config Parameter */
>   struct uv_cb_ssc {
>   	struct uv_cb_header header;
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index de2e4850..fe49d7b9 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -418,6 +418,7 @@ static struct cmd_list invalid_cmds[] = {
>   	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1},
>   	{ "share", UVC_CMD_SET_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_SET_SHARED_ACCESS },
>   	{ "unshare", UVC_CMD_REMOVE_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_REMOVE_SHARED_ACCESS },
> +	{ "attest", UVC_CMD_ATTESTATION, sizeof(struct uv_cb_attest), BIT_UVC_CMD_ATTESTATION },
>   	{ NULL, 0, 0 },
>   };
>   

