Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7632D4DE3EB
	for <lists+kvm@lfdr.de>; Fri, 18 Mar 2022 23:14:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiCRWPX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Mar 2022 18:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiCRWPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Mar 2022 18:15:22 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5167A9BD;
        Fri, 18 Mar 2022 15:14:03 -0700 (PDT)
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IIW64u016588;
        Fri, 18 Mar 2022 22:14:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : from : to : cc : references : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=aEXRaRrEgSkHQoR59P+HnjcfzvaVIARFb4s9O5pToOw=;
 b=VMn2QAbxvoUNMmG4hcYIhhNhw4AGM4dznC45UD9Bftxg7i1oxvmaWddAwRd4c1gLJ1Jn
 q3sE7+fFRSXjyolescf0IVhatqFYJfke9NWgkiy3fVSAzzpv6OCf0YE32msca3fT/zsW
 94BcOCLp8VGZQCHiQigT8k+Zh5UKPTVYocRfJpXlMLoNFVaps5oH8/rAHVT+sEYkGy8Q
 jUOZKGw0EUaRR8Lzt6FM6VEYeZE862HzyTbcqXyD4E9WFa/QGJ0ELtnUEMnSVJUSG9ov
 zwHhr1fNxRY5lw8puZ/OrTQlNlKz0KW+aREmAeliQXCprLDbe89XxqM9yxyEumkSPjrw Ng== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3evqgxnasd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 22:14:01 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 22IME0ip001712;
        Fri, 18 Mar 2022 22:14:00 GMT
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3evqgxnas5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 22:14:00 +0000
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 22IM7gae008807;
        Fri, 18 Mar 2022 22:13:59 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04dal.us.ibm.com with ESMTP id 3erk5ag4cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 18 Mar 2022 22:13:59 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 22IMDvsP41681392
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 22:13:58 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6A82AC065;
        Fri, 18 Mar 2022 22:13:57 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 770DDAC064;
        Fri, 18 Mar 2022 22:13:56 +0000 (GMT)
Received: from [9.65.234.56] (unknown [9.65.234.56])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 18 Mar 2022 22:13:56 +0000 (GMT)
Message-ID: <b2dd8ef3-5fdb-5e29-4c75-12b9c3971950@linux.ibm.com>
Date:   Fri, 18 Mar 2022 18:13:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v18 12/18] s390/vfio-ap: reset queues after adapter/domain
 unassignment
Content-Language: en-US
From:   Tony Krowiak <akrowiak@linux.ibm.com>
To:     jjherne@linux.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     freude@linux.ibm.com, borntraeger@de.ibm.com, cohuck@redhat.com,
        mjrosato@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20220215005040.52697-1-akrowiak@linux.ibm.com>
 <20220215005040.52697-13-akrowiak@linux.ibm.com>
 <6083d83b-6867-2525-fdd8-baccde1a599f@linux.ibm.com>
 <e869ab58-432e-e451-9021-71ee65488fb0@linux.ibm.com>
In-Reply-To: <e869ab58-432e-e451-9021-71ee65488fb0@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: UF4kXXVLjxavD5mFrUT60zQzg-_GdT58
X-Proofpoint-GUID: H0_AMFsPe5LdN0I1nDjJP8fOx0DZ2hmJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-18_14,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 mlxlogscore=999 suspectscore=0 adultscore=0 priorityscore=1501
 impostorscore=0 malwarescore=0 lowpriorityscore=0 spamscore=0
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180119
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H5,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

snip ...

>
>>
>>
>>> + vfio_ap_unlink_mdev_fr_queue(q);
>>> +        hash_del(&q->mdev_qnode);
>>>       }
>>>   }
>> ...
>>> @@ -1273,9 +1320,9 @@ static void vfio_ap_mdev_unset_kvm(struct 
>>> ap_matrix_mdev *matrix_mdev,
>>>           mutex_lock(&kvm->lock);
>>>           mutex_lock(&matrix_dev->mdevs_lock);
>>>   -        kvm_arch_crypto_clear_masks(kvm);
>>> -        vfio_ap_mdev_reset_queues(matrix_mdev);
>>> -        kvm_put_kvm(kvm);
>>> +        kvm_arch_crypto_clear_masks(matrix_mdev->kvm);
>>> + vfio_ap_mdev_reset_queues(&matrix_mdev->qtable);
>>> +        kvm_put_kvm(matrix_mdev->kvm);
>>>           matrix_mdev->kvm = NULL;
>>
>> I understand changing the call to vfio_ap_mdev_reset_queues, but why 
>> are we changing the
>> kvm pointer on the surrounding lines?
>
> In reality, both pointers are one in the same given the two callers pass
> matrix_mdev->kvm into the function. I'm not sure why that is the case,
> it is probably a remnant from the commits that fixed the lockdep splat;
> however, there is no reason other than I've gotten used to retrieving the
> KVM pointer from the ap_matrix_mdev structure. In reality, there is no
> reason to pass a 'struct kvm *kvm' into this function, so I'm going to
> look into that and adjust accordingly.

The 'struct kvm *kvm' parameter was added to the signature of the
vfio_ap_mdev_unset_kvm function with the following commit:

86956e70761b (s390/vfio-ap: replace open coded locks for 
VFIO_GROUP_NOTIFY_SET_KVM notification)

I also noticed the the kernel doc for the vfio_ap_mdev_set_kvm and
vfio_ap_mdev_unset_kvm functions still contained a comment that is no longer
valid by the following commit:

0cc00c8d4050 (s390/vfio-ap: fix circular lockdep when setting/clearing 
crypto masks)

I pushed a patch to our devel branch that removes the invalid comment
from the two functions and removes the 'struct kvm *kvm' parameter
from the vfio_ap_mdev_unset_kvm function. That patch will prereq this 
series.

>
>>
>>
>>> mutex_unlock(&matrix_dev->mdevs_lock);
>>> @@ -1328,14 +1375,17 @@ static int vfio_ap_mdev_reset_queue(struct 
>>> vfio_ap_queue *q, unsigned int retry)
>>>         if (!q)
>>>           return 0;
>>> +    q->reset_rc = 0;

