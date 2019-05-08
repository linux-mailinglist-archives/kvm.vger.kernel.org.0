Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46198173FF
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 10:36:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726799AbfEHIgh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 04:36:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43970 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726685AbfEHIgg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 04:36:36 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A1CCA30832E3
        for <kvm@vger.kernel.org>; Wed,  8 May 2019 08:36:36 +0000 (UTC)
Received: from xz-x1 (dhcp-15-205.nay.redhat.com [10.66.15.205])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C8639600D4;
        Wed,  8 May 2019 08:36:33 +0000 (UTC)
Date:   Wed, 8 May 2019 16:36:31 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Juan Quintela <quintela@redhat.com>,
        Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Subject: Re: [PATCH 0/2] kvm: Some more trivial fixes for clear dirty log
Message-ID: <20190508083631.GA18465@xz-x1>
References: <20190508054403.7277-1-peterx@redhat.com>
 <a440e3f0-384b-2173-2c55-6cb2641f7937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a440e3f0-384b-2173-2c55-6cb2641f7937@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.44]); Wed, 08 May 2019 08:36:36 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, May 08, 2019 at 10:12:49AM +0200, Paolo Bonzini wrote:
> On 08/05/19 00:44, Peter Xu wrote:
> > Two issues I've noticed when I'm drafting the QEMU support of it.
> > With these two patches applied the QEMU binary (with the clear dirty
> > log supported [1]) can migrate correctly otherwise the migration can
> > stall forever if with/after heavy memory workload.
> > 
> > Please have a look, thanks.
> > 
> > [1] https://github.com/xzpeter/qemu/tree/kvm-clear-dirty-log
> > 
> > Peter Xu (2):
> >   kvm: Fix the bitmap range to copy during clear dirty
> >   kvm: Fix loop of clear dirty with off-by-one
> > 
> >  virt/kvm/kvm_main.c | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> 
> Looks good, but this is a blocker for using this feature in userspace.
> I think we should change the capability name and number.

Ok, let me add another patch for it.  Also I probably have made a
mistake too in patch 2 (it's not really off-by-one, but it should be a
DIV_ROUND_UP I think...).  I'll post a new version soon.

Thanks,

-- 
Peter Xu
