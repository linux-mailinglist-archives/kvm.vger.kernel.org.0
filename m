Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE73A46CEB1
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 09:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244669AbhLHINw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 03:13:52 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45804 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S244653AbhLHINu (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 03:13:50 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B86N7w9022178;
        Wed, 8 Dec 2021 08:10:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Yov6zh/U1Si+vqKskjQnhGfHU9BznGr/TOyvV0YNvQY=;
 b=qfyYWu4qrclCWWyS/pYKDM9nRpa0xqzXStrET8MrDsDVY89/mgwg9hqOTPboDgns6jif
 hDcTSX1AnqmSdgRXNfirDajkATIfxSFZB/zD71Igj5Bu+8lGcBZpjLVxUPwvIR8pg3jw
 RsvR0ViJr+sG/JDZjJZjte75FlDjc0nFlQ6dOYRnl7gVylpIMPyykwfhCdeY4Zre+Wrk
 Os24DYc57B8Z+tLLq929cMU6eIHxmqNZmUbnuSOOZ7GnFbhjiTAnlwpd08dWA+kO5PGW
 LCB6oynj6KCGLYJu/DcMYOFptN3x9xZUOzr7vQ3npx6+6/fcgaiOnLG/O1DKfz627/Vs Kg== 
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctqd19uc9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 08:10:17 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B889Epi024752;
        Wed, 8 Dec 2021 08:10:15 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3cqyyaw41v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 08:10:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B882T4814483904
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 08:02:29 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 85884A4068;
        Wed,  8 Dec 2021 08:10:11 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2E008A405F;
        Wed,  8 Dec 2021 08:10:11 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.18])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 08:10:11 +0000 (GMT)
Date:   Wed, 8 Dec 2021 09:10:08 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        borntraeger@linux.ibm.com
Subject: Re: [PATCH] s390: uv: Add offset comments to UV query struct
Message-ID: <20211208091008.09874eba@p-imbrenda>
In-Reply-To: <20211207160510.1818-1-frankja@linux.ibm.com>
References: <20211207160510.1818-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: QbGl6heyQSBO0KB4zJ7nhIwEgnJQBaVc
X-Proofpoint-GUID: QbGl6heyQSBO0KB4zJ7nhIwEgnJQBaVc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_03,2021-12-06_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 bulkscore=0 impostorscore=0 adultscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 phishscore=0 priorityscore=1501 lowpriorityscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080054
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  7 Dec 2021 16:05:10 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Changes to the struct are easier to manage with offset comments so
> let's add some.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>
> ---
>  arch/s390/include/asm/uv.h | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index 72d3e49c2860..235bd5cc8289 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -91,23 +91,23 @@ struct uv_cb_header {
>  
>  /* Query Ultravisor Information */
>  struct uv_cb_qui {
> -	struct uv_cb_header header;
> -	u64 reserved08;
> -	u64 inst_calls_list[4];
> -	u64 reserved30[2];
> -	u64 uv_base_stor_len;
> -	u64 reserved48;
> -	u64 conf_base_phys_stor_len;
> -	u64 conf_base_virt_stor_len;
> -	u64 conf_virt_var_stor_len;
> -	u64 cpu_stor_len;
> -	u32 reserved70[3];
> -	u32 max_num_sec_conf;
> -	u64 max_guest_stor_addr;
> -	u8  reserved88[158 - 136];
> -	u16 max_guest_cpu_id;
> -	u64 uv_feature_indications;
> -	u8  reserveda0[200 - 168];
> +	struct uv_cb_header header;		/* 0x0000 */
> +	u64 reserved08;				/* 0x0008 */
> +	u64 inst_calls_list[4];			/* 0x0010 */
> +	u64 reserved30[2];			/* 0x0030 */
> +	u64 uv_base_stor_len;			/* 0x0040 */
> +	u64 reserved48;				/* 0x0048 */
> +	u64 conf_base_phys_stor_len;		/* 0x0050 */
> +	u64 conf_base_virt_stor_len;		/* 0x0058 */
> +	u64 conf_virt_var_stor_len;		/* 0x0060 */
> +	u64 cpu_stor_len;			/* 0x0068 */
> +	u32 reserved70[3];			/* 0x0070 */
> +	u32 max_num_sec_conf;			/* 0x007c */
> +	u64 max_guest_stor_addr;		/* 0x0080 */
> +	u8  reserved88[158 - 136];		/* 0x0088 */
> +	u16 max_guest_cpu_id;			/* 0x009e */
> +	u64 uv_feature_indications;		/* 0x00a0 */
> +	u8  reserveda0[200 - 168];		/* 0x00a8 */

since you're changing stuff, maybe fix the name?
s/reserveda0/reserveda8/

with that fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

>  } __packed __aligned(8);
>  
>  /* Initialize Ultravisor */

