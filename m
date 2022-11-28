Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38DD663A810
	for <lists+kvm@lfdr.de>; Mon, 28 Nov 2022 13:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbiK1MU1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 28 Nov 2022 07:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbiK1MUF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 28 Nov 2022 07:20:05 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF60C6302
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 04:12:41 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ASC6EX2010127
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:12:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : from
 : cc : to : subject : message-id : date; s=pp1;
 bh=Whv5ZJ3wBsAaZ9xrtqNy9cvhUs/qaoMk2CTZ3rcBaD8=;
 b=Bpxa3KaSdrWdRg6kEROGqbpMAUa1gUGg/84OTVE/+s5dgDgVOJoWdflREZszLAaog8ze
 wImx2pdBSRK6BT7Fa65/p6xGSS9C8u9Kh8yP4QUUflPUQsvpRHYdf7cnUqtJxnxPfFCs
 tPQZGiBn6B1QdQ2qPOjsY6ZMusjjN1Z4TnUnHkzBSBZYLGwXtUM43erehHlKXu59ksqn
 IFZYsxFOfr3siVHls1udX2issvZUWUTHcnmsmZF+aMaaLxpNzQsnkcE0pg3QQBlh5/Mi
 q5/IeIytKZxaFPZ4KbFrTxsX3jp3ghrHCKWnrl70SpUj0NlH5p45tcpwHxmf3xKoSNbZ YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpkwtse-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:12:40 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2ASCBxoP016853
        for <kvm@vger.kernel.org>; Mon, 28 Nov 2022 12:12:40 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3m3vpkwtrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:12:40 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2ASC5mRe014899;
        Mon, 28 Nov 2022 12:12:37 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9affq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Nov 2022 12:12:37 +0000
Received: from d06av21.portsmouth.uk.ibm.com (d06av21.portsmouth.uk.ibm.com [9.149.105.232])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2ASC69sc64487864
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Nov 2022 12:06:09 GMT
Received: from d06av21.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 48ADB52050;
        Mon, 28 Nov 2022 12:12:34 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.62.74])
        by d06av21.portsmouth.uk.ibm.com (Postfix) with ESMTP id 216C65204E;
        Mon, 28 Nov 2022 12:12:34 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221125150348.55676f0c@p-imbrenda>
References: <20221124134429.612467-1-nrb@linux.ibm.com> <20221124134429.612467-2-nrb@linux.ibm.com> <20221125150348.55676f0c@p-imbrenda>
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v2 1/2] s390x: add a library for CMM-related functions
Message-ID: <166963755324.7765.7971505373288044037@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Mon, 28 Nov 2022 13:12:33 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: pUOrn8CdMmloI6_u2HrCukoYF5DPlvk1
X-Proofpoint-GUID: LYdfONmO4Rb4Fo-4xBl93TJuGuMvcr01
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-28_09,2022-11-28_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=858
 impostorscore=0 mlxscore=0 malwarescore=0 adultscore=0 spamscore=0
 lowpriorityscore=0 phishscore=0 suspectscore=0 priorityscore=1501
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211280093
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-11-25 15:03:48)
> On Thu, 24 Nov 2022 14:44:28 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
[...]
> > diff --git a/lib/s390x/cmm.c b/lib/s390x/cmm.c
> > new file mode 100644
> > index 000000000000..5da02fe628f9
> > --- /dev/null
> > +++ b/lib/s390x/cmm.c
[...]
> > +/*
> > + * Set CMM page states on pagebuf.
> > + * pagebuf must point to page_count consecutive pages.
> > + * page_count must be a multiple of 4.
> > + */
> > +void cmm_set_page_states(uint8_t *pagebuf, int page_count)
>=20
> this could be an unsigned int (but maybe unsigned long would be better)

Yes, changed to unsigned long.

[...]
> > +/*
> > + * Verify CMM page states on pagebuf.
> > + * Page states must have been set by cmm_set_page_states on pagebuf be=
fore.
> > + * page_count must be a multiple of 4.
> > + *
> > + * If page states match the expected result, will return a cmm_verify_=
result
> > + * with verify_failed false. All other fields are then invalid.
> > + * If there is a mismatch, the returned struct will have verify_failed=
 true
> > + * and will be filled with details on the first mismatch encountered.
> > + */
> > +struct cmm_verify_result cmm_verify_page_states(uint8_t *pagebuf, int =
page_count)
>=20
> same here

Yes, done.
>=20
> > +{
> > +     struct cmm_verify_result result =3D {
> > +             .verify_failed =3D true
> > +     };
> > +     int i, expected_mask, actual_mask;
> > +     unsigned long addr;
> > +
> > +     assert(page_count % 4 =3D=3D 0);
> > +
> > +     for (i =3D 0; i < page_count; i++) {
> > +             addr =3D (unsigned long)(pagebuf + i * PAGE_SIZE);
> > +             actual_mask =3D essa(ESSA_GET_STATE, addr);

Oh, essa() returns unsigned long, so let's make actual_mask, expected_mask =
etc. unsigned long, too.

> > +             /* usage state in bits 60 and 61 */
> > +             actual_mask =3D BIT((actual_mask >> 2) & 0x3);
> > +             expected_mask =3D allowed_essa_state_masks[i % ARRAY_SIZE=
(allowed_essa_state_masks)];
> > +             if (!(actual_mask & expected_mask)) {
> > +                     result.page_mismatch_idx =3D i;
> > +                     result.page_mismatch_addr =3D addr;
> > +                     result.expected_mask =3D expected_mask;
> > +                     result.actual_mask =3D actual_mask;
> > +                     result.verify_failed =3D true;
>=20
> it's already true, you don't need to set it again

OK, removed.=20

[...]
> > +void cmm_report_verify(struct cmm_verify_result const *result)
> > +{
> > +     if (result->verify_failed)
> > +             report_fail("page state mismatch: first page idx =3D %d, =
addr =3D %lx, expected_mask =3D 0x%x, actual_mask =3D 0x%x", result->page_m=
ismatch_idx, result->page_mismatch_addr, result->expected_mask, result->act=
ual_mask);
>=20
> this line looks longer than 120 columns

Yes, wrapped it.

> > diff --git a/lib/s390x/cmm.h b/lib/s390x/cmm.h
> > new file mode 100644
> > index 000000000000..41dcc2f953fd
> > --- /dev/null
> > +++ b/lib/s390x/cmm.h
[...]
> > +struct cmm_verify_result {
> > +     bool verify_failed;
> > +     char expected_mask;
> > +     char actual_mask;
> > +     int page_mismatch_idx;
>=20
> maybe also unsigned long to be consistent with
> cmm_set_page_states

Yes, done.
