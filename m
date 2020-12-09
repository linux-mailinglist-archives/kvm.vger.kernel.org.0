Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BB22D4C3D
	for <lists+kvm@lfdr.de>; Wed,  9 Dec 2020 21:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732549AbgLIUxb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Dec 2020 15:53:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:5624 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726227AbgLIUxb (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Dec 2020 15:53:31 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0B9KWXIf021859;
        Wed, 9 Dec 2020 15:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=10ioeuJE2bkIm5pz7lZv+a8MyIhqu9LDDDbuOWf3B44=;
 b=JV9ylOWsAq310dSSCBQWT7GzkjabPwzoaG1fErUCfQQxJidadMDUgTT0b2JL6FMDGl9b
 jI+5OfQaHVAIZT7WHwplqvVN6Ri7C9inUjnTzlQ6ukHA8Lv9uHX57gwJ04kF+7IdXSkD
 Il9rrx2gPdU3rP8/q268YDv3KCsBs0NhM5XO03vLufwmMe5VnJDjRCHWZ2nvo+paG7T8
 cNK1jtriDcVyoUv3ysHsu15b3xNw9UT5gL0zRx7XeO215ClTMMgn4kG7GydUKgF5fExu
 j9kSxGESLhyzPFWESOtnKHxpsq0NcvINaVk5Ss2S7aygm0BFH/ywWfTfobVEFbk6m8BK 7g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ayxnc2fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:52:50 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0B9Kph8f104760;
        Wed, 9 Dec 2020 15:52:50 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35ayxnc2f9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 15:52:49 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0B9Kl1RD004138;
        Wed, 9 Dec 2020 20:52:49 GMT
Received: from b01cxnp23033.gho.pok.ibm.com (b01cxnp23033.gho.pok.ibm.com [9.57.198.28])
        by ppma04dal.us.ibm.com with ESMTP id 3581u9u0b1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Dec 2020 20:52:49 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp23033.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0B9KqlVB32768278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 9 Dec 2020 20:52:47 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F2880112061;
        Wed,  9 Dec 2020 20:52:46 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A686112062;
        Wed,  9 Dec 2020 20:52:44 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.37.122])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  9 Dec 2020 20:52:44 +0000 (GMT)
Subject: Re: [RFC 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     pmorel@linux.ibm.com, borntraeger@de.ibm.com, hca@linux.ibm.com,
        gor@linux.ibm.com, gerald.schaefer@linux.ibm.com,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <765a8b73-a879-ea96-d13e-8fd574b363be@linux.ibm.com>
Date:   Wed, 9 Dec 2020 15:52:43 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1607545670-1557-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-09_16:2020-12-09,2020-12-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 spamscore=0 lowpriorityscore=0 phishscore=0 impostorscore=0
 adultscore=0 suspectscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012090140
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/9/20 3:27 PM, Matthew Rosato wrote:
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
> PCI layer for exeuction, pinning the guest buffer in memory briefly in
> order to execute the requested PCI instruction.
> 
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
>   include/uapi/linux/vfio_zdev.h      |  33 ++++++++
>   8 files changed, 221 insertions(+), 3 deletions(-)
> 

Associated qemu patchset:
https://lists.gnu.org/archive/html/qemu-devel/2020-12/msg02377.html

