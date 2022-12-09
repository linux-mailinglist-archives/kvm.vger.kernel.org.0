Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D80B6482A3
	for <lists+kvm@lfdr.de>; Fri,  9 Dec 2022 13:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbiLIM4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 9 Dec 2022 07:56:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiLIM4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 9 Dec 2022 07:56:46 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEEFB6BC81
        for <kvm@vger.kernel.org>; Fri,  9 Dec 2022 04:56:45 -0800 (PST)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B9B4Bj6003438;
        Fri, 9 Dec 2022 12:56:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : subject : to : cc : message-id : date; s=pp1;
 bh=Gk10zfeao+Nv53Q51vcCsjOVsMrNk4oW3opvOXZlA+o=;
 b=J59AwIE0/0dHrdzd/jXibEEIlZkyCpBFuDVe4ekUOOQNxqHt6uL7VBtk/NAL0UWy4lUp
 K3r0FmglS52vdbUcTeT/Ek3aou2zoDSZ7YnbZ80IjqXpoTheTD57BE4WfQxfk/Pty6WS
 0L7tHICOxC9u4+bmnO8EiGJru0Tg2o/KqqyllpA2ohfdqEf3gULae3n/9oukpRlhX2G8
 Ne9yc7ZuS+VSu+9qw8q9rlbRYHa0t+iNENL7b2ILwDqbuCcqcopDQYSBJukxjszTom2X
 Yaa3epF6/QlFVhWnL8h42X83XN4yNbCONJlbgTDBOLafG8lU/GmZyz19EmLYy+axJXmC fQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxakht40-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:56:42 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B9CmAuN016238;
        Fri, 9 Dec 2022 12:56:42 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mbxakht39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:56:42 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.16.1.2) with ESMTP id 2B98MwTe018446;
        Fri, 9 Dec 2022 12:56:39 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3m9m7rccnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 09 Dec 2022 12:56:39 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B9CuZs638732198
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 9 Dec 2022 12:56:36 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C3C1620049;
        Fri,  9 Dec 2022 12:56:35 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A0FE520040;
        Fri,  9 Dec 2022 12:56:35 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.9.45])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri,  9 Dec 2022 12:56:35 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221202115658.kx7zn6qod24ddt6x@kamzik>
References: <20221130142249.3558647-1-nrb@linux.ibm.com> <20221130142249.3558647-5-nrb@linux.ibm.com> <20221202115658.kx7zn6qod24ddt6x@kamzik>
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 4/4] arm: use migrate_once() in migration tests
To:     Andrew Jones <andrew.jones@linux.dev>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, imbrenda@linux.ibm.com,
        thuth@redhat.com, pbonzini@redhat.com, lvivier@redhat.com
Message-ID: <167059059477.42366.12070842524877835570@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Fri, 09 Dec 2022 13:56:35 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: sYrOJHqzRXQZ2DG0IVPNfpRr5OkC8uwe
X-Proofpoint-ORIG-GUID: 7wxuSFtsxi1_ro647kRMdrfYMApdrrhV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-09_07,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 clxscore=1015
 mlxlogscore=978 impostorscore=0 mlxscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212090098
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Andrew Jones (2022-12-02 12:56:58)
> On Wed, Nov 30, 2022 at 03:22:49PM +0100, Nico Boehr wrote:
> > Some tests already shipped with their own do_migrate() function, remove
> > it and instead use the new migrate_once() function. The control flow in
> > the gib tests can be simplified due to migrate_once().
>=20
> s/gib/gic/

Opsie, thanks :)

[...]
> > diff --git a/arm/debug.c b/arm/debug.c
> > index e9f805632db7..21b0f5aeb590 100644
> > --- a/arm/debug.c
> > +++ b/arm/debug.c
[...]
> > @@ -369,7 +363,7 @@ static noinline void test_ss(bool migrate)
> >       isb();
> > =20
> >       if (migrate) {
> > -             do_migrate();
> > +             migrate_once();
> >       }
>=20
> While here, please opportunistically drop the unnecessary {}

Done.

[...]
> Reviewed-by: Andrew Jones <andrew.jones@linux.dev>

Thanks.
