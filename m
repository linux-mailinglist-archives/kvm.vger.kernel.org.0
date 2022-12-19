Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4778E6511D1
	for <lists+kvm@lfdr.de>; Mon, 19 Dec 2022 19:28:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiLSS2M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 19 Dec 2022 13:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbiLSS2D (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 19 Dec 2022 13:28:03 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D26A469
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 10:27:59 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id 65so6863341pfx.9
        for <kvm@vger.kernel.org>; Mon, 19 Dec 2022 10:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UWiRQvAxN9O3Vy4Pvdq+L2QQRxWvUv0umxELOuUSkuk=;
        b=Io/eiBdr2FMFjHoAburlk5EnBFupLvFbthAwxHFftAxvangqI40DSW9mHlaaQTigAA
         pRAQNuuoQ1KPhYw27YFcq+Zlcn/0Qdb67Ra/p+78HoNnmOaPcS8MhJL+ci4/ryzg2r39
         CYtRJXLP1W2LYjlCtVUAZeeeqcS1UXhAzVAmpJ7jQxd1d+vc3XdTYhdIxeHez9FMNpqN
         jij+JKeY15JmLBh0Gf88hCS/QtjJz5Yng+rVY+3rPW03pzCcpRHwZ+6B2T9llmhlvqzg
         BcQ3GBYMitubOvv030+vMIZwzMIjU62xU33Lq3PxBHFnOg0u9xsjFFFs89zcvx6BzLhG
         ENgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UWiRQvAxN9O3Vy4Pvdq+L2QQRxWvUv0umxELOuUSkuk=;
        b=Fb6MYEfjfjtxhfS5+C/yTwQ56nlqVEW/aEVZxbSK6zqfy0GHlewDVa3J9jg9lj0n6k
         BIWkr+bznVe7JW60FXKZLToLm++TM4lJff+AZWJl8FaeqUPFAHFIbfJEzZlHEc06UNSN
         T4a0QNyKZWeVYDtMd9n+S9HUScRw0nzle/9y6v3Y/1ZDD6N5On7Wch1Z7uRInzXhXH31
         llFofcpjdlx++EIQk7xdzFHrozmHPwnSTYAtqZP1IHhOR7l1wceju6nCmifzLcbfbbiY
         vSeB2/mAa+ULjdF+viRHPz1KRFZ+lbQKr+X1ck8/JdrryBSJB0EUpHC9UEhfL77mQpB9
         PckA==
X-Gm-Message-State: AFqh2krHEjmc6VdiYZuqWe9qKkqnow8v6xVUmPpSBtGx3Bmy6eKmIjGb
        UNbpd974BCwWq9bTX6XOzw4YzMzQJi+KJVCG
X-Google-Smtp-Source: AMrXdXsTmj8zfnHWcOpBs/EFJygJTnuhTBlWiJSmYiA/lLP4u98eIPZIcjOxGLcLVEXe3NaJ4PQicg==
X-Received: by 2002:a05:6a00:418f:b0:576:22d7:fd9e with SMTP id ca15-20020a056a00418f00b0057622d7fd9emr1458105pfb.0.1671474478640;
        Mon, 19 Dec 2022 10:27:58 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a24-20020aa79718000000b005745788f44csm6937543pfg.124.2022.12.19.10.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 10:27:58 -0800 (PST)
Date:   Mon, 19 Dec 2022 18:27:54 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: RFC: few questions about hypercall patching in KVM
Message-ID: <Y6CtKrlGYUF5LhSZ@google.com>
References: <9c7d86d5fd56aa0e35a9a1533a23c90853382227.camel@redhat.com>
 <Y5pv+/58UBDAfP19@google.com>
 <0d0ee4ff7e57996342e3eaa3bb714a43d8fa6628.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0d0ee4ff7e57996342e3eaa3bb714a43d8fa6628.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Dec 15, 2022, Maxim Levitsky wrote:
> On Thu, 2022-12-15 at 00:53 +0000, Sean Christopherson wrote:
> > On Wed, Dec 14, 2022, Maxim Levitsky wrote:
> > > 1. Now I suggest that when hypercall patching fails, can we do
> > > kvm_vm_bugged() instead of forwarding the hypercall?  I know that vmmcall can
> > > be executed from ring 3 as well, so I can limit this to hypercall patching
> > > that happens when guest ring is 0.
> > 
> > And L1.  But why?  It's not a KVM bug per se, it's a known deficiency in KVM's
> > emulator.  What to do in response to the failure should be up to userspace.  The
> > real "fix" is to disable the quirk in QEMU.
> 
> Yes, and L1, you are right - I thought about nested case, that maybe it is possible
> to eliminate it, but you are right, it can't be eliminated.
> 
> My reasoning for doing kvm_vm_bugged() (or returning X86EMUL_UNHANDLEABLE
> even better maybe, to give userspace a theoretical chance of dealing with it) 
> 
> is to make the error at least a bit more visible.  (I for example thought for
> a while that there is some memory corrupion in the guest caused by valgrind,
> which cause that #PF)

Yeah, the #PF is nasty, but bugging the VM isn't much better, and based on past
analysis, gracefully getting out to userspace isn't trivial.

https://lore.kernel.org/all/YUNqEeWg32kNwfO8@google.com

> > > 2. Why can't we just emulate the VMCALL/VMMCALL instruction in this case
> > > instead of patching? Any technical reasons for not doing this?  Few guests
> > > use it so the perf impact should be very small.
> > 
> > Nested is basically impossible to get right[1][2].  IIRC, calling into
> > kvm_emulate_hypercall() from the emulator also gets messy (I think I tried doing
> > exactly this at some point).
> 
> It could very well be, however if L0's KVM starts to emulate both VMMCALL and
> VMCALL instructions (when the quirk is enabled) then it will be the closest
> to what KVM always did, and it will not overwrite the guest memory.
> 
> About calling into kvm_emulate_hypercall I can expect trouble, but I would be
> very happy if you recall which problems did you face.

The above link has more details than I can recall.

> Note that at least for a nested guest, we can avoid patching right away
> because both VMMCALL and VMCALL that are done in nested guest will never need
> to call kvm_emulate_hypercall().
> 
> VMCALL is always intercepted by L1 as defined by VMX spec, while VMMCALL if
> not intercepted causes #UD in the guest.
> 
> In those cases emulation is very simple.
> 
> As for L1, we already have a precedent: #GP is sometimes emulated as SVM
> instruction due to the AMD's errata.
> 
> 
> Look at gp_interception:
> 
> You first decode the instruciton, and if it is VMCALL, then call the
> kvm_emulate_hypercall() This way there is no recursive emulator call.
> 
> What do you think?

I don't love the idea of expanding out-of-emulator emulation, especially since
the behavior is quirky, i.e. KVM shouldn't emulate the wrong hypercall instruction
if userspace has disabled KVM_X86_QUIRK_FIX_HYPERCALL_INSN.

My vote is to have QEMU disable the quirk, and if necessary, "fix" QEMU's TCG to
enumerate the correct vendor.
