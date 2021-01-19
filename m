Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05CED2FC19D
	for <lists+kvm@lfdr.de>; Tue, 19 Jan 2021 21:54:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390622AbhASUwy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Jan 2021 15:52:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:3742 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391692AbhASUvZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Jan 2021 15:51:25 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10JKo5gq083602;
        Tue, 19 Jan 2021 15:50:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5hJR3m5dyx8Acjc3hN/OuZwbr0iTuKoKmoHsfnRLyqI=;
 b=KJrf0xnfYnRNUzrA20RLHUBvqc902rMWej8XbGcErAUBHBvtj1N1HwlmubkD3cqguLqA
 CTn8cQ4lqpqD5ZXR/1L4gkqGnh4fVclQu/PXUux/74HliNfQ4YZ63HGsVlI/qTWnhLYy
 /rTxBpnaSeTQBHIWdNt0mwAwEyPpP4dJ5l+hXyr+IcybHcfrBIJJ95Tsq+H/sDXI6K+A
 yYmpvK5mMizWurkOR82b2/bG7Bao9Hiq7XlzOw12R1KO7zPuouUKlcJsqkwgJCfqxZP+
 28WoBgNWkE2UPoqKwDp2rQtjAgQTWXNS/y8EhgCoraXrNnWbtpniSttlEhFEZC9IDNmH dg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3666te80k0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:50:42 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10JKofb9085661;
        Tue, 19 Jan 2021 15:50:41 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3666te80jc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 15:50:41 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10JKaAvp006473;
        Tue, 19 Jan 2021 20:50:40 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 363qs90ya7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 20:50:40 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10JKocTr10355622
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 19 Jan 2021 20:50:38 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id D3BADAE063;
        Tue, 19 Jan 2021 20:50:38 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB45EAE05F;
        Tue, 19 Jan 2021 20:50:36 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue, 19 Jan 2021 20:50:36 +0000 (GMT)
Subject: Re: [PATCH 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <8b655baa-cda0-a78f-4504-649e9580c87a@linux.ibm.com>
Date:   Tue, 19 Jan 2021 15:50:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_09:2021-01-18,2021-01-19 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 priorityscore=1501 suspectscore=0 spamscore=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 bulkscore=0 clxscore=1015
 adultscore=0 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101190110
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/19/21 3:02 PM, Matthew Rosato wrote:
> Today, ISM devices are completely disallowed for vfio-pci passthrough as
> QEMU will reject the device due to an (inappropriate) MSI-X check.
> However, in an effort to enable ISM device passthrough, I realized that the
> manner in which ISM performs block write operations is highly incompatible
> with the way that QEMU s390 PCI instruction interception and
> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
> devices have particular requirements in regards to the alignment, size and
> order of writes performed.  Furthermore, they require that legacy/non-MIO
> s390 PCI instructions are used, which is also not guaranteed when the I/O
> is passed through the typical userspace channels.
> 
> As a result, this patchset proposes a new VFIO region to allow a guest to
> pass certain PCI instruction intercepts directly to the s390 host kernel
> PCI layer for execution, pinning the guest buffer in memory briefly in
> order to execute the requested PCI instruction.
> 
> Changes from RFC -> v1:
> - No functional changes, just minor commentary changes -- Re-posting along
> with updated QEMU set.
> 

Link to latest QEMU patch set:
https://lists.gnu.org/archive/html/qemu-devel/2021-01/msg04881.html

> Matthew Rosato (4):
>    s390/pci: track alignment/length strictness for zpci_dev
>    vfio-pci/zdev: Pass the relaxed alignment flag
>    s390/pci: Get hardware-reported max store block length
>    vfio-pci/zdev: Introduce the zPCI I/O vfio region
> 
>   arch/s390/include/asm/pci.h         |   4 +-
>   arch/s390/include/asm/pci_clp.h     |   7 +-
>   arch/s390/pci/pci_clp.c             |   2 +
>   drivers/vfio/pci/vfio_pci.c         |   8 ++
>   drivers/vfio/pci/vfio_pci_private.h |   6 ++
>   drivers/vfio/pci/vfio_pci_zdev.c    | 160 ++++++++++++++++++++++++++++++++++++
>   include/uapi/linux/vfio.h           |   4 +
>   include/uapi/linux/vfio_zdev.h      |  34 ++++++++
>   8 files changed, 222 insertions(+), 3 deletions(-)
> 

