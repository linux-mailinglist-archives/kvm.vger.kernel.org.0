Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE65255489B
	for <lists+kvm@lfdr.de>; Wed, 22 Jun 2022 14:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352124AbiFVIbn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Jun 2022 04:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353208AbiFVIbk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 Jun 2022 04:31:40 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5A7FEB
        for <kvm@vger.kernel.org>; Wed, 22 Jun 2022 01:31:39 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25M7k06Y004919;
        Wed, 22 Jun 2022 08:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=wl3ZF7qtvxsSXSZkAdDbi5qBMul+2/bNZ2Fuv0GYqRw=;
 b=i8Ncp/ouX6GaCnYCWa7AtJZwxyaP9EUHNlCgnUwpEs+DEIXMBD+52Hi7obKzZy7v6b3v
 k1bi4SVQo/m/dwLnIiGRGFqY7jtB5Fr5Kp7ds8YQBvjLNRZVNgPyj036jXt9auc8n1t2
 NfCEoziPGxfZN5V09+IgiwjccOvUDdsEnfX5bEH2VXLvSl/hDIB4QwCXAud7JgCuDIU4
 MJ1fVpuYscFnlvfKujXOh6VYkyU+z5twJUcQf1uLf6qTM3Jqr+OHTlK+M2vI7SNvrVKy
 JdA6FDDp8kQkt9MbddBkwwvun0GykCO7ryjOpE5GaJIB6MLLICox2tvkkwHWk91C5igH wQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3guxyw16pj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 08:31:32 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 25M8R5kB032317;
        Wed, 22 Jun 2022 08:31:31 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3guxyw16ny-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 08:31:31 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 25M8KvU3003911;
        Wed, 22 Jun 2022 08:31:29 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3gs5yhnaee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 22 Jun 2022 08:31:29 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 25M8VQ5l20709810
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Jun 2022 08:31:26 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 764D94204B;
        Wed, 22 Jun 2022 08:31:26 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B6A4F42049;
        Wed, 22 Jun 2022 08:31:25 +0000 (GMT)
Received: from [9.171.38.79] (unknown [9.171.38.79])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 22 Jun 2022 08:31:25 +0000 (GMT)
Message-ID: <ea3daac0-875d-dd9d-7ad0-65a0aed2aaed@linux.ibm.com>
Date:   Wed, 22 Jun 2022 10:35:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v7 3/8] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220606203614.110928-1-mjrosato@linux.ibm.com>
 <20220606203614.110928-4-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220606203614.110928-4-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kxOU667y70SB8KgBkKdh9r2NuWJCmh4t
X-Proofpoint-GUID: fVZJya9Zv6ca5PYnOMhyFI13fbomoW2E
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.64.514
 definitions=2022-06-21_11,2022-06-21_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 adultscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 phishscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206220039
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 6/6/22 22:36, Matthew Rosato wrote:
> If the ZPCI_OP ioctl reports that is is available and usable, then the
> underlying KVM host will enable load/store intepretation for any guest
> device without a SHM bit in the guest function handle.  For a device that
> will be using interpretation support, ensure the guest function handle
> matches the host function handle; this value is re-checked every time the
> guest issues a SET PCI FN to enable the guest device as it is the only
> opportunity to reflect function handle changes.
> 
> By default, unless interpret=off is specified, interpretation support will
> always be assumed and exploited if the necessary ioctl and features are
> available on the host kernel.  When these are unavailable, we will silently
> revert to the interception model; this allows existing guest configurations
> to work unmodified on hosts with and without zPCI interpretation support,
> allowing QEMU to choose the best support model available.
> 
> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
> ---
>   hw/s390x/meson.build            |  1 +
>   hw/s390x/s390-pci-bus.c         | 66 ++++++++++++++++++++++++++++++++-
>   hw/s390x/s390-pci-inst.c        | 16 ++++++++
>   hw/s390x/s390-pci-kvm.c         | 22 +++++++++++
>   include/hw/s390x/s390-pci-bus.h |  1 +
>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>   target/s390x/kvm/kvm.c          |  7 ++++
>   target/s390x/kvm/kvm_s390x.h    |  1 +
>   8 files changed, 137 insertions(+), 1 deletion(-)
>   create mode 100644 hw/s390x/s390-pci-kvm.c
>   create mode 100644 include/hw/s390x/s390-pci-kvm.h
> 
> diff --git a/hw/s390x/meson.build b/hw/s390x/meson.build
> index feefe0717e..f291016fee 100644
> --- a/hw/s390x/meson.build
> +++ b/hw/s390x/meson.build
> @@ -23,6 +23,7 @@ s390x_ss.add(when: 'CONFIG_KVM', if_true: files(
>     's390-skeys-kvm.c',
>     's390-stattrib-kvm.c',
>     'pv.c',
> +  's390-pci-kvm.c',
>   ))

Here...

> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
> new file mode 100644
> index 0000000000..0f16104a74
> --- /dev/null
> +++ b/hw/s390x/s390-pci-kvm.c

...and here:

Shouldn't this file go in target/s390x/kvm ?


> @@ -0,0 +1,22 @@
> +/*
> + * s390 zPCI KVM interfaces
> + *
> + * Copyright 2022 IBM Corp.
> + * Author(s): Matthew Rosato <mjrosato@linux.ibm.com>
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> + * your option) any later version. See the COPYING file in the top-level
> + * directory.
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#include "kvm/kvm_s390x.h"
> +#include "hw/s390x/pv.h"
> +#include "hw/s390x/s390-pci-kvm.h"
> +#include "cpu_models.h"
> +
> +bool s390_pci_kvm_interp_allowed(void)
> +{
> +    return kvm_s390_get_zpci_op() && !s390_is_pv();
> +}


-- 
Pierre Morel
IBM Lab Boeblingen
