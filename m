Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39609636582
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239005AbiKWQNF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:13:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238875AbiKWQND (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:13:03 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C2BD72113
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:12:59 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ANG6SvA030673
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:12:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 cc : from : subject : message-id : date; s=pp1;
 bh=7rVFMK0MBVVEqIQEsLP/peVxSi0VOsf3s0lfnSyTkBI=;
 b=lQs/rUyAwKzOfCFXX4fsh5IH+E+AeY5KcdWAPvAzlrN1hG2KuTUgvCsOkmGyQLnZVMsF
 hW+LleCgG4Mi2+lJ/u2rBUfeiWf1A/O/FUbQoTGV/AqmGZ7XSPUAfQBrH+g2V3jMf2po
 z1R+8aNXHTlLdt6fSzlXEar0fZOTsalqCxdDOTUmo+DoG7cSofSgrPaCMmoOELpv9XQH
 XUQHHUBY5v40Wm6BV9/x/zrrtF13dQEgoFeS9wBykF2BirOVKxWBVBjvvcutV4eYGkQz
 2qEFKkP5+qDgltannGlY1EJPTHe2y3QesEzYPx75w8oaxTvEBhc+6eGg/7EagbVtu0Tj mQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x80yd9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:12:58 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ANFnaOs002641
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 16:12:58 GMT
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m0x80yd8g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 16:12:57 +0000
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ANG7Nr2004149;
        Wed, 23 Nov 2022 16:12:56 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma02fra.de.ibm.com with ESMTP id 3kxps8vu7r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 23 Nov 2022 16:12:56 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ANGCqW749742292
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Nov 2022 16:12:52 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D14DDA405B;
        Wed, 23 Nov 2022 16:12:52 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AB162A405F;
        Wed, 23 Nov 2022 16:12:52 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.53.251])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 23 Nov 2022 16:12:52 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221123131338.7c091974@p-imbrenda>
References: <20221122161243.214814-1-nrb@linux.ibm.com> <20221122161243.214814-2-nrb@linux.ibm.com> <20221123131338.7c091974@p-imbrenda>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1 1/2] s390x: add a library for CMM-related functions
Message-ID: <166921997196.14080.2103781613814018050@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 23 Nov 2022 17:12:52 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: qbWmz9PTA9VTUONsItiv8UALU0KdfisJ
X-Proofpoint-ORIG-GUID: yBuFUMA2ottFmdUVCcSz8--RX9U1hgFL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-23_08,2022-11-23_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 adultscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=999 spamscore=0 phishscore=0
 bulkscore=0 suspectscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211230119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-11-23 13:13:38)
> > diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> > new file mode 100644
> > index 000000000000..9609cea68950
[...]
> > +static inline unsigned long get_page_addr(uint8_t *pagebuf, int page_i=
dx)
>=20
> I don't like the name of this function, but maybe you can just get rid
> of it (see below)

Didn't like repeating the cast with the address calculation every time, but=
 your solution with the cast first is good too. Done.

[...]
> > +/*
> > + * Verify CMM page states on pagebuf.
> > + * Page states must have been set by cmm_set_page_states on pagebuf be=
fore.
> > + * page_count must be a multiple of 4.
> > + *
> > + * If page states match the expected result,
> > + * will return true and result will be untouched. When a mismatch occu=
rs, will
> > + * return false and result will be filled with details on the first mi=
smatch.
> > + */
> > +bool cmm_verify_page_states(uint8_t *pagebuf, int page_count, struct c=
mm_verify_result *result)
> > +{
> > +     int i, state_mask, actual_state;
>=20
> I think "expected_mask" would be a better name, and maybe call the
> other one "actual_mask"

Yes, makes perfect sense. Done.

> > +
> > +     assert(page_count % 4 =3D=3D 0);
> > +
> > +     for (i =3D 0; i < page_count; i++) {
> > +             actual_state =3D essa(ESSA_GET_STATE, get_page_addr(pageb=
uf, i));
>=20
> addr + i * PAGE_SIZE (if we get rid of get_page_addr)
>=20
> > +             /* extract the usage state in bits 60 and 61 */
> > +             actual_state =3D (actual_state >> 2) & 0x3;
>=20
> actual_mask =3D BIT((actual_mask >> 2) & 3);

Yes makes sense, I will also adjust the comment a bit.

[...]
> > +void cmm_report_verify_fail(struct cmm_verify_result const *result)
> > +{
> > +     report_fail("page state mismatch: first page =3D %d, expected_mas=
k =3D 0x%x, actual_mask =3D 0x%x", result->page_mismatch, result->expected_=
mask, result->actual_mask);
>=20
> it would be a good idea to also print the actual address where the
> mismatch was found (with %p and (pagebuf + result->page_mismatch))

pagebuf is not available here, I want to avoid adding another argument, so =
I'll add a new field for the address in cmm_verify_result.

> > diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
> > new file mode 100644
> > index 000000000000..56e188c78704
[...]
> > +struct cmm_verify_result {
> > +     int page_mismatch;
> > +     int expected_mask;
> > +     int actual_mask;
> > +};
>=20
> I'm not too fond of this, I wonder if it's possible to just return the
> struct (maybe make the masks chars, since they will be small)

No real reason to optimize for size, but also no reason not to, so I just c=
hanged it.

> but I am not sure if the code will actually look better in the end

I am not a fan of returning structs, but none of my arguments against it ap=
ply
here, so I changed it. Will add a field verify_failed to cmm_verify_result.=
=20

This has the nice side effect that I don't have to do=20
  if(cmm_verify_page_states())=20
    report_pass()
  else
    cmm_report_verify_fail()
in every caller, but can just move this whole logic to a function.
