Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95AA25115EC
	for <lists+kvm@lfdr.de>; Wed, 27 Apr 2022 13:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232366AbiD0LWR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Apr 2022 07:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbiD0LWM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Apr 2022 07:22:12 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22B9B2E09D;
        Wed, 27 Apr 2022 04:19:02 -0700 (PDT)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23RBEDap025896;
        Wed, 27 Apr 2022 11:19:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=fmUf9cGv1MtJQqAzVZNv4BhI+qCEv+kTC0e+R+nBeYw=;
 b=O8GEyUxnTkSbEVU334IVPNCIbfQQjS2xyOVI3h5G3GAB5jSzN4zhwLVpyh8eefk/TzLZ
 lmkyroyj2Mg2MSYVVhcUBwmdGZ9iiAjwjDD4WECwAg2dlS3NuwVsqaYWuCPPfnRfK1Lc
 yzxZPCBUWDJS5hCqjj8fV56IAp5hXIea14ZIYppuedGFvL+h2MGUmTI3ypnp0FVPztyU
 PLpi/NcYMbKlxhJI9mqx41pJnfP6SSxowJcN3PKyqQPJKJ/rxLKwJ1Q2GnyHxifvhW9n
 IwXCxkNvu0qhVuqzyS4VI9xKNNbVQZJTmUVOJFB+aWiztlJCcIA9JYHBOLMM/CK4jt3t qg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fq4s5g2md-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:19:01 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 23RBJ0HG010752;
        Wed, 27 Apr 2022 11:19:00 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3fq4s5g2ky-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:19:00 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 23RB8cvk016523;
        Wed, 27 Apr 2022 11:18:58 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04ams.nl.ibm.com with ESMTP id 3fm938wuf8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:18:58 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 23RBItG643712962
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Apr 2022 11:18:55 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CDC214C044;
        Wed, 27 Apr 2022 11:18:55 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 583794C040;
        Wed, 27 Apr 2022 11:18:55 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.10.176])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 27 Apr 2022 11:18:55 +0000 (GMT)
Date:   Wed, 27 Apr 2022 13:12:07 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Janis Schoetterl-Glausch <scgl@linux.ibm.com>
Cc:     Thomas Huth <thuth@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v6 3/3] Disable s390x skey test in GitLab
 CI
Message-ID: <20220427131207.5b06b211@p-imbrenda>
In-Reply-To: <20220427100611.2119860-4-scgl@linux.ibm.com>
References: <20220427100611.2119860-1-scgl@linux.ibm.com>
        <20220427100611.2119860-4-scgl@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: IgGXCxwim64mXcYUhh3YrKNegD5HU_kZ
X-Proofpoint-ORIG-GUID: WWEUaruCcm1_86ocMFMuG8dAGFjFDK1K
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-27_03,2022-04-27_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 clxscore=1015 spamscore=0 bulkscore=0 lowpriorityscore=0
 priorityscore=1501 mlxlogscore=999 impostorscore=0 phishscore=0
 suspectscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204270073
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 27 Apr 2022 12:06:11 +0200
Janis Schoetterl-Glausch <scgl@linux.ibm.com> wrote:

> The test cases newly added to skey.c require kernel 5.18.
> 
> Signed-off-by: Janis Schoetterl-Glausch <scgl@linux.ibm.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .gitlab-ci.yml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 4f3049d8..e5768f1d 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -166,7 +166,7 @@ s390x-kvm:
>    - ./configure --arch=s390x
>    - make -j$(nproc)
>    - ACCEL=kvm ./run_tests.sh
> -      selftest-setup intercept emulator sieve sthyi skey diag10 diag308 pfmf
> +      selftest-setup intercept emulator sieve sthyi diag10 diag308 pfmf
>        cmm vector gs iep cpumodel diag288 stsi sclp-1g sclp-3g css skrf sie
>        | tee results.txt
>    - grep -q PASS results.txt && ! grep -q FAIL results.txt

