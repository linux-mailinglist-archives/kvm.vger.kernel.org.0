Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2534B37A9BE
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 16:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhEKOnc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 10:43:32 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:65252 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231681AbhEKOnb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 May 2021 10:43:31 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14BEZLKM181915;
        Tue, 11 May 2021 10:42:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=Pyje8jRIZ5YwHttqBQnmXopZr3LgujmVgjPacEuTfVo=;
 b=TnGz6gB/zu0r/b/b2q1loFEaB4hWAJNPXZ9h+JRjtsY3rx+tYTqJ44eycNpagvZnPcTy
 dPTqn7A6Bi0RWFKpEBifqqFk1EeuqqpMcK9ATkrg3qRHg7VVlUNn3ZJZJQV5iDESbdoO
 GTddLZycZUhwm0b1/7aoak2O7TXp14RG/cfWprsz1LSmKNCkbr1JZ8aq0crHGnQJJsd7
 y+6k1phlriFGnfdnhTWK87RBbCgOv/LO5uK+MmwKEEwcpvyGSNpnVQvY5hAZ53Phvz/f
 GWs7fmRzL132NVv7L3Bww05xHuuEpJ8oCPopARUGL6Iz6DiJZFhtrfIkgsNvZuBPw6bF vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftarbqp1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:24 -0400
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 14BEaAsH186008;
        Tue, 11 May 2021 10:42:24 -0400
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38ftarbqmc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 10:42:24 -0400
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 14BEduHg016600;
        Tue, 11 May 2021 14:42:21 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 38dj989qud-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 May 2021 14:42:21 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 14BEfq7o19333504
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 14:41:52 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2E7C11C04A;
        Tue, 11 May 2021 14:42:18 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ADF911C04C;
        Tue, 11 May 2021 14:42:18 +0000 (GMT)
Received: from ibm-vm (unknown [9.145.13.244])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 11 May 2021 14:42:18 +0000 (GMT)
Date:   Tue, 11 May 2021 16:42:02 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, david@redhat.com, cohuck@redhat.com,
        linux-s390@vger.kernel.org, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH 3/4] s390x: cpumodel: FMT4 SCLP test
Message-ID: <20210511164202.0049c1a0@ibm-vm>
In-Reply-To: <20210510150015.11119-4-frankja@linux.ibm.com>
References: <20210510150015.11119-1-frankja@linux.ibm.com>
        <20210510150015.11119-4-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: T-7PZLuejSLZWEmt-m4WXRb9InlRnRF_
X-Proofpoint-ORIG-GUID: 98pXpknhH_fPZ9mIf-5S2OWt9MYpqb51
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-11_02:2021-05-11,2021-05-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0
 suspectscore=0 spamscore=0 mlxscore=0 priorityscore=1501 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 10 May 2021 15:00:14 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> SCLP is also part of the cpumodel, so we need to make sure that the
> features indicated via read info / read cpu info are correct.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/cpumodel.c | 59
> +++++++++++++++++++++++++++++++++++++++++++++++- 1 file changed, 58
> insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/cpumodel.c b/s390x/cpumodel.c
> index 4dd8b96f..619c3dc7 100644
> --- a/s390x/cpumodel.c
> +++ b/s390x/cpumodel.c
> @@ -2,14 +2,69 @@
>  /*
>   * Test the known dependencies for facilities
>   *
> - * Copyright 2019 IBM Corp.
> + * Copyright 2019, 2021 IBM Corp.
>   *
>   * Authors:
>   *    Christian Borntraeger <borntraeger@de.ibm.com>
> + *    Janosch Frank <frankja@linux.ibm.com>
>   */
>  
>  #include <asm/facility.h>
>  #include <vm.h>
> +#include <sclp.h>
> +#include <uv.h>
> +#include <asm/uv.h>
> +
> +static void test_sclp_missing_sief2_implications(void)
> +{
> +	/* Virtualization related facilities */
> +	report(!sclp_facilities.has_64bscao, "!64bscao");
> +	report(!sclp_facilities.has_pfmfi, "!pfmfi");
> +	report(!sclp_facilities.has_gsls, "!gsls");
> +	report(!sclp_facilities.has_cmma, "!cmma");
> +	report(!sclp_facilities.has_esca, "!esca");
> +	report(!sclp_facilities.has_kss, "!kss");
> +	report(!sclp_facilities.has_ibs, "!ibs");
> +
> +	/* Virtualization related facilities reported via CPU
> entries */
> +	report(!sclp_facilities.has_sigpif, "!sigpif");
> +	report(!sclp_facilities.has_sief2, "!sief2");
> +	report(!sclp_facilities.has_skeyi, "!skeyi");
> +	report(!sclp_facilities.has_siif, "!siif");
> +	report(!sclp_facilities.has_cei, "!cei");
> +	report(!sclp_facilities.has_ib, "!ib");
> +}
> +
> +static void test_sclp_features_fmt4(void)
> +{
> +	/*
> +	 * STFLE facilities are handled by the Ultravisor but SCLP
> +	 * facilities are advertised by the hypervisor.
> +	 */
> +	report_prefix_push("PV guest implies");
> +
> +	/* General facilities */
> +	report(!sclp_facilities.has_diag318, "!diag318");
> +
> +	/*
> +	 * Virtualization related facilities, all of which are
> +	 * unavailable because there's no virtualization support in a
> +	 * protected guest.
> +	 */
> +	test_sclp_missing_sief2_implications();
> +
> +	report_prefix_pop();
> +}
> +
> +static void test_sclp_features(void)
> +{
> +	report_prefix_push("sclp");
> +
> +	if (uv_os_is_guest())
> +		test_sclp_features_fmt4();
> +
> +	report_prefix_pop();
> +}
>  
>  static struct {
>  	int facility;
> @@ -60,6 +115,8 @@ int main(void)
>  	}
>  	report_prefix_pop();
>  
> +	test_sclp_features();
> +
>  	report_prefix_pop();
>  	return report_summary();
>  }

