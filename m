Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FA8529579
	for <lists+kvm@lfdr.de>; Tue, 17 May 2022 01:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348883AbiEPXsa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 19:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiEPXsY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 19:48:24 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 727C43E0FA
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:48:23 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id c24so18996089lfv.11
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 16:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=l+psx6Yx472hZpZ2bcQNygHszc2ixOPG3ap3rPQRlQY=;
        b=rskA2rxng+xCPLD2nxBuj4JD/+aHkgys08JfNBIsb3AiT3+SLjj04K7L/l+xMx3Wxh
         NvzliJrD1wDAvOE/i8VGKgtOoB6dUacWYmkgLdt4djhe3ULwM47ZfE+6w4kkKW2MQM3u
         wQFbRTI+5mXohT6SxgUGhxPl1cI0Ls3AoJ1Ldz59/07GO55rtEFiPyCxl5M1XPwSDEbd
         U/ZFtNNXBRmlXhMwYDPRtA39U6NRLTe4lj319mZSQ4+PeC19TXai/R4Z8TtvZH/5b+CX
         Dh2nsLkmj2VNlaStC6ew/67Xn1SbSHGoI0cGlVa2MuRhkapljvzqnknnzO/wmeWxIdnn
         keGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=l+psx6Yx472hZpZ2bcQNygHszc2ixOPG3ap3rPQRlQY=;
        b=Au929Hcz0H8zoUQzPZtPbpPG9xBPOSKYL2Q6mtixmBYaZYYVfAtqLqeJ8YxcrQ96oA
         8pldBju4wxSI+rpKNoTVS7uDyzH9bDJwlAHDgmkzuOBeC1FLs9O+ccS4vXWsWeWhNyIK
         KToFpwGJxqSvy54yNXhq0lvA6LvlVpdkRM9UJPc0zBZ9JLtmfDoJ+//YJmGY1e5xn5F6
         ZId0T07aZSqb+5N2ER+eu/LP0KbM2K9ivbPvZJoKLqn9pEXHCUu6OQddX2e0IGtOtfm/
         APx4GKJbKsTmkIHeznF0LKn1BY+A/f2MBSbwREYG5FqtPrpZ//ZyJtl0REYTCMe/EwJN
         9h+A==
X-Gm-Message-State: AOAM530aW3A2deViGFM1sW0oecPR0SL1gGp/RhYDbw63ncpg6Y7Fa1X9
        Jw9a/aWU8v417jBU7gWdgRrmUYySQd0n0NrqciLPeg==
X-Google-Smtp-Source: ABdhPJyoUWYutvbt1I7j417ZYs5nAt1dXGWOtHdvLp6OQvSVfNkO58Zx6vj3uObJQ3JNPzYgZVmEk2VA7qLyecFigMU=
X-Received: by 2002:a05:6512:1502:b0:474:28db:7b37 with SMTP id
 bq2-20020a056512150200b0047428db7b37mr15128073lfb.250.1652744901639; Mon, 16
 May 2022 16:48:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220429183935.1094599-1-dmatlack@google.com> <20220429183935.1094599-10-dmatlack@google.com>
 <YoLNcd1SQMSNdSMb@xz-m1.local> <CALzav=dwEJx=HrPDBxVyTJU-JkjX3c0hx-4JvJ2bY+BW7FL5dQ@mail.gmail.com>
 <YoLhW0DoAzqpAqu2@xz-m1.local>
In-Reply-To: <YoLhW0DoAzqpAqu2@xz-m1.local>
From:   David Matlack <dmatlack@google.com>
Date:   Mon, 16 May 2022 16:47:55 -0700
Message-ID: <CALzav=dZht2T5PPaErhKbv6WLijq6i=EdRw0RufRj9GsqDmc0w@mail.gmail.com>
Subject: Re: [PATCH 9/9] KVM: selftests: Add option to run dirty_log_perf_test
 vCPUs in L2
To:     Peter Xu <peterx@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrew Jones <drjones@redhat.com>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 16, 2022 at 4:42 PM Peter Xu <peterx@redhat.com> wrote:
>
> On Mon, May 16, 2022 at 03:34:28PM -0700, David Matlack wrote:
> > On Mon, May 16, 2022 at 3:17 PM Peter Xu <peterx@redhat.com> wrote:
> > >
> > > On Fri, Apr 29, 2022 at 06:39:35PM +0000, David Matlack wrote:
> > > > +static void perf_test_l1_guest_code(struct vmx_pages *vmx, uint64_t vcpu_id)
> > > > +{
> > > > +#define L2_GUEST_STACK_SIZE 64
> > > > +     unsigned long l2_guest_stack[L2_GUEST_STACK_SIZE];
> > > > +     unsigned long *rsp;
> > > > +
> > > > +     GUEST_ASSERT(vmx->vmcs_gpa);
> > > > +     GUEST_ASSERT(prepare_for_vmx_operation(vmx));
> > > > +     GUEST_ASSERT(load_vmcs(vmx));
> > > > +     GUEST_ASSERT(ept_1g_pages_supported());
> > > > +
> > > > +     rsp = &l2_guest_stack[L2_GUEST_STACK_SIZE - 1];
> > > > +     *rsp = vcpu_id;
> > > > +     prepare_vmcs(vmx, perf_test_l2_guest_entry, rsp);
> > >
> > > Just to purely ask: is this setting the same stack pointer to all the
> > > vcpus?
> >
> > No, but I understand the confusion since typically selftests use
> > symbols like "l2_guest_code" that are global. But "l2_guest_stack" is
> > actually a local variable so it will be allocated on the stack. Each
> > vCPU runs on a separate stack, so they will each run with their own
> > "l2_guest_stack".
>
> Ahh that's correct!
>
> >
> > >
> > > > +
> > > > +     GUEST_ASSERT(!vmlaunch());
> > > > +     GUEST_ASSERT(vmreadz(VM_EXIT_REASON) == EXIT_REASON_VMCALL);
> > > > +     GUEST_DONE();
> > > > +}
> > >
> > > [...]
> > >
> > > > +/* Identity map the entire guest physical address space with 1GiB Pages. */
> > > > +void nested_map_all_1g(struct vmx_pages *vmx, struct kvm_vm *vm)
> > > > +{
> > > > +     __nested_map(vmx, vm, 0, 0, vm->max_gfn << vm->page_shift, PG_LEVEL_1G);
> > > > +}
> > >
> > > Could max_gfn be large?  Could it consumes a bunch of pages even if mapping
> > > 1G only?
> >
> > Since the selftests only support 4-level EPT, this will use at most
> > 513 pages. If we add support for 5-level EPT we may need to revisit
> > this approach.
>
> It's just that AFAICT vm_alloc_page_table() is fetching from slot 0 for all
> kinds of pgtables including EPT.  I'm not sure whether there can be some
> failures conditionally with this because when creating the vm we're not
> aware of this consumption, so maybe we'd reserve the pages somehow so that
> we'll be sure to have those pages at least?

So far in my tests perf_test_util seemed to allocate enough pages in
slot 0 that this just worked, so I didn't bother to explicitly reserve
the extra pages. But that's just an accident waiting to happen as you
point out, so I'll fix that in v2.

>
> --
> Peter Xu
>
