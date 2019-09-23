Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0DABBC31
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 21:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfIWTVd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 15:21:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1455 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfIWTVc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 15:21:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DFC213082E4E;
        Mon, 23 Sep 2019 19:21:32 +0000 (UTC)
Received: from mail (ovpn-120-159.rdu2.redhat.com [10.10.120.159])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BAF2160BFB;
        Mon, 23 Sep 2019 19:21:32 +0000 (UTC)
Date:   Mon, 23 Sep 2019 15:21:31 -0400
From:   Andrea Arcangeli <aarcange@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/17] KVM: monolithic: x86: convert the kvm_x86_ops
 methods to external functions
Message-ID: <20190923192131.GD19996@redhat.com>
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-3-aarcange@redhat.com>
 <9b188fb8-b930-047f-d1c0-fe27cbe27338@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b188fb8-b930-047f-d1c0-fe27cbe27338@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Mon, 23 Sep 2019 19:21:32 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 23, 2019 at 12:19:30PM +0200, Paolo Bonzini wrote:
> On 20/09/19 23:24, Andrea Arcangeli wrote:
> > diff --git a/arch/x86/kvm/svm_ops.c b/arch/x86/kvm/svm_ops.c
> > new file mode 100644
> > index 000000000000..2aaabda92179
> > --- /dev/null
> > +++ b/arch/x86/kvm/svm_ops.c
> > @@ -0,0 +1,672 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/*
> > + *  arch/x86/kvm/svm_ops.c
> > + *
> > + *  Copyright 2019 Red Hat, Inc.
> > + */
> > +
> > +int kvm_x86_ops_cpu_has_kvm_support(void)
> > +{
> > +	return has_svm();
> > +}
> 
> Can you just rename all the functions in vmx/ and svm.c, instead of
> adding forwarders?

I can do that, I thought this was cleaner as it still retained the
abstraction separated from the mixup of the rest of the vmx/svm code,
but it'll work the same by dropping the abstraction in kvm_ops.h and
just maintaining a common name between the svm.c and vmx.c files, gcc
already built it that way after all.
