Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D271270F32
	for <lists+kvm@lfdr.de>; Sat, 19 Sep 2020 17:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgISPud (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Sep 2020 11:50:33 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:41128 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726434AbgISPuc (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 19 Sep 2020 11:50:32 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08JF2ZZX011945;
        Sat, 19 Sep 2020 11:50:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=rRF4tk9fIejtWiYVZk6Exl4Zucnt+GVESr+b7iU8Ylw=;
 b=iijrKqWoxI27o8rTEXdTaqapqB7n6K87zL6fqEiOXCByl4Aqv9I2D5jF485JBTfJVkZb
 ESU8q68cJZ8545AvdXHZbonEUOGFcgVh13WhDQoRDrZifYQSOxpSDvPa2INHAQO44HzN
 IIcgEeCbxJ/n6BmPVVe1Qgbp8Hi0uz878wPsXLdc+FVlqdUtVQnovo56PuXewKP1pyE5
 tSGF+d9pkEbJyRzxb1yNYJJUP6FgdMx6l6uu4akPIfYKYLSCN40ICguD2tQstaqmuWWe
 2yk53CzYiFB5XhZ30xmJl6C1wQXjVKceC1LcJszEFVxnZvU4EK6VOCHTwSv+0fFzATo5 gQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ngh94nrq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:50:32 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08JFoV3Q008163;
        Sat, 19 Sep 2020 11:50:31 -0400
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33ngh94nrh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 11:50:31 -0400
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08JFkoh8024589;
        Sat, 19 Sep 2020 15:50:31 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma02dal.us.ibm.com with ESMTP id 33n9m8c3kq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 19 Sep 2020 15:50:31 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08JFoTvC54264162
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 19 Sep 2020 15:50:29 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0AD1EAE05C;
        Sat, 19 Sep 2020 15:50:29 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A70C2AE062;
        Sat, 19 Sep 2020 15:50:26 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.74.107])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Sat, 19 Sep 2020 15:50:26 +0000 (GMT)
Subject: Re: [PATCH 0/4] Pass zPCI hardware information via VFIO
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <1f47cab8-af05-494f-1cf0-7b6d126e6367@linux.ibm.com>
Date:   Sat, 19 Sep 2020 11:50:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600529318-8996-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-19_05:2020-09-16,2020-09-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxlogscore=999 lowpriorityscore=0 suspectscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 impostorscore=0 adultscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009190131
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/19/20 11:28 AM, Matthew Rosato wrote:
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

QEMU patchset that exploits the new region:
https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg07076.html

> 
> Matthew Rosato (4):
>    s390/pci: stash version in the zpci_dev
>    s390/pci: track whether util_str is valid in the zpci_dev
>    vfio-pci/zdev: define the vfio_zdev header
>    vfio-pci/zdev: use a device region to retrieve zPCI information
> 
>   arch/s390/include/asm/pci.h         |   4 +-
>   arch/s390/pci/pci_clp.c             |   2 +
>   drivers/vfio/pci/Kconfig            |  13 ++
>   drivers/vfio/pci/Makefile           |   1 +
>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>   drivers/vfio/pci/vfio_pci_private.h |  10 ++
>   drivers/vfio/pci/vfio_pci_zdev.c    | 242 ++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/vfio.h           |   5 +
>   include/uapi/linux/vfio_zdev.h      | 116 +++++++++++++++++
>   9 files changed, 400 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>   create mode 100644 include/uapi/linux/vfio_zdev.h
> 

