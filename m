Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD3BF6E105
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 08:33:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726076AbfGSGc7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 02:32:59 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:22990 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727102AbfGSGc7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jul 2019 02:32:59 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6J6Rk9U139973
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 02:32:58 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tu762v0qb-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 02:32:57 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <heiko.carstens@de.ibm.com>;
        Fri, 19 Jul 2019 07:32:55 +0100
Received: from b06cxnps4074.portsmouth.uk.ibm.com (9.149.109.196)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 07:32:52 +0100
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6J6Wp7I51118114
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 06:32:51 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1020EA405F;
        Fri, 19 Jul 2019 06:32:51 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2EA1A405B;
        Fri, 19 Jul 2019 06:32:50 +0000 (GMT)
Received: from osiris (unknown [9.152.212.134])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 19 Jul 2019 06:32:50 +0000 (GMT)
Date:   Fri, 19 Jul 2019 08:32:49 +0200
From:   Heiko Carstens <heiko.carstens@de.ibm.com>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
References: <20190718172120.69947-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718172120.69947-1-pasic@linux.ibm.com>
X-TM-AS-GCONF: 00
x-cbid: 19071906-4275-0000-0000-0000034EAD30
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071906-4276-0000-0000-0000385EC843
Message-Id: <20190719063249.GA4852@osiris>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=720 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190071
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 18, 2019 at 07:21:20PM +0200, Halil Pasic wrote:
> On s390 ZONE_DMA is up to 2G, i.e. ARCH_ZONE_DMA_BITS should be 31 bits.
> The current value is 24 and makes __dma_direct_alloc_pages() take a
> wrong turn first (but __dma_direct_alloc_pages() recovers then).
> 
> Let's correct ARCH_ZONE_DMA_BITS value and avoid wrong turns.
> 
> Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> Reported-by: Petr Tesarik <ptesarik@suse.cz>
> Fixes: c61e9637340e ("dma-direct: add support for allocation from
> ZONE_DMA and ZONE_DMA32")

Please don't add linebreaks to "Fixes:" tags.

> ---
>  arch/s390/include/asm/dma.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
> index 6f26f35d4a71..3b0329665b13 100644
> --- a/arch/s390/include/asm/dma.h
> +++ b/arch/s390/include/asm/dma.h
> @@ -10,6 +10,7 @@
>   * by the 31 bit heritage.
>   */
>  #define MAX_DMA_ADDRESS         0x80000000
> +#define ARCH_ZONE_DMA_BITS      31

powerpc has this in arch/powerpc/include/asm/page.h. This really
should be consistently defined in the same header file across
architectures.

Christoph, what is the preferred header file for this definition?

I'd also rather say it would be better to move the #ifndef ARCH_ZONE_DMA_BITS
check to a common code header file instead of having it in a C file, and
make it more obvious in which header file architectures should/can override
the default, no?

