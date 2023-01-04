Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8158A65DBCE
	for <lists+kvm@lfdr.de>; Wed,  4 Jan 2023 19:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239893AbjADSFm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Jan 2023 13:05:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239879AbjADSFl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Jan 2023 13:05:41 -0500
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1201AA01;
        Wed,  4 Jan 2023 10:05:40 -0800 (PST)
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 304GheZT007920;
        Wed, 4 Jan 2023 18:05:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=olkBDj7BCW3B6tXIADYxz7nEwfGeaP/mnqd2FwMDCv8=;
 b=b+8UTZsx4F6fUM8ZeOTrOfdKYO96BgYVfSGwc9thNzQkuxm7+zippSb+gw3cXhUVFpTp
 RFmuMFhuQgn5Dh/vEPntZ241NVTppv8HwOyZPB/U//smbaC+wJvWjxAsP04EmgF8eL7s
 AHehTolrm/Ouatcr6ml+1MZNa8wlzaHAz/ssVRxMi69ddFJSdMOYNCBQBFGB56sI404F
 IZfmqvrPoviCwv6cdokq3+ejcJz085/JdXvAy7vwb1ofXbtTxk/BhctTwdC/l5J4j3z9
 ax3tJQ0mD91cl5brLHVoG9u/PqP24bKo+pTuXSZJ+drYEHkz21B3pSly5lFg46NV9zFo YQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwd7n1vw1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 18:05:39 +0000
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 304HrIsu011170;
        Wed, 4 Jan 2023 18:05:39 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3mwd7n1vv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 18:05:39 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 304D668A001543;
        Wed, 4 Jan 2023 18:05:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3mtcbfdp9j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Jan 2023 18:05:37 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 304I5Xia51184076
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Jan 2023 18:05:33 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8DC8C20043;
        Wed,  4 Jan 2023 18:05:33 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 61AC120040;
        Wed,  4 Jan 2023 18:05:33 +0000 (GMT)
Received: from li-7e0de7cc-2d9d-11b2-a85c-de26c016e5ad.ibm.com (unknown [9.171.146.193])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  4 Jan 2023 18:05:33 +0000 (GMT)
Message-ID: <6d23c99ad1d799f72a171c02fa3bd20870ba6c7e.camel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v1] s390x: Fix integer literal in skey.c
From:   Nina Schoetterl-Glausch <nsg@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Date:   Wed, 04 Jan 2023 19:05:33 +0100
In-Reply-To: <20230104175950.731988-1-nsg@linux.ibm.com>
References: <20230104175950.731988-1-nsg@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.2 (3.46.2-1.fc37) 
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: aPEhgW9lnmLKmM1a7am_ujE_UjnYFnvJ
X-Proofpoint-ORIG-GUID: OpDYi0O7CpZuLLuU8jIhnCmMo88_yWsm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2023-01-04_07,2023-01-04_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 malwarescore=0 suspectscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 mlxscore=0 impostorscore=0 spamscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301040151
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I forgot:

Fixes: 965e38a0 ("s390x: Test effect of storage keys on diag 308")

On Wed, 2023-01-04 at 18:59 +0100, Nina Schoetterl-Glausch wrote:
> The code is a 64bit number of which the upper 48 bits must be 0.
>=20
> Signed-off-by: Nina Schoetterl-Glausch <nsg@linux.ibm.com>
> ---
>  s390x/skey.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/s390x/skey.c b/s390x/skey.c
> index 1167e4d3..7c7a8090 100644
> --- a/s390x/skey.c
> +++ b/s390x/skey.c
> @@ -320,7 +320,7 @@ static void test_diag_308(void)
>  		"lr	%[response],%%r3\n"
>  		: [response] "=3Dd" (response)
>  		: [ipib] "d" (ipib),
> -		  [code] "d" (5)
> +		  [code] "d" (5L)
>  		: "%r2", "%r3"
>  	);
>  	report(response =3D=3D 0x402, "no exception on fetch, response: invalid=
 IPIB");
>=20
> base-commit: 73d9d850f1c2c9f0df321967e67acda0d2c305ea

