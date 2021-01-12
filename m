Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A548C2F29D5
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 09:17:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730811AbhALIQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 03:16:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65352 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727530AbhALIQa (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 03:16:30 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10C83Dxc095642;
        Tue, 12 Jan 2021 03:15:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=N827eidgwM3gI3OnF16yd/OITjrp4uO08ZYr0+vAmIs=;
 b=e3V0knLpOwraxPI1zAoZrAx/nG7KIE34Dsla52qPDDvLQaIUvvzCdsZ4iOuXmm4WJo8I
 ehXMcZciMVap9ykw+3W72e3FstNh2h1bBPf7UfKY+rCXlYvNKsjNfBPWPTYxf/F3OhnX
 wmkePu83Q9PXFKtqTaiXhvP/jlWqq0ndVCX88GMKBsnqGUeV3CE5a+esi3dAYy5a8Oqu
 OtNGc3ij000IncWyKH6YkG8QYv/JInnxVSdDiV71EjjMmTgFxKctajjhGmrw0KXAM/cu
 lu3Zoxm2PePfUC0OhfEEIGUmurjvxVXMx0yBpmCB2iFWsy8XUGejzP1RvnSu7HBl8iKf Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3617cqs6ce-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 03:15:33 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10C83CWi095614;
        Tue, 12 Jan 2021 03:15:33 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3617cqs6bh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 03:15:33 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10C8CWYW030731;
        Tue, 12 Jan 2021 08:15:31 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma02fra.de.ibm.com with ESMTP id 35y448hpgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:15:31 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10C8FSF246924240
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 08:15:28 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2018F4C04E;
        Tue, 12 Jan 2021 08:15:28 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BA2D54C04A;
        Tue, 12 Jan 2021 08:15:26 +0000 (GMT)
Received: from oc7455500831.ibm.com (unknown [9.171.50.44])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 12 Jan 2021 08:15:26 +0000 (GMT)
Subject: Re: [PATCH v6 13/13] s390: Recognize confidential-guest-support
 option
To:     David Gibson <david@gibson.dropbear.id.au>, pasic@linux.ibm.com,
        brijesh.singh@amd.com, pair@us.ibm.com, dgilbert@redhat.com,
        qemu-devel@nongnu.org
Cc:     andi.kleen@intel.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Greg Kurz <groug@kaod.org>, frankja@linux.ibm.com,
        thuth@redhat.com, mdroth@linux.vnet.ibm.com,
        richard.henderson@linaro.org, kvm@vger.kernel.org,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eduardo Habkost <ehabkost@redhat.com>, david@redhat.com,
        Cornelia Huck <cohuck@redhat.com>, mst@redhat.com,
        qemu-s390x@nongnu.org, pragyansri.pathi@intel.com,
        jun.nakajima@intel.com
References: <20210112044508.427338-1-david@gibson.dropbear.id.au>
 <20210112044508.427338-14-david@gibson.dropbear.id.au>
From:   Christian Borntraeger <borntraeger@de.ibm.com>
Message-ID: <fcafba03-3701-93af-8eb7-17bd0d14d167@de.ibm.com>
Date:   Tue, 12 Jan 2021 09:15:26 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112044508.427338-14-david@gibson.dropbear.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_03:2021-01-11,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 spamscore=0 bulkscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 suspectscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120039
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12.01.21 05:45, David Gibson wrote:
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


This results in

[cborntra@t35lp61 qemu]$ qemu-system-s390x -enable-kvm -nographic -m 2G -kernel ~/full.normal 
**
ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
Bail out! ERROR:../qom/object.c:317:type_initialize: assertion failed: (parent->instance_size <= ti->instance_size)
Aborted (core dumped)




> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  docs/confidential-guest-support.txt |  3 ++
>  docs/system/s390x/protvirt.rst      | 19 +++++++---
>  hw/s390x/pv.c                       | 58 +++++++++++++++++++++++++++++
>  include/hw/s390x/pv.h               |  1 +
>  target/s390x/kvm.c                  |  3 ++
>  5 files changed, 78 insertions(+), 6 deletions(-)
> 
> diff --git a/docs/confidential-guest-support.txt b/docs/confidential-guest-support.txt
> index d466aa79d5..b4912f66c2 100644
> --- a/docs/confidential-guest-support.txt
> +++ b/docs/confidential-guest-support.txt
> @@ -42,4 +42,7 @@ AMD Secure Encrypted Virtualization (SEV)
>  
>  POWER Protected Execution Facility (PEF)
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
> index ab3a2482aa..85592e100a 100644
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
> @@ -111,3 +114,58 @@ void s390_pv_inject_reset_error(CPUState *cs)
>      /* Report that we are unable to enter protected mode */
>      env->regs[r1 + 1] = DIAG_308_RC_INVAL_FOR_PV;
>  }
> +
> +#define TYPE_S390_PV_GUEST "s390-pv-guest"
> +#define S390_PV_GUEST(obj)                              \
> +    OBJECT_CHECK(S390PVGuestState, (obj), TYPE_S390_PV_GUEST)
> +
> +typedef struct S390PVGuestState S390PVGuestState;
> +
> +/**
> + * S390PVGuestState:
> + *
> + * The S390PVGuestState object is basically a dummy used to tell the
> + * confidential guest support system to use s390's PV mechanism.
> + *
> + * # $QEMU \
> + *         -object s390-pv-guest,id=pv0 \
> + *         -machine ...,confidential-guest-support=pv0
> + */
> +struct S390PVGuestState {
> +    Object parent_obj;
> +};
> +
> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp)
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
> +static const TypeInfo s390_pv_guest_info = {
> +    .parent = TYPE_CONFIDENTIAL_GUEST_SUPPORT,
> +    .name = TYPE_S390_PV_GUEST,
> +    .instance_size = sizeof(S390PVGuestState),
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void
> +s390_pv_register_types(void)
> +{
> +    type_register_static(&s390_pv_guest_info);
> +}
> +
> +type_init(s390_pv_register_types);
> diff --git a/include/hw/s390x/pv.h b/include/hw/s390x/pv.h
> index aee758bc2d..9bbf66f356 100644
> --- a/include/hw/s390x/pv.h
> +++ b/include/hw/s390x/pv.h
> @@ -43,6 +43,7 @@ void s390_pv_prep_reset(void);
>  int s390_pv_verify(void);
>  void s390_pv_unshare(void);
>  void s390_pv_inject_reset_error(CPUState *cs);
> +int s390_pv_init(ConfidentialGuestSupport *cgs, Error **errp);
>  #else /* CONFIG_KVM */
>  static inline bool s390_is_pv(void) { return false; }
>  static inline int s390_pv_vm_enable(void) { return 0; }
> diff --git a/target/s390x/kvm.c b/target/s390x/kvm.c
> index b8385e6b95..d2435664dc 100644
> --- a/target/s390x/kvm.c
> +++ b/target/s390x/kvm.c
> @@ -387,6 +387,9 @@ int kvm_arch_init(MachineState *ms, KVMState *s)
>      }
>  
>      kvm_set_max_memslot_size(KVM_SLOT_MAX_BYTES);
> +
> +    s390_pv_init(ms->cgs, &error_fatal);
> +
>      return 0;
>  }
>  
> 
