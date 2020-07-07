Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFF021798C
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 22:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728936AbgGGUia (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 16:38:30 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48996 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728437AbgGGUi3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 7 Jul 2020 16:38:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594154308;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aMjCiC4fXOOzIsPO0KvxcCfMxXjgG381WcddzPegvjk=;
        b=OspgZzSh+09WrDVaoEsrCrk+bOWWGA0jCh1lJVYVVLfN1bfgjW5ypvcHE7otgMp8axLEMT
        O8Rl0TeicwjK+4LbH6MyplExsI8i3tZ0i9yawT+PN/8ZBWMM9TXSU1OpSZR91XjGDF3i8t
        XJUUF4q2lkcY5ddn+ifYQRODA957XWc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-dlysDCsoNYyTq8ZyCkxbKQ-1; Tue, 07 Jul 2020 16:38:26 -0400
X-MC-Unique: dlysDCsoNYyTq8ZyCkxbKQ-1
Received: by mail-qk1-f198.google.com with SMTP id i145so10532252qke.2
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 13:38:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aMjCiC4fXOOzIsPO0KvxcCfMxXjgG381WcddzPegvjk=;
        b=h3Hfri5rIDVuTouZjY+ZqpYgtgIWj7UXiFqzxWxJ99iQfYwzhMpzX2gtHxeUH+dFE1
         PvwAuSwVo3GFX/EFd6QsNGgArpDXNt2kD5twHeWenn2kjoMHtwxWrTm1sWrScr1IAYws
         uRA2YBVxMyDuzN0YOcNKcyO8Zx2cAMEJIz1P8HPbAvVgNuRQA2pl2iASpJX5yqtP92o3
         4Q3+4uOUXkl+q/xa2oZGNTNviPqnjg5854ObU1CzRPJLDWEomr7yEjZ5S1A3JaIXJX7K
         /TagO27p5N1ygESTqE+lQ7faheRP/DiRWvesWlJg5qYCAQ7j9H6UgnY43qzEUkc6g0Bb
         oAGw==
X-Gm-Message-State: AOAM533iOi0bGCOI7PlFyFBdDJcAHoAxII8E6vxUaPpwQfBOFtuBVrPA
        fkleCda66ZAawSfCX2zWfNgvALBKEyGMRjxydCPbWejNPCNSnCpTl1hRWJ396WA1x6OYiQSLuWF
        6ODA6kX4AiM3j
X-Received: by 2002:a0c:a8e6:: with SMTP id h38mr48101767qvc.15.1594154306097;
        Tue, 07 Jul 2020 13:38:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzleWjN2olOhhrG5haHwdKHsD0Dqr3AfHJ7k/D2DRg2L3jSRHghjGvq6xqW45fgCMAxgq8VpQ==
X-Received: by 2002:a0c:a8e6:: with SMTP id h38mr48101747qvc.15.1594154305869;
        Tue, 07 Jul 2020 13:38:25 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id n143sm23806440qkn.94.2020.07.07.13.38.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 13:38:25 -0700 (PDT)
Date:   Tue, 7 Jul 2020 16:38:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Kevin Tian <kevin.tian@intel.com>
Subject: Re: [PATCH v10 02/14] KVM: Cache as_id in kvm_memory_slot
Message-ID: <20200707203823.GI88106@xz-x1>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
 <20200707061732.GI5208@linux.intel.com>
 <20200707195009.GE88106@xz-x1>
 <20200707195658.GK20096@linux.intel.com>
 <20200707201508.GH88106@xz-x1>
 <20200707202623.GM20096@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200707202623.GM20096@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 01:26:23PM -0700, Sean Christopherson wrote:
> On Tue, Jul 07, 2020 at 04:15:08PM -0400, Peter Xu wrote:
> > On Tue, Jul 07, 2020 at 12:56:58PM -0700, Sean Christopherson wrote:
> > > > > It's a single line of code, and there's more than one
> > > > > "shouldn't" in the above.
> > > > 
> > > > If you want, I can both set it and add the comment.  Thanks,
> > > 
> > > Why bother with the comment?  It'd be wrong in the sense that the as_id is
> > > always valid/accurate, even if npages == 0.
> > 
> > Sorry I'm confused.. when npages==0, why as_id field is meaningful?  Even if
> > the id field is meaningless after the slot is successfully removed, or am I
> > wrong?
> > 
> > My understanding is that after your dynamic slot work, we'll only have at most
> > one extra memslot that was just removed, and that slot should be meaningless as
> > a whole.  Feel free to correct me.
> 
> Your understanding is correct.  What I'm saying is that if something goes
> awry and the memslots need to be debugged, having accurate info for that one
> defunct memslot could be helpful, if only to not confuse a future debugger
> that doesn't fully understand memslots or address spaces.  Sure, it could be
> manually added back in for debug, but it's literally a single line of code
> to carry and it avoids the need for a special comment.

Sure, will do.  But again, I hope you allow me to add at least some comment.
To me, it's still weird to set these in a destroying memslot...

-- 
Peter Xu

