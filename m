Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0530349658
	for <lists+kvm@lfdr.de>; Thu, 25 Mar 2021 17:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230062AbhCYQDr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 25 Mar 2021 12:03:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:4202 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229979AbhCYQDS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 25 Mar 2021 12:03:18 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 12PFXmin149707
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=3gVRe2JtEtbVugxrPkXowYipE8z/2LZCTqgDbKeK4uY=;
 b=Xtu8JBmP4eDtyp/QXo/Q3wJtUeSJV/vNAujrjK5s1iEK/OZQPfVZfHUf2J1BGoKeCAW1
 tm8Pclu2vneYnnlO6549yqF3yv2tHsvGcQpXaBZ02zzpj9hX1U3w8fWoslyIGZcg+qYD
 /KUJtlPHDR7AfEoR3OPdME8aZbSUzPjuKxDaKJyQrgBRBjG/qlV2SUUNi1bMnhfWi+CZ
 PzmfliXbXILHo0EdTV+Sqs7Mq2rFJKS0kVuFn8UHeqrXxqF9bURbdoB4aiIRM2m/s2eG
 Lj90yq5UdimT6Xg/Z99eZPpSO4dCQcOp9guz6lSmZ7GGzOWvmDhJB/30h+ZzOF82BBaH 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvav2y02-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:17 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 12PFYroh159464
        for <kvm@vger.kernel.org>; Thu, 25 Mar 2021 12:03:17 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 37gvav2xxm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 12:03:17 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 12PG2Vn0005155;
        Thu, 25 Mar 2021 16:03:15 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 37df68d3ut-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 25 Mar 2021 16:03:15 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 12PG3Cam41550206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 16:03:12 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2AC3442045;
        Thu, 25 Mar 2021 16:03:12 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CF43E42042;
        Thu, 25 Mar 2021 16:03:11 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.2.56])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 25 Mar 2021 16:03:11 +0000 (GMT)
Date:   Thu, 25 Mar 2021 16:00:41 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH v2 2/8] s390x: lib: css: SCSW bit
 definitions
Message-ID: <20210325160041.28516b9b@ibm-vm>
In-Reply-To: <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
References: <1616665147-32084-1-git-send-email-pmorel@linux.ibm.com>
        <1616665147-32084-3-git-send-email-pmorel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-03-25_04:2021-03-24,2021-03-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 impostorscore=0
 malwarescore=0 priorityscore=1501 bulkscore=0 clxscore=1015 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103250112
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 25 Mar 2021 10:39:01 +0100
Pierre Morel <pmorel@linux.ibm.com> wrote:

> We need the SCSW definitions to test clear and halt subchannel.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/css.h | 23 +++++++++++++++++++++++
>  1 file changed, 23 insertions(+)
> 
> diff --git a/lib/s390x/css.h b/lib/s390x/css.h
> index b0de3a3..0058355 100644
> --- a/lib/s390x/css.h
> +++ b/lib/s390x/css.h
> @@ -67,6 +67,29 @@ struct scsw {
>  #define SCSW_SC_PRIMARY		0x00000004
>  #define SCSW_SC_INTERMEDIATE	0x00000008
>  #define SCSW_SC_ALERT		0x00000010
> +#define SCSW_AC_SUSPENDED	0x00000020
> +#define SCSW_AC_DEVICE_ACTIVE	0x00000040
> +#define SCSW_AC_SUBCH_ACTIVE	0x00000080
> +#define SCSW_AC_CLEAR_PEND	0x00000100
> +#define SCSW_AC_HALT_PEND	0x00000200
> +#define SCSW_AC_START_PEND	0x00000400
> +#define SCSW_AC_RESUME_PEND	0x00000800
> +#define SCSW_FC_CLEAR		0x00001000
> +#define SCSW_FC_HALT		0x00002000
> +#define SCSW_FC_START		0x00004000
> +#define SCSW_QDIO_RESERVED	0x00008000
> +#define SCSW_PATH_NON_OP	0x00010000
> +#define SCSW_EXTENDED_CTRL	0x00020000
> +#define SCSW_ZERO_COND		0x00040000
> +#define SCSW_SUPPRESS_SUSP_INT	0x00080000
> +#define SCSW_IRB_FMT_CTRL	0x00100000
> +#define SCSW_INITIAL_IRQ_STATUS	0x00200000
> +#define SCSW_PREFETCH		0x00400000
> +#define SCSW_CCW_FORMAT		0x00800000
> +#define SCSW_DEFERED_CC		0x03000000
> +#define SCSW_ESW_FORMAT		0x04000000
> +#define SCSW_SUSPEND_CTRL	0x08000000
> +#define SCSW_KEY		0xf0000000
>  	uint32_t ctrl;
>  	uint32_t ccw_addr;
>  #define SCSW_DEVS_DEV_END	0x04

