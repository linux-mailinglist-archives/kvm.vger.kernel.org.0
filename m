Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5BEA672065
	for <lists+kvm@lfdr.de>; Wed, 18 Jan 2023 16:01:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjARPA6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Jan 2023 10:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjARPAb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 Jan 2023 10:00:31 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E81B604AB;
        Wed, 18 Jan 2023 06:55:50 -0800 (PST)
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30IDKcQY027120;
        Wed, 18 Jan 2023 14:55:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=/asgtMy/qhWFY2TxHCd85ee3a9Lem+Noi/OHiwyhihU=;
 b=OdH3NOykV8G0o/SZKaiUxLOSFcaNT5x//YXBz32ZNiOA3blUq1AgBdH6vwSEs8zHW+BD
 4kk1YfzfS4M+LF0aXhEf4t1xY00kdiWBgVPMB/elluMSnc7VsC/oXLwiYyROgzBlJpb7
 QgcHERvG/utRVZhIJ1/9hEUAiGlDUyg02XEZF6WA/9jAw+UXBz5c1MknacGlBoxBF8BP
 +gwUYCgPwFFfdCVlyiARmTeGFgcnVhYdCd9eQxc6kjUUJOWGHZc/qYADvQ6rHYrG0wFJ
 dAkycZVl1Sgb3rQ92R5dRDwZB61VQNZoyuN6hxfUHwuPXeR7s/ZbLWtD43opjt/7/bvf qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91wtvx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:55:44 +0000
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 30IE0Tbh022576;
        Wed, 18 Jan 2023 14:55:43 GMT
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0b-001b2d01.pphosted.com (PPS) with ESMTPS id 3n6f91wtvp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:55:43 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 30ICc6Ua005708;
        Wed, 18 Jan 2023 14:55:42 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([9.208.130.99])
        by ppma02dal.us.ibm.com (PPS) with ESMTPS id 3n3m17nrtm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Jan 2023 14:55:42 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
        by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 30IEtfje29622842
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 18 Jan 2023 14:55:41 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2463D58056;
        Wed, 18 Jan 2023 14:55:41 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D2485803F;
        Wed, 18 Jan 2023 14:55:39 +0000 (GMT)
Received: from [9.60.89.243] (unknown [9.60.89.243])
        by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 18 Jan 2023 14:55:39 +0000 (GMT)
Message-ID: <b5a7efc9-7cfa-3314-fe36-b8da4a25265d@linux.ibm.com>
Date:   Wed, 18 Jan 2023 09:55:39 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v4] vfio: fix potential deadlock on vfio group lock
Content-Language: en-US
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>
Cc:     "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>
References: <20230114000351.115444-1-mjrosato@linux.ibm.com>
 <20230117142252.70cc85c7.alex.williamson@redhat.com>
 <BN9PR11MB52763D861C254248FD33F65C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <BN9PR11MB52763D861C254248FD33F65C8CC79@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: TfmjtY4Qpflu2Wdc05rgEibVTFbw_JpY
X-Proofpoint-ORIG-GUID: 1ul9rd7a7oGMvAucLJJS3iFU0CRQHuJl
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.923,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-18_05,2023-01-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 adultscore=0 clxscore=1015 impostorscore=0 malwarescore=0 mlxlogscore=999
 bulkscore=0 spamscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2301180124
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/18/23 4:03 AM, Tian, Kevin wrote:
>> From: Alex Williamson
>> Sent: Wednesday, January 18, 2023 5:23 AM
>>
>> On Fri, 13 Jan 2023 19:03:51 -0500
>> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
>>
>>>  void vfio_device_group_close(struct vfio_device *device)
>>>  {
>>> +	void (*put_kvm)(struct kvm *kvm);
>>> +	struct kvm *kvm;
>>> +
>>>  	mutex_lock(&device->group->group_lock);
>>> +	kvm = device->kvm;
>>> +	put_kvm = device->put_kvm;
>>>  	vfio_device_close(device, device->group->iommufd);
>>> +	if (kvm == device->kvm)
>>> +		kvm = NULL;
>>
>> Hmm, so we're using whether the device->kvm pointer gets cleared in
>> last_close to detect whether we should put the kvm reference.  That's a
>> bit obscure.  Our get and put is also asymmetric.
>>
>> Did we decide that we couldn't do this via a schedule_work() from the
>> last_close function, ie. implementing our own version of an async put?
>> It seems like that potentially has a cleaner implementation, symmetric
>> call points, handling all the storing and clearing of kvm related
>> pointers within the get/put wrappers, passing only a vfio_device to the
>> put wrapper, using the "vfio_device_" prefix for both.  Potentially
>> we'd just want an unconditional flush outside of lock here for
>> deterministic release.
>>
>> What's the downside?  Thanks,
>>
> 
> btw I guess this can be also fixed by Yi's work here:
> 
> https://lore.kernel.org/kvm/20230117134942.101112-6-yi.l.liu@intel.com/
> 
> with set_kvm(NULL) moved to the release callback of kvm_vfio device,
> such circular lock dependency can be avoided too.

Oh, interesting...  It seems to me that this would eliminate the reported call chain altogether:

kvm_put_kvm
 -> kvm_destroy_vm
  -> kvm_destroy_devices
   -> kvm_vfio_destroy (starting here -- this would no longer be executed)
    -> kvm_vfio_file_set_kvm
     -> vfio_file_set_kvm
      -> group->group_lock/group_rwsem

because kvm_destroy_devices now can't end up calling kvm_vfio_destroy and friends, it won't try and acquire the group lock a 2nd time making a kvm_put_kvm while the group lock is held OK to do.  The vfio_file_set_kvm call will now always come from a separate thread of execution, kvm_vfio_group_add, kvm_vfio_group_del or the release thread:

kvm_device_release (where the group->group_lock would not be held since vfio does not trigger closing of the kvm fd)
 -> kvm_vfio_destroy (or, kvm_vfio_release)
  -> kvm_vfio_file_set_kvm
   -> vfio_file_set_kvm
    -> group->group_lock/group_rwsem
