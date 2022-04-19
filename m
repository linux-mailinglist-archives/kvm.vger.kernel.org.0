Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30023507A71
	for <lists+kvm@lfdr.de>; Tue, 19 Apr 2022 21:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356009AbiDSTrZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Apr 2022 15:47:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243888AbiDSTrX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 Apr 2022 15:47:23 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A379B41625
        for <kvm@vger.kernel.org>; Tue, 19 Apr 2022 12:44:39 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23JH8p7n025430;
        Tue, 19 Apr 2022 19:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=z37+Z6JA+K8p1T0P4ihSZ8xuvKmNCnZIQ6PP/pXu7ZI=;
 b=S16mh9BqsRmtSwI6Hsu7EhET0AR4S+cMdY4zdvEo9wJfebN+UtqdVbm+5PDBplksnYUS
 /tyG1R3tfv998PEIIhuKvoWkCghIp+GYIkjsEuXduJNBaqwz4bqmwXITd3OAZltalk2P
 ibOvIt5alvO7xn4GF9vQmYMCj33bXuhoW6BO7mU1WjhLblyR/oqLNV8Xp2d1rhtkStAd
 SytZ27eraJmqfOaWC+S+yr62mPI3yrSmeqfmBD79/F2FeeGIgCjgCLMKrnl/By3fTOdV
 gSmj47jgqM8aatni3WzN01BpYjdXnf0ujugxtssfku5eymxg2ucFm5+4s/OEEN2JxbIO kQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fhsx8ptgq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:44:34 +0000
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 23JJiXLi029420;
        Tue, 19 Apr 2022 19:44:33 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3fhsx8ptgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:44:33 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23JJNhic022116;
        Tue, 19 Apr 2022 19:44:31 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3ffn2hvybe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Apr 2022 19:44:31 +0000
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23JJiS6F33882400
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Apr 2022 19:44:28 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D1B742041;
        Tue, 19 Apr 2022 19:44:28 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE53742045;
        Tue, 19 Apr 2022 19:44:27 +0000 (GMT)
Received: from [9.171.88.57] (unknown [9.171.88.57])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 19 Apr 2022 19:44:27 +0000 (GMT)
Message-ID: <cb628847-9b52-b64a-da1e-18f69fe20e4b@linux.ibm.com>
Date:   Tue, 19 Apr 2022 21:47:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v5 5/9] s390x/pci: enable for load/store intepretation
Content-Language: en-US
To:     Matthew Rosato <mjrosato@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     alex.williamson@redhat.com, schnelle@linux.ibm.com,
        cohuck@redhat.com, thuth@redhat.com, farman@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com,
        pasic@linux.ibm.com, borntraeger@linux.ibm.com, mst@redhat.com,
        pbonzini@redhat.com, qemu-devel@nongnu.org, kvm@vger.kernel.org
References: <20220404181726.60291-1-mjrosato@linux.ibm.com>
 <20220404181726.60291-6-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
In-Reply-To: <20220404181726.60291-6-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: cZGoyeg-zoPj5oQgfSn1PMk8OFG0FPFI
X-Proofpoint-ORIG-GUID: X_OS7AJR2NJsWJ4zd3JsE8sGBShmjGLu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-19_07,2022-04-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 bulkscore=0
 impostorscore=0 mlxscore=0 priorityscore=1501 phishscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2204190110
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/4/22 20:17, Matthew Rosato wrote:
> If the appropriate CPU facilty is available as well as the necessary
> ZPCI_OP ioctl, then the underlying KVM host will enable load/store
> intepretation for any guest device without a SHM bit in the guest
> function handle.  For a device that will be using interpretation
> support, ensure the guest function handle matches the host function
> handle; this value is re-checked every time the guest issues a SET PCI FN
> to enable the guest device as it is the only opportunity to reflect
> function handle changes.
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
>   hw/s390x/s390-pci-inst.c        | 12 ++++++
>   hw/s390x/s390-pci-kvm.c         | 21 +++++++++++
>   include/hw/s390x/s390-pci-bus.h |  1 +
>   include/hw/s390x/s390-pci-kvm.h | 24 ++++++++++++
>   target/s390x/kvm/kvm.c          |  7 ++++
>   target/s390x/kvm/kvm_s390x.h    |  1 +
>   8 files changed, 132 insertions(+), 1 deletion(-)
>   create mode 100644 hw/s390x/s390-pci-kvm.c
>   create mode 100644 include/hw/s390x/s390-pci-kvm.h
> 

...snip...

>           if (s390_pci_msix_init(pbdev)) {
> @@ -1360,6 +1423,7 @@ static Property s390_pci_device_properties[] = {
>       DEFINE_PROP_UINT16("uid", S390PCIBusDevice, uid, UID_UNDEFINED),
>       DEFINE_PROP_S390_PCI_FID("fid", S390PCIBusDevice, fid),
>       DEFINE_PROP_STRING("target", S390PCIBusDevice, target),
> +    DEFINE_PROP_BOOL("interpret", S390PCIBusDevice, interp, true),
>       DEFINE_PROP_END_OF_LIST(),
>   };
>   
> diff --git a/hw/s390x/s390-pci-inst.c b/hw/s390x/s390-pci-inst.c
> index 6d400d4147..c898c8abe9 100644
> --- a/hw/s390x/s390-pci-inst.c
> +++ b/hw/s390x/s390-pci-inst.c
> @@ -18,6 +18,8 @@
>   #include "sysemu/hw_accel.h"
>   #include "hw/s390x/s390-pci-inst.h"
>   #include "hw/s390x/s390-pci-bus.h"
> +#include "hw/s390x/s390-pci-kvm.h"
> +#include "hw/s390x/s390-pci-vfio.h"
>   #include "hw/s390x/tod.h"
>   
>   #ifndef DEBUG_S390PCI_INST
> @@ -246,6 +248,16 @@ int clp_service_call(S390CPU *cpu, uint8_t r2, uintptr_t ra)
>                   goto out;
>               }
>   
> +            /*
> +             * Take this opportunity to make sure we still have an accurate
> +             * host fh.  It's possible part of the handle changed while the
> +             * device was disabled to the guest (e.g. vfio hot reset for
> +             * ISM during plug)
> +             */
> +            if (pbdev->interp) {
> +                /* Take this opportunity to make sure we are sync'd with host */
> +                s390_pci_get_host_fh(pbdev, &pbdev->fh);
> +            }
>               pbdev->fh |= FH_MASK_ENABLE;

Are we sure here that the PCI device is always enabled?
Shouldn't we check?


>               pbdev->state = ZPCI_FS_ENABLED;
>               stl_p(&ressetpci->fh, pbdev->fh);
> diff --git a/hw/s390x/s390-pci-kvm.c b/hw/s390x/s390-pci-kvm.c
> new file mode 100644
> index 0000000000..8bfce9ef18
> --- /dev/null
> +++ b/hw/s390x/s390-pci-kvm.c
> @@ -0,0 +1,21 @@
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
> +#include "hw/s390x/s390-pci-kvm.h"
> +#include "cpu_models.h"
> +
> +bool s390_pci_kvm_interp_allowed(void)
> +{
> +    return s390_has_feat(S390_FEAT_ZPCI_INTERP) && kvm_s390_get_zpci_op();
> +}

ZPCI is not supported by the PV currently but I do not see what could 
prevent it to be enable in the future.
As the code of QEMU zPCI is not PV compatible, I would like to add a 
check for PV.

... && !s390_is_pv())



> diff --git a/include/hw/s390x/s390-pci-bus.h b/include/hw/s390x/s390-pci-bus.h
> index da3cde2bb4..a9843dfe97 100644
> --- a/include/hw/s390x/s390-pci-bus.h
> +++ b/include/hw/s390x/s390-pci-bus.h
> @@ -350,6 +350,7 @@ struct S390PCIBusDevice {
>       IndAddr *indicator;
>       bool pci_unplug_request_processed;
>       bool unplug_requested;
> +    bool interp;
>       QTAILQ_ENTRY(S390PCIBusDevice) link;
>   };
>   

...snip...

-- 
Pierre Morel
IBM Lab Boeblingen
