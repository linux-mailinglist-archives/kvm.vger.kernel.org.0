Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D973049E8
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 21:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731974AbhAZFUA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 00:20:00 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15782 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729705AbhAYOmY (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 25 Jan 2021 09:42:24 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10PEaTY0158047;
        Mon, 25 Jan 2021 09:40:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=mcJlkJaeVhRgHBYfiw9t183g6Wd43wiUOrNGMXi9YJI=;
 b=s0cVfs0zZWoGyp8N1z8/pE/7/gtXQTK2kxAluO31qRtwaqvYCRE0s5VGakQz33Vo1Tun
 yGwiJgXLjDcmefuzZLamJCl9jWH2lNb3HhX4kltaYzY1xSsW4LXnlH8PTf8xcswY3mGe
 b60uAQqNpZKis1JP14qFjnqwwIdI6VU9lt/ycJFdDCb9+qSMwu5W/3cS/GH22ivG91PF
 k4F5XFXxtCleN35Y8sH6G7sDLS0IMEtSf18hHwlhKEnHoVONHrGZ6flsPHlhHrQJJ0C+
 sgyc3jA6iAF44tEhI7q3fl0DAumhZQ9Jr2CxW9lg8Fet6kmjBtU/sKMR53hmdI8m9HBO aQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 369xjnjtrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:40:45 -0500
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10PEaW4w158298;
        Mon, 25 Jan 2021 09:40:45 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0a-001b2d01.pphosted.com with ESMTP id 369xjnjtqv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 09:40:44 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10PEajml011644;
        Mon, 25 Jan 2021 14:40:43 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma05wdc.us.ibm.com with ESMTP id 368be8fbyw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 25 Jan 2021 14:40:43 +0000
Received: from b03ledav003.gho.boulder.ibm.com (b03ledav003.gho.boulder.ibm.com [9.17.130.234])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10PEee3w12779972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 25 Jan 2021 14:40:40 GMT
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 767BB6A047;
        Mon, 25 Jan 2021 14:40:40 +0000 (GMT)
Received: from b03ledav003.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77A266A051;
        Mon, 25 Jan 2021 14:40:39 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.138.51])
        by b03ledav003.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 25 Jan 2021 14:40:39 +0000 (GMT)
Subject: Re: [PATCH 4/4] vfio-pci/zdev: Introduce the zPCI I/O vfio region
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     cohuck@redhat.com, schnelle@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <1611086550-32765-5-git-send-email-mjrosato@linux.ibm.com>
 <20210122164843.269f806c@omen.home.shazbot.org>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <9c363ff5-b76c-d697-98e2-cf091a404d15@linux.ibm.com>
Date:   Mon, 25 Jan 2021 09:40:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210122164843.269f806c@omen.home.shazbot.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-25_04:2021-01-25,2021-01-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 spamscore=0 priorityscore=1501 mlxlogscore=999
 impostorscore=0 malwarescore=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101250081
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/22/21 6:48 PM, Alex Williamson wrote:
> On Tue, 19 Jan 2021 15:02:30 -0500
> Matthew Rosato <mjrosato@linux.ibm.com> wrote:
> 
>> Some s390 PCI devices (e.g. ISM) perform I/O operations that have very
>> specific requirements in terms of alignment as well as the patterns in
>> which the data is read/written. Allowing these to proceed through the
>> typical vfio_pci_bar_rw path will cause them to be broken in up in such a
>> way that these requirements can't be guaranteed. In addition, ISM devices
>> do not support the MIO codepaths that might be triggered on vfio I/O coming
>> from userspace; we must be able to ensure that these devices use the
>> non-MIO instructions.  To facilitate this, provide a new vfio region by
>> which non-MIO instructions can be passed directly to the host kernel s390
>> PCI layer, to be reliably issued as non-MIO instructions.
>>
>> This patch introduces the new vfio VFIO_REGION_SUBTYPE_IBM_ZPCI_IO region
>> and implements the ability to pass PCISTB and PCILG instructions over it,
>> as these are what is required for ISM devices.
> 
> There have been various discussions about splitting vfio-pci to allow
> more device specific drivers rather adding duct tape and bailing wire
> for various device specific features to extend vfio-pci.  The latest
> iteration is here[1].  Is it possible that such a solution could simply
> provide the standard BAR region indexes, but with an implementation that
> works on s390, rather than creating new device specific regions to
> perform the same task?  Thanks,
> 
> Alex
> 
> [1]https://lore.kernel.org/lkml/20210117181534.65724-1-mgurtovoy@nvidia.com/
> 

Thanks for the pointer, I'll have to keep an eye on this.  An approach 
like this could solve some issues, but I think a main issue that still 
remains with relying on the standard BAR region indexes (whether using 
the current vfio-pci driver or a device-specific driver) is that QEMU 
writes to said BAR memory region are happening in, at most, 8B chunks 
(which then, in the current general-purpose vfio-pci code get further 
split up into 4B iowrite operations).  The alternate approach I'm 
proposing here is allowing for the whole payload (4K) in a single 
operation, which is significantly faster.  So, I suspect even with a 
device specific driver we'd want this sort of a region anyhow..
