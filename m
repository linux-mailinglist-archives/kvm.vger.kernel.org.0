Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE696F12DB
	for <lists+kvm@lfdr.de>; Fri, 28 Apr 2023 09:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbjD1HxY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Apr 2023 03:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345270AbjD1HxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Apr 2023 03:53:20 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C0D24ED8;
        Fri, 28 Apr 2023 00:52:52 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33S7kCW5005865;
        Fri, 28 Apr 2023 07:52:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : to : cc : subject : message-id : date; s=pp1;
 bh=6D2b6aDe9MMFLR2IaBOmrejmGqGp+K+dvneE3KpcB9E=;
 b=WUHB/sSCYa1h5O50153E9+f1ER9CbQvAnNuRAY7quVH/GIZdt5UXsgdxS9WFuhN8Lu1v
 kSo27Dr6Zg/1Qv1Kxa74bDL483epFs7lpWFG+xNOeUV5MSs403JSRMoc4hB74Wqzodm1
 ESqS/Kos6NwTlU9tqjSMYSpzbt/PvcO28zl7FCMyNOpSlW8iLM5FOv7874mRJHnsOyyf
 3Q/apOZLUUwEe+36dVv2whJLX1VCGEKQ/rbSCyXwHchUsdaD1LckokYPb8ajAL408L21
 ARoHhEAIhV6N3/OJMm2nB/+yhcPo+aBZJvHPtoiOiV2c0rpo+24hzGH6c4qvmV6vxJ2Y Zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q88te2b4c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 07:52:25 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33S7Sv9a027541;
        Fri, 28 Apr 2023 07:52:24 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q88te2b3d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 07:52:24 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33S7c6kA018753;
        Fri, 28 Apr 2023 07:52:21 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47773dx1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 28 Apr 2023 07:52:21 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33S7qHAV27394734
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Apr 2023 07:52:17 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA3E520040;
        Fri, 28 Apr 2023 07:52:17 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98C1F2004E;
        Fri, 28 Apr 2023 07:52:17 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.67.100])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 28 Apr 2023 07:52:17 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com>
References: <20230426083426.6806-1-pmorel@linux.ibm.com> <20230426083426.6806-3-pmorel@linux.ibm.com> <168258524358.99032.14388431972069131423@t14-nrb> <25a9c3d6-43be-6a08-a32e-5abc520e8c62@linux.ibm.com>
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking Configuration Topology Information
Message-ID: <168266833708.15302.621201335459420614@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 28 Apr 2023 09:52:17 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: acp3ZtwCttx-0wGg9dtsEqPLqZO5KfF7
X-Proofpoint-ORIG-GUID: tjYJGoySvK1WCM-CcKSjzboD0bV-Yz0_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-28_02,2023-04-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 malwarescore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304280061
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-04-27 16:50:16)
[...]
> >> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> >> index fc3666b..375e6ce 100644
> >> --- a/s390x/unittests.cfg
> >> +++ b/s390x/unittests.cfg
> >> @@ -221,3 +221,6 @@ file =3D ex.elf
> >>  =20
> >>   [topology]
> >>   file =3D topology.elf
> >> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, ori=
gin)
> >> +# 1 CPU on socket 2
> >> +extra_params =3D -smp 1,drawers=3D3,books=3D3,sockets=3D4,cores=3D4,m=
axcpus=3D144 -cpu z14,ctop=3Don -device z14-s390x-cpu,core-id=3D1,entitleme=
nt=3Dlow -device z14-s390x-cpu,core-id=3D2,dedicated=3Don -device z14-s390x=
-cpu,core-id=3D10 -device z14-s390x-cpu,core-id=3D20 -device z14-s390x-cpu,=
core-id=3D130,socket-id=3D0,book-id=3D0,drawer-id=3D0 -append '-drawers 3 -=
books 3 -sockets 4 -cores 4'
> > If I got the command line right, all CPUs are on the same drawer with t=
his command line, aren't they? If so, does it make sense to run with differ=
ent combinations, i.e. CPUs on different drawers, books etc?
>=20
> OK, I will add some CPU on different drawers and books.

just to clarify: What I meant is adding an *additional* entry to unittests.=
cfg. Does it make sense in your opinion? I just want more coverage for diff=
erent scenarios we may have.
