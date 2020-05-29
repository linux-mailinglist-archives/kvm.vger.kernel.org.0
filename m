Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76E01E7796
	for <lists+kvm@lfdr.de>; Fri, 29 May 2020 10:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725768AbgE2IAG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 29 May 2020 04:00:06 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:63508 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725355AbgE2IAF (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 29 May 2020 04:00:05 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04T7W6i0105906;
        Fri, 29 May 2020 03:59:52 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31aucad42r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 May 2020 03:59:52 -0400
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 04T7XWfV112862;
        Fri, 29 May 2020 03:59:52 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 31aucad41v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 May 2020 03:59:51 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 04T7tabT010099;
        Fri, 29 May 2020 07:59:49 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03ams.nl.ibm.com with ESMTP id 316uf8bg8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 May 2020 07:59:49 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 04T7xlRf25297348
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 May 2020 07:59:47 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3DFA211C050;
        Fri, 29 May 2020 07:59:47 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EE5D611C04A;
        Fri, 29 May 2020 07:59:43 +0000 (GMT)
Received: from oc0525413822.ibm.com (unknown [9.163.45.230])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 29 May 2020 07:59:43 +0000 (GMT)
Date:   Fri, 29 May 2020 00:59:40 -0700
From:   Ram Pai <linuxram@us.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     qemu-devel@nongnu.org, brijesh.singh@amd.com,
        frankja@linux.ibm.com, dgilbert@redhat.com, pair@us.ibm.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, cohuck@redhat.com,
        mdroth@linux.vnet.ibm.com, qemu-ppc@nongnu.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Richard Henderson <rth@twiddle.net>
Message-ID: <20200529075940.GA26785@oc0525413822.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20200521034304.340040-1-david@gibson.dropbear.id.au>
 <20200521034304.340040-18-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200521034304.340040-18-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: Re:  [RFC v2 17/18] spapr: Added PEF based guest memory protection
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-05-29_02:2020-05-28,2020-05-29 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 malwarescore=0 spamscore=0 impostorscore=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 lowpriorityscore=0 suspectscore=0 clxscore=1011
 cotscore=-2147483648 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2005290055
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 21, 2020 at 01:43:03PM +1000, David Gibson wrote:
> Some upcoming POWER machines have a system called PEF (Protected
> Execution Framework) which uses a small ultravisor to allow guests to

Framework -> Facility

> run in a way that they can't be eavesdropped by the hypervisor.  The
> effect is roughly similar to AMD SEV, although the mechanisms are
> quite different.
> 
> Most of the work of this is done between the guest, KVM and the
> ultravisor, with little need for involvement by qemu.  However qemu
> does need to tell KVM to allow secure VMs.
> 
> Because the availability of secure mode is a guest visible difference
> which depends on havint the right hardware and firmware, we don't

havint -> having

> enable this by default.  In order to run a secure guest you need to
> create a "pef-guest" object and set the guest-memory-protection machine property to point to it.
> 
> Note that this just *allows* secure guests, the architecture of PEF is
> such that the guest still needs to talk to the ultravisor to enter
> secure mode, so we can't know if the guest actually is secure until
> well after machine creation time.

In fact, Qemu has no direct way of knowing if the guest has turned
secure or not, even after machine creation time. There are indirect ways
for Qemu to know that, but nothing informs Qemu explicitly about it. 

So maybe we should just say...

"..
 such that the guest still needs to talk to the ultravisor to enter
 secure mode, so we can't directly know if the guest actually is secure." 


> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  target/ppc/Makefile.objs |  2 +-
>  target/ppc/pef.c         | 81 ++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 82 insertions(+), 1 deletion(-)
>  create mode 100644 target/ppc/pef.c
> 
> diff --git a/target/ppc/Makefile.objs b/target/ppc/Makefile.objs
> index e8fa18ce13..ac93b9700e 100644
> --- a/target/ppc/Makefile.objs
> +++ b/target/ppc/Makefile.objs
> @@ -6,7 +6,7 @@ obj-y += machine.o mmu_helper.o mmu-hash32.o monitor.o arch_dump.o
>  obj-$(TARGET_PPC64) += mmu-hash64.o mmu-book3s-v3.o compat.o
>  obj-$(TARGET_PPC64) += mmu-radix64.o
>  endif
> -obj-$(CONFIG_KVM) += kvm.o
> +obj-$(CONFIG_KVM) += kvm.o pef.o
>  obj-$(call lnot,$(CONFIG_KVM)) += kvm-stub.o
>  obj-y += dfp_helper.o
>  obj-y += excp_helper.o
> diff --git a/target/ppc/pef.c b/target/ppc/pef.c
> new file mode 100644
> index 0000000000..823daf3e9c
> --- /dev/null
> +++ b/target/ppc/pef.c
> @@ -0,0 +1,81 @@
> +/*
> + * PEF (Protected Execution Framework) for POWER support
> + *
> + * Copyright David Gibson, Redhat Inc. 2020
> + *
> + * This work is licensed under the terms of the GNU GPL, version 2 or later.
> + * See the COPYING file in the top-level directory.
> + *
> + */
> +
> +#include "qemu/osdep.h"
> +
> +#define TYPE_PEF_GUEST "pef-guest"
> +#define PEF_GUEST(obj)                                  \
> +    OBJECT_CHECK(PefGuestState, (obj), TYPE_SEV_GUEST)
> +
> +typedef struct PefGuestState PefGuestState;
> +
> +/**
> + * PefGuestState:
> + *
> + * The PefGuestState object is used for creating and managing a PEF
> + * guest.
> + *
> + * # $QEMU \
> + *         -object pef-guest,id=pef0 \
> + *         -machine ...,guest-memory-protection=pef0
> + */
> +struct PefGuestState {
> +    Object parent_obj;
> +};
> +
> +static Error *pef_mig_blocker;
> +
> +static int pef_kvm_init(GuestMemoryProtection *gmpo, Error **errp)
> +{
> +    PefGuestState *pef = PEF_GUEST(gmpo);
> +
> +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURE_GUEST)) {
> +        error_setg(errp,
> +                   "KVM implementation does not support Secure VMs (is an ultravisor running?)");
> +        return -1;
> +    } else {
> +        int ret = kvm_vm_enable_cap(kvm_state, KVM_CAP_PPC_SECURE_GUEST, 0, 1);
> +
> +        if (ret < 0) {
> +            error_setg(errp,
> +                       "Error enabling PEF with KVM");
> +            return -1;
> +        }
> +    }
> +
> +    return 0;
> +}

This looks correct to me.

> +
> +static void pef_guest_class_init(ObjectClass *oc, void *data)
> +{
> +    GuestMemoryProtectionClass *gmpc = GUEST_MEMORY_PROTECTION_CLASS(oc);
> +
> +    gmpc->kvm_init = pef_kvm_init;
> +}
> +
> +static const TypeInfo pef_guest_info = {
> +    .parent = TYPE_OBJECT,
> +    .name = TYPE_PEF_GUEST,
> +    .instance_size = sizeof(PefGuestState),
> +    .class_init = pef_guest_class_init,
> +    .interfaces = (InterfaceInfo[]) {
> +        { TYPE_GUEST_MEMORY_PROTECTION },
> +        { TYPE_USER_CREATABLE },
> +        { }
> +    }
> +};
> +
> +static void
> +pef_register_types(void)
> +{
> +    type_register_static(&pef_guest_info);
> +}
> +
> +type_init(pef_register_types);

Acked-by: Ram Pai <linuxram@us.ibm.com>

Thanks for doing this!

BTW: Will there be a new machine type defined for running secure VMs?

RP
