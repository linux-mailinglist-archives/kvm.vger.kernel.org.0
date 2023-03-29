Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F015F6CD9A1
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 14:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjC2MwP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 08:52:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229997AbjC2MwO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 08:52:14 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54F10CA;
        Wed, 29 Mar 2023 05:52:04 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32TCZloR005141;
        Wed, 29 Mar 2023 12:52:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=FRayFWXe11GRLY/kzC7Vjo1WnrRd3pdQMGq7DcqB/hE=;
 b=prjEMobNJpZtMEGAAEqM+t363cJ46pvOL86Y9nBlzJu2rT3xFCrxhMjM5zk18mrRBHtK
 GS0/mAhXitnlAclO3jEiLp8mc05isinLso7ZxgIEO86x2d153JM1cc/uLtZVgYdL8Zj0
 U9bZCrG1GAtjz/rhLPzj834HA1YfBNCGvrQCiyk//jD2KWMgmgbEcuSB1iMufEZvkqg+
 Ea7vsxefaQM1P7iBFb1I/nIHSQLVdjOVS+uADi1jp5fLD2i9Gt4ohwqhOcgPSIq4cqL8
 SmC3+TnBWO6dJpwcjs+JH0Yx3DiRXAJknowJTY9SwxaAl1cov7cBDg+fX5ArfnUU2+md OA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn838x8s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:52:03 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 32TCLadl011119;
        Wed, 29 Mar 2023 12:52:03 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pmn838x7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:52:02 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 32SMN1w0009613;
        Wed, 29 Mar 2023 12:52:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3phrk6mykc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 29 Mar 2023 12:52:00 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 32TCpvQE13042328
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 29 Mar 2023 12:51:57 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73A482004E;
        Wed, 29 Mar 2023 12:51:57 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4E0DF20043;
        Wed, 29 Mar 2023 12:51:57 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.2.202])
        by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 29 Mar 2023 12:51:57 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230328190106.6ea977ee@p-imbrenda>
References: <20230327082118.2177-1-nrb@linux.ibm.com> <20230327082118.2177-4-nrb@linux.ibm.com> <20230328190106.6ea977ee@p-imbrenda>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v1 3/4] s390x: lib: sie: don't reenter SIE on pgm int
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <168009431698.295696.13066910573552475184@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 29 Mar 2023 14:51:56 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: lQ7TvULVPNQgs8L9HsK5fqmrbbFxCULe
X-Proofpoint-GUID: pcwxqx15-6kHLzEzP4b1EiHvrQIBUohf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-29_06,2023-03-28_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0 mlxscore=0
 spamscore=0 malwarescore=0 suspectscore=0 impostorscore=0 mlxlogscore=999
 priorityscore=1501 phishscore=0 clxscore=1015 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303290102
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-03-28 19:01:06)
[...]
> > diff --git a/lib/s390x/sie.h b/lib/s390x/sie.h
> > index 0b00fb709776..8ab755dc9456 100644
> > --- a/lib/s390x/sie.h
> > +++ b/lib/s390x/sie.h
> > @@ -37,6 +37,7 @@ struct kvm_s390_sie_block {
> >       uint32_t        ibc : 12;
> >       uint8_t         reserved08[4];          /* 0x0008 */
> >  #define PROG_IN_SIE (1<<0)
> > +#define PROG_PGM_IN_SIE (1<<1)
>=20
> please align the body of the macros with tabs, so they are more readable

Thanks, would do, but this is gonna go away anyways in favor of Janoschs su=
ggestion.
