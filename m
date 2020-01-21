Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64243143D3C
	for <lists+kvm@lfdr.de>; Tue, 21 Jan 2020 13:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgAUMrw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Jan 2020 07:47:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26220 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727350AbgAUMrv (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 21 Jan 2020 07:47:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579610870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GY+iQRTVNqzAwyuJVyAGWCFYTd4Vb20jwokeXldetiQ=;
        b=V9l/RjOrn5bDjy2gOLBOFwkEvsrMDrQ09s5AXSFxEryBPS+7M8MWYIymWxMJLsk6HNlTff
        pXsanWHlOHpFnKuYMIJhSxIVfeArffxP8JmWjNtsfxxCCpOcwtkY3jJM5zMWm3fnvOWcbF
        jiXv3jpgKH78MfbR77W0H5qh3cxUW1E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-40-o7pT7f5bM8uq-sa5KpjA-Q-1; Tue, 21 Jan 2020 07:47:49 -0500
X-MC-Unique: o7pT7f5bM8uq-sa5KpjA-Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3E385190D340;
        Tue, 21 Jan 2020 12:47:48 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0000E84DB3;
        Tue, 21 Jan 2020 12:47:46 +0000 (UTC)
Date:   Tue, 21 Jan 2020 13:47:44 +0100
From:   Andrew Jones <drjones@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        alexandru.elisei@arm.com
Subject: Re: [PATCH kvm-unit-tests 0/3] arm/arm64: selftest for pabt
Message-ID: <20200121124744.avp3g2p24q6p44di@kamzik.brq.redhat.com>
References: <20200113130043.30851-1-drjones@redhat.com>
 <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbd1f024-2f6c-d963-57f9-e6d7f2939fda@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 21, 2020 at 01:24:31PM +0100, Paolo Bonzini wrote:
> On 13/01/20 14:00, Andrew Jones wrote:
> > Patch 3/3 is a rework of Alexandru's pabt test on top of a couple of
> > framework changes allowing it to be more simply and robustly implemented.
> > 
> > Andrew Jones (3):
> >   arm/arm64: Improve memory region management
> >   arm/arm64: selftest: Allow test_exception clobber list to be extended
> >   arm/arm64: selftest: Add prefetch abort test
> > 
> >  arm/selftest.c      | 199 ++++++++++++++++++++++++++++++++------------
> >  lib/arm/asm/setup.h |   8 +-
> >  lib/arm/mmu.c       |  24 ++----
> >  lib/arm/setup.c     |  56 +++++++++----
> >  lib/arm64/asm/esr.h |   3 +
> >  5 files changed, 203 insertions(+), 87 deletions(-)
> > 
> 
> Looks good, are you going to send a pull request for this?
>

Sure. I'll send in a few minutes.

Thanks,
drew 

