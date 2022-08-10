Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B372C58EA48
	for <lists+kvm@lfdr.de>; Wed, 10 Aug 2022 12:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231571AbiHJKKQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Aug 2022 06:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiHJKKP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Aug 2022 06:10:15 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1072FE12
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 03:10:14 -0700 (PDT)
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27A97d8U032226
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=wpQQNv5k08/WCK7wXcYXdITkJQQwioZUCYBEW2tRyZM=;
 b=BIbNvRaLXD6H6U2YkPNE36PC9SWZJQGCQn6108yMQ/JXpsxlq48/34aGsjvGwltTvIPM
 hyFZwDOvwuwLD7At6vGTk34k81AsQmNnejs5xfaOJeLa+2l7aOkSXIb5b6gcP5FRH9eV
 Zwnbzrh3Lbz7+SjZ2fxDq6krrHMYUqjtWmrsMlkXV5zKQE1DeWHH+vwzjuxLACOhGPUC
 zSUIazzgomVQz2jwggC8tr3HADFou10o1OHtirttmkbP27jBLaf3WnFc9Re7vj4kACMP
 bHDllev5qnnNEh2mOf6unesJV6YjPyIDQn6OEiV/DVP/UE4bZCUD6t+8qZarRmfwKSEg EA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv4c6trgj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:13 +0000
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27A97kr1000745
        for <kvm@vger.kernel.org>; Wed, 10 Aug 2022 10:10:12 GMT
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hv4c6trfk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:12 +0000
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27AA9MVE025146;
        Wed, 10 Aug 2022 10:10:11 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03fra.de.ibm.com with ESMTP id 3huwvfrgur-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 10 Aug 2022 10:10:10 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27AAA7Rk33030404
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Aug 2022 10:10:07 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9FD5FA404D;
        Wed, 10 Aug 2022 10:10:07 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 520D8A4040;
        Wed, 10 Aug 2022 10:10:07 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.0.105])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 10 Aug 2022 10:10:07 +0000 (GMT)
Date:   Wed, 10 Aug 2022 11:58:08 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v3 1/4] runtime: add support for panic
 tests
Message-ID: <20220810115808.62c51ef1@p-imbrenda>
In-Reply-To: <20220722060043.733796-2-nrb@linux.ibm.com>
References: <20220722060043.733796-1-nrb@linux.ibm.com>
        <20220722060043.733796-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FKpSranWATu_fM8jrdYdSmj1REkm65Ke
X-Proofpoint-GUID: BIpr9omHW-8vURrIYFOZ009GykyxMtmI
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-10_04,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208100031
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 22 Jul 2022 08:00:40 +0200
Nico Boehr <nrb@linux.ibm.com> wrote:

> QEMU supports a guest state "guest-panicked" which indicates something
> in the guest went wrong, for example on s390x, when an external
> interrupt loop was triggered.
> 
> Since the guest does not continue to run when it is in the
> guest-panicked state, it is currently impossible to write panicking
> tests in kvm-unit-tests. Support from the runtime is needed to check
> that the guest enters the guest-panicked state.
> 
> Similar to migration tests, add a new group panic. Tests in this
> group must enter the guest-panicked state to succeed.
> 
> The runtime will spawn a QEMU instance, connect to the QMP and listen
> for events. To parse the QMP protocol, jq[1] is used. Same as with
> netcat in the migration tests, panic tests won't run if jq is not
> installed.
> 
> The guest is created in the stopped state and only continued when
> connection to the QMP was successful. This ensures no events are missed
> between QEMU start and the connect to the QMP.
> 
> [1] https://stedolan.github.io/jq/
> 
> Signed-off-by: Nico Boehr <nrb@linux.ibm.com>
> Reviewed-by: Thomas Huth <thuth@redhat.com>
> ---
>  s390x/run             |  2 +-
>  scripts/arch-run.bash | 49 +++++++++++++++++++++++++++++++++++++++++++
>  scripts/runtime.bash  |  3 +++
>  3 files changed, 53 insertions(+), 1 deletion(-)
> 
> diff --git a/s390x/run b/s390x/run
> index 24138f6803be..f1111dbdbe62 100755
> --- a/s390x/run
> +++ b/s390x/run
> @@ -30,7 +30,7 @@ M+=",accel=$ACCEL"
>  command="$qemu -nodefaults -nographic $M"
>  command+=" -chardev stdio,id=con0 -device sclpconsole,chardev=con0"
>  command+=" -kernel"
> -command="$(migration_cmd) $(timeout_cmd) $command"
> +command="$(panic_cmd) $(migration_cmd) $(timeout_cmd) $command"
>  
>  # We return the exit code via stdout, not via the QEMU return code
>  run_qemu_status $command "$@"
> diff --git a/scripts/arch-run.bash b/scripts/arch-run.bash
> index 0dfaf017db0a..739490bc7da2 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -104,6 +104,14 @@ qmp ()
>  	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>  }
>  
> +qmp_events ()
> +{
> +	while ! test -S "$1"; do sleep 0.1; done
> +	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' \

if you put the pipe at the end of the line, instead of the beginning,
then you don't need the \ . I think it is easier to read without the \
and it is also more robust (no need to worry about spaces)

> +		| ncat --no-shutdown -U $1 \
> +		| jq -c 'select(has("event"))'
> +}
> +
>  run_migration ()
>  {
>  	if ! command -v ncat >/dev/null 2>&1; then
> @@ -164,6 +172,40 @@ run_migration ()
>  	return $ret
>  }
>  
> +run_panic ()
> +{
> +	if ! command -v ncat >/dev/null 2>&1; then
> +		echo "${FUNCNAME[0]} needs ncat (netcat)" >&2
> +		return 77
> +	fi
> +
> +	if ! command -v jq >/dev/null 2>&1; then
> +		echo "${FUNCNAME[0]} needs jq" >&2
> +		return 77
> +	fi
> +
> +	qmp=$(mktemp -u -t panic-qmp.XXXXXXXXXX)
> +
> +	trap 'kill 0; exit 2' INT TERM
> +	trap 'rm -f ${qmp}' RETURN EXIT
> +
> +	# start VM stopped so we don't miss any events
> +	eval "$@" -chardev socket,id=mon1,path=${qmp},server=on,wait=off \
> +		-mon chardev=mon1,mode=control -S &
> +
> +	panic_event_count=$(qmp_events ${qmp} | jq -c 'select(.event == "GUEST_PANICKED")' | wc -l)
> +	if [ "$panic_event_count" -lt 1 ]; then
> +		echo "FAIL: guest did not panic"
> +		ret=3
> +	else
> +		# some QEMU versions report multiple panic events
> +		echo "PASS: guest panicked"
> +		ret=1

so we never return 0? is that intentional?

> +	fi
> +
> +	return $ret
> +}
> +
>  migration_cmd ()
>  {
>  	if [ "$MIGRATION" = "yes" ]; then
> @@ -171,6 +213,13 @@ migration_cmd ()
>  	fi
>  }
>  
> +panic_cmd ()
> +{
> +	if [ "$PANIC" = "yes" ]; then
> +		echo "run_panic"
> +	fi
> +}
> +
>  search_qemu_binary ()
>  {
>  	local save_path=$PATH
> diff --git a/scripts/runtime.bash b/scripts/runtime.bash
> index 7d0180bf14bd..8072f3bb536a 100644
> --- a/scripts/runtime.bash
> +++ b/scripts/runtime.bash
> @@ -145,6 +145,9 @@ function run()
>      if find_word "migration" "$groups"; then
>          cmdline="MIGRATION=yes $cmdline"
>      fi
> +    if find_word "panic" "$groups"; then
> +        cmdline="PANIC=yes $cmdline"
> +    fi
>      if [ "$verbose" = "yes" ]; then
>          echo $cmdline
>      fi

