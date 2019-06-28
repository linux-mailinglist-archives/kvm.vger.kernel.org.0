Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4541F59D6E
	for <lists+kvm@lfdr.de>; Fri, 28 Jun 2019 16:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726722AbfF1OBP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jun 2019 10:01:15 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50628 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726616AbfF1OBO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 28 Jun 2019 10:01:14 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5SDveVL093538
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 10:01:13 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tdhndf3qj-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 28 Jun 2019 10:01:13 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <mjrosato@linux.ibm.com>;
        Fri, 28 Jun 2019 15:01:12 +0100
Received: from b03cxnp08027.gho.boulder.ibm.com (9.17.130.19)
        by e33.co.us.ibm.com (192.168.1.133) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 28 Jun 2019 15:01:09 +0100
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x5SE17T050790876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 28 Jun 2019 14:01:07 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 797B6C606D;
        Fri, 28 Jun 2019 14:01:07 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6468EC6063;
        Fri, 28 Jun 2019 14:01:05 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.80.239.94])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 28 Jun 2019 14:01:05 +0000 (GMT)
Subject: Re: mdevctl: A shoestring mediated device management and persistence
 utility
To:     Cornelia Huck <cohuck@redhat.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
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
 <20190627093832.064a346f@x1.home> <20190627151502.2ae5314f@x1.home>
 <20190627195704.66be88c8@x1.home> <20190628110648.40e0607d.cohuck@redhat.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Date:   Fri, 28 Jun 2019 10:01:05 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190628110648.40e0607d.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19062814-0036-0000-0000-00000AD1ACC3
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00011346; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000286; SDB=6.01224501; UDB=6.00644488; IPR=6.01005693;
 MB=3.00027507; MTD=3.00000008; XFM=3.00000015; UTC=2019-06-28 14:01:12
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19062814-0037-0000-0000-00004C64D6EB
Message-Id: <4df06b68-4977-7285-c598-11e582ceb7d5@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-28_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906280165
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/28/19 5:06 AM, Cornelia Huck wrote:
> On Thu, 27 Jun 2019 19:57:04 -0600
> Alex Williamson <alex.williamson@redhat.com> wrote:
> 
>> On Thu, 27 Jun 2019 15:15:02 -0600
>> Alex Williamson <alex.williamson@redhat.com> wrote:
>>
>>> On Thu, 27 Jun 2019 09:38:32 -0600
>>> Alex Williamson <alex.williamson@redhat.com> wrote:  
>>>>> On 6/27/19 8:26 AM, Cornelia Huck wrote:      
>>>>>>
>>>>>> {
>>>>>>   "foo": "1",
>>>>>>   "bar": "42",
>>>>>>   "baz": {
>>>>>>     "depends": ["foo", "bar"],
>>>>>>     "value": "plahh"
>>>>>>   }
>>>>>> }
>>>>>>
>>>>>> Something like that?      
>>>>
>>>> I'm not sure yet.  I think we need to look at what's feasible (and
>>>> easy) with jq.  Thanks,    
>>>
>>> I think it's not too much trouble to remove and insert into arrays, so
>>> what if we were to define the config as:
>>>
>>> {
>>>   "mdev_type":"vendor-type",
>>>   "start":"auto",
>>>   "attrs": [
>>>       {"attrX":["Xvalue1","Xvalue2"]},
>>>       {"dir/attrY": "Yvalue1"},
>>>       {"attrX": "Xvalue3"}
>>>     ]
>>> }
>>>
>>> "attr" here would define sysfs attributes under the device.  The array
>>> would be processed in order, so in the above example we'd do the
>>> following:
>>>
>>>  1. echo Xvalue1 > attrX
>>>  2. echo Xvalue2 > attrX
>>>  3. echo Yvalue1 > dir/attrY
>>>  4. echo Xvalue3 > attrX
>>>
>>> When starting the device mdevctl would simply walk the array, if the
>>> attribute key exists write the value(s).  If a write fails or the
>>> attribute doesn't exist, remove the device and report error.
> 
> Yes, I think it makes sense to fail the startup of a device where we
> cannot set all attributes to the requested values.
> 
>>>
>>> I think it's easiest with jq to manipulate arrays by removing and
>>> inserting by index.  Also if we end up with something like above, it's
>>> ambiguous if we reference the "attrX" key.  So perhaps we add the
>>> following options to the modify command:
>>>
>>> --addattr=ATTRIBUTE --delattr --index=INDEX --value=VALUE1[,VALUE2]
>>>
>>> We could handle it like a stack, so if --index is not supplied, add to
>>> the end or remove from the end.  If --index is provided, delete that
>>> index or add the attribute at that index.  So if you had the above and
>>> wanted to remove Xvalue1 but keep the ordering, you'd do:
>>>
>>> --delattr --index=0
>>> --addattr --index=0 --value=Xvalue2
>>>
>>> Which should results in:
>>>
>>>   "attrs": [
>>>       {"attrX": "Xvalue2"},
>>>       {"dir/attrY": "Yvalue1"},
>>>       {"attrX": "Xvalue3"}
>>>     ]
> 
> Modifying by index looks reasonable; I just sent a pull request to
> print the index of an attribute out as well, so it is easier to specify
> the right attribute to modify.
> 
>>>
>>> If we want to modify a running device, I'm thinking we probably want a
>>> new command and options --attr=ATTRIBUTE --value=VALUE might suffice.
>>>
>>> Do we need to support something like this for the 'start' command or
>>> should we leave that for simple devices and require a sequence of:
>>>
>>> # mdevctl define ...
>>> # mdevctl modify --addattr...
>>> ...
>>> # mdevctl start
>>> # mdevctl undefine
>>>
>>> This is effectively the long way to get a transient device.  Otherwise
>>> we'd need to figure out how to have --attr --value appear multiple
>>> times on the start command line.  Thanks,  
> 
> What do you think of a way to specify JSON for the attributes directly
> on the command line? Or would it be better to just edit the config
> files directly?
> 
>>
>> This is now implemented, and yes you can specify '--addattr remove
>> --value 1' and mdevctl will immediately remove the device after it's
>> created (more power to the admin).  Listing defined devices also lists
> 
> Fun ;)
> 
>> any attributes defined for easy inspection.  It is also possible to
>> override the conversion of comma separated values into an array by
>> encoding and escaping the comma.  It's a little cumbersome, but
>> possible in case a driver isn't fully on board with the one attribute,
>> one value rule of sysfs.  Does this work for vfio-ap?  I also still
> 
> I do not have ap devices to actually test this with; but defining a
> device and adding attributes seems to work.
> 

I pulled and did a quick test with vfio-ap, it's working.  I was able to
define, modify with the appropriate attributes and start, resulting in a
correctly-configured device.


