Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574B360BC7D
	for <lists+kvm@lfdr.de>; Mon, 24 Oct 2022 23:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbiJXVu0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 24 Oct 2022 17:50:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231139AbiJXVuD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 24 Oct 2022 17:50:03 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B582EBC2C
        for <kvm@vger.kernel.org>; Mon, 24 Oct 2022 13:02:54 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29OJ1gkE013945;
        Mon, 24 Oct 2022 19:26:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=GD0BfoXlIK5o47OuxrwJG/gRYU/ge0/2dWAiJfqWlcQ=;
 b=Ziarjqh6tk3KPWKaBR+CFpiFqMt8PqTmgxmLOcjADtcaMwdBWRW6CM9SNDNU0QIxn0D/
 88Wocqid9FmfY8kw/Fto82lMxWJNvIpJWd8rTtFl1EtyP2Q5QDWf0pKjI/oit1tHduo0
 fJBC68O8u4xGoYzayBD49I88rFBKXnxX14CjJM0ERxB53KH38NNE28vhX3MDLHqIa+O6
 mdKBCM+Rdng1aY9Xa/StoG/GibHjZiJjv+An5vWjNLpnprLp13ibBTYvNjCPXE/pY/Az
 /+LUxUyHJpeTiBkiNGQzJYq/FRhfpcuvMMd+y2xbStztPxDOXEmRab9f0G7pTAwJopdE MA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdxrj4gfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 19:26:20 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29OIkRc1016659;
        Mon, 24 Oct 2022 19:26:20 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kdxrj4gf6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 19:26:19 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29OJKpmB016341;
        Mon, 24 Oct 2022 19:26:18 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3kdugardf1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 24 Oct 2022 19:26:18 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29OJQEcd3670730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Oct 2022 19:26:14 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BF419AE045;
        Mon, 24 Oct 2022 19:26:14 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E4FAEAE053;
        Mon, 24 Oct 2022 19:26:13 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.27.135])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 24 Oct 2022 19:26:13 +0000 (GMT)
Message-ID: <2f5f3946980e242058934bfe04607597ffa0d91f.camel@linux.ibm.com>
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        =?ISO-8859-1?Q?C=E9dric?= Le Goater <clg@kaod.org>,
        qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com
Date:   Mon, 24 Oct 2022 21:26:13 +0200
In-Reply-To: <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-2-pmorel@linux.ibm.com>
         <5d5ff3cb-43a0-3d15-ff17-50b46c57a525@kaod.org>
         <b584418d-8a6d-d618-fd21-3b71d27f1e3e@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 2tpZIDQJf_0ax8OSwgSz7EB1SNdjGQ0n
X-Proofpoint-GUID: ohP6KjCwhpAzPiWvRffYtDTDiWYMrzql
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-24_06,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 suspectscore=0 malwarescore=0 mlxscore=0 priorityscore=1501 phishscore=0
 spamscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2209130000
 definitions=main-2210240114
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-10-19 at 17:39 +0200, Pierre Morel wrote:
> 
> On 10/18/22 18:43, Cédric Le Goater wrote:
> 
> > > 
[...]
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >   include/hw/s390x/cpu-topology.h |  45 +++++++++++
> > >   hw/s390x/cpu-topology.c         | 132 ++++++++++++++++++++++++++++++++
> > >   hw/s390x/s390-virtio-ccw.c      |  21 +++++
> > >   hw/s390x/meson.build            |   1 +
> > >   4 files changed, 199 insertions(+)
> > >   create mode 100644 include/hw/s390x/cpu-topology.h
> > >   create mode 100644 hw/s390x/cpu-topology.c
> > > 
[...]
> > > 
> > > +/*
> > > + * s390_topology_new_cpu:
> > > + * @core_id: the core ID is machine wide
> > > + *
> > > + * The topology returned by s390_get_topology(), gives us the CPU
> > > + * topology established by the -smp QEMU aruments.
> > > + * The core-id gives:
> > > + *  - the Container TLE (Topology List Entry) containing the CPU TLE.
> > > + *  - in the CPU TLE the origin, or offset of the first bit in the 
> > > core mask
> > > + *  - the bit in the CPU TLE core mask
> > > + */
> > > +void s390_topology_new_cpu(int core_id)
> > > +{
> > > +    S390Topology *topo = s390_get_topology();
> > > +    int socket_id;
> > > +    int bit, origin;
> > > +
> > > +    /* In the case no Topology is used nothing is to be done here */
> > > +    if (!topo) {
> > > +        return;
> > > +    }
> > 
> > I would move this test in the caller.
> 
> Check will disapear with the new implementation.
> 
> > 
> > > +
> > > +    socket_id = core_id / topo->cpus;
> > > +
> > > +    /*
> > > +     * At the core level, each CPU is represented by a bit in a 64bit
> > > +     * unsigned long which represent the presence of a CPU.
> > > +     * The firmware assume that all CPU in a CPU TLE have the same
> > > +     * type, polarization and are all dedicated or shared.
> > > +     * In that case the origin variable represents the offset of the 
> > > first
> > > +     * CPU in the CPU container.
> > > +     * More than 64 CPUs per socket are represented in several CPU 
> > > containers
> > > +     * inside the socket container.
> > > +     * The only reason to have several S390TopologyCores inside a 
> > > socket is
> > > +     * to have more than 64 CPUs.
> > > +     * In that case the origin variable represents the offset of the 
> > > first CPU
> > > +     * in the CPU container. More than 64 CPUs per socket are 
> > > represented in
> > > +     * several CPU containers inside the socket container.
> > > +     */
> > > +    bit = core_id;
> > > +    origin = bit / 64;
> > > +    bit %= 64;
> > > +    bit = 63 - bit;
> > > +
> > > +    topo->socket[socket_id].active_count++;
> > > +    set_bit(bit, &topo->tle[socket_id].mask[origin]);
> > 
> > here, the tle array is indexed with a socket id and ...
> 
> It was stupid to keep both structures.
> I will keep only the socket structure and incorparate the TLE inside.

I don't think it's stupid. Both are valid possibilities.
The first one treats sockets and books and drawers exactly the same, since
they are all just containers (once you introduce books and drawers).
The second treats sockets differently, because they're the leaf nodes of the
hierarchy in a certain sense (the leaf nodes of the "regular" hierarchy,
whereas the cpus are the real leaf nodes of the topology but special/not "regular").

I'd say the first is more natural from reading the PoP, but it might indeed be a bit
confusing when reading the code since there's a one to one correspondence between
sockets and TLE(List)s.
> 
> > 
> > > +}
> > > +
> > > +/**
> > > + * s390_topology_realize:
> > > + * @dev: the device state
> > > + * @errp: the error pointer (not used)
> > > + *
> > > + * During realize the machine CPU topology is initialized with the
> > > + * QEMU -smp parameters.
> > > + * The maximum count of CPU TLE in the all Topology can not be greater
> > > + * than the maximum CPUs.
> > > + */
> > > +static void s390_topology_realize(DeviceState *dev, Error **errp)
> > > +{
> > > +    MachineState *ms = MACHINE(qdev_get_machine());
> > > +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> > > +
> > > +    topo->cpus = ms->smp.cores * ms->smp.threads;> +
> > > +    topo->socket = g_new0(S390TopoContainer, ms->smp.sockets);
> > > +    topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);
> > 
> > 
> > ... here, the tle array is allocated with max_cpus and this looks
> > weird. I will dig the specs to try to understand.
> 
> ack it looks weird. I keep only the socket structure

[...]
