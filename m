Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFAA3CE5D
	for <lists+kvm@lfdr.de>; Tue, 11 Jun 2019 16:21:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388728AbfFKOTf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jun 2019 10:19:35 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:40528 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2387551AbfFKOTf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jun 2019 10:19:35 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5BEEtj6009179
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:19:33 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2t2dhthm09-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Tue, 11 Jun 2019 10:19:33 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Tue, 11 Jun 2019 15:19:33 +0100
Received: from b01cxnp23034.gho.pok.ibm.com (9.57.198.29)
        by e14.ny.us.ibm.com (146.89.104.201) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 11 Jun 2019 15:19:30 +0100
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5BEJThA37421398
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jun 2019 14:19:29 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A3EA7112065;
        Tue, 11 Jun 2019 14:19:29 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 75417112064;
        Tue, 11 Jun 2019 14:19:29 +0000 (GMT)
Received: from [9.60.75.173] (unknown [9.60.75.173])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jun 2019 14:19:29 +0000 (GMT)
Subject: Re: [PATCH RFC 1/1] allow to specify additional config data
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
 <20190606144417.1824-2-cohuck@redhat.com> <20190606093224.3ecb92c7@x1.home>
 <20190606101552.6fc62bef@x1.home>
 <ed75a4de-da0b-f6cf-6164-44cebc82c3a5@linux.ibm.com>
 <20190607140344.0399b766@x1.home>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Tue, 11 Jun 2019 10:19:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190607140344.0399b766@x1.home>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061114-0052-0000-0000-000003CE70B5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011246; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01216459; UDB=6.00639602; IPR=6.00997558;
 MB=3.00027261; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-11 14:19:32
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061114-0053-0000-0000-0000614848A1
Message-Id: <1d859c27-31e2-64ca-f505-19abe9bffed2@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-11_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906110095
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/7/19 4:03 PM, Alex Williamson wrote:
> On Fri, 7 Jun 2019 14:26:13 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 6/6/19 12:15 PM, Alex Williamson wrote:
>>> On Thu, 6 Jun 2019 09:32:24 -0600
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>    
>>>> On Thu,  6 Jun 2019 16:44:17 +0200
>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>   
>>>>> Add a rough implementation for vfio-ap.
>>>>>
>>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>>> ---
>>>>>    mdevctl.libexec | 25 ++++++++++++++++++++++
>>>>>    mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>    2 files changed, 80 insertions(+), 1 deletion(-)
>>>>>
>>>>> diff --git a/mdevctl.libexec b/mdevctl.libexec
>>>>> index 804166b5086d..cc0546142924 100755
>>>>> --- a/mdevctl.libexec
>>>>> +++ b/mdevctl.libexec
>>>>> @@ -54,6 +54,19 @@ wait_for_supported_types () {
>>>>>        fi
>>>>>    }
>>>>>    
>>>>> +# configure vfio-ap devices <config entry> <matrix attribute>
>>>>> +configure_ap_devices() {
>>>>> +    list="`echo "${config[$1]}" | sed 's/,/ /'`"
>>>>> +    [ -z "$list" ] && return
>>>>> +    for a in $list; do
>>>>> +        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
>>>>> +        if [ $? -ne 0 ]; then
>>>>> +            echo "Error writing '$a' to '$uuid/$2'" >&2
>>>>> +            exit 1
>>>>> +        fi
>>>>> +    done
>>>>> +}
>>>>> +
>>>>>    case ${1} in
>>>>>        start-mdev|stop-mdev)
>>>>>            if [ $# -ne 2 ]; then
>>>>> @@ -148,6 +161,18 @@ case ${cmd} in
>>>>>                echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
>>>>>                exit 1
>>>>>            fi
>>>>> +
>>>>> +        # some types may specify additional config data
>>>>> +        case ${config[mdev_type]} in
>>>>> +            vfio_ap-passthrough)
>>>>
>>>> I think this could have some application beyond ap too, I know NVIDIA
>>>> GRID vGPUs do have some controls under the vendor hierarchy of the
>>>> device, ex. setting the frame rate limiter.  The implementation here is
>>>> a bit rigid, we know a specific protocol for a specific mdev type, but
>>>> for supporting arbitrary vendor options we'd really just want to try to
>>>> apply whatever options are provided.  If we didn't care about ordering,
>>>> we could just look for keys for every file in the device's immediate
>>>> sysfs hierarchy and apply any value we find, independent of the
>>>> mdev_type, ex. intel_vgpu/foo=bar  Thanks,
>>>
>>> For example:
>>>
>>> for key in find -P $mdev_base/$uuid/ \( -path
>>> "$mdev_base/$uuid/power/*" -o -path $mdev_base/$uuid/uevent -o -path $mdev_base/$uuid/remove \) -prune -o -type f -print | sed -e "s|$mdev_base/$uuid/||g"); do
>>>     [ -z ${config[$key]} ] && continue
>>>     ... parse value(s) and iteratively apply to key
>>> done
>>>
>>> The find is a little ugly to exclude stuff, maybe we just let people do
>>> screwy stuff like specify remove=1 in their config.  Also need to think
>>> about whether we're imposing a delimiter to apply multiple values to a
>>> key that conflicts with the attribute usage.  Thanks,
>>>
>>> Alex
>>
>> I like the idea of looking for files in the device's immediate sysfs
>> hierarchy, but maybe the find could exclude attributes that are
>> not vendor defined.
> 
> How would we know what attributes are vendor defined?  The above `find`
> strips out the power, uevent, and remove attributes, which for GVT-g
> leaves only the vendor defined attributes[1], but I don't know how to
> instead do a positive match of the vendor attributes without
> unmaintainable lookup tables.  This starts to get into the question of
> how much do we want to (or need to) protect the user from themselves.
> If we let the user specify a key=value of remove=1 and the device
> immediately disappears, is that a bug or a feature?  Thanks,
> 
> Alex

By vendor defined, I meant attributes that are not defined by the mdev
framework, such as the 'remove' attribute. As far as whether allowing
specification of remove-1, I'd have to play with that and see what all
of the ramifications are.

Tony K

> 
> [1] GVT-g doesn't actually have an writable attributes, so we'd also
> minimally want to add a test to skip read-only attributes.

Probably a good idea.

> 
>>>>> +                configure_ap_devices ap_adapters assign_adapter
>>>>> +                configure_ap_devices ap_domains assign_domain
>>>>> +                configure_ap_devices ap_control_domains assign_control_domain
>>>>> +                # TODO: is assigning idempotent? Should we unwind on error?
>>>>> +                ;;
>>>>> +            *)
>>>>> +                ;;
>>>>> +        esac
>>>>>            ;;
>>>>>    
>>>>>        add-mdev)
>>>>> diff --git a/mdevctl.sbin b/mdevctl.sbin
>>>>> index 276cf6ddc817..eb5ee0091879 100755
>>>>> --- a/mdevctl.sbin
>>>>> +++ b/mdevctl.sbin
>>>>> @@ -33,6 +33,8 @@ usage() {
>>>>>        echo "set-start <mdev UUID>: change mdev start policy, if no option specified," >&2
>>>>>        echo "                       system default policy is used" >&2
>>>>>        echo "                       options: [--auto] [--manual]" >&2
>>>>> +    echo "set-additional-config <mdev UUID> {fmt...}: supply additional configuration" >&2
>>>>> +    echo "show-additional-config-format <mdev UUiD>:  prints the format expected by the device" >&2
>>>>>        echo "list-all: list all possible mdev types supported in the system" >&2
>>>>>        echo "list-available: list all mdev types currently available" >&2
>>>>>        echo "list-mdevs: list currently configured mdevs" >&2
>>>>> @@ -48,7 +50,7 @@ while (($# > 0)); do
>>>>>            --manual)
>>>>>                config[start]=manual
>>>>>                ;;
>>>>> -        start-mdev|stop-mdev|remove-mdev|set-start)
>>>>> +        start-mdev|stop-mdev|remove-mdev|set-start|show-additional-config-format)
>>>>>                [ $# -ne 2 ] && usage
>>>>>                cmd=$1
>>>>>                uuid=$2
>>>>> @@ -67,6 +69,14 @@ while (($# > 0)); do
>>>>>                cmd=$1
>>>>>                break
>>>>>                ;;
>>>>> +        set-additional-config)
>>>>> +            [ $# -le 2 ] && usage
>>>>> +            cmd=$1
>>>>> +            uuid=$2
>>>>> +            shift 2
>>>>> +            addtl_config="$*"
>>>>> +            break
>>>>> +            ;;
>>>>>            *)
>>>>>                usage
>>>>>                ;;
>>>>> @@ -114,6 +124,50 @@ case ${cmd} in
>>>>>            fi
>>>>>            ;;
>>>>>    
>>>>> +    set-additional-config)
>>>>> +        file=$(find $persist_base -name $uuid -type f)
>>>>> +        if [ -w "$file" ]; then
>>>>> +            read_config "$file"
>>>>> +            if [ ${config[start]} == "auto" ]; then
>>>>> +                systemctl stop mdev@$uuid.service
>>>>> +            fi
>>>>> +            # FIXME: validate input!
>>>>> +            for i in $addtl_config; do
>>>>> +                key="`echo "$i" | cut -d '=' -f 1`"
>>>>> +                value="`echo "$i" | cut -d '=' -f 2-`"
>>>>> +                if grep -q ^$key $file; then
>>>>> +                    if [ -z "$value" ]; then
>>>>> +                        sed -i "s/^$key=.*//g" $file
>>>>> +                    else
>>>>> +                        sed -i "s/^$key=.*/$key=$value/g" $file
>>>>> +                    fi
>>>>> +                else
>>>>> +                    echo "$i" >> "$file"
>>>>> +                fi
>>>>> +            done
>>>>> +            if [ ${config[start]} == "auto" ]; then
>>>>> +                systemctl start mdev@$uuid.service
>>>>> +            fi
>>>>> +        else
>>>>> +            exit 1
>>>>> +        fi
>>>>> +        ;;
>>>>> +
>>>>> +    show-additional-config-format)
>>>>> +        file=$(find $persist_base -name $uuid -type f)
>>>>> +        read_config "$file"
>>>>> +        case ${config[mdev_type]} in
>>>>> +            vfio_ap-passthrough)
>>>>> +                echo "ap_adapters=<comma-separated list of adapters>"
>>>>> +                echo "ap_domains=<comma-separated list of domains>"
>>>>> +                echo "ap_control_domains=<comma-separated list of control domains>"
>>>>> +                ;;
>>>>> +            *)
>>>>> +                echo "no additional configuration defined"
>>>>> +                ;;
>>>>> +        esac
>>>>> +        ;;
>>>>> +
>>>>>        list-mdevs)
>>>>>            for mdev in $(find $mdev_base/ -maxdepth 1 -mindepth 1 -type l); do
>>>>>                uuid=$(basename $mdev)
>>>>   
>>>    
>>
> 

