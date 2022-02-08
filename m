Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA6A54ADCCA
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 16:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380554AbiBHPfg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 10:35:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380550AbiBHPfg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 10:35:36 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 869DDC06174F;
        Tue,  8 Feb 2022 07:35:34 -0800 (PST)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 218FB2JA023434;
        Tue, 8 Feb 2022 15:35:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=vECnjka+VlGUIZXpKRpphkhVXpSjuVm4u3VIe1rkdTE=;
 b=KC2WxMIZdstJJV+lzTc7jpNVKmNbDPXkXtuo1I7Ds+E5q+S7aEnMH3UZlruzbytyraJW
 yd9QOah+L9pyQZXAEgNzMOMfzRQQikw3+t6B9tKa1vGfOfCbK511d2oLT4ERUbz8BuAB
 QQD29EbliOns7HWKhPxRrgsEsODmyxZn3Q4ob/iFFw4VSIwlY2hIdJXnXVMn1nJoIIi0
 VEKWbZmxopIZQ1+6+9bC9wa4tML4D15wJeIrpMzHUkYNOJAVBsmIvNmYoK0sWQ7lzaLl
 Yiqh+AWm97NAtxl8RymLXcZKrKVhrak3adpCF9vX8JPP75RF2+aEzw2b04w0Vel9d3Mo 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23apu068-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:35:33 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 218FMxtt007383;
        Tue, 8 Feb 2022 15:35:33 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3e23apu05m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:35:33 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 218FIrbo024522;
        Tue, 8 Feb 2022 15:35:31 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04fra.de.ibm.com with ESMTP id 3e2ygq4yyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 15:35:31 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 218FZPNi42992094
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 8 Feb 2022 15:35:25 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABAD852067;
        Tue,  8 Feb 2022 15:35:25 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.36.227])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 5281D5205A;
        Tue,  8 Feb 2022 15:35:25 +0000 (GMT)
Message-ID: <ea550ac540d29fdf76eb104d05a7016a95f8373b.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/4] s390x: stsi: Define vm_is_kvm to
 be used in different tests
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        cohuck@redhat.com, imbrenda@linux.ibm.com, david@redhat.com
Date:   Tue, 08 Feb 2022 16:35:25 +0100
In-Reply-To: <20220208132709.48291-3-pmorel@linux.ibm.com>
References: <20220208132709.48291-1-pmorel@linux.ibm.com>
         <20220208132709.48291-3-pmorel@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 (3.42.3-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: u5Mlk6WiBu9FiED6umpjm3E79Ss0isKk
X-Proofpoint-ORIG-GUID: mgMxsFRqUtiEWEBLvrIhv_hZKj5X1DYI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_05,2022-02-07_02,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 spamscore=0 priorityscore=1501 clxscore=1015
 mlxlogscore=941 adultscore=0 bulkscore=0 suspectscore=0 impostorscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202080096
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-08 at 14:27 +0100, Pierre Morel wrote:
> We need in several tests to check if the VM we are running in
> is KVM.
> Let's add the test.
> 
> To check the VM type we use the STSI 3.2.2 instruction, let's
> define it's response structure in a central header.
> 
> Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>

> ---
>  lib/s390x/stsi.h | 32 +++++++++++++++++++++++++++
>  lib/s390x/vm.c   | 56
> ++++++++++++++++++++++++++++++++++++++++++++++--
>  lib/s390x/vm.h   |  3 +++
>  s390x/stsi.c     | 23 ++------------------
>  4 files changed, 91 insertions(+), 23 deletions(-)
>  create mode 100644 lib/s390x/stsi.h
> 
> diff --git a/lib/s390x/stsi.h b/lib/s390x/stsi.h
> new file mode 100644
> index 00000000..9b40664f
> --- /dev/null
> +++ b/lib/s390x/stsi.h
> @@ -0,0 +1,32 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */

This was taken from stsi.c which is GPL 2 only, so this probably should
be as well.

> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..38886b76 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -12,6 +12,7 @@
>  #include <alloc_page.h>
>  #include <asm/arch_def.h>
>  #include "vm.h"
> +#include "stsi.h"
>  
>  /**
>   * Detect whether we are running with TCG (instead of KVM)
> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>         if (initialized)
>                 return is_tcg;
>  
> -       buf = alloc_page();
> -       if (!buf)
> +       if (!vm_is_vm()) {
> +               initialized = true;
>                 return false;
> diff --git a/lib/s390x/vm.c b/lib/s390x/vm.c
> index a5b92863..38886b76 100644
> --- a/lib/s390x/vm.c
> +++ b/lib/s390x/vm.c
> @@ -12,6 +12,7 @@
>  #include <alloc_page.h>
>  #include <asm/arch_def.h>
>  #include "vm.h"
> +#include "stsi.h"
>  
>  /**
>   * Detect whether we are running with TCG (instead of KVM)
> @@ -26,9 +27,13 @@ bool vm_is_tcg(void)
>         if (initialized)
>                 return is_tcg;
>  
> -       buf = alloc_page();
> -       if (!buf)
> +       if (!vm_is_vm()) {
> +               initialized = true;
>                 return false;

I would personally prefer return is_tcg here to make it obvious we're
relying on the previous initalization to false for subsequent calls.

> +       }
> +
> +       buf = alloc_page();
> +       assert(buf);
>  
>         if (stsi(buf, 1, 1, 1))
>                 goto out;
> @@ -43,3 +48,50 @@ out:
>         free_page(buf);
>         return is_tcg;
>  }
> +
> +/**
> + * Detect whether we are running with KVM
> + */
> +

No newline here.

> +bool vm_is_kvm(void)
> +{
> +       /* EBCDIC for "KVM/" */
> +       const uint8_t kvm_ebcdic[] = { 0xd2, 0xe5, 0xd4, 0x61 };
> +       static bool initialized;
> +       static bool is_kvm;

Might make sense to initizalize these to false to make it consistent
with vm_is_tcg().
