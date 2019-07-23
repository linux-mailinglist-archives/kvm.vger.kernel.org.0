Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9FEA871C3B
	for <lists+kvm@lfdr.de>; Tue, 23 Jul 2019 17:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732390AbfGWPwu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Jul 2019 11:52:50 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:53224 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728497AbfGWPwt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 23 Jul 2019 11:52:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=is+r8dxblNhDKZzXEGDWw1uqTuIfnmvA2uNHNQ+F5to=; b=s2nY5uuCAcKnWxU4mjttDOOje
        7rbAEudFeIwehYshWoTvjgcXy0wzo9BTlNMYfyOMOXhi2EOpPgUtoofsTBxiCmlwq1P46YMmhYfGI
        yRXilMY6iS0pViD+TIy3Syddkf4cNI5wWxzxcIRpcVynblMemsOtNcN/66yu/lBo59NJ5MgIn5zWU
        0fAEMeg7kN/52f57NR3WUS+PJN6uSorPSGCFvFOi7bB1qyl0T2SrFTKuHlQSoJjl76lAp2csXPOTk
        ZyAmBxnxhV2aPMorzg8ZKIW0LOQA9OwhnkiVdhrcv+csIW1URAGUn8Zocfhs6i/lZp4fZeLqmfFMo
        +zRfQjGOg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hpx5t-00081N-6X; Tue, 23 Jul 2019 15:52:49 +0000
Date:   Tue, 23 Jul 2019 08:52:49 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/dma: provide proper ARCH_ZONE_DMA_BITS value
Message-ID: <20190723155249.GA30643@infradead.org>
References: <20190718172120.69947-1-pasic@linux.ibm.com>
 <20190719063249.GA4852@osiris>
 <20190719130130.3ef4fa9c.pasic@linux.ibm.com>
 <20190723143226.6d929d7a.pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723143226.6d929d7a.pasic@linux.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 23, 2019 at 02:32:26PM +0200, Halil Pasic wrote:
> On Fri, 19 Jul 2019 13:01:30 +0200
> Halil Pasic <pasic@linux.ibm.com> wrote:
> 
> > > > diff --git a/arch/s390/include/asm/dma.h b/arch/s390/include/asm/dma.h
> > > > index 6f26f35d4a71..3b0329665b13 100644
> > > > --- a/arch/s390/include/asm/dma.h
> > > > +++ b/arch/s390/include/asm/dma.h
> > > > @@ -10,6 +10,7 @@
> > > >   * by the 31 bit heritage.
> > > >   */
> > > >  #define MAX_DMA_ADDRESS         0x80000000
> > > > +#define ARCH_ZONE_DMA_BITS      31  
> > > 
> > > powerpc has this in arch/powerpc/include/asm/page.h. This really
> > > should be consistently defined in the same header file across
> > > architectures.
> > > 
> > > Christoph, what is the preferred header file for this definition?
> 
> ping
> 
> Christoph could you please answer Heiko's question, so I can do my
> respin.

page.h is fine for now.  dma.h is odd for sure as it is for legacy
ISA DMA only.
