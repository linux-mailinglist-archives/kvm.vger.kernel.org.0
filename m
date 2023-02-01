Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68629686842
	for <lists+kvm@lfdr.de>; Wed,  1 Feb 2023 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232389AbjBAO2F (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 1 Feb 2023 09:28:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbjBAO17 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 1 Feb 2023 09:27:59 -0500
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94A4B3C31;
        Wed,  1 Feb 2023 06:27:57 -0800 (PST)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 311EGiCj017993;
        Wed, 1 Feb 2023 14:27:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=AksKXheM6eLJ2HJAaoqsPb0evevC0hzy3+GFy9Z9YPg=;
 b=CfgjhILKgVXjlprS6ndI6w88DM4Nm8UgkSI824MJn2Y0774QADwyhnFNy4kCC7zk6285
 S8OgktA9wsQ/eHl76jBQGYAB5hfSLUFDaV9tyar7qSvL/D9WCKdI/JWxF+YiCkKe/rFd
 gZFigVd2+9aQ1x+w3PDy1uvo1fJFArGxmj6Ow0Ppf7VNL1Im5dLa3t0gbOir3AOhluG3
 e2UgFBuyLWBBN9AU2z1Wow4a3HuTab9blm+mXplhdu64TYYgnYVbmaprYZOFPkPZ8qMO
 bUaatYewFboUqXJ/C1kOodzk/sFIvbGEJ1iHoh1IyCsTUetxgrLjwi9YI/0CjzQe7HIU 1w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfsps88yc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:27:52 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 311EH02Q022226;
        Wed, 1 Feb 2023 14:27:51 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3nfsps88xe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:27:51 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 311DSoA6028521;
        Wed, 1 Feb 2023 14:27:49 GMT
Received: from smtprelay05.dal12v.mail.ibm.com ([9.208.130.101])
        by ppma04wdc.us.ibm.com (PPS) with ESMTPS id 3ncvuyp5pd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 01 Feb 2023 14:27:49 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
        by smtprelay05.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 311ERmTg52756914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Feb 2023 14:27:48 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8140A58050;
        Wed,  1 Feb 2023 14:27:48 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EC90B58056;
        Wed,  1 Feb 2023 14:27:45 +0000 (GMT)
Received: from [9.65.253.123] (unknown [9.65.253.123])
        by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
        Wed,  1 Feb 2023 14:27:45 +0000 (GMT)
Message-ID: <9b6c0c4d-57c9-6a9a-379e-82f073b73988@linux.ibm.com>
Date:   Wed, 1 Feb 2023 09:27:45 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH] vfio: fix deadlock between group lock and kvm lock
To:     "Tian, Kevin" <kevin.tian@intel.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "Liu, Yi L" <yi.l.liu@intel.com>, "jgg@nvidia.com" <jgg@nvidia.com>
Cc:     "cohuck@redhat.com" <cohuck@redhat.com>,
        "farman@linux.ibm.com" <farman@linux.ibm.com>,
        "pmorel@linux.ibm.com" <pmorel@linux.ibm.com>,
        "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
        "frankja@linux.ibm.com" <frankja@linux.ibm.com>,
        "imbrenda@linux.ibm.com" <imbrenda@linux.ibm.com>,
        "david@redhat.com" <david@redhat.com>,
        "akrowiak@linux.ibm.com" <akrowiak@linux.ibm.com>,
        "jjherne@linux.ibm.com" <jjherne@linux.ibm.com>,
        "pasic@linux.ibm.com" <pasic@linux.ibm.com>,
        "zhenyuw@linux.intel.com" <zhenyuw@linux.intel.com>,
        "Wang, Zhi A" <zhi.a.wang@intel.com>,
        "Christopherson, , Sean" <seanjc@google.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "intel-gvt-dev@lists.freedesktop.org" 
        <intel-gvt-dev@lists.freedesktop.org>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230131200635.44227-1-mjrosato@linux.ibm.com>
 <BN9PR11MB5276E39EE37A7BA2E1B896278CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Language: en-US
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <BN9PR11MB5276E39EE37A7BA2E1B896278CD19@BN9PR11MB5276.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NJqvptLaEdfJ-3joEq6sHAB0jl6RLbQ7
X-Proofpoint-GUID: SsuqcBrPe_cn_3aaAd2-Jqa6moPwAGMh
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-02-01_04,2023-01-31_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 spamscore=0 phishscore=0 priorityscore=1501 mlxscore=0 mlxlogscore=999
 adultscore=0 impostorscore=0 lowpriorityscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302010120
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/1/23 1:13 AM, Tian, Kevin wrote:
>> From: Matthew Rosato <mjrosato@linux.ibm.com>
>> Sent: Wednesday, February 1, 2023 4:07 AM
>>
>> -	device->kvm = kvm;
>> +	/*
>> +	 * Get the KVM pointer currently associated with the group, if there
>> +	 * is one, and obtain a reference now that will be held until the
>> +	 * open_count reaches 0.  Save the pointer in the device for use by
>> +	 * drivers.
>> +	 */
>> +	spin_lock_irqsave(&group->kvm_ref_lock, flags);
>> +	if (group->kvm && vfio_kvm_get_kvm_safe(device, group->kvm))
>> +		device->kvm = group->kvm;
>> +	spin_unlock_irqrestore(&group->kvm_ref_lock, flags);
>> +
> 
> No group reference in vfio_main.c. 

OK -- I think to do that I'll have to move the lock/unlock of the dev_set lock to group.c right before we call vfio_device_{open,close} and check open_count there to make decisions about the kvm ref (before calling vfio_device_open to decide to get kvm ref, after returning from vfio_device_open to see if we to drop ref on error, after close to see if we need to drop ref).

> 
> btw Yi, looks the deadlock issue also exists in your cdev work.
> 
> kvm_vfio_release() holds kvm lock and then try to acquire
> device->device_set->lock in vfio_device_file_set_kvm().
> 
> vfio_device_ioctl_bind_iommufd() holds device->device_set->lock
> and then call vfio_device_open() which finally hit kvm lock
> acquisition in driver's open_device routine (e.g. vfio-ap).
> 
> A similar fix is required in your series.
> 
> Thanks
> Kevin

