Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7764F2CEFF0
	for <lists+kvm@lfdr.de>; Fri,  4 Dec 2020 15:44:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387563AbgLDOoN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Dec 2020 09:44:13 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:65232 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730305AbgLDOoL (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Dec 2020 09:44:11 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B4EXMoD141257;
        Fri, 4 Dec 2020 09:43:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=BYw8DCBC8WrZ09Uzj7lWvHhacH0T5sgdnIIP1nwYSyQ=;
 b=Tlkm1FK3a58beV/C+6AkANRSjb0pPHn20LZ6ulfHjDF4ZMT36VUFYQ96WLmkes8NaorR
 ZQhwpEdI9IRhK3Bk0JMw125VSE0oTUG4lot7CwveXtmwySKsM+swIyJYNfAmi1uFLXro
 ucEuKQT+5Gdbgr+2yKLNnfOrcVndgLO6xJw1wrozHckJxat+0ItMC3jH86G6rmgXPydu
 eMUI41j+J8FsXeKEagTaYFvt5l/WZwL4bKMKh84eNhJ3YeJQg6KSJp35mvTtrAODVOeX
 nF5f8ail5srMnAx8gu5ZWm1F9rNEmb3wYGYcWqGXuTLA+CQ/skFC2DXH3KxNyx1NPtu1 RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 357m8fwjaa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 09:43:19 -0500
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B4EXk42142979;
        Fri, 4 Dec 2020 09:43:19 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0b-001b2d01.pphosted.com with ESMTP id 357m8fwj9s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 09:43:19 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B4EfvwN006651;
        Fri, 4 Dec 2020 14:43:17 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 353e68bard-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Dec 2020 14:43:17 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B4EhEMd8520216
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 4 Dec 2020 14:43:14 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 35D084C044;
        Fri,  4 Dec 2020 14:43:14 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 267C24C04E;
        Fri,  4 Dec 2020 14:43:13 +0000 (GMT)
Received: from oc2783563651 (unknown [9.171.41.218])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Fri,  4 Dec 2020 14:43:13 +0000 (GMT)
Date:   Fri, 4 Dec 2020 15:43:10 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, pair@us.ibm.com,
        brijesh.singh@amd.com, frankja@linux.ibm.com, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, david@redhat.com,
        dgilbert@redhat.com, Eduardo Habkost <ehabkost@redhat.com>,
        qemu-devel@nongnu.org, qemu-s390x@nongnu.org, qemu-ppc@nongnu.org,
        berrange@redhat.com, thuth@redhat.com, pbonzini@redhat.com,
        rth@twiddle.net, mdroth@linux.vnet.ibm.com,
        David Gibson <david@gibson.dropbear.id.au>
Subject: Re: [for-6.0 v5 12/13] securable guest memory: Alter virtio default
 properties for protected guests
Message-ID: <20201204154310.158b410e.pasic@linux.ibm.com>
In-Reply-To: <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
References: <20201204054415.579042-1-david@gibson.dropbear.id.au>
        <20201204054415.579042-13-david@gibson.dropbear.id.au>
        <d739cae2-9197-76a5-1c19-057bfe832187@de.ibm.com>
        <20201204091706.4432dc1e.cohuck@redhat.com>
        <038214d1-580d-6692-cd1e-701cd41b5cf8@de.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-12-04_04:2020-12-04,2020-12-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 adultscore=0 spamscore=0 mlxlogscore=999 priorityscore=1501 phishscore=0
 lowpriorityscore=0 malwarescore=0 mlxscore=0 bulkscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2012040080
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 4 Dec 2020 09:29:59 +0100
Christian Borntraeger <borntraeger@de.ibm.com> wrote:

> 
> 
> On 04.12.20 09:17, Cornelia Huck wrote:
> > On Fri, 4 Dec 2020 09:10:36 +0100
> > Christian Borntraeger <borntraeger@de.ibm.com> wrote:
> > 
> >> On 04.12.20 06:44, David Gibson wrote:
> >>> The default behaviour for virtio devices is not to use the platforms normal
> >>> DMA paths, but instead to use the fact that it's running in a hypervisor
> >>> to directly access guest memory.  That doesn't work if the guest's memory
> >>> is protected from hypervisor access, such as with AMD's SEV or POWER's PEF.
> >>>
> >>> So, if a securable guest memory mechanism is enabled, then apply the
> >>> iommu_platform=on option so it will go through normal DMA mechanisms.
> >>> Those will presumably have some way of marking memory as shared with
> >>> the hypervisor or hardware so that DMA will work.
> >>>
> >>> Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> >>> Reviewed-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> >>> ---
> >>>  hw/core/machine.c | 13 +++++++++++++
> >>>  1 file changed, 13 insertions(+)
> >>>
> >>> diff --git a/hw/core/machine.c b/hw/core/machine.c
> >>> index a67a27d03c..d16273d75d 100644
> >>> --- a/hw/core/machine.c
> >>> +++ b/hw/core/machine.c
> >>> @@ -28,6 +28,8 @@
> >>>  #include "hw/mem/nvdimm.h"
> >>>  #include "migration/vmstate.h"
> >>>  #include "exec/securable-guest-memory.h"
> >>> +#include "hw/virtio/virtio.h"
> >>> +#include "hw/virtio/virtio-pci.h"
> >>>  
> >>>  GlobalProperty hw_compat_5_1[] = {
> >>>      { "vhost-scsi", "num_queues", "1"},
> >>> @@ -1169,6 +1171,17 @@ void machine_run_board_init(MachineState *machine)
> >>>           * areas.
> >>>           */
> >>>          machine_set_mem_merge(OBJECT(machine), false, &error_abort);
> >>> +
> >>> +        /*
> >>> +         * Virtio devices can't count on directly accessing guest
> >>> +         * memory, so they need iommu_platform=on to use normal DMA
> >>> +         * mechanisms.  That requires also disabling legacy virtio
> >>> +         * support for those virtio pci devices which allow it.
> >>> +         */
> >>> +        object_register_sugar_prop(TYPE_VIRTIO_PCI, "disable-legacy",
> >>> +                                   "on", true);
> >>> +        object_register_sugar_prop(TYPE_VIRTIO_DEVICE, "iommu_platform",
> >>> +                                   "on", false);  
> >>
> >> I have not followed all the history (sorry). Should we also set iommu_platform
> >> for virtio-ccw? Halil?
> >>
> > 
> > That line should add iommu_platform for all virtio devices, shouldn't
> > it?
> 
> Yes, sorry. Was misreading that with the line above. 
> 

I believe this is the best we can get. In a sense it is still a
pessimization, but it is a big usability improvement compared to having
to set iommu_platform manually. 

Regards,
Halil
