Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDE3272777
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 07:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725955AbfGXFov (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 01:44:51 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4388 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725894AbfGXFou (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 24 Jul 2019 01:44:50 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6O5gQ3T021204
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 01:44:49 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2txe9qxfe1-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Wed, 24 Jul 2019 01:44:49 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Wed, 24 Jul 2019 06:44:47 +0100
Received: from b06avi18878370.portsmouth.uk.ibm.com (9.149.26.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Wed, 24 Jul 2019 06:44:44 +0100
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6O5igU540436056
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Jul 2019 05:44:42 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7DD0311C050;
        Wed, 24 Jul 2019 05:44:42 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 39B9C11C052;
        Wed, 24 Jul 2019 05:44:42 +0000 (GMT)
Received: from osiris (unknown [9.152.212.134])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Wed, 24 Jul 2019 05:44:42 +0000 (GMT)
Date:   Wed, 24 Jul 2019 07:44:40 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH v2 1/1] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
References: <20190723225155.3915-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723225155.3915-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19072405-0008-0000-0000-000003003A0C
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19072405-0009-0000-0000-0000226DC921
Message-Id: <20190724054440.GA4412@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-24_02:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=553 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907240065
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 24, 2019 at 12:51:55AM +0200, Halil Pasic wrote:
> On s390 ZONE_DMA is up to 2G, i.e. ARCH_ZONE_DMA_BITS should be 31 bits.
> The current value is 24 and makes __dma_direct_alloc_pages() take a
> wrong turn first (but __dma_direct_alloc_pages() recovers then).
> 
> Let's correct ARCH_ZONE_DMA_BITS value and avoid wrong turns.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reported-by: Petr Tesarik <ptesarik@suse.cz>
> Fixes: c61e9637340e ("dma-direct: add support for allocation from ZONE_DMA and ZONE_DMA32")
> ---
>  arch/s390/include/asm/page.h | 2 ++
>  1 file changed, 2 insertions(+)

Applied, thanks!

