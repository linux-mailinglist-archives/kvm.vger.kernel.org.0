Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D900542F634
	for <lists+kvm@lfdr.de>; Fri, 15 Oct 2021 16:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhJOOvv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Oct 2021 10:51:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232019AbhJOOvv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Oct 2021 10:51:51 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C06C061570
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 07:49:44 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id 21so6521836plo.13
        for <kvm@vger.kernel.org>; Fri, 15 Oct 2021 07:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VJdMGjbx+3L428UO0IwtH/tbfc+Utizl22DCtmWyKDk=;
        b=lU5uT0W0cipNBgwqEncLpZ7gpU3p9jTwA8teGqDXcu7iMwc8GNd89GWwZkcgWcYY6I
         qHMR614dwitbhzRvtA9cDh9Bs+E7ewY+LKU8DG5ZfOZt11nhRBehM4FneputcsSPeg7N
         Ow07oNjRTWRAAf30NS5ne7TzdNA0/6Ztih1P75EOm9mTb2rpUQWRZp0aE7xmfDUyM2PW
         jNMqGfvbXQeHauq/Ur3u5mBsrASjqARiTd10jwI7T6cXDOr6+GJjolkTcabqcS5DwRCZ
         CwSJ6QpObhpWuTzEn8Ly4GlbB+pdbnv1cEu62KI0kJOdC3NCOtK3Do24hQmr5taEpbOs
         E2WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VJdMGjbx+3L428UO0IwtH/tbfc+Utizl22DCtmWyKDk=;
        b=X6G7d0hGC44hZ6LB4ZpsrbvmedkmLU5b7CyBvDbpWO0akkFuOL+SHkTNkW1A2JOIMv
         XpV/sI8D5tpqC09S9FCUUUoGWCU4vwlt1xTzCgZSWuUj6JA8AykomdQFih19W8VMTn7V
         ufHr2Xgi7EkBn5AyU7pszi5VMJa8HByaJnOTch3K0SqC4IcyGsB62j14HtjWZ+bFGDXw
         BduiTkVavyG7EtCunriEzCmdcJ4ZMNU7fDJHYe4aJtHgc2S3YNBa6qiUWFNfwDYzRRN8
         csNB54JknZ5TePjk4CgmKPOivLxAVl/u8gohg3k2yoyK+6WdBrsqmPMf2mxUifp4VGb3
         k0Ag==
X-Gm-Message-State: AOAM531mClhUZiIfPdVrIWPNpz8kkMjZjtKz2LKwKEchzq0LX5gYwt8z
        AsfHHnYrueoO4N3s3u+Ju6LKwQ==
X-Google-Smtp-Source: ABdhPJy/EMS1oyN12Sv9vAKIsXKkPGNKfiRdwMj8GDcwM8ly7Rfwf/UNDDlarFpC/WAe3AF6WVvJdA==
X-Received: by 2002:a17:903:2451:b0:13f:297b:829e with SMTP id l17-20020a170903245100b0013f297b829emr11476004pls.45.1634309384122;
        Fri, 15 Oct 2021 07:49:44 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q14sm11650491pjm.17.2021.10.15.07.49.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 07:49:43 -0700 (PDT)
Date:   Fri, 15 Oct 2021 14:49:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        jmattson@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 15/15] KVM: x86/cpuid: Advise Arch LBR feature in CPUID
Message-ID: <YWmVA3FQoGcprtlp@google.com>
References: <1629791777-16430-1-git-send-email-weijiang.yang@intel.com>
 <1629791777-16430-16-git-send-email-weijiang.yang@intel.com>
 <YWjE0iQ6fDdJpDfT@google.com>
 <20211015012821.GA29942@intel.com>
 <dfe0dee9-905a-9296-4a5b-e88eb9e942a1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfe0dee9-905a-9296-4a5b-e88eb9e942a1@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 15, 2021, Like Xu wrote:
> On 15/10/2021 9:28 am, Yang Weijiang wrote:
> > On Fri, Oct 15, 2021 at 12:01:22AM +0000, Sean Christopherson wrote:
> > > s/Advise/Advertise
> > > 
> > > On Tue, Aug 24, 2021, Yang Weijiang wrote:
> > > > Add Arch LBR feature bit in CPU cap-mask to expose the feature.
> > > > Only max LBR depth is supported for guest, and it's consistent
> > > > with host Arch LBR settings.
> > > > 
> > > > Co-developed-by: Like Xu <like.xu@linux.intel.com>
> > > > Signed-off-by: Like Xu <like.xu@linux.intel.com>
> > > > Signed-off-by: Yang Weijiang <weijiang.yang@intel.com>
> > > > ---
> > > >   arch/x86/kvm/cpuid.c | 33 ++++++++++++++++++++++++++++++++-
> > > >   1 file changed, 32 insertions(+), 1 deletion(-)
> > > > 
> > > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > > index 03025eea1524..d98ebefd5d72 100644
> > > > --- a/arch/x86/kvm/cpuid.c
> > > > +++ b/arch/x86/kvm/cpuid.c
> > > > @@ -88,6 +88,16 @@ static int kvm_check_cpuid(struct kvm_cpuid_entry2 *entries, int nent)
> > > >   		if (vaddr_bits != 48 && vaddr_bits != 57 && vaddr_bits != 0)
> > > >   			return -EINVAL;
> > > >   	}
> > > > +	best = cpuid_entry2_find(entries, nent, 0x1c, 0);
> > > > +	if (best) {
> > > > +		unsigned int eax, ebx, ecx, edx;
> > > > +
> > > > +		/* Reject user-space CPUID if depth is different from host's.*/
> > > 
> > > Why disallow this?  I don't see why it would be illegal for userspace to specify
> > > fewer LBRs,
> 
> The emulation of guest LBR *depends* on the host LBR driver to save/restore
> LBRs entries (which are pass-through to the guest and store the guest branch
> instructions rips actually).
> 
> Currently, the host side does not support the use of different lbr depths on
> the same host to customize this part of the overhead. The host perf LBR
> driver assumes that the lbr depths of different tasks on different cpu's are
> the same and are the maximum value.

Yes, I assumed as much, but saving/restoring MSRs that the guest does not have
access to is not a functional issue, just a waste of cycles.
