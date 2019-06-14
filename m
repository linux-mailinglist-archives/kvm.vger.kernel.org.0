Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFB3745E0F
	for <lists+kvm@lfdr.de>; Fri, 14 Jun 2019 15:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728125AbfFNNYl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jun 2019 09:24:41 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49924 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727954AbfFNNYi (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 14 Jun 2019 09:24:38 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5EDNcDk068344
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 09:24:38 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2t4bv51suk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 14 Jun 2019 09:24:38 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <akrowiak@linux.ibm.com>;
        Fri, 14 Jun 2019 14:24:37 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 14 Jun 2019 14:24:34 +0100
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5EDOWw835651992
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 14 Jun 2019 13:24:33 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DFB596E053;
        Fri, 14 Jun 2019 13:24:32 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E0BA96E04E;
        Fri, 14 Jun 2019 13:24:31 +0000 (GMT)
Received: from [9.80.235.40] (unknown [9.80.235.40])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 14 Jun 2019 13:24:31 +0000 (GMT)
Subject: Re: [PATCH RFC 1/1] allow to specify additional config data
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>, kvm@vger.kernel.org,
        libvir-list@redhat.com, Matthew Rosato <mjrosato@linux.ibm.com>,
        Halil Pasic <pasic@linux.ibm.com>
References: <20190606144417.1824-1-cohuck@redhat.com>
 <20190606144417.1824-2-cohuck@redhat.com> <20190606093224.3ecb92c7@x1.home>
 <20190606101552.6fc62bef@x1.home>
 <ed75a4de-da0b-f6cf-6164-44cebc82c3a5@linux.ibm.com>
 <20190607140344.0399b766@x1.home>
 <1d859c27-31e2-64ca-f505-19abe9bffed2@linux.ibm.com>
 <20190613161849.070cbc3c.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Date:   Fri, 14 Jun 2019 09:24:30 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <20190613161849.070cbc3c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19061413-0016-0000-0000-000009C27157
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011260; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01217854; UDB=6.00640455; IPR=6.00998976;
 MB=3.00027308; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-14 13:24:35
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19061413-0017-0000-0000-000043A6547D
Message-Id: <b475fc4a-2007-7e9e-442a-554ea88d0793@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-14_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906140113
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/13/19 10:18 AM, Cornelia Huck wrote:
> On Tue, 11 Jun 2019 10:19:29 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> 
>> On 6/7/19 4:03 PM, Alex Williamson wrote:
>>> On Fri, 7 Jun 2019 14:26:13 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>    
>>>> On 6/6/19 12:15 PM, Alex Williamson wrote:
>>>>> On Thu, 6 Jun 2019 09:32:24 -0600
>>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>>       
>>>>>> On Thu,  6 Jun 2019 16:44:17 +0200
>>>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>>>      
>>>>>>> Add a rough implementation for vfio-ap.
>>>>>>>
>>>>>>> Signed-off-by: Cornelia Huck <cohuck@redhat.com>
>>>>>>> ---
>>>>>>>     mdevctl.libexec | 25 ++++++++++++++++++++++
>>>>>>>     mdevctl.sbin    | 56 ++++++++++++++++++++++++++++++++++++++++++++++++-
>>>>>>>     2 files changed, 80 insertions(+), 1 deletion(-)
>>>>>>>
>>>>>>> diff --git a/mdevctl.libexec b/mdevctl.libexec
>>>>>>> index 804166b5086d..cc0546142924 100755
>>>>>>> --- a/mdevctl.libexec
>>>>>>> +++ b/mdevctl.libexec
>>>>>>> @@ -54,6 +54,19 @@ wait_for_supported_types () {
>>>>>>>         fi
>>>>>>>     }
>>>>>>>     
>>>>>>> +# configure vfio-ap devices <config entry> <matrix attribute>
>>>>>>> +configure_ap_devices() {
>>>>>>> +    list="`echo "${config[$1]}" | sed 's/,/ /'`"
>>>>>>> +    [ -z "$list" ] && return
>>>>>>> +    for a in $list; do
>>>>>>> +        echo "$a" > "$supported_types/${config[mdev_type]}/devices/$uuid/$2"
>>>>>>> +        if [ $? -ne 0 ]; then
>>>>>>> +            echo "Error writing '$a' to '$uuid/$2'" >&2
>>>>>>> +            exit 1
>>>>>>> +        fi
>>>>>>> +    done
>>>>>>> +}
>>>>>>> +
>>>>>>>     case ${1} in
>>>>>>>         start-mdev|stop-mdev)
>>>>>>>             if [ $# -ne 2 ]; then
>>>>>>> @@ -148,6 +161,18 @@ case ${cmd} in
>>>>>>>                 echo "Error creating mdev type ${config[mdev_type]} on $parent" >&2
>>>>>>>                 exit 1
>>>>>>>             fi
>>>>>>> +
>>>>>>> +        # some types may specify additional config data
>>>>>>> +        case ${config[mdev_type]} in
>>>>>>> +            vfio_ap-passthrough)
>>>>>>
>>>>>> I think this could have some application beyond ap too, I know NVIDIA
>>>>>> GRID vGPUs do have some controls under the vendor hierarchy of the
>>>>>> device, ex. setting the frame rate limiter.  The implementation here is
>>>>>> a bit rigid, we know a specific protocol for a specific mdev type, but
>>>>>> for supporting arbitrary vendor options we'd really just want to try to
>>>>>> apply whatever options are provided.  If we didn't care about ordering,
>>>>>> we could just look for keys for every file in the device's immediate
>>>>>> sysfs hierarchy and apply any value we find, independent of the
>>>>>> mdev_type, ex. intel_vgpu/foo=bar  Thanks,
>>>>>
>>>>> For example:
>>>>>
>>>>> for key in find -P $mdev_base/$uuid/ \( -path
>>>>> "$mdev_base/$uuid/power/*" -o -path $mdev_base/$uuid/uevent -o -path $mdev_base/$uuid/remove \) -prune -o -type f -print | sed -e "s|$mdev_base/$uuid/||g"); do
>>>>>      [ -z ${config[$key]} ] && continue
>>>>>      ... parse value(s) and iteratively apply to key
>>>>> done
>>>>>
>>>>> The find is a little ugly to exclude stuff, maybe we just let people do
>>>>> screwy stuff like specify remove=1 in their config.  Also need to think
>>>>> about whether we're imposing a delimiter to apply multiple values to a
>>>>> key that conflicts with the attribute usage.  Thanks,
>>>>>
>>>>> Alex
> 
> One thing that this does is limiting us to things that can be expressed
> with "if you encounter key=value, take value (possibly decomposed) and
> write it to <device>/key". A problem with this generic approach is that
> the code cannot decide itself whether value should be decomposed (and
> if yes, with which delimiter), or not. We also cannot cover any
> configuration that does not fit this pattern; so I think we need both
> generic (for flexibility, and easy extensibility), and explicitly
> defined options to cover more complex cases.
> 
> [As an aside, how should we deal with duplicate key= entries? Not
> allowed, last one wins, or all are written to the sysfs attribute?]
> 
>>>>
>>>> I like the idea of looking for files in the device's immediate sysfs
>>>> hierarchy, but maybe the find could exclude attributes that are
>>>> not vendor defined.
>>>
>>> How would we know what attributes are vendor defined?  The above `find`
>>> strips out the power, uevent, and remove attributes, which for GVT-g
>>> leaves only the vendor defined attributes[1], but I don't know how to
>>> instead do a positive match of the vendor attributes without
>>> unmaintainable lookup tables.  This starts to get into the question of
>>> how much do we want to (or need to) protect the user from themselves.
>>> If we let the user specify a key=value of remove=1 and the device
>>> immediately disappears, is that a bug or a feature?  Thanks,
>>>
>>> Alex
>>
>> By vendor defined, I meant attributes that are not defined by the mdev
>> framework, such as the 'remove' attribute.
> 
> And those defined by the base driver core like uevent, I guess.

Yes

> 
>> As far as whether allowing
>> specification of remove-1, I'd have to play with that and see what all
>> of the ramifications are.
> 
> It does feel a bit odd to me (why would you configure it if you
> immediately want to remove it again?)

This was in response to Alex's comment. My personal preference is to
exclude attributes that are not vendor created, at least to the
extent it is possible to determine such.

> 
>>
>> Tony K
>>
>>>
>>> [1] GVT-g doesn't actually have an writable attributes, so we'd also
>>> minimally want to add a test to skip read-only attributes.
>>
>> Probably a good idea.
> 
> Agreed.
> 

