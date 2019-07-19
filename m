Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 971246E4A5
	for <lists+kvm@lfdr.de>; Fri, 19 Jul 2019 13:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727546AbfGSLCD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jul 2019 07:02:03 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:19462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726075AbfGSLCD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 19 Jul 2019 07:02:03 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6JAwYDt019971
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 07:02:02 -0400
Received: from e06smtp05.uk.ibm.com (e06smtp05.uk.ibm.com [195.75.94.101])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2tuanqnab2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <kvm@vger.kernel.org>; Fri, 19 Jul 2019 07:01:50 -0400
Received: from localhost
        by e06smtp05.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <kvm@vger.kernel.org> from <pasic@linux.ibm.com>;
        Fri, 19 Jul 2019 12:01:36 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp05.uk.ibm.com (192.168.101.135) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 19 Jul 2019 12:01:33 +0100
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x6JB1VTh41812050
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Jul 2019 11:01:31 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C551042047;
        Fri, 19 Jul 2019 11:01:31 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8671F42049;
        Fri, 19 Jul 2019 11:01:31 +0000 (GMT)
Received: from oc2783563651 (unknown [9.152.224.184])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 19 Jul 2019 11:01:31 +0000 (GMT)
Date:   Fri, 19 Jul 2019 13:01:30 +0200
From:   Halil Pasic <pasic@linux.ibm.com>
To:     Heiko Carstens <heiko.carstens@de.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
In-Reply-To: <20190719063249.GA4852@osiris>
References: <20190718172120.69947-1-pasic@linux.ibm.com>
        <20190719063249.GA4852@osiris>
Organization: IBM
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
x-cbid: 19071911-0020-0000-0000-0000035557B7
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19071911-0021-0000-0000-000021A9344B
Message-Id: <20190719130130.3ef4fa9c.pasic@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-19_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=782 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907190128
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 19 Jul 2019 08:32:49 +0200
Heiko Carstens <heiko.carstens@de.ibm.com> wrote:

> On Thu, Jul 18, 2019 at 07:21:20PM +0200, Halil Pasic wrote:
> > On s390 ZONE_DMA is up to 2G, i.e. ARCH_ZONE_DMA_BITS should be 31 bits.
> > The current value is 24 and makes __dma_direct_alloc_pages() take a
> > wrong turn first (but __dma_direct_alloc_pages() recovers then).
> > 
> > Let's correct ARCH_ZONE_DMA_BITS value and avoid wrong turns.
> > 
> > Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
> > Reported-by: Petr Tesarik <ptesarik@suse.cz>
> > Fixes: c61e9637340e ("dma-direct: add support for allocation from
> > ZONE_DMA and ZONE_DMA32")
> 
> Please don't add linebreaks to "Fixes:" tags.
> 

Will remember that, thanks! I was not aware of the rule and checkpatch
did not complain. 

> > ---
> >  arch/s390/include/asm/dma.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
> > index 6f26f35d4a71..3b0329665b13 100644
> > --- a/arch/s390/include/asm/dma.h
> > +++ b/arch/s390/include/asm/dma.h
> > @@ -10,6 +10,7 @@
> >   * by the 31 bit heritage.
> >   */
> >  #define MAX_DMA_ADDRESS         0x80000000
> > +#define ARCH_ZONE_DMA_BITS      31
> 
> powerpc has this in arch/powerpc/include/asm/page.h. This really
> should be consistently defined in the same header file across
> architectures.
> 
> Christoph, what is the preferred header file for this definition?
> 
> I'd also rather say it would be better to move the #ifndef ARCH_ZONE_DMA_BITS
> check to a common code header file instead of having it in a C file, and
> make it more obvious in which header file architectures should/can override
> the default, no?

+1

I will wait for Christoph's answer with a respin. Thanks for having a
look.

Regards,
Halil

