Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C9E7C512D
	for <lists+kvm@lfdr.de>; Wed, 11 Oct 2023 13:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234782AbjJKLLB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Oct 2023 07:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234778AbjJKLKq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Oct 2023 07:10:46 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30252195;
        Wed, 11 Oct 2023 04:10:30 -0700 (PDT)
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39BAwLAD017986;
        Wed, 11 Oct 2023 11:10:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=EfzKXAuwh0M3LiZpE8egTg/gDpQ8+UOoHxLyEk/CZ2U=;
 b=R0F42J7rlv9e6dbc3vGuCFO1woXGud0LhYlcd8IGJDKABLWsn7QLwxLeuAYiB3PD6DPt
 mc6GHytEMVx8xVTjzRvP92GZfKgGMIwlIjxHmj4fAoBVtDnrjk9JBNhfJTihOqVZ8foi
 CCSpKk9UC07QCuLQrAHz9BNh2hrTu8/M4+vmbufflvUIplixt2DCGWIMZ3/weIWf/dHK
 KPYbcyri4NMNMQXIBLJQ0XIwVz+kcCRb7NT+8Fsu6uIhhSuF0tuIco7tn/GRZDwmS8Om
 f+3ut2FXrDW2DOipdWnHFkHIEW7w3eWfbuY15pZy0lv8BHS5T81wJKhmUWjnIiJp1FWu Vw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnsy093xh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:10:20 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39BAwgMs019014;
        Wed, 11 Oct 2023 11:10:19 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tnsy093w9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:10:19 +0000
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
        by ppma12.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39BAdCq6024461;
        Wed, 11 Oct 2023 11:10:17 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 3tkhnsqut0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 Oct 2023 11:10:17 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39BBAEhJ22938176
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 11 Oct 2023 11:10:14 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABD4120040;
        Wed, 11 Oct 2023 11:10:14 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 84CDA2004B;
        Wed, 11 Oct 2023 11:10:14 +0000 (GMT)
Received: from li-978a334c-2cba-11b2-a85c-a0743a31b510.ibm.com (unknown [9.152.224.238])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 11 Oct 2023 11:10:14 +0000 (GMT)
Message-ID: <57504d05bce665a3855415495c9efc681d28d87d.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH 1/9] s390x: topology: Fix report message
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Nico =?ISO-8859-1?Q?B=F6hr?= <nrb@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>,
        Thomas Huth <thuth@redhat.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, Andrew Jones <andrew.jones@linux.dev>,
        Colton Lewis <coltonlewis@google.com>,
        Nikos Nikoleris <nikos.nikoleris@arm.com>,
        Sean Christopherson <seanjc@google.com>
Date:   Wed, 11 Oct 2023 13:10:13 +0200
In-Reply-To: <434cdea5-e0a8-43d0-a06f-5c4a1990acf7@linux.ibm.com>
References: <20231011085635.1996346-1-nsg@linux.ibm.com>
         <20231011085635.1996346-2-nsg@linux.ibm.com>
         <434cdea5-e0a8-43d0-a06f-5c4a1990acf7@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: d11dDc6fC14fwY2-mPnsxcnBO8oIVSee
X-Proofpoint-GUID: LTYJfqXyrhd2bkN3ktsgkYLv_KghzG6q
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-11_08,2023-10-11_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 mlxscore=0 impostorscore=0 suspectscore=0 spamscore=0
 adultscore=0 priorityscore=1501 clxscore=1015 mlxlogscore=999 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310110097
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2023-10-11 at 12:56 +0200, Janosch Frank wrote:
> On 10/11/23 10:56, Nina Schoetterl-Glausch wrote:
> > A polarization value of 0 means horizontal polarization.
> >=20
> > Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Don't we need to remove the entitlement part?
> Entitlement is defined as the degree of vertical polarization.

I don't follow.
We're checking this from the PoP:
A dedicated CPU is either horizontally or vertically
polarized. When a dedicated CPU is vertically polar-
ized, entitlement is always high. Thus, when D is one,
PP is either 00 binary or 11 binary.=20

> > ---
> >   s390x/topology.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >=20
> > diff --git a/s390x/topology.c b/s390x/topology.c
> > index 69558236..53838ed1 100644
> > --- a/s390x/topology.c
> > +++ b/s390x/topology.c
> > @@ -275,7 +275,7 @@ static uint8_t *check_tle(void *tc)
> >   	if (!cpus->d)
> >   		report_skip("Not dedicated");
> >   	else
> > -		report(cpus->pp =3D=3D 3 || cpus->pp =3D=3D 0, "Dedicated CPUs are e=
ither vertically polarized or have high entitlement");
> > +		report(cpus->pp =3D=3D 3 || cpus->pp =3D=3D 0, "Dedicated CPUs are e=
ither horizontally polarized or have high entitlement");
> >  =20
> >   	return tc + sizeof(*cpus);
> >   }
>=20

