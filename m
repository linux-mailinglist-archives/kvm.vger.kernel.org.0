Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C38811B8072
	for <lists+kvm@lfdr.de>; Fri, 24 Apr 2020 22:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729359AbgDXUVK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Apr 2020 16:21:10 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:26632 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729198AbgDXUVJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Apr 2020 16:21:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587759668;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXw5lZJhw85ciOou4EBdbk3YqKsJHjQueqWvCGOssSI=;
        b=jIJahxkDXCEQRCbyWpr9X2A24gWjO5G01+PmNOP/e9pM02KmjzFk7qKtkQSys8+V5umI1b
        flC7ksGkgfHUaEnU1wxHVnsKdQCnFDAHFmTp932Ss0xGrGidz9HTHRc40UOI8CoZJ5iaae
        X3Ekx5tYHn9hzIpkpOF0X0NmZ9lt5AM=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-9-7LlRTQfNMdmA0CokXXZTNA-1; Fri, 24 Apr 2020 16:21:06 -0400
X-MC-Unique: 7LlRTQfNMdmA0CokXXZTNA-1
Received: by mail-qk1-f199.google.com with SMTP id k138so11838714qke.15
        for <kvm@vger.kernel.org>; Fri, 24 Apr 2020 13:21:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rXw5lZJhw85ciOou4EBdbk3YqKsJHjQueqWvCGOssSI=;
        b=KUIM6N/LyWMCtxAIjGMXiGkgnZLeRgi0WyelIS+7ZYX7kWbr/4DRRVSUgbV89OlKqH
         QckhNZ8JGXsRQxJG83bU59zn8yYwxMPrqCib50Fb1IF5ijZNZUC+FKgRfrXnnUs3Z8vF
         FWQ4ZoWdUeOfBh1de4Z3s3T1Aq6o8pPo8qZwZWk4smxnrgL9vmhMpPQu8gSnu2rwzOHH
         cF7NGmUDfJ1kFMSNWJEZDV0tlU5ASs2btKu103ES0cIfcO0r0wfkp62JEhvNOWA+glpR
         gCI8tyAnuAXjFM/+QtQpQPdbPAXEE/SibZFM8MQT/HHiw2AsaRHEREmDZt20OYuXm6tj
         2nRA==
X-Gm-Message-State: AGi0PuaPQPLZWKBet7BQdKYPejXcvIsi+1T/9j9hVcrcBDIcOHaj2jzl
        6k+KKM3Uv4t3nL3xGiYobxK7rB5AWv6usO4frZxi9ueROEMNQje9hVsfA8v1ArPP6gb8iaULxsY
        rVbxnChNslq4y
X-Received: by 2002:aed:2744:: with SMTP id n62mr11883395qtd.112.1587759665809;
        Fri, 24 Apr 2020 13:21:05 -0700 (PDT)
X-Google-Smtp-Source: APiQypLosHedl4+HJNNfXQLB7BcTG5F83yEgf4jDw1y2BrBe1GKEfq219Np0WT8QWevw2abxbY2mBg==
X-Received: by 2002:aed:2744:: with SMTP id n62mr11883362qtd.112.1587759665480;
        Fri, 24 Apr 2020 13:21:05 -0700 (PDT)
Received: from xz-x1 ([2607:9880:19c0:32::2])
        by smtp.gmail.com with ESMTPSA id o67sm4384051qkc.2.2020.04.24.13.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:21:04 -0700 (PDT)
Date:   Fri, 24 Apr 2020 16:21:03 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Nadav Amit <namit@cs.technion.ac.il>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] kvm: x86: Rename KVM_DEBUGREG_RELOAD to
 KVM_DEBUGREG_NEED_RELOAD
Message-ID: <20200424202103.GA48376@xz-x1>
References: <20200416101509.73526-1-xiaoyao.li@intel.com>
 <20200416101509.73526-2-xiaoyao.li@intel.com>
 <20200423190941.GN17824@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200423190941.GN17824@linux.intel.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 23, 2020 at 12:09:42PM -0700, Sean Christopherson wrote:
> On Thu, Apr 16, 2020 at 06:15:07PM +0800, Xiaoyao Li wrote:
> > To make it more clear that the flag means DRn (except DR7) need to be
> > reloaded before vm entry.
> > 
> > Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
> > ---
> >  arch/x86/include/asm/kvm_host.h | 2 +-
> >  arch/x86/kvm/x86.c              | 6 +++---
> >  2 files changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> > index c7da23aed79a..f465c76e6e5a 100644
> > --- a/arch/x86/include/asm/kvm_host.h
> > +++ b/arch/x86/include/asm/kvm_host.h
> > @@ -511,7 +511,7 @@ struct kvm_pmu_ops;
> >  enum {
> >  	KVM_DEBUGREG_BP_ENABLED = 1,
> >  	KVM_DEBUGREG_WONT_EXIT = 2,
> > -	KVM_DEBUGREG_RELOAD = 4,
> > +	KVM_DEBUGREG_NEED_RELOAD = 4,
> 
> My vote would be for KVM_DEBUGREG_DIRTY  Any bit that is set switch_db_regs
> triggers a reload, whereas I would expect a RELOAD flag to be set _every_
> time a load is needed and thus be the only bit that's checked

But then shouldn't DIRTY be set as long as KVM_DEBUGREG_BP_ENABLED is set every
time before vmenter?  Then it'll somehow go back to switch_db_regs, iiuc...

IIUC RELOAD actually wants to say "reload only for this iteration", that's why
it's cleared after each reload.  So maybe...  RELOAD_ONCE?

(Btw, do we have debug regs tests somewhere no matter inside guest or with
 KVM_SET_GUEST_DEBUG?)

Thanks,

-- 
Peter Xu

