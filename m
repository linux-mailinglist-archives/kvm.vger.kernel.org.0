Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 635BDE58C8
	for <lists+kvm@lfdr.de>; Sat, 26 Oct 2019 07:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbfJZFdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 26 Oct 2019 01:33:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50504 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbfJZFdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 26 Oct 2019 01:33:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rBFZM3Rm7F2y0bq2NvCIIQKubp4uvyGCLsoRcmsizGo=; b=gkngM0TLz8m0hzgQ5czLiVB6i
        2632tiJPfM/BaQ31vYmEZyQLaIfKETslrkSwJnCpYhjTkuYt/5W274FTZsSlRpIIE+SyQiGbSpXm7
        rw4xiO/zzqzWLQ3sdYSw9PfClT66v7FgyzK3JUM3Qb8ZsFZxjw8msi4aDENNDPcBE7PSJ3zcKoDiX
        +sTpkpqTpQZ+k4i8zgpwwhPWioOccVKXoYLjI25B3h56G7Y/lpfvOrGUYMYo81AlJ0CiTCtS2ND/s
        nMkcGXQor+sy5C3cqcHtvX3iVaPYsP4Z1o3z4Sw8Wpu6dDaB0uD7KO3BrdU2cQV6jXfn9ScHnxXUD
        GOy1KT84g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iOEhC-0003Eu-J1; Sat, 26 Oct 2019 05:33:02 +0000
Date:   Fri, 25 Oct 2019 22:33:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Anup Patel <anup@brainfault.org>
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Anup Patel <Anup.Patel@wdc.com>,
        Palmer Dabbelt <palmer@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v9 00/22] KVM RISC-V Support
Message-ID: <20191026053302.GA12368@infradead.org>
References: <20191016160649.24622-1-anup.patel@wdc.com>
 <alpine.DEB.2.21.9999.1910251609500.12828@viisi.sifive.com>
 <CAAhSdy1zfL2kPM-Le6TZSqS2TU1RkgC+zTbB4y31t8TXwVjhEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAhSdy1zfL2kPM-Le6TZSqS2TU1RkgC+zTbB4y31t8TXwVjhEg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, Oct 26, 2019 at 08:52:16AM +0530, Anup Patel wrote:
> I generally run checkpatch.pl every time before sending patches.
> 
> I will try checkpatch.pl with --strict parameter as well in v10 series.

--strict is a load of bullshit.  Please don't do that.
