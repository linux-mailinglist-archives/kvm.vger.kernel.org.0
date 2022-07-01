Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00448562C31
	for <lists+kvm@lfdr.de>; Fri,  1 Jul 2022 09:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiGAHCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 1 Jul 2022 03:02:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233268AbiGAHCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 1 Jul 2022 03:02:48 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A06677C4
        for <kvm@vger.kernel.org>; Fri,  1 Jul 2022 00:02:48 -0700 (PDT)
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2616ohGn011767
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 07:02:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : cc : to : message-id : date; s=pp1;
 bh=918mngXZ88Y7llU8WSZTyUKOuvqK88Pw7+H6Rt2bPkU=;
 b=cKSXLyQPgow+Uscz/YXbtiABO3PJ/j+BDLk0k7KOuIN1cZsTA7tjDnjTSiThQDIiCNSQ
 +N98uZqHLPq7OppddHpvyTo8i/EJd2C6csZ7m6yZIV+Y852Fvojhvq5DLhywzP14fwy+
 RqoY5L9BxFKJ1XXTqXfoeB7CVK16+FR+2s1LdvlidUrxCaZBtZs2atXo4pokYxRJMQ8p
 zoMZipwyCtYOMjfXX9oL2mwO4vtsLp8QAvFkij/BJJ+XNOmf+dkBr4g5t+PLA6YgSYU6
 n0mdWh4ELX9g4iXJnbVrdobpvvQF/4DNR8uPvsfWvVYMikbfQnRAIoWF5ju6QOnIR1// kw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3h1v0y0ahj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 07:02:47 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2616b1p3021655
        for <kvm@vger.kernel.org>; Fri, 1 Jul 2022 07:02:45 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma06fra.de.ibm.com with ESMTP id 3gwsmhxyf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 01 Jul 2022 07:02:45 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 26172gFa23134550
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 1 Jul 2022 07:02:42 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 151314C046;
        Fri,  1 Jul 2022 07:02:42 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EDE904C044;
        Fri,  1 Jul 2022 07:02:41 +0000 (GMT)
Received: from li-ca45c2cc-336f-11b2-a85c-c6e71de567f1.ibm.com (unknown [9.171.42.232])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri,  1 Jul 2022 07:02:41 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <60f5b2f9-7c97-865c-075b-cb690bdcb082@redhat.com>
References: <20220630113059.229221-1-nrb@linux.ibm.com> <20220630113059.229221-2-nrb@linux.ibm.com> <60f5b2f9-7c97-865c-075b-cb690bdcb082@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/3] runtime: add support for panic tests
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com
To:     kvm@vger.kernel.org
Message-ID: <165665896175.83789.13004690806751071854@localhost.localdomain>
User-Agent: alot/0.8.1
Date:   Fri, 01 Jul 2022 09:02:41 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: DXsxO6Mkx2GhaUBIGH0w-Hmz1TVOB-oL
X-Proofpoint-GUID: DXsxO6Mkx2GhaUBIGH0w-Hmz1TVOB-oL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-01_04,2022-06-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 priorityscore=1501 adultscore=0 spamscore=0 impostorscore=0 clxscore=1015
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2207010024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2022-06-30 19:49:45)
> On 30/06/2022 13.30, Nico Boehr wrote:
> > QEMU suports a guest state "guest-panicked" which indicates something in
>=20
> s/suports/supports/

Fixed.

> > diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> > index 0dfaf017db0a..5663a1ddb09e 100644
> > --- a/scripts/arch-run.bash
> > +++ b/scripts/arch-run.bash
> > @@ -104,6 +104,12 @@ qmp ()
> >       echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | n=
cat -U $1
> >   }
> >  =20
> > +qmp_events ()
> > +{
> > +     while ! test -S "$1"; do sleep 0.1; done
> > +     echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' | n=
cat --no-shutdown -U $1 | jq -c 'select(has("event"))'
>=20
> Break the long line into two or three?

Fixed.

> > +run_panic ()
> > +{
[...]
> > +     panic_event_count=3D$(qmp_events ${qmp} | jq -c 'select(.event =
=3D=3D "GUEST_PANICKED")' | wc -l)
> > +     if [ $panic_event_count -lt 1 ]; then
>=20
> Maybe put double-quotes around $panic_event_count , just to be sure?

Yes, quoting is a bit broken anyways, but we have to start somewhere, thank=
s.

> With the nits fixed:
>=20
> Reviewed-by: Thomas Huth <thuth@redhat.com>

Thanks.
