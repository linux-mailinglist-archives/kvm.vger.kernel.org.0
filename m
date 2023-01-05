Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0098565F150
	for <lists+kvm@lfdr.de>; Thu,  5 Jan 2023 17:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233386AbjAEQj5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Jan 2023 11:39:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231640AbjAEQj4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Jan 2023 11:39:56 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3B9E5D401
        for <kvm@vger.kernel.org>; Thu,  5 Jan 2023 08:39:55 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 305GRipV012206
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 16:39:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 in-reply-to : references : subject : to : from : cc : message-id : date :
 content-transfer-encoding : mime-version; s=pp1;
 bh=JljXeo4L1wen521eBqYRC37Bx87fAjvOSGUIOi1zopg=;
 b=TfeNjFdj1qjcssDCBGe3tZuQdpsU1PQZwuNiRY5slHH+Hbm2SrsUN0uObMfww1Pfe3/l
 Ma+JDCsDvPp8g/whr9gDGt5c/5xO9OZepNyOeQdkx/CNzgSOwzcCNCR7KupaB+vEXjBO
 3BMeVAmOFreZ9ZVPdxAI9ELCkOpc9CWrrQkVWzCH8loAJTbDb/wnByasA0Hy00GvTiQq
 OMs54g75kpn5LOZ2aUdqISQN6lqV7/qIbNhhUO2XlwPSb/UoOsuP1S4iF22PZDvU0QLO
 PsBpg1/QkVAirP+Q+uWJY79VGTBIrH7YpY/CVh/Sz2GvtnfJ2mycq+F1cp8KlW2ZBFGT Qw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx23ega3f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 05 Jan 2023 16:39:55 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 305GSrvO015097
        for <kvm@vger.kernel.org>; Thu, 5 Jan 2023 16:39:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mx23ega2v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 16:39:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 305535ee001543;
        Thu, 5 Jan 2023 16:39:52 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mtcbff1s0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 05 Jan 2023 16:39:52 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 305Gdmvq44892472
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 5 Jan 2023 16:39:48 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7A41E20043;
        Thu,  5 Jan 2023 16:39:48 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58BDA20040;
        Thu,  5 Jan 2023 16:39:48 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.89.196])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  5 Jan 2023 16:39:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <b525ee76-67ce-f1f9-8b09-b3d447641943@redhat.com>
References: <20230105121538.52008-1-imbrenda@linux.ibm.com> <20230105121538.52008-5-imbrenda@linux.ibm.com> <b525ee76-67ce-f1f9-8b09-b3d447641943@redhat.com>
Subject: Re: [kvm-unit-tests GIT PULL 4/4] s390x: add CMM test during migration
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Thomas Huth <thuth@redhat.com>, pbonzini@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com
Message-ID: <167293678759.10194.7855209900471212728@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 05 Jan 2023 17:39:48 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vtR3sJ7w7cEmp-z3jjXojBIW832T8wob
X-Proofpoint-ORIG-GUID: 7WD1kl2Fv23F0lKmZVw9XoWmnRmT4OVp
Content-Transfer-Encoding: quoted-printable
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-05_08,2023-01-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 priorityscore=1501 mlxlogscore=999 malwarescore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301050131
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-01-05 13:24:03)
> On 05/01/2023 13.15, Claudio Imbrenda wrote:
> > From: Nico Boehr <nrb@linux.ibm.com>
> >=20
> > Add a test which modifies CMM page states while migration is in
> > progress.
> >=20
> > This is added to the existing migration-cmm test, which gets a new
> > command line argument for the sequential and parallel variants.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> > Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > Link: https://lore.kernel.org/r/20221221090953.341247-2-nrb@linux.ibm.c=
om
> > Message-Id: <20221221090953.341247-2-nrb@linux.ibm.com>
> > Signed-off-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
> > ---
> >   s390x/migration-cmm.c | 258 +++++++++++++++++++++++++++++++++++++-----
> >   s390x/unittests.cfg   |  15 ++-
> >   2 files changed, 240 insertions(+), 33 deletions(-)
>=20
>   Hi!
>=20
> While this works fine on my z15 LPAR, I'm getting a failure when running=
=20
> this test on my z13 LPAR:

I can _sometimes_ reproduce this on z16, z13 and misc older machines. The o=
lder the machine, the more often it seems to happen.

I think we may have a bug somewhere. While I investigate, feel free to leav=
e out this patch if you prefer.
