Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6712695127
	for <lists+kvm@lfdr.de>; Mon, 13 Feb 2023 20:57:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjBMT5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 Feb 2023 14:57:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbjBMT5I (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 Feb 2023 14:57:08 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553991CAC3
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 11:56:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676318181;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BJSyCURZo4zjKZjqklQ7P1Wkqqa8CZURFqDl8CtDysY=;
        b=MFPcpHsA4cpPbZWIWgPem+sgSpyCbHZ76GwRyKf436Tg7WmiGkd8+wxgaJgjTP5lFUAKdM
        B2WdGfPwxcMYGgL96N7FvAi/aQk8ivwXAq51kevE1ry83+t+ieXdcHluDHyi/jQUsPPKQU
        +V895WR9jkx3C9ys5TPSTVKdzI6UaXI=
Received: from mail-vs1-f69.google.com (mail-vs1-f69.google.com
 [209.85.217.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-373-KRRhWMEqP5i_yjwny3irUQ-1; Mon, 13 Feb 2023 14:56:20 -0500
X-MC-Unique: KRRhWMEqP5i_yjwny3irUQ-1
Received: by mail-vs1-f69.google.com with SMTP id i23-20020a0561023d1700b00411ab049675so2895120vsv.12
        for <kvm@vger.kernel.org>; Mon, 13 Feb 2023 11:56:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BJSyCURZo4zjKZjqklQ7P1Wkqqa8CZURFqDl8CtDysY=;
        b=Ou6gNrrbUiCd3qz9YVun5I3kC6bWYZjPDACzYuRl+bM5r31g4pPj5cdwjvui4O7d1Z
         d3Wlor7/kctURS6Q5fBWhIdQtz6ftsicwlx0+Jzi86USFfsP2ADkr/wxX6p6p8MA0u+m
         9+faVqANHbkTd35TzkaidjOZ7+QFe78A9NvLgitR19d7frTuzceGfWGfwDJBKl04MYSx
         EOyOPNlR4bCrVWeklNb8eYXc23qvd76diHQzHvWcCAdigfQa/TSg7B8oLRVgzwh2OrzE
         rOlJdm/PSaWDo6hC73jZ7csKVMkbApJY6loUR24iPY5ntBHyCzPN4NzNw4qtnGnlzzNB
         cKFA==
X-Gm-Message-State: AO0yUKX/3EbtTW2VZ1bB0fUOzVk8xMvXREA/uDafy0/AgYie90DrEMjM
        pqAo6UbM8n+IVt/LFkz5uktq+U4KV1jCLo6AsA/DGf/9y5jnFKGZnCsKj4pT2EHUZwDPNHfXaZW
        vUuVjZ1ORJzhDDNctlGzOBP1tb/Lq5ClhF2L0
X-Received: by 2002:ab0:6957:0:b0:68a:67ef:4b6d with SMTP id c23-20020ab06957000000b0068a67ef4b6dmr880880uas.20.1676318179603;
        Mon, 13 Feb 2023 11:56:19 -0800 (PST)
X-Google-Smtp-Source: AK7set8axWCufvKXEi39RlcLeywpkZYfwLG7FADc7b/CNFdC/+kTa0YKM/S3LCGLz/Umdv220hl4bINXVESf+7aWbrY=
X-Received: by 2002:ab0:6957:0:b0:68a:67ef:4b6d with SMTP id
 c23-20020ab06957000000b0068a67ef4b6dmr880873uas.20.1676318179381; Mon, 13 Feb
 2023 11:56:19 -0800 (PST)
MIME-Version: 1.0
References: <43980946-7bbf-dcef-7e40-af904c456250@linux.microsoft.com>
 <Y+p1j7tYT+16MX6B@google.com> <35ff8f48-2677-78ea-b5f3-329c75ce65c9@redhat.com>
 <Y+qLe42h9ZPRINrG@google.com>
In-Reply-To: <Y+qLe42h9ZPRINrG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Date:   Mon, 13 Feb 2023 20:56:08 +0100
Message-ID: <CABgObfaZQOvt6v0yGz3MR7FBU7DcrTTGmS6M8RWCX0uy6WML1Q@mail.gmail.com>
Subject: Re: "KVM: x86/mmu: Overhaul TDP MMU zapping and flushing" breaks SVM
 on Hyper-V
To:     Sean Christopherson <seanjc@google.com>
Cc:     Jeremi Piotrowski <jpiotrowski@linux.microsoft.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tianyu Lan <ltykernel@gmail.com>,
        "Michael Kelley (LINUX)" <mikelley@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 13, 2023 at 8:12 PM Sean Christopherson <seanjc@google.com> wrote:
> > My reading of the spec[1] is that HV_X64_NESTED_ENLIGHTENED_TLB will cause
> > svm_flush_tlb_current to behave (in Intel parlance) as an INVVPID rather
> > than an INVEPT.
>
> Oh!  Good catch!  Yeah, that'll be a problem.
>
> > So svm_flush_tlb_current has to be changed to also add a
> > call to HvCallFlushGuestPhysicalAddressSpace.  I'm not sure if that's a good
> > idea though.
>
> That's not strictly necessary, e.g. flushes from kvm_invalidate_pcid() and
> kvm_post_set_cr4() don't need to effect a full flush.  I believe the virtual
> address flush is also sufficient for avic_activate_vmcb().  Nested (from KVM's
> perspective, i.e. running L3) can just be mutually exclusive with
> HV_X64_NESTED_ENLIGHTENED_TLB.
>
> That just leaves kvm_mmu_new_pgd()'s force_flush_and_sync_on_reuse and the
> aforementioned kvm_mmu_load().
>
> That said, the above cases where a virtual address flush is sufficient are
> rare operations when using NPT, so adding a new KVM_REQ_TLB_FLUSH_ROOT or
> whatever probably isn't worth doing.
>
> > First, that's a TLB shootdown rather than just a local thing;
> > flush_tlb_current is supposed to be relatively cheap, and there would be a
> > lot of them because of the unconditional calls to
> > nested_svm_transition_tlb_flush on vmentry/vmexit.
>
> This isn't a nested scenario for KVM though.

Yes, but svm_flush_tlb_current() *is* also used in nested scenarios so
it's like you said below---you would have to disable enlightened TLB
when EFER.SVME=1 or something like that.

> > Depending on the performance results of adding the hypercall to
> > svm_flush_tlb_current, the fix could indeed be to just disable usage of
> > HV_X64_NESTED_ENLIGHTENED_TLB.
>
> Minus making nested SVM (L3) mutually exclusive, I believe this will do the trick:
>
> +       /* blah blah blah */
> +       hv_flush_tlb_current(vcpu);
> +

Yes, it's either this or disabling the feature.

Paolo

