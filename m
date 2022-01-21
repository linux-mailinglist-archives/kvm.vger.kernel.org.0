Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77FE7495ED3
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 13:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350391AbiAUMFD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 07:05:03 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:11760 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1350347AbiAUME4 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 21 Jan 2022 07:04:56 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20LBBlWT027449
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 12:04:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=l9S6edvmWgS36qdlWbUOr5wfriczJwO6AtdNvfgeKXI=;
 b=WlS79PkgZVCIitQxetV86HstftD5tfEwwG2kxCxJr2TeKK8G++l2OsP7YsBmqUKhdtHc
 zXtOi5aecvnGWejq42hV6eugAkekGyRc7gFJhXeRE4D6Ic3RADJZ3M9YfBQPDMZbDP/4
 fGcgNkxR8GBsBb3bHgluKIGh+Y3g/N7W6/O70G4SJMYToazmf9uiN5YtZFT0iu0/jLqt
 iaUnqtMpsm1RhKnvzF6nrBsiJCQa+WSsKXjNE8dxRVwF2Z6omTKP5qF9oGJ9ulaGbstL
 pQ7feE7a1NFnMuRjOpKqYEXFX5BC9c7uPeshjsIP9yznEAOQeQiaEQXMOw4/pXJlwRO3 hw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqur490dw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 12:04:54 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20LBuEiN028971
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 12:04:54 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqur490de-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 12:04:54 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20LBwELs028536;
        Fri, 21 Jan 2022 12:04:52 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma03ams.nl.ibm.com with ESMTP id 3dqjdpm84k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 12:04:52 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20LC4ngZ31195594
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 12:04:49 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B73A142042;
        Fri, 21 Jan 2022 12:04:49 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 52C3F42045;
        Fri, 21 Jan 2022 12:04:49 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.16])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 12:04:49 +0000 (GMT)
Date:   Fri, 21 Jan 2022 13:04:47 +0100
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Thomas Huth <thuth@redhat.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Laurent Vivier <lvivier@redhat.com>
Subject: Re: [kvm-unit-tests PATCH] Use a prefix for the STANDALONE
 environment variable
Message-ID: <20220121130447.37418454@p-imbrenda>
In-Reply-To: <20220120182200.152835-1-thuth@redhat.com>
References: <20220120182200.152835-1-thuth@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZqEF1L7abKO7OyYgKrK7vEwnvF6UAthw
X-Proofpoint-GUID: Mvfx8zIUpHNi1ELe6KZJtCNOGX_SEGD8
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 malwarescore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 impostorscore=0 mlxlogscore=999 bulkscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201210082
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 20 Jan 2022 19:22:00 +0100
Thomas Huth <thuth@redhat.com> wrote:

> Seems like "STANDALONE" is too generic and causes a conflict in
> certain environments (see bug link below). Add a prefix here to
> decrease the possibility of a conflict here.
> 
> Resolves: https://gitlab.com/kvm-unit-tests/kvm-unit-tests/-/issues/3
> Signed-off-by: Thomas Huth <thuth@redhat.com>

Acked-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arm/run                 | 2 +-
>  powerpc/run             | 2 +-
>  s390x/run               | 2 +-
>  scripts/mkstandalone.sh | 2 +-
>  scripts/runtime.bash    | 4 ++--
>  x86/run                 | 2 +-
>  6 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/arm/run b/arm/run
> index a390ca5..a94e1c7 100755
> --- a/arm/run
> +++ b/arm/run
> @@ -1,6 +1,6 @@
>  #!/usr/bin/env bash
>  
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>  	if [ ! -f config.mak ]; then
>  		echo "run ./configure && make first. See ./configure -h"
>  		exit 2
> diff --git a/powerpc/run b/powerpc/run
> index 597ab96..ee38e07 100755
> --- a/powerpc/run
> +++ b/powerpc/run
> @@ -1,6 +1,6 @@
>  #!/usr/bin/env bash
>  
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>  	if [ ! -f config.mak ]; then
>  		echo "run ./configure && make first. See ./configure -h"
>  		exit 2
> diff --git a/s390x/run b/s390x/run
> index c615caa..064ecd1 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -1,6 +1,6 @@
>  #!/usr/bin/env bash
>  
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>  	if [ ! -f config.mak ]; then
>  		echo "run ./configure && make first. See ./configure -h"
>  		exit 2
> diff --git a/scripts/mkstandalone.sh b/scripts/mkstandalone.sh
> index cefdec3..86c7e54 100755
> --- a/scripts/mkstandalone.sh
> +++ b/scripts/mkstandalone.sh
> @@ -35,7 +35,7 @@ generate_test ()
>  	done
>  
>  	echo "#!/usr/bin/env bash"
> -	echo "export STANDALONE=yes"
> +	echo "export KUT_STANDALONE=yes"
>  	echo "export ENVIRON_DEFAULT=$ENVIRON_DEFAULT"
>  	echo "export HOST=\$(uname -m | sed -e 's/i.86/i386/;s/arm.*/arm/;s/ppc64.*/ppc64/')"
>  	echo "export PRETTY_PRINT_STACKS=no"
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index c513761..6d5fced 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -36,7 +36,7 @@ get_cmdline()
>  skip_nodefault()
>  {
>      [ "$run_all_tests" = "yes" ] && return 1
> -    [ "$STANDALONE" != "yes" ] && return 0
> +    [ "$KUT_STANDALONE" != "yes" ] && return 0
>  
>      while true; do
>          read -r -p "Test marked not to be run by default, are you sure (y/N)? " yn
> @@ -155,7 +155,7 @@ function run()
>      summary=$(eval $cmdline 2> >(RUNTIME_log_stderr $testname) \
>                               > >(tee >(RUNTIME_log_stdout $testname $kernel) | extract_summary))  
>      ret=$?
> -    [ "$STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
> +    [ "$KUT_STANDALONE" != "yes" ] && echo > >(RUNTIME_log_stdout $testname $kernel)
>  
>      if [ $ret -eq 0 ]; then
>          print_result "PASS" $testname "$summary"
> diff --git a/x86/run b/x86/run
> index ab91753..582d1ed 100755
> --- a/x86/run
> +++ b/x86/run
> @@ -1,6 +1,6 @@
>  #!/usr/bin/env bash
>  
> -if [ -z "$STANDALONE" ]; then
> +if [ -z "$KUT_STANDALONE" ]; then
>  	if [ ! -f config.mak ]; then
>  		echo "run ./configure && make first. See ./configure -h"
>  		exit 2

