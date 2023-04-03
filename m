Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDFDB6D42B9
	for <lists+kvm@lfdr.de>; Mon,  3 Apr 2023 12:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231992AbjDCK5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Apr 2023 06:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231867AbjDCK5P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Apr 2023 06:57:15 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E765BAD04
        for <kvm@vger.kernel.org>; Mon,  3 Apr 2023 03:57:00 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 333Au7Cc016135;
        Mon, 3 Apr 2023 10:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=MlBhvKYEqNWx2xNW5FKTWedDFts1gQca+9MSl0NBCo4=;
 b=YxuIW8ThhXWqldXdQMXNniEOrp3H6dsm4tBn0A8hrHK4NeFpcCb6rnPU/u6VYsjFxUDy
 oFxt43bFKqN63D33qqfiwrntfvwK53+jgqJiFXu3XL7++lb2y0P51cPdOtXOp81kba+w
 1Z5HdeuqahPp3r0kIwfg5vCVjR2s7GklECMdualbcN7pV9/0iZNq6Dj69MnktmASXG2B
 ocGE+X6zpouGTWwkas1FLL3h95k/SMF95dyp9Ih3EaMSnXGSZ9EWrWbBOXpJynNFJDYb
 vMwItOdhRJMomkA19AJdeugMr+kF7e6dkMfEmVWUPdLXrG7v0b8Nu0AOS0MQpiaide3X ZQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqva11ya9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 10:56:55 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 333Au8Zi016254;
        Mon, 3 Apr 2023 10:56:54 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3pqva11y9a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 10:56:54 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 332BM400000685;
        Mon, 3 Apr 2023 10:56:52 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
        by ppma06ams.nl.ibm.com (PPS) with ESMTPS id 3ppbvg1j0a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Apr 2023 10:56:52 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
        by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 333Aum7K27656824
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Apr 2023 10:56:48 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E543C20043;
        Mon,  3 Apr 2023 10:56:47 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B686A20040;
        Mon,  3 Apr 2023 10:56:47 +0000 (GMT)
Received: from p-imbrenda (unknown [9.152.224.56])
        by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Mon,  3 Apr 2023 10:56:47 +0000 (GMT)
Date:   Mon, 3 Apr 2023 12:56:46 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>,
        Janosch Frank <frankja@linux.ibm.com>,
        Nico Boehr <nrb@linux.ibm.com>
Subject: Re: [kvm-unit-tests PATCH] ci: Provide the logs as artifacts
Message-ID: <20230403125646.18fe06f4@p-imbrenda>
In-Reply-To: <20230403093255.45104-1-thuth@redhat.com>
References: <20230403093255.45104-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.35; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: npM67LAVbp4SwddYqN0EOeNPxv-scEtL
X-Proofpoint-ORIG-GUID: KtMgpwzm673mo8ppYT2fPNPTHPjnmnj3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-03_06,2023-04-03_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 malwarescore=0
 spamscore=0 clxscore=1015 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304030080
X-Spam-Status: No, score=-0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon,  3 Apr 2023 11:32:55 +0200
Thomas Huth <thuth@redhat.com> wrote:

> If something goes wrong, it's good to have a way to see where it failed,
> so let's provide the logs as artifacts.
> 
> While we're at it, also dump /proc/cpuinfo in the Fedora KVM job
> as this might contain valuable information about the KVM environment.
> 
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  .gitlab-ci.yml                | 22 ++++++++++++++++++++++
>  ci/cirrus-ci-fedora.yml       |  6 ++++++
>  ci/cirrus-ci-macos-i386.yml   |  4 ++++
>  ci/cirrus-ci-macos-x86-64.yml |  4 ++++
>  4 files changed, 36 insertions(+)
> 
> diff --git a/.gitlab-ci.yml b/.gitlab-ci.yml
> index ad7949c9..59a3d3c8 100644
> --- a/.gitlab-ci.yml
> +++ b/.gitlab-ci.yml
> @@ -4,7 +4,20 @@ before_script:
>   - dnf update -y
>   - dnf install -y make python
>  
> +.intree_template:
> + artifacts:
> +  expire_in: 2 days
> +  paths:
> +   - logs
> +
> +.outoftree_template:
> + artifacts:
> +  expire_in: 2 days
> +  paths:
> +   - build/logs
> +
>  build-aarch64:
> + extends: .intree_template
>   script:
>   - dnf install -y qemu-system-aarch64 gcc-aarch64-linux-gnu
>   - ./configure --arch=aarch64 --cross-prefix=aarch64-linux-gnu-
> @@ -35,6 +48,7 @@ build-aarch64:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-arm:
> + extends: .outoftree_template
>   script:
>   - dnf install -y qemu-system-arm gcc-arm-linux-gnu
>   - mkdir build
> @@ -49,6 +63,7 @@ build-arm:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-ppc64be:
> + extends: .outoftree_template
>   script:
>   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>   - mkdir build
> @@ -62,6 +77,7 @@ build-ppc64be:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-ppc64le:
> + extends: .intree_template
>   script:
>   - dnf install -y qemu-system-ppc gcc-powerpc64-linux-gnu
>   - ./configure --arch=ppc64 --endian=little --cross-prefix=powerpc64-linux-gnu-
> @@ -73,6 +89,7 @@ build-ppc64le:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-s390x:
> + extends: .outoftree_template
>   script:
>   - dnf install -y qemu-system-s390x gcc-s390x-linux-gnu
>   - mkdir build
> @@ -109,6 +126,7 @@ build-s390x:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-x86_64:
> + extends: .intree_template
>   script:
>   - dnf install -y qemu-system-x86 gcc
>   - ./configure --arch=x86_64
> @@ -147,6 +165,7 @@ build-x86_64:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-i386:
> + extends: .outoftree_template
>   script:
>   - dnf install -y qemu-system-x86 gcc
>   - mkdir build
> @@ -180,6 +199,7 @@ build-i386:
>   - if grep -q FAIL results.txt ; then exit 1 ; fi
>  
>  build-clang:
> + extends: .intree_template
>   script:
>   - dnf install -y qemu-system-x86 clang
>   - ./configure --arch=x86_64 --cc=clang
> @@ -218,6 +238,7 @@ build-clang:
>   - grep -q PASS results.txt && ! grep -q FAIL results.txt
>  
>  build-centos7:
> + extends: .outoftree_template
>   image: centos:7
>   before_script:
>   - yum update -y
> @@ -266,6 +287,7 @@ cirrus-ci-macos-x86-64:
>   <<: *cirrus_build_job_definition
>  
>  s390x-kvm:
> + extends: .intree_template
>   before_script: []
>   tags:
>    - s390x-z15-vm
> diff --git a/ci/cirrus-ci-fedora.yml b/ci/cirrus-ci-fedora.yml
> index d6070f70..918c9a36 100644
> --- a/ci/cirrus-ci-fedora.yml
> +++ b/ci/cirrus-ci-fedora.yml
> @@ -13,6 +13,8 @@ fedora_task:
>      - git fetch origin "@CI_COMMIT_REF_NAME@"
>      - git reset --hard "@CI_COMMIT_SHA@"
>    script:
> +    - uname -r
> +    - sed -n "/processor.*:.0/,/^$/p" /proc/cpuinfo
>      - mkdir build
>      - cd build
>      - ../configure
> @@ -70,3 +72,7 @@ fedora_task:
>          xsave
>          | tee results.txt
>      - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +  on_failure:
> +    log_artifacts:
> +      path: build/logs/*.log
> +      type: text/plain
> diff --git a/ci/cirrus-ci-macos-i386.yml b/ci/cirrus-ci-macos-i386.yml
> index ed580e61..45d1b716 100644
> --- a/ci/cirrus-ci-macos-i386.yml
> +++ b/ci/cirrus-ci-macos-i386.yml
> @@ -35,3 +35,7 @@ macos_i386_task:
>           vmexit_tscdeadline_immed
>           | tee results.txt
>      - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +  on_failure:
> +    log_artifacts:
> +      path: build/logs/*.log
> +      type: text/plain
> diff --git a/ci/cirrus-ci-macos-x86-64.yml b/ci/cirrus-ci-macos-x86-64.yml
> index 861caa16..8ee6fb7e 100644
> --- a/ci/cirrus-ci-macos-x86-64.yml
> +++ b/ci/cirrus-ci-macos-x86-64.yml
> @@ -39,3 +39,7 @@ macos_task:
>           vmexit_tscdeadline_immed
>           | tee results.txt
>      - grep -q PASS results.txt && ! grep -q FAIL results.txt
> +  on_failure:
> +    log_artifacts:
> +      path: build/logs/*.log
> +      type: text/plain

