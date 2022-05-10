Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8EC521B6B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 16:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245151AbiEJOON (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 10:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343974AbiEJOLg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 10:11:36 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A29CB36F8;
        Tue, 10 May 2022 06:45:31 -0700 (PDT)
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24ADi8R6028618;
        Tue, 10 May 2022 13:45:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=ynBCm9JWc39fX+b79IVtttkb4ExbogVmIsodlrJim80=;
 b=Vz6V9GusriwO8k667Ja/srCCSZkHR176NRj8YV6puOS8Bu+bl7C01WTk40JdQ14hhr72
 29J9Gje1cT6hBeTZxJ4eCndDaBXbQ8Tw10NhKESieGSnbK5HEuN1t/I6br321kfeF/VG
 Wo099+FslYWGLWIPCjxpUp5XCXaaopq/cghkgoWQvaYicZIrlKfQ4xHaMGPhJamvoDcZ
 Kn5QD/EUPeaeVqkQr+g7puKQvZ4SjD89dMxRq1sHnsyQJ5mKTpGgu0L7vgbZZZnPYwF1
 IBgNTg+Y85KvDNRSSE1AAJM4y+T5alklc+hvn1bufn6PR6gCkdkXY8mMIwxlfUQDnrUG MQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyrd8s9s9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:45:28 +0000
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24ADiBqR029120;
        Tue, 10 May 2022 13:45:28 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3fyrd8s9rh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:45:27 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24ADjBqY024763;
        Tue, 10 May 2022 13:45:25 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma05fra.de.ibm.com with ESMTP id 3fwgd8u7fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 May 2022 13:45:25 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24ADVmkM12255654
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 May 2022 13:31:48 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 81ED6A405C;
        Tue, 10 May 2022 13:45:22 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39406A405B;
        Tue, 10 May 2022 13:45:22 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.15.58])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 10 May 2022 13:45:22 +0000 (GMT)
Date:   Tue, 10 May 2022 15:45:20 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 2/2] s390x: add cmm migration test
Message-ID: <20220510154520.52274a76@p-imbrenda>
In-Reply-To: <d87472c1556d8503bdda9e1cec26b5d910468cbc.camel@linux.ibm.com>
References: <20220509120805.437660-1-nrb@linux.ibm.com>
        <20220509120805.437660-3-nrb@linux.ibm.com>
        <20220509155821.07279b39@p-imbrenda>
        <d87472c1556d8503bdda9e1cec26b5d910468cbc.camel@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: f9vaLTth3JVpUbD5JOSuFZLuvsOnB_5a
X-Proofpoint-ORIG-GUID: R7ZHxkFUKBfnqp1u-NVHkCxUi_uyci_g
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-10_03,2022-05-10_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 suspectscore=0 malwarescore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205100060
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 10 May 2022 15:25:09 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> On Mon, 2022-05-09 at 15:58 +0200, Claudio Imbrenda wrote:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0for (i =3D 0; i < NUM_PAGE=
S; i++) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0switch(i % 4) {
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cas=
e 0:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0essa(ESSA_SET_STABLE, (unsigned
> > > long)pagebuf[i]);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bre=
ak;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cas=
e 1:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0essa(ESSA_SET_UNUSED, (unsigned
> > > long)pagebuf[i]);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bre=
ak;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cas=
e 2:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0essa(ESSA_SET_VOLATILE, (unsig=
ned
> > > long)pagebuf[i]);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bre=
ak;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0cas=
e 3:
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0essa(ESSA_SET_POT_VOLATILE,
> > > (unsigned long)pagebuf[i]);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0bre=
ak; =20
> >=20
> > const int essa_commands[4] =3D {ESSA_SET_STABLE, ESSA_SET_UNUSED, ...
> >=20
> > for (i =3D 0; i < NUM_PAGES; i++)
> > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0essa(essa_commands[i % =
4], ...
> >=20
> > I think it would look more compact and more readable =20
>=20
> I like your idea a lot, but the compiler doesn't :-(:

ouch, I had completely forgotten about that.

>=20
> /home/nrb/kvm-unit-tests/lib/asm/cmm.h: In function =E2=80=98main=E2=80=
=99:
> /home/nrb/kvm-unit-tests/lib/asm/cmm.h:32:9: error: =E2=80=98asm=E2=80=99=
 operand 2
> probably does not match constraints [-Werror]
>    32 |         asm volatile(".insn
> rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
>       |         ^~~
> /home/nrb/kvm-unit-tests/lib/asm/cmm.h:32:9: error: impossible
> constraint in =E2=80=98asm=E2=80=99
>=20
> To satify the "i" constraint, new_state needs to be a compile time
> constant, which it won't be any more with your suggestion
> unfortunately.=20
>=20
> We can do crazy stuff like this in cmm.h:
>=20
> #define __essa(state) \
> 	asm volatile(".insn
> rrf,0xb9ab0000,%[extr_state],%[addr],%[new_state],0" \
> 			: [extr_state] "=3Dd" (extr_state) \
> 			: [addr] "a" (paddr), [new_state] "i"
> (state));
> static unsigned long essa(uint8_t state, unsigned long paddr)
> {
> 	uint64_t extr_state =3D 0;
>=20
> 	switch(state) {
> 		case ESSA_SET_STABLE:
> 			__essa(ESSA_SET_STABLE);
> 		break;
> 		case ESSA_SET_UNUSED:
> 			__essa(ESSA_SET_UNUSED);
> 		break;
> 		case ESSA_SET_VOLATILE:
> 			__essa(ESSA_SET_VOLATILE);
> 		break;
> 		case ESSA_SET_POT_VOLATILE:
> 			__essa(ESSA_SET_POT_VOLATILE);
> 		break;
> 	}
>=20
> 	return (unsigned long)extr_state;
> }
>=20
> But that essentially just shifts the readability problem to a different
> file. What do you think?
>=20
> Or we make essa a marco, which doesn't sound like a particularily
> attractive alternative either.

ok, next less ugly thing: unroll the loop

for (i =3D 0; i < NUM_PAGES; i +=3D 4) {
	essa(ESSA_SET_STABLE, (unsigned long)pagebuf[i]);
	essa(ESSA_SET_UNUSED, (unsigned long)pagebuf[i + 1]);
	... etc
}

maybe assert(NUM_PAGES % 4 =3D=3D 0) before that, just for good measure


