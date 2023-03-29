Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35C086CEC49
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 16:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229525AbjC2O7D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 10:59:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbjC2O7B (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 10:59:01 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC862113;
        Wed, 29 Mar 2023 07:59:00 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TDRGcJ031647;
        Wed, 29 Mar 2023 14:59:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=2jrWUF/UKWVjUdnSzdYgtrwWLE6Bb+W9Socvg4XKr/Q=;
 b=QjEpnOzB+WeBg6rqAs5VzR2cy5hlpUxrpkhtjANtsoBJDCPVFHRWtVShYxPPjNL+Dtab
 lBzkgXjF/twB7towFRqnTF75yoRsTudROCsD5Q16dFePQaCCFohHdwM/mP48cIhlxCds
 iaCvoJZYrdnC+Gn/U7Y3Qf3O9re6fULTFzV5SyCYjq6ic0lOZiEoTxKUWzEoRhHFLiI7
 BNbzpb7TTzlXu6ZaJrhkEQBaJXyXqF3gUjwp7y7F2QbAKK96yMCcuaWaOcremlInunv0
 R1QEbgSd7ZMF1AgO3zwaDuWIANrmtScLji80C3BWptrBjComa39WklQFBx/maBaIPGCZ nw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7j2j7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 14:58:59 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TEFmMS015305;
        Wed, 29 Mar 2023 14:58:59 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmp7j2j6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 14:58:59 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32T0pgNA017053;
        Wed, 29 Mar 2023 14:58:56 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3phrk6m8eb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 14:58:56 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TEwrxr21168728
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 14:58:53 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B2F620043;
        Wed, 29 Mar 2023 14:58:53 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEF9F20040;
        Wed, 29 Mar 2023 14:58:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.2.202])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 14:58:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230329150032.7093e25b@p-imbrenda>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-2-nrb@linux.ibm.com> <afcf5186-c3f2-d777-be5f-408318039f2d@linux.ibm.com> <168009425098.295696.4253423899606982653@t14-nrb> <20230329150032.7093e25b@p-imbrenda>
Cc:     Janosch Frank <frankja@linux.ibm.com>, thuth@redhat.com,
        kvm@vger.kernel.org, linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 1/4] s390x: sie: switch to home space mode before entering SIE
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <168010193252.295696.17762897869912282460@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 29 Mar 2023 16:58:52 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: dVMQ4NuvmbhZ4HjltXjmsYCzbX1ICYyD
X-Proofpoint-GUID: Q92Wlg2a3KrjHAXkkt5D5EnieAYM0EYI
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_08,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 spamscore=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 adultscore=0
 suspectscore=0 impostorscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303290116
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-03-29 15:00:32)
> On Wed, 29 Mar 2023 14:50:50 +0200
> Nico Boehr <nrb@linux.ibm.com> wrote:
>=20
> > Quoting Janosch Frank (2023-03-28 16:13:04)
> > > On 3/27/23 10:21, Nico Boehr wrote: =20
> > > > This is to prepare for running guests without MSO/MSL, which is
> > > > currently not possible.
> > > >=20
> > > > We already have code in sie64a to setup a guest primary ASCE before
> > > > entering SIE, so we can in theory switch to the page tables which
> > > > translate gpa to hpa.
> > > >=20
> > > > But the host is running in primary space mode already, so changing =
the
> > > > primary ASCE before entering SIE will also affect the host's code a=
nd
> > > > data.
> > > >=20
> > > > To make this switch useful, the host should run in a different addr=
ess
> > > > space mode. Hence, set up and change to home address space mode bef=
ore
> > > > installing the guest ASCE.
> > > >=20
> > > > The home space ASCE is just copied over from the primary space ASCE=
, so
> > > > no functional change is intended, also for tests that want to use
> > > > MSO/MSL. If a test intends to use a different primary space ASCE, i=
t can
> > > > now just set the guest.asce in the save_area.
> > > >  =20
> > > [...] =20
> > > > +     /* set up home address space to match primary space */
> > > > +     old_cr13 =3D stctg(13);
> > > > +     lctlg(13, stctg(1));
> > > > +
> > > > +     /* switch to home space so guest tables can be different from=
 host */
> > > > +     psw_mask_set_bits(PSW_MASK_HOME);
> > > > +
> > > > +     /* also handle all interruptions in home space while in SIE */
> > > > +     lowcore.pgm_new_psw.mask |=3D PSW_MASK_DAT_HOME; =20
> > >  =20
> > > > +     lowcore.ext_new_psw.mask |=3D PSW_MASK_DAT_HOME;
> > > > +     lowcore.io_new_psw.mask |=3D PSW_MASK_DAT_HOME; =20
> > > We didn't enable DAT in these two cases as far as I can see so this i=
s=20
> > > superfluous or we should change the mmu code. Also it's missing the s=
vc=20
> > > and machine check. =20
> >=20
> > Right. Is there a particular reason why we only run DAT on for PGM ints?
>=20
> a fixup handler for PGM it might need to run with DAT on (e.g. to
> access data that is not identity mapped), whereas for other interrupts
> it's not needed (at least not yet ;) )

Makes sense.

Since one can register a cleanup for io and ext, too, I think we need to fi=
x the
mmu init for these cases while at it.

Will do that in v2.
