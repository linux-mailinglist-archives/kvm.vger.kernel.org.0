Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFF2948BA58
	for <lists+kvm@lfdr.de>; Tue, 11 Jan 2022 22:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343770AbiAKV6U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Jan 2022 16:58:20 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:16428 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229719AbiAKV6T (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 11 Jan 2022 16:58:19 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20BLAvVG001974;
        Tue, 11 Jan 2022 21:58:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=9EeTXtdvEVZJPE8clELVEPcRNb4nDpYJAOUAGnpD18E=;
 b=AHJ47HcbsWqVPq3rjy43Ss5e4x3KrLCHIGCL2F0X1Q303cN75OEQk4FZ/z8LdKV2BlAE
 rNzGguTWzpwBfHA/vqVNsCgDCxhVyaxyZ/AMm4UvLb/On9X/Pqcq4cix+YnTkSfTk6iO
 pjWKPMfTbnciyPFd6XfhHPmA2QYRKswpwqGoaycPm/l7vB+o+OBEpz8kbMwAmckXymSB
 B3x8ThguvfLo/3CuTjf0j+yTR07xrQimWAoV9E0ZGYSwqAvGABFJpgY9QfPF95dRtRoB
 aXC/65nwL21N7X1bpGuCnIhVNXu213vZEo3006p+57nOjCLmYnKAhONigbOdRLe6ELgh 6w== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhgxy1hyc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:58:17 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20BLwGC9026617;
        Tue, 11 Jan 2022 21:58:16 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dhgxy1hy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:58:16 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20BLqMe9012370;
        Tue, 11 Jan 2022 21:58:16 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma04wdc.us.ibm.com with ESMTP id 3df28apbag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 11 Jan 2022 21:58:15 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20BLwFtO10093018
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jan 2022 21:58:15 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D4FAA28067;
        Tue, 11 Jan 2022 21:58:14 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C48E028060;
        Tue, 11 Jan 2022 21:58:13 +0000 (GMT)
Received: from [9.65.85.237] (unknown [9.65.85.237])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 11 Jan 2022 21:58:13 +0000 (GMT)
Message-ID: <fcce7cc6-6ac7-b22a-a957-80e59a0f4e83@linux.ibm.com>
Date:   Tue, 11 Jan 2022 16:58:13 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH v17 08/15] s390/vfio-ap: keep track of active guests
Content-Language: en-US
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, jjherne@linux.ibm.com, freude@linux.ibm.com,
        borntraeger@de.ibm.com, cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com
References: <20211021152332.70455-1-akrowiak@linux.ibm.com>
 <20211021152332.70455-9-akrowiak@linux.ibm.com>
 <20211230043322.2ba19bbd.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
In-Reply-To: <20211230043322.2ba19bbd.pasic@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uiPt7voRNxJjkjHMej9jUbf_89r3wWlF
X-Proofpoint-ORIG-GUID: TrUUSbQ4qftWyQU6y_m6rm0QqOdw6Mhx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-11_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 clxscore=1015 mlxscore=0 phishscore=0
 priorityscore=1501 adultscore=0 bulkscore=0 lowpriorityscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201110111
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 12/29/21 22:33, Halil Pasic wrote:
> On Thu, 21 Oct 2021 11:23:25 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> The vfio_ap device driver registers for notification when the pointer to
>> the KVM object for a guest is set. Let's store the KVM pointer as well as
>> the pointer to the mediated device when the KVM pointer is set.
> [..]
>
>
>> struct ap_matrix_dev {
>>          ...
>>          struct rw_semaphore guests_lock;
>>          struct list_head guests;
>>         ...
>> }
>>
>> The 'guests_lock' field is a r/w semaphore to control access to the
>> 'guests' field. The 'guests' field is a list of ap_guest
>> structures containing the KVM and matrix_mdev pointers for each active
>> guest. An ap_guest structure will be stored into the list whenever the
>> vfio_ap device driver is notified that the KVM pointer has been set and
>> removed when notified that the KVM pointer has been cleared.
>>
> Is this about the field or about the list including all the nodes? This
> reads lie guests_lock only protects the head element, which makes no
> sense to me. Because of how these lists work.

It locks the list, I can rewrite the description.

>
> The narrowest scope that could make sense is all the list_head stuff
> in the entire list. I.e. one would only need the lock to traverse or
> manipulate the list, while the payload would still be subject to
> the matrix_dev->lock mutex.

The matrix_dev->guests lock is needed whenever the kvm->lock
is needed because the struct ap_guest object is created and the
struct kvm assigned to it when the kvm pointer is set
(vfio_ap_mdev_set_kvm function). So, in order to access the
ap_guest object and retrieve the kvm pointer, we have to ensure
the ap_guest_object is still available. The fact we can get the
kvm pointer from the ap_matrix_mdev object just makes things
more efficient - i.e., we won't have to traverse the list.

Whenever the kvm->lock and matrix_dev->lock mutexes must
be held, the order is:

     matrix_dev->guests_lock
     matrix_dev->guests->kvm->lock
     matrix_dev->lock

There are times where all three locks are not required; for example,
the handle_pqap and vfio_ap_mdev_probe/remove functions only
require the matrix_dev->lock because it does not need to lock kvm.

>
> [..]
>
>> +struct ap_guest {
>> +	struct kvm *kvm;
>> +	struct list_head node;
>> +};
>> +
>>   /**
>>    * struct ap_matrix_dev - Contains the data for the matrix device.
>>    *
>> @@ -39,6 +44,9 @@
>>    *		single ap_matrix_mdev device. It's quite coarse but we don't
>>    *		expect much contention.
>>    * @vfio_ap_drv: the vfio_ap device driver
>> + * @guests_lock: r/w semaphore for protecting access to @guests
>> + * @guests:	list of guests (struct ap_guest) using AP devices bound to the
>> + *		vfio_ap device driver.
> Please compare the above. Also if it is only about the access to the
> list, then you could drop the lock right after create, and not keep it
> till the very end of vfio_ap_mdev_set_kvm(). Right?

That would be true if it only controlled access to the list, but as I
explained above, that is not its sole purpose.

>
> In any case I'm skeptical about this whole struct ap_guest business. To
> me, it looks like something that just makes things more obscure and
> complicated without any real benefit.

I'm open to other ideas, but you'll have to come up with a way
to take the kvm->lock before the matrix_mdev->lock in the
vfio_ap_mdev_probe_queue and vfio_ap_mdev_remove_queue
functions where we don't have access to the ap_matrix_mdev
object to which the APQN is assigned and has the pointer to the
kvm object.

In order to retrieve the matrix_mdev, we need the matrix_dev->lock.
In order to hot plug/unplug the queue, we need the kvm->lock.
There's your catch-22 that needs to be solved. This design is my
attempt to solve that.

>
> Regards,
> Halil
>
>>    */
>>   struct ap_matrix_dev {
>>   	struct device device;
>> @@ -47,6 +55,8 @@ struct ap_matrix_dev {
>>   	struct list_head mdev_list;
>>   	struct mutex lock;
>>   	struct ap_driver  *vfio_ap_drv;
>> +	struct rw_semaphore guests_lock;
>> +	struct list_head guests;
>>   };
>>   
>>   extern struct ap_matrix_dev *matrix_dev;

