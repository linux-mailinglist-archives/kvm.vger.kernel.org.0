Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D3E6A0B96
	for <lists+kvm@lfdr.de>; Thu, 23 Feb 2023 15:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234082AbjBWONZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Feb 2023 09:13:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbjBWONY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Feb 2023 09:13:24 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F5A2332E
        for <kvm@vger.kernel.org>; Thu, 23 Feb 2023 06:13:23 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31NECLJU002916;
        Thu, 23 Feb 2023 14:13:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=G8Y1tG5cyVju22NcyeTVHx7S4BXX+hfZbpp8x+4dwJQ=;
 b=Lwgwjz49qgYqKw8BxNlG3oWeA583nmqaubYTz9DdHpKXC1Soiri7qTClSs7a64jZsBls
 HA4Oj3PPNcqa69PhpWgrgz3elNiMvM5y6Tm/3XdtxoOqTJjbHpvurGnu/tS9pN+B6j9F
 SoOCAMtyW1CK98ZnYfLffEYPGW1rK/tL05dJOar7vYa5Z2dvygKdGj9HoUqiZwvEFJ9B
 jGgIwjmxe2/VkRASQePb0MwJ5Uqwu1RRWlRdZ8Erjg8ocbHqU5cIhlOo+gBah4XcMy5S
 BFL+nxbLWBbltKDnLVi9j+XGRmjjRruryYJenMXWWAc14dFjNDgaZLHaPJbRvwIndQyl 7Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx9pug0hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 14:13:08 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 31NECvtL008162;
        Thu, 23 Feb 2023 14:13:08 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nx9pug0h1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 14:13:08 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 31N8uRXY007338;
        Thu, 23 Feb 2023 14:13:05 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3ntpa6ern7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 23 Feb 2023 14:13:05 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 31NED1nx23134578
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Feb 2023 14:13:01 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C54522004B;
        Thu, 23 Feb 2023 14:13:01 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5AD2220040;
        Thu, 23 Feb 2023 14:13:01 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.164.163])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 23 Feb 2023 14:13:01 +0000 (GMT)
Message-ID: <969c9ec842174876d514d082afe1c383baf58b99.camel@linux.ibm.com>
Subject: Re: [PATCH v16 02/11] s390x/cpu topology: add topology entries on
 CPU hotplug
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     pierre <pierre@imap.linux.ibm.com>, Thomas Huth <thuth@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, cohuck@redhat.com,
        mst@redhat.com, pbonzini@redhat.com, kvm@vger.kernel.org,
        ehabkost@redhat.com, marcel.apfelbaum@gmail.com, eblake@redhat.com,
        armbru@redhat.com, seiden@linux.ibm.com, nrb@linux.ibm.com,
        frankja@linux.ibm.com, berrange@redhat.com, clg@kaod.org
Date:   Thu, 23 Feb 2023 15:13:01 +0100
In-Reply-To: <a19eb89ab4841e389e72b50ec017ae01@imap.linux.ibm.com>
References: <20230222142105.84700-1-pmorel@linux.ibm.com>
         <20230222142105.84700-3-pmorel@linux.ibm.com>
         <4bd16293-62e8-d7ea-dab4-9e5cb0208812@redhat.com>
         <a19eb89ab4841e389e72b50ec017ae01@imap.linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: OPgKtQsmFgLHN4CDS9qiQuTH-NcForNk
X-Proofpoint-GUID: SOEf9730xJfzujg0SkO-1kLWvCLDfCY1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-23_08,2023-02-23_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 spamscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 mlxlogscore=999 priorityscore=1501 suspectscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302230115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-23 at 15:06 +0100, pierre wrote:
> On 2023-02-23 13:53, Thomas Huth wrote:
> > On 22/02/2023 15.20, Pierre Morel wrote:
> > > The topology information are attributes of the CPU and are
> > > specified during the CPU device creation.
> > ...
> > > diff --git a/include/hw/s390x/cpu-topology.h=20
> > > b/include/hw/s390x/cpu-topology.h
> > > index 83f31604cc..fa7f885a9f 100644
> > > --- a/include/hw/s390x/cpu-topology.h
> > > +++ b/include/hw/s390x/cpu-topology.h
> > > @@ -10,6 +10,47 @@
> > >   #ifndef HW_S390X_CPU_TOPOLOGY_H
> > >   #define HW_S390X_CPU_TOPOLOGY_H
> > >   +#include "qemu/queue.h"
> > > +#include "hw/boards.h"
> > > +#include "qapi/qapi-types-machine-target.h"
> > > +
> > >   #define S390_TOPOLOGY_CPU_IFL   0x03
> > >   +typedef struct S390Topology {
> > > +    uint8_t *cores_per_socket;
> > > +    CpuTopology *smp;
> > > +    CpuS390Polarization polarization;
> > > +} S390Topology;
> > > +
> > > +#ifdef CONFIG_KVM
> > > +bool s390_has_topology(void);
> > > +void s390_topology_setup_cpu(MachineState *ms, S390CPU *cpu, Error=
=20
> > > **errp);
> > > +#else
> > > +static inline bool s390_has_topology(void)
> > > +{
> > > +       return false;
> > > +}
> > > +static inline void s390_topology_setup_cpu(MachineState *ms,
> > > +                                           S390CPU *cpu,
> > > +                                           Error **errp) {}
> > > +#endif
> > > +
> > > +extern S390Topology s390_topology;
> > > +int s390_socket_nb(S390CPU *cpu);
> > > +
> > > +static inline int s390_std_socket(int n, CpuTopology *smp)
> > > +{
> > > +    return (n / smp->cores) % smp->sockets;
> > > +}
> > > +
> > > +static inline int s390_std_book(int n, CpuTopology *smp)
> > > +{
> > > +    return (n / (smp->cores * smp->sockets)) % smp->books;
> > > +}
> > > +
> > > +static inline int s390_std_drawer(int n, CpuTopology *smp)
> > > +{
> > > +    return (n / (smp->cores * smp->sockets * smp->books)) %=20
> > > smp->books;
> >=20
> > Shouldn't that be " % smp->drawers" instead?
>=20
> /o\  Yes it is of course.
> thanks.

You can also just drop the modulo, since
n < core * sockets * books * drawers. Not that % drawers does any harm ofc.
>=20
[...]

