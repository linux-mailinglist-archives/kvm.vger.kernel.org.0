Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9932E7363B
	for <lists+kvm@lfdr.de>; Wed, 24 Jul 2019 20:00:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727908AbfGXSAI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Jul 2019 14:00:08 -0400
Received: from ms.lwn.net ([45.79.88.28]:56828 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726242AbfGXSAH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Jul 2019 14:00:07 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id BEBCD300;
        Wed, 24 Jul 2019 18:00:06 +0000 (UTC)
Date:   Wed, 24 Jul 2019 12:00:05 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Christoph Hellwig <hch@lst.de>, rkrcmar@redhat.com,
        jdike@addtoit.com, richard@nod.at, anton.ivanov@cambridgegreys.com,
        linux-doc@vger.kernel.org, kvm@vger.kernel.org,
        linux-um@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: move Documentation/virtual to
 Documentation/virt
Message-ID: <20190724120005.31a990af@lwn.net>
In-Reply-To: <b9baabbb-9e9b-47cf-f5a8-ea42ba1ddc25@redhat.com>
References: <20190724072449.19599-1-hch@lst.de>
        <b9baabbb-9e9b-47cf-f5a8-ea42ba1ddc25@redhat.com>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 24 Jul 2019 10:51:36 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> On 24/07/19 09:24, Christoph Hellwig wrote:
> > Renaming docs seems to be en vogue at the moment, so fix on of the
> > grossly misnamed directories.  We usually never use "virtual" as
> > a shortcut for virtualization in the kernel, but always virt,
> > as seen in the virt/ top-level directory.  Fix up the documentation
> > to match that.
> > 
> > Fixes: ed16648eb5b8 ("Move kvm, uml, and lguest subdirectories under a common "virtual" directory, I.E:")
> > Signed-off-by: Christoph Hellwig <hch@lst.de>  
> 
> Queued, thanks.  I can't count how many times I said "I really should
> rename that directory".

...and it's up to Linus before I even got a chance to look at it - one has
to be fast around here...:)

There's nothing wrong with this move, but it does miss the point of much
of the reorganization that has been going on in the docs tree.  It's not
just a matter of getting more pleasing names; the real idea is to create a
better, more reader-focused organization on kernel documentation as a
whole.  Documentation/virt still has the sort of confusion of audiences
that we're trying to fix:

 - kvm/api.txt pretty clearly belongs in the userspace-api book, rather
   than tossed in with:

 - kvm/review-checklist.txt, which belongs in the subsystem guide, if only
   we'd gotten around to creating it yet, or

 - kvm/mmu.txt, which is information for kernel developers, or

 - uml/UserModeLinux-HOWTO.txt, which belongs in the admin guide.

I suspect that organization is going to be one of the main issues to talk
about in Lisbon.  Meanwhile, I hope that this rename won't preclude
organizational work in the future.

Thanks,

jon
