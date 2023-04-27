Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446B56F02C5
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 10:47:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243003AbjD0Irg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 04:47:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242131AbjD0Irf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 04:47:35 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FF0213A;
        Thu, 27 Apr 2023 01:47:34 -0700 (PDT)
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R8bEMD007154;
        Thu, 27 Apr 2023 08:47:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=SDI/VWEp6PjcC/VhRBvBfSEW9oMqyP/o6Aah3BFcxzA=;
 b=TOdO7tJWMmnO+uG6ICLPvVFH89dZZ1JfNa/sMBRFIpw/WZCOIF4Vz7m9dT809ndnIISl
 JMMXWk78s79KpP5XRyYNF9ekDf2fmiRsImNiQO9dPcatLDbdxa+s2Wf98HmmezLxGxfK
 50pxR+tzgG73XuhDZXZCkx/LWrz9Skg/VpWs86lZopRJHB/Vkj5f4FSXsU9W28y01bnN
 2Zvlplf7u2pr3J+++5V9CuW/gMbnLJHaq37jhsGJuB9kkj9j7yuWhoXjruOODEifybL4
 8ZBpGLdRVRz+iJd7TuXCzKE1ltYuZYLTFdH4kt7v9ByI5R8uOV3LCODFQUIrFLge2eyz rQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7m7ru09u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:47:33 +0000
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33R8bbj8010454;
        Thu, 27 Apr 2023 08:47:33 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7m7ru05f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:47:32 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33R4sxLa031508;
        Thu, 27 Apr 2023 08:47:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3q47772uq9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 08:47:27 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33R8lOcp18612804
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 08:47:24 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 244F12004E;
        Thu, 27 Apr 2023 08:47:24 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DD73620040;
        Thu, 27 Apr 2023 08:47:23 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.67.236])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 08:47:23 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230426083426.6806-3-pmorel@linux.ibm.com>
References: <20230426083426.6806-1-pmorel@linux.ibm.com> <20230426083426.6806-3-pmorel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v8 2/2] s390x: topology: Checking Configuration Topology Information
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
Message-ID: <168258524358.99032.14388431972069131423@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 27 Apr 2023 10:47:23 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: nf5WbcKBTvAZiCFcc72N11yy5ymBLsVL
X-Proofpoint-GUID: CWfYQeArgp2_9rcKMeJ930vWXMTLLkyt
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_06,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 priorityscore=1501 bulkscore=0 clxscore=1015 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304270073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-04-26 10:34:26)
> diff --git a/s390x/topology.c b/s390x/topology.c
> index 07f1650..42a9cc9 100644
> --- a/s390x/topology.c
> +++ b/s390x/topology.c
> @@ -17,6 +17,20 @@
[...]
> +/**
> + * check_tle:
> + * @tc: pointer to first TLE
> + *
> + * Recursively check the containers TLEs until we
> + * find a CPU TLE.
> + */
> +static uint8_t *check_tle(void *tc)
> +{
[...]
> +
> +       report(!cpus->d || (cpus->pp =3D=3D 3 || cpus->pp =3D=3D 0),
> +              "Dedication versus entitlement");

Again, I would prefer something like this:

if (!cpus->d)
    report_skip("Not dedicated")
else
    report(cpus->pp =3D=3D 3 || cpus->pp =3D=3D 0, "Dedicated CPUs are eith=
er vertically polarized or have high entitlement")

No?

[...]

> +/**
> + * check_sysinfo_15_1_x:
> + * @info: pointer to the STSI info structure
> + * @sel2: the selector giving the topology level to check
> + *
> + * Check if the validity of the STSI instruction and then
> + * calls specific checks on the information buffer.
> + */
> +static void check_sysinfo_15_1_x(struct sysinfo_15_1_x *info, int sel2)
> +{
> +       int ret;
> +       int cc;
> +       unsigned long rc;
> +
> +       report_prefix_pushf("15_1_%d", sel2);
> +
> +       ret =3D stsi_get_sysib(info, sel2);
> +       if (ret) {
> +               report_skip("Selector 2 not supported by architecture");
> +               goto end;
> +       }
> +
> +       report_prefix_pushf("H");
> +       cc =3D ptf(PTF_REQ_HORIZONTAL, &rc);
> +       if (cc !=3D 0 && rc !=3D PTF_ERR_ALRDY_POLARIZED) {
> +               report(0, "Unable to set horizontal polarization");

report_fail() please

> +               goto vertical;
> +       }
> +
> +       stsi_check_mag(info);
> +       stsi_check_tle_coherency(info);
> +
> +vertical:
> +       report_prefix_pop();
> +       report_prefix_pushf("V");
> +
> +       cc =3D ptf(PTF_REQ_VERTICAL, &rc);
> +       if (cc !=3D 0 && rc !=3D PTF_ERR_ALRDY_POLARIZED) {
> +               report(0, "Unable to set vertical polarization");

report_fail() please

[...]
> +static int arch_max_cpus(void)

Does the name arch_max_cpus() make sense? Maybe expected_num_cpus()?

> diff --git a/s390x/unittests.cfg b/s390x/unittests.cfg
> index fc3666b..375e6ce 100644
> --- a/s390x/unittests.cfg
> +++ b/s390x/unittests.cfg
> @@ -221,3 +221,6 @@ file =3D ex.elf
> =20
>  [topology]
>  file =3D topology.elf
> +# 3 CPUs on socket 0 with different CPU TLE (standard, dedicated, origin)
> +# 1 CPU on socket 2
> +extra_params =3D -smp 1,drawers=3D3,books=3D3,sockets=3D4,cores=3D4,maxc=
pus=3D144 -cpu z14,ctop=3Don -device z14-s390x-cpu,core-id=3D1,entitlement=
=3Dlow -device z14-s390x-cpu,core-id=3D2,dedicated=3Don -device z14-s390x-c=
pu,core-id=3D10 -device z14-s390x-cpu,core-id=3D20 -device z14-s390x-cpu,co=
re-id=3D130,socket-id=3D0,book-id=3D0,drawer-id=3D0 -append '-drawers 3 -bo=
oks 3 -sockets 4 -cores 4'

If I got the command line right, all CPUs are on the same drawer with this =
command line, aren't they? If so, does it make sense to run with different =
combinations, i.e. CPUs on different drawers, books etc?
