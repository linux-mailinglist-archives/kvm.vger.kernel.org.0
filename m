Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D320325FD3E
	for <lists+kvm@lfdr.de>; Mon,  7 Sep 2020 17:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729899AbgIGPfN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Sep 2020 11:35:13 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:26456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729820AbgIGPfA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Sep 2020 11:35:00 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 087F3iDa065914;
        Mon, 7 Sep 2020 11:10:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0uT1Wh3NsrCyhry/BDzdibfaWs2fQbiYxDW51MVpoaI=;
 b=d8RnsC3GWpqKB8EVHSVfUXP4kWt6nvv+tKT+MOXciV5luzqfH5tySxcB979+PetploWV
 6PCnByP7NaQJrpQb5giUYlo+8ggkZGjK5iz7YegXCrpBpEcd76thYGkRf4JHmIRzt26A
 emvqWGDFhUXmG7ZgAAQcxPQeKvMxNFoUwbB6If5gPqAjZJWG3diiFkWsfwJQCDvjAdRb
 VQtYVf2GoAVmbXS8yg2CEug4y8iCNy5UOuFMWcA70hEJjq769Htt0gkbOx25ncDGAHe6
 yGTzYf5PyGIrmdKUYZfWlErvxRc/EikV9NxVsP83Du3yCytztAmeNb7jWsQ825uplDIv 4A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dq2d8apn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 11:10:56 -0400
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 087F4HAB067012;
        Mon, 7 Sep 2020 11:10:55 -0400
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33dq2d8ans-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 11:10:55 -0400
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 087F28JI014122;
        Mon, 7 Sep 2020 15:10:52 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma03ams.nl.ibm.com with ESMTP id 33c2a82h2p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 07 Sep 2020 15:10:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 087FAnZb36307338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 7 Sep 2020 15:10:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CC76F42041;
        Mon,  7 Sep 2020 15:10:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D370542042;
        Mon,  7 Sep 2020 15:10:48 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.173.93])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  7 Sep 2020 15:10:48 +0000 (GMT)
Date:   Mon, 7 Sep 2020 17:10:46 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     David Gibson <david@gibson.dropbear.id.au>
Cc:     dgilbert@redhat.com, frankja@linux.ibm.com, pair@us.ibm.com,
        qemu-devel@nongnu.org, pbonzini@redhat.com, brijesh.singh@amd.com,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com,
        "Michael S. Tsirkin" <mst@redhat.com>, qemu-ppc@nongnu.org,
        kvm@vger.kernel.org, qemu-s390x@nongnu.org,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Richard Henderson <rth@twiddle.net>,
        "Daniel P. =?UTF-8?B?QmVycmFuZ8Op?=" <berrange@redhat.com>,
        mdroth@linux.vnet.ibm.com, Thomas Huth <thuth@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Boris Fiuczynski <fiuczy@linux.ibm.com>,
        Bjoern Walk <bwalk@linux.ibm.com>
Subject: Re: [for-5.2 v4 09/10] host trust limitation: Alter virtio default
 properties for protected guests
Message-ID: <20200907171046.18211111.pasic@linux.ibm.com>
In-Reply-To: <20200724025744.69644-10-david@gibson.dropbear.id.au>
References: <20200724025744.69644-1-david@gibson.dropbear.id.au>
        <20200724025744.69644-10-david@gibson.dropbear.id.au>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-07_10:2020-09-07,2020-09-07 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 adultscore=0
 mlxlogscore=999 phishscore=0 impostorscore=0 priorityscore=1501 mlxscore=0
 suspectscore=0 clxscore=1011 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009070149
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 24 Jul 2020 12:57:43 +1000
David Gibson <david@gibson.dropbear.id.au> wrote:

> The default behaviour for virtio devices is not to use the platforms normal
> DMA paths, but instead to use the fact that it's running in a hypervisor
> to directly access guest memory.  That doesn't work if the guest's memory
> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> 
> So, if a host trust limitation mechanism is enabled, then apply the
> iommu_platform=on option so it will go through normal DMA mechanisms.
> Those will presumably have some way of marking memory as shared with the
> hypervisor or hardware so that DMA will work.

Sorry for being this late. I had to do some high priority debugging,
which made me drop everything else, and after that I had some vacation.

I have some questions about the bigger picture. The promised benefit of
this patch for users that invoke QEMU manually is relatively clear: it
alters the default value of some virtio properties, so that using the
defaults does not result in a bugous configuration.

This comes at a price. I used to think of device property default values
like this. If I don't specify it and I use the default machine, I will
effectively get the the default value of of the property (as reported by
qemu -device dev-name,?). If I use a compat machine, then I will get the
compatibility default value: i.e. the what is reported as the default
value, if I invoke the binary whose default machine is my compat machine.

With this patch, that reasoning is not valid any more. Did we do
something like this before, or is this the first time we introduce this
complication?

In any case, I suppose, this change needs a documentation update, which I
could not find in the series.

How are things supposed to pan out when QEMU is used with management
software?

I was told that libvirt's policy is to be explicit and not let QEMU use
defaults. But this policy does not seem to apply to iommu_platform -- at
least not on s390x. Why is this? Is this likely to change in the future?

Furthermore, the libvirt documentation is IMHO not that great when it
comes to iommu_platform. All I've found is 

"""
Virtio-related options


QEMU's virtio devices have some attributes related to the virtio transport under the driver element: The iommu attribute enables the use of emulated IOMMU by the device. 
"""

which:
* Is not explicit about the default, but suggests that default is off
  (because it needs to be enabled), which would reflect the current state
  of affairs (without this patch).
* Makes me wonder, to what extent does the libvirt concept correspond
  to the virtio semantics of _F_ACCESS_PLATFORM. I.e. we don't really
  do any IOMMU emulation with virtio-ccw.

I guess host trust limitation is something that is to be expressed in
libvirt, or? Do we have a design for that?

I was also reflecting on how does this patch compare to on/off/auto, but
this email is already too long, so decided keep my thoughts for myself
-- for now.

Regards,
Halil

> 
> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> ---
>  hw/core/machine.c | 11 +++++++++++
>  1 file changed, 11 insertions(+)
> 
> diff --git a/hw/core/machine.c b/hw/core/machine.c
> index b599b0ba65..2a723bf07b 100644
> --- a/hw/core/machine.c
> +++ b/hw/core/machine.c
> @@ -28,6 +28,8 @@
>  #include "hw/mem/nvdimm.h"
>  #include "migration/vmstate.h"
>  #include "exec/host-trust-limitation.h"
> +#include "hw/virtio/virtio.h"
> +#include "hw/virtio/virtio-pci.h"
>  
>  GlobalProperty hw_compat_5_0[] = {
>      { "virtio-balloon-device", "page-poison", "false" },
> @@ -1161,6 +1163,15 @@ void machine_run_board_init(MachineState *machine)
>           * areas.
>           */
>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> +
> +        /*
> +         * Virtio devices can't count on directly accessing guest
> +         * memory, so they need iommu_platform=on to use normal DMA
> +         * mechanisms.  That requires disabling legacy virtio support
> +         * for virtio pci devices
> +         */
> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy", "on");
> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform", "on");
>      }
>  
>      machine_class->init(machine);



