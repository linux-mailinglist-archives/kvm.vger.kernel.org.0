Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C15D230ADF
	for <lists+kvm@lfdr.de>; Tue, 28 Jul 2020 15:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729720AbgG1NDG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Jul 2020 09:03:06 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:28908 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729393AbgG1NDG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 28 Jul 2020 09:03:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595941385;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OKtEBQaZn0YzZZHRsb7SFbrApIA8b080HrT/IDEZIaQ=;
        b=bcvvSs+7pXMHJxkHgG3nA01x/w68mo6D8BfnMY0CYsKyXDTDHOUETboIXDRo1a1yyjTikF
        eGEDpRN7rKUL8gbMIz6ZLQKMfD0c7BDzj9KojJwZb2y2mvu6vVH3mXrLNgJ8EnEwG3Jkpi
        G0kRQO7DvLZdLVBVNGM5uze9VvW5pv4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-CIQdaN17OKK5X56TfILZDQ-1; Tue, 28 Jul 2020 08:59:19 -0400
X-MC-Unique: CIQdaN17OKK5X56TfILZDQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 782BC1009618;
        Tue, 28 Jul 2020 12:59:18 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.193.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BE7031C937;
        Tue, 28 Jul 2020 12:59:14 +0000 (UTC)
Date:   Tue, 28 Jul 2020 14:59:11 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, steven.price@arm.com
Subject: Re: [PATCH 0/5] KVM: arm64: pvtime: Fixes and a new cap
Message-ID: <20200728125911.ym7fcdp57tbtl32m@kamzik.brq.redhat.com>
References: <20200711100434.46660-1-drjones@redhat.com>
 <b9176783230caeb1224043ed150c4139@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9176783230caeb1224043ed150c4139@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 27, 2020 at 07:01:04PM +0100, Marc Zyngier wrote:
> On 2020-07-11 11:04, Andrew Jones wrote:
> > The first three patches in the series are fixes that come from testing
> > and reviewing pvtime code while writing the QEMU support (I'll reply
> > to this mail with a link to the QEMU patches after posting - which I'll
> > do shortly). The last patch is only a convenience for userspace, and I
> > wouldn't be heartbroken if it wasn't deemed worth it. The QEMU patches
> > I'll be posting are currently written without the cap. However, if the
> > cap is accepted, then I'll change the QEMU code to use it.
> > 
> > Thanks,
> > drew
> > 
> > Andrew Jones (5):
> >   KVM: arm64: pvtime: steal-time is only supported when configured
> >   KVM: arm64: pvtime: Fix potential loss of stolen time
> >   KVM: arm64: pvtime: Fix stolen time accounting across migration
> >   KVM: Documentation minor fixups
> >   arm64/x86: KVM: Introduce steal-time cap
> > 
> >  Documentation/virt/kvm/api.rst    | 20 ++++++++++++++++----
> >  arch/arm64/include/asm/kvm_host.h |  2 +-
> >  arch/arm64/kvm/arm.c              |  3 +++
> >  arch/arm64/kvm/pvtime.c           | 31 +++++++++++++++----------------
> >  arch/x86/kvm/x86.c                |  3 +++
> >  include/linux/kvm_host.h          | 19 +++++++++++++++++++
> >  include/uapi/linux/kvm.h          |  1 +
> >  7 files changed, 58 insertions(+), 21 deletions(-)
> 
> Hi Andrew,
> 
> Sorry about the time it took to get to this series.

No problem.

> Although I had a number of comments, they are all easy to
> address, and you will hopefully be able to respin it quickly

I'll address all the comments and get it respun right away.

> (assuming we agree that patch #1 is unnecessary).

I'm not sure yet. I've suggested yet another interpretation
of the spec and will see what you say about that.

Thanks,
drew

