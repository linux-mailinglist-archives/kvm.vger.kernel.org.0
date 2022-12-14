Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B3864CF68
	for <lists+kvm@lfdr.de>; Wed, 14 Dec 2022 19:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238823AbiLNS1Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 14 Dec 2022 13:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238712AbiLNS1X (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 14 Dec 2022 13:27:23 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9EE56392
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 10:27:22 -0800 (PST)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEICk9l018779
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 18:27:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=6Tsug5BgKqwfO1l+xbv9bVZOG98KcLYYirZ39k7tH3Y=;
 b=H3IdUcPt7ulhqKPNdps8iz57TGls/i3krKob7KAcj7F047UcLMReM8g3WvQLqGiLZu+7
 fK3GUwEXa0BlyZ59FESznp2EFRcvBbkNbBD8iMaBYudFhU7YTrFUybQ7MbyKnV9ziHUg
 Kfawwuxwa5rcwGLW7owSYipMOAy99eO7XOoC0fzCvSzxwb8/Gavf5Oos86dkgVq2mzZT
 gkDCSC+AUeIxresn2tivyJgimZT7x99F17zwQCYNJXsfC2r4p+pLSc2lcDzt8wJUdxeB
 tP31++p5OyHcQoGRn5hqs+5VS3KmWrGAvYtImy8l/PI1AvWqV5fMhhJWVYxE0TSMQTXz YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfkjerav5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 18:27:22 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 2BEIEJQ9022138
        for <kvm@vger.kernel.org>; Wed, 14 Dec 2022 18:27:21 GMT
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mfkjerauf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 18:27:21 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 2BEBawZu004787;
        Wed, 14 Dec 2022 18:27:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06fra.de.ibm.com (PPS) with ESMTPS id 3meyqy1b4t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Dec 2022 18:27:19 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 2BEIRFLf51118528
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Dec 2022 18:27:15 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8512820043;
        Wed, 14 Dec 2022 18:27:15 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 58E7220040;
        Wed, 14 Dec 2022 18:27:15 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.152.224.238])
        by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 14 Dec 2022 18:27:15 +0000 (GMT)
Message-ID: <6116d3af273718915c0f57356ab6d09a8293600a.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/1] s390x: add parallel skey
 migration test
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>, kvm@vger.kernel.org
Cc:     frankja@linux.ibm.com, imbrenda@linux.ibm.com, thuth@redhat.com
Date:   Wed, 14 Dec 2022 19:27:15 +0100
In-Reply-To: <20221214123814.651451-2-nrb@linux.ibm.com>
References: <20221214123814.651451-1-nrb@linux.ibm.com>
         <20221214123814.651451-2-nrb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Kltr2o3Vrj2Ekq7dkss0ZLn4pN1zGYEY
X-Proofpoint-GUID: sG6juG-hVd61I_118qjy2Q58k_Cbn5vP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-14_09,2022-12-14_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 malwarescore=0 phishscore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxscore=0 spamscore=0 impostorscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2212140146
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-12-14 at 13:38 +0100, Nico Boehr wrote:
> Right now, we have a test which sets storage keys, then migrates the VM
> and - after migration finished - verifies the skeys are still there.
>=20
> Add a new version of the test which changes storage keys while the
> migration is in progress. This is achieved by adding a command line
> argument to the existing migration-skey test.
>=20
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>

Reviewed-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>

Indentation should be fixed IMO, feel free to ignore the rest.

> ---
>  s390x/migration-skey.c | 218 +++++++++++++++++++++++++++++++++++++----
>  s390x/unittests.cfg    |  15 ++-
>  2 files changed, 210 insertions(+), 23 deletions(-)
>=20
> diff --git a/s390x/migration-skey.c b/s390x/migration-skey.c
> index a91eb6b5a63e..0f862cc9d821 100644
> --- a/s390x/migration-skey.c
> +++ b/s390x/migration-skey.c
>=20
[...]

> +/*
> + * Verify storage keys on pagebuf.
> + * Storage keys must have been set by set_test_pattern on pagebuf before=
.
> + * set_test_pattern must have been called with the same seed value.
> + *
> + * If storage keys match the expected result, will return a verify_resul=
t
> + * with verify_failed false. All other fields are then invalid.
> + * If there is a mismatch, returned struct will have verify_failed true =
and will
> + * be filled with the details on the first mismatch encountered.
> + */
> +static struct verify_result verify_test_pattern(unsigned char seed)
> +{
> +	union skey expected_key, actual_key;
> +	struct verify_result result =3D {
> +		.verify_failed =3D true
> +	};
> +	uint8_t *cur_page;
> +	unsigned long i;
> =20
>  	for (i =3D 0; i < NUM_PAGES; i++) {
> -		actual_key.val =3D get_storage_key(pagebuf[i]);
> -		expected_key.val =3D i * 2;
> +		cur_page =3D pagebuf + i * PAGE_SIZE;
> +		actual_key.val =3D get_storage_key(cur_page);
> +		expected_key.val =3D (i ^ seed) * 2;
> =20
>  		/*
>  		 * The PoP neither gives a guarantee that the reference bit is
> @@ -51,27 +105,153 @@ static void test_migration(void)
>  		actual_key.str.rf =3D 0;
>  		expected_key.str.rf =3D 0;
> =20
> -		/* don't log anything when key matches to avoid spamming the log */
>  		if (actual_key.val !=3D expected_key.val) {
> -			key_mismatches++;
> -			report_fail("page %d expected_key=3D0x%x actual_key=3D0x%x", i, expec=
ted_key.val, actual_key.val);

I feel like setting verify_failed here also would be nicer. Could also do
	return (struct verify_result) {
	...
	}
Just a suggestion.
> +			result.expected_key.val =3D expected_key.val;
> +			result.actual_key.val =3D actual_key.val;
> +			result.page_mismatch_idx =3D i;
> +			result.page_mismatch_addr =3D (unsigned long)cur_page;
> +			return result;
>  		}
>  	}
> =20
> -	report(!key_mismatches, "skeys after migration match");
> +	result.verify_failed =3D false;
> +	return result;
> +}
> +
> +static void report_verify_result(struct verify_result * const result)

Why const? Why not also pointer to const?
> +{
> +	if (result->verify_failed)
> +		report_fail("page skey mismatch: first page idx =3D %lu, addr =3D 0x%l=
x, "
> +			"expected_key =3D 0x%x, actual_key =3D 0x%x",

Indent is off here.
I have a slight preference for %02x for the keys. Just a suggestion.

> +			result->page_mismatch_idx, result->page_mismatch_addr,
> +			result->expected_key.val, result->actual_key.val);
> +	else
> +		report_pass("skeys match");
> +}
> +
>=20
[...]

> -int main(void)
> +int main(int argc, char **argv)
>  {
>  	report_prefix_push("migration-skey");
> =20
> -	if (test_facility(169))
> +	if (test_facility(169)) {
>  		report_skip("storage key removal facility is active");
> -	else
> -		test_migration();
> +		goto error;
> +	}
> =20
> -	migrate_once();
> +	parse_args(argc, argv);
> +
> +	switch (arg_test_to_run) {

break statements should be indented.

> +	case TEST_SEQUENTIAL:
> +		test_skey_migration_sequential();
> +	break;
> +	case TEST_PARALLEL:
> +		test_skey_migration_parallel();
> +	break;
> +	default:
> +		print_usage();
> +	break;
> +	}
> =20
> +error:
> +	migrate_once();
>  	report_prefix_pop();
>  	return report_summary();
>  }
[...]
