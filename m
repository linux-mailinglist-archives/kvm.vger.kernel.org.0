Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2E549C7F4
	for <lists+kvm@lfdr.de>; Wed, 26 Jan 2022 11:50:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240213AbiAZKuW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jan 2022 05:50:22 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233176AbiAZKuV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 Jan 2022 05:50:21 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20QAa46m006863
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 10:50:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Mds6KfXCGiuY6ShHHtm5dfUvh7nv2Tw1cd7RNYNSWTU=;
 b=jvPQ/RU00jjtCXvvTjk1rD1tQ5P3JEI4aSY+Gsdi3l63Qo4NdqArGZBgm/M3wsx5i65f
 tszHaBcF0eO7Mjn+sM96SEg0yRo25wsqrUL/Hqqwjx+4oqd/Tr5ujVTjmn8UnPLbpS+E
 YhgH4MO6Xaecghl/NvBWidsLRhC2Ch/Zsqf6Le+CyQwV0PNsvJo2C//2Rg1W6YizcZ7w
 inNZU5QavKK1+8+1Zw1qGCCvjtgqHiMx4S1gza5ZGyZUTAcTuTzO6wFEE7gPsNCxlviH
 KzUQF+XaPTkDK0N0apC41BMoBMrgraxH4Sx2hJTUI2J1EGrNRlCmM8Y6fSCVVvWg+90B YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du30vtcev-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 10:50:21 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20QAfJfJ028636
        for <kvm@vger.kernel.org>; Wed, 26 Jan 2022 10:50:21 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3du30vtcec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:50:21 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20QAgROE012576;
        Wed, 26 Jan 2022 10:50:18 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3dr96jn8t2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Jan 2022 10:50:18 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20QAoG4e45941136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Jan 2022 10:50:16 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2916BA405B;
        Wed, 26 Jan 2022 10:50:16 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DAC04A4066;
        Wed, 26 Jan 2022 10:50:15 +0000 (GMT)
Received: from [9.145.146.49] (unknown [9.145.146.49])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 26 Jan 2022 10:50:15 +0000 (GMT)
Message-ID: <871d090d-36c9-1c6f-016f-634a7c705d4b@linux.ibm.com>
Date:   Wed, 26 Jan 2022 11:50:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [kvm-unit-tests PATCH] Use a prefix for the STANDALONE
 environment variable
Content-Language: en-US
To:     Thomas Huth <thuth@redhat.com>, kvm@vger.kernel.org,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>
References: <20220120182200.152835-1-thuth@redhat.com>
From:   Janosch Frank <frankja@linux.ibm.com>
In-Reply-To: <20220120182200.152835-1-thuth@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Q7a1llc2CXD2URHJ6-Uo5m0IWw9amE6H
X-Proofpoint-GUID: 0TbQeVyWf5dD3AmGml0vFnAGYZKbF_PP
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-26_02,2022-01-26_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015 adultscore=0
 suspectscore=0 mlxscore=0 phishscore=0 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2201260061
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/22 19:22, Thomas Huth wrote:
> Seems like "STANDALONE" is too generic and causes a conflict in
> certain environments (see bug link below). Add a prefix here to
> decrease the possibility of a conflict here.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/3
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Doesn't look like this would impact our ci in a meaningful way, so:
Acked-by: Janosch Frank <frankja@linux.ibm.com>

> ---
>   arm/run                 | 2 +-
>   powerpc/run             | 2 +-
>   s390x/run               | 2 +-
>   scripts/mkstandalone.sh | 2 +-
>   scripts/runtime.bash    | 4 ++--
>   x86/run                 | 2 +-
>   6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index a390ca5..a94e1c7 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -1,6 +1,6 @@
>   #!/usr/bin/env bash
>   
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>   	if [ ! -f config.mak ]; then
>   		echo "run ./configure && make first. See ./configure -h"
>   		exit 2
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96..ee38e07 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -1,6 +1,6 @@
>   #!/usr/bin/env bash
>   
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>   	if [ ! -f config.mak ]; then
>   		echo "run ./configure && make first. See ./configure -h"
>   		exit 2
> diff --git a/s390x/run b/s390x/run
> index c615caa..064ecd1 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -1,6 +1,6 @@
>   #!/usr/bin/env bash
>   
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>   	if [ ! -f config.mak ]; then
>   		echo "run ./configure && make first. See ./configure -h"
>   		exit 2
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index cefdec3..86c7e54 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -35,7 +35,7 @@ generate_test ()
>   	done
>   
>   	echo "#!/usr/bin/env bash"
> -	echo "export STANDALONE=yes"
> +	echo "export KUT_STANDALONE=yes"
>   	echo "export ENVIRON_DEFAULT=$ENVIRON_DEFAULT"
>   	echo "export HOST=\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')"
>   	echo "export PRETTY_PRINT_STACKS=no"
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c513761..6d5fced 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -36,7 +36,7 @@ get_cmdline()
>   skip_nodefault()
>   {
>       [ "$run_all_tests" = "yes" ] && return 1
> -    [ "$STANDALONE" != "yes" ] && return 0
> +    [ "$KUT_STANDALONE" != "yes" ] && return 0
>   
>       while true; do
>           read -r -p "Test marked not to be run by default, are you sure (y/N)? " yn
> @@ -155,7 +155,7 @@ function run()
>       summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
>                                > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))
>       ret=$?
> -    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
> +    [ "$KUT_STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
>   
>       if [ $ret -eq 0 ]; then
>           print_result "PASS" $testname "$summary"
> diff --git a/x86/run b/x86/run
> index ab91753..582d1ed 100755
> --- a/x86/run
> +++ b/x86/run
> @@ -1,6 +1,6 @@
>   #!/usr/bin/env bash
>   
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>   	if [ ! -f config.mak ]; then
>   		echo "run ./configure && make first. See ./configure -h"
>   		exit 2
> 

