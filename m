Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C417A63F490
	for <lists+kvm@lfdr.de>; Thu,  1 Dec 2022 16:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiLAPz6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Dec 2022 10:55:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231602AbiLAPzw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Dec 2022 10:55:52 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04852B3907
        for <kvm@vger.kernel.org>; Thu,  1 Dec 2022 07:55:49 -0800 (PST)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B1FsukP029613
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 15:55:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : cc :
 subject : from : to : message-id : date; s=pp1;
 bh=J0k4iJ+zd3fcwJZ0bxH4A50UxCU4boLYDlTvPts4hQE=;
 b=AsV8gK8Mwf7XrV5ZgqjpXCHX2Mm1gGyfLKCJjYprhp1UYJtWdWZyBXC5yyMIJu9aU3Rd
 GWBmmSMcFhyXWvY9W+5UhAiReBxL2fUSas5jC5xjpCRfn47Ya329bQBR2I/vSJBCdO9C
 bBzNsphTGVBEnsArBsJgjGJ8umnGsU37OdLP2rdD3GQeIYAs18Jg6qxlacjpN6+iN0Ec
 +Vguz/tKVCDyNrkikkG3c9et9Y2GlHekgkfzVkb5RAYkHFvppht0AUObbsYhuwniYCJN
 VRaoPGNXMZ/9ddrb/Sx2Ebf+bqzAAtDIw4Ez1nQqnRCb6664l9by711URK5jtXzZ1cng RQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6yayg0j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 01 Dec 2022 15:55:49 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2B1FtD9f031235
        for <kvm@vger.kernel.org>; Thu, 1 Dec 2022 15:55:48 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3m6yayg0hm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 15:55:48 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 2B1Fnwrm020562;
        Thu, 1 Dec 2022 15:55:46 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma04ams.nl.ibm.com with ESMTP id 3m3ae9fkvc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Dec 2022 15:55:46 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2B1FnBks7078544
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Dec 2022 15:49:11 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5B4E442045;
        Thu,  1 Dec 2022 15:55:43 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 36CFE4203F;
        Thu,  1 Dec 2022 15:55:43 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.4.226])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  1 Dec 2022 15:55:43 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221201141650.32cfe787@p-imbrenda>
References: <20221201084642.3747014-1-nrb@linux.ibm.com> <20221201084642.3747014-2-nrb@linux.ibm.com> <20221201141650.32cfe787@p-imbrenda>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com,
        pbonzini@redhat.com
Subject: Re: [kvm-unit-tests PATCH v1 1/3] s390x: add library for skey-related functions
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Message-ID: <166991014258.186408.12012997417078839512@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 01 Dec 2022 16:55:42 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: vkvnKyL2PkbTOTVeqYYNvHnIUmyyjZJY
X-Proofpoint-ORIG-GUID: d_3x4N1ttFIRwtbdCatRO1GciKURysnf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-01_11,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 impostorscore=0
 lowpriorityscore=0 adultscore=0 priorityscore=1501 spamscore=0
 mlxlogscore=999 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2210170000 definitions=main-2212010113
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-01 14:16:50)
> On Thu,  1 Dec 2022 09:46:40 +0100
> Nico Boehr <nrb@linux.ibm.com> wrote:
[...]
> > diff --git a/lib/s390x/skey.c b/lib/s390x/skey.c
> > new file mode 100644
> > index 000000000000..100f0949a244
[...]
> > +/*
> > + * Set storage keys on pagebuf.
>=20
> surely you should explain better what the function does (e.g. how are
> you setting the keys and why)

Well there is the comment below which explains why the * 2 is needed, so wh=
at
about this paragraph (after merging the commits as discussed before):

    * Each page's storage key is generated by taking the page's index in pa=
gebuf,
    * XOR-ing that with the given seed and then multipling the result with =
two.

(But really that's also easy to see from the code below, so I am not sure if
this really adds value.)

> > + * pagebuf must point to page_count consecutive pages.
> > + */
> > +void skey_set_keys(uint8_t *pagebuf, unsigned long page_count)
>=20
> this name does not make clear what the function is doing. at first one
> would think that it sets the same key for all pages.
>=20
> maybe something like set_storage_keys_test_pattern or
> skey_set_test_pattern or something like that

Oh that's a nice suggestion, thanks.

>=20
> > +{
> > +     unsigned char key_to_set;
> > +     unsigned long i;
> > +
> > +     for (i =3D 0; i < page_count; i++) {
> > +             /*
> > +              * Storage keys are 7 bit, lowest bit is always returned =
as zero
> > +              * by iske.
> > +              * This loop will set all 7 bits which means we set fetch
> > +              * protection as well as reference and change indication =
for
> > +              * some keys.
> > +              */
> > +             key_to_set =3D i * 2;
> > +             set_storage_key(pagebuf + i * PAGE_SIZE, key_to_set, 1);
>=20
> why not just i * 2 instead of using key_to_set ?

Well you answered that yourself :)

In patch 2, the key_to_set expression becomes a bit more complex, so the ex=
tra
variable makes sense to me.
