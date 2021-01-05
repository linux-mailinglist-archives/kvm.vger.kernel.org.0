Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4497A2EB655
	for <lists+kvm@lfdr.de>; Wed,  6 Jan 2021 00:37:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbhAEXfq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 5 Jan 2021 18:35:46 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725838AbhAEXfp (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 5 Jan 2021 18:35:45 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 105NWv8v131611;
        Tue, 5 Jan 2021 18:34:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 message-id : reply-to : references : mime-version : content-type :
 in-reply-to : subject; s=pp1;
 bh=SEMgVBXBgS8oXklCCsiQh4hDhP2dBEwhEUJwWn9ZcM8=;
 b=m3pIleuvatum4n0oqf4UYyqBb+lxrXdMpmLe3vQsgIIXlu5/rt4vHe2BTsvymRf0WeFD
 Yr3lAGQmCi5sjbuhpqFdcWwny72tvZG6lCGPutgKY2PzTkmwrmMHsXb8kRQaK/6KuImY
 PtU06cAcSz1eAVBPxBFLqjJtoOJ7YGrgUs8hqC+O2Pa/LmTinplzz0uOZmexEyDD4Sux
 WPSehLdUi8UCFLRXJ/zg84o+NcwkQpX5MAgAn+qogPUW8OF5yLEqNRWK7qryio6wBIg0
 tLciWKgnPK4Y7vU89/8a/LpSxngO2YxMiqVT19NtVBLhZ7PmpOq23olKLXC9bcrRIgSi ug== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35w1rag58t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 18:34:49 -0500
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 105NYnrd135879;
        Tue, 5 Jan 2021 18:34:49 -0500
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com with ESMTP id 35w1rag58d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 18:34:49 -0500
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 105NW66K004358;
        Tue, 5 Jan 2021 23:34:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma04ams.nl.ibm.com with ESMTP id 35u3pmjq9x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 05 Jan 2021 23:34:47 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 105NYfEo31457672
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 5 Jan 2021 23:34:41 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9F7D4C052;
        Tue,  5 Jan 2021 23:34:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B18E54C04A;
        Tue,  5 Jan 2021 23:34:40 +0000 (GMT)
Received: from ram-ibm-com.ibm.com (unknown [9.163.29.145])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Tue,  5 Jan 2021 23:34:40 +0000 (GMT)
Date:   Tue, 5 Jan 2021 15:34:38 -0800
From:   Ram Pai <linuxram@us.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     pair@us.ibm.com, pbonzini@redhat.com, frankja@linux.ibm.com,
        brijesh.singh@amd.com, dgilbert@redhat.com, qemu-devel@nongnu.org,
        thuth@redhat.com, cohuck@redhat.com, berrange@redhat.com,
        Eduardo Habkost <ehabkost@redhat.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        mdroth@linux.vnet.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        rth@twiddle.net
Message-ID: <20210105233438.GB22585@ram-ibm-com.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
 <20201204054415.579042-11-david@gibson.dropbear.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204054415.579042-11-david@gibson.dropbear.id.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-GCONF: 00
Subject: Re:  [for-6.0 v5 10/13] spapr: Add PEF based securable guest memory
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-05_09:2021-01-05,2021-01-05 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 impostorscore=0 clxscore=1015 mlxlogscore=999 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101050134
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 04, 2020 at 04:44:12PM +1100, David Gibson wrote:
> Some upcoming POWER machines have a system called PEF (Protected
> Execution Facility) which uses a small ultravisor to allow guests to
> run in a way that they can't be eavesdropped by the hypervisor.  The
> effect is roughly similar to AMD SEV, although the mechanisms are
> quite different.
> 
> Most of the work of this is done between the guest, KVM and the
> ultravisor, with little need for involvement by qemu.  However qemu
> does need to tell KVM to allow secure VMs.
> 
> Because the availability of secure mode is a guest visible difference
> which depends on having the right hardware and firmware, we don't
> enable this by default.  In order to run a secure guest you need to
> create a "pef-guest" object and set the securable-guest-memory machine
> property to point to it.
> 
> Note that this just *allows* secure guests, the architecture of PEF is
> such that the guest still needs to talk to the ultravisor to enter
> secure mode.  Qemu has no directl way of knowing if the guest is in
> secure mode, and certainly can't know until well after machine
> creation time.
> 
> To start a PEF-capable guest, use the command line options:
>     -object pef-guest,id=pef0 -machine securable-guest-memory=pef0
> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> Acked-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  hw/ppc/meson.build   |   1 +
>  hw/ppc/pef.c         | 115 +++++++++++++++++++++++++++++++++++++++++++
>  hw/ppc/spapr.c       |  10 ++++
>  include/hw/ppc/pef.h |  26 ++++++++++
>  target/ppc/kvm.c     |  18 -------
>  target/ppc/kvm_ppc.h |   6 ---
>  6 files changed, 152 insertions(+), 24 deletions(-)
>  create mode 100644 hw/ppc/pef.c
>  create mode 100644 include/hw/ppc/pef.h
> 
> diff --git a/hw/ppc/meson.build b/hw/ppc/meson.build
> index ffa2ec37fa..218631c883 100644
> --- a/hw/ppc/meson.build
> +++ b/hw/ppc/meson.build
> @@ -27,6 +27,7 @@ ppc_ss.add(when: 'CONFIG_PSERIES', if_true: files(
>    'spapr_nvdimm.c',
>    'spapr_rtas_ddw.c',
>    'spapr_numa.c',
> +  'pef.c',
>  ))
>  ppc_ss.add(when: 'CONFIG_SPAPR_RNG', if_true: files('spapr_rng.c'))
>  ppc_ss.add(when: ['CONFIG_PSERIES', 'CONFIG_LINUX'], if_true: files(
> diff --git a/hw/ppc/pef.c b/hw/ppc/pef.c
> new file mode 100644
> index 0000000000..3ae3059cfe
> --- /dev/null
> +++ b/hw/ppc/pef.c
> @@ -0,0 +1,115 @@
> +/*
> + * PEF (Protected Execution Facility) for POWER support
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
> +#include "qapi/error.h"
> +#include "qom/object_interfaces.h"
> +#include "sysemu/kvm.h"
> +#include "migration/blocker.h"
> +#include "exec/securable-guest-memory.h"
> +#include "hw/ppc/pef.h"
> +
> +#define TYPE_PEF_GUEST "pef-guest"
> +#define PEF_GUEST(obj)                                  \
> +    OBJECT_CHECK(PefGuestState, (obj), TYPE_PEF_GUEST)
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
> + *         -machine ...,securable-guest-memory=pef0
> + */
> +struct PefGuestState {
> +    Object parent_obj;
> +};
> +
> +#ifdef CONFIG_KVM
> +static int kvmppc_svm_init(Error **errp)
> +{
> +    if (!kvm_check_extension(kvm_state, KVM_CAP_PPC_SECURABLE_GUEST)) {
                                           ^^^^^^^^^^^^^^^^^^^^^^^^^^
KVM defines this macro as KVM_CAP_PPC_SECURE_GUEST. Unless we patch KVM,
    we are stuck with KVM_CAP_PPC_SECURE_GUEST.

RP
