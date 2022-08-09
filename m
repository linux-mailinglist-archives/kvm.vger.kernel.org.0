Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FE858D3A8
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 08:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236904AbiHIGUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 02:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236727AbiHIGUx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 02:20:53 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 848011FCC7
        for <kvm@vger.kernel.org>; Mon,  8 Aug 2022 23:20:51 -0700 (PDT)
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2795R7uP026224
        for <kvm@vger.kernel.org>; Tue, 9 Aug 2022 06:20:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : subject : cc : message-id : date; s=pp1;
 bh=dJ/TRtWUxEoXx2eGh7qcNnsiF1kJAOcu+aFBlVmBjOI=;
 b=rcb9SO8DX3wFJUNQemLRYoTqR6hGjCDN9AgtqO28E7pHq6R7a5TZNNQcSl/WYmET5jvj
 Foi/rFxg6lWBXsDks9XK4raAEAxT5r+MO+Tjr5X6lkV5AJsX0yYZi+g/EscfTFh7/Gpp
 twDQNQ0drwONOzlBLO5GECivCxhF2JX/xDJnwn/N+7/0TeikHrc4JemYqcouo2cuD6Dk
 /BXGzy/IEj2L4J0cVCJYh344rZ0rmFEQpyiRdfl2mbYkJAVF/MXIbYRd59awBHJ51k3O
 wOIbX2waXSWSmHE2diF1Dx+0SEcJYflidIHqzyqPzg3rxVYcgfnSgNIrzmbmTyDBvRvT Mg== 
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3huf2757h4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 06:20:50 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2796KQU6004506
        for <kvm@vger.kernel.org>; Tue, 9 Aug 2022 06:20:48 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma04fra.de.ibm.com with ESMTP id 3hsfx8t95e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 06:20:48 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2796Kj1231457670
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Aug 2022 06:20:45 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 27ACF11C04C;
        Tue,  9 Aug 2022 06:20:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02E3011C052;
        Tue,  9 Aug 2022 06:20:45 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.13.40])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  9 Aug 2022 06:20:44 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
References: <20220803135851.384805-1-nrb@linux.ibm.com> <20220803135851.384805-2-nrb@linux.ibm.com> <b1383c10-fa60-56b5-7d57-7d6d59efd572@redhat.com>
To:     kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: verify EQBS/SQBS is unavailable
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
Message-ID: <166002604475.24812.2883502978971812957@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Tue, 09 Aug 2022 08:20:44 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: yhCKaExj2rHHkBse4JiNPpdZ-2ebM0gQ
X-Proofpoint-GUID: yhCKaExj2rHHkBse4JiNPpdZ-2ebM0gQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_03,2022-08-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 spamscore=0 phishscore=0 clxscore=1015 bulkscore=0 mlxlogscore=498
 suspectscore=0 malwarescore=0 lowpriorityscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208090026
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-08-04 00:17:38)
> On 03/08/2022 15.58, Nico Boehr wrote:
> > QEMU doesn't provide EQBS/SQBS instructions, so we should check they
> > result in an exception.
>=20
> I somewhat fail to see the exact purpose of this patch... QEMU still does=
n't=20
> emulate a lot of other instructions, too, so why are we checking now thes=
e=20
> QBS instructions?=20

I agree with you, it certainly doesn't make sense to test all kinds of rand=
om instructions that aren't implemented in QEMU.

But, for the QBS instructions, there is a special case in handle_b9 and han=
dle_eb in QEMU. I would argue since there is code for it, there can be (or =
even should be) tests for it.

But if you guys say it is not worth having this test, this is fine for me a=
s well.

[...]
> > diff --git a/s390x/intercept.c b/s390x/intercept.c
> > index 9e826b6c79ad..48eb2d22a2cc 100644
> > --- a/s390x/intercept.c
> > +++ b/s390x/intercept.c
> > @@ -197,6 +197,34 @@ static void test_diag318(void)
> >  =20
> >   }
> >  =20
> > +static void test_qbs(void)
> > +{
> > +     report_prefix_push("qbs");
>=20
> You should definitely add a comment here, explaining why this is only a t=
est=20
> for QEMU and saying that this could be removed as soon as QEMU implements=
=20
> these instructions later - otherwise this would be very confusing to the =

> readers later (if they forget or cannot check the commit message).

OK, I can add this once we have an answer to your first question.
