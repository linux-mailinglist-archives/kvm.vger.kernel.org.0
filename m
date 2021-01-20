Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B04A2FCD1C
	for <lists+kvm@lfdr.de>; Wed, 20 Jan 2021 10:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728120AbhATJEh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Jan 2021 04:04:37 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15456 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbhATJDo (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 20 Jan 2021 04:03:44 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10K91kRv070532;
        Wed, 20 Jan 2021 04:03:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=WTDZ9aYsWOWABpjc4bX1QkrE9uWJbUYyZ6lhbsp3NbM=;
 b=UXwmT+kNQHqdA2kllHP7p1VOhnhXBbQ9/qOSm8xpjG0hplwAlbArPGLAJFdfax4wHf05
 Vj06ithKjHqeVbIf+KTmswjupgvfLY6hAUm72nTec36+5GEl3ooYTJTZlymFImgv2J1c
 GO5CrR8gpjUooqreEfaF5GoEj7JYGFLlYRme873NyGnnPZ1oqIAq0iaVwYjcwZOkENGf
 fdVEMv2W587TPerlR4Zj39va90sDVdCTUaI1S1ul5EGaWbRRhm6UVbIzSLrahgg4F2fq
 lV3qRrABXP4LMe+hRDUuBlMxtAEMENRotw4t/TiGsNuVtnPI/DSOujHDa9XG3MOxZjAn YA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366ff73bgb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 04:03:02 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10K92jkh073694;
        Wed, 20 Jan 2021 04:02:45 -0500
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 366ff73awh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 04:02:44 -0500
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10K8qfr7009557;
        Wed, 20 Jan 2021 09:02:12 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma06ams.nl.ibm.com with ESMTP id 3668nwrctt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 20 Jan 2021 09:02:12 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10K929Xe40567204
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 20 Jan 2021 09:02:09 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 314914C05A;
        Wed, 20 Jan 2021 09:02:09 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A49314C046;
        Wed, 20 Jan 2021 09:02:08 +0000 (GMT)
Received: from oc3016276355.ibm.com (unknown [9.145.39.155])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 20 Jan 2021 09:02:08 +0000 (GMT)
Subject: Re: [PATCH 0/4] vfio-pci/zdev: Fixing s390 vfio-pci ISM support
To:     Matthew Rosato <mjrosato@linux.ibm.com>,
        alex.williamson@redhat.com, cohuck@redhat.com,
        schnelle@linux.ibm.com
Cc:     borntraeger@de.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        gerald.schaefer@linux.ibm.com, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
From:   Pierre Morel <pmorel@linux.ibm.com>
Message-ID: <d44a5da8-1cb9-8b1c-ef48-caea4bda2fa8@linux.ibm.com>
Date:   Wed, 20 Jan 2021 10:02:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <1611086550-32765-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-20_02:2021-01-18,2021-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 clxscore=1011 mlxscore=0 suspectscore=0 phishscore=0 spamscore=0
 impostorscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2009150000 definitions=main-2101200049
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 1/19/21 9:02 PM, Matthew Rosato wrote:
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

Hi,

there are is a concerns about this patch series:
As the title says it is strongly related to ISM hardware.

Why being so specific?

Regards,
Pierre

-- 
Pierre Morel
IBM Lab Boeblingen
