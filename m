Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E22B8690868
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 13:13:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbjBIMNQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 07:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjBIMM5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 07:12:57 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97AB1DE
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 04:12:33 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319C0dju016569;
        Thu, 9 Feb 2023 12:12:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=DNHKKgk9PqtgWqi8kDgp7zxoSSh4f18Y0BzdDWUb9Yg=;
 b=XDaoHYmwLN193M40/PMWvYFwsiaJ7BZmNjSiBb/2pt+ozSeYW6UPc/U6+A8lxMJb3rzn
 SPLw3pwInTLsFudibszXWBNmw3ch+MZxPvcvGTGdmWn0ouHI+9vwpEvIkkLlexOr5N0Z
 eNvu9nA5myBplx2rVu0MGuuJ1JUhfpMfRUdKdjUKm6jsa251ELXNOAOrTrYjxi58BDuf
 C9fkukceAED8ucU5Wd8E/qRfQOA/uqAKKXX6QeSwNaec+YSHEafulFvPWaoAzusTM6XC
 CfFSyiWFko60lAqpRh5K66m/fARH1HSe9fWikO+zme8H0PTUNoVYX8nBjnKqFpbzss4r KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn0f9gcyx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:12:25 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319C17jj020425;
        Thu, 9 Feb 2023 12:12:24 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn0f9gcy3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:12:24 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3194sPbh018248;
        Thu, 9 Feb 2023 12:12:22 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3nhf06mbgn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 12:12:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319CCHYd50266414
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 12:12:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DCA032004B;
        Thu,  9 Feb 2023 12:12:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74AD120040;
        Thu,  9 Feb 2023 12:12:17 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.135.170])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 12:12:17 +0000 (GMT)
Message-ID: <4622b3c1e565b89132be8b5a8cda61aef9c5d0f6.camel@linux.ibm.com>
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     "Daniel P." =?ISO-8859-1?Q?Berrang=E9?= <berrange@redhat.com>
Cc:     Pierre Morel <pmorel@linux.ibm.com>, qemu-s390x@nongnu.org,
        qemu-devel@nongnu.org, borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com, armbru@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        clg@kaod.org
Date:   Thu, 09 Feb 2023 13:12:17 +0100
In-Reply-To: <Y+TFRNoOAfZ7QTvp@redhat.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-11-pmorel@linux.ibm.com>
         <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
         <Y+TFRNoOAfZ7QTvp@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -JX1S8K_g0O9nBPlUzquX3j3ffVzMzJX
X-Proofpoint-GUID: oNcO3-iylCci_b6u-xk_we-Ogsqhlehu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-09_08,2023-02-08_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090115
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-09 at 10:04 +0000, Daniel P. Berrang=C3=A9 wrote:
> On Wed, Feb 08, 2023 at 06:35:39PM +0100, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-02-01 at 14:20 +0100, Pierre Morel wrote:
> > > When the guest asks to change the polarity this change
> > > is forwarded to the admin using QAPI.
> > > The admin is supposed to take according decisions concerning
> > > CPU provisioning.
> > >=20
> > > Signed-off-by: Pierre Morel <pmorel@linux.ibm.com>
> > > ---
> > >  qapi/machine-target.json | 30 ++++++++++++++++++++++++++++++
> > >  hw/s390x/cpu-topology.c  |  2 ++
> > >  2 files changed, 32 insertions(+)
> > >=20
> > > diff --git a/qapi/machine-target.json b/qapi/machine-target.json
> > > index 58df0f5061..5883c3b020 100644
> > > --- a/qapi/machine-target.json
> > > +++ b/qapi/machine-target.json
> > > @@ -371,3 +371,33 @@
> > >    },
> > >    'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM' ] }
> > >  }
> > > +
> > > +##
> > > +# @CPU_POLARITY_CHANGE:
> > > +#
> > > +# Emitted when the guest asks to change the polarity.
> > > +#
> > > +# @polarity: polarity specified by the guest
> > > +#
> > > +# The guest can tell the host (via the PTF instruction) whether the
> > > +# CPUs should be provisioned using horizontal or vertical polarity.
> > > +#
> > > +# On horizontal polarity the host is expected to provision all vCPUs
> > > +# equally.
> > > +# On vertical polarity the host can provision each vCPU differently.
> > > +# The guest will get information on the details of the provisioning
> > > +# the next time it uses the STSI(15) instruction.
> > > +#
> > > +# Since: 8.0
> > > +#
> > > +# Example:
> > > +#
> > > +# <- { "event": "CPU_POLARITY_CHANGE",
> > > +#      "data": { "polarity": 0 },
> > > +#      "timestamp": { "seconds": 1401385907, "microseconds": 422329 =
} }
> > > +#
> > > +##
> > > +{ 'event': 'CPU_POLARITY_CHANGE',
> > > +  'data': { 'polarity': 'int' },
> > > +   'if': { 'all': [ 'TARGET_S390X', 'CONFIG_KVM'] }
> >=20
> > I wonder if you should depend on CONFIG_KVM or not. If tcg gets topolog=
y
> > support it will use the same event and right now it would just never be=
 emitted.
> > On the other hand it's more conservative this way.
> >=20
> > I also wonder if you should add 'feature' : [ 'unstable' ].
> > On the upside, it would mark the event as unstable, but I don't know wh=
at the
> > consequences are exactly.
>=20
> The intention of this flag is to allow mgmt apps to make a usage policy
> decision.
>=20
> Libvirt's policy is that we'll never use features marked unstable.

Does it enforce that, e.g via compat policies?
If so, I assume there is some way to allow use of unstable features in libv=
irt for development?
If for example you're prototyping a new mgmt feature that uses unstable com=
mands.

>=20
> IOW, the consequence of marking it unstable is that it'll likely
> go unused until the unstable marker gets removed.
>=20
> Using 'unstable' is useful if you want to get complex code merged
> before you're quite happy with the design, and then iterate on the
> impl in-tree. This is OK if there's no urgent need for apps to
> consume the feature. If you want the feature to be used for real
> though, the unstable flag is not desirable and you need to finalize
> the design.
>=20
> > Also I guess one can remove qemu events without breaking backwards comp=
atibility,
> > since they just won't be emitted? Unless I guess you specify that a eve=
nt must
> > occur under certain situations and the client waits on it?
>=20
> As Markus says, that's not a safe assumption. If a mgmt app is expecting
> to receive an event, ceasing to emit it would likely be considered a
> regression.
>=20
>=20
> With regards,
> Daniel

