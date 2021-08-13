Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AA53EB2E8
	for <lists+kvm@lfdr.de>; Fri, 13 Aug 2021 10:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239816AbhHMIvQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Aug 2021 04:51:16 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S239799AbhHMIvO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 13 Aug 2021 04:51:14 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17D8XENE167314;
        Fri, 13 Aug 2021 04:50:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=5Tam6L5GF+YkaxAs0SulSAJKk+ROpHne9xG9PtCvyqE=;
 b=CJNLaRc/X5GnelbbFAc9XfbJz/u702fO1/586oMc6GLvqTEM//L7dG31VqG2lTDAaLJC
 NrkNmZ6niaR/xLFFvZuPczogGM/Ltul886yrUcp5CGmJTVFi7IWuZKhjR1hIFCRFw5vf
 n4L++cLMHRpUqN7LAdlSkJffCqHytgTSdViYMV3IV18Y4HNbbRA4HHrVQWwQ5mSWeFJr
 m9HLu1Y6J8BH6sSfgps5Yrnb6NLKJgrzADYsuZx4lAcZH0TB2mZukyyehOhfjfGqc1Yo
 YzVv8JW1t6U5/ysdhle4AVQsgg8g9zTuEqAXviMPNza31m0wI4WpsnxQKJ101Alovibk qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3addp5ujp8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:47 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 17D8f114001427;
        Fri, 13 Aug 2021 04:50:46 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3addp5ujnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 04:50:46 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 17D8l5FD006058;
        Fri, 13 Aug 2021 08:50:45 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3acf0kutdp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 13 Aug 2021 08:50:44 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 17D8ogdo55509342
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 13 Aug 2021 08:50:42 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39FC95204E;
        Fri, 13 Aug 2021 08:50:42 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.9.6])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id EB3CC52054;
        Fri, 13 Aug 2021 08:50:41 +0000 (GMT)
Date:   Fri, 13 Aug 2021 10:20:37 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, cohuck@redhat.com
Subject: Re: [kvm-unit-tests PATCH 2/8] lib: s390x: Add 0x3d, 0x3e and 0x3f
 PGM constants
Message-ID: <20210813102037.74d52111@p-imbrenda>
In-Reply-To: <20210813073615.32837-3-frankja@linux.ibm.com>
References: <20210813073615.32837-1-frankja@linux.ibm.com>
        <20210813073615.32837-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dTrSiETMHe5pUyOySC2MggPJXur3nOaK
X-Proofpoint-GUID: xBGa1hkfkF0mviAc6DSo8kER6L6JDdZa
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-13_03:2021-08-12,2021-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 impostorscore=0
 adultscore=0 phishscore=0 suspectscore=0 mlxscore=0 spamscore=0
 priorityscore=1501 mlxlogscore=999 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2107140000 definitions=main-2108130050
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Aug 2021 07:36:09 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> For UV and format 4 SIE tests we need to handle the following PGM
> exceptions: 0x3d Secure Storage Access (non-secure CPU accesses
> secure storage) 0x3e Non-Secure Storage Access (secure CPU accesses
> non-secure storage) 0x3f Mapping of secure guest is wrong
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  lib/s390x/asm/arch_def.h | 3 +++
>  lib/s390x/interrupt.c    | 3 +++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/lib/s390x/asm/arch_def.h b/lib/s390x/asm/arch_def.h
> index 15cf7d48..4ca02c1d 100644
> --- a/lib/s390x/asm/arch_def.h
> +++ b/lib/s390x/asm/arch_def.h
> @@ -177,6 +177,9 @@ _Static_assert(sizeof(struct lowcore) == 0x1900,
> "Lowcore size"); #define PGM_INT_CODE_REGION_FIRST_TRANS
> 	0x39 #define PGM_INT_CODE_REGION_SECOND_TRANS	0x3a
>  #define PGM_INT_CODE_REGION_THIRD_TRANS		0x3b
> +#define PGM_INT_CODE_SECURE_STOR_ACCESS		0x3d
> +#define PGM_INT_CODE_NON_SECURE_STOR_ACCESS	0x3e
> +#define PGM_INT_CODE_SECURE_STOR_VIOLATION	0x3f
>  #define PGM_INT_CODE_MONITOR_EVENT		0x40
>  #define PGM_INT_CODE_PER			0x80
>  #define PGM_INT_CODE_CRYPTO_OPERATION		0x119
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 785b7355..01ded49d 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
> @@ -115,6 +115,9 @@ static void fixup_pgm_int(struct stack_frame_int
> *stack) case PGM_INT_CODE_REGION_THIRD_TRANS:
>  	case PGM_INT_CODE_PER:
>  	case PGM_INT_CODE_CRYPTO_OPERATION:
> +	case PGM_INT_CODE_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_NON_SECURE_STOR_ACCESS:
> +	case PGM_INT_CODE_SECURE_STOR_VIOLATION:
>  		/* The interrupt was nullified, the old PSW points
> at the
>  		 * responsible instruction. Forward the PSW so we
> don't loop. */

