Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58DC44F3AD5
	for <lists+kvm@lfdr.de>; Tue,  5 Apr 2022 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238393AbiDELtK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Apr 2022 07:49:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380319AbiDELm2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 5 Apr 2022 07:42:28 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E0C7108BDC;
        Tue,  5 Apr 2022 04:06:09 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2358gg6r025603;
        Tue, 5 Apr 2022 11:06:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=r9DZ+eeVwLbg49woOvCrWf024P9XfMU5dPNNDJwnzco=;
 b=tfUAcUq0SvWnpNfEio0GWAGMRWqKs2zmKj3zzT10WbhXqouEfHgZqjJqL1UKqfyMWde4
 R0KDPUgGelGBCfh8m02LeBINw86WxdbHCrXal8iB8uEpg4yeZp1+7IMcInZG1zD7M0Dp
 4pbGw2w+xj+430/T6DWJt7FFu0ht1EKpNVeFXqpvJyhRcHp33Ow8YKyyroTzANHebQk5
 TJlmzZJtmKdrZgJPEcNC1tLJvxPL+swHFrlwZzq2Q+cbeCxFKorTZ4+g8qGjUPIkV/ai
 fHgHUdM9QSG2jGKaPdP/708zZoaVgZZQpvU37i3MeNiAAeZZQgw0V7kXTcLuCfYqk8ju 7w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tcjvh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:08 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 235Aj4L5017019;
        Tue, 5 Apr 2022 11:06:08 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f85tcjvge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:08 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 235B361H022933;
        Tue, 5 Apr 2022 11:06:06 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04fra.de.ibm.com with ESMTP id 3f6e48vkec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Apr 2022 11:06:06 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 235B62If35127772
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Apr 2022 11:06:02 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AD519A4054;
        Tue,  5 Apr 2022 11:06:02 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4F2B4A405C;
        Tue,  5 Apr 2022 11:06:02 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.14.146])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  5 Apr 2022 11:06:02 +0000 (GMT)
Date:   Tue, 5 Apr 2022 13:05:30 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org, david@redhat.com,
        thuth@redhat.com, nrb@linux.ibm.com, seiden@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH 8/8] s390x: mvpg: Cleanup includes
Message-ID: <20220405130530.1a383a11@p-imbrenda>
In-Reply-To: <20220405075225.15903-9-frankja@linux.ibm.com>
References: <20220405075225.15903-1-frankja@linux.ibm.com>
        <20220405075225.15903-9-frankja@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: zOBwiAjlZ1y3Zrca4ZLnXCajhyQteZ5Z
X-Proofpoint-ORIG-GUID: Qk-taQUZ24OvhgBlmk02_LMXIM0l8ULy
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-05_02,2022-04-05_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 phishscore=0 suspectscore=0 lowpriorityscore=0 mlxscore=0
 impostorscore=0 mlxlogscore=952 bulkscore=0 adultscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
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

On Tue,  5 Apr 2022 07:52:25 +0000
Janosch Frank <frankja@linux.ibm.com> wrote:

> Time to remove unneeded includes.
> 
> Signed-off-by: Janosch Frank <frankja@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/mvpg.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/s390x/mvpg.c b/s390x/mvpg.c
> index 62f0fc5a..04e5218f 100644
> --- a/s390x/mvpg.c
> +++ b/s390x/mvpg.c
> @@ -9,15 +9,12 @@
>   */
>  #include <libcflat.h>
>  #include <asm/asm-offsets.h>
> -#include <asm-generic/barrier.h>
>  #include <asm/interrupt.h>
>  #include <asm/pgtable.h>
>  #include <mmu.h>
>  #include <asm/page.h>
>  #include <asm/facility.h>
>  #include <asm/mem.h>
> -#include <asm/sigp.h>
> -#include <smp.h>
>  #include <alloc_page.h>
>  #include <bitops.h>
>  #include <hardware.h>

