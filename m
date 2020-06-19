Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABD28200299
	for <lists+kvm@lfdr.de>; Fri, 19 Jun 2020 09:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730104AbgFSHSE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Jun 2020 03:18:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729740AbgFSHSC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Jun 2020 03:18:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7831C06174E;
        Fri, 19 Jun 2020 00:18:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yIfJe0PFRgdyF2+GVyLdDtjQLZgmYPiu7eqo8YWzytw=; b=bGn6urih2VWjJAHDlVdGesTHZa
        dxC4+l/f0dS650eIB8jOFMPtDJBue5SJbBKrJ+DtXIeJ+jNQODd/ws+yIbwGCktbS+WemW0PeMQTy
        vlFSt5nUNSlAOuv+uN0Gw6/hrA13TxUrQaCwXnXvvj86xwyeD5KO2h6OQijyWZYF9+S2FvI+VeVk7
        TnlJMe+MoM9827RcPMjbjHjivWI28NLueyuONvLRksa24Px+hopL2baI66XfkHXmMjMgVnh21tvnO
        Uh8JIs6d8LbX0Lb7G1TBZBAHNvyedtbDsToAZLuf9Ka6b1KuMzb7qY2g4d//xNgth2SDqaw6h1r/O
        JBpbqakg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jmBHm-0007Rj-2n; Fri, 19 Jun 2020 07:18:02 +0000
Date:   Fri, 19 Jun 2020 00:18:02 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        cohuck@redhat.com
Subject: Re: [PATCH] vfio: Cleanup allowed driver naming
Message-ID: <20200619071802.GA28304@infradead.org>
References: <159251018108.23973.14170848139642305203.stgit@gimli.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <159251018108.23973.14170848139642305203.stgit@gimli.home>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 18, 2020 at 01:57:18PM -0600, Alex Williamson wrote:
> No functional change, avoid non-inclusive naming schemes.

Adding a bunch of overly long lines that don't change anything are
everything but an improvement.
