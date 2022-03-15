Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D52B4DA23F
	for <lists+kvm@lfdr.de>; Tue, 15 Mar 2022 19:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351004AbiCOSYL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Mar 2022 14:24:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235913AbiCOSYJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Mar 2022 14:24:09 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E210D5F7F;
        Tue, 15 Mar 2022 11:22:55 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22FIIinO006273;
        Tue, 15 Mar 2022 18:22:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=djvJQtE04iNr+/E7XxRYsv6HnSSYEbt+avD/41Uo+Es=;
 b=A+SEXkuaYWNiU7zJvbjv4gk8XGWDP6zJtt7nbAbnCH6Z0EbUzCCDhLiJLcPJ27CX1n/N
 66mN8Ogs+67NBDJJRPq2JSzHtLM1m3jNJAqe85PrC69iqrEAdPKHAviacHBouw6+N45K
 5tf1bFArIHZ8rgmbBcPcsjCoIt4vSv29nlQvQIAbkwntDEV4qzKzib7kOdG/WQoKPiZo
 9zF0aOxHLm22u6GXSZryua+Iu4qZKaplID8FHDM2/m7joID7PTbbFnU9nklaED16kL2a
 Lqz34ebhB2yuPCtwY7IOFJDV9blpFKuWdrKXR9vDjtnky6l61yJiTShgAxt5x716RaRz oA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etywcg5cf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 18:22:54 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22FIJQMs009017;
        Tue, 15 Mar 2022 18:22:54 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3etywcg5bw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 18:22:54 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22FIDVnf000884;
        Tue, 15 Mar 2022 18:22:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 3erk58p5ta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Mar 2022 18:22:52 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22FIMnqm28836098
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Mar 2022 18:22:49 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1B5C3AE051;
        Tue, 15 Mar 2022 18:22:49 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5181AE045;
        Tue, 15 Mar 2022 18:22:48 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.12.100])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 15 Mar 2022 18:22:48 +0000 (GMT)
Date:   Tue, 15 Mar 2022 18:39:22 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Eric Farman <farman@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH kvm-unit-tests v2 3/6] s390x: smp: Fix checks for SIGP
 STOP STORE STATUS
Message-ID: <20220315183922.0444e8d2@p-imbrenda>
In-Reply-To: <20220311173822.1234617-4-farman@linux.ibm.com>
References: <20220311173822.1234617-1-farman@linux.ibm.com>
        <20220311173822.1234617-4-farman@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3tzuyMJJKfl4T8OJyJzSD4hcBFY3mLHe
X-Proofpoint-GUID: LPbhcidT7r9yn7P83bAAWql77_9601c_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-15_09,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 phishscore=0 impostorscore=0 clxscore=1015 mlxlogscore=982
 suspectscore=0 lowpriorityscore=0 priorityscore=1501 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203150108
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 11 Mar 2022 18:38:19 +0100
Eric Farman <farman@linux.ibm.com> wrote:

> In the routine test_stop_store_status(), the "running" part of
> the test checks a few of the fields in lowcore (to verify the
> "STORE STATUS" part of the SIGP order), and then ensures that
> the CPU has stopped. But this is backwards, according to the
> Principles of Operation:
>   The addressed CPU performs the stop function, fol-
>   lowed by the store-status operation (see =E2=80=9CStore Sta-
>   tus=E2=80=9D on page 4-82).
>=20
> If the CPU were not yet stopped, the contents of the lowcore
> fields would be unpredictable. It works today because the
> library functions wait on the stop function, so the CPU is
> stopped by the time it comes back. Let's first check that the
> CPU is stopped first, just to be clear.
>=20
> While here, add the same check to the second part of the test,
> even though the CPU is explicitly stopped prior to the SIGP.
>=20
> Fixes: fc67b07a4 ("s390x: smp: Test stop and store status on a running an=
d stopped cpu")
> Signed-off-by: Eric Farman <farman@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  s390x/smp.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/s390x/smp.c b/s390x/smp.c
> index 2f4af820..50811bd0 100644
> --- a/s390x/smp.c
> +++ b/s390x/smp.c
> @@ -98,9 +98,9 @@ static void test_stop_store_status(void)
>  	lc->grs_sa[15] =3D 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
> +	report(smp_cpu_stopped(1), "cpu stopped");
>  	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "prefix"=
);
>  	report(lc->grs_sa[15], "stack");
> -	report(smp_cpu_stopped(1), "cpu stopped");
>  	report_prefix_pop();
> =20
>  	report_prefix_push("stopped");
> @@ -108,6 +108,7 @@ static void test_stop_store_status(void)
>  	lc->grs_sa[15] =3D 0;
>  	smp_cpu_stop_store_status(1);
>  	mb();
> +	report(smp_cpu_stopped(1), "cpu stopped");
>  	report(lc->prefix_sa =3D=3D (uint32_t)(uintptr_t)cpu->lowcore, "prefix"=
);
>  	report(lc->grs_sa[15], "stack");
>  	report_prefix_pop();

