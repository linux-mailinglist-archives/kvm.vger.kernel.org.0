Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AFFF7068A6
	for <lists+kvm@lfdr.de>; Wed, 17 May 2023 14:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231790AbjEQMwX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 May 2023 08:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjEQMwW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 May 2023 08:52:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9740230C8;
        Wed, 17 May 2023 05:52:21 -0700 (PDT)
Received: from pps.filterd (m0353726.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34HCbFud023507;
        Wed, 17 May 2023 12:52:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 to : subject : from : message-id : date; s=pp1;
 bh=0ne0IL/I7EjmSkfXqwjzWAAFGpbiV9GQfqihj2Rc6XU=;
 b=KcDdQDCQGhgR1gTMK20eauUNnbupXb6EVFOx26kXTitmZ53M+FWD7jGBfOSTEPx+4nAl
 utbGC2GMt/eaZHrEAPe5oW2yBTloGKrC6tZ2gOZkZTt+MK+mTJYP8YVok0McO+o4pQHm
 ahwS5dB3N1uY7vKLh4mgtMpPWKOuoLDcE6nT1FKQSDDLPOFXa52ZJpNyRcevzNRf91ac
 kVWhIiRpwhNQwG66EpPd1X6y12CYrmf10J9Wfr7gjsixiJ7B+op9eZ09DOujkSBEMNE6
 wLuULLZDxQncnmE9sl1B1ulHE3bSdAq2hXpocm3ZQvKVVldcRgZdTGgtHvWu/JI6giOl ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmxx310s7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:52:20 +0000
Received: from m0353726.ppops.net (m0353726.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 34HCbgGB026426;
        Wed, 17 May 2023 12:52:19 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qmxx310r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:52:19 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 34H3qfbX024876;
        Wed, 17 May 2023 12:52:17 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma02fra.de.ibm.com (PPS) with ESMTPS id 3qj264st3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 17 May 2023 12:52:16 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 34HCqDBD14156302
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 May 2023 12:52:13 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E0EB20043;
        Wed, 17 May 2023 12:52:13 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0E96D20040;
        Wed, 17 May 2023 12:52:13 +0000 (GMT)
Received: from t14-nrb (unknown [9.179.7.234])
        by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 17 May 2023 12:52:12 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230516193018.2e6cab64@p-imbrenda>
References: <20230516130456.256205-1-nrb@linux.ibm.com> <20230516130456.256205-6-nrb@linux.ibm.com> <20230516193018.2e6cab64@p-imbrenda>
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 5/6] s390x: lib: sie: don't reenter SIE on pgm int
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168432793263.12463.18068695121142335984@t14-nrb>
User-Agent: alot/0.8.1
Date:   Wed, 17 May 2023 14:52:12 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: gDI1fTAoLeJWuVIgPKqc2PFqOYcxEm19
X-Proofpoint-ORIG-GUID: rkRFkcqcllNpcbMTjFLx5DMi0Gt0GHbk
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-17_02,2023-05-17_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 spamscore=0 impostorscore=0 clxscore=1015 adultscore=0
 priorityscore=1501 bulkscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 mlxlogscore=635 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305170103
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2023-05-16 19:30:18)
[...]
> > diff --git a/lib/s390x/interrupt.c b/lib/s390x/interrupt.c
> > index 2e5309cee40f..82b4259d433c 100644
> > --- a/lib/s390x/interrupt.c
> > +++ b/lib/s390x/interrupt.c
[...]
> > +/**
> > + * read_pgm_int_code - Get the program interruption code of the last p=
gm int
> > + * on the current CPU.
> > + *
> > + * This is similar to clear_pgm_int(), except that it doesn't clear the
> > + * interruption information from lowcore.
> > + *
> > + * Returns 0 when none occured.
> > + */
> > +uint16_t read_pgm_int_code(void)
>=20
> could this whole function go in the header as static inline?

Yes, sure, changed.

> > +{
> > +     mb();
>=20
> is the mb really needed?

No, I don't think so, since this is a function, I'll remove this.
