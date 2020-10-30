Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD722A0C77
	for <lists+kvm@lfdr.de>; Fri, 30 Oct 2020 18:28:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727251AbgJ3R2J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Oct 2020 13:28:09 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22268 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgJ3R2J (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 30 Oct 2020 13:28:09 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 09UH1gug135909;
        Fri, 30 Oct 2020 13:28:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=4A7wONqyqzGSfCfGWtY44IxnIiQw2tQHsrvQPfBffG0=;
 b=UGVU9i+yah6gg3VkzGk3fMB4lfhrySbY4en2V238iAHyPX4Pb/7S/Gi51oBPqXQGTi7H
 64Cp0DIux+jp6xRWOq7AYYxShIv64P8FwmRyBJSON7pzAO12612K+BLFI3VGefbsyENd
 Q6vwgBeLijaHlrX1KIUY7HYWFneFAPOoZ9hEg5oxLt33vEqMxQxiASwJQXLyBgxZl+4+
 URTyhJpr+AsHhk44iUIJdvELBikHflN38kNLHKrVlYaF5Zcy6ays6tl72rsQ7AgUrdUN
 NDgwvbWhwFXtgAfD7XLTfcpXi9McPKPMoVZUepz4obcX0Q1jVHpOxe7crfjRNOeowg0X eA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34g31dvyay-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:28:08 -0400
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 09UH2Hu4139166;
        Fri, 30 Oct 2020 13:28:05 -0400
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34g31dvy8w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 13:28:04 -0400
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 09UHQjOr008875;
        Fri, 30 Oct 2020 17:28:01 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 34g41xryb8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 30 Oct 2020 17:28:01 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 09UHRw6W34472420
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 30 Oct 2020 17:27:58 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 34DCD4C040;
        Fri, 30 Oct 2020 17:27:58 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74C694C058;
        Fri, 30 Oct 2020 17:27:57 +0000 (GMT)
Received: from oc2783563651 (unknown [9.145.172.93])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 30 Oct 2020 17:27:57 +0000 (GMT)
Date:   Fri, 30 Oct 2020 18:27:55 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v11 01/14] s390/vfio-ap: No need to disable IRQ after
 queue reset
Message-ID: <20201030182755.433e3e2d.pasic@linux.ibm.com>
In-Reply-To: <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
References: <20201022171209.19494-1-akrowiak@linux.ibm.com>
        <20201022171209.19494-2-akrowiak@linux.ibm.com>
        <20201027074846.30ee0ddc.pasic@linux.ibm.com>
        <7a2c5930-9c37-8763-7e5d-c08a3638e6a1@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-10-30_07:2020-10-30,2020-10-30 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 bulkscore=0 clxscore=1015 suspectscore=0 adultscore=0 malwarescore=0
 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 spamscore=0 impostorscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2010300122
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 29 Oct 2020 19:29:35 -0400
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> On 10/27/20 2:48 AM, Halil Pasic wrote:
> > On Thu, 22 Oct 2020 13:11:56 -0400
> > Tony Krowiak <akrowiak@linux.ibm.com> wrote:
> >  
> >> The queues assigned to a matrix mediated device are currently reset when:
> >>
> >> * The VFIO_DEVICE_RESET ioctl is invoked
> >> * The mdev fd is closed by userspace (QEMU)
> >> * The mdev is removed from sysfs.  
> > What about the situation when vfio_ap_mdev_group_notifier() is called to
> > tell us that our pointer to KVM is about to become invalid? Do we need to
> > clean up the IRQ stuff there?  
> 
> After reading this question, I decided to do some tracing using
> printk's and learned that the vfio_ap_mdev_group_notifier()
> function does not get called when the guest is shutdown. The reason
> for this is because the vfio_ap_mdev_release() function, which is called
> before the KVM pointer is invalidated, unregisters the group notifier.
> 
> I took a look at some of the other drivers that register a group
> notifier in the mdev_parent_ops.open callback and each unregistered
> the notifier in the mdev_parent_ops.release callback.
> 
> So, to answer your question, there is no need to cleanup the IRQ
> stuff in the vfio_ap_mdev_group_notifier() function since it will
> not get called when the KVM pointer is invalidated. The cleanup
> should be done in the vfio_ap_mdev_release() function that gets
> called when the mdev fd is closed.

You say if vfio_ap_mdev_group_notifier() is called to tell us
that KVM going away, then it is a bug?

If that is the case, I would like that reflected in the code! By that I
mean at logging an error at least (if not BUG_ON).

Regards,
Halil
