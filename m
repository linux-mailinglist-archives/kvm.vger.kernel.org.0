Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B167C690C2A
	for <lists+kvm@lfdr.de>; Thu,  9 Feb 2023 15:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbjBIOur (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Feb 2023 09:50:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBIOuq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Feb 2023 09:50:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02DD12064
        for <kvm@vger.kernel.org>; Thu,  9 Feb 2023 06:50:43 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 319ELE7O008328;
        Thu, 9 Feb 2023 14:50:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Z4Qt4GiluVOiEpgReQRttMx7hwLp3Yl8oF/M/ZmJguE=;
 b=MorFFusraHb8Cv885hY5hM8h7ldN5XzESwpT/YNAIMRA6sPlJO8fXBXiXcFRtCUg87jc
 3t1CzrOYGt4Sy5cfnV89MeKiNrvm5j706DlVg50oPfM9aFLUv/PcZrB2UYM2o1MiwAfh
 KE8xkCQwS5Ezolg+qr/TgHzn7PQ/+E5uFjaMJTwHU+4TNbRA8Xe/087bX2zCmDe4wPnv
 XQZDMfrtI/NILVtBYvW1muQii2VUBZ9xFnAoCMWLkL8PRhXcD6hjo6RwL6OpkBhMqLwH
 Qe028MUblWRcPwUM0Psoulg+o4Q8Hog4dxkL5Ku+KBXW//OhhcY4hkr5nd2XFigs1LEv Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn2gvh08e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 14:50:29 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 319EMWWf014679;
        Thu, 9 Feb 2023 14:50:28 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3nn2gvh07b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 14:50:28 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3196MNXB025825;
        Thu, 9 Feb 2023 14:50:26 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3nhf06xbsr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Feb 2023 14:50:26 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 319EoMW327984372
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Feb 2023 14:50:22 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0591D20043;
        Thu,  9 Feb 2023 14:50:22 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 94F3720040;
        Thu,  9 Feb 2023 14:50:21 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.156.204])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  9 Feb 2023 14:50:21 +0000 (GMT)
Message-ID: <c4e1fc8a172a65dfd099830c98e97513b2222cd3.camel@linux.ibm.com>
Subject: Re: [PATCH v15 10/11] qapi/s390x/cpu topology: CPU_POLARITY_CHANGE
 qapi event
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     qemu-s390x@nongnu.org, qemu-devel@nongnu.org,
        borntraeger@de.ibm.com, pasic@linux.ibm.com,
        richard.henderson@linaro.org, david@redhat.com, thuth@redhat.com,
        cohuck@redhat.com, mst@redhat.com, pbonzini@redhat.com,
        kvm@vger.kernel.org, ehabkost@redhat.com,
        marcel.apfelbaum@gmail.com, eblake@redhat.com,
        seiden@linux.ibm.com, nrb@linux.ibm.com, frankja@linux.ibm.com,
        berrange@redhat.com, clg@kaod.org
Date:   Thu, 09 Feb 2023 15:50:21 +0100
In-Reply-To: <517b73a9-51a5-53ab-538e-58bfb2cf20ae@linux.ibm.com>
References: <20230201132051.126868-1-pmorel@linux.ibm.com>
         <20230201132051.126868-11-pmorel@linux.ibm.com>
         <5b26ee514ccbbfaf5670cbf0cb006d8e706fe5ae.camel@linux.ibm.com>
         <87y1p8q7v6.fsf@pond.sub.org>
         <32389178edcf67ac08904906df9a12aa64f24928.camel@linux.ibm.com>
         <517b73a9-51a5-53ab-538e-58bfb2cf20ae@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 9wqlhC_eM7SNKZEOjrMmdIwcarkdik_b
X-Proofpoint-ORIG-GUID: fiL4LVnDo1_BKXxbOF3QQvqa-ggVpqif
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-09_10,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 clxscore=1015 bulkscore=0 malwarescore=0 lowpriorityscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302090138
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2023-02-09 at 14:00 +0100, Pierre Morel wrote:
>=20
> On 2/9/23 13:28, Nina Schoetterl-Glausch wrote:
> > On Wed, 2023-02-08 at 20:23 +0100, Markus Armbruster wrote:
> > > Nina Schoetterl-Glausch <nsg@linux.ibm.com> writes:
> > >=20
>=20
> ...
>=20
> >=20
> > >=20
> > > > I also wonder if you should add 'feature' : [ 'unstable' ].
> > > > On the upside, it would mark the event as unstable, but I don't kno=
w what the
> > > > consequences are exactly.
> > >=20
> > > docs/devel/qapi-code-gen.rst:
> > >=20
> > >      Special features
> > >      ~~~~~~~~~~~~~~~~
> > >=20
> > >      Feature "deprecated" marks a command, event, enum value, or stru=
ct
> > >      member as deprecated.  It is not supported elsewhere so far.
> > >      Interfaces so marked may be withdrawn in future releases in acco=
rdance
> > >      with QEMU's deprecation policy.
> > >=20
> > >      Feature "unstable" marks a command, event, enum value, or struct
> > >      member as unstable.  It is not supported elsewhere so far.  Inte=
rfaces
> > >      so marked may be withdrawn or changed incompatibly in future rel=
eases.
> >=20
> > Yeah, I saw that, but wasn't aware of -compat, thanks.
> >=20
> > >=20
> > > See also -compat parameters unstable-input, unstable-output, both
> > > intended for "testing the future".
> > >=20
> > > > Also I guess one can remove qemu events without breaking backwards =
compatibility,
> > > > since they just won't be emitted? Unless I guess you specify that a=
 event must
> > > > occur under certain situations and the client waits on it?
> > >=20
> > > Events are part of the interface just like command returns are.  Not
> > > emitting an event in a situation where it was emitted before can easi=
ly
> > > break things.  Only when the situation is no longer possible, the eve=
nt
> > > can be removed safely.
> >=20
> > @Pierre, seems it would be a good idea to mark all changes to qmp unsta=
ble, not just
> > set-cpu-topology, can just remove it later after all.
>=20
> OK.
>=20
> Just curious: how do you think this simple event matching the guest=20
> request 1 on 1 may evolve?

Well, I don't know really, making it unstable is just more conservative for=
 now.
But this way you can prototype/implement support in libvirt for topology an=
d then
make the interface stable one you've confirmed that everything works as int=
ended.

Here is something to think about: The architecture allows rejection of the =
PTF
polarization change request, if a request is currently in process. A possib=
le design
to allow the same semantics for qemu/libvirt would be to set a polarization=
_change_in_progess
bit when a PTF request occurs and refuse subsequent requests until this bit=
 was reset via qmp.
This wouldn't result in the event data structure being changed, but its sem=
antics, since it
isn't fired for every request anymore.

>=20
> Regards,
> Pierre
>=20

