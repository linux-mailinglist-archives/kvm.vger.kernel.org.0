Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063A1314A11
	for <lists+kvm@lfdr.de>; Tue,  9 Feb 2021 09:16:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhBIIOx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Feb 2021 03:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhBIIOx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Feb 2021 03:14:53 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8DBC061786;
        Tue,  9 Feb 2021 00:14:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=3ClKmTCZkiXhw+XhaM4rukL0gkFL3K11MqTaTKHhTuc=; b=mx7ydtFKmO+9z1LAS9vJQANpNf
        knVyCftAq3dKUql2YXClzEstVG62Cu6nCWXCcNosYeWkOclQfc9CWxtJdGIcOtipx5yqzhXda5BDt
        aHbKbhiSZgHtUwhrx0hUA2KqTocRrPcAwqoGlCgsnIkezlRol4QH3etNP44K8CkNnekKCu2nSufeO
        E6lERBpj+6WlS10mswMQWBquwP69QoLwCJu/ltkNdXiEG8E2WGBaOuR1XdZjItQxtiFn6L3nGYEiw
        lTj3vsrSWA27hTPQnZOfbwXnDqPp2BqTt3Oh5ToNp+n8806P7eG0p4Y2PusjE4sdqBeNleGaA9+G/
        vbjnN4Yw==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1l9O9w-0079GD-15; Tue, 09 Feb 2021 08:14:08 +0000
Date:   Tue, 9 Feb 2021 08:14:08 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, jgg@ziepe.ca,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        dan.j.williams@intel.com, Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [PATCH 1/2] mm: provide a sane PTE walking API for modules
Message-ID: <20210209081408.GA1703597@infradead.org>
References: <20210205103259.42866-1-pbonzini@redhat.com>
 <20210205103259.42866-2-pbonzini@redhat.com>
 <20210208173936.GA1496438@infradead.org>
 <3b10057c-e117-89fa-1bd4-23fb5a4efb5f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3b10057c-e117-89fa-1bd4-23fb5a4efb5f@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 08, 2021 at 07:18:56PM +0100, Paolo Bonzini wrote:
> Fair enough.  I would expect that pretty much everyone using follow_pfn will
> at least want to switch to this one (as it's less bad and not impossible to
> use correctly), but I'll squash this in:


Daniel looked into them, so he may correct me, but the other follow_pfn
users and their destiny are:

 - SGX, which is not modular and I think I just saw a patch to kill them
 - v4l videobuf and frame vector: I think those are going away
   entirely as they implement a rather broken pre-dmabuf P2P scheme
 - vfio: should use MMU notifiers eventually

Daniel, what happened to your follow_pfn series?
