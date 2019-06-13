Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A56B743F59
	for <lists+kvm@lfdr.de>; Thu, 13 Jun 2019 17:56:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388180AbfFMP4j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jun 2019 11:56:39 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36514 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731679AbfFMP4h (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Jun 2019 11:56:37 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5DFpjJw068741
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 11:56:36 -0400
Received: from e06smtp07.uk.ibm.com (e06smtp07.uk.ibm.com [195.75.94.103])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t3rn6u4td-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Thu, 13 Jun 2019 11:56:36 -0400
Received: from localhost
        by e06smtp07.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Thu, 13 Jun 2019 16:56:34 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp07.uk.ibm.com (192.168.101.137) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Thu, 13 Jun 2019 16:56:31 +0100
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5DFuTxk49348724
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Jun 2019 15:56:29 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B2A7EAE055;
        Thu, 13 Jun 2019 15:56:29 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6C657AE051;
        Thu, 13 Jun 2019 15:56:29 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.26])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 13 Jun 2019 15:56:29 +0000 (GMT)
Date:   Thu, 13 Jun 2019 17:56:28 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
Subject: Re: [PATCH RFC 1/1] allow to specify additional config data
In-Reply-To: <20190606144417.1824-2-cohuck@redhat.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
        <20190606144417.1824-2-cohuck@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19061315-0028-0000-0000-0000037A0A9E
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061315-0029-0000-0000-0000243A046B
Message-Id: <20190613175628.28159268.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-13_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906130118
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu,  6 Jun 2019 16:44:17 +0200
Cornelia Huck <cohuck@redhat.com> wrote:

> Add a rough implementation for vfio-ap.
> 
> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
> ---
>  mdevctl.libexec | 25 ++++++++++++++++++++++
>  mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 80 insertions(+), 1 deletion(-)
> 
> diff --git a/mdevctl.libexec b/mdevctl.libexec
> index 804166b5086d..cc0546142924 100755
> --- a/mdevctl.libexec
> +++ b/mdevctl.libexec
> @@ -54,6 +54,19 @@ wait_for_supported_types () {
>      fi
>  }
>  
> +# configure vfio-ap devices <config entry> <matrix attribute>
> +configure_ap_devices() {
> +    list="`echo "${config[$1]}" | sed 's/,/ /'`"
> +    [ -z "$list" ] && return
> +    for a in $list; do
> +        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
> +        if [ $? -ne 0 ]; then
> +            echo "Error writing '$a' to '$uuid/$2'" >&2
> +            exit 1
> +        fi
> +    done
> +}
> +
>  case ${1} in
>      start-mdev|stop-mdev)
>          if [ $# -ne 2 ]; then
> @@ -148,6 +161,18 @@ case ${cmd} in
>              echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
>              exit 1
>          fi
> +
> +        # some types may specify additional config data
> +        case ${config[mdev_type]} in
> +            vfio_ap-passthrough)
> +                configure_ap_devices ap_adapters assign_adapter
> +                configure_ap_devices ap_domains assign_domain
> +                configure_ap_devices ap_control_domains assign_control_domain
> +                # TODO: is assigning idempotent? Should we unwind on error?

It is largely idempotent AFAIR. The pathological case is queues go away
between the two assigns, but that results in the worst case just
in an error code -- the previous assignment is still effective. Why are
you asking? When doing this next time we will start with a freshly
created mdev I guess.

Regarding unwind. Keeping a half configured mdev (errors happened) looks
like a bad idea to me. Currently we don't fail the start operation if
we can't configure a device. So I guess the in case of vfio_ap the
guest would just start with whatever we managed to get.

What about concurrent updates to the config?

> +                ;;
> +            *)
> +                ;;
> +        esac
>          ;;
>  
>      add-mdev)
> diff --git a/mdevctl.sbin b/mdevctl.sbin
> index 276cf6ddc817..eb5ee0091879 100755
> --- a/mdevctl.sbin
> +++ b/mdevctl.sbin
> @@ -33,6 +33,8 @@ usage() {
>      echo "set-start <mdev UUID>: change mdev start policy, if no option specified," >&2
>      echo "                       system default policy is used" >&2
>      echo "                       options: [--auto] [--manual]" >&2
> +    echo "set-additional-config <mdev UUID> {fmt...}: supply additional configuration" >&2

This is a disruptive action for 'auto' at the moment. I'm not sure about
that, but if we want to have this disruptive, then we need to document
it as such.

> +    echo "show-additional-config-format <mdev UUiD>:  prints the format expected by the device" >&2
>      echo "list-all: list all possible mdev types supported in the system" >&2
>      echo "list-available: list all mdev types currently available" >&2
>      echo "list-mdevs: list currently configured mdevs" >&2
> @@ -48,7 +50,7 @@ while (($# > 0)); do
>          --manual)
>              config[start]=manual
>              ;;
> -        start-mdev|stop-mdev|remove-mdev|set-start)
> +        start-mdev|stop-mdev|remove-mdev|set-start|show-additional-config-format)
>              [ $# -ne 2 ] && usage
>              cmd=$1
>              uuid=$2
> @@ -67,6 +69,14 @@ while (($# > 0)); do
>              cmd=$1
>              break
>              ;;
> +        set-additional-config)
> +            [ $# -le 2 ] && usage
> +            cmd=$1
> +            uuid=$2
> +            shift 2
> +            addtl_config="$*"
> +            break
> +            ;;
>          *)
>              usage
>              ;;
> @@ -114,6 +124,50 @@ case ${cmd} in
>          fi
>          ;;
>  
> +    set-additional-config)
> +        file=$(find $persist_base -name $uuid -type f)
> +        if [ -w "$file" ]; then
> +            read_config "$file"
> +            if [ ${config[start]} == "auto" ]; then
> +                systemctl stop mdev@$uuid.service
> +            fi

If the mdev is not started stop has no effect. If there
is an mdev started, and in use by a VM destroying the
mdev is a disruptive operation.

I'm a bit concerned about this semantic. We have a case
where the change takes effect immediately in a disruptive
or not disruptive fashion, and then we have a case where
only the persistent configuration is changed. And then,
when the configuration are applied, it may only get partially
applied.

Tony is working on hotplug/unplug on vfio_ap_mdevs. I do
not see if that is also supposed to fit in here. Probably
not.

> +            # FIXME: validate input!
> +            for i in $addtl_config; do
> +                key="`echo "$i" | cut -d '=' -f 1`"
> +                value="`echo "$i" | cut -d '=' -f 2-`"
> +                if grep -q ^$key $file; then
> +                    if [ -z "$value" ]; then
> +                        sed -i "s/^$key=.*//g" $file
> +                    else
> +                        sed -i "s/^$key=.*/$key=$value/g" $file
> +                    fi
> +                else
> +                    echo "$i" >> "$file"
> +                fi

How about concurrency? I guess we could end up loosing distinct
updates without detecting it.

> +            done

Basically we append or change but don't remove. So it is a
cumulative thing I suppose.


I'm not sure 'set-additional-config' is a good idea. For vfio_ap
I would hope for a tool that is more intelligent, and can help
with avoiding and managing conflicts.

Regards,
Halil

[..]

