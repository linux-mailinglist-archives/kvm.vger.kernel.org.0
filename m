Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6426279160A
	for <lists+kvm@lfdr.de>; Mon,  4 Sep 2023 13:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbjIDLH7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 Sep 2023 07:07:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjIDLH6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 4 Sep 2023 07:07:58 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73DE5CC0;
        Mon,  4 Sep 2023 04:07:55 -0700 (PDT)
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 384B72gU010961;
        Mon, 4 Sep 2023 11:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=L2rZM2ve5mboGRtXbmEUq5q8d2aHXOw9PB0RiBy9gD0=;
 b=MIu1UKSJJwKYnmKax6xPKq9L/9P3OtEvawLcFoJsLoTFlcYHld6ffKuWEoSu5/2iGDjl
 l+AOruuYvkGdUMSGicrkRBY04jeOcpzZNqJoYu6K+hx+Xc70v0XqpqTNfgYsOLoyyyRu
 Q1BoqlK2K2m4s9uSU7wEn2aCylb1RECnMgDd0E+qD1nxIRDGAZTgS916gPTt+A5ldhbx
 ukqoUqRI+Yz4rbYrhXNPjMEigDvmVx+ToakJkUWqAEUzUAzsHeXm9amZ/KhTLFBsp1wR
 H//66kr+gRnzV6dWfii6AO/zwuhZPp4P3YNBY58XY0wOrz+HXX3/mqAMl22whorqooUc yQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7qw9m54-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 11:07:54 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 384B7Dmn012013;
        Mon, 4 Sep 2023 11:07:53 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3sw7qw9m3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 11:07:53 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
        by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3848weG0012209;
        Mon, 4 Sep 2023 11:07:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3svhkjhjf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 04 Sep 2023 11:07:52 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 384B7nwY22545062
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 4 Sep 2023 11:07:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B57C720040;
        Mon,  4 Sep 2023 11:07:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 152512004E;
        Mon,  4 Sep 2023 11:07:49 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.14.38])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  4 Sep 2023 11:07:48 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <e6b8a718-4c99-cd37-c73f-fcb604a67af4@redhat.com>
References: <20230904082318.1465055-1-nrb@linux.ibm.com> <20230904082318.1465055-4-nrb@linux.ibm.com> <e6b8a718-4c99-cd37-c73f-fcb604a67af4@redhat.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     Thomas Huth <thuth@redhat.com>, frankja@linux.ibm.com,
        imbrenda@linux.ibm.com
Subject: Re: [kvm-unit-tests PATCH v6 3/8] s390x: sie: switch to home space mode before entering SIE
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <169382566786.97137.9911014409792025043@t14-nrb>
User-Agent: alot/0.8.1
Date:   Mon, 04 Sep 2023 13:07:47 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gx7LIITZYj64qWBOTdVlAyUOBV8_pgPB
X-Proofpoint-GUID: nV5CEHWDXxZgMPYUxVEWRILmy0jf9EdF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-04_07,2023-08-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 adultscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 phishscore=0 mlxscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309040099
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Thomas Huth (2023-09-04 11:59:30)
[...]
> If we want tests to be able in other modes in the future...
>=20
> > +      */
> > +     old_cr13 =3D stctg(13);
> > +     lctlg(13, stctg(1));
> > +
> > +     /* switch to home space so guest tables can be different from hos=
t */
> > +     psw_mask_set_bits(PSW_MASK_HOME);
> > +
> > +     /* also handle all interruptions in home space while in SIE */
> > +     irq_set_dat_mode(true, AS_HOME);
> > +
> >       while (vm->sblk->icptcode =3D=3D 0) {
> >               sie64a(vm->sblk, &vm->save_area);
> >               sie_handle_validity(vm);
> > @@ -66,6 +86,12 @@ void sie(struct vm *vm)
> >       vm->save_area.guest.grs[14] =3D vm->sblk->gg14;
> >       vm->save_area.guest.grs[15] =3D vm->sblk->gg15;
> >  =20
> > +     irq_set_dat_mode(true, AS_PRIM);
> > +     psw_mask_clear_bits(PSW_MASK_HOME);
>=20
> ... we should maybe restore the previous mode here instead of switching=20
> always to primary mode?

I don't want to add untested "should work" code, so I'd much prefer if we'd
have a proper test which uses multiple address spaces - and that seems out
of scope for this series to me.

> Anyway, could be done later, but you might want to update your comment.

Yep, agree, I'd prefer to do this later.

Pardon if I'm not getting it but the comment IMO makes sufficiently clear
that multiple AS are for future extensions. If you have any suggestion on
how this could be clearer, I'd be happy to incorporate.
