Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6130A437200
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 08:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhJVGpK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 02:45:10 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19636 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229609AbhJVGpI (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 Oct 2021 02:45:08 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M4gpZ5011913
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:42:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Tx2UtFCCiczJSTdCpt5gWXBtodVsuSrCdbJPJUAF/UE=;
 b=fSd3e1C5dY49z8u0sdGU7WKS0jhyAV/Uh8FNI54d1GU/MDCCUU3McXBHzVhsDBCRBiyp
 ru8l/UjdmZC5YrjvPdrSRWwkL1CCwBnA3u+1L4FapaEVWztwYmgLg5HxP+di0WP0yvJi
 NfGizf7yKQ4qsd22gQNUymR7+n0rPsniCtz8j75t+M7oUQ0QF801tuZVUHuMwunb8rXY
 0Jf8z2BQLlidl68vIzXx8cmo5TLfQQ17rZ+k+n27KqiOV6fUsvnduSafm0qO2sqlGTGn
 1xhs+dLxL37fWwFoCx0h7Oh1bLd7rM42YFjXmwt/EsRLQAmhy4niFbiwgtJ73zhJKaA9 3Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bud044c84-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:42:49 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 19M6dk2E020280
        for <kvm@vger.kernel.org>; Fri, 22 Oct 2021 02:42:49 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3bud044c7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 02:42:49 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19M6dkko015415;
        Fri, 22 Oct 2021 06:42:47 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
        by ppma06ams.nl.ibm.com with ESMTP id 3bqp0kngeb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 06:42:46 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19M6anGj52494656
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 22 Oct 2021 06:36:49 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 83D954C074;
        Fri, 22 Oct 2021 06:42:44 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 46E4D4C052;
        Fri, 22 Oct 2021 06:42:44 +0000 (GMT)
Received: from [9.145.148.62] (unknown [9.145.148.62])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 22 Oct 2021 06:42:44 +0000 (GMT)
Message-ID: <91b899e6-f1b5-6dc3-e63f-815f02a933f4@linux.ibm.com>
Date:   Fri, 22 Oct 2021 08:42:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [kvm-unit-tests PATCH] gitlab-ci: Disable the s390x storage key
 test (which fails now with TCG)
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>
References: <20211021182113.818393-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20211021182113.818393-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: i5ImLHNez4xPEo187QNw4Wp7Bss9MJ7o
X-Proofpoint-ORIG-GUID: qf4jyO5_9mIsiunXxQ-w_UrKoVT1Rz0t
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_02,2021-10-21_02,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110220033
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/21/21 20:21, Thomas Huth wrote:
> Commit 429c9cc ("s390x: skey: Test for ADDRESSING exceptions") added
> some new tests which require the latest and greatest QEMU, which is
> not available in the distros yet, so the skey test is currently failing
> in the CI. Disable it for the time being, we'll switch it on again once
> the distros feature a QEMU with the bug fix.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Reviewed-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   .gitlab-ci.yml | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index 943b20f..4f3049d 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -62,7 +62,7 @@ build-s390x:
>    - ../configure --arch=s390x --cross-prefix=s390x-linux-gnu-
>    - make -j2
>    - ACCEL=tcg ./run_tests.sh
> -     selftest-setup intercept emulator sieve skey diag10 diag308 vector diag288
> +     selftest-setup intercept emulator sieve diag10 diag308 vector diag288
>        stsi sclp-1g sclp-3g
>        | tee results.txt
>    - if grep -q FAIL results.txt ; then exit 1 ; fi
> 

