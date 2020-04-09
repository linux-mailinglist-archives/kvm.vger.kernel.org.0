Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC351A35BC
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 16:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727700AbgDIOSr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 10:18:47 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:9274 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726977AbgDIOSr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 9 Apr 2020 10:18:47 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 039E3GnA110666;
        Thu, 9 Apr 2020 10:18:45 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920xgsj7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 10:18:45 -0400
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 039E4OfI115723;
        Thu, 9 Apr 2020 10:18:45 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 30920xgshu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 10:18:45 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id 039EF4gU008147;
        Thu, 9 Apr 2020 14:18:44 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma04dal.us.ibm.com with ESMTP id 3091me94vh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Apr 2020 14:18:44 +0000
Received: from b03ledav001.gho.boulder.ibm.com (b03ledav001.gho.boulder.ibm.com [9.17.130.232])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 039EIeC34784668
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Apr 2020 14:18:40 GMT
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BD9DC6E05D;
        Thu,  9 Apr 2020 14:18:40 +0000 (GMT)
Received: from b03ledav001.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8CBF06E054;
        Thu,  9 Apr 2020 14:18:39 +0000 (GMT)
Received: from cpe-172-100-173-215.stny.res.rr.com (unknown [9.85.171.227])
        by b03ledav001.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu,  9 Apr 2020 14:18:39 +0000 (GMT)
Subject: Re: [PATCH v7 06/15] s390/vfio-ap: sysfs attribute to display the
 guest CRYCB
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        mjrosato@linux.ibm.com, pmorel@linux.ibm.com, pasic@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        jjherne@linux.ibm.com, fiuczy@linux.ibm.com
References: <20200407192015.19887-1-akrowiak@linux.ibm.com>
 <20200407192015.19887-7-akrowiak@linux.ibm.com>
 <20200408123344.1a9032e1.cohuck@redhat.com>
 <60c6bfb6-dd0a-75dc-1043-8dffe983220a@linux.ibm.com>
 <20200408184606.309d9cd9.cohuck@redhat.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <e5823678-9f17-2849-09c1-d4db39b4e696@linux.ibm.com>
Date:   Thu, 9 Apr 2020 10:18:38 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200408184606.309d9cd9.cohuck@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-09_04:2020-04-07,2020-04-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 bulkscore=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 clxscore=1015 suspectscore=3
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004090105
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 4/8/20 12:46 PM, Cornelia Huck wrote:
> On Wed, 8 Apr 2020 12:38:49 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>> On 4/8/20 6:33 AM, Cornelia Huck wrote:
>>> On Tue,  7 Apr 2020 15:20:06 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>   
>>>> The matrix of adapters and domains configured in a guest's CRYCB may
>>>> differ from the matrix of adapters and domains assigned to the matrix mdev,
>>>> so this patch introduces a sysfs attribute to display the CRYCB of a guest
>>>> using the matrix mdev. For a matrix mdev denoted by $uuid, the crycb for a
>>>> guest using the matrix mdev can be displayed as follows:
>>>>
>>>>      cat /sys/devices/vfio_ap/matrix/$uuid/guest_matrix
>>>>
>>>> If a guest is not using the matrix mdev at the time the crycb is displayed,
>>>> an error (ENODEV) will be returned.
>>>>
>>>> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
>>>> ---
>>>>    drivers/s390/crypto/vfio_ap_ops.c | 58 +++++++++++++++++++++++++++++++
>>>>    1 file changed, 58 insertions(+)
>>>> +static DEVICE_ATTR_RO(guest_matrix);
>>> Hm... should information like the guest configuration be readable by
>>> everyone? Or should it be restricted a bit more?
>> Why? The matrix attribute already displays the APQNs of the queues
>> assigned to the matrix mdev. The guest_matrix attribute merely displays
>> a subset of the matrix (i.e., the APQNs assigned to the mdev that reference
>> queue devices bound to the vfio_ap device driver).
>>
>> How can this be restricted?
> I was thinking of using e.g. 400 instead of 444 for the permissions.
>
> I'm not sure if the info about what subset of the queues the guest
> actually uses is all that interesting (except for managing guests); but
> if I see guest information being exposed, I get a little wary, so I
> just stumbled over this.
>
> Maybe I'll come back to that once I have looked at the series in more
> detail, but this might not be a problem at all.

I created this patch primarily because I found it very helpful when
testing. It saved me from logging on to the guest and executing
lszcrypt to verify the AP configuration for the guest. I thought this
might also add value for a system administrator responsible for
KVM guests. It would not be a problem to remove this patch or
change the permissions for the attribute. Let me know when you
complete the series review. Thanks.

>
>>>   
>>>> +
>>>>    static struct attribute *vfio_ap_mdev_attrs[] = {
>>>>    	&dev_attr_assign_adapter.attr,
>>>>    	&dev_attr_unassign_adapter.attr,
>>>> @@ -1050,6 +1107,7 @@ static struct attribute *vfio_ap_mdev_attrs[] = {
>>>>    	&dev_attr_unassign_control_domain.attr,
>>>>    	&dev_attr_control_domains.attr,
>>>>    	&dev_attr_matrix.attr,
>>>> +	&dev_attr_guest_matrix.attr,
>>>>    	NULL,
>>>>    };
>>>>      

