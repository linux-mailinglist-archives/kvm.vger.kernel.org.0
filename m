Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38772F3907
	for <lists+kvm@lfdr.de>; Tue, 12 Jan 2021 19:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732878AbhALSkf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jan 2021 13:40:35 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:62642 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbhALSkf (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 12 Jan 2021 13:40:35 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10CIX43S105985;
        Tue, 12 Jan 2021 13:39:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=pp1;
 bh=0mUUZ0luBZVApEnrMUbFupnm3Xl8YZxqNAYcYOKcSiE=;
 b=lUusMNjQ1MW0/7yYF96aH7YJwJ2ylfy4lwp9fiyM4xegUkXXY4N/GX97KLHTgyA3uAZh
 J2KqF5060DYF0aflfgg14mHXIT3QmmhV6/V+ED+UT6tSgMDss3HSIv5G2U0bmhrzaANt
 ISmH+sB7JGuWoA/hkHDD5Th55FSMQi175fCTuwmwTTsFSdEVgNMm3ru1uAPJDjA6W7Iq
 bbPS35w7uThtZHkFXOXhkIvWr8t/6HDi4qOLA8SDrJ6tt2TIerO8vc0E13pf1EXW9t65
 F3EMxmZlXM4tT2AUcu347gA6JMo+2pESt29c5i0FP8CMJsLWtl20Zei22xxLIBzalr05 dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361gxxrf2n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:39:54 -0500
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10CIXNh1107194;
        Tue, 12 Jan 2021 13:39:53 -0500
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 361gxxrf1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 13:39:53 -0500
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10CIc360025377;
        Tue, 12 Jan 2021 18:39:51 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma04fra.de.ibm.com with ESMTP id 3604h99c0k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 18:39:51 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10CIdmgo46334452
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Jan 2021 18:39:48 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 44B6F11C050;
        Tue, 12 Jan 2021 18:39:48 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8E3FC11C04C;
        Tue, 12 Jan 2021 18:39:47 +0000 (GMT)
Received: from li-e979b1cc-23ba-11b2-a85c-dfd230f6cf82 (unknown [9.171.60.135])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with SMTP;
        Tue, 12 Jan 2021 18:39:47 +0000 (GMT)
Date:   Tue, 12 Jan 2021 19:39:45 +0100
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Tony Krowiak <akrowiak@linux.ibm.com>
Cc:     linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, freude@linux.ibm.com, borntraeger@de.ibm.com,
        cohuck@redhat.com, mjrosato@linux.ibm.com,
        alex.williamson@redhat.com, kwankhede@nvidia.com,
        fiuczy@linux.ibm.com, frankja@linux.ibm.com, david@redhat.com,
        hca@linux.ibm.com, gor@linux.ibm.com
Subject: Re: [PATCH v13 13/15] s390/vfio-ap: handle host AP config change
 notification
Message-ID: <20210112193945.0050139e.pasic@linux.ibm.com>
In-Reply-To: <20201223011606.5265-14-akrowiak@linux.ibm.com>
References: <20201223011606.5265-1-akrowiak@linux.ibm.com>
        <20201223011606.5265-14-akrowiak@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_15:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 malwarescore=0
 suspectscore=0 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0
 impostorscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101120108
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 22 Dec 2020 20:16:04 -0500
Tony Krowiak <akrowiak@linux.ibm.com> wrote:

> The motivation for config change notification is to enable the vfio_ap
> device driver to handle hot plug/unplug of AP queues for a KVM guest as a
> bulk operation. For example, if a new APID is dynamically assigned to the
> host configuration, then a queue device will be created for each APQN that
> can be formulated from the new APID and all APQIs already assigned to the
> host configuration. Each of these new queue devices will get bound to their
> respective driver one at a time, as they are created. In the case of the
> vfio_ap driver, if the APQN of the queue device being bound to the driver
> is assigned to a matrix mdev in use by a KVM guest, it will be hot plugged
> into the guest if possible. Given that the AP architecture allows for 256
> adapters and 256 domains, one can see the possibility of the vfio_ap
> driver's probe/remove callbacks getting invoked an inordinate number of
> times when the host configuration changes. Keep in mind that in order to
> plug/unplug an AP queue for a guest, the guest's VCPUs must be suspended,
> then the guest's AP configuration must be updated followed by the VCPUs
> being resumed. If this is done each time the probe or remove callback is
> invoked and there are hundreds or thousands of queues to be probed or
> removed, this would be incredibly inefficient and could have a large impact
> on guest performance. What the config notification does is allow us to
> make the changes to the guest in a single operation.
> 
> This patch implements the on_cfg_changed callback which notifies the
> AP device drivers that the host AP configuration has changed (i.e.,
> adapters, domains and/or control domains are added to or removed from the
> host AP configuration).
> 
> Adapters added to host configuration:
> * The APIDs of the adapters added will be stored in a bitmap contained
>   within the struct representing the matrix device which is the parent
>   device of all matrix mediated devices.
> * When a queue is probed, if the APQN of the queue being probed is
>   assigned to an mdev in use by a guest, the queue may get hot plugged
>   into the guest; however, if the APID of the adapter is contained in the
>   bitmap of adapters added, the queue hot plug operation will be skipped
>   until the AP bus notifies the driver that its scan operation has
>   completed (another patch).

I guess, I should be able to find this in patch 14. But I can't.

> * When the vfio_ap driver is notified that the AP bus scan has completed,
>   the guest's APCB will be refreshed by filtering the mdev's matrix by
>   APID.
> 
> Domains added to host configuration:
> * The APQIs of the domains added will be stored in a bitmap contained
>   within the struct representing the matrix device which is the parent
>   device of all matrix mediated devices.
> * When a queue is probed, if the APQN of the queue being probed is
>   assigned to an mdev in use by a guest, the queue may get hot plugged
>   into the guest; however, if the APQI of the domain is contained in the
>   bitmap of domains added, the queue hot plug operation will be skipped
>   until the AP bus notifies the driver that its scan operation has
>   completed (another patch).
> 
> Control domains added to the host configuration:
> * The domain numbers of the domains added will be stored in a bitmap
>   contained within the struct representing the matrix device which is the
>   parent device of all matrix mediated devices.
> 
> When the vfio_ap device driver is notified that the AP bus scan has
> completed, the APCB for each matrix mdev to which the adapters, domains
> and control domains added are assigned will be refreshed. If a KVM guest is
> using the matrix mdev, the APCB will be hot plugged into the guest to
> refresh its AP configuration.
> 
> Adapters removed from configuration:
> * Each queue device with the APID identifying an adapter removed from
>   the host AP configuration will be unlinked from the matrix mdev to which
>   the queue's APQN is assigned.
> * When the vfio_ap driver's remove callback is invoked, if the queue
>   device is not linked to the matrix mdev, the refresh of the guest's
>   APCB will be skipped.
> 
> Domains removed from configuration:
> * Each queue device with the APQI identifying a domain removed from
>   the host AP configuration will be unlinked from the matrix mdev to which
>   the queue's APQN is assigned.
> * When the vfio_ap driver's remove callback is invoked, if the queue
>   device is not linked to the matrix mdev, the refresh of the guest's
>   APCB will be skipped.
> 
> If any queues with an APQN assigned to a given matrix mdev have been
> unlinked or any control domains assigned to a given matrix mdev have been
> removed from the host AP configuration, the APCB of the matrix mdev will
> be refreshed. If a KVM guest is using the matrix mdev, the APCB will be hot
> plugged into the guest to refresh its AP configuration.
> 
> Signed-off-by: Tony Krowiak <akrowiak@linux.ibm.com>
> ---
[..]
> +static void vfio_ap_mdev_on_cfg_add(void)
> +{
> +	unsigned long *cur_apm, *cur_aqm, *cur_adm;
> +	unsigned long *prev_apm, *prev_aqm, *prev_adm;
> +
> +	cur_apm = (unsigned long *)matrix_dev->config_info.apm;
> +	cur_aqm = (unsigned long *)matrix_dev->config_info.aqm;
> +	cur_adm = (unsigned long *)matrix_dev->config_info.adm;
> +
> +	prev_apm = (unsigned long *)matrix_dev->config_info_prev.apm;
> +	prev_aqm = (unsigned long *)matrix_dev->config_info_prev.aqm;
> +	prev_adm = (unsigned long *)matrix_dev->config_info_prev.adm;
> +
> +	bitmap_andnot(matrix_dev->ap_add, cur_apm, prev_apm, AP_DEVICES);
> +	bitmap_andnot(matrix_dev->aq_add, cur_aqm, prev_aqm, AP_DOMAINS);
> +	bitmap_andnot(matrix_dev->ad_add, cur_adm, prev_adm, AP_DOMAINS);
> +}

This function seems useless without the next patch, but I don't mind, it
can stay here.

Regards,
Halil
[..]
