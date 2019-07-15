Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FEE068A56
	for <lists+kvm@lfdr.de>; Mon, 15 Jul 2019 15:20:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfGONU3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jul 2019 09:20:29 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:33492 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbfGONU2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jul 2019 09:20:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5GKp/zZJv2OBI15GLElegzasJaV4QF+dIc/5Z2PrD2w=; b=WlYJgXKZxw0Y8a0MTzAiXVlFX
        +msA7HSB5ND0JG2kG/g5cCw9gMI9sTfpeKUD6PvnDNrwFmHIlGdx12LcfADl+JXjjoJHkmggZVlP5
        YYhDOgrIBj9o1z60COQlNX5kNZqvHUBVnJoiXRr5RxEJb7EPhdUPolZDquaKeFFTtlZV/ek0/Rt/4
        tSJIQfmdmSqLYXWmBJ5XXdtaLvFadWYVhPHsUT0LNbYk1hnlYISsHWbO7JaJ0T4PEg8rivbBmIw4C
        bPywGudp6PN3ApSbFQMXhYAoSOAxscFlqE5Oc3leSEfc0GhEZsrKIipFz9sb4BoaQx2Abz1p/b+25
        82ZxH0kVw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hn0u3-0006Bf-MA; Mon, 15 Jul 2019 13:20:27 +0000
Date:   Mon, 15 Jul 2019 06:20:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Halil Pasic <pasic@linux.ibm.com>
Cc:     kvm@vger.kernel.org, linux-s390@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>
Subject: Re: [PATCH 1/1] s390/protvirt: restore force_dma_unencrypted()
Message-ID: <20190715132027.GA18357@infradead.org>
References: <20190715131719.100650-1-pasic@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190715131719.100650-1-pasic@linux.ibm.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This looks good to me - if you and Tom are fine with it I'd like to
fold it into his commit so that what I'll send to Linus is bisection
clean.

> Note: we still need sev_active() defined because of the reference
> in fs/core/vmcore, but this one is likely to go away soon along
> with the need for an s390 sev_active().

Any chance we could not change the return value from the function
at least in this patch/fold as that change seems unrelated to the
dma functionality.  If that is what you really wanted and only
the dma code was in the way we can happily merge it as a separate
patch, of couse.
