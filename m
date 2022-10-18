Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA172602F0C
	for <lists+kvm@lfdr.de>; Tue, 18 Oct 2022 17:00:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiJRO77 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Oct 2022 10:59:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbiJRO75 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Oct 2022 10:59:57 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4634F40015
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:59:55 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id s20so22950498lfi.11
        for <kvm@vger.kernel.org>; Tue, 18 Oct 2022 07:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lYrie4UT5hMp1hkII136MefcVp75Ib7e68vnqkG16Pc=;
        b=cd1ADZB/0EC+8KIbN69XzJIqS0kCUC4kJyyq/X5H8U9eHkDgH3jDbuZrCWR+GWxuWP
         MBsYwzZttATQp3Jpv+aO5JT0ImAlgApe+HrsPVD6EcjGt+f1Bzxj9j6d5PBTgeN6usT3
         FHb+JfbYJV9v7YeNBFe1uh5yvJDW5IraF6SJajXdcE9ccBKTDgP/B6GGDo4DePNMP1qX
         mJaiz20i7a6q7mFvv2bj5PUv3F0RUNSyl3SHx/b0sVOUUtn2AuV0KNE7Fd/kCyStmisz
         5/LhiE0QoehwCirHHux+C38XDW3Q9++txKhjck6U6WEH1eeR8C5U6B/yc9QbamTdlGit
         qD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lYrie4UT5hMp1hkII136MefcVp75Ib7e68vnqkG16Pc=;
        b=Us0x7utrybJO4X1dkaRak+9hzq2FzpRXPKb/RjpVDsMq4c6BnTorhM6Hnwop0ljFjF
         BgQbjDWkSkeK5HbEcPbUJJSfa6wyLl6aQWNWil+fBky4eHP75MgRbJb9idJ6RLsCJ5m7
         7UEsnDDUA5bEVkvPD8l/oo+aBCxDxh6py1P6fbFesnTVdWkgWELxjzmhdMS4TjayoxMy
         OgVdKpw0xRRAfzc2aUwYzoDGSkg2hSNetwoRVsdOY2z6NG628K/bXlkNCsJqOyjOKsRH
         8K/zKyiUTXENfE3YUHrFJf/ef9QcTqZbZvL5GghZdVLa75juoXjmb9bKoc1H1+FHxp4E
         FFfg==
X-Gm-Message-State: ACrzQf1e7gZTPENP+i31ZOcG3qsH/1rvu1IHxHoimdHXQeuXcuN3V58c
        mu4GLpsspPAux5iiSkKvFJlODF1A7d/Z0Xq5Qa4kWA==
X-Google-Smtp-Source: AMsMyM5XwfMnXRbvHP4edGUVgtisf62Gh0MV76ebekK8GwU1N/ss0ilrXOQrSWkpUokjJjHAQDlTBqZ/O70ux3GP/Y4=
X-Received: by 2002:a19:5f52:0:b0:4a2:2429:c6d5 with SMTP id
 a18-20020a195f52000000b004a22429c6d5mr1279215lfj.291.1666105192923; Tue, 18
 Oct 2022 07:59:52 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com> <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com> <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
 <Y028WrU3pmEQqWDq@google.com>
In-Reply-To: <Y028WrU3pmEQqWDq@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Tue, 18 Oct 2022 08:59:40 -0600
Message-ID: <CAMkAt6pvT15teuYWjz7r1vmUP5McDp76qjxQ26_oeg5mTnv5NA@mail.gmail.com>
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

On Mon, Oct 17, 2022 at 2:34 PM Sean Christopherson <seanjc@google.com> wrote:
>
> On Mon, Oct 17, 2022, Peter Gonda wrote:
> > On Mon, Oct 17, 2022 at 12:04 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Oct 17, 2022, Peter Gonda wrote:
> > > > This refactor sounds good, working on this with a few changes.
> > > >
> > > > Instead of kvm_init_vm_address_properties() as you suggested I've added this:
> > > >
> > > > @@ -272,6 +275,8 @@ struct kvm_vm *____vm_create(enum vm_guest_mode
> > > >  mode, uint64_t nr_pages)
> > > >                 vm->type = KVM_VM_TYPE_ARM_IPA_SIZE(vm->pa_bits);
> > > >  #endif
> > > >
> > > > +       kvm_init_vm_arch(vm);
> > >
> > > Why?  I'm not necessarily opposed to adding kvm_init_vm_arch(), but since x86
> > > "needs" a dedicated hook to unpack the mode, why not piggyback that one?
> > >
> >
> > Well I since I need to do more than just
> > kvm_init_vm_address_properties() I thought the more generic name would
> > be better. We need to allocate kvm_vm_arch, find the c-bit, and call
> > KVM_SEV_INIT. I can put it back in that switch case if thats better,
> > thoughts?
> >
> > > > +
> > > >         vm_open(vm);
> > > >
> > > >         /* Limit to VA-bit canonical virtual addresses. */
> > > >
> > > > And I need to put kvm_arch_vm_post_create() after the vCPUs are
> > > > created because the ordering we need is: KVM_SEV_INIT -> Create vCPUS
> > > > -> KVM_SEV_LAUNCH_FINISH.
> > >
> > > Hrm, that's annoying.  Please don't use kvm_arch_vm_post_create() as the name,
> > > that's a better fit for what Vishal is doing since the "vm_post_create()" implies
> > > that it's called for "all" VM creation paths, where "all" means "everything
> > > except barebones VMs".  E.g. in Vishal's series, kvm_arch_vm_post_create() can
> > > be used to drop the vm_create_irqchip() call in common code.  In your case, IIUC
> > > the hook will be invoked from __vm_create_with_vcpus().
> > >
> > > I'm a little hesitant to have an arch hook for this case since it can't be
> > > all-or-nothing (again, ignoring barebones VMs).  If a "finalize" arch hook is added,
> > > then arguably tests that do __vm_create() and manually add vCPUs should call the
> > > arch hook, i.e. we'd be adding maintenance burden to tests that in all likelihood
> > > don't care about SEV and never will.
> > >
> > > It's somewhat unfortunate, but dedicated vm_sev_create_with_one_vcpu() and
> > > and vm_sev_create_with_vcpus() wrappers is probably the least awful solution.
> >
> > Make sense. I think we can go back to your suggestion of
> > kvm_init_vm_address_properties() above since we can now do all the
> > KVM_SEV_* stuff. I think this means we don't need to add
> > VM_MODE_PXXV48_4K_SEV since we can set up the c-bit from inside of
> > vm_sev_create_*(), thoughts?
>
> Configuring the C-bit inside vm_sev_create_*() won't work (at least not well).
> The C-bit needs to be known before kvm_vm_elf_load(), i.e. can't be handled after
> __vm_create(), and needs to be tracked inside the VM, i.e. can't be handled before
> __vm_create().
>
> The proposed kvm_init_vm_address_properties() seems like the best fit since the
> C-bit (and TDX's S-bit) is stolen from GPA space, i.e. directly affects the other
> values computed in that path.
>
> As for the kvm_vm_arch allocation ugliness, when we talked off-list I didn't
> consider the need to allocate in kvm_init_vm_address_properties().  That's quite
> gross, especially since the pointer will be larger than the thing being allocated.
>
> With that in mind, adding .../include/<arch>/kvm_util.h so that "struct kvm_vm_arch"
> can be defined and referenced directly doesn't seem so bad.  Having to stub in the
> struct for the other architectures is annoying, but not the end of the world.

I'll make "struct kvm_vm_arch" a non pointer member, so adding
/include/<arch>/kvm_util.h files.

But I think we do not need VM_MODE_PXXV48_4K_SEV, see:

struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
                                           struct kvm_vcpu **cpu)
{
        enum vm_guest_mode mode = VM_MODE_PXXV48_4K;
        uint64_t nr_pages = vm_nr_pages_required(mode, 1, 0);
        struct kvm_vm *vm;
        uint8_t measurement[512];
        int i;

        vm = ____vm_create(mode, nr_pages);

        kvm_sev_ioctl(vm, KVM_SEV_INIT, NULL);

        configure_sev_pte_masks(vm);

        *cpu = vm_vcpu_add(vm, 0, guest_code);
        kvm_vm_elf_load(vm, program_invocation_name);

        sev_vm_launch(vm, policy);

        /* Dump the initial measurement. A test to actually verify it
would be nice. */
        sev_vm_launch_measure(vm, measurement);
        pr_info("guest measurement: ");
        for (i = 0; i < 32; ++i)
                pr_info("%02x", measurement[i]);
        pr_info("\n");

        sev_vm_launch_finish(vm);

        return vm;
}
