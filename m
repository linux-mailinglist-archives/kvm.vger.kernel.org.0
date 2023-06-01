Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B636719B2D
	for <lists+kvm@lfdr.de>; Thu,  1 Jun 2023 13:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbjFALwq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Jun 2023 07:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjFALwp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Jun 2023 07:52:45 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E09F0129;
        Thu,  1 Jun 2023 04:52:43 -0700 (PDT)
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 351BjOf1015991;
        Thu, 1 Jun 2023 11:52:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=content-type :
 mime-version : content-transfer-encoding : in-reply-to : references :
 subject : cc : from : to : message-id : date; s=pp1;
 bh=9ZLtXuuUknrTCJ7paV/Y+vccjQL1g7paNWJmH6I8LuA=;
 b=RaoJWWesLwYo8hnV07oFeM1bOH1kaq+SUq7EaUaFALk75my4FJSXCnZVFMdKWk00b5ad
 kZ1hKtljemeiMhGUVa7I2P1Y3i+PGn7ur5fbavrWGSXo+okA7NlJ/06LhLWEO4s5Sdl6
 riqqOtlUHThNa0negHNKLa+OBm3we32wzTMPq3vQ2i0mBIoctdRNgg5vQOmHPM31arn9
 Be/hFBglT7CEJcxA6Bv+9JWTpn+P+mOYFTEQo6smctAXAa94AnPSD02kxbkTR76RirFf
 /AKCCBiwVNe/ZAFYqk9vQCNDzu2E/A7yPR/7oioNz86cS98Q72CePPyipO5kghhpwMPz 9A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtfj8m55-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:52:42 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 351Bko56018540;
        Thu, 1 Jun 2023 11:52:42 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3qxtfj8m4f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:52:42 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3511S6c4016865;
        Thu, 1 Jun 2023 11:52:40 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
        by ppma04ams.nl.ibm.com (PPS) with ESMTPS id 3qu9g5agfx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 01 Jun 2023 11:52:40 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
        by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 351Bqap832899432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 1 Jun 2023 11:52:36 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C091520043;
        Thu,  1 Jun 2023 11:52:36 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 98D1E20040;
        Thu,  1 Jun 2023 11:52:36 +0000 (GMT)
Received: from t14-nrb (unknown [9.171.95.43])
        by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Thu,  1 Jun 2023 11:52:36 +0000 (GMT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230530124056.18332-2-pmorel@linux.ibm.com>
References: <20230530124056.18332-1-pmorel@linux.ibm.com> <20230530124056.18332-2-pmorel@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH v3 1/2] s390x: sclp: consider monoprocessor on read_info error
Cc:     frankja@linux.ibm.com, thuth@redhat.com, kvm@vger.kernel.org,
        imbrenda@linux.ibm.com, david@redhat.com, nsg@linux.ibm.com,
        cohuck@redhat.com
From:   Nico Boehr <nrb@linux.ibm.com>
To:     Pierre Morel <pmorel@linux.ibm.com>, linux-s390@vger.kernel.org
Message-ID: <168562035629.164254.14237878033396575782@t14-nrb>
User-Agent: alot/0.8.1
Date:   Thu, 01 Jun 2023 13:52:36 +0200
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Xd0r0KNCsei40o2Wvw_BRfScqHMElFyO
X-Proofpoint-ORIG-GUID: 6nswMGf4uO6MaHdj_2Y4-EHUWUN1psC6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-01_08,2023-05-31_03,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 malwarescore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=999 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306010102
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Quoting Pierre Morel (2023-05-30 14:40:55)
> A kvm-unit-test would hang if an abort happens before SCLP Read SCP
> Information has completed if sclp_get_cpu_num() does not report at
> least one CPU.
> Since we obviously have one, report it.

Sorry for complaining again, in a discussion with Janosch we found that the
description and commit below can be easily misunderstood. I suggest the
following wording in the commit description:

s390x: sclp: treat system as single processor when read_info is NULL

When a test abort()s before SCLP read info is completed, the assertion on
read_info in sclp_read_info() will fail. Since abort() eventually calls
smp_teardown() which in turn calls sclp_get_cpu_num(), this will cause an
infinite abort() chain, causing the test to hang.

Fix this by considering the system single processor when read_info is missi=
ng.

[...]
> diff --git a/lib/s390x/sclp.c b/lib/s390x/sclp.c
> index 12919ca..34a31da 100644
> --- a/lib/s390x/sclp.c
> +++ b/lib/s390x/sclp.c
> @@ -121,6 +121,12 @@ int sclp_get_cpu_num(void)
>  {
>         if (read_info)
>                 return read_info->entries_cpu;
> +       /*
> +        * If we fail here and read_info has not being set,
> +        * it means we failed early and we try to abort the test.
> +        * We need to return at least one CPU, and obviously we have
> +        * at least one, for the smp_teardown to correctly work.
> +        */

Please make this:

Don't abort here if read_info is NULL since abort() calls smp_teardown() wh=
ich
eventually calls this function and thus causes an infinite abort() chain,
causing the test to hang. Since we obviously have at least one CPU, just re=
turn
one.

With these changes:

Reviewed-by: Nico Boehr <nrb@linux.ibm.com>

Sorry for the back and forth.
