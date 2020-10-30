Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABEAC2A100C
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 22:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727693AbgJ3VRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 17:17:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:57854 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726163AbgJ3VRZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 17:17:25 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UL1Znr052631;
        Fri, 30 Oct 2020 17:17:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=2G50emrylfscXAATrJU9tfzM2of8ayvmd9E8/gVNHHM=;
 b=dnWpJAQhMcOO0Sea3abeIp3+kDXERbEBX6vF1BtUIMH89K36QVKlulwZz5X/dnJf8iHm
 mPv3X9K3vvvYF/ZRjjvHdvH94GyxlS4E3Rv8lWNi88ryO96XjCI29P9743Oli6dsoySs
 6hl+/dXPSfVxSg4gTfShewl2nINekT+idzINtWV1jMh+bf0OKH6WQyilJ+4/fKiiOf+E
 te38YaXr3FsHA90YyGPoWaCD3JS5kGuJX2YSuzrgds4eEN0T0z8YPA+Fe8xI+C+e6JCy
 dMbbJglMrMZ7+FFHOlq7dmH4piD2XgFkfikxym2BWS7jhsar2cwsf7bjPwIwYng3a8/L 5Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gnqqrs5t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:17:23 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09ULBeBL095561;
        Fri, 30 Oct 2020 17:17:22 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0b-001b2d01.pphosted.com with ESMTP id 34gnqqrs5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:17:22 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09ULDeNF005409;
        Fri, 30 Oct 2020 21:17:22 GMT
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
        by ppma04dal.us.ibm.com with ESMTP id 34g1e25g03-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 21:17:22 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09ULHK9s50331990
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 21:17:20 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 37529112064;
        Fri, 30 Oct 2020 21:17:20 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7632C112062;
        Fri, 30 Oct 2020 21:17:19 +0000 (GMT)
Received: from cpe-66-24-58-13.stny.res.rr.com (unknown [9.85.162.174])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 21:17:19 +0000 (GMT)
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
 <20201022171209.19494-2-akrowiak@linux.ibm.com>
 <20201027074846.30ee0ddc.pasic@linux.ibm.com>
 <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
 <20201030185636.60fcca52.pasic@linux.ibm.com>
From:   Tony Krowiak <akrowiak@linux.ibm.com>
Message-ID: <66de1211-2a18-8c68-e321-a1af42bc4537@linux.ibm.com>
Date:   Fri, 30 Oct 2020 17:17:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20201030185636.60fcca52.pasic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_10:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 priorityscore=1501
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0
 spamscore=0 suspectscore=3 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300152
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 10/30/20 1:56 PM, Halil Pasic wrote:
> On Thu, 29 Oct 2020 19:29:35 -0400
> Tony Krowiak <akrowiak@linux.ibm.com> wrote:
>
>>>> +void vfio_ap_mdev_remove_queue(struct ap_device *apdev)
>>>> +{
>>>> +	struct vfio_ap_queue *q;
>>>> +	struct ap_queue *queue;
>>>> +	int apid, apqi;
>>>> +
>>>> +	queue = to_ap_queue(&apdev->device);
>>> What is the benefit of rewriting this? You introduced
>>> queue just to do queue->ap_dev to get to the apdev you
>>> have in hand in the first place.
>> I'm not quite sure what you're asking. This function is
>> the callback function specified via the function pointer
>> specified via the remove field of the struct ap_driver
>> when the vfio_ap device driver is registered with the
>> AP bus. That callback function takes a struct ap_device
>> as a parameter. What am I missing here?
> Please compare the removed function vfio_ap_queue_dev_remove() with the
> added function vfio_ap_mdev_remove_queue() line by line. It should
> become clear.

Got it. You are one sharp cookie, I'll fix this.

>
> Regards,
> Halil

