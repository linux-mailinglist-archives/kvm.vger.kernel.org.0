Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B1C064D924
	for <lists+kvm@lfdr.de>; Thu, 15 Dec 2022 10:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiLOJ7e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 04:59:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230188AbiLOJ73 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 04:59:29 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81C72C655
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 01:59:28 -0800 (PST)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF9k4TT022879
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:59:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references : to :
 from : cc : subject : message-id : date; s=pp1;
 bh=GOcaD9QUbdU3G+0X67irGW2beICfbg3t2qljGBbATGA=;
 b=IEpm+kGtuVSsZ9rqVgnUzOWyQIESSvTEqnEGrxNxq99Q3Z5D5LLS0w4mVBpaD60qF73g
 ZrReW+q7DwXh0pUampacdJYZlSpA2CeetawW4FKaHyHv0rr8HYczU+M3nt8BbhyRAjqN
 /mgF4ZccsxIZXbQL+R+LKrafG53ixFqdhi2/AwUANUEhyVBENLVCYZNqqzODD7pMKB4+
 fYVsirJJeao2ILRWhJKYFboSKZN0MW10HWuwWii2cUhiU4/0S+7pU0I9hfLfnWkNBz4o
 cfSFi3iIOzQZ672ahQ88P7uxNQ2irmaYrCW8ko+BlhNI6gSPaB9MiafyPUv9a+rXwyj9 cw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg18608q1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:59:27 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BF9mED0032259
        for <kvm@vger.kernel.org>; Thu, 15 Dec 2022 09:59:27 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mg18608pg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 09:59:27 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BF4KCEr025991;
        Thu, 15 Dec 2022 09:59:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma03fra.de.ibm.com (PPS) with ESMTPS id 3mf038227r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 15 Dec 2022 09:59:25 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BF9xLb424445426
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Dec 2022 09:59:21 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E98AD2004B;
        Thu, 15 Dec 2022 09:59:20 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C295520040;
        Thu, 15 Dec 2022 09:59:20 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.90.232])
        by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu, 15 Dec 2022 09:59:20 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6116d3af273718915c0f57356ab6d09a8293600a.camel@linux.ibm.com>
References: <20221214123814.651451-1-nrb@linux.ibm.com> <20221214123814.651451-2-nrb@linux.ibm.com> <6116d3af273718915c0f57356ab6d09a8293600a.camel@linux.ibm.com>
To:     Nina Schoetterl-Glausch <nsg@linux.ibm.com>, kvm@vger.kernel.org
From:   Nico Boehr <nrb@linux.ibm.com>
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add parallel skey migration test
Message-ID: <167109836015.7370.4424627965254271776@t14-nrb.local>
User-Agent: alot/0.8.1
Date:   Thu, 15 Dec 2022 10:59:20 +0100
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: P2fhkRzveEJCUg10WFIzLOfj3OZJLQE_
X-Proofpoint-ORIG-GUID: nBvN2PD5rJOp3Zybjhd5z2RtbS0NdDIH
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-15_03,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxlogscore=999
 adultscore=0 spamscore=0 priorityscore=1501 impostorscore=0 malwarescore=0
 suspectscore=0 mlxscore=0 phishscore=0 bulkscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2212150075
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Nina Schoetterl-Glausch (2022-12-14 19:27:15)
> On Wed, 2022-12-14 at 13:38 +0100, Nico Boehr wrote:
> > Right now, we have a test which sets storage keys, then migrates the VM
> > and - after migration finished - verifies the skeys are still there.
> >=20
> > Add a new version of the test which changes storage keys while the
> > migration is in progress. This is achieved by adding a command line
> > argument to the existing migration-skey test.
> >=20
> > Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
>=20
> Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
>=20
> Indentation should be fixed IMO, feel free to ignore the rest.

Thanks!

[...]
> > diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> > index a91eb6b5a63e..0f862cc9d821 100644
> > --- a/s390x/migration-skey.c
> > +++ b/s390x/migration-skey.c
> >=20
[...]
> > +static struct verify_result verify_test_pattern(unsigned char seed)
> > +{
[...]
> > -             /* don't log anything when key matches to avoid spamming =
the log */
> >               if (actual_key.val !=3D expected_key.val) {
> > -                     key_mismatches++;
> > -                     report_fail("page %d expected_key=3D0x%x actual_k=
ey=3D0x%x", i, expected_key.val, actual_key.val);
>=20
> I feel like setting verify_failed here also would be nicer.=20

I had this before, Claudio requested to remove it...

> Could also do
>         return (struct verify_result) {
>         ...
>         }
> Just a suggestion.

No strong opinion. I'll do whatever you prefer.

[...]
> > +static void report_verify_result(struct verify_result * const result)
>=20
> Why const? Why not also pointer to const?

Yes right, I'll make this a const struct.

> > +{
> > +     if (result->verify_failed)
> > +             report_fail("page skey mismatch: first page idx =3D %lu, =
addr =3D 0x%lx, "
> > +                     "expected_key =3D 0x%x, actual_key =3D 0x%x",
>=20
> Indent is off here.

Yes done.

> I have a slight preference for %02x for the keys. Just a suggestion.

Yes, changed.

> [...]
>=20
> > -int main(void)
> > +int main(int argc, char **argv)
> >  {
> >       report_prefix_push("migration-skey");
> > =20
> > -     if (test_facility(169))
> > +     if (test_facility(169)) {
> >               report_skip("storage key removal facility is active");
> > -     else
> > -             test_migration();
> > +             goto error;
> > +     }
> > =20
> > -     migrate_once();
> > +     parse_args(argc, argv);
> > +
> > +     switch (arg_test_to_run) {
>=20
> break statements should be indented.

Fixed.
