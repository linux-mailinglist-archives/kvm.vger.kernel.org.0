Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4DF68D983
	for <lists+kvm@lfdr.de>; Tue,  7 Feb 2023 14:38:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjBGNiB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Feb 2023 08:38:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjBGNiA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Feb 2023 08:38:00 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2ECB29416
        for <kvm@vger.kernel.org>; Tue,  7 Feb 2023 05:37:55 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 317CEgtX028198;
        Tue, 7 Feb 2023 13:37:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=h7mmZ4IX2cyxBeNXOteLGgJt0sfICTaspfIP6CibGDQ=;
 b=OrXPbVRt1e0nHLuoqqNETuiAxCaTd/ekRtczT0YhonI7pb6z0jLdYSVNqDgpi+LlJtpo
 Dn7FwKyWKWDczskIC44u8DUJRB4SDWwGatRRfb+KLLf1GOyYEs943BarR73H58X5H9GU
 wAMR/+RB47TO73X6BiK8+xXgqH46a+pN5mkVxUusqe8ogDMNQoU/jnl7vLDs53AdTBBP
 YyBBT8IgXZSJmyta1QJm/8xQyvF9o6iAsw3nfaL4e0nxyGtbKxfGotBOF6xRwpVqkRhx
 1fyf9jYFwm5V+AaF+gSl1y/Nzk7NBUVJah2rr+LluNBmXOznqRe9E4j77/3fzhU2PBaW EQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkpfut5ku-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:37:49 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 317DARWX024130;
        Tue, 7 Feb 2023 13:37:48 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nkpfut5jw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:37:48 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 316NYJdv000405;
        Tue, 7 Feb 2023 13:37:46 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3nhf06tkew-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 07 Feb 2023 13:37:46 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 317DbgWF49807648
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 7 Feb 2023 13:37:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C16C920043;
        Tue,  7 Feb 2023 13:37:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BDEC20040;
        Tue,  7 Feb 2023 13:37:42 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.183.69])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue,  7 Feb 2023 13:37:42 +0000 (GMT)
Message-ID: <d53ff9ed9d3f28abd504763f060c4c6c4f7f9553.camel@linux.ibm.com>
Subject: Re: [PATCH v15 05/11] s390x/cpu topology: resetting the
 Topology-Change-Report
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org
Cc:     qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Tue, 07 Feb 2023 14:37:42 +0100
In-Reply-To: <78b4f4c2-511e-f8bd-6f4b-8c13f4d87fe1@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-6-pmorel@linux.ibm.com>
         <3215597a6916932c26fdbe1dd8daf2fc0c1c1ab5.camel@linux.ibm.com>
         <f4732cd4-67bb-a2a3-0048-3a2118b52fc1@linux.ibm.com>
         <669fea20042a31d009b5f3d9371bcf88f32d5d49.camel@linux.ibm.com>
         <78b4f4c2-511e-f8bd-6f4b-8c13f4d87fe1@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qMZE5osEqD65UramMeeXKWJA55UyDFlI
X-Proofpoint-ORIG-GUID: p0SzP3WPM7wMyOM6jUtfVvA0jupiL_3M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-07_05,2023-02-06_03,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 bulkscore=0
 clxscore=1015 suspectscore=0 phishscore=0 spamscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 impostorscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302070121
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2023-02-07 at 13:19 +0100, Pierre Morel wrote:
>=20
> On 2/7/23 11:50, Nina Schoetterl-Glausch wrote:
> > On Tue, 2023-02-07 at 10:24 +0100, Pierre Morel wrote:
> > >=20
> > > On 2/6/23 18:52, Nina Schoetterl-Glausch wrote:
> > > > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > > > During a subsystem reset the Topology-Change-Report is cleared
> > > > > by the machine.
> > > > > Let's ask KVM to clear the Modified Topology Change Report (MTCR)
> > > > > bit of the SCA in the case of a subsystem reset.
> > > > >=20
> > > > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > > > ---
> > > > >    include/hw/s390x/cpu-topology.h |  1 +
> > > > >    target/s390x/cpu.h              |  1 +
> > > > >    target/s390x/kvm/kvm_s390x.h    |  1 +
> > > > >    hw/s390x/cpu-topology.c         | 12 ++++++++++++
> > > > >    hw/s390x/s390-virtio-ccw.c      |  3 +++
> > > > >    target/s390x/cpu-sysemu.c       | 13 +++++++++++++
> > > > >    target/s390x/kvm/kvm.c          | 17 +++++++++++++++++
> > > > >    7 files changed, 48 insertions(+)
> > > > >=20
> > > > > diff --git a/include/hw/s390x/cpu-topology.h b/include/hw/s390x/c=
pu-topology.h
> > > > > index 1ae7e7c5e3..60e0b9fbfa 100644
> > > > > --- a/include/hw/s390x/cpu-topology.h
> > > > > +++ b/include/hw/s390x/cpu-topology.h
> > > > > @@ -66,5 +66,6 @@ static inline void s390_topology_set_cpu(Machin=
eState *ms,
> > > > >   =20
> > > > >    extern S390Topology s390_topology;
> > > > >    int s390_socket_nb(S390CPU *cpu);
> > > > > +void s390_topology_reset(void);
> > > > >   =20
> > > > >    #endif
> > > > > diff --git a/target/s390x/cpu.h b/target/s390x/cpu.h
> > > > > index e1f6925856..848314d2a9 100644
> > > > > --- a/target/s390x/cpu.h
> > > > > +++ b/target/s390x/cpu.h
> > > > > @@ -641,6 +641,7 @@ typedef struct SysIBTl_cpu {
> > > > >    QEMU_BUILD_BUG_ON(sizeof(SysIBTl_cpu) !=3D 16);
> > > > >   =20
> > > > >    void insert_stsi_15_1_x(S390CPU *cpu, int sel2, __u64 addr, ui=
nt8_t ar);
> > > > > +void s390_cpu_topology_reset(void);
> > > >=20
> > > > How about you call this s390_cpu_topology_reset_modified, so it's s=
ymmetric
> > > > with the function you define in the next patch. You could also drop=
 the "cpu"
> > > > from the name.
> > >=20
> > > I am not sure about this, Thomas already gave his R-B on this patch s=
o I
> > > prefer to stay on the original name, unless he says it is a good idea=
 to
> > > change.
> > > Also in cpu-sysemu.c most of the function are tagged with _cpu_
> >=20
> > IMO, renaming a function would be a small enough change to keep an R-b.
> > >=20
> > > >=20
> > > > Or maybe even better, you only define a function for setting the mo=
dified state,
> > > > but make it take a bool argument. This way you also get rid of some=
 code duplication
> > > > and it wouldn't harm readability IMO.
> > >=20
> > > There is already a single function kvm_s390_topology_set_mtcr(attr) t=
o
> > > set the "modified state"
> >=20
> > Yes, but that is for KVM only and doesn't do error handling.
> > So you need at least one function on top of that. What I'm suggesting i=
s to
> > only have one function instead of two because it gets rid of some code.
>=20
> OK this is right.
> I rename
> void s390_cpu_topology_reset(void);
> to
> void s390_cpu_topology_set_mtcr(int value);

I don't find mtcr very descriptive and a bit of a SIE/KVM name, it might no=
t
fit a possible future tcg implementation.
I'd just call it s390_cpu_topology_set_changed/modified, and have it take a=
 bool,
because I cannot imagine other int values to make sense.

>=20
> and then:
>=20
> -    s390_cpu_topology_reset();
> +    s390_cpu_topology_set_mtcr(0);
>=20
>=20
> > >=20
> > > >=20
> > > > >   =20
> > > > >    /* MMU defines */
> > > > >    #define ASCE_ORIGIN           (~0xfffULL) /* segment table ori=
gin             */
> > > > > diff --git a/target/s390x/kvm/kvm_s390x.h b/target/s390x/kvm/kvm_=
s390x.h
> > > > > index f9785564d0..649dae5948 100644
> > > > > --- a/target/s390x/kvm/kvm_s390x.h
> > > > > +++ b/target/s390x/kvm/kvm_s390x.h
> > > > > @@ -47,5 +47,6 @@ void kvm_s390_crypto_reset(void);
> > > > >    void kvm_s390_restart_interrupt(S390CPU *cpu);
> > > > >    void kvm_s390_stop_interrupt(S390CPU *cpu);
> > > > >    void kvm_s390_set_diag318(CPUState *cs, uint64_t diag318_info)=
;
> > > > > +int kvm_s390_topology_set_mtcr(uint64_t attr);
> > > > >   =20
> > > > >    #endif /* KVM_S390X_H */
> > > > > diff --git a/hw/s390x/cpu-topology.c b/hw/s390x/cpu-topology.c
> > > > > index a80a1ebf22..cf63f3dd01 100644
> > > > > --- a/hw/s390x/cpu-topology.c
> > > > > +++ b/hw/s390x/cpu-topology.c
> > > > > @@ -85,6 +85,18 @@ static void s390_topology_init(MachineState *m=
s)
> > > > >        QTAILQ_INSERT_HEAD(&s390_topology.list, entry, next);
> > > > >    }
> > > > >   =20
> > > > > +/**
> > > > > + * s390_topology_reset:
> > > > > + *
> > > > > + * Generic reset for CPU topology, calls s390_topology_reset()
> > > > > + * s390_topology_reset() to reset the kernel Modified Topology
> > > > > + * change record.
> > > > > + */
> > > > > +void s390_topology_reset(void)
> > > > > +{
> > > >=20
> > > > I'm wondering if you shouldn't move the reset changes you do in the=
 next patch
> > > > into this one. I don't see what they have to do with PTF emulation.
> > >=20
> > > Here in this patch we do not intercept PTF and we have only an
> > > horizontal polarity.
> > > So we do not need to reset the polarity for all the vCPUs, we only ne=
ed
> > > it when we have vertical polarity.
> >=20
> > Well, with the PTF patch you don't get vertical polarity either, becaus=
e you
> > only enable the topology with patch 7.
> > And since it's about resetting, it fits better in this patch IMO.
>=20
> Not in my opinion, suppose the next patch never get included it has no=
=20
> sense.

Well, yes, but then the series would be broken, since the facility requires=
 PTF to work.

> However if there is a majority in favor of this change I will do it.
>=20
> Regards,
> Pierre
>=20

