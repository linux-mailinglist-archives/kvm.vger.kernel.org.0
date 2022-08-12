Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1066D590DF4
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 11:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbiHLJRp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Aug 2022 05:17:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232010AbiHLJRn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Aug 2022 05:17:43 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26C9A7AB5
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 02:17:42 -0700 (PDT)
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27C99JM8007093
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:17:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=5PYKm6ZoJSMOboe3C14rqV4lHf+yHcZx9qxFk51ZJrQ=;
 b=tLwPI5KTEmCFN3Lua645Gc4vpHK6v+io/FmJmNeX/0vjnb1S+S9E66EXNkbD0HjWdWls
 aRvYTxZtTguH5kFcOdML98PWpPev5qbXXr4BXtTdA8fbXBq2G2RpuuRRDOUJdHfDCBga
 vspR3WfHR9sfdvjNCmst8pkjNATWhdwMbfvyCtdA1pHOUdwqqnZ40l8lPOaSZ0qqciaM
 D1XhD9Jmfpijek1mTXSb8zCyKKGb+jNcCVF1qhCqYx3PDdL+qLW1vwpzV0R5rpBKQ8yg
 wqlBDEhzoQcw1aHTNZXnsn9srY9NtizYjlHYE/ME0WuzAILh+bfhUKuBhufAuJ5PQso4 hg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwk9rsm4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:17:41 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 27C99OW1007771
        for <kvm@vger.kernel.org>; Fri, 12 Aug 2022 09:17:41 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3hwk9rsm44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:17:41 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 27C96BBE029970;
        Fri, 12 Aug 2022 09:17:39 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma04ams.nl.ibm.com with ESMTP id 3hw3wfrudh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Aug 2022 09:17:39 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 27C9Hau934210136
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Aug 2022 09:17:36 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 760894C046;
        Fri, 12 Aug 2022 09:17:36 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1F0224C040;
        Fri, 12 Aug 2022 09:17:36 +0000 (GMT)
Received: from p-imbrenda (unknown [9.145.3.179])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 12 Aug 2022 09:17:36 +0000 (GMT)
Date:   Fri, 12 Aug 2022 11:17:34 +0200
From:   Claudio Imbrenda <imbrenda@linux.ibm.com>
To:     Nico Boehr <nrb@linux.ibm.com>
Cc:     kvm@vger.kernel.org, frankja@linux.ibm.com, thuth@redhat.com
Subject: Re: [kvm-unit-tests PATCH v4 1/4] runtime: add support for panic
 tests
Message-ID: <20220812111734.21ee38da@p-imbrenda>
In-Reply-To: <20220812062151.1980937-2-nrb@linux.ibm.com>
References: <20220812062151.1980937-1-nrb@linux.ibm.com>
        <20220812062151.1980937-2-nrb@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.34; x86_64-redhat-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: jMHW9UylNFEqtqfvK-UVNQp9mvwFu3a0
X-Proofpoint-ORIG-GUID: wQ55bazfbg_VjUn929Q9CGINbP7Ggh-H
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-12_06,2022-08-11_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 spamscore=0 priorityscore=1501 impostorscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2208120024
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 12 Aug 2022 08:21:48 +0200
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

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

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
> index 0dfaf017db0a..51e4b97b27d1 100644
> --- a/scripts/arch-run.bash
> +++ b/scripts/arch-run.bash
> @@ -104,6 +104,14 @@ qmp ()
>  	echo '{ "execute": "qmp_capabilities" }{ "execute":' "$2" '}' | ncat -U $1
>  }
>  
> +qmp_events ()
> +{
> +	while ! test -S "$1"; do sleep 0.1; done
> +	echo '{ "execute": "qmp_capabilities" }{ "execute": "cont" }' |
> +		ncat --no-shutdown -U $1 |
> +		jq -c 'select(has("event"))'
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
> index bbf87cf4ed3f..f8794e9a25ce 100644
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

