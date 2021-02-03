Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4773730D5D4
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 10:07:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233021AbhBCJGs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 Feb 2021 04:06:48 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:13384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232880AbhBCJGm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 3 Feb 2021 04:06:42 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11392MAC139200;
        Wed, 3 Feb 2021 04:05:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=klMBnIvBeALFiLu2McF39NY902kwA2/i84RvI1FGzCc=;
 b=aXu4sFfFXq8C+gKBR5JNYERv8pYwM6I6hhBcOoAqnsT1PjSOv5WFWMe2HC0YE4ucCs3v
 P78YwBzbSisDF9ylq4iXHLrRnBMgc2Aa7LvyZGicBY3ndOTgXBIi5xHIC+AGDBJE5erz
 CvOg7opr1lNJi+TcMUZ2RqOndeSsZw2NcG/M/cj2ZHnf0jNLSIgMUy3qZ9Q95tpMwBtz
 fe7g0frZa5hkutFaSKgZpgCdVmU+qqIzZXcRn0Bng9mjKX6tap6lxMAjZhnNSoBQm6DL
 XCgNFkEOCB9UYyV3KiiZl18pnzwHo+fAUAlrtqhunkRkgFpEYrEMPZubRcznhZXvWEG3 xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36frbjs007-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 04:05:40 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11393THi147410;
        Wed, 3 Feb 2021 04:05:40 -0500
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36frbjrykm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 04:05:39 -0500
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 11394I29012318;
        Wed, 3 Feb 2021 09:05:28 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06fra.de.ibm.com with ESMTP id 36cxqh9xj4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Feb 2021 09:05:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 11395PNx37290322
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 Feb 2021 09:05:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ECF4BAE055;
        Wed,  3 Feb 2021 09:05:24 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 978F2AE059;
        Wed,  3 Feb 2021 09:05:23 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.7.56])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  3 Feb 2021 09:05:23 +0000 (GMT)
Subject: Re: [PATCH v8 13/13] s390: Recognize confidential-guest-support
 option
To:     David Gibson <david@gibson.dropbear.id.au>, dgilbert@redhat.com,
        pair@us.ibm.com, qemu-devel@nongnu.org, brijesh.singh@amd.com,
        pasic@linux.ibm.com
Cc:     pragyansri.pathi@intel.com, Greg Kurz <groug@kaod.org>,
        richard.henderson@linaro.org, berrange@redhat.com,
        David Hildenbrand <david@redhat.com>,
        mdroth@linux.vnet.ibm.com, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        pbonzini@redhat.com, mtosatti@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, qemu-ppc@nongnu.org,
        qemu-s390x@nongnu.org, thuth@redhat.com, mst@redhat.com,
        frankja@linux.ibm.com, jun.nakajima@intel.com,
        andi.kleen@intel.com, Eduardo Habkost <ehabkost@redhat.com>
References: <20210202041315.196530-1-david@gibson.dropbear.id.au>
 <20210202041315.196530-14-david@gibson.dropbear.id.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <1c9b65d6-b73f-3fde-7b76-f2d7b6e6d175@de.ibm.com>
Date:   Wed, 3 Feb 2021 10:05:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210202041315.196530-14-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-03_03:2021-02-02,2021-02-03 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 impostorscore=0 phishscore=0 malwarescore=0
 clxscore=1015 suspectscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102030053
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 02.02.21 05:13, David Gibson wrote:
> At least some s390 cpu models support "Protected Virtualization" (PV),
> a mechanism to protect guests from eavesdropping by a compromised
> hypervisor.
> 
> This is similar in function to other mechanisms like AMD's SEV and
> POWER's PEF, which are controlled by the "confidential-guest-support"
> machine option.  s390 is a slightly special case, because we already
> supported PV, simply by using a CPU model with the required feature
> (S390_FEAT_UNPACK).
> 
> To integrate this with the option used by other platforms, we
> implement the following compromise:
> 
>  - When the confidential-guest-support option is set, s390 will
>    recognize it, verify that the CPU can support PV (failing if not)
>    and set virtio default options necessary for encrypted or protected
>    guests, as on other platforms.  i.e. if confidential-guest-support
>    is set, we will either create a guest capable of entering PV mode,
>    or fail outright.
> 
>  - If confidential-guest-support is not set, guests might still be
>    able to enter PV mode, if the CPU has the right model.  This may be
>    a little surprising, but shouldn't actually be harmful.
> 
> To start a guest supporting Protected Virtualization using the new
> option use the command line arguments:
>     -object s390-pv-guest,id=pv0 -machine confidential-guest-support=pv0
> 

This version seems to work fine.

Tested-by: Christian Borntraeger <borntraeger@de.ibm.com>
Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>


> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |  3 ++
>  docs/system/s390x/protvirt.rst      | 19 ++++++---
>  hw/s390x/pv.c                       | 62 +++++++++++++++++++++++++++++
>  hw/s390x/s390-virtio-ccw.c          |  3 ++
>  include/hw/s390x/pv.h               | 17 ++++++++
>  5 files changed, 98 insertions(+), 6 deletions(-)
> 
> diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
> index 4da4c91bd3..71d07ba57a 100644
> --- a/docs/confidential-guest-support.txt
> +++ b/docs/confidential-guest-support.txt
> @@ -43,4 +43,7 @@ AMD Secure Encrypted Virtualization (SEV)
>  POWER Protected Execution Facility (PEF)
>      docs/papr-pef.txt
>  
> +s390x Protected Virtualization (PV)
> +    docs/system/s390x/protvirt.rst
> +
>  Other mechanisms may be supported in future.
> diff --git a/docs/system/s390x/protvirt.rst b/docs/system/s390x/protvirt.rst
> index 712974ad87..0f481043d9 100644
> --- a/docs/system/s390x/protvirt.rst
> +++ b/docs/system/s390x/protvirt.rst
> @@ -22,15 +22,22 @@ If those requirements are met, the capability `KVM_CAP_S390_PROTECTED`
>  will indicate that KVM can support PVMs on that LPAR.
>  
>  
> -QEMU Settings
> --------------
> +Running a Protected Virtual Machine
> +-----------------------------------
>  
> -To indicate to the VM that it can transition into protected mode, the
> +To run a PVM you will need to select a CPU model which includes the
>  `Unpack facility` (stfle bit 161 represented by the feature
> -`unpack`/`S390_FEAT_UNPACK`) needs to be part of the cpu model of
> -the VM.
> +`unpack`/`S390_FEAT_UNPACK`), and add these options to the command line::
> +
> +    -object s390-pv-guest,id=pv0 \
> +    -machine confidential-guest-support=pv0
> +
> +Adding these options will:
> +
> +* Ensure the `unpack` facility is available
> +* Enable the IOMMU by default for all I/O devices
> +* Initialize the PV mechanism
>  
> -All I/O devices need to use the IOMMU.
>  Passthrough (vfio) devices are currently not supported.
>  
>  Host huge page backings are not supported. However guests can use huge
> diff --git a/hw/s390x/pv.c b/hw/s390x/pv.c
> index ab3a2482aa..93eccfc05d 100644
> --- a/hw/s390x/pv.c
> +++ b/hw/s390x/pv.c
> @@ -14,8 +14,11 @@
>  #include <linux/kvm.h>
>  
>  #include "cpu.h"
> +#include "qapi/error.h"
>  #include "qemu/error-report.h"
>  #include "sysemu/kvm.h"
> +#include "qom/object_interfaces.h"
> +#include "exec/confidential-guest-support.h"
>  #include "hw/s390x/ipl.h"
>  #include "hw/s390x/pv.h"
>  
> @@ -111,3 +114,62 @@ void s390_pv_inject_reset_error(CPUState *cs)
>      /* Report that we are unable to enter protected mode */
>      env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
>  }
> +
> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> +OBJECT_DECLARE_SIMPLE_TYPE(S390PVGuest, S390_PV_GUEST)
> +
> +/**
> + * S390PVGuest:
> + *
> + * The S390PVGuest object is basically a dummy used to tell the
> + * confidential guest support system to use s390's PV mechanism.
> + *
> + * # $QEMU \
> + *         -object s390-pv-guest,id=pv0 \
> + *         -machine ...,confidential-guest-support=pv0
> + */
> +struct S390PVGuest {
> +    ConfidentialGuestSupport parent_obj;
> +};
> +
> +typedef struct S390PVGuestClass S390PVGuestClass;
> +
> +struct S390PVGuestClass {
> +    ConfidentialGuestSupportClass parent_class;
> +};
> +
> +int s390_pv_kvm_init(ConfidentialGuestSupport *cgs, Error **errp)
> +{
> +    if (!object_dynamic_cast(OBJECT(cgs), TYPE_S390_PV_GUEST)) {
> +        return 0;
> +    }
> +
> +    if (!s390_has_feat(S390_FEAT_UNPACK)) {
> +        error_setg(errp,
> +                   "CPU model does not support Protected Virtualization");
> +        return -1;
> +    }
> +
> +    cgs->ready = true;
> +
> +    return 0;
> +}
> +
> +OBJECT_DEFINE_TYPE_WITH_INTERFACES(S390PVGuest,
> +                                   s390_pv_guest,
> +                                   S390_PV_GUEST,
> +                                   CONFIDENTIAL_GUEST_SUPPORT,
> +                                   { TYPE_USER_CREATABLE },
> +                                   { NULL })
> +
> +static void s390_pv_guest_class_init(ObjectClass *oc, void *data)
> +{
> +}
> +
> +static void s390_pv_guest_init(Object *obj)
> +{
> +}
> +
> +static void s390_pv_guest_finalize(Object *obj)
> +{
> +}
> diff --git a/hw/s390x/s390-virtio-ccw.c b/hw/s390x/s390-virtio-ccw.c
> index a2d9a79c84..2972b607f3 100644
> --- a/hw/s390x/s390-virtio-ccw.c
> +++ b/hw/s390x/s390-virtio-ccw.c
> @@ -250,6 +250,9 @@ static void ccw_init(MachineState *machine)
>      /* init CPUs (incl. CPU model) early so s390_has_feature() works */
>      s390_init_cpus(machine);
>  
> +    /* Need CPU model to be determined before we can set up PV */
> +    s390_pv_init(machine->cgs, &error_fatal);
> +
>      s390_flic_init();
>  
>      /* init the SIGP facility */
> diff --git a/include/hw/s390x/pv.h b/include/hw/s390x/pv.h
> index aee758bc2d..1f1f545bfc 100644
> --- a/include/hw/s390x/pv.h
> +++ b/include/hw/s390x/pv.h
> @@ -12,6 +12,9 @@
>  #ifndef HW_S390_PV_H
>  #define HW_S390_PV_H
>  
> +#include "qapi/error.h"
> +#include "sysemu/kvm.h"
> +
>  #ifdef CONFIG_KVM
>  #include "cpu.h"
>  #include "hw/s390x/s390-virtio-ccw.h"
> @@ -55,4 +58,18 @@ static inline void s390_pv_unshare(void) {}
>  static inline void s390_pv_inject_reset_error(CPUState *cs) {};
>  #endif /* CONFIG_KVM */
>  
> +int s390_pv_kvm_init(ConfidentialGuestSupport *cgs, Error **errp);
> +static inline int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
> +{
> +    if (!cgs) {
> +        return 0;
> +    }
> +    if (kvm_enabled()) {
> +        return s390_pv_kvm_init(cgs, errp);
> +    }
> +
> +    error_setg(errp, "Protected Virtualization requires KVM");
> +    return -1;
> +}
> +
>  #endif /* HW_S390_PV_H */
> 
