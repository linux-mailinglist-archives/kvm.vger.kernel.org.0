Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4341368A8D
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:29:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730303AbfGON3b (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:29:31 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35960 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730134AbfGON3a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZyoOvmVi7Du/ofy7SZvI/5JqSK1HykWuFytKnKZrtmY=; b=Gh8IZW66NCwDYBygeA3s0uAQW
        CtnRs3l7gjwcozOfiPih5DP/hNr4W+ohpJ/pqORl9ceRWpjhcI8kejJ6o4iRJsMOaNv/1NiEVX2Ib
        xgJ8T5brrAccOOGA1tA/dkvXNaEleI7QE+m5ogqE4qKyOqWZcC1hndqg/Kw4azYCJgpTXRmVWTH9X
        qyqcwY/qV7RGHtibAcjZPi/YOwSnDjgF3Yr6Pe6vX9Vc8f/m63xhnEpEr90JF0Pc32PXg11JANkDw
        wSQRdYy7D4bw8YOnvMsYnFeZGmpgN94TBKbdToZs7vAkMlPzTFJ3Dc86nUzeHDHsildX1Se2EsqBF
        ORqlr4Tww==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hn12n-0008Rx-2n; Mon, 15 Jul 2019 13:29:29 +0000
Date:   Mon, 15 Jul 2019 06:29:29 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Halil Pasic <pasic@linux.ibm.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Message-ID: <20190715132929.GA32348@infradead.org>
References: <20190715131719.100650-1-pasic@linux.ibm.com>
 <20190715132027.GA18357@infradead.org>
 <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e393b48-4165-e1d4-0450-e52dd914a3cd@amd.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 15, 2019 at 01:28:19PM +0000, Lendacky, Thomas wrote:
> On 7/15/19 8:20 AM, Christoph Hellwig wrote:
> > This looks good to me - if you and Tom are fine with it I'd like to
> > fold it into his commit so that what I'll send to Linus is bisection
> > clean.
> 
> I'm ok with folding it in. Sorry about missing that.

The s390 changes were queued up in a different tree for 5.2, so you
had no easy way of noticing this.
