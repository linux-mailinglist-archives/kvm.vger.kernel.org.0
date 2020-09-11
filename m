Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74AFD26657A
	for <lists+kvm@lfdr.de>; Fri, 11 Sep 2020 19:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgIKRD4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Sep 2020 13:03:56 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23052 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726120AbgIKRDr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Sep 2020 13:03:47 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08BH2K5u031709;
        Fri, 11 Sep 2020 13:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=P2P6SDqZs3I1gUwsNVWBn5obbiKERcCnL+qPZ5JxI3g=;
 b=OPmqlLab0fGh2ljWgyK/KzjAzoaVL12XujTMqxVmUvdzZQkrqlkBMh6IQ/CT3hI6wcuZ
 0KpR7XP8DGn9N2cWA2SvkWbSPO5IWQK9wzemkX1vZZwmeHMdVjGMUrsl/HagZ2Jrnb8j
 OlCZZkJyKeMnx7wwfn+KM7rOV4O/LKPu/LZkLWhLbG8p13q9HCXtOYtONfEUW8nzbmAg
 J9IulW5WJh5qF9x9wjuPg4S7KRU3LXxHdZ6c4jEss+OlkNsJ/1utFIvND+y/xKafBmMO
 OwvwlQGeTtR5b0c6BsXJ/VrEsM6eOebVPA5ZeV31CbJpZVMdIQcbR29JdNfuprgPu7+Z Jw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gbbk3j3b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 13:03:45 -0400
Received: from m0098417.ppops.net (m0098417.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08BH3KSs037389;
        Fri, 11 Sep 2020 13:03:45 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33gbbk3j31-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 13:03:45 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08BH2NMo023839;
        Fri, 11 Sep 2020 17:03:44 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma03dal.us.ibm.com with ESMTP id 33c2a9wpy2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 11 Sep 2020 17:03:44 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08BH3bh438601170
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 11 Sep 2020 17:03:37 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A2721C6057;
        Fri, 11 Sep 2020 17:03:42 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09D1EC605B;
        Fri, 11 Sep 2020 17:03:41 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.211.91.207])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 11 Sep 2020 17:03:41 +0000 (GMT)
Subject: Re: [PATCH] vfio iommu: Add dma limit capability
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <01caedea-9cb3-a676-6f0e-2ea872ace84e@linux.ibm.com>
Date:   Fri, 11 Sep 2020 13:03:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1599842643-2553-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-11_08:2020-09-10,2020-09-11 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 impostorscore=0 clxscore=1015 adultscore=0 mlxlogscore=999
 priorityscore=1501 mlxscore=0 bulkscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009110134
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/11/20 12:44 PM, Matthew Rosato wrote:
> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container") added
> a limit to the number of concurrent DMA requests for a vfio container.
> However, lazy unmapping in s390 can in fact cause quite a large number of
> outstanding DMA requests to build up prior to being purged, potentially
> the entire guest DMA space.  This results in unexpected 'VFIO_MAP_DMA
> failed: No space left on device' conditions seen in QEMU.
> 
> This patch proposes to provide the DMA limit via the VFIO_IOMMU_GET_INFO
> ioctl as a new capability.  A subsequent patchset to QEMU would collect
> this information and use it in s390 PCI support to tap the guest on the
> shoulder before overrunning the vfio limit.
> 

Link to the QEMU patchset:
https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg04322.html

> Matthew Rosato (1):
>    vfio iommu: Add dma limit capability
> 
>   drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>   include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>   2 files changed, 33 insertions(+)
> 

