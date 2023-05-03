Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC396F577A
	for <lists+kvm@lfdr.de>; Wed,  3 May 2023 13:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjECL4h (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 3 May 2023 07:56:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjECL4f (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 3 May 2023 07:56:35 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A861BFC;
        Wed,  3 May 2023 04:56:32 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 343BsCAR012111;
        Wed, 3 May 2023 11:56:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : subject : cc : message-id : date; s=pp1;
 bh=S33JR8bjL3PKZ1TbqVK0DIYgv5GWbyTkRR4cOAd1xuQ=;
 b=X77YAlLYextwmuOTrBNAiOvkIqHriLJCJkf3vzn0kQ02s9qxCEparZeTN2piiPMaDrDQ
 DriJ49CMB8izAKBiuKZTjjHj3ianiaTT/Z7pRlFFr9I7fYgdPYE6iCNDNIWmChCrjalD
 dMZc5nM/Epp7hGTC4uR/zkotP9zvCIOyp1yNpWScRZ5gXh/FrhKVAS3Q2C/MdKNJgDDD
 1pafhuWQFsCl675IEi1xIMya4p14nq6/RA3qxPqnV2x2DVT4Od4xZZ8KF6FqawgXGLiB
 AXEgENwbItHTXGJyhROj4HNbx1O9rBKqGH2K8JxaBTJmYaUoYTbShERKfWCpTGh6JdMq Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbq51g1j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 11:56:31 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 343BtJTs015345;
        Wed, 3 May 2023 11:56:31 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qbq51g1hp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 11:56:30 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34377rPj024369;
        Wed, 3 May 2023 11:56:29 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3q8tgfst5x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 May 2023 11:56:29 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 343BuPM421496546
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 3 May 2023 11:56:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 953332004B;
        Wed,  3 May 2023 11:56:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C03320040;
        Wed,  3 May 2023 11:56:25 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.43.83])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  3 May 2023 11:56:25 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <8122e0de-7cbb-83f2-4c3a-7a50f0d5b205@linux.ibm.com>
References: <20230426083426.6806-1-pmorel@linux.ibm.com> <20230426083426.6806-3-pmorel@linux.ibm.com> <168258524358.99032.14388431972069131423@t14-nrb> <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com> <168266833708.15302.621201335459420614@t14-nrb> <8122e0de-7cbb-83f2-4c3a-7a50f0d5b205@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking Configuration Topology Information
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
Message-ID: <168311498507.14421.10981394117035080962@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 03 May 2023 13:56:25 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KGnR3WsasNTSebOvQ6p410S3faFN46WY
X-Proofpoint-GUID: xnOPxg4V0sFYFXXkoNq62tn7sm6zDEXJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-03_07,2023-05-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 adultscore=0 spamscore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2305030097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-04-28 15:10:07)
>=20
> On 4/28/23 09:52, Nico Boehr wrote:
> > Quoting Pierre Morel (2023-04-27 16:50:16)
> > [...]
> >>>> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> >>>> index fc3666b..375e6ce 100644
> >>>> --- a/s390x/unittests.cfg
> >>>> +++ b/s390x/unittests.cfg
> >>>> @@ -221,3 +221,6 @@ file =3D ex.elf
> >>>>   =20
> >>>>    [topology]
> >>>>    file =3D topology.elf
> >>>> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, o=
rigin)
> >>>> +# 1 CPU on socket 2
> >>>> +extra_params =3D -smp 1,drawers=3D3,books=3D3,sockets=3D4,cores=3D4=
,maxcpus=3D144 -cpu z14,ctop=3Don -device z14-s390x-cpu,core-id=3D1,entitle=
ment=3Dlow -device z14-s390x-cpu,core-id=3D2,dedicated=3Don -device z14-s39=
0x-cpu,core-id=3D10 -device z14-s390x-cpu,core-id=3D20 -device z14-s390x-cp=
u,core-id=3D130,socket-id=3D0,book-id=3D0,drawer-id=3D0 -append '-drawers 3=
 -books 3 -sockets 4 -cores 4'
> >>> If I got the command line right, all CPUs are on the same drawer with=
 this command line, aren't they? If so, does it make sense to run with diff=
erent combinations, i.e. CPUs on different drawers, books etc?
> >> OK, I will add some CPU on different drawers and books.
> > just to clarify: What I meant is adding an *additional* entry to unitte=
sts.cfg. Does it make sense in your opinion? I just want more coverage for =
different scenarios we may have.
>=20
> Ah OK, yes even better.
>=20
> In this test I chose the values randomly, I can add 2 other tests like
>=20
> - once with the maximum of CPUs like:
>=20
> [topology-2]
> file =3D topology.elf
> extra_params =3D -smp drawers=3D3,books=3D4,sockets=3D5,cores=3D4,maxcpus=
=3D240=C2=A0=20
> -append '-drawers 3 -books 4 -sockets 5 -cores 4'
>=20
>=20
> or having 8 different TLE on the same socket
>=20
> [topology-2]
>=20
> file =3D topology.elf
> extra_params =3D -smp 1,drawers=3D2,books=3D2,sockets=3D2,cores=3D30,maxc=
pus=3D240=C2=A0=20
> -append '-drawers 2 -books 2 -sockets 2 -cores 30' -cpu z14,ctop=3Don=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D2,entitle=
ment=3Dlow=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D3,entitle=
ment=3Dmedium=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D4,entitle=
ment=3Dhigh=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D5,entitle=
ment=3Dhigh,dedicated=3Don=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D65,entitl=
ement=3Dlow=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D66,entitl=
ement=3Dmedium=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D67,entitl=
ement=3Dhigh=20
> -device=20
> z14-s390x-cpu,drawer-id=3D1,book-id=3D0,socket-id=3D0,core-id=3D68,entitl=
ement=3Dhigh,dedicated=3Don
>=20
>=20
> What do you think is the best ?

I think both do make sense, since they cover differenct scenarios, don't th=
ey?
