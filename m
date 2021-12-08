Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0CA46D664
	for <lists+kvm@lfdr.de>; Wed,  8 Dec 2021 16:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbhLHPI2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 Dec 2021 10:08:28 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10024 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235616AbhLHPIW (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 8 Dec 2021 10:08:22 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1B8ErGRc017260;
        Wed, 8 Dec 2021 15:04:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=5ZzGJFNHOId4Fg8Lm8qhIqr7WLjSOU+9kIfRCaUQ4Ck=;
 b=nH1KyjX0pXYieqXIUNScTM1kvGu0IGoNrSdSZxe8T0ld6i7kjjC9nHSHqNRs9ewhQFpJ
 BzEyOyFTOipR41W+Q61CJJ0FK5pP3TYYosqnw8HVy6ygqIPcJINJyw21Un0lSOdz2owI
 n2U5HjKmurGUX27sBMgr9hHLmaaxwoQi6f9MbZEfHMYHQGHkeLf9lm0dBEOjmeuiR1bz
 CngrVawlhZsn3DhOn9MAQwrN7ouS7Jl6Hn04is0WG9tDrJ1uXN1jn/GI2Rx4jFYyoDnI
 MGF5ZIiGw7v6/dTkTx3RJuMum05KK3gRlhM0a4/nieg15l6aP3y0x63EYJIphSKBbhXl zg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctxv688pe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:04:49 +0000
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1B8EvCwp028277;
        Wed, 8 Dec 2021 15:04:49 GMT
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ctxv688p0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:04:48 +0000
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1B8Elsxv017866;
        Wed, 8 Dec 2021 15:04:47 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma04wdc.us.ibm.com with ESMTP id 3cqyyb3nxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 08 Dec 2021 15:04:47 +0000
Received: from b01ledav003.gho.pok.ibm.com (b01ledav003.gho.pok.ibm.com [9.57.199.108])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1B8F4k3t27001156
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 8 Dec 2021 15:04:46 GMT
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EA9D6B2066;
        Wed,  8 Dec 2021 15:04:45 +0000 (GMT)
Received: from b01ledav003.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 60D9DB206C;
        Wed,  8 Dec 2021 15:04:38 +0000 (GMT)
Received: from [9.211.152.43] (unknown [9.211.152.43])
        by b01ledav003.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  8 Dec 2021 15:04:37 +0000 (GMT)
Message-ID: <97f867f3-d582-c8d2-9336-98a92d184961@linux.ibm.com>
Date:   Wed, 8 Dec 2021 10:04:36 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH 20/32] KVM: s390: pci: provide routines for
 enabling/disabling interpretation
Content-Language: en-US
To:     Niklas Schnelle <schnelle@linux.ibm.com>,
        linux-s390@vger.kernel.org
Cc:     alex.williamson@redhat.com, cohuck@redhat.com,
        farman@linux.ibm.com, pmorel@linux.ibm.com,
        borntraeger@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, agordeev@linux.ibm.com,
        frankja@linux.ibm.com, david@redhat.com, imbrenda@linux.ibm.com,
        vneethv@linux.ibm.com, oberpar@linux.ibm.com, freude@linux.ibm.com,
        thuth@redhat.com, pasic@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211207205743.150299-1-mjrosato@linux.ibm.com>
 <20211207205743.150299-21-mjrosato@linux.ibm.com>
 <8c2f83d2186e93965eba74356126df7fd35d9a41.camel@linux.ibm.com>
From:   Matthew Rosato <mjrosato@linux.ibm.com>
In-Reply-To: <8c2f83d2186e93965eba74356126df7fd35d9a41.camel@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VYcW3kS46ytNN2s9cpT_PSjtLMj7etNf
X-Proofpoint-ORIG-GUID: N3yFQjtM4d6m7eWHLPpL1QjRC_br2zB6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-08_06,2021-12-08_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 spamscore=0 clxscore=1015
 suspectscore=0 lowpriorityscore=0 impostorscore=0 phishscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112080093
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/8/21 4:44 AM, Niklas Schnelle wrote:
> On Tue, 2021-12-07 at 15:57 -0500, Matthew Rosato wrote:
>> These routines will be wired into the vfio_pci_zdev ioctl handlers to
>> respond to requests to enable / disable a device for zPCI Load/Store
>> interpretation.
>>
>> The first time such a request is received, enable the necessary facilities
>> for the guest.
>>
>> Signed-off-by: Matthew Rosato <mjrosato@linux.ibm.com>
>> ---
>>   arch/s390/include/asm/kvm_pci.h |  4 ++
>>   arch/s390/kvm/pci.c             | 91 +++++++++++++++++++++++++++++++++
>>   arch/s390/pci/pci.c             |  3 ++
>>   3 files changed, 98 insertions(+)
>>
>> diff --git a/arch/s390/include/asm/kvm_pci.h b/arch/s390/include/asm/kvm_pci.h
>> index 3e491a39704c..5d6283acb54c 100644
>> --- a/arch/s390/include/asm/kvm_pci.h
>>
> ---8<---
>> 		return rc;
>> +	}
>> +
>> +	/*
>> +	 * Store information about the identity of the kvm guest allowed to
>> +	 * access this device via interpretation to be used by host CLP
>> +	 */
>> +	zdev->gd = gd;
>> +
>> +	rc = zpci_enable_device(zdev);
>> +	if (rc)
>> +		goto err;
>> +
>> +	/* Re-register the IOMMU that was already created */
>> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
>> +				(u64)zdev->dma_table);
> 
> The zdev->dma_table is a virtual address but we need an absolute
> address in the MPCIFC so the above should use
> virt_to_phys(zdev->dma_table) to be compatible with future V != R
> kernel memory. As of now since virtual and absolute kernel addresses
> are the same this is not a bug and we've had this (wrong) pattern in
> the rest of the code but let's get it righht here from the start.
> 
> See also my commit "s390/pci: use physical addresses in DMA tables"
> that is currently in the s390 feature branch.

You're right of course -- I saw those changes happening as I prepared 
this series but I didn't want to delay getting comments any longer, what 
with the holidays approaching.  Of course, I didn't realize they were 
already out on the feature branch.

I suspect there is some more of this also in the code related to 
handling RPCIT.  AEN setup too.

> 
>> +	if (rc)
>> +		goto err;
>> +
>> +	return rc;
>> +
>> +err:
>> +	zdev->gd = 0;
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_enable);
>> +
>> +int kvm_s390_pci_interp_disable(struct zpci_dev *zdev)
>> +{
>> +	int rc;
>> +
>> +	if (zdev->gd == 0)
>> +		return -EINVAL;
>> +
>> +	/* Remove the host CLP guest designation */
>> +	zdev->gd = 0;
>> +
>> +	if (zdev_enabled(zdev)) {
>> +		rc = zpci_disable_device(zdev);
>> +		if (rc)
>> +			return rc;
>> +	}
>> +
>> +	rc = zpci_enable_device(zdev);
>> +	if (rc)
>> +		return rc;
>> +
>> +	/* Re-register the IOMMU that was already created */
>> +	rc = zpci_register_ioat(zdev, 0, zdev->start_dma, zdev->end_dma,
>> +				(u64)zdev->dma_table);
> 
> Same as above
> 
>> +
>> +	return rc;
>> +}
>> +EXPORT_SYMBOL_GPL(kvm_s390_pci_interp_disable);
>> +
>>
> ---8<---
> 

