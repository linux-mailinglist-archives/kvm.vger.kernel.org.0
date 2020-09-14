Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A874269903
	for <lists+kvm@lfdr.de>; Tue, 15 Sep 2020 00:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgINWhh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 14 Sep 2020 18:37:37 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:23034 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725961AbgINWhg (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 14 Sep 2020 18:37:36 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 08EMYbDV187332;
        Mon, 14 Sep 2020 18:37:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : from : to : cc
 : references : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=x7AjuG8Qft3/lurL5MWEK1nTbf6pvAgQIIFcyHHETp4=;
 b=aIox2N7gp00I16Ai9hd+K77VN1iQuXlscWHNtEuCYvrN5qcq/IE/ouXu7L1XHmSEhFbU
 n1I/O4DVFWezonQ6nwQDaAzONK624I0ifV7StSEmoWOtmiNqR6zukPapeYrzegcc7F5Y
 jKNQE/FdaXD6DtODCAo3F5BwWaQY9Vrr/CctRJzQsrT5W/pKwd6caliYx0G31VHQQixX
 yokrKeh47sc3/AP21UoJY4TgEjViE9FxvBulmbwoZVN19rXyLFCfwgL5Kh260+0AXD7W
 mpRAIAzfmx/f/NEiGjn1OK6zAgXL2sXRCgACMzwOHwGYUBrKYJH+SABzSWTJPPMzGPAm yA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jfm02fuk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:37:34 -0400
Received: from m0127361.ppops.net (m0127361.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 08EMbX71192273;
        Mon, 14 Sep 2020 18:37:33 -0400
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 33jfm02egv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 18:34:48 -0400
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 08EMWMiS024711;
        Mon, 14 Sep 2020 22:32:44 GMT
Received: from b03cxnp07029.gho.boulder.ibm.com (b03cxnp07029.gho.boulder.ibm.com [9.17.130.16])
        by ppma04dal.us.ibm.com with ESMTP id 33gny8yt36-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Sep 2020 22:32:44 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07029.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 08EMWgjc37290422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Sep 2020 22:32:42 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CA592BE054;
        Mon, 14 Sep 2020 22:32:42 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0816CBE04F;
        Mon, 14 Sep 2020 22:32:42 +0000 (GMT)
Received: from oc4221205838.ibm.com (unknown [9.163.85.51])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Mon, 14 Sep 2020 22:32:41 +0000 (GMT)
Subject: Re: [PATCH v2] vfio iommu: Add dma available capability
From:   Matthew Rosato <mjrosato@linux.ibm.com>
To:     alex.williamson@redhat.com, cohuck@redhat.com
Cc:     pmorel@linux.ibm.com, schnelle@linux.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
Message-ID: <4ee4a697-6b92-f4e8-79a3-5d131249748a@linux.ibm.com>
Date:   Mon, 14 Sep 2020 18:32:41 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <1600122331-12181-1-git-send-email-mjrosato@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-09-14_09:2020-09-14,2020-09-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 adultscore=0
 impostorscore=0 spamscore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=931 lowpriorityscore=0 malwarescore=0 phishscore=0
 clxscore=1015 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009140170
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/14/20 6:25 PM, Matthew Rosato wrote:
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

Link to associated v2 QEMU patchset:
https://lists.gnu.org/archive/html/qemu-devel/2020-09/msg05067.html

> 
> Changes from v1:
> - Report dma_avail instead of the limit, which might not have been accurate
>    anyway
> - Text/naming changes throughout due to the above
> 
> Matthew Rosato (1):
>    vfio iommu: Add dma available capability
> 
>   drivers/vfio/vfio_iommu_type1.c | 17 +++++++++++++++++
>   include/uapi/linux/vfio.h       | 16 ++++++++++++++++
>   2 files changed, 33 insertions(+)
> 

