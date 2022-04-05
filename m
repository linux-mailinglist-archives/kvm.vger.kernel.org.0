Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83CB44F3AEF
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244886AbiDELuM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380301AbiDELm1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:27 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE8C108776;
        Tue,  5 Apr 2022 04:06:07 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 235920S9003825;
        Tue, 5 Apr 2022 11:06:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=iPqYQgjQbDTI6PEyLKoC19+rQC4xx9kDP5jj3ZLgsYw=;
 b=FAOsLuKYDRLtdWdckfnE7ctkNUj2uAfr7LJmTURi1JWRzZmHIhZ7TXTx3UPSh06tJDsP
 YDbwyLAlaRBEGDnWNtxke3fWVcdh+4RJSGMYL2TQg0Gxq1BIcFrrmp5hQB/zLDxTCc+w
 A1qdHHo9+XRBzXkh0NRVOJD08kWUrQtAc/F5CwViIgJSLj2vmFLTi/poEj2Ib66m6pXb
 tBghHtHOBGi4Qqw396Vhrv1RjbtByPlZo3KPQEsdluC+hWbpWhwaYdle2ejsuCagybS0
 enpQzbpWOHo6Mogn9kcLii9JipONKqQ1+18vlC/FswOusNZG4X+xrCsqUpH6h4sUILeK eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv70jb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:06 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235AtRvX014082;
        Tue, 5 Apr 2022 11:06:05 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f6yv70jag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:05 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B37mS027162;
        Tue, 5 Apr 2022 11:06:04 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma01fra.de.ibm.com with ESMTP id 3f6e48vjwn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:03 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235Arlm329360570
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 10:53:47 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ADCB5A4060;
        Tue,  5 Apr 2022 11:06:00 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F2A1A4054;
        Tue,  5 Apr 2022 11:06:00 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:06:00 +0000 (GMT)
Date:   Tue, 5 Apr 2022 13:04:58 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 6/8] s390x: css: Cleanup includes
Message-ID: <20220405130458.50ec1e46@p-imbrenda>
In-Reply-To: <20220405075225.15903-7-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-7-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ms1dzIw1dYetJkRJ5C0YB9de6T_Xp6_v
X-Proofpoint-GUID: uZKGXWMEQUIVzR0zaAZ9kvmA7kqLkJ0i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 lowpriorityscore=0 clxscore=1015 suspectscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 impostorscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204050066
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue,  5 Apr 2022 07:52:23 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Most includes were related to allocation but that's done in the io
> allocation library so having them in the test doesn't make sense.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/css.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/s390x/css.c b/s390x/css.c
> index 52d35f49..9cfcfad4 100644
> --- a/s390x/css.c
> +++ b/s390x/css.c
> @@ -9,17 +9,14 @@
>   */
>  
>  #include <libcflat.h>
> -#include <alloc_phys.h>
> -#include <asm/page.h>
> -#include <string.h>
>  #include <interrupt.h>
> -#include <asm/arch_def.h>
> -#include <alloc_page.h>
>  #include <hardware.h>
>  
> +#include <asm/arch_def.h>
> +#include <asm/page.h>
> +
>  #include <malloc_io.h>
>  #include <css.h>
> -#include <asm/barrier.h>
>  
>  #define DEFAULT_CU_TYPE		0x3832 /* virtio-ccw */
>  static unsigned long cu_type = DEFAULT_CU_TYPE;

