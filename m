Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED354217918
	for <lists+kvm@lfdr.de>; Tue,  7 Jul 2020 22:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgGGUPS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 7 Jul 2020 16:15:18 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53640 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728493AbgGGUPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 7 Jul 2020 16:15:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594152915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DYtZMNoSH5tT3xKArGRPbFktJPFGX2LErV9OGvxddAA=;
        b=WYd9Osd9XsS1D/EpRWMKLUXRrkESYc9pRObhdn/HThTjX85YGWKJxdkShT7XDjgo7KtbxT
        qH+iOgAXwjdHha7KWfLOtuRYgQCmYChGLKaGr+rMm1DoNgd/yCfMn4OdYgaqf1rw3XJKfI
        oq7ox8nxhNbvRrFSq4bkbPCxf+lp2wI=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-371-2lHoWUnyMGm5Pyd_btX-ng-1; Tue, 07 Jul 2020 16:15:11 -0400
X-MC-Unique: 2lHoWUnyMGm5Pyd_btX-ng-1
Received: by mail-qv1-f70.google.com with SMTP id v20so27827346qvt.15
        for <kvm@vger.kernel.org>; Tue, 07 Jul 2020 13:15:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DYtZMNoSH5tT3xKArGRPbFktJPFGX2LErV9OGvxddAA=;
        b=KAGhUyZ4iC5UKLMK42gRMQ32M3T7emKfBJtkLWTHgjJES7m/doemBD/khaRaYc76O/
         eYyZgWm1rCb/w65b02H8aCCqikFoo1Drkv2LvNwRi0EB2xr2H7OrGMLi2BtYgqfdq4dG
         j9Cqsi5nyBRGFity3BWr3foBx6gzTGA82uTNWtlYkB+5SQbVWvqLG2hSCLGwBCUwgvo3
         WCFqKB0zvtpIOJLRJX863JXC44TJ0M5HyVMvOx6nrwGZ1I1E6jhcydT/LrAAJXic1dSm
         RWyMZeFUPiI+PhE0v6MHubhXwi4KI0ePuA8If9UN3gHASvGaiiQPiSGrR/XsCLTvP/PK
         S9tg==
X-Gm-Message-State: AOAM530CmCO82uwgMOJV9+YvzPLQKeAFls8afqXVl0yVbqJ7NTGn2VJK
        qIVrcHgfpdelDXDGMg70mvDQdRiYBzauxDWmnUrhPu/4GowGRs491oaF7i05U4sdgHx8WXuXtp/
        aATIo4IwOyu1L
X-Received: by 2002:a37:7ec1:: with SMTP id z184mr52466861qkc.185.1594152910998;
        Tue, 07 Jul 2020 13:15:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJymaqFNwY67jxYXAjVi4pHOd20KFZ9k9uKRFyhRphB+5xxP+YZ4ehh2D+MYuYBMhFJYol+BhA==
X-Received: by 2002:a37:7ec1:: with SMTP id z184mr52466842qkc.185.1594152910791;
        Tue, 07 Jul 2020 13:15:10 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id v12sm27518581qtj.32.2020.07.07.13.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 13:15:10 -0700 (PDT)
Date:   Tue, 7 Jul 2020 16:15:08 -0400
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
Message-ID: <20200707201508.GH88106@xz-x1>
References: <20200601115957.1581250-1-peterx@redhat.com>
 <20200601115957.1581250-3-peterx@redhat.com>
 <20200702230849.GL3575@linux.intel.com>
 <20200703184122.GF6677@xz-x1>
 <20200707061732.GI5208@linux.intel.com>
 <20200707195009.GE88106@xz-x1>
 <20200707195658.GK20096@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200707195658.GK20096@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jul 07, 2020 at 12:56:58PM -0700, Sean Christopherson wrote:
> > > It's a single line of code, and there's more than one
> > > "shouldn't" in the above.
> > 
> > If you want, I can both set it and add the comment.  Thanks,
> 
> Why bother with the comment?  It'd be wrong in the sense that the as_id is
> always valid/accurate, even if npages == 0.

Sorry I'm confused.. when npages==0, why as_id field is meaningful?  Even if
the id field is meaningless after the slot is successfully removed, or am I
wrong?

My understanding is that after your dynamic slot work, we'll only have at most
one extra memslot that was just removed, and that slot should be meaningless as
a whole.  Feel free to correct me.

-- 
Peter Xu

