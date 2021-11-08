Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E129E449DA1
	for <lists+kvm@lfdr.de>; Mon,  8 Nov 2021 22:07:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239325AbhKHVKl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 Nov 2021 16:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbhKHVKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 Nov 2021 16:10:40 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D97C9C061570
        for <kvm@vger.kernel.org>; Mon,  8 Nov 2021 13:07:55 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u17so16813796plg.9
        for <kvm@vger.kernel.org>; Mon, 08 Nov 2021 13:07:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Cp6vZetKpkElyiBtPgIxgukktZ0AkdM63MCzBnzruM8=;
        b=loCOngRzFgnpjgKErGCHanLkYaFws6XxH7f8cuIK3LMmyu/jdKIBLIgLsWkUGdqgiT
         WLSeHTk9CoYl4RKa+F8t/Wy45ErkLb3Oq8Ce/6czE9pUqwYm9CbPTne2M8TdVoERpzlQ
         gN7wVIBCaVEjhUoXXqhrf25GkkyZGgNMP57ysh0mMHZ2KkMWJeKhBbfCDv2iLOrU3D1V
         z2GA4i/nPm2uUwxueFc4oWzsk73CrHBcOuBKIo5nT2L72lvB4aYBP9xXn0eMEf+zkScw
         pSuBis7myHejZzAvWqJLnHIcwM/+K5m0RRSHgnWzWdZ2+iQuowtdAnzP12baGhPTP+a3
         VsZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cp6vZetKpkElyiBtPgIxgukktZ0AkdM63MCzBnzruM8=;
        b=0cjOxNWSEaklHZjDXaSboQK7lzCZ0bnLYedbAW5OFL8rStQLuOR9TeRDgY3yGCBLZt
         zhqXkepu4l4uH/hxP4hvvKllTJsdAOhftQCLAPqRCGjAvZ7c/LqF5RAc1qjdTRwYpedE
         CLmK8mpXih3IvHRT9HWXF4/31NGM1vVQQoLOMwL9fP+K3Ta+AN66RbBFKJXaRbcgDn2D
         ayoNgxRsYL+W2qG8RMx2bgvUIXsglmhIri/4z6pweBxBHsL53hF1w5olwif1miHGRqLz
         JjcFZ6TliBkKpZiHudDULlM1m2gZYq+QkTR+79AcDMlYNw2boeI4d0alD/uqFfOkSWI9
         +73Q==
X-Gm-Message-State: AOAM533u4AHlpFComzRMthhCidCDhJzCecP3xIOIsF5ED2nkaUaXg9pA
        qy8IDKJ1iXoI2Ao+5CD7XHxVoA==
X-Google-Smtp-Source: ABdhPJyWTSDzju6o4BQzR4xICT/TvND+ogsMpwV3gEVGphv7H/u0foelXIz3p0faAFwN8mtDr+naxQ==
X-Received: by 2002:a17:902:b18b:b0:13a:354a:3e9d with SMTP id s11-20020a170902b18b00b0013a354a3e9dmr2284442plr.36.1636405675175;
        Mon, 08 Nov 2021 13:07:55 -0800 (PST)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id fh3sm241723pjb.8.2021.11.08.13.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:07:54 -0800 (PST)
Date:   Mon, 8 Nov 2021 21:07:51 +0000
From:   David Matlack <dmatlack@google.com>
To:     Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
Subject: Re: RFC: KVM: x86/mmu: Eager Page Splitting
Message-ID: <YYmRpz4dQgli3GKM@google.com>
References: <CALzav=dV_U4r1K9oDq4esb4mpBQDQ2ROQ5zH5wV3KpOaZrRW-A@mail.gmail.com>
 <bc06dd82-06e1-b455-b2c1-59125b530dda@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bc06dd82-06e1-b455-b2c1-59125b530dda@linux.vnet.ibm.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 05, 2021 at 06:17:11PM +0100, Janis Schoetterl-Glausch wrote:
> On 11/4/21 23:45, David Matlack wrote:
> 
> [...]
> > 
> > The last alternative is to perform dirty tracking at a 2M granularity.
> > This would reduce the amount of splitting work required by 512x,
> > making the current approach of splitting on fault less impactful to
> > customer performance. We are in the early stages of investigating 2M
> > dirty tracking internally but it will be a while before it is proven
> > and ready for production. Furthermore there may be scenarios where
> > dirty tracking at 4K would be preferable to reduce the amount of
> > memory that needs to be demand-faulted during precopy.

Oops I meant to say "demand-faulted during post-copy" here.

> I'm curious how you're going about evaluating this, as I've experimented with
> 2M dirty tracking in the past, in a continuous checkpointing context however.
> I suspect it's very sensitive to the workload. If the coarser granularity
> leads to more memory being considered dirty, the length of pre-copy rounds
> increases, giving the workload more time to dirty even more memory.
> Ideally large pages would be used only for regions that won't be dirty or
> regions that would also be pretty much completely dirty when tracking at 4K.
> But deciding the granularity adaptively is hard, doing 2M tracking instead
> of 4K robs you of the very information you'd need to judge that.

We're planning to look at how 2M tracking affects the amount of memory
that needs to be demand-faulted during the post-copy phase for different
workloads.
