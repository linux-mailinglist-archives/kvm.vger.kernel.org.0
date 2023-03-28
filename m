Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E6626CB71C
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 08:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232717AbjC1G0s (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 02:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232401AbjC1G0S (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 02:26:18 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF4135BF;
        Mon, 27 Mar 2023 23:25:38 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32S4Itxq024766;
        Tue, 28 Mar 2023 06:25:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=SXQto6sc/s5yqYSgq+aOTCmeRorwTBuWFiZZTvwnrTI=;
 b=iFpUBw8/UPtOGqnEkruBOGbR5NP3rXeGvsEGXPyERRtj5XzSGuoRdGII0Df+mYjzH1fd
 UiI4VIYVpMJ5Ov9ce9qnP8iCas0JRHFaeQGoF96avSv7EO9fn6ln6+hqthUmWJXyR5IM
 LYmI9x5jA7DpuMcnf6g1rLa/btEeUI1jfU3E24qisotTTTl8bhR+2QFBD8CRNjqE2TNC
 5r29UdA0t8RTAcSTedC+7nd/xqyNfgZ87THrrbaQfnr+5iWg0t9oVEyhahtdBCoALqqz
 pF5cxXMgYx+OAW8wJCBrlzeSjDb4vC8yJl81FcUVboeVD0/HE73xzC/Zl2xSPjZaT/aG rA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pks3tah68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 06:25:23 +0000
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32S6D5pS012675;
        Tue, 28 Mar 2023 06:25:23 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pks3tah59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 06:25:23 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32RKC4D8004114;
        Tue, 28 Mar 2023 06:25:20 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma04fra.de.ibm.com (PPS) with ESMTPS id 3phrk6b43g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 06:25:20 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32S6PHk367043804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 06:25:17 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 000822004E;
        Tue, 28 Mar 2023 06:25:16 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD6E920043;
        Tue, 28 Mar 2023 06:25:16 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.2.12])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 06:25:16 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <eed972f5-7d94-4db3-c496-60f7d37db0f3@linux.ibm.com>
References: <20230320085642.12251-1-pmorel@linux.ibm.com> <20230320085642.12251-3-pmorel@linux.ibm.com> <167965555147.41638.10047922188597254104@t14-nrb> <eed972f5-7d94-4db3-c496-60f7d37db0f3@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v7 2/2] s390x: topology: Checking Configuration Topology Information
Message-ID: <167998471655.28355.8845167343467425829@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 28 Mar 2023 08:25:16 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: pW4IHJ1kwnRftD7saSIit98-bSsm2FQc
X-Proofpoint-ORIG-GUID: VcS6eiAGiTeIVDfhe0NvfJgCgodxDQom
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-27_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1015
 priorityscore=1501 malwarescore=0 mlxlogscore=999 bulkscore=0 adultscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303280049
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-03-27 14:38:35)
> > [...]
> >> diff --git a/s390x/topology.c b/s390x/topology.c
> >> index ce248f1..11ce931 100644
> >> --- a/s390x/topology.c
> >> +++ b/s390x/topology.c
> > [...]
> >> +/*
> >> + * Topology level as defined by architecture, all levels exists with
> >> + * a single container unless overwritten by the QEMU -smp parameter.
> >> + */
> >> +static int arch_topo_lvl[CPU_TOPOLOGY_MAX_LEVEL]; // =3D {1, 1, 1, 1,=
 1, 1};
> > So that's what is being provided to the test on the command line, right?
> >
> > How about renaming this to expected_topo_lvl?
> >
> > What do you mean by 'defined by architecture'?
>=20
> This is what is provided by the boot arguments and should correspond to=20
> the physical topology.
>=20
> The test checks that this is corresponding to what LPAR or QEMU shows in =

> the SYSIB.

Yep, OK. Makes sense.

> If a topology level always exist physically and if it is not specified=20
> on the QEMU command line it is implicitly unique.

What do you mean by 'implicitly unique'?

> OK for expected_topo_lvl if you prefer.

Yes, please.

> > [...]
> >> +/*
> >> + * stsi_check_mag
> >> + * @info: Pointer to the stsi information
> >> + *
> >> + * MAG field should match the architecture defined containers
> >> + * when MNEST as returned by SCLP matches MNEST of the SYSIB.
> >> + */
> >> +static void stsi_check_mag(struct sysinfo_15_1_x *info)
> >> +{
> >> +       int i;
> >> +
> >> +       report_prefix_push("MAG");
> >> +
> >> +       stsi_check_maxcpus(info);
> >> +
> >> +       /* Explicitly skip the test if both mnest do not match */
> >> +       if (max_nested_lvl !=3D info->mnest)
> >> +               goto done;
> > What does it mean if the two don't match, i.e. is this an error? Or a s=
kip? Or is it just expected?
>=20
> I have no information on the representation of the MAG fields for a=20
> SYSIB with a nested level different than the maximum nested level.
>=20
> There are examples in the documentation but I did not find, and did not=20
> get a clear answer, on how the MAG field are calculated.
>=20
> The examples seems clear for info->mnest between MNEST -1 and 3 but the=20
> explication I had on info->mnest =3D 2 is not to be found in any=20
> documentation.
>=20
> Until it is specified in a documentation I skip all these tests.

Alright - then please:
- update the comment to say:
  "It is not clear how the MAG fields are calculated when mnest in the SYSI=
B 15.x is different from the maximum nested level in the SCLP info, so we s=
kip here for now."
- when this is the case, do a report_skip() and show info->mnest and max_ne=
sted_lvl in the message.
