Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6CC4F7BFC
	for <lists+kvm@lfdr.de>; Thu,  7 Apr 2022 11:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243898AbiDGJpc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 05:45:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238354AbiDGJp1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 05:45:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E588203A59;
        Thu,  7 Apr 2022 02:43:27 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2377LZcr005634;
        Thu, 7 Apr 2022 09:43:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=/QXVflmAhP8Jz6pH2Q/UYx3aefzfsRXHOvjWovUq7EA=;
 b=f+ErLNhiVlA6Ko3gTpFLr/XHHK0gsLXHBaMj1LW1H5cLxBiynXH9Hof0Gphshy/0voYK
 sQZVPat0yJRqsSHYtBpkIvuEfCPZEW61VaGSZjhLVs7pIEVbq8VqFN9QtBfio3C6QOgX
 cyBUuZ5Pdaq1jhNuG+0yy6HERLRQvrdKSGXA0EPJniyM2W/Tz8Xb2nZYlE2pq2I6a01m
 jMDOvTfbXH3PJqp84VEVi30Dwx/kGHcsd/eO+QDRD6tt62Add7fNiGX3Jkp9fTq8LbZo
 Vs4NBRLTTnZhO8S/ZkIZKjnGf8XrRYcaRM9LT22ky+hjqqd+wG2GyBV4V/cXILvZbMK0 nQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugfanv2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:27 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 2379WjMH002014;
        Thu, 7 Apr 2022 09:43:26 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3f9ugfanu7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:26 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2379RHlj012725;
        Thu, 7 Apr 2022 09:43:24 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3f6e48qv33-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 09:43:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2379hLsk55640466
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 7 Apr 2022 09:43:21 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1E70E11C054;
        Thu,  7 Apr 2022 09:43:21 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A928D11C050;
        Thu,  7 Apr 2022 09:43:20 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.5.20])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  7 Apr 2022 09:43:20 +0000 (GMT)
Date:   Thu, 7 Apr 2022 11:40:01 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v2 2/9] s390x: css: Skip if we're not run
 by qemu
Message-ID: <20220407114001.784dd0e5@p-imbrenda>
In-Reply-To: <20220407084421.2811-3-frankja@linux.ibm.com>
References: <20220407084421.2811-1-frankja@linux.ibm.com>
        <20220407084421.2811-3-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: QE6M5re7b9caTid_wQXjOwAa1up6PmcM
X-Proofpoint-ORIG-GUID: gM-t_0CTobNyzIqQ0yOUAp_gYFB3Fm6f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-06_13,2022-04-06_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 phishscore=0 suspectscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 lowpriorityscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204070048
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  7 Apr 2022 08:44:14 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> There's no guarantee that we even find a device at the address we're
> testing for if we're not running under QEMU.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/css.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index a333e55a..13a1509f 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -15,6 +15,7 @@
>  #include <interrupt.h>
>  #include <asm/arch_def.h>
>  #include <alloc_page.h>
> +#include <hardware.h>
>  
>  #include <malloc_io.h>
>  #include <css.h>
> @@ -642,13 +643,21 @@ int main(int argc, char *argv[])
>  	int i;
>  
>  	report_prefix_push("Channel Subsystem");
> +
> +	/* There's no guarantee where our devices are without qemu */
> +	if (!host_is_qemu()) {
> +		report_skip("Not running under QEMU");
> +		goto done;
> +	}
> +
>  	enable_io_isc(0x80 >> IO_SCH_ISC);
>  	for (i = 0; tests[i].name; i++) {
>  		report_prefix_push(tests[i].name);
>  		tests[i].func();
>  		report_prefix_pop();
>  	}
> -	report_prefix_pop();
>  
> +done:
> +	report_prefix_pop();
>  	return report_summary();
>  }

