Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B002B9A73
	for <lists+kvm@lfdr.de>; Thu, 19 Nov 2020 19:15:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbgKSSPg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Nov 2020 13:15:36 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:14926 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727761AbgKSSPf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 19 Nov 2020 13:15:35 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AJI2pnq134068;
        Thu, 19 Nov 2020 13:15:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=27GOfRCLmrOpPdwc1nWg0zzBxV0oor0zhKyOQGBMgFU=;
 b=NO2/ozUEVxERFF5dV67w1PyQlqBz4Ms8aPvuj9IVGrUzmQCsP2RMoYkjBPDsGcV6sjaP
 688z1V6XvqMck+p2q8ezVE9RO0IwQQw8m/5lr9hrzYFK4DrS0syNjyyNxy31kVtjTEoe
 LUzydpafkourCIcTiiqC56PuFHfYtUvSzrmAqEXHAFjfvguIVrZh64ilYv4/Rp4Lesqv
 2KsatajQte/b4f2dh4wRB13F+JNQwbguv6KB6hFRLZaoh5djcKLxY6aeQcqI5OkAstjw
 YONyiGr+lO+V6c1g6OfRmiH6gaWCGfDZaBLgQ81pdWL6yyGt5aAg80XOSfbUmaa+bdji Fg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xqvmc8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 13:15:32 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0AJI33Zv135438;
        Thu, 19 Nov 2020 13:15:31 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34w4xqvmb6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 13:15:31 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AJIBxIk021543;
        Thu, 19 Nov 2020 18:15:30 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma03wdc.us.ibm.com with ESMTP id 34t6v9g4ae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Nov 2020 18:15:30 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AJIFLSv36241710
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Nov 2020 18:15:21 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 55C03BE04F;
        Thu, 19 Nov 2020 18:15:27 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3DC0BE059;
        Thu, 19 Nov 2020 18:15:25 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.152.80])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Nov 2020 18:15:25 +0000 (GMT)
Subject: Re: [PATCH v11 07/14] s390/vfio-ap: sysfs attribute to display the
 guest's matrix
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-8-akrowiak@linux.ibm.com>
 <20201028091758.73aa77a3.pasic@linux.ibm.com>
 <b96fe876-c67a-fe6c-0e3a-7b4948edeef4@linux.ibm.com>
 <20201114001248.3b397c8c.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <d25a6810-00df-a2fc-4541-548917fdcc40@linux.ibm.com>
Date:   Thu, 19 Nov 2020 13:15:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201114001248.3b397c8c.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-19_09:2020-11-19,2020-11-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 spamscore=0 impostorscore=0 mlxscore=0 adultscore=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0 bulkscore=0
 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011190125
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 11/13/20 6:12 PM, Halil Pasic wrote:
> On Fri, 13 Nov 2020 12:27:32 -0500
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>
>> On 10/28/20 4:17 AM, Halil Pasic wrote:
>>> On Thu, 22 Oct 2020 13:12:02 -0400
>>> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>>>
>>>> +static ssize_t guest_matrix_show(struct device *dev,
>>>> +				 struct device_attribute *attr, char *buf)
>>>> +{
>>>> +	ssize_t nchars;
>>>> +	struct mdev_device *mdev = mdev_from_dev(dev);
>>>> +	struct ap_matrix_mdev *matrix_mdev = mdev_get_drvdata(mdev);
>>>> +
>>>> +	if (!vfio_ap_mdev_has_crycb(matrix_mdev))
>>>> +		return -ENODEV;
>>> I'm wondering, would it make sense to have guest_matrix display the would
>>> be guest matrix when we don't have a KVM? With the filtering in
>>> place, the question in what guest_matrix would my (assign) matrix result
>>> right now if I were to hook up my vfio_ap_mdev to a guest seems a
>>> legitimate one.
>> A couple of thoughts here:
>> * The ENODEV informs the user that there is no guest running
>>      which makes sense to me given this interface displays the
>>      guest matrix. The alternative, which I considered, was to
>>      display an empty matrix (i.e., nothing).
>> * This would be a pretty drastic change to the design because
>>      the shadow_apcb - which is what is displayed via this interface - is
>>      only updated when the guest is started and while it is running (i.e.,
>>      hot plug of new adapters/domains). Making this change would
>>      require changing that entire design concept which I am reluctant
>>      to do at this point in the game.
>>
>>
> No problem. My thinking was, that, because we can do the
> assign/unassing ops also for the running guest, that we also have
> the code to do the maintenance on the shadow_apcb. In this
> series this code is conditional with respect to vfio_ap_mdev_has_crycb().
> E.g.
>
> static ssize_t assign_adapter_store(struct device *dev,
>                                      struct device_attribute *attr,
>                                      const char *buf, size_t count)
> {
> [..]
>          if (vfio_ap_mdev_has_crycb(matrix_mdev))
>                  if (vfio_ap_mdev_filter_guest_matrix(matrix_mdev, true))
>                          vfio_ap_mdev_commit_shadow_apcb(matrix_mdev);
>
> If one were to move the
> vfio_ap_mdev_has_crycb() check into vfio_ap_mdev_commit_shadow_apcb()
> then we would have an always up to date shatdow_apcb, we could display.
>
> I don't feel strongly about this. Was just an idea, because if the result
> of the filtering is surprising, currently the only to see, without
> knowing the algorithm, and possibly the state, and the history of the
> system, is to actually start a guest.

Okay, I can buy this and will make the change.

>
> Regards,
> Halil
>

