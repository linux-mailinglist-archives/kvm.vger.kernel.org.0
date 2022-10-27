Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72F8760FD07
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 18:25:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbiJ0QZf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 12:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236554AbiJ0QZP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 12:25:15 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE3918E1E
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:25:12 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id bs14so3504130ljb.9
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 09:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5AbOZPPx5VkNSMFzPpXkxxoX+EZvXcp8nmUZDe8dyso=;
        b=s2e/ipfA55884ao3QvXnpN3xLnz1VbWNFLuEz67qHxdi5pMLO1NRK6IwJ6FG3kD7jE
         Gx9AyAh+8/3p+8OA2nczu1Zor5Ws3p2FALXWAsTsniWq0pmuamQybNOfoU5Whwtnc3TH
         R8rsHYpnV68OhCYzlIQrcXNJE5SceGJ1a1MI4J6SmHf0J+40Oagj3OjT8MNIKEJfyLPO
         wujFXtrNfiFHPNepeDqyo5AI1AimLW41PsEuD3OP7nfwC82rUO+fdGTlnur2bKslbuNb
         doHcUWw+Q6Leo62hunr+w2pMxtXbVIUvKgznZwWOGHpG5/DEwPS9YhnJ65kNuP03cZpq
         Q8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5AbOZPPx5VkNSMFzPpXkxxoX+EZvXcp8nmUZDe8dyso=;
        b=tyV+2jrxgviIiMoYY8+ogSo2lW1yeB7nf1/8qeBBZFF2F80azv7AsKf4QPstO6j+l6
         Yb9le8TSwj5A/eqe93oOgc76Melfynxr7HcThV8DjkTE4ZQIf1EqnK3VqiQFRw47QLRx
         BSwO5goZSnhdNf9OwvAdD++iwlJESdfgKgghVXpmxjeWOutL8RZ/j3cD1B1yEq7vZX9E
         Hl61XGcpHVruCOdhl/pPCwao0NvvPHRJ3/F5r/a+rWJHQnzJ63+IRQdEuPwTjVJsu41R
         YXaUP4eA6OyAuaXV488J/hSq4M2lwzFYbT/jowLNo5A4vrQPO5SQp/eVKygfyC/+olPY
         56sQ==
X-Gm-Message-State: ACrzQf3eo6u/9ydEF/ouLOfHfQWAYr8i70Zhik+NTFu/zcvBuiyTf0QW
        s64bZ2jTHBI8t8mqcRkDQh4Glax0DweMu77QCAfHUg==
X-Google-Smtp-Source: AMsMyM6vHcvJV2pfaDrNFAgv1Q8Qn13qvYkx9fy7AGO71Sx4c0l4LJYay1eilZ8R1MZC1Vl+kqqwpX5qhC4ZIs5/Cbs=
X-Received: by 2002:ac2:4e0c:0:b0:4a2:4042:8698 with SMTP id
 e12-20020ac24e0c000000b004a240428698mr17893141lfr.170.1666887910328; Thu, 27
 Oct 2022 09:25:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com> <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com> <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
 <Y028WrU3pmEQqWDq@google.com> <CAMkAt6pvT15teuYWjz7r1vmUP5McDp76qjxQ26_oeg5mTnv5NA@mail.gmail.com>
 <Y1AnHwVtOFShRxQD@google.com>
In-Reply-To: <Y1AnHwVtOFShRxQD@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 27 Oct 2022 10:24:58 -0600
Message-ID: <CAMkAt6rP7KbgUqmK+aiooSLfvRrMsRmp99cL0YWKBwpOJZc82A@mail.gmail.com>
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

On Wed, Oct 19, 2022 at 10:34 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Tue, Oct 18, 2022, Peter Gonda wrote:
> > On Mon, Oct 17, 2022 at 2:34 PM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Mon, Oct 17, 2022, Peter Gonda wrote:
> > > > I think this means we don't need to add VM_MODE_PXXV48_4K_SEV since we
> > > > can set up the c-bit from inside of vm_sev_create_*(), thoughts?
> > >
> > > Configuring the C-bit inside vm_sev_create_*() won't work (at least not well).
> > > The C-bit needs to be known before kvm_vm_elf_load(), i.e. can't be handled after
> > > __vm_create(), and needs to be tracked inside the VM, i.e. can't be handled before
> > > __vm_create().
> > >
> > > The proposed kvm_init_vm_address_properties() seems like the best fit since the
> > > C-bit (and TDX's S-bit) is stolen from GPA space, i.e. directly affects the other
> > > values computed in that path.
> > >
> > > As for the kvm_vm_arch allocation ugliness, when we talked off-list I didn't
> > > consider the need to allocate in kvm_init_vm_address_properties().  That's quite
> > > gross, especially since the pointer will be larger than the thing being allocated.
> > >
> > > With that in mind, adding .../include/<arch>/kvm_util.h so that "struct kvm_vm_arch"
> > > can be defined and referenced directly doesn't seem so bad.  Having to stub in the
> > > struct for the other architectures is annoying, but not the end of the world.
> >
> > I'll make "struct kvm_vm_arch" a non pointer member, so adding
> > /include/<arch>/kvm_util.h files.
> >
> > But I think we do not need VM_MODE_PXXV48_4K_SEV, see:
>
> I really don't want to open code __vm_create() with a slight tweak.  E.g. the
> below code will be broken by Ricardo's series to add memslot0 is moved out of
> ____vm_create()[1], and kinda sorta be broken again by Vishal's series to add an
> arch hook to __vm_create()[2].
>
> AFAICT, there is no requirement that KVM_SEV_INIT be called before computing the
> C-Bit, the only requirement is that KVM_SEV_INIT is called before adding vCPUs.
>
> [1] https://lore.kernel.org/all/20221017195834.2295901-8-ricarkol@google.com
> [2] https://lore.kernel.org/all/YzsC4ibDqGh5qaP9@google.com

Oh I misunderstood your suggestion above.

I should make KVM_SEV_INIT happen from kvm_arch_vm_post_create().  Add
VM_MODE_PXXV48_4K_SEV for c-bit setting inside of
kvm_init_vm_address_properties().

Inside of vm_sev_create_with_one_vcpu() I use
__vm_create_with_vcpus(), then call KVM_SEV_LAUNCH_FINISH.

Is that correct?



>
> > struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t policy, void *guest_code,
> >                                            struct kvm_vcpu **cpu)
> > {
> >         enum vm_guest_mode mode = VM_MODE_PXXV48_4K;
> >         uint64_t nr_pages = vm_nr_pages_required(mode, 1, 0);
> >         struct kvm_vm *vm;
> >         uint8_t measurement[512];
> >         int i;
> >
> >         vm = ____vm_create(mode, nr_pages);
> >
> >         kvm_sev_ioctl(vm, KVM_SEV_INIT, NULL);
> >
> >         configure_sev_pte_masks(vm);
> >
> >         *cpu = vm_vcpu_add(vm, 0, guest_code);
> >         kvm_vm_elf_load(vm, program_invocation_name);
> >
> >         sev_vm_launch(vm, policy);
> >
> >         /* Dump the initial measurement. A test to actually verify it
> > would be nice. */
> >         sev_vm_launch_measure(vm, measurement);
> >         pr_info("guest measurement: ");
> >         for (i = 0; i < 32; ++i)
> >                 pr_info("%02x", measurement[i]);
> >         pr_info("\n");
> >
> >         sev_vm_launch_finish(vm);
> >
> >         return vm;
> > }
