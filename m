Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4296F011E
	for <lists+kvm@lfdr.de>; Thu, 27 Apr 2023 08:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242894AbjD0G5p (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Apr 2023 02:57:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232094AbjD0G5o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Apr 2023 02:57:44 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A061630EE;
        Wed, 26 Apr 2023 23:57:43 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33R6cci3032349;
        Thu, 27 Apr 2023 06:57:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 from : subject : to : message-id : date; s=pp1;
 bh=Nf4FgwH/CJciV+SvG5cBvuLeuLLWv+tfhziOh5xnCS8=;
 b=amxBoSx10EDMeeo4j15JeKiY/rKVEApULzJqtNZuvLqllVOBJYMwvc8fYpOW9Dq4o2O6
 BgPbbNfocPgNvx/RAHqSecvoS19sXKiTYnmPJGmMF6FqdRj8HittTDdaBsws+rLl7YZl
 RrHf6BCp0d2a+n9JnwPAB9mgfQ4sQQAklu6Y0kf8yEi4FnCjBbuGz4nHG+iju3sUF0k/
 fLJpk5lACht44cre9QHJS78jGO+VuLwZ3cmM5+rKlo4/x0I0jsxTCX9C2Jda8Id0GybE
 83vaOiUb8YVyGDI35tLWGzhPXTXbAAB6mwS0sVJ6eLAYSP0AXmQw+LlDoe2QHunHcnX6 KA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7h2vvu93-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 06:57:42 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33R6vgCr015015;
        Thu, 27 Apr 2023 06:57:42 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q7h2vvu8m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 06:57:42 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QLPePc020733;
        Thu, 27 Apr 2023 06:57:40 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3q46ug2s6j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Apr 2023 06:57:40 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33R6vaNR22282972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Apr 2023 06:57:36 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 994AE2004E;
        Thu, 27 Apr 2023 06:57:36 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 673BD20043;
        Thu, 27 Apr 2023 06:57:36 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.6.166])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 27 Apr 2023 06:57:36 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230426083426.6806-2-pmorel@linux.ibm.com>
References: <20230426083426.6806-1-pmorel@linux.ibm.com> <20230426083426.6806-2-pmorel@linux.ibm.com>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v8 1/2] s390x: topology: Check the Perform Topology Function
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168257865594.44728.1799002877053720751@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 27 Apr 2023 08:57:35 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: I_t1y52MXy-FqWhzNmMefOLqWXqT9M6w
X-Proofpoint-GUID: 5MTLXlgRHp_udQwCgUg0YNZNCRPlPza0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-27_04,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 clxscore=1015
 mlxlogscore=719 phishscore=0 adultscore=0 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304270057
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-04-26 10:34:25)
[...]
> diff --git a/s390x/topology.c b/s390x/topology.c
> new file mode 100644
> index 0000000..07f1650
> --- /dev/null
> +++ b/s390x/topology.c
> @@ -0,0 +1,191 @@
[...]
> +#define PTF_INVALID_FUNCTION   0xff

No longer used?

[...]
> +static void check_specifications(void)
> +{
> +       unsigned long wrong_bits =3D 0;
> +       unsigned long ptf_bits;
> +       unsigned long rc;
> +       int i;
> +
> +       report_prefix_push("Specifications");
> +
> +       /* Function codes above 3 are undefined */
> +       for (i =3D 4; i < 255; i++) {
> +               expect_pgm_int();
> +               ptf(i, &rc);
> +               mb();
> +               if (lowcore.pgm_int_code !=3D PGM_INT_CODE_SPECIFICATION)=
 {

Please use clear_pgm_int(), the return value will be the interruption code.=
 You can also get rid of the barrier then.

Also, using wrong_bits is confusing here since it serves a completely diffe=
rent purpose below.

Maybe just:

if (clear_pgm_int() !=3D PGM_INT_CODE_SPECIFICATION)
    report_fail("FC %d did not yield specification exception", i);

[...]
> +       /* Reserved bits must be 0 */
> +       for (i =3D 8, wrong_bits =3D 0; i < 64; i++) {
> +               ptf_bits =3D 0x01UL << i;
> +               expect_pgm_int();
> +               ptf(ptf_bits, &rc);
> +               mb();
> +               if (lowcore.pgm_int_code !=3D PGM_INT_CODE_SPECIFICATION)

Also use clear_pgm_int() here.
