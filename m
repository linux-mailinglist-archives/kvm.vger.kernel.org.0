Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B49243F1F
	for <lists+kvm@lfdr.de>; Thu, 13 Aug 2020 21:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgHMTD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Aug 2020 15:03:29 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726167AbgHMTD3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 13 Aug 2020 15:03:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07DJ1bbr032123;
        Thu, 13 Aug 2020 15:03:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=zankwXPh1JSZGLL5iEapdJBtpkCZ9JrA9lMunhM68I0=;
 b=TaqkUdkTypixJCNiKX24PKa/4JpJopl1sCntLK7z2+ngrhLw+vlm80qV1jliRbeWEeXO
 EI9oT6+rGWhsEWhGx7Km7Rwi6SpRy3ntbTc0PHhpCIlcqyTluJAVGOJHD5Mkwlqo+5fW
 ArPc7xENyfxviXpm3HMYnJJTKHT6ZgSq8ajEqKV19fAyodEusc5YJ+BdxSi+1e9ytEP3
 tCAoXsb5JL7oJN5Wqh1JagjS+fivd7LQPWQRTPFQ3o+OV0EwBHcyUM+tXsj3GnHvAxhi
 hCaDT/7pAGmjFiBgQZlUi5nXleRwTnXyy9q/LFSQiMIrd4H8QWg4OiCl4rBjEedOIhNA 4Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n0wft1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 15:03:03 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07DJ1kv8032915;
        Thu, 13 Aug 2020 15:03:02 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com with ESMTP id 32w0n0wfrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 15:03:02 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07DIxJwt017964;
        Thu, 13 Aug 2020 19:03:00 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma02dal.us.ibm.com with ESMTP id 32skp9yf39-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 13 Aug 2020 19:03:00 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07DJ2vNp53084462
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 Aug 2020 19:02:57 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 975FC136059;
        Thu, 13 Aug 2020 19:02:59 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 67F14136051;
        Thu, 13 Aug 2020 19:02:54 +0000 (GMT)
Received: from [9.65.204.197] (unknown [9.65.204.197])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 13 Aug 2020 19:02:54 +0000 (GMT)
Subject: Re: device compatibility interface for live migration with assigned
 devices
To:     Cornelia Huck <cohuck@redhat.com>, Sean Mooney <smooney@redhat.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, Yan Zhao <yan.y.zhao@intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        kvm@vger.kernel.org, libvir-list@redhat.com, qemu-devel@nongnu.org,
        kwankhede@nvidia.com, eauger@redhat.com, xin-ran.wang@intel.com,
        corbet@lwn.net, openstack-discuss@lists.openstack.org,
        shaohe.feng@intel.com, kevin.tian@intel.com, eskultet@redhat.com,
        jian-feng.ding@intel.com, dgilbert@redhat.com,
        zhenyuw@linux.intel.com, hejie.xu@intel.com, bao.yumeng@zte.com.cn,
        intel-gvt-dev@lists.freedesktop.org, berrange@redhat.com,
        dinechin@redhat.com, devel@ovirt.org,
        Parav Pandit <parav@mellanox.com>
References: <20200727072440.GA28676@joy-OptiPlex-7040>
 <20200727162321.7097070e@x1.home> <20200729080503.GB28676@joy-OptiPlex-7040>
 <20200804183503.39f56516.cohuck@redhat.com>
 <c178a0d3-269d-1620-22b1-9010f602d8ff@redhat.com>
 <20200805021654.GB30485@joy-OptiPlex-7040>
 <2624b12f-3788-7e2b-2cb7-93534960bcb7@redhat.com>
 <20200805075647.GB2177@nanopsycho>
 <eb1d01c2-fbad-36b6-10cf-9e03483a736b@redhat.com>
 <20200805093338.GC30485@joy-OptiPlex-7040> <20200805105319.GF2177@nanopsycho>
 <4cf2824c803c96496e846c5b06767db305e9fb5a.camel@redhat.com>
 <20200807135942.5d56a202.cohuck@redhat.com>
 <20200813173347.239801fa.cohuck@redhat.com>
From:   Eric Farman <farman@linux.ibm.com>
Autocrypt: addr=farman@linux.ibm.com; keydata=
 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
Message-ID: <315669b0-5c75-d359-a912-62ebab496abf@linux.ibm.com>
Date:   Thu, 13 Aug 2020 15:02:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200813173347.239801fa.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-13_15:2020-08-13,2020-08-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 clxscore=1011 malwarescore=0 impostorscore=0
 adultscore=0 suspectscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008130131
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/13/20 11:33 AM, Cornelia Huck wrote:
> On Fri, 7 Aug 2020 13:59:42 +0200
> Cornelia Huck <cohuck@redhat.com> wrote:
> 
>> On Wed, 05 Aug 2020 12:35:01 +0100
>> Sean Mooney <smooney@redhat.com> wrote:
>>
>>> On Wed, 2020-08-05 at 12:53 +0200, Jiri Pirko wrote:  
>>>> Wed, Aug 05, 2020 at 11:33:38AM CEST, yan.y.zhao@intel.com wrote:    
>>
>> (...)
>>
>>>>>    software_version: device driver's version.
>>>>>               in <major>.<minor>[.bugfix] scheme, where there is no
>>>>> 	       compatibility across major versions, minor versions have
>>>>> 	       forward compatibility (ex. 1-> 2 is ok, 2 -> 1 is not) and
>>>>> 	       bugfix version number indicates some degree of internal
>>>>> 	       improvement that is not visible to the user in terms of
>>>>> 	       features or compatibility,
>>>>>
>>>>> vendor specific attributes: each vendor may define different attributes
>>>>>   device id : device id of a physical devices or mdev's parent pci device.
>>>>>               it could be equal to pci id for pci devices
>>>>>   aggregator: used together with mdev_type. e.g. aggregator=2 together
>>>>>               with i915-GVTg_V5_4 means 2*1/4=1/2 of a gen9 Intel
>>>>> 	       graphics device.
>>>>>   remote_url: for a local NVMe VF, it may be configured with a remote
>>>>>               url of a remote storage and all data is stored in the
>>>>> 	       remote side specified by the remote url.
>>>>>   ...    
>>> just a minor not that i find ^ much more simmple to understand then
>>> the current proposal with self and compatiable.
>>> if i have well defiend attibute that i can parse and understand that allow
>>> me to calulate the what is and is not compatible that is likely going to
>>> more useful as you wont have to keep maintianing a list of other compatible
>>> devices every time a new sku is released.
>>>
>>> in anycase thank for actully shareing ^ as it make it simpler to reson about what
>>> you have previously proposed.  
>>
>> So, what would be the most helpful format? A 'software_version' field
>> that follows the conventions outlined above, and other (possibly
>> optional) fields that have to match?
> 
> Just to get a different perspective, I've been trying to come up with
> what would be useful for a very different kind of device, namely
> vfio-ccw. (Adding Eric to cc: for that.)
> 
> software_version makes sense for everybody, so it should be a standard
> attribute.
> 
> For the vfio-ccw type, we have only one vendor driver (vfio-ccw_IO).
> 
> Given a subchannel A, we want to make sure that subchannel B has a
> reasonable chance of being compatible. I guess that means:
> 
> - same subchannel type (I/O)
> - same chpid type (e.g. all FICON; I assume there are no 'mixed' setups
>   -- Eric?)

Correct.

> - same number of chpids? Maybe we can live without that and just inject
>   some machine checks, I don't know. Same chpid numbers is something we
>   cannot guarantee, especially if we want to migrate cross-CEC (to
>   another machine.)

I think we'd live without it, because I wouldn't expect it to be
consistent between systems.

> 
> Other possibly interesting information is not available at the
> subchannel level (vfio-ccw is a subchannel driver.)

I presume you're alluding to the DASD uid (dasdinfo -x) here?

> 
> So, looking at a concrete subchannel on one of my machines, it would
> look something like the following:
> 
> <common>
> software_version=1.0.0
> type=vfio-ccw          <-- would be vfio-pci on the example above
> <vfio-ccw specific>
> subchannel_type=0
> <vfio-ccw_IO specific>
> chpid_type=0x1a
> chpid_mask=0xf0        <-- not sure if needed/wanted
> 
> Does that make sense?
> 
