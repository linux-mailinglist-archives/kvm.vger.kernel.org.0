Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0106C60F36F
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 11:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233896AbiJ0JPH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 05:15:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235402AbiJ0JOs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 05:14:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC1416F774
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 02:13:27 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29R90um1009376;
        Thu, 27 Oct 2022 09:13:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=996CKtG//SC1Yp/cEATMl2cb8+XDWLYwh6JlvXwvFO8=;
 b=gh5c7r8R3Vq7yx/UfcsomPfxCcKzvln7Nl6IIyMC3zXGc8Wp718ymz4hh0m1FgzhH4rH
 HUvb1MxgRfcBX0jszJoqLnyFqxhGU4IkAv+kuMr6XDs8r/DOHkVay1MKuiM23RyvKlQR
 BCTIaMF7b3A4EfgViLWvP3BPdJDo1VJY6MXG2WRUAUZ3PnH/f9HJMOmrH4+y+lwjj0Cn
 pthR/zY/67C3KrmUM8xs+pCsyEsSqSKBXXnHPPc+QIahiEC14gSZfXcKTslYkavF1D41
 09MUxBX4SU88VJNFUCMGiKWQ/yo4Qxcn3BgPsA3wEJy9z0CA4lXljIqmk4J6b7+8lko2 KQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfq018fva-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 09:13:17 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29R919YA010326;
        Thu, 27 Oct 2022 09:13:16 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3kfq018fu8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 09:13:16 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29R9668c024550;
        Thu, 27 Oct 2022 09:13:14 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3kfahd13ah-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 09:13:14 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29R9DBtT2097736
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 09:13:11 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96F984C046;
        Thu, 27 Oct 2022 09:13:11 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD3E74C044;
        Thu, 27 Oct 2022 09:13:10 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.179.11.84])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Oct 2022 09:13:10 +0000 (GMT)
Message-ID: <a2a88ccc6dde6e61395c29733f42ddda8280479b.camel@linux.ibm.com>
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Thu, 27 Oct 2022 11:13:10 +0200
In-Reply-To: <a45185d1-16dc-6a31-6f1e-13b97fdb31e2@redhat.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-2-pmorel@linux.ibm.com>
         <65c3bfd263b03ca524444cdf5f96d937f582f2d7.camel@linux.ibm.com>
         <a45185d1-16dc-6a31-6f1e-13b97fdb31e2@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: wZxlcrJnOSEqFS0sSivhptD8vMa0T7-w
X-Proofpoint-ORIG-GUID: mgxSg0be-JwJQdHhMQSA89633gOvSdVh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_03,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 malwarescore=0
 adultscore=0 spamscore=0 phishscore=0 mlxscore=0 mlxlogscore=999
 impostorscore=0 bulkscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2210270051
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-10-27 at 10:05 +0200, Thomas Huth wrote:
> On 24/10/2022 21.25, Janis Schoetterl-Glausch wrote:
> > On Wed, 2022-10-12 at 18:20 +0200, Pierre Morel wrote:
> > > In the S390x CPU topology the core_id specifies the CPU address
> > > and the position of the core withing the topology.
> > > 
> > > Let's build the topology based on the core_id.
> > > s390x/cpu topology: core_id sets s390x CPU topology
> > > 
> > > In the S390x CPU topology the core_id specifies the CPU address
> > > and the position of the cpu withing the topology.
> > > 
> > > Let's build the topology based on the core_id.
> > > 
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/cpu-topology.h |  45 +++++++++++
> > >   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
> > >   hw/s390x/s390-virtio-ccw.c      |  21 +++++
> > >   hw/s390x/meson.build            |   1 +
> > >   4 files changed, 199 insertions(+)
> > >   create mode 100644 include/hw/s390x/cpu-topology.h
> > >   create mode 100644 hw/s390x/cpu-topology.c
> > > 
> > > diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/cpu-topology.h
> > > new file mode 100644
> > > index 0000000000..66c171d0bc
> > > --- /dev/null
> > > +++ b/include/hw/s390x/cpu-topology.h
> > > @@ -0,0 +1,45 @@
> > > +/*
> > > + * CPU Topology
> > > + *
> > > + * Copyright 2022 IBM Corp.
> > > + *
> > > + * This work is licensed under the terms of the GNU GPL, version 2 or (at
> > > + * your option) any later version. See the COPYING file in the top-level
> > > + * directory.
> > > + */
> > > +#ifndef HW_S390X_CPU_TOPOLOGY_H
> > > +#define HW_S390X_CPU_TOPOLOGY_H
> > > +
> > > +#include "hw/qdev-core.h"
> > > +#include "qom/object.h"
> > > +
> > > +typedef struct S390TopoContainer {
> > > +    int active_count;
> > > +} S390TopoContainer;
> > > +
> > > +#define S390_TOPOLOGY_CPU_IFL 0x03
> > > +#define S390_TOPOLOGY_MAX_ORIGIN ((63 + S390_MAX_CPUS) / 64)
> > > +typedef struct S390TopoTLE {
> > > +    uint64_t mask[S390_TOPOLOGY_MAX_ORIGIN];
> > > +} S390TopoTLE;
> > 
> > Since this actually represents multiple TLEs, you might want to change the
> > name of the struct to reflect this. S390TopoTLEList maybe?
> 
> Didn't TLE mean "Topology List Entry"? (by the way, Pierre, please explain 

Yes.

> this three letter acronym somewhere in this header in a comment)...
> 
> So expanding the TLE, this would mean S390TopoTopologyListEntryList ? ... 
> this is getting weird...

:D indeed. So the leaves of the topology tree as stored by STSI are lists
of CPU-type TLEs which aren't empty i.e. represent some cpus.
Whereas this struct is used to track which CPU-type TLEs need to be created.
It doesn't represent a TLE and doesn't represent the list of CPU-type TLEs.
So yeah, you're right, not a good name.

Off the top of my head I'd suggest S390TopoCPUSet. It's a bitmap, which is
kind of a set. Maybe S390TopoSocketCPUSet to reflect that it is the set of
CPUs in a socket, although, if we ever support different polarizations, etc.
that wouldn't really be true anymore, since that creates additional levels,
so maybe not. (In that case the leaf list of CPU-types TLEs is a flattened tree.)

> Also, this is not a "list" in the sense of a linked 
> list, as one might expect at a first glance, so this is all very confusing 
> here. Could you please come up with some better naming?
> 
>   Thomas
> 
> 

