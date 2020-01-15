Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2F8B13B9EF
	for <lists+kvm@lfdr.de>; Wed, 15 Jan 2020 07:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgAOGuV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 15 Jan 2020 01:50:21 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33503 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726075AbgAOGuU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 15 Jan 2020 01:50:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579071018;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uRmRVjt4VuQHcdX0Fq66G4p7865AfnsRCHZCOCF+SJY=;
        b=HadbDCCIh/xm2B33pCJqT9jCINGL/c3hJMLlTGKbCYf2/8EgwF7dUh9dgnuVhkr6BdG4vm
        /g78Kt0LR8gOZ+XhpWiz0CTF8lA6kt4R5f1Db0zh3UPLE02rFTnqjOPyBZn0+XxnRnY3Bu
        UHUOMBwBMI/XE/pGZ77yC0Mv/wzUjL0=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-252-29c96CziN0Gry3t_6WnVxA-1; Wed, 15 Jan 2020 01:50:17 -0500
X-MC-Unique: 29c96CziN0Gry3t_6WnVxA-1
Received: by mail-qv1-f69.google.com with SMTP id r9so10369028qvs.19
        for <kvm@vger.kernel.org>; Tue, 14 Jan 2020 22:50:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uRmRVjt4VuQHcdX0Fq66G4p7865AfnsRCHZCOCF+SJY=;
        b=YLdcldj8eZzVwNw6O7cvdC7f0ZeAqCkxJg2FP6eGPTuQ5qn8xeytxSkEd9eyNoEO38
         sXkMR+qGp3KyTmB8NJ8wf7Nrov+yRSVpF2iS+9shvzXvst/wrgIo8rWZnA+BneQvHMCH
         fecPfilkDMcJ7dFPy9BST85g4oa6YEdLATb8mKTy5EpCLLDloYTBPXzp4teHzcrggOMK
         QOXnwf0I7HWzKcmseIVhri+yfynnihoyB/GQOFf23MUuM45O4fncWO8/nIeR/4jAVyk2
         LDzg7Bd/BNF19Z4Tm/HrCdwNBmOphogj6JnhdKGo+vsZnKLQ9K/o0r9SSVhAaOrz84KC
         o6iQ==
X-Gm-Message-State: APjAAAWVnCjSfQHAWQtwkrQvWaBKs2QM0uSA8bZmYlU/vWknuWhUm5bw
        wVfE4LF5enpVQKzagdDnbvFv07pj8dWONs92zyxnyiNeVVS3/oLHwvGgfklqSyKm/a8W2Q0+OGh
        El/U72KOvHEaF
X-Received: by 2002:aed:3c16:: with SMTP id t22mr2158037qte.92.1579071016652;
        Tue, 14 Jan 2020 22:50:16 -0800 (PST)
X-Google-Smtp-Source: APXvYqw+JHaQyK4cROIu3XDgjevbDMk5RwHCZJqLOBkK59TwqdwSAfqibCf47Af1w0kbJriP3UtBqg==
X-Received: by 2002:aed:3c16:: with SMTP id t22mr2158025qte.92.1579071016474;
        Tue, 14 Jan 2020 22:50:16 -0800 (PST)
Received: from redhat.com (bzq-79-183-34-164.red.bezeqint.net. [79.183.34.164])
        by smtp.gmail.com with ESMTPSA id a36sm9168690qtk.29.2020.01.14.22.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2020 22:50:15 -0800 (PST)
Date:   Wed, 15 Jan 2020 01:50:08 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Peter Xu <peterx@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christophe de Dinechin <dinechin@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Yan Zhao <yan.y.zhao@intel.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Kevin <kevin.tian@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Lei Cao <lei.cao@stratus.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 12/21] KVM: X86: Implement ring-based dirty memory
 tracking
Message-ID: <20200115014735-mutt-send-email-mst@kernel.org>
References: <20200109145729.32898-1-peterx@redhat.com>
 <20200109145729.32898-13-peterx@redhat.com>
 <20200109110110-mutt-send-email-mst@kernel.org>
 <20200109191514.GD36997@xz-x1>
 <20200109141634-mutt-send-email-mst@kernel.org>
 <20200114200134.GA233443@xz-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114200134.GA233443@xz-x1>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jan 14, 2020 at 03:01:34PM -0500, Peter Xu wrote:
> On Thu, Jan 09, 2020 at 02:35:46PM -0500, Michael S. Tsirkin wrote:
> >   ``void flush_dcache_page(struct page *page)``
> > 
> >         Any time the kernel writes to a page cache page, _OR_
> >         the kernel is about to read from a page cache page and
> >         user space shared/writable mappings of this page potentially
> >         exist, this routine is called.
> > 
> > 
> > > Also, I believe this is the similar question that Jason has asked in
> > > V2.  Sorry I should mention this earlier, but I didn't address that in
> > > this series because if we need to do so we probably need to do it
> > > kvm-wise, rather than only in this series.
> > 
> > You need to document these things.
> > 
> > >  I feel like it's missing
> > > probably only because all existing KVM supported archs do not have
> > > virtual-tagged caches as you mentioned.
> > 
> > But is that a fact? ARM has such a variety of CPUs,
> > I can't really tell. Did you research this to make sure?
> > 
> > > If so, I would prefer if you
> > > can allow me to ignore that issue until KVM starts to support such an
> > > arch.
> > 
> > Document limitations pls.  Don't ignore them.
> 
> Hi, Michael,
> 
> I failed to find a good place to document about flush_dcache_page()
> for KVM.  Could you give me a suggestion?

Maybe where the field is introduced. I posted the suggestions to the
relevant patch.

> And I don't know about whether there's any ARM hosts that requires
> flush_dcache_page().  I think not, because again I didn't see any
> caller of flush_dcache_page() in KVM code yet.  Otherwise I think we
> should at least call it before the kernel reading kvm_run or after
> publishing data to kvm_run.

But is kvm run ever accessed while VCPU is running on another CPU?
I always assumed no but maybe I'm missing something?

>  However I'm also CCing Drew for this.
> 
> Thanks,
> 
> -- 
> Peter Xu

