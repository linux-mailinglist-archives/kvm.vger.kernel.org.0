Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29AF610296
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 22:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236925AbiJ0UUu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 16:20:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236944AbiJ0UUs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 16:20:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CBC75DF2A
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 13:20:45 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29RKIqKN025692;
        Thu, 27 Oct 2022 20:20:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=C77jLXcEwrqhwY1a6x1KYJWa8qVXlcnsxpHunhGlW0w=;
 b=oTVrTSk9jxml+Efa4IXKSlzjvQyrkEJzJ/V0Xrx55/DOsVrOgfA7WpFAkOT6V1LRtISF
 EIK/zs6hxLf/ScVvh57RvD1jbBTw7ZqBMVzzO/unDpdxdvQcqZQP3lDsGo8GmqaqSs6W
 8HKSpxKd38iWLLi5Fxv6+txc23NO093NwFToDnruqNCTjmBsNB2GcTz1oKwr/R9PLT50
 GUukVGxbvgUYGQGzJbBRJ/lPpt8NxLqp0UOoDwIoyeK/AaXmDvxa1B0pGQJ3rn4M3/pL
 gJjLcL5hBiC56rSzcdqoxKVgO7vYAHOduqiTe4Ds/8IDUMSLw2FrHhgegIuW/fDmMG8J TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kg0wsr1jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 20:20:31 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29RKIos3025620;
        Thu, 27 Oct 2022 20:20:31 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kg0wsr1gq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 20:20:30 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 29RJpUji019207;
        Thu, 27 Oct 2022 20:20:28 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 3kfahqjmdh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Oct 2022 20:20:28 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 29RKKPQc58786254
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 20:20:25 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 24F75A4059;
        Thu, 27 Oct 2022 20:20:25 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E1FCA404D;
        Thu, 27 Oct 2022 20:20:24 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.94.180])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Oct 2022 20:20:24 +0000 (GMT)
Message-ID: <c1c2a492596c3f853ca260e22ba2c9f8afb9a0ae.camel@linux.ibm.com>
Subject: Re: [PATCH v10 1/9] s390x/cpu topology: core_id sets s390x CPU
 topology
From:   Janis Schoetterl-Glausch <scgl@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 27 Oct 2022 22:20:23 +0200
In-Reply-To: <15b829ca-14d0-dc77-5e1e-1b4455784ed6@linux.ibm.com>
References: <20221012162107.91734-1-pmorel@linux.ibm.com>
         <20221012162107.91734-2-pmorel@linux.ibm.com>
         <ad2a9892184cd5dc7597d411f42e330558146acf.camel@linux.ibm.com>
         <15b829ca-14d0-dc77-5e1e-1b4455784ed6@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Cet0PrCha0D_IKs0ihX9Y-wRDKXWGEZ9
X-Proofpoint-ORIG-GUID: 545YRZgEDipKKkarnLW9N57LclB3JtBl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-27_07,2022-10-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 bulkscore=0 phishscore=0 adultscore=0 clxscore=1015
 malwarescore=0 mlxlogscore=999 mlxscore=0 suspectscore=0
 lowpriorityscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2210270112
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-10-26 at 10:34 +0200, Pierre Morel wrote:
> 
> On 10/25/22 21:58, Janis Schoetterl-Glausch wrote:
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
> > [...]
> > 
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
> > > +    MachineState *ms = MACHINE(qdev_get_machine());
> > > +    S390Topology *topo = S390_CPU_TOPOLOGY(dev);
> > > +
> > > +    topo->cpus = ms->smp.cores * ms->smp.threads;
> > 
> > Currently threads are not supported, effectively increasing the number of cpus,
> > so this is currently correct. Once the machine version limits the threads to 1,
> > it is also correct. However, once we support multiple threads, this becomes incorrect.
> > I wonder if it's ok from a backward compatibility point of view to modify the smp values
> > by doing cores *= threads, threads = 1 for old machines.
> 
> Right, this will become incorrect with thread support.
> What about having a dedicated function:
> 
> 	topo->cpus = s390_get_cpus(ms);
> 
> This function will use the S390CcwMachineClass->max_thread introduced 
> later to report the correct number of CPUs.

I don't think max_threads is exactly what matters here, it's if
threads are supported or not or, if max_threads == 1 it doesn't matter.
The question is how best to do the check. You could check the machine version.
I wonder if you could add a feature bit for the multithreading facility that is
always false and use that.

I don't know if using a function makes a difference, that is if it is obvious on
introduction of multithreading support that the function needs to be updated.
(If it is implemented in a way that requires updating, if you check the machine
version it doesn't)
In any case, the name you suggested isn't very descriptive.
> 
> 
> > Then you can just use the cores value and it is always correct.
> > In any case, if you keep it as is, I'd like to see a comment here saying that this
> > is correct only so long as we don't support threads.
> > > +
> > > +    topo->socket = g_new0(S390TopoContainer, ms->smp.sockets);
> > > +    topo->tle = g_new0(S390TopoTLE, ms->smp.max_cpus);
> > > +
> > > +    topo->ms = ms;
> > > +}
> > > +
> > [...]
> 

