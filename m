Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1095E586C9
	for <lists+kvm@lfdr.de>; Thu, 27 Jun 2019 18:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfF0QOR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jun 2019 12:14:17 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726487AbfF0QOQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Jun 2019 12:14:16 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5RGDW2i056242;
        Thu, 27 Jun 2019 12:13:40 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2td0jh9qnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 12:13:38 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x5RGA16K015831;
        Thu, 27 Jun 2019 16:13:03 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma01wdc.us.ibm.com with ESMTP id 2t9by77fs0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 16:13:03 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5RGD3LQ13173718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jun 2019 16:13:03 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0599D112069;
        Thu, 27 Jun 2019 16:13:03 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B730D112064;
        Thu, 27 Jun 2019 16:13:02 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.60.84.198])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jun 2019 16:13:02 +0000 (GMT)
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Cornelia Huck <cohuck@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Libvirt Devel <libvir-list@redhat.com>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Erik Skultety <eskultet@redhat.com>,
        Pavel Hrdina <phrdina@redhat.com>,
        =?UTF-8?Q?Daniel_P=2e_Berrang=c3=a9?= <berrange@redhat.com>,
        Sylvain Bauza <sbauza@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Tony Krowiak <akrowiak@linux.ibm.com>
References: <20190523172001.41f386d8@x1.home>
 <20190625165251.609f6266@x1.home> <20190626115806.3435c45c.cohuck@redhat.com>
 <20190626083720.42a2b5d4@x1.home> <20190626195350.2e9c81d3@x1.home>
 <20190627142626.415138da.cohuck@redhat.com>
 <06114b39-69c2-3fa0-d0b3-aa96a44ae2ce@linux.ibm.com>
 <20190627093832.064a346f@x1.home>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <6fc477e0-c9ff-321b-e2dd-f0cc4b701b13@linux.ibm.com>
Date:   Thu, 27 Jun 2019 12:13:02 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190627093832.064a346f@x1.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-27_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906270185
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/27/19 11:38 AM, Alex Williamson wrote:
> On Thu, 27 Jun 2019 11:00:31 -0400
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> On 6/27/19 8:26 AM, Cornelia Huck wrote:
>>> On Wed, 26 Jun 2019 19:53:50 -0600
>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>   
>>>> On Wed, 26 Jun 2019 08:37:20 -0600
>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>  
>>>>> On Wed, 26 Jun 2019 11:58:06 +0200
>>>>> Cornelia Huck <cohuck@redhat.com> wrote:
>>>>>     
>>>>>> On Tue, 25 Jun 2019 16:52:51 -0600
>>>>>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>>>>>       
>>>>>>> Hi,
>>>>>>>
>>>>>>> Based on the discussions we've had, I've rewritten the bulk of
>>>>>>> mdevctl.  I think it largely does everything we want now, modulo
>>>>>>> devices that will need some sort of 1:N values per key for
>>>>>>> configuration in the config file versus the 1:1 key:value setup we
>>>>>>> currently have (so don't consider the format final just yet).        
>>>>>>
>>>>>> We might want to factor out that config format handling while we're
>>>>>> trying to finalize it.
>>>>>>
>>>>>> cc:ing Matt for his awareness. I'm currently not quite sure how to
>>>>>> handle those vfio-ap "write several values to an attribute one at a
>>>>>> time" requirements. Maybe 1:N key:value is the way to go; maybe we
>>>>>> need/want JSON or something like that.      
>>>>>
>>>>> Maybe we should just do JSON for future flexibility.  I assume there
>>>>> are lots of helpers that should make it easy even from a bash script.
>>>>> I'll look at that next.    
>>>>
>>>> Done.  Throw away any old mdev config files, we use JSON now.   
>>>
>>> The code changes look quite straightforward, thanks.
>>>   
>>>> The per
>>>> mdev config now looks like this:
>>>>
>>>> {
>>>>   "mdev_type": "i915-GVTg_V4_8",
>>>>   "start": "auto"
>>>> }
>>>>
>>>> My expectation, and what I've already pre-enabled support in set_key
>>>> and get_key functions, is that we'd use arrays for values, so we might
>>>> have:
>>>>
>>>>   "new_key": ["value1", "value2"]
>>>>
>>>> set_key will automatically convert a comma separated list of values
>>>> into such an array, so I'm thinking this would be specified by the user
>>>> as:
>>>>
>>>> # mdevctl modify -u UUID --key=new_key --value=value1,value2  
>>>
>>> Looks sensible.
>>>
>>> For vfio-ap, we'd probably end up with something like the following:
>>>
>>> {
>>>   "mdev_type": "vfio_ap-passthrough",
>>>   "start": "auto",
>>>   "assign_adapter": ["5", "6"],
>>>   "assign_domain": ["4", "0xab"]
>>> }
>>>
>>> (following the Guest1 example in the kernel documentation)
>>>
>>> <As an aside, what should happen if e.g "assign_adapter" is set to
>>> ["6", "7"]? Remove 5, add 7? Remove all values, then set the new ones?  
>>
>> IMO remove 5, add 7 would make the most sense.  I'm not sure that doing
>> an unassign of all adapters (effectively removing all APQNs) followed by
>> an assign of the new ones would work nicely with Tony's vfio-ap dynamic
>> configuration patches.
> 
> Are we conflating operating on the config file versus operating on the
> device?  I was thinking that setting a new key value replaces the
> existing key, because anything else adds unnecessary complication to
> the code and command line.  So in the above example, if the user
> specified:
> 
>   mdevctl modify -u UUID --key=assign_adapter --value=6,7
> 
> The new value is simply ["6", "7"].  This would take effect the next
> time the device is started.  We haven't yet considered how to change
> running devices, but I think the semantics we have since the respin of
> mdevctl separate saved config vs running devices in order to generalize
> the support of transient devices.

Yeah, my comment was aimed specifically at changes to a running device.
 When considering only the config file I agree: the new key value can
just replace the existing key value.
