Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC1D1743E1C
	for <lists+kvm@lfdr.de>; Fri, 30 Jun 2023 16:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbjF3O7V (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Jun 2023 10:59:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232406AbjF3O7Q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Jun 2023 10:59:16 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61509171E;
        Fri, 30 Jun 2023 07:59:14 -0700 (PDT)
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35UEuR67011836;
        Fri, 30 Jun 2023 14:59:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : to : cc : from : message-id : date; s=pp1;
 bh=bQtzFNa1JczzRDlw+6cC+dZXlXKJ4g6orLHBwWkLT8M=;
 b=QYBxbpzA/qwPqhndySnhzlFHNwCGrKu/e3eYUoQvVapdp95mgyNOkEqkKC8k8ElXsvUn
 OnQLm11Z0nCHAfhpHVcCWdGU4eiH/d1ZzheYoZlS1j/0XbMgFQmauVQo7ptxx2r/wJlN
 8AyWm3COQ3b1a4F+6XVIXvat+3NmQHyJmX5M7b9OnuCJRYQvZiEpyljqYkK2/nz+qmpD
 zCYpPzJX6ed5YjolBqxapyEKIEnvu/e8eQwRFjvUqsIWn+JFV14XR2uKN9PEpDTFpntR
 7JU/vdDz1xIQkUVjqwJgUgezFQvJOieE0nwOPy47oV7Wi8bKXhRUqlYTq9a+aTFFI3rf Vg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj18p02n1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:59:12 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 35UEvNPI015722;
        Fri, 30 Jun 2023 14:59:12 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3rj18p02m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:59:12 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 35U3GEWF027359;
        Fri, 30 Jun 2023 14:59:10 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3rdr45474a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Jun 2023 14:59:10 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 35UEx7nd40043148
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Jun 2023 14:59:07 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F029E20043;
        Fri, 30 Jun 2023 14:59:06 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C359720040;
        Fri, 30 Jun 2023 14:59:06 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.51.244])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Fri, 30 Jun 2023 14:59:06 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
References: <20230601070202.152094-1-nrb@linux.ibm.com> <20230601070202.152094-6-nrb@linux.ibm.com> <baf4bb04-b258-f8b4-e49d-5d400e498bbf@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 5/6] s390x: lib: sie: don't reenter SIE on pgm int
To:     Janosch Frank <frankja@linux.ibm.com>, imbrenda@linux.ibm.com,
        thuth@redhat.com
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Message-ID: <168813714644.32198.9739825161407676099@t14-nrb>
User-Agent: alot/0.8.1
Date:   Fri, 30 Jun 2023 16:59:06 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NSrs1D8ezCT8xOLCoec_CmqliFnwJ4pF
X-Proofpoint-GUID: R3uZNn9ASvVCPbgdrqcAZhx7OG3ZUGNG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-30_05,2023-06-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=859 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306300123
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Janosch Frank (2023-06-05 11:30:36)
> On 6/1/23 09:02, Nico Boehr wrote:
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
>=20
> That's the reason why we set an invalid PGM PSW new for the assembly=20
> snippets. Seems like I didn't add it for C snippets for some reason -_-

True, C snippets should have a invalid PGM new PSW too. Let me have a try a=
fter
my holiday... *writes TODO*

> This code is fine but it doesn't fully fix the usability aspect and=20
> leaves a few questions open:
>   - Do we want to stick to the code 8 handling?

Well, I think we need to distinguish between two kinds of PGMs:
- PGMs in the guest,
- PGMs caused by SIE on the host (e.g. because the gpa-hpa mapping is not
  present)

The first case is out of scope for this patch, but certainly something whic=
h can
be improved.

This patch focuses on the latter case, where code 8 handling is irrelevant =
since
the PGM is always delivered to the host.

>   - Do we want to assert like with validities and PGMs outside of SIE?

Well, we would assert() except if we have an expect_pgm_int(), which we do =
have
:)

>   - Should sie() have a int return code like in KVM?

That's a lovely idea, maybe we should have this at some point in the future=
, but
I suppose it would require reshuffling large parts of the tests, so please
excuse me if I don't want to do this in the context of this series :) *writ=
es
another TODO*

[...]
> > Also add missing include of facility.h to mem.h.
>=20
> ?

That explains why we're including facility.h in mem.h below.

[...]
> > diff --git a/lib/s390x/asm/interrupt.h b/lib/s390x/asm/interrupt.h
> > index 55759002dce2..fb4283a40a1b 100644
> > --- a/lib/s390x/asm/interrupt.h
> > +++ b/lib/s390x/asm/interrupt.h
> > @@ -99,4 +99,18 @@ static inline void low_prot_disable(void)
> >       ctl_clear_bit(0, CTL0_LOW_ADDR_PROT);
> >   }
> >  =20
> > +/**
> > + * read_pgm_int_code - Get the program interruption code of the last p=
gm int
> > + * on the current CPU.
>=20
> All of the other functions are in the c file.

Claudio requested this to be in the C file, I really don't mind much. Claud=
io,
maybe you can elaborate why you wanted it in the header.

> > + *
> > + * This is similar to clear_pgm_int(), except that it doesn't clear the
> > + * interruption information from lowcore.
> > + *
> > + * Returns 0 when none occured.
>=20
> s/r/rr/

Fixed.

> > + */
> > +static inline uint16_t read_pgm_int_code(void)
> > +{
>=20
> No mb()?

This is a function call, so none should be needed, no?
