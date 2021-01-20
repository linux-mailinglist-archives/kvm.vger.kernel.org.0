Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8A902FDA87
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 21:13:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387679AbhATUMM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 15:12:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38474 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389670AbhATODU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 09:03:20 -0500
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10KE2G21075548;
        Wed, 20 Jan 2021 09:02:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BAeaN5aBw1Q1PNgOFJ8a2pj1N9pC+et+J5r+lRzxBFA=;
 b=l91Ri8xOsipANoIIycqtLBHKYLAU8Ann/AVRRpi9XQrGmmcd8rlvx06T+Qc+p22dGvQP
 TTmReR2tk1f2qkDWC0TIaZHtOZwoOE1h1pPbHzjLpfp+Q5AzHtyGKw3M81g2rKC25ua1
 Sk/dvPDeZo7EAnXo/VlFDnuzSJjyeXh0NADZcplgDMLAHanvDQLanmW9ZORZXuIFuZkP
 BuzCyk4aiLbYwFApTDkRsT2qnW1XnfXDT3QQ85gCHB0bZOVQXKTpPsLi31nAy5fEoqXW
 xQ+MFV4SmQ9LOV3Dl/9fr5JzcRstsYIwsHsCSZ74f0jqfZI+22pajxccCus48v1+IGzR RA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366nn0gk3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 09:02:31 -0500
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10KE2OfX075868;
        Wed, 20 Jan 2021 09:02:24 -0500
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366nn0gjxg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 09:02:24 -0500
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10KDvsJ6024442;
        Wed, 20 Jan 2021 14:02:13 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma01wdc.us.ibm.com with ESMTP id 3668s74k8h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 14:02:13 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10KE29RR22938058
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 14:02:09 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2A22BE051;
        Wed, 20 Jan 2021 14:02:09 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B57C8BE04F;
        Wed, 20 Jan 2021 14:02:08 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.56.144])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 14:02:08 +0000 (GMT)
Subject: Re: [PATCH 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
To:     Pierre Morel <pmorel@linux.ibm.com>, alex.williamson@redhat.com,
        cohuck@redhat.com, schnelle@linux.ibm.com
Cc:     borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
 <d44a5da8-1cb9-8b1c-ef48-caea4bda2fa8@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
Message-ID: <18cf09c6-5331-b5df-c421-aade717f9766@linux.ibm.com>
Date:   Wed, 20 Jan 2021 09:02:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <d44a5da8-1cb9-8b1c-ef48-caea4bda2fa8@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_05:2021-01-20,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 clxscore=1015
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 lowpriorityscore=0 adultscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101200079
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/20/21 4:02 AM, Pierre Morel wrote:
> 
> 
> On 1/19/21 9:02 PM, Matthew Rosato wrote:
>> Today, ISM devices are completely disallowed for vfio-pci passthrough as
>> QEMU will reject the device due to an (inappropriate) MSI-X check.
>> However, in an effort to enable ISM device passthrough, I realized 
>> that the
>> manner in which ISM performs block write operations is highly 
>> incompatible
>> with the way that QEMU s390 PCI instruction interception and
>> vfio_pci_bar_rw break up I/O operations into 8B and 4B operations -- ISM
>> devices have particular requirements in regards to the alignment, size 
>> and
>> order of writes performed.  Furthermore, they require that legacy/non-MIO
>> s390 PCI instructions are used, which is also not guaranteed when the I/O
>> is passed through the typical userspace channels.
>>
>> As a result, this patchset proposes a new VFIO region to allow a guest to
>> pass certain PCI instruction intercepts directly to the s390 host kernel
>> PCI layer for execution, pinning the guest buffer in memory briefly in
>> order to execute the requested PCI instruction.
>>
>> Changes from RFC -> v1:
>> - No functional changes, just minor commentary changes -- Re-posting 
>> along
>> with updated QEMU set.
>>
> 
> Hi,
> 
> there are is a concerns about this patch series:
> As the title says it is strongly related to ISM hardware.
> 
> Why being so specific?

Because prior investigations have shown that the region can only be 
safely used by a device type that does not implement MSI-X (use of this 
region by a vfio-pci device that has MSI-X capability interferes with 
vfio-pci MSI-X masking, since we are bypassing the typical VFIO bar 
regions and vfio-pci MSI-X masking is triggered by those region accesses).

So, in lieu of another suggestion that would overcome that issue (nobody 
has suggested anything thus far), the proposal is to limit the region's 
use to fix the specific problem at hand (ISM devices won't function 
properly if passed through).  That doesn't preclude this region from 
being used for a different device type later, but ISM is why we are 
introducing it now.


