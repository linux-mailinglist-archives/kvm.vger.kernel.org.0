Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6542B7123
	for <lists+kvm@lfdr.de>; Thu, 19 Sep 2019 03:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387460AbfISBg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 Sep 2019 21:36:28 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:12804 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbfISBg2 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 18 Sep 2019 21:36:28 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8J1O3CT166512;
        Wed, 18 Sep 2019 21:36:20 -0400
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v3ve0wqb2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 21:36:20 -0400
Received: from m0098420.ppops.net (m0098420.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id x8J1PStb169475;
        Wed, 18 Sep 2019 21:36:20 -0400
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2v3ve0wqar-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 Sep 2019 21:36:20 -0400
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8J1QRUQ002729;
        Thu, 19 Sep 2019 01:36:19 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02wdc.us.ibm.com with ESMTP id 2v3vbtsgxc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 19 Sep 2019 01:36:19 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8J1aF2t58655170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 19 Sep 2019 01:36:15 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4ABB6BE058;
        Thu, 19 Sep 2019 01:36:15 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39503BE051;
        Thu, 19 Sep 2019 01:36:13 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.85.141.73])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Thu, 19 Sep 2019 01:36:13 +0000 (GMT)
Subject: Re: [PATCH v4 0/4] Retrieving zPCI specific info with VFIO
To:     sebott@linux.ibm.com
Cc:     gerald.schaefer@de.ibm.com, pasic@linux.ibm.com,
        borntraeger@de.ibm.com, walling@linux.ibm.com,
        linux-s390@vger.kernel.org, iommu@lists.linux-foundation.org,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        alex.williamson@redhat.com, kvm@vger.kernel.org,
        heiko.carstens@de.ibm.com, robin.murphy@arm.com, gor@linux.ibm.com,
        cohuck@redhat.com, pmorel@linux.ibm.com
References: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Openpgp: preference=signencrypt
Message-ID: <b4af47c1-0dc1-938d-20e4-0eeca095a7d5@linux.ibm.com>
Date:   Wed, 18 Sep 2019 21:36:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1567815231-17940-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-19_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909190010
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping

On 9/6/19 8:13 PM, Matthew Rosato wrote:
> Note: These patches by Pierre got lost in the ether a few months back
> as he has been unavailable to carry them forward.  I've made changes
> based upon comments received on his last version.
> 
> We define a new configuration entry for VFIO/PCI, VFIO_PCI_ZDEV
> to configure access to a zPCI region dedicated for retrieving
> zPCI features.
> 
> When the VFIO_PCI_ZDEV feature is configured we initialize
> a new device region, VFIO_REGION_SUBTYPE_ZDEV_CLP, to hold
> the information from the ZPCI device the userland needs to
> give to a guest driving the zPCI function.
> 
> 
> Note that in the current state we do not use the CLP instructions
> to access the firmware but get the information directly from
> the zdev device.
> 
> -This means that the patch 1, "s390: pci: Exporting access to CLP PCI
> function and PCI group" is not used and can be let out of this series
> without denying the good working of the other patches.
> - But we will need this later, eventually in the next iteration
>   to retrieve values not being saved inside the zdev structure.
>   like maxstbl and the PCI supported version
> 
> To share the code with arch/s390/pci/pci_clp.c the original functions
> in pci_clp.c to query PCI functions and PCI functions group are
> modified so that they can be exported.
> 
> A new function clp_query_pci() replaces clp_query_pci_fn() and
> the previous calls to clp_query_pci_fn() and clp_query_pci_fngrp()
> are replaced with calls to zdev_query_pci_fn() and zdev_query_pci_fngrp()
> using a zdev pointer as argument.
> 
> Changes since v3:
> - New patch: define maxstbl
> - Remove CLP_UTIL_STR_LEN references from uapi header
> - Fix broken ifdef CONFIG_VFIO_PCI_ZDEV
> - Change Kconfig option from tristate to bool
> - Remove VFIO_REGION_TYPE_IBM_ZDEV, move VFIO_REGION_SUBTYPE_ZDEV_CLP to a 1014 subtype
> - reject iswrite in .rw callback
> - Remove rw restriction on identical buffer sizes
> - Allow arbitrary sized read
> 
> Pierre Morel (4):
>   s390: pci: Exporting access to CLP PCI function and PCI group
>   s390: pci: Define the maxstbl CLP response entry
>   vfio: zpci: defining the VFIO headers
>   vfio: pci: Using a device region to retrieve zPCI information
> 
>  arch/s390/include/asm/pci.h         |  3 ++
>  arch/s390/include/asm/pci_clp.h     |  2 +-
>  arch/s390/pci/pci_clp.c             | 71 ++++++++++++++++---------------
>  drivers/vfio/pci/Kconfig            |  7 +++
>  drivers/vfio/pci/Makefile           |  1 +
>  drivers/vfio/pci/vfio_pci.c         |  9 ++++
>  drivers/vfio/pci/vfio_pci_private.h | 10 +++++
>  drivers/vfio/pci/vfio_pci_zdev.c    | 85 +++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/vfio.h           |  1 +
>  include/uapi/linux/vfio_zdev.h      | 35 +++++++++++++++
>  10 files changed, 189 insertions(+), 35 deletions(-)
>  create mode 100644 drivers/vfio/pci/vfio_pci_zdev.c
>  create mode 100644 include/uapi/linux/vfio_zdev.h
> 

