Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E17564C8DE
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 13:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiLNMWI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 07:22:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbiLNMVa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 07:21:30 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C3F6588
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 04:18:46 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BECHLlN013886
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:18:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : from : to : cc : message-id : date; s=pp1;
 bh=8Tar9amtcJtr055oouu4u0lGNFwAgBXlyHa+Dwpj1L4=;
 b=bRfWzNeRl/h6x+KkF3c+RRrkjPZgmvwaaUFQDjylcTmCsA3mdhWcs54iAbmIrc6u77Z6
 FTLsB2VT6dmV/WZa624wi2tFEA2OhBMvxyTrB9ytZDXF36PRGt3cB8chF/O9B77WktJf
 aTSRueCEBTGeuTBnixqL67bf4Mh20n6cFGP8PnWikPctuQ8a8vmvzGlp91mTalzBkXP6
 OG0cQhVNjzT75HAqAu6C4LVPmvnRRk+zjHhhs5Vp+gLxBVrn0N6XnP/brEgnOilikCvd
 lIOvL6ZHXHMDhu755fdhPElodbqBBq45txoQ2NMBupDpXiwSJ7ISGuM/M5XbVRyjZjIx TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfec1g0d0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:18:46 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BECIkEb020596
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 12:18:46 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfec1g0cm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 12:18:45 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BDMLV2c027949;
        Wed, 14 Dec 2022 12:18:43 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma05fra.de.ibm.com (PPS) with ESMTPS id 3meyxm8xtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 12:18:43 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BECIdKn14680338
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 12:18:39 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 96D0C20040;
        Wed, 14 Dec 2022 12:18:39 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 802D620049;
        Wed, 14 Dec 2022 12:18:39 +0000 (GMT)
Received: from t14-nrb (unknown [9.152.224.44])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 12:18:39 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20221213182756.0e3d2643@p-imbrenda>
References: <20221209102122.447324-1-nrb@linux.ibm.com> <20221209102122.447324-2-nrb@linux.ibm.com> <20221213182756.0e3d2643@p-imbrenda>
Subject: Re: [kvm-unit-tests PATCH v2 1/1] s390x: add parallel skey migration test
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Message-ID: <167102031897.9238.16296908848457715319@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Wed, 14 Dec 2022 13:18:39 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aijGLAfuhDNI86SodW3PKA4KGig8L2hj
X-Proofpoint-ORIG-GUID: UXtfW1PXnw9MWN8kUWYBJdZt9fVPcTwT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_05,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 mlxscore=0 impostorscore=0
 bulkscore=0 clxscore=1015 priorityscore=1501 adultscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140094
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Claudio Imbrenda (2022-12-13 18:27:56)
[...]
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > index b7bd82581abe..9b9a45f4ad3b 100644
> > --- a/s390x/migration-skey.c
> > +++ b/s390x/migration-skey.c
[...]
> > +/*
> > + * Verify storage keys on pagebuf.
> > + * Storage keys must have been set by skey_set_test_pattern on pagebuf=
 before.
> > + * skey_set_keys must have been called with the same seed value.
> > + *
> > + * If storage keys match the expected result, will return a skey_verif=
y_result
> > + * with verify_failed false. All other fields are then invalid.
> > + * If there is a mismatch, returned struct will have verify_failed tru=
e and will
> > + * be filled with the details on the first mismatch encountered.
> > + */
> > +static struct skey_verify_result skey_verify_test_pattern(uint8_t *pag=
ebuf, unsigned long page_count, unsigned char seed)
>=20
> this line is a little too long, even for the KVM unit tests; find a way
> to shorten it by a couple of bytes (it would look better to keep it on
> one line)
>=20
> (rename pagebuf? use size_t or uint64_t instead of unsigned long? use
> uint8_t for seed? shorten the name of struct verify_result?)

Well since all these functions are static again, I will:
- remove the skey_ prefix
- get rid of the pagebuf argument and just use the global variable.
That makes everything nice and short.

[...]
> > +static void migrate_once(void)
> > +{
> > +     static bool migrated;
> > +
> > +     if (migrated)
> > +             return;
> > +
> > +     migrated =3D true;
> > +     puts("Please migrate me, then press return\n");
> > +     (void)getchar();
> >  }
>=20
> you don't need this any more, since your migration patches are
> upstream now :)

Yes, rebased.

[...]
> > +static void print_usage(void)
> > +{
> > +     report_info("Usage: migration-skey [parallel|sequential]");
> > +}
> > +
> > +int main(int argc, char **argv)
> >  {
> >       report_prefix_push("migration-skey");
> >       if (test_facility(169)) {
> >               report_skip("storage key removal facility is active");
> > +             goto error;
> > +     }
> > =20
> > -             /*
> > -              * If we just exit and don't ask migrate_cmd to migrate u=
s, it
> > -              * will just hang forever. Hence, also ask for migration =
when we
> > -              * skip this test altogether.
> > -              */
> > -             puts("Please migrate me, then press return\n");
> > -             (void)getchar();
> > +     if (argc < 2) {
> > +             print_usage();
> > +             goto error;
> > +     }
> > +
> > +     if (!strcmp("parallel", argv[1])) {
> > +             test_skey_migration_parallel();
> > +     } else if (!strcmp("sequential", argv[1])) {
> > +             test_skey_migration_sequential();
> >       } else {
> > -             test_migration();
> > +             print_usage();
>=20
> hmm I don't like this whole main.
>=20
> I think the best approach would be to have some kind of separate
> parse_args function that will set some flags (or one flag, in this case)
>=20
> then the main becomes just a bunch of if/else, something like this:
>=20
> parse_args(argc, argv);
> if (test_facility(169))
>         skip
> else if (parallel_flag)
>         parallel();
> else
>         sequential();
>=20
> also, default to sequential if there are no parameters, and use
> posix-style parameters (--parallel, --sequential)
>=20
> only if you get an invalid parameter you can print the usage and fail
> optionally if you really want you can print the usage info when called
> without parameter and inform that the test will default to sequential
>=20
>=20
> one of these days I have to write an argument parsing library :)

Alright, done.
