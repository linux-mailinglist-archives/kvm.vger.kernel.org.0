Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C416425471F
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 16:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgH0OkM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 10:40:12 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55394 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727069AbgH0OjS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 27 Aug 2020 10:39:18 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07REVoip105513;
        Thu, 27 Aug 2020 10:39:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=PzL6mYYNBm+qLHeyq/Oz7P9vWfJmgDGHbFFmFFeAyRY=;
 b=mwsr91MZ3/eX+5NrLpQHOzb57NkvbpZ8YcNPyV+nvqmLlKNyZMxSnBo5G/S3e5FYOodu
 SauZQrlWJeUsQor0u7sKe+W+zZjAEXZp06aR9JCGo8HUeJMUY51Dv4DnIWb2QptZ8co3
 qJCFnslBvVkH/rx1Dm2jafj1S2+QGoFOWLr7cl7Ob6TmqNfb96szFjjeE9TGNYoktqNz
 q5EibKahYbYPr/xRqkhZFA5rps7Sqj3SAxmYQLO/qY/XX0ewBnoQASQSdCnSqUPnzK13
 EoGUSHVC+ELz2RplGZCzhf/MFUzls0RTiPutuJ1Tk371CjC+Hs+Aq9uXvxaqMtP8x5pJ 3A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 336dmp2px7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 10:39:13 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 07REWCeC107818;
        Thu, 27 Aug 2020 10:39:13 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 336dmp2pwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 10:39:13 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07REbKuI022484;
        Thu, 27 Aug 2020 14:39:12 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 332uwatpbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Aug 2020 14:39:12 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07REd4xN41484600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Aug 2020 14:39:04 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7726BBE04F;
        Thu, 27 Aug 2020 14:39:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 32676BE056;
        Thu, 27 Aug 2020 14:39:08 +0000 (GMT)
Received: from cpe-172-100-175-116.stny.res.rr.com (unknown [9.85.170.64])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 27 Aug 2020 14:39:07 +0000 (GMT)
Subject: Re: [PATCH v10 01/16] s390/vfio-ap: add version vfio_ap module
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com
References: <20200821195616.13554-1-akrowiak@linux.ibm.com>
 <20200821195616.13554-2-akrowiak@linux.ibm.com>
 <20200825120432.13a1b444.cohuck@redhat.com>
 <ca016eca-1ee7-2d0f-c2ec-3ef147b6216a@linux.ibm.com>
 <20200827123240.42e0c787.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <8b3eb14e-c388-3025-1bfb-2dc7fb820de3@linux.ibm.com>
Date:   Thu, 27 Aug 2020 10:39:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200827123240.42e0c787.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-27_07:2020-08-27,2020-08-27 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 impostorscore=0 lowpriorityscore=0 suspectscore=3
 adultscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008270107
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 8/27/20 6:32 AM, Cornelia Huck wrote:
> On Wed, 26 Aug 2020 10:49:47 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 8/25/20 6:04 AM, Cornelia Huck wrote:
>>> On Fri, 21 Aug 2020 15:56:01 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> Let's set a version for the vfio_ap module so that automated regression
>>>> tests can determine whether dynamic configuration tests can be run or
>>>> not.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_drv.c | 2 ++
>>>>    1 file changed, 2 insertions(+)
>>>>
>>>> diff --git a/drivers/s390/crypto/vfio_ap_drv.c b/drivers/s390/crypto/vfio_ap_drv.c
>>>> index be2520cc010b..f4ceb380dd61 100644
>>>> --- a/drivers/s390/crypto/vfio_ap_drv.c
>>>> +++ b/drivers/s390/crypto/vfio_ap_drv.c
>>>> @@ -17,10 +17,12 @@
>>>>    
>>>>    #define VFIO_AP_ROOT_NAME "vfio_ap"
>>>>    #define VFIO_AP_DEV_NAME "matrix"
>>>> +#define VFIO_AP_MODULE_VERSION "1.2.0"
>>>>    
>>>>    MODULE_AUTHOR("IBM Corporation");
>>>>    MODULE_DESCRIPTION("VFIO AP device driver, Copyright IBM Corp. 2018");
>>>>    MODULE_LICENSE("GPL v2");
>>>> +MODULE_VERSION(VFIO_AP_MODULE_VERSION);
>>>>    
>>>>    static struct ap_driver vfio_ap_drv;
>>>>      
>>> Setting a version manually has some drawbacks:
>>> - tools wanting to check for capabilities need to keep track which
>>>     versions support which features
>>> - you need to remember to actually bump the version when adding a new,
>>>     visible feature
>>> (- selective downstream backports may get into a pickle, but that's
>>> arguably not your problem)
>>>
>>> Is there no way for a tool to figure out whether this is supported?
>>> E.g., via existence of a sysfs file, or via a known error that will
>>> occur. If not, it's maybe better to expose known capabilities via a
>>> generic interface.
>> This patch series introduces a new mediated device sysfs attribute,
>> guest_matrix, so the automated tests could check for the existence
>> of that interface. The problem I have with that is it will work for
>> this version of the vfio_ap device driver - which may be all that is
>> ever needed - but does not account for future enhancements
>> which may need to be detected by tooling or automated tests.
>> It seems to me that regardless of how a tool detects whether
>> a feature is supported or not, it will have to keep track of that
>> somehow.
> Which enhancements? If you change the interface in an incompatible way,
> you have a different problem anyway. If someone trying to use the
> enhanced version of the interface gets an error on a kernel providing
> an older version of the interface, that's a reasonable way to discover
> support.
>
> I think "discover device driver capabilities by probing" is less
> burdensome and error prone than trying to match up capabilities with a
> version number. If you expose a version number, a tool would still have
> to probe that version number, and then consult with a list of features
> per version, which can easily go out of sync.
>
>> Can you provide more details about this generic interface of
>> which you speak?
> If that is really needed, I'd probably do a driver sysfs attribute that
> exposes a list of documented capabilities (as integer values, or as a
> bit.) But since tools can simply check for guest_matrix to find out
> about support for this feature here, it seems like overkill to me --
> unless you have a multitude of features waiting in queue that need to
> be made discoverable.

Currently there are two tools that probably need to be aware of
the changes to these assignment interfaces:
* The hades test framework has tests that will fail if run against
    these patches that should be skipped if over-provisioning is
    allowed. There are also tests under development to test the
    function introduced by these patches that will fail if run against
    an older version of the driver. These tests should be skipped in
    that case.
* There is a tool under development for configuring AP matrix
    mediated devices that probably need to be aware of the change
    introduced by this series.

Since a tool would have to first determine whether a new sysfs
interface documenting facilities is available and it would only
expose one facility at this point, it seems reasonable for these tools
to check for the sysfs guest_matrix attribute to discern whether
over-provisioning is available or not. I'll go ahead and remove this
patch from the series.

>

