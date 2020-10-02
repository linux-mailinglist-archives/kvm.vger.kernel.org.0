Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1094281CCF
	for <lists+kvm@lfdr.de>; Fri,  2 Oct 2020 22:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJBUSa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Oct 2020 16:18:30 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:60984 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgJBUS3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 2 Oct 2020 16:18:29 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 092K1w7O008793;
        Fri, 2 Oct 2020 16:18:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Iz8GtRGjp+QU5TRzo1glFjFvmg1Z5wCPlTvS572cwwM=;
 b=N3eSpmhnSxsa8XkXvuSFsXsxQDL2A3e0GhSfaFEL02OEivEFrjcQnhE6vI0Ky0iu7Ku0
 Ebv2iRbQHlW2VTOLzR8fY8lgVS6dQ8rgEPA+fMqAJpkhranKqKUMgcM6uzBmXHTePlBg
 ic7lTKr5EVdfXMBdt+wIypEIHbjiQfYwhlZSSKgfaL3EdTGDg1/mkJNyCW+hTy0i42bw
 b08KyQ52TNugkbshe+6udC1KOK/Nw43MfljL07ziqMUcuNusKFsGKTHB1/KuzhH+hWay
 NSw0BFQNg/iAs3BDbLai8OXxyggKR2HowYWZVlZ4Kl3KELLu9spoEsEBVQRtlkrSoIVg eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9uasxgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:18:29 -0400
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 092K2eQ5011377;
        Fri, 2 Oct 2020 16:18:28 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33x9uasxfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 16:18:28 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 092KH6xE011867;
        Fri, 2 Oct 2020 20:18:27 GMT
Received: from b01cxnp22033.gho.pok.ibm.com (b01cxnp22033.gho.pok.ibm.com [9.57.198.23])
        by ppma02wdc.us.ibm.com with ESMTP id 33sw9a0baw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 02 Oct 2020 20:18:27 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 092KIQpU55247182
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 2 Oct 2020 20:18:26 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E6893AC05F;
        Fri,  2 Oct 2020 20:18:25 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C5D52AC05B;
        Fri,  2 Oct 2020 20:18:23 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.4.25])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri,  2 Oct 2020 20:18:23 +0000 (GMT)
Subject: Re: [PATCH v2 0/5] Pass zPCI hardware information via VFIO
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <28d77f9a-0f73-82a8-7dc8-61451f13f375@linux.ibm.com>
Date:   Fri, 2 Oct 2020 16:18:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1601668844-5798-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-10-02_14:2020-10-02,2020-10-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 impostorscore=0 spamscore=0
 malwarescore=0 bulkscore=0 phishscore=0 adultscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2010020142
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/2/20 4:00 PM, Matthew Rosato wrote:
> This patchset provides a means by which hardware information about the
> underlying PCI device can be passed up to userspace (ie, QEMU) so that
> this hardware information can be used rather than previously hard-coded
> assumptions. A new VFIO region type is defined which holds this
> information.
> 
> A form of these patches saw some rounds last year but has been back-
> tabled for a while.  The original work for this feature was done by Pierre
> Morel. I'd like to refresh the discussion on this and get this finished up
> so that we can move forward with better-supporting additional types of
> PCI-attached devices.  The proposal here presents a completely different
> region mapping vs the prior approach, taking inspiration from vfio info
> capability chains to provide device CLP information in a way that allows
> for future expansion (new CLP features).
> 
> This feature is toggled via the CONFIG_VFIO_PCI_ZDEV configuration entry.
> 
> Changes from v1:
> - Added ACKs (thanks!)
> - Patch 2: Minor change:s/util_avail/util_str_avail/ per Niklas
> - Patch 3: removed __packed
> - Patch 3: rework various descriptions / comment blocks
> - New patch: MAINTAINERS hit to cover new files.
> 

Link to latest QEMU patchset:
https://lists.gnu.org/archive/html/qemu-devel/2020-10/msg00673.html

> Matthew Rosato (5):
>    s390/pci: stash version in the zpci_dev
>    s390/pci: track whether util_str is valid in the zpci_dev
>    vfio-pci/zdev: define the vfio_zdev header
>    vfio-pci/zdev: use a device region to retrieve zPCI information
>    MAINTAINERS: Add entry for s390 vfio-pci
> 
>   MAINTAINERS                         |   8 ++
>   arch/s390/include/asm/pci.h         |   4 +-
>   arch/s390/pci/pci_clp.c             |   2 +
>   drivers/vfio/pci/Kconfig            |  13 ++
>   drivers/vfio/pci/Makefile           |   1 +
>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>   drivers/vfio/pci/vfio_pci_private.h |  10 ++
>   drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/vfio.h           |   5 +
>   include/uapi/linux/vfio_zdev.h      | 118 ++++++++++++++++++
>   10 files changed, 410 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>   create mode 100644 include/uapi/linux/vfio_zdev.h
> 

