Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18595722618
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 14:39:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbjFEMji (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 08:39:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232924AbjFEMjf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 08:39:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BB81A1;
        Mon,  5 Jun 2023 05:39:34 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 355CGkXw003839;
        Mon, 5 Jun 2023 12:39:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : to : cc : references : from : subject : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=E66XeiwmOkh+c6855Qhsf1UQLKfUMHAjv3cY+q0Hu7E=;
 b=if/rjP84XTqrQZXm8+RJtcJgYsXdki54QVpIKpP9wToFXeNEn6AlxMqPImf4rZ7YNc5q
 ZPlS6Dp9J2rGHVFijZTqWjezWm6EblF+icn63t27S6NF6bq0xnzU8xpa7l275aQlzp2f
 PR0RgSTFLZJE0Cs1DO3JY5NQZGpEHS97hXx2WkH7FPfGw1nLSjmQ1eNRkC5uKeo0K24u
 +MyqZTr/Z4feWYh+M1Jxgr301sqe8doitHixHZQJOq/cZ4T/86WjDr+oXcHBYtZFNCZh
 Z9cgMKty5Gm5HsjFjuEf4rzL3hlrre/dAW2w1UFhVKZ+XNr0AlUFF7rC4WB6uwW7qrKo nQ== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3r1fju0mtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 12:39:33 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3558ZbGN023557;
        Mon, 5 Jun 2023 12:39:31 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3qyx5q92mh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 05 Jun 2023 12:39:31 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 355CdRN518809380
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 5 Jun 2023 12:39:27 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C8AB42004F;
        Mon,  5 Jun 2023 12:39:27 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44B7320040;
        Mon,  5 Jun 2023 12:39:27 +0000 (GMT)
Received: from [9.171.39.161] (unknown [9.171.39.161])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  5 Jun 2023 12:39:27 +0000 (GMT)
Message-ID: <ddb1e8bf-fb4d-0899-3884-15be2d34c852@linux.ibm.com>
Date:   Mon, 5 Jun 2023 14:39:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
To:     Steffen Eiden <seiden@linux.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Viktor Mihajlovski <mihajlov@linux.ibm.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Hendrik Brueckner <brueckner@linux.ibm.com>
References: <20230519093708.810957-1-seiden@linux.ibm.com>
 <20230519093708.810957-2-seiden@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 1/6] s390/uvdevice: Add info IOCTL
In-Reply-To: <20230519093708.810957-2-seiden@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: q5TAtzMyJrjH5SN3W9TvahBTJzE979cy
X-Proofpoint-ORIG-GUID: q5TAtzMyJrjH5SN3W9TvahBTJzE979cy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-03_08,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 suspectscore=0 priorityscore=1501 spamscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306050110
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/23 11:37, Steffen Eiden wrote:
> Add an IOCTL that allows userspace to find out which IOCTLs the uvdevice
> supports without trial and error.
> 
> Explicitly expose the IOCTL nr for the request types.
> 
> Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
> ---
[...]
>   #endif /* __S390_ASM_UVDEVICE_H */
> diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
> index 1d40457c7b10..61c7f284c5c5 100644
> --- a/drivers/s390/char/uvdevice.c
> +++ b/drivers/s390/char/uvdevice.c
> @@ -20,6 +20,7 @@
>    *  channel for userspace to the Ultravisor.
>    */
>   
> +#include "asm-generic/ioctl.h"
>   #include <linux/module.h>
>   #include <linux/kernel.h>
>   #include <linux/miscdevice.h>
> @@ -32,6 +33,51 @@
>   #include <asm/uvdevice.h>
>   #include <asm/uv.h>
>   
> +/* Mapping from IOCTL-nr to UVC-bit */
> +static const u64 ioctl_nr_to_uvc_bit[] __initconst = {

This can be u32 since cmds are u16.

> +	[UVIO_IOCTL_UVDEV_INFO_NR] = -1UL,

#define BIT_UVIO_INTERNAL U32_MAX

> +	[UVIO_IOCTL_ATT_NR] = BIT_UVC_CMD_RETR_ATTEST,
> +};
> +
> +static_assert(ARRAY_SIZE(ioctl_nr_to_uvc_bit) == UVIO_IOCTL_NUM_IOCTLS);
> +
> +static struct uvio_uvdev_info uvdev_info = {
> +	.supp_uvio_cmds = GENMASK_ULL(UVIO_IOCTL_NUM_IOCTLS - 1, 0),
> +};
> +
> +static void __init set_supp_uv_cmds(struct uvio_uvdev_info *info)
> +{
> +	int i;
> +
> +	for (i = 0; i < UVIO_IOCTL_NUM_IOCTLS; i++) {
> +		if (ioctl_nr_to_uvc_bit[i] == -1UL)

BIT_UVIO_INTERNAL

> +			continue;
> +		if (!test_bit_inv(ioctl_nr_to_uvc_bit[i], uv_info.inst_calls_list))
> +			continue;
> +		__set_bit(i, (unsigned long *)&info->supp_uv_cmds);

Move the cast to the caller and make this function take a "unsigned long 
*)" argument.

> +	}
> +}
> +
> +/**
> + * uvio_uvdev_info() - get information about the uvdevice
> + *
> + * @uv_ioctl: ioctl control block
> + *
> + * Lists all supported IOCTLs by this uvdevice

Lists all IOCTLs that are supported by this uvdevice

[...]

Rest seems fine to me.
