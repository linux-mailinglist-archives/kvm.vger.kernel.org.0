Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A63FE4EDC51
	for <lists+kvm@lfdr.de>; Thu, 31 Mar 2022 17:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237956AbiCaPGd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 31 Mar 2022 11:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237940AbiCaPG3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 31 Mar 2022 11:06:29 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B91131DC6;
        Thu, 31 Mar 2022 08:04:42 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22VE4HLO030730;
        Thu, 31 Mar 2022 15:04:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=O33EKk6MEPMZZ4v7WLay1cwwrotVvoNotFUt+PFvt+g=;
 b=tU6ptp9c5/aEn0mH3DmUb09YLql0ayR8SkKYsIupR5Dplfg5TNTMWpIwINwGq+eL4Dhq
 aZieAURiRpm5Te0Etd/tSuEdjFgIaIxOejwd+aZ8KE7nSd4qpFiGJPymVA/wiImQlc7l
 hAAUfFe/wn2zbIgEjSrcqetpFV/ysYrI6TTwpdYAegCSGFu+0FcW52wLyMMenwNyVWiL
 sgTHc3Fyc/QmV89ox71Xn6Ed9kWXFKsTOBHf2v8idYSOD4TxMe3ugPO/oBio4VYvwG7/
 UTE8EhW9XDX13msOMclwIjFXrPQjxLHuo0tHBs/wAL+JXr1KFk0v/s4UoZc2BNS8/KZN Kw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f58sd8brg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:04:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22VEqZOq008009;
        Thu, 31 Mar 2022 15:04:40 GMT
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3f58sd8bqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:04:40 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
        by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22VF2q5R013863;
        Thu, 31 Mar 2022 15:04:39 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma01fra.de.ibm.com with ESMTP id 3f1tf8sc5j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 15:04:38 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22VF4Zrt39453042
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 31 Mar 2022 15:04:35 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B493A11C05B;
        Thu, 31 Mar 2022 15:04:35 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5058911C050;
        Thu, 31 Mar 2022 15:04:35 +0000 (GMT)
Received: from [9.145.159.108] (unknown [9.145.159.108])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 31 Mar 2022 15:04:35 +0000 (GMT)
Message-ID: <a90856c8-875b-a2a9-a97d-c7cfeba5afd0@linux.ibm.com>
Date:   Thu, 31 Mar 2022 17:04:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: remove spurious includes
Content-Language: en-US
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>, kvm@vger.kernel.org
Cc:     linux-s390@vger.kernel.org, scgl@linux.ibm.com,
        borntraeger@de.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        nrb@linux.ibm.com, thuth@redhat.com, david@redhat.com
References: <20220330144339.261419-1-imbrenda@linux.ibm.com>
 <20220330144339.261419-2-imbrenda@linux.ibm.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220330144339.261419-2-imbrenda@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VZnDRjJCty5x-1oEFYMqbIEQWx49mChp
X-Proofpoint-ORIG-GUID: Zrekwgne80Nw47-o3mk2h-ZtRxUPe5gl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_05,2022-03-31_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 lowpriorityscore=0 adultscore=0 impostorscore=0 mlxlogscore=999 mlxscore=0
 malwarescore=0 priorityscore=1501 clxscore=1015 bulkscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310084
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/30/22 16:43, Claudio Imbrenda wrote:
> Remove unused includes of vm.h

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> 
> Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> ---
>   s390x/mvpg-sie.c    | 1 -
>   s390x/pv-diags.c    | 1 -

I think there are more unused includes in pv-diags.c. I need to take 
another look at that.

>   s390x/spec_ex-sie.c | 1 -
>   3 files changed, 3 deletions(-)
> 
> diff --git a/s390x/mvpg-sie.c b/s390x/mvpg-sie.c
> index 8ae9a52a..46a2edb6 100644
> --- a/s390x/mvpg-sie.c
> +++ b/s390x/mvpg-sie.c
> @@ -16,7 +16,6 @@
>   #include <asm/facility.h>
>   #include <asm/mem.h>
>   #include <alloc_page.h>
> -#include <vm.h>
>   #include <sclp.h>
>   #include <sie.h>
>   #include <snippet.h>
> diff --git a/s390x/pv-diags.c b/s390x/pv-diags.c
> index 110547ad..6899b859 100644
> --- a/s390x/pv-diags.c
> +++ b/s390x/pv-diags.c
> @@ -19,7 +19,6 @@
>   #include <asm/sigp.h>
>   #include <smp.h>
>   #include <alloc_page.h>
> -#include <vm.h>
>   #include <vmalloc.h>
>   #include <sclp.h>
>   #include <snippet.h>
> diff --git a/s390x/spec_ex-sie.c b/s390x/spec_ex-sie.c
> index 5dea4115..d8e25e75 100644
> --- a/s390x/spec_ex-sie.c
> +++ b/s390x/spec_ex-sie.c
> @@ -11,7 +11,6 @@
>   #include <asm/page.h>
>   #include <asm/arch_def.h>
>   #include <alloc_page.h>
> -#include <vm.h>
>   #include <sie.h>
>   #include <snippet.h>
>   

