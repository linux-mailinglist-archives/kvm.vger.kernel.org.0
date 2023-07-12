Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D0B7504D8
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 12:39:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232012AbjGLKjY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 06:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231921AbjGLKjV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 06:39:21 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8DA1FC8;
        Wed, 12 Jul 2023 03:38:59 -0700 (PDT)
Received: from pps.filterd (m0353722.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36CATdtd010895;
        Wed, 12 Jul 2023 10:38:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=bAN5PzjuoLeFJcc3AbJBgN8awbksB/RH5I6I/iCwsj8=;
 b=pZqlIAsKu9gzwlYqYzgCNoInisWpehf9azXnX7kXdcDMmmNFZUcSv5LVmqjc9+C/RcbJ
 CNDsBPC2qwQzQaI4EJHAwnhHTCprk40R6jzdHxvIFEgbKUdbqnzi0k0Ls2/M6doLkH/1
 EN5qWuWZGmyNu6U4EwtKexZZdsPVKX03GOAzL5hzl1YmjRrwr6GTiYcuDRMScEeRBDnD
 lVljvuBJ1OCYPfsyScIJ+nitI1X1AnQFbBs9iziwmZpNiufhV2U0HgIPY1OGFfCD6Sl2
 /jV5sKK42C6pE3Snq6b4eWAJQuJl9HgeTtKR7BKgMMLSdX3u9ZvQMaYwXKBVEY5tYV2E Pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rstfcg92u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 10:38:56 +0000
Received: from m0353722.ppops.net (m0353722.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 36CAVWrt018094;
        Wed, 12 Jul 2023 10:37:17 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rstfcg7hj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 10:37:17 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 36C149Mo013796;
        Wed, 12 Jul 2023 10:36:08 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3rpy2e9vff-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jul 2023 10:36:08 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 36CAa5bT42336876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 12 Jul 2023 10:36:05 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13B7520043;
        Wed, 12 Jul 2023 10:36:05 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9531720040;
        Wed, 12 Jul 2023 10:36:04 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.71.117])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 12 Jul 2023 10:36:04 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230711073514.413364-3-nrb@linux.ibm.com>
References: <20230711073514.413364-1-nrb@linux.ibm.com> <20230711073514.413364-3-nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v4 2/6] s390x: add function to set DAT mode for all interrupts
From:   Nico Boehr <nrb@linux.ibm.com>
To:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
Message-ID: <168915816326.78841.11857684763351919863@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 12 Jul 2023 12:36:03 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: RyWLn6eznbKVB9tRzhcUBOooAL-5p5lZ
X-Proofpoint-GUID: y_zG8LLVW00XG5mdD499AAPam5D6bwvg
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-12_06,2023-07-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 suspectscore=0 phishscore=0 adultscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=850 lowpriorityscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307120094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nico Boehr (2023-07-11 09:35:10)
[...]
> diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> index 3f993a363ae2..d97b5a3a7e97 100644
> --- a/lib/s390x/interrupt.c
> +++ b/lib/s390x/interrupt.c
[...]
> +void irq_set_dat_mode(bool dat, uint64_t as)
> +{
> +       struct psw* irq_psws[] =3D {
> +               OPAQUE_PTR(GEN_LC_EXT_NEW_PSW),
> +               OPAQUE_PTR(GEN_LC_SVC_NEW_PSW),
> +               OPAQUE_PTR(GEN_LC_PGM_NEW_PSW),
> +               OPAQUE_PTR(GEN_LC_MCCK_NEW_PSW),
> +               OPAQUE_PTR(GEN_LC_IO_NEW_PSW),
> +               NULL /* sentinel */
> +       };
> +
> +       assert(as =3D=3D AS_PRIM || as =3D=3D AS_ACCR || as =3D=3D AS_SEC=
N || as =3D=3D AS_HOME);
> +
> +       for (struct psw *psw =3D irq_psws[0]; psw !=3D NULL; psw++) {

This is obviously completely wrong and leads to a bunch of random memory in
lowcore being overwritten. For weird optimization reasons, this actually
terminates. I will sent a fixed version, where I simply don't do fancy poin=
ter
stuff but just iterate over an array index...

Thanks Claudio.
