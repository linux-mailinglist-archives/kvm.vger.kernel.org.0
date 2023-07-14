Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4A23754501
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 00:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbjGNWf7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 18:35:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbjGNWf6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 18:35:58 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935132D75
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 15:35:53 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id d9443c01a7336-1b8b310553bso17333225ad.3
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 15:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689374153; x=1691966153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AqPQXu/AIr+STPlGjrumZEqk7MLinV6fP6qlYwF+Hxk=;
        b=Tt0V9A0qkpbl5zS0LESlEdwvp+4lS8swsnaM5ygU4p8wmWduWJsTsWiMBUrW9Vh2KL
         aNiclCU+3JOXB1yiqIKXN6QgR9QdqoTo2RC11ivA+QpKq3HQpnI8PiDAYzg63A260iOT
         /X8Zs4ITCCFalugl0jsN26LMWffPpuzQBP22vn8lpRSG+H4mTHf3+orEXOoeYZYdfyr2
         abFsO9FDujBoCuI48/+aMdXB2jBUEMCB+wK+csXPETYbqUkpzTNRqr4u7awtDvgcPp5C
         u2l7VKka+4qaqK2LwY7H9dgsRxhvzJ+xsqjkh1lzLWjpI9iGg9n1Apbc27ImlTO1X+KO
         zawA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689374153; x=1691966153;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AqPQXu/AIr+STPlGjrumZEqk7MLinV6fP6qlYwF+Hxk=;
        b=Gd5M+frJUJzUgz8oD7RMq9y/w6K636PPPQTnyLUr7d0oiMRhwDUj44umCJuJOBphwG
         hXLMnpFX8GIAGScAYKdJBIOgkQXGe6+qcF1/ZQh1TA2M/qAggUK0HRVzcmA7npo8V9mt
         cUGB5FBeZ8ONgZY47DYeSRiqAXZa1cNVUHidOUZcXmqlTs2Fgn9Y7Tw7Dz09fQmf+H8o
         56Rm9in8odc+RPGViCtcDlfitJr0cSGjrhy8FchszrKG5HakxdejTVIRAZasjxezDB3q
         YHd2f6DPEgGnqWHmRL6F3EJuyvEQCAefhqgB81ZzT7fppYTeHXGMq0tWy4XYT4Lkhmvm
         VwYA==
X-Gm-Message-State: ABy/qLbTgLL6OCscTllkArZAyprnzKtv2iDwosRcDnuzdRKpBylKTyLY
        6ptdH+so0e/kk+JLFmSFFQPDmsxhtLs=
X-Google-Smtp-Source: APBJJlF9Rovb1aladgpgZPHMCXoqG55aen/Zed897i+LVWocHvfN1RJ6IbmpkTUFw7J9N1WkMXgLw6ub6IY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:902:b492:b0:1b9:e338:a90d with SMTP id
 y18-20020a170902b49200b001b9e338a90dmr17230plr.3.1689374153026; Fri, 14 Jul
 2023 15:35:53 -0700 (PDT)
Date:   Fri, 14 Jul 2023 22:35:51 +0000
In-Reply-To: <20230714115715.000026fe.zhi.wang.linux@gmail.com>
Mime-Version: 1.0
References: <cover.1687991811.git.isaku.yamahata@intel.com>
 <358fb191b3690a5cbc2c985d3ffc67224df11cf3.1687991811.git.isaku.yamahata@intel.com>
 <ZLB0ytO7y4NOLWpL@google.com> <20230714115715.000026fe.zhi.wang.linux@gmail.com>
Message-ID: <ZLHNx5jDjla2+4b0@google.com>
Subject: Re: [RFC PATCH v3 08/11] KVM: Fix set_mem_attr ioctl when error case
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Michael Roth <michael.roth@amd.com>,
        Yuan Yao <yuan.yao@linux.intel.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023, Zhi Wang wrote:
> On Thu, 13 Jul 2023 15:03:54 -0700
> Sean Christopherson <seanjc@google.com> wrote:
> > +       /*
> > +        * Reserve memory ahead of time to avoid having to deal with failures
> > +        * partway through setting the new attributes.
> > +        */
> > +       for (i = start; i < end; i++) {
> > +               r = xa_reserve(&kvm->mem_attr_array, i, GFP_KERNEL_ACCOUNT);
> > +               if (r)
> > +                       goto out_unlock;
> > +       }
> > +
> >         KVM_MMU_LOCK(kvm);
> >         kvm_mmu_invalidate_begin(kvm);
> >         kvm_mmu_invalidate_range_add(kvm, start, end);
> >         KVM_MMU_UNLOCK(kvm);
> >  
> >         for (i = start; i < end; i++) {
> > -               if (xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > -                                   GFP_KERNEL_ACCOUNT)))
> > +               r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
> > +                                   GFP_KERNEL_ACCOUNT));
> > +               if (KVM_BUG_ON(r, kvm))
> >                         break;
> >         }
> >
> 
> IIUC, If an error happenes here, we should bail out and call xa_release()?
> Or the code below (which is not shown here) still changes the memory attrs
> partially.

I'm pretty sure we want to continue on.  The VM is dead (killed by KVM_BUG_ON()),
so the attributes as seen by userspace and/or the VM don't matter.  What does
matter is that KVM's internal state is consistent, e.g. that KVM doesn't have
shared SPTEs while the attributes say a GFN is private.  That might not matter
for teardown, but I can't think of any reason not to tidy up.

And there can also be other ioctls() in flight.  KVM_REQ_VM_DEAD ensures vCPU
can't enter the guest, and vm->vm_dead ensures no new ioctls() cant start, but
neither of those guarantees there aren't other tasks doing KVM things.

Regardless, we definitely don't need to do xa_release().  The VM is dead and all
its memory will be reclaimed soon enough.  And there's no guarantee xa_release()
will actually be able to free anything, e.g. already processed entries won't be
freed, nor will any entries that existed _before_ the ioctl() was invoked.  Not
to mention that the xarray probably isn't consuming much memory, relatively
speaking.  I.e. in the majority of scenarios, it's likely preferable to get out
and destroy the VM asap.
