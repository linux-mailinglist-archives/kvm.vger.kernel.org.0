Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 675BC26AF2C
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 23:07:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgIOUbm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Sep 2020 16:31:42 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:61478 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728036AbgIOUau (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Sep 2020 16:30:50 -0400
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ2ist135652;
        Tue, 15 Sep 2020 15:18:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=jPmLWamHj5njq52hGHvp+d5qBX3n9dlTmk4CMxzTFUc=;
 b=UkWAzekDd6fxnWHKd5a8Pq5fhGD/ekoaGuDTkqaAMsiYPH69Vg+cOc84S14Ga7JIVXJA
 mJv1MJdfVRPO7ZngIIANEc1IPHz618tX8xm5UO734zBgCnB+7IKKhXlhkiWXQJhu/vKH
 sPCpL7ZcVhDrjIHt2iCKXDApnsLMal4bhSG2rcKOD8ZgrVPOwBg1t1rAeEEfAE6rwdE4
 EOMoxTvo+kxv/vqxAaY0fIv8VuynZiVqU2qIHQ7wbw3ATdqmkMJIQYkypjBD3/aKDaR1
 9wOk9nrf3+IhwhJ42WGCHFN3CNhwA3iVtF0KYyB3U1CzoezLq/mOLfh8RJ4ZTZZcrFct Uw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33k2pp1hjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:18:15 -0400
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08FJ498T140637;
        Tue, 15 Sep 2020 15:18:15 -0400
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0b-001b2d01.pphosted.com with ESMTP id 33k2pp1hjj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 15:18:15 -0400
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08FJ7O0O029380;
        Tue, 15 Sep 2020 19:18:15 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma03wdc.us.ibm.com with ESMTP id 33gny8spqe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Sep 2020 19:18:15 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08FJIDqG1835692
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 15 Sep 2020 19:18:13 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CD4AB13604F;
        Tue, 15 Sep 2020 19:18:13 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 30C3E136059;
        Tue, 15 Sep 2020 19:18:13 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 15 Sep 2020 19:18:12 +0000 (GMT)
Subject: Re: [PATCH v3] vfio iommu: Add dma available capability
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <4437b2a0-c2db-4210-305a-3397bcc18050@linux.ibm.com>
Date:   Tue, 15 Sep 2020 15:18:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600196718-23238-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-15_12:2020-09-15,2020-09-15 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0
 priorityscore=1501 spamscore=0 impostorscore=0 clxscore=1015
 mlxlogscore=939 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2006250000 definitions=main-2009150147
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/15/20 3:05 PM, Matthew Rosato wrote:
> Commit 492855939bdb ("vfio/type1: Limit DMA mappings per container") added
> a limit to the number of concurrent DMA requests for a vfio container.
> However, lazy unmapping in s390 can in fact cause quite a large number of
> outstanding DMA requests to build up prior to being purged, potentially
> the entire guest DMA space.  This results in unexpected 'VFIO_MAP_DMA
> failed: No space left on device' conditions seen in QEMU.
> 
> This patch proposes to provide the remaining number of allowable DMA
> requests via the VFIO_IOMMU_GET_INFO ioctl as a new capability.  A
> subsequent patchset to QEMU would collect this information and use it in
> s390 PCI support to tap the guest on the shoulder before overrunning the
> vfio limit.

Link to latest QEMU patchset:
https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg05505.html

> 
> Changes from v2:
> - Typos / fixed stale comment block
> 
> Matthew Rosato (1):
>    vfio iommu: Add dma available capability
> 
>   drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>   include/uapi/linux/vfio.h       | 15 +++++++++++++++
>   2 files changed, 32 insertions(+)
> 

