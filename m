Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 844FF3D3E99
	for <lists+kvm@lfdr.de>; Fri, 23 Jul 2021 19:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231621AbhGWQpN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Jul 2021 12:45:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54068 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231462AbhGWQpM (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 23 Jul 2021 12:45:12 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16NH3Xjp033348;
        Fri, 23 Jul 2021 13:25:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=B+7h+NbnSiCg0iK2RpxEi1MZVNVf/G4treNgytltwmM=;
 b=H2CYQe1xUdyRCed5HY5EHQC3y8I3iePs8U5lAB+mRd4zVhIR1tmdOocAEerRH5qltZmH
 7CHO5hA6W26COBx1Avb8tbR99VK7UtZ0HCVRjTSr5S75XIiOshNCaTpzi4AY7n8Q4dqd
 589Guo6kI/zNO3WYBHNABWBf/nElPei1gQ6Sj06u9RlE/BvSu24LHJfexUj88r+E310I
 w2mzpn/lffD3Yt7yIK6qlZiRv/o1EM++PZEyxxiNmuD4IQspdE8lC/sra4x/lytRMK3V
 6g6USPUuOs4CK6R47hwq39ox0ODBZjceRCgL0T9CXq9xwnz+ZyYEiIELPFqrqv1DxnQg Ag== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yy0hx70k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:45 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 16NHObkZ108172;
        Fri, 23 Jul 2021 13:25:45 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 39yy0hx702-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 13:25:45 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 16NHJHq9002718;
        Fri, 23 Jul 2021 17:25:43 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma03ams.nl.ibm.com with ESMTP id 39upu8b5s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 17:25:42 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 16NHNCOm26214832
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Jul 2021 17:23:12 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AD7A52051;
        Fri, 23 Jul 2021 17:25:40 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.87])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 38C515204E;
        Fri, 23 Jul 2021 17:25:40 +0000 (GMT)
Date:   Fri, 23 Jul 2021 19:22:16 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 4/5] lib: s390x: uv: Add offset comments
 to uv_query and extend it
Message-ID: <20210723192216.0f7c9fdb@p-imbrenda>
In-Reply-To: <20210629133322.19193-5-frankja@linux.ibm.com>
References: <20210629133322.19193-1-frankja@linux.ibm.com>
        <20210629133322.19193-5-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9RSL_zhCn_KETMQNv1_SDobLUtBMzXrY
X-Proofpoint-ORIG-GUID: 4-l0Pg3MbqhYS0pdEELrWkLG_qNhDpy2
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_09:2021-07-23,2021-07-23 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 impostorscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 mlxlogscore=999 suspectscore=0 priorityscore=1501 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2107230102
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 29 Jun 2021 13:33:21 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The struct is getting longer, let's add offset comments so we know
> where we change things when we add struct members.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

with reserveda0 fixed:

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/uv.h | 33 +++++++++++++++++----------------
>  1 file changed, 17 insertions(+), 16 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 96a2a7e..5ff98b8 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -86,22 +86,23 @@ struct uv_cb_init {
>  } __attribute__((packed))  __attribute__((aligned(8)));
>  
>  struct uv_cb_qui {
> -	struct uv_cb_header header;
> -	uint64_t reserved08;
> -	uint64_t inst_calls_list[4];
> -	uint64_t reserved30[2];
> -	uint64_t uv_base_stor_len;
> -	uint64_t reserved48;
> -	uint64_t conf_base_phys_stor_len;
> -	uint64_t conf_base_virt_stor_len;
> -	uint64_t conf_virt_var_stor_len;
> -	uint64_t cpu_stor_len;
> -	uint32_t reserved70[3];
> -	uint32_t max_num_sec_conf;
> -	uint64_t max_guest_stor_addr;
> -	uint8_t  reserved88[158 - 136];
> -	uint16_t max_guest_cpus;
> -	uint8_t  reserveda0[200 - 160];
> +	struct uv_cb_header header;		/* 0x0000 */
> +	uint64_t reserved08;			/* 0x0008 */
> +	uint64_t inst_calls_list[4];		/* 0x0010 */
> +	uint64_t reserved30[2];			/* 0x0030 */
> +	uint64_t uv_base_stor_len;		/* 0x0040 */
> +	uint64_t reserved48;			/* 0x0048 */
> +	uint64_t conf_base_phys_stor_len;	/* 0x0050 */
> +	uint64_t conf_base_virt_stor_len;	/* 0x0058 */
> +	uint64_t conf_virt_var_stor_len;	/* 0x0060 */
> +	uint64_t cpu_stor_len;			/* 0x0068 */
> +	uint32_t reserved70[3];			/* 0x0070 */
> +	uint32_t max_num_sec_conf;		/* 0x007c */
> +	uint64_t max_guest_stor_addr;		/* 0x0080 */
> +	uint8_t  reserved88[158 - 136];		/* 0x0088 */
> +	uint16_t max_guest_cpus;		/* 0x009e */
> +	uint64_t uv_feature_indications;	/* 0x00a0 */
> +	uint8_t  reserveda0[200 - 168];		/* 0x00a8 */
>  }  __attribute__((packed))  __attribute__((aligned(8)));
>  
>  struct uv_cb_cgc {

