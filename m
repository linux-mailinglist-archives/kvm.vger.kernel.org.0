Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80B2852DA52
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiESQfT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiESQfQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 12:35:16 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2038AD02AC;
        Thu, 19 May 2022 09:35:16 -0700 (PDT)
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24JG7pPu017535;
        Thu, 19 May 2022 16:35:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2T5NhEA+6P1WIyw4DeeIGw9BcvZEFkKAL6lWgW6LRvc=;
 b=bExy/vlOeydJMgjLGuPMNuvb9obIIWE9x/rU49vHC3V/5k9VMhSd+0/UeZ+B1L2D6J7m
 0X4QznkbKuVVhQHAFQGpVmxUQddGnyrBnOXfokCuHudV+Bq33OTQo+qOGtPVwxUFrc1S
 kqyQ4Hxuf8+wR8LJpM/3mklKexinY0l1llFFhqoIiYUEr/Wf0GZnLiNUvULcelPgToPM
 cPqS+mDshGmx1JT/qYYgtB3SWDrL6Tq/v+mKWCYLEsR2ItGLR8y/XOWbL0BN098MDRnj
 lgtcoySH2NpVfpzASFJOJP2bf8cRLDMGdqdZr8JABJeYAQ4uFwnCwAAfzf2CyB395UJ8 7A== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5rsf9a8j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 16:35:07 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 24JGRO0F009332;
        Thu, 19 May 2022 16:35:07 GMT
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3g5rsf9a80-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 16:35:07 +0000
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 24JGStQ1017503;
        Thu, 19 May 2022 16:35:05 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma05wdc.us.ibm.com with ESMTP id 3g242an11b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 May 2022 16:35:05 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 24JGZ5rq39452944
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 May 2022 16:35:05 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 01060124060;
        Thu, 19 May 2022 16:35:05 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2940912405B;
        Thu, 19 May 2022 16:35:02 +0000 (GMT)
Received: from [9.211.37.97] (unknown [9.211.37.97])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 19 May 2022 16:35:01 +0000 (GMT)
Message-ID: <f7a30821-5885-261f-5197-088d6f76dcc4@linux.ibm.com>
Date:   Thu, 19 May 2022 12:35:00 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH v2 1/1] vfio: remove VFIO_GROUP_NOTIFY_SET_KVM
Content-Language: en-US
To:     Tony Krowiak <akrowiak@linux.ibm.com>, jgg@nvidia.com,
        alex.williamson@redhat.com
Cc:     cohuck@redhat.com, borntraeger@linux.ibm.com,
        jjherne@linux.ibm.com, pasic@linux.ibm.com,
        zhenyuw@linux.intel.com, zhi.a.wang@intel.com, hch@infradead.org,
        intel-gfx@lists.freedesktop.org,
        intel-gvt-dev@lists.freedesktop.org, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220518212607.467538-1-mjrosato@linux.ibm.com>
 <20220518212607.467538-2-mjrosato@linux.ibm.com>
 <0ab6bb11-4510-0efc-0ad6-507d749022f2@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <0ab6bb11-4510-0efc-0ad6-507d749022f2@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n5MRbdrtyYeMwoOhhvnPEZ_kAMqepiPR
X-Proofpoint-ORIG-GUID: fw9NAjzqH5y8tJAgl_wa0ExUc7gQwGLZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.874,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-19_05,2022-05-19_03,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 clxscore=1015
 malwarescore=0 priorityscore=1501 phishscore=0 lowpriorityscore=0
 bulkscore=0 spamscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205190095
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/19/22 12:23 PM, Tony Krowiak wrote:
> I made a few comments, but other than that this looks good to
> me:
> 
> Reviewed-by: Tony Krowiak <akrowiak@linux.ibm.com>
> 

...

> I'm not sure what version of the code on which the patch was rebased, 

Was on top of Jason's vfio_group_locking series, but now would apply on 
vfio-next since Alex pulled that series in to vfio-next.

> but in the
> latest master branch from our repository the kvm_get_kvm(kvm) function is
> called inside of the if block below. I'm fine with moving outside of the 
> block, but
> I don't see a corresponding removal of it from inside the block.

Yeah, I didn't notice those there.  v3 will simply remove my get/put 
additions and leave yours as-is.

...

>> vfio_ap_mdev_group_notifier;
>> -    events = VFIO_GROUP_NOTIFY_SET_KVM;
>> +    if (!vdev->kvm)
>> +        return -EPERM;
> 
> Perhaps -EINVAL or -EFAULT?
> 

Whichever you'd prefer?  If I don't hear back I'll just use -EINVAL in v3.

>> -    ret = vfio_register_notifier(vdev, VFIO_GROUP_NOTIFY, &events,
>> -                     &matrix_mdev->group_notifier);
>> +    ret = vfio_ap_mdev_set_kvm(matrix_mdev, vdev->kvm);
>>       if (ret)
>>           return ret;
>> @@ -1415,12 +1400,11 @@ static int vfio_ap_mdev_open_device(struct 
>> vfio_device *vdev)
>>       ret = vfio_register_notifier(vdev, VFIO_IOMMU_NOTIFY, &events,
>>                        &matrix_mdev->iommu_notifier);
>>       if (ret)
>> -        goto out_unregister_group;
>> +        goto err_kvm;
>>       return 0;
>> -out_unregister_group:
>> -    vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
>> -                 &matrix_mdev->group_notifier);
>> +err_kvm:
>> +    vfio_ap_mdev_unset_kvm(matrix_mdev);
>>       return ret;
>>   }
>> @@ -1431,8 +1415,6 @@ static void vfio_ap_mdev_close_device(struct 
>> vfio_device *vdev)
>>       vfio_unregister_notifier(vdev, VFIO_IOMMU_NOTIFY,
>>                    &matrix_mdev->iommu_notifier);
>> -    vfio_unregister_notifier(vdev, VFIO_GROUP_NOTIFY,
>> -                 &matrix_mdev->group_notifier);
>>       vfio_ap_mdev_unset_kvm(matrix_mdev);
> 
> I'm not sure if this matters, but the vfio_ap_mdev_unset_kvm(matrix_mdev)
> function uses the KVM pointer stored in matrix_mdev->kvm. I can't imagine
> the KVM pointer stored in vdev->kvm being different than matrix_mdev->kvm,

With this patch matrix_mdev->kvm is set from the value in vdev->kvm 
during vfio_ap_mdev_set_kvm (basically, doing the work that the notifier 
was doing but instead of getting it from notifier data get it from the 
vfio_device)

> but thought I should point it out. Previously, this function was called 
> by the
> notifier handler which did not have access to the KVM pointer which is 
> why it
> was retrieved from matrix_mdev->kvm. Even if the vdev->kvm and
> matrix_mdev->kvm did not match, we should probably go ahead and call
> the unset function anyway to remove access to AP resources for the guest 
> and
> reset the queues.
> 

