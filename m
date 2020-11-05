Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5D702A864B
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 19:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731990AbgKESpU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 13:45:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:34699 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731912AbgKESpS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 13:45:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604601916;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1kl2GcEHrL+/aY0LbZRlrpXSE/ZcybgwWvSuMbDECEo=;
        b=P+b4jx1SOmKkpVPJrAg/fnfHEJCQTQFqKU9mJgGyQvCZ0sh6Vd/1n1fFWXxQLCZByOFSZO
        TzvKS9PrSsIqVxyh73xMMutjNmR8jA8LfQo8LaUqgInbcjPt4OEzK+BsFOq8yCAyBUbeTI
        dLLwAsmDAHnvD+YziQt+PoXawAaeDbA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-348-MnL8H2QhNISR_BDjLZqciA-1; Thu, 05 Nov 2020 13:45:14 -0500
X-MC-Unique: MnL8H2QhNISR_BDjLZqciA-1
Received: by mail-qk1-f198.google.com with SMTP id z28so1525678qkj.4
        for <kvm@vger.kernel.org>; Thu, 05 Nov 2020 10:45:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1kl2GcEHrL+/aY0LbZRlrpXSE/ZcybgwWvSuMbDECEo=;
        b=lKDjM5AkDox5l9Dey418xF5a8yQBTju7XFJIxFgP1lT2HVUeWWuCiC8vVXBV8vjTAx
         l2k2Jfb8OkLhQ6U5kySLO0UxhOO021taHYPAKPcHTnKbsnUElRDp9yIfrrB75D91TQgk
         2SO7PKxEuxq0MJ7Dspn4xSR9i0qU5HZFvvh5iH24Na4gpQMsuBTKfltsWcdg1mXFjhao
         O0OEcJU8rGjTthu8H9l58qxUq9E1hoMzH8ewi1KMbdqkIlkUJWz36fH+MbmHJwzWOM2c
         q+Mz4HzqYxJcg7NS8KHxFNpcG8faUM++Wfs9mRNDav4QG3DrDGC/PZ+ASlLDoPFd1aoM
         +1mA==
X-Gm-Message-State: AOAM532F/LzhGekLQWyzAs/GB1LLS6vSchFA852/B4ltNdFWsJ4M/l9f
        YuRN+ek+IIErZP4gR1Pgy62EJM+pLACQQuLLFxI6jjl17SP/Fcru5zkMLDEReSASX/gxrjd0N35
        J2drZ1qzSjF1e
X-Received: by 2002:ad4:5345:: with SMTP id v5mr3484189qvs.15.1604601913889;
        Thu, 05 Nov 2020 10:45:13 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyO/7kTyLVkGyVH2I9FXdcfQ4TKdLNFScTJiKKTucNXWb0+4FLZA8Pua1vaf54XVQ5nPmz26g==
X-Received: by 2002:ad4:5345:: with SMTP id v5mr3484155qvs.15.1604601913575;
        Thu, 05 Nov 2020 10:45:13 -0800 (PST)
Received: from xz-x1 (bras-vprn-toroon474qw-lp130-20-174-93-89-196.dsl.bell.ca. [174.93.89.196])
        by smtp.gmail.com with ESMTPSA id w45sm1537698qtw.96.2020.11.05.10.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 10:45:12 -0800 (PST)
Date:   Thu, 5 Nov 2020 13:45:11 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Andrew Jones <drjones@redhat.com>
Cc:     Christian Borntraeger <borntraeger@de.ibm.com>,
        kvm@vger.kernel.org, pbonzini@redhat.com, frankja@linux.ibm.com,
        bgardon@google.com
Subject: Re: [PATCH 09/11] KVM: selftests: Make vm_create_default common
Message-ID: <20201105184511.GC106309@xz-x1>
References: <20201104212357.171559-1-drjones@redhat.com>
 <20201104212357.171559-10-drjones@redhat.com>
 <20201104213612.rjykwe7pozcoqbcb@kamzik.brq.redhat.com>
 <c2c57735-2d1c-5abf-c2c0-ed04a19db5a0@de.ibm.com>
 <20201105095930.nofg64qyuf4qertu@kamzik.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201105095930.nofg64qyuf4qertu@kamzik.brq.redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 05, 2020 at 10:59:30AM +0100, Andrew Jones wrote:
> > >> +#define PTRS_PER_PAGE(page_size)	((page_size) / 8)
> > > 
> > > Doh. I think this 8 is supposed to be a 16 for s390x, considering it
> > > was dividing by 256 in its version of vm_create_default. I need
> > > guidance from s390x gurus as to whether or not I should respin though.
> > > 
> > > Thanks,
> > > drew
> > > 
> > 
> > This is kind of tricky. The last level page table is only 2kb (256 entries = 1MB range).
> > Depending on whether the page table allocation is clever or not (you can have 2 page
> > tables in one page) this means that indeed 16 might be better. But then you actually 
> > want to change the macro name to PTES_PER_PAGE?
> 
> Thanks Christian,
> 
> I'll respin with the macro name change and 16 for s390.

Maybe it can also be moved to common header, but instead define PTR_SIZE for
per-arch?  I'm also curious whether PTR_SIZE will equals to "sizeof(void *)",
but seems not for s390x..  Thanks,

-- 
Peter Xu

