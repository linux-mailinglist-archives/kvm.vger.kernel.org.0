Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4D546647F
	for <lists+kvm@lfdr.de>; Thu,  2 Dec 2021 14:28:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346704AbhLBNcC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 08:32:02 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48506 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241991AbhLBNcA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 2 Dec 2021 08:32:00 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B2DPM8M019247;
        Thu, 2 Dec 2021 13:28:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fDDoy6CKl0ycD0i6SD1WVxS/anA8U5NOZficqaVDAaQ=;
 b=BAc602Jr/5Wi6E1n4NVYJ1nF84uPiGsUB6wOKmU239o1XUzkKlnGrGDLidZ/N8Nm/ISa
 o1EPSwZcFO0rtKMrQKrH0AwysMVLQ1JlgO0Jg6jy2vW4N8ydj8u34hTTUzCzbKmJSSNl
 Pj1vSyK2dLYnY5AYm+PhvZGJtKq+q06cT7wmjitjo+DBJVlSetWoUxTl4SuutXKAXYX6
 FAHyIgpvzmDvVoTvaVDBpdyByy4/H2T/Uctgd74IKLb7zlVJQDsth6cK7FAuh+RDoGNA
 c9KpRWzBvwLM3r0L1gsRyDxA5Jqp/V8Bl2h5Y3cAohz6LnZ79aeWS2xz7IizAVv4jRlR DA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpxf48sn0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:28:38 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B2DPRhK019849;
        Thu, 2 Dec 2021 13:28:37 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cpxf48smk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:28:37 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B2DRAuf023348;
        Thu, 2 Dec 2021 13:28:35 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma06fra.de.ibm.com with ESMTP id 3ckbxkaadh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 02 Dec 2021 13:28:35 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B2DSVu228115418
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 2 Dec 2021 13:28:32 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D433352051;
        Thu,  2 Dec 2021 13:28:31 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.8.140])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 864F252050;
        Thu,  2 Dec 2021 13:28:31 +0000 (GMT)
Date:   Thu, 2 Dec 2021 14:28:29 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH] s390x: uv: Fix UVC cmd prepare reset
 name
Message-ID: <20211202142829.087c8650@p-imbrenda>
In-Reply-To: <20211202131122.2948-1-frankja@linux.ibm.com>
References: <20211202131122.2948-1-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: H4PShoar-yGRfTxIcUHE8m-CG5raStxS
X-Proofpoint-GUID: xKRPdLP_zHEzADCokPds_o7wNZrov_If
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-12-02_07,2021-12-02_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112020084
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  2 Dec 2021 13:11:22 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> The specification and the kernel use UVC_CMD_PREPARE_RESET so let's
> fix our naming up.
> 
> The call bit is named correctly but is not the same as the name we use
> on KVM. So let's clear that up too.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/uv.h | 4 ++--
>  s390x/uv-guest.c   | 2 +-
>  s390x/uv-host.c    | 2 +-
>  3 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/s390x/asm/uv.h b/lib/s390x/asm/uv.h
> index 97c90e81..70bf65c4 100644
> --- a/lib/s390x/asm/uv.h
> +++ b/lib/s390x/asm/uv.h
> @@ -39,7 +39,7 @@
>  #define UVC_CMD_VERIFY_IMG		0x0302
>  #define UVC_CMD_CPU_RESET		0x0310
>  #define UVC_CMD_CPU_RESET_INITIAL	0x0311
> -#define UVC_CMD_PERF_CONF_CLEAR_RESET	0x0320
> +#define UVC_CMD_PREPARE_RESET		0x0320
>  #define UVC_CMD_CPU_RESET_CLEAR		0x0321
>  #define UVC_CMD_CPU_SET_STATE		0x0330
>  #define UVC_CMD_SET_UNSHARED_ALL	0x0340
> @@ -66,7 +66,7 @@ enum uv_cmds_inst {
>  	BIT_UVC_CMD_CPU_RESET = 15,
>  	BIT_UVC_CMD_CPU_RESET_INITIAL = 16,
>  	BIT_UVC_CMD_CPU_SET_STATE = 17,
> -	BIT_UVC_CMD_PREPARE_CLEAR_RESET = 18,
> +	BIT_UVC_CMD_PREPARE_RESET = 18,
>  	BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET = 19,
>  	BIT_UVC_CMD_UNSHARE_ALL = 20,
>  	BIT_UVC_CMD_PIN_PAGE_SHARED = 21,
> diff --git a/s390x/uv-guest.c b/s390x/uv-guest.c
> index 44ad2154..99120cae 100644
> --- a/s390x/uv-guest.c
> +++ b/s390x/uv-guest.c
> @@ -142,7 +142,7 @@ static struct {
>  	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
>  	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
>  	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
> -	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
> +	{ "prepare clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
>  	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
>  	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
>  	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },
> diff --git a/s390x/uv-host.c b/s390x/uv-host.c
> index 92a41069..de2e4850 100644
> --- a/s390x/uv-host.c
> +++ b/s390x/uv-host.c
> @@ -55,7 +55,7 @@ static struct cmd_list cmds[] = {
>  	{ "verify", UVC_CMD_VERIFY_IMG, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_VERIFY_IMG },
>  	{ "cpu reset", UVC_CMD_CPU_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET },
>  	{ "cpu initial reset", UVC_CMD_CPU_RESET_INITIAL, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_RESET_INITIAL },
> -	{ "conf clear reset", UVC_CMD_PERF_CONF_CLEAR_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_CLEAR_RESET },
> +	{ "conf clear reset", UVC_CMD_PREPARE_RESET, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_PREPARE_RESET },
>  	{ "cpu clear reset", UVC_CMD_CPU_RESET_CLEAR, sizeof(struct uv_cb_nodata), BIT_UVC_CMD_CPU_PERFORM_CLEAR_RESET },
>  	{ "cpu set state", UVC_CMD_CPU_SET_STATE, sizeof(struct uv_cb_cpu_set_state), BIT_UVC_CMD_CPU_SET_STATE },
>  	{ "pin shared", UVC_CMD_PIN_PAGE_SHARED, sizeof(struct uv_cb_cfs), BIT_UVC_CMD_PIN_PAGE_SHARED },

