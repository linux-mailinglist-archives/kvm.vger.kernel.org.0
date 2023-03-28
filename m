Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB6756CC1E5
	for <lists+kvm@lfdr.de>; Tue, 28 Mar 2023 16:17:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232832AbjC1ORH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Mar 2023 10:17:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230444AbjC1OQz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Mar 2023 10:16:55 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C959CC3E;
        Tue, 28 Mar 2023 07:16:54 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32SEFg48017941;
        Tue, 28 Mar 2023 14:16:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : from : subject : message-id : date; s=pp1;
 bh=fJeZHWWyfWvSqqgFrPwYsCg34mKTxQM/CIAKKEiQIgk=;
 b=i069lDtgDRlan6VeulVZ/SMZAbG47tv+qy9d3lCfqh3yxPO7yby66tuye2c8abEPn0ZY
 hu+9OxYJY7XxOIvntbf6yNJxMdg9jbKkdo4RExUObnxHGCOcYC3fiXMltB44FLY2/7Dl
 1BTRBqpYv42WU6NAkTXxydk59jmYXmZXZEcFkJCF9pkiTuW2x9hSPYEc3wpA2YaO4Q2R
 4cyGFpP3W2GdAs9IWug0+cFkVVRw5oMfyzQG7nJB/kWNTI4keFqDBCAi6aAcSSRDjnsY
 lBJY0ZXWwQAKwdn61wqEXi0WF3VIZs7kvn5YfWXbqbIsjXiec6xbTHVlY8F+mUlcpRMa xg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm1ujg1nm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:16:53 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32SEGFtT020266;
        Tue, 28 Mar 2023 14:16:53 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pm1ujg17p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:16:51 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SDG6vv017824;
        Tue, 28 Mar 2023 14:16:32 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3phrk6uex6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 28 Mar 2023 14:16:32 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32SEGSoq23921314
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 28 Mar 2023 14:16:28 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2AC120043;
        Tue, 28 Mar 2023 14:16:28 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78FDA20040;
        Tue, 28 Mar 2023 14:16:28 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.48.75])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Tue, 28 Mar 2023 14:16:28 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <4eb0d6aa-d0c9-ff0e-d1f6-2d23ea8a957d@linux.ibm.com>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-4-nrb@linux.ibm.com> <4eb0d6aa-d0c9-ff0e-d1f6-2d23ea8a957d@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: lib: sie: don't reenter SIE on pgm int
Message-ID: <168001298812.28355.13672619009088163461@t14-nrb>
User-Agent: alot/0.8.1
Date:   Tue, 28 Mar 2023 16:16:28 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: EVHA6faA7G0WTotXEGq68yP4ythaSo9Z
X-Proofpoint-ORIG-GUID: BwSqF8cT1jRwl6M3B32Lrcx6twRCgNeU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-24_11,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 spamscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 mlxlogscore=737 malwarescore=0 impostorscore=0 phishscore=0 clxscore=1015
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2303280111
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-03-28 15:42:26)
> On 3/27/23 10:21, Nico Boehr wrote:
> > At the moment, when a PGM int occurs while in SIE, we will just reenter
> > SIE after the interrupt handler was called.
> >=20
> > This is because sie() has a loop which checks icptcode and re-enters SIE
> > if it is zero.
> >=20
> > However, this behaviour is quite undesirable for SIE tests, since it
> > doesn't give the host the chance to assert on the PGM int. Instead, we
> > will just re-enter SIE, on nullifing conditions even causing the
> > exception again.
> >=20
> > Add a flag PROG_PGM_IN_SIE set by the pgm int fixup which indicates a
> > program interrupt has occured in SIE. Check for the flag in sie() and if
> > it's set return from sie() to give the host the ability to react on the
> > exception. The host may check if a PGM int has occured in the guest
> > using the new function sie_had_pgm_int().
>=20
> We could simply check "!lowcore.pgm_int_code" by introducing:
> uint16_t read_pgm_int(void)
> {
>         mb();
>         return lowcore.pgm_int_code;
> }
>=20
> into interrupt.c.
>=20
>=20
> Or to be a bit more verbose:
> I don't see a reason why we'd want to store a per sblk PGM in SIE bit=20
> when all we want to know is either: was there a PGM at all (to stop the=20
> SIE loop) or was there a PGM between the expect and the=20
> check_pgm_int_code().

Yes, makes perfect sense, I just didn't see this possiblity. Thanks, will c=
hange.
