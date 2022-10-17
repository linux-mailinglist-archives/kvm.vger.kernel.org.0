Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26EA601634
	for <lists+kvm@lfdr.de>; Mon, 17 Oct 2022 20:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230196AbiJQSZv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 17 Oct 2022 14:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229905AbiJQSZt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 17 Oct 2022 14:25:49 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD54071BC7
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:25:46 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id b18so14980132ljr.13
        for <kvm@vger.kernel.org>; Mon, 17 Oct 2022 11:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s0J5M786TwaMLoMsZ1Scm7fs/H+L1tdOLwBM6CQTWeI=;
        b=ipD578I3BnnfeMqQ/xcTjxHYz3cX6TI59AYe00AjkAU6nGV+Q4GiPC8EO4sQnVGrwM
         d9RsREiia8cfIgb8q8f8Evaa2nf/zEpw4jeK+KgLQbAfAhT8wrkgCdoVbtjt3upSxoag
         G8T5O5j259sPtYDszziZ6q899421SWMASVuP50YovJMxS/SUrT5lQ+vxYZZibcKP7hYK
         A68Hs1ILFe/Qj9itaDs3xvMdl+BpCAounrj11jHn9KD/jsodwPS0EAxbi40BB+EPyJT0
         eCvMGiD+kdLSCMByEYAVOsWULFHg466L3MqT/5Eckgluy+YnDqUjhLMnNBKEYV6GA9Ik
         SflQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0J5M786TwaMLoMsZ1Scm7fs/H+L1tdOLwBM6CQTWeI=;
        b=42RZ5HOaH8vRHNNd3TrKNd6mKMrrdW4nxU5LE3adJ8zNIRTzb/TQDx4vYvC1hOLiQC
         yJmhIEtRbGE4eCgU+eiH/1Gkknm2Flkv7OBOhewjHwCAGMw4wbHxpbdScBhYMjWLiS8U
         dwRGokHEktq3YOi31wT8BqK0DcGfxZ3B+MjAgmvjsvu6MALyXaVLOiTJZc2nwCyMKj2n
         QWrjziYXgOgfb1QXmCOfPLRMt7PNfuByE5jORjv8I3cSqDMi8GoWbOkRStAdp2aqHb0H
         qBVLJ8IgHt2iyerYqypfuAEGxeajLgZYfpFhugn2ECMJdlBJN8ia2cNuVHdscbIvElnO
         pthg==
X-Gm-Message-State: ACrzQf2hO9ecU4WcmzIjAvUeBfo50xpOfggxhlx6ciAyPDdVl98dSDYy
        nGWq+cc3Fdt1RDg+ijdwLiE5VjTJPaCKHap5RFOrbw==
X-Google-Smtp-Source: AMsMyM6MN2i4QFOsG6TOmRT4cmD9zZRF8XxU4VoVShT1r4QoakmftxqylA/JwJDlztOJn6NuD4CeRvlQdvGolhVp25I=
X-Received: by 2002:a2e:7c17:0:b0:26e:4f7:3c95 with SMTP id
 x23-20020a2e7c17000000b0026e04f73c95mr4732936ljc.455.1666031144602; Mon, 17
 Oct 2022 11:25:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com> <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com>
In-Reply-To: <Y02ZLFcDQbX6lP9z@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Mon, 17 Oct 2022 12:25:32 -0600
Message-ID: <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
Subject: Re: [V4 6/8] KVM: selftests: add library for creating/interacting
 with SEV guests
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcorr@google.com, michael.roth@amd.com, thomas.lendacky@amd.com,
        joro@8bytes.org, mizhang@google.com, pbonzini@redhat.com,
        andrew.jones@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 17, 2022 at 12:04 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 17, 2022, Peter Gonda wrote:
> > On Thu, Oct 6, 2022 at 12:25 PM Sean Christopherson <seanjc@google.com> wrote:
> > > And with that, I believe sev_vm_create() can go away entirely and the SEV encryption
> > > stuff can be handled via a new vm_guest_mode.  ____vm_create() already has a gross
> > > __x86_64__ hook that we can tweak, e.g.
> > >
> > > diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > index 54b8d8825f5d..2d6cbca2c01a 100644
> > > --- a/tools/testing/selftests/kvm/lib/kvm_util.c
> > > +++ b/tools/testing/selftests/kvm/lib/kvm_util.c
> > > @@ -238,9 +238,10 @@ struct kvm_vm *____vm_create(enum vm_guest_mode mode, uint64_t nr_pages)
> > >         case VM_MODE_P36V47_16K:
> > >                 vm->pgtable_levels = 3;
> > >                 break;
> > > +       case VM_MODE_PXXV48_4K_SEV:
> > >         case VM_MODE_PXXV48_4K:
> > >  #ifdef __x86_64__
> > > -               kvm_get_cpu_address_width(&vm->pa_bits, &vm->va_bits);
> > > +               kvm_init_vm_address_properties(vm);
> > >                 /*
> > >                  * Ignore KVM support for 5-level paging (vm->va_bits == 57),
> > >                  * it doesn't take effect unless a CR4.LA57 is set, which it
> > >
> > > Then kvm_init_vm_address_properties() can pivot on vm->mode to deal with SEV
> > > specific stuff.
>
> ...
>
> > This refactor sounds good, working on this with a few changes.
> >
> > Instead of kvm_init_vm_address_properties() as you suggested I've added this:
> >
> > @@ -272,6 +275,8 @@ struct kvm_vm *____vm_create(enum vm_guest_mode
> >  mode, uint64_t nr_pages)
> >                 vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> >  #endif
> >
> > +       kvm_init_vm_arch(vm);
>
> Why?  I'm not necessarily opposed to adding kvm_init_vm_arch(), but since x86
> "needs" a dedicated hook to unpack the mode, why not piggyback that one?
>

Well I since I need to do more than just
kvm_init_vm_address_properties() I thought the more generic name would
be better. We need to allocate kvm_vm_arch, find the c-bit, and call
KVM_SEV_INIT. I can put it back in that switch case if thats better,
thoughts?

> > +
> >         vm_open(vm);
> >
> >         /* Limit to VA-bit canonical virtual addresses. */
> >
> > And I need to put kvm_arch_vm_post_create() after the vCPUs are
> > created because the ordering we need is: KVM_SEV_INIT -> Create vCPUS
> > -> KVM_SEV_LAUNCH_FINISH.
>
> Hrm, that's annoying.  Please don't use kvm_arch_vm_post_create() as the name,
> that's a better fit for what Vishal is doing since the "vm_post_create()" implies
> that it's called for "all" VM creation paths, where "all" means "everything
> except barebones VMs".  E.g. in Vishal's series, kvm_arch_vm_post_create() can
> be used to drop the vm_create_irqchip() call in common code.  In your case, IIUC
> the hook will be invoked from __vm_create_with_vcpus().
>
> I'm a little hesitant to have an arch hook for this case since it can't be
> all-or-nothing (again, ignoring barebones VMs).  If a "finalize" arch hook is added,
> then arguably tests that do __vm_create() and manually add vCPUs should call the
> arch hook, i.e. we'd be adding maintenance burden to tests that in all likelihood
> don't care about SEV and never will.
>
> It's somewhat unfortunate, but dedicated vm_sev_create_with_one_vcpu() and
> and vm_sev_create_with_vcpus() wrappers is probably the least awful solution.

Make sense. I think we can go back to your suggestion of
kvm_init_vm_address_properties() above since we can now do all the
KVM_SEV_* stuff. I think this means we don't need to add
VM_MODE_PXXV48_4K_SEV since we can set up the c-bit from inside of
vm_sev_create_*(), thoughts?
