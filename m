Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D4F84A8A45
	for <lists+kvm@lfdr.de>; Thu,  3 Feb 2022 18:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352942AbiBCRiT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Feb 2022 12:38:19 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:12790 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1352920AbiBCRiS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 3 Feb 2022 12:38:18 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 213GhUKC006797;
        Thu, 3 Feb 2022 17:38:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=UH8KPZHWVL/SjLef9PLK9/+V9aDWQdeyPcNJOCWgfas=;
 b=HWjdkOZ5Hop3y2XlWFHrw7f0uuJd+9XTqTTMHzwK4wbh2r3Xrtlf9rHUmN0GANslA/uS
 bjevYXbO1ISXaM1UN0afUn3LaFk+Ew52ABzM+DukECD26imJG2OU91SY9cYvv2dDTZfW
 AjAE0WULsA6hozuHPtMQ2C1/8h7axnESWQkhNKng0ykDBdvtVekvyaaaARD0PMMlkMrk
 XirhKR+tyshreF5vzHC10g86JbxctFK9x0BlovfNOoiaZd7q3HcBWUIDtvF1O6FOIMc3
 iPCxKYU0w4md1VcynMLGwC0FVDOGctVTIdj9bGkSQVkYod7MOtvcxZlcjHVspcL2wOTN qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyygrg8h5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:17 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 213HH5XP024209;
        Thu, 3 Feb 2022 17:38:17 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dyygrg8gr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:17 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 213HXBlF017941;
        Thu, 3 Feb 2022 17:38:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma02fra.de.ibm.com with ESMTP id 3dvw79xpf5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Feb 2022 17:38:14 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 213HSF7q48628168
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 3 Feb 2022 17:28:15 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2C3BFA4057;
        Thu,  3 Feb 2022 17:38:09 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B1285A404D;
        Thu,  3 Feb 2022 17:38:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.1.135])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  3 Feb 2022 17:38:08 +0000 (GMT)
Date:   Thu, 3 Feb 2022 17:37:39 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Steffen Eiden <seiden@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 1/4] s390x: uv-host: Add attestation
 test
Message-ID: <20220203173739.2b3b7d1e@p-imbrenda>
In-Reply-To: <20220203091935.2716-2-seiden@linux.ibm.com>
References: <20220203091935.2716-1-seiden@linux.ibm.com>
 <20220203091935.2716-2-seiden@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: B8dpBd6y6Pim16T_jK08sZQR9FkLAvV_
X-Proofpoint-GUID: aRAk8IHmC-a4MMutM0eOL9aR0HxODuxS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-03_06,2022-02-03_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 malwarescore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 priorityscore=1501 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202030106
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  3 Feb 2022 09:19:32 +0000
Steffen Eiden <seiden@linux.ibm.com> wrote:

> Adds an invalid command test for attestation in the uv-host.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> Reviewed-by: Janosch Frank <frankja@linux.ibm.com>
>
> ---
>  lib/s390x/asm/uv.h | 23 ++++++++++++++++++++++-
>  s390x/uv-host.c    |  1 +
>  2 files changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 97c90e81..7afbcffd 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -1,7 +1,7 @@
>  /*
>   * s390x Ultravisor related definitions
>   *
> - * Copyright (c) 2020 IBM Corp
> + * Copyright IBM Corp. 2020, 2022
>   *
>   * Authors:
>   *  Janosch Frank <frankja@linux.ibm.com>
> @@ -47,6 +47,7 @@
>  #define UVC_CMD_UNPIN_PAGE_SHARED	0x0342
>  #define UVC_CMD_SET_SHARED_ACCESS	0x1000
>  #define UVC_CMD_REMOVE_SHARED_ACCESS	0x1001
> +#define UVC_CMD_ATTESTATION		0x1020
>  
>  /* Bits in installed uv calls */
>  enum uv_cmds_inst {
> @@ -71,6 +72,7 @@ enum uv_cmds_inst {
>  	BIT_UVC_CMD_UNSHARE_ALL = 20,
>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
>  	BIT_UVC_CMD_UNPIN_PAGE_SHARED = 22,
> +	BIT_UVC_CMD_ATTESTATION = 28,
>  };
>  
>  struct uv_cb_header {
> @@ -178,6 +180,25 @@ struct uv_cb_cfs {
>  	u64 paddr;
>  }  __attribute__((packed))  __attribute__((aligned(8)));
>  
> +/* Retrieve Attestation Measurement */
> +struct uv_cb_attest {
> +	struct uv_cb_header header;	/* 0x0000 */
> +	u64 reserved08[2];		/* 0x0008 */
> +	u64 arcb_addr;			/* 0x0018 */
> +	u64 continuation_token;		/* 0x0020 */
> +	u8  reserved28[6];		/* 0x0028 */
> +	u16 user_data_length;		/* 0x002e */
> +	u8  user_data[256];		/* 0x0030 */
> +	u32 reserved130[3];		/* 0x0130 */
> +	u32 measurement_length;		/* 0x013c */
> +	u64 measurement_address;	/* 0x0140 */
> +	u8 config_uid[16];		/* 0x0148 */
> +	u32 reserved158;		/* 0x0158 */
> +	u32 add_data_length;		/* 0x015c */
> +	u64 add_data_address;		/* 0x0160 */
> +	u64 reserved168[4];		/* 0x0168 */

please use uint*_t types!

with that fixed: 

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> +}  __attribute__((packed))  __attribute__((aligned(8)));
> +
>  /* Set Secure Config Parameter */
>  struct uv_cb_ssc {
>  	struct uv_cb_header header;
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 92a41069..946f031e 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -418,6 +418,7 @@ static struct cmd_list invalid_cmds[] = {
>  	{ "bogus", 0x4242, sizeof(struct uv_cb_header), -1},
>  	{ "share", UVC_CMD_SET_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_SET_SHARED_ACCESS },
>  	{ "unshare", UVC_CMD_REMOVE_SHARED_ACCESS, sizeof(struct uv_cb_share), BIT_UVC_CMD_REMOVE_SHARED_ACCESS },
> +	{ "attest", UVC_CMD_ATTESTATION, sizeof(struct uv_cb_attest), BIT_UVC_CMD_ATTESTATION },
>  	{ NULL, 0, 0 },
>  };
>  

