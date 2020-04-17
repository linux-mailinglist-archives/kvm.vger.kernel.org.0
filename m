Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 277351ADEC9
	for <lists+kvm@lfdr.de>; Fri, 17 Apr 2020 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgDQNyZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Apr 2020 09:54:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:5888 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730731AbgDQNyZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 17 Apr 2020 09:54:25 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03HDYk3N023289
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 09:54:24 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0b-001b2d01.pphosted.com with ESMTP id 30fcsyj2mk-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 17 Apr 2020 09:54:24 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <freude@linux.ibm.com>;
        Fri, 17 Apr 2020 14:53:43 +0100
Received: from b06cxnps4076.portsmouth.uk.ibm.com (9.149.109.198)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 17 Apr 2020 14:53:40 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 03HDsGn148889986
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Apr 2020 13:54:16 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 947EF4203F;
        Fri, 17 Apr 2020 13:54:16 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C39DF42042;
        Fri, 17 Apr 2020 13:54:15 +0000 (GMT)
Received: from funtu.home (unknown [9.171.23.248])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 17 Apr 2020 13:54:15 +0000 (GMT)
Subject: Re: [PATCH v7 03/15] s390/zcrypt: driver callback to indicate
 resource in use
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     Tony Krowiak <akrowiak@linux.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        borntraeger@de.ibm.com, mjrosato@linux.ibm.com,
        pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-4-akrowiak@linux.ibm.com>
 <20200414145851.562867ae.cohuck@redhat.com>
 <82675d5c-4901-cbd8-9287-79133aa3ee68@linux.ibm.com>
 <20200416113356.28fcef8c.cohuck@redhat.com>
From:   Harald Freudenberger <freude@linux.ibm.com>
Date:   Fri, 17 Apr 2020 15:54:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200416113356.28fcef8c.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 20041713-4275-0000-0000-000003C18CFB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20041713-4276-0000-0000-000038D70A5B
Message-Id: <c0e3cca2-8683-7034-3b41-cd04fcdfa2ce@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-17_03:2020-04-17,2020-04-17 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxscore=0 phishscore=0 priorityscore=1501 clxscore=1015
 adultscore=0 lowpriorityscore=0 impostorscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004170105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16.04.20 11:33, Cornelia Huck wrote:
> On Wed, 15 Apr 2020 08:08:24 +0200
> Harald Freudenberger <freude@linux.ibm.com> wrote:
>
>> On 14.04.20 14:58, Cornelia Huck wrote:
>>> On Tue,  7 Apr 2020 15:20:03 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>> +	/* The non-default driver's module must be loaded */
>>>> +	if (!try_module_get(drv->owner))
>>>> +		return 0;  
>>> Is that really needed? I would have thought that the driver core's
>>> klist usage would make sure that the callback would not be invoked for
>>> drivers that are not registered anymore. Or am I missing a window?  
>> The try_module_get() and module_put() is a result of review feedback from
>> my side. The ap bus core is static in the kernel whereas the
>> vfio dd is a kernel module. So there may be a race condition between
>> calling the callback function and removal of the vfio dd module.
>> There is similar code in zcrypt_api which does the same for the zcrypt
>> device drivers before using some variables or functions from the modules.
>> Help me, it this is outdated code and there is no need to adjust the
>> module reference counter any more, then I would be happy to remove
>> this code :-)
> I think the driver core already should keep us safe. A built-in bus
> calling a driver in a module is a very common pattern, and I think
> ->owner was introduced exactly for that case.
>
> Unless I'm really missing something obvious?
Hm. I tested a similar code (see zcrypt_api.c where try_module_get() and module_put()
is called surrounding use of functions related to the implementing driver.
The driver module has a reference count of 0 when not used and can get removed
- because refcount is 0 - at any time when there is nothing related to the driver pending.

As soon as the driver is actually used the try_module_get(...driver.owner) increases
the reference counter and makes it impossible to remove the module. After use the
module_put() reduces the reference count.
When I now remove the try_module_get() and module_put() calls and run this modified
code I immediately face a crash when the module is removed during use.

I see code in the kernel which does an initial try_module_get() on the driver to increase
the reference count, for example when the driver registers. However, I see no clear
way to remove such a driver module any more.

I know I had a fight with a tester some years ago where he stated that it is a valid
testcase to remove a device driver module 'during use of the driver'. So I'd like
to have the try_module_get() and module_put() invokations in the ap bus code
until you convince me there are other maybe better ways to make sure the
driver and it's functions are available at the time of the call.

Maybe we can discuss this offline if you wish :-)

