Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D69F61004B
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 20:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235638AbiJ0Sei (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Oct 2022 14:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235484AbiJ0Seg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Oct 2022 14:34:36 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BD49FE6
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:34:34 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id j14so4872869ljh.12
        for <kvm@vger.kernel.org>; Thu, 27 Oct 2022 11:34:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rImRM8lUYQwKUuhHi33Xv0slNDyY9fPfRBiZY4CGcO8=;
        b=pIlYlWR1qxP4Us0NHBx+aE76CTtlViPPRDK3+wueE5cjtAq26qHBbWpEP4mIjWcUWZ
         YVqZdbRf/W6tdLjzUiVroX2d9vVt5fF8sEmwQ4q3YwQ/mfA/fdY2ABeCNLfIoTgbLNuA
         aKsWrjullJiJp3MadhZ6dYErUCpCbX6Cs+6xawriBBcmT0OoYA2rUM9f0xI/8SMB65Q8
         xsWL2A/0fBFwIcztXgMaUUQnMSOK7d9fdhoko7WN9UjBzfiQs03EnomhdDdAaHU/zbd0
         lURafjqfblsqGQbyXeMOKpRy1Pwb5w1mAXuN7rTyeL24PRCL8k1GXLoARqARraNlQqGe
         Za6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rImRM8lUYQwKUuhHi33Xv0slNDyY9fPfRBiZY4CGcO8=;
        b=Zbdc3YYzYXKDQuB1O9KmlF3ikHafElO9AYzNUp/uTx06CkrWTVtNiwPlM5f8Dr+sFr
         Tsvqsd1dEYXhlJuVk/ZfHLOEiV7jmtLsSUeNa5PCbia/R5SuOFiF7oigFSUubYit/rXf
         yiBIOSmF9mhIT09+54AqbsW4VtgENAnux/yed1xzmxO7wtgaJ1cCDY8saEGl4EeV6GbD
         6PYpSIEhJOwRiqhgZS4uT/kywtewG6fnxpYD3h25ovy6hFhW0ra+rfK2jVpIaoBb1zdO
         xoqmjIkrqg2uj5xtYspLxUcfIjkNrrPQ0PfoiXGr+Sc2KVe2mDiEpAGAeXZhSpDV7dM/
         x7MQ==
X-Gm-Message-State: ACrzQf1ueWsWUaq6h/WD0ViTQED/VxMO2cyerD3w+c6aVJJI6bG9jNBi
        l/qbkUZDbTGebnOTrOeMMxzvC8e4jmRvj+OqP+oiaQ==
X-Google-Smtp-Source: AMsMyM79FbIl/dMM63/B6tvA+SnZTqv8/GlFeOpCpeOri6dVgmO2Wd/Omcxzo0njdk/R6ksMkMC4fWKCa7d2zmPIUDs=
X-Received: by 2002:a2e:94cf:0:b0:26c:5d14:6ec7 with SMTP id
 r15-20020a2e94cf000000b0026c5d146ec7mr20536772ljh.237.1666895671322; Thu, 27
 Oct 2022 11:34:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220829171021.701198-1-pgonda@google.com> <20220829171021.701198-7-pgonda@google.com>
 <Yz8dpB5+RFjEhA3n@google.com> <CAMkAt6oZQc4jqF7FOXOKkpbP3c4NXxPumVVjX9gXwPCh-zbtYg@mail.gmail.com>
 <Y02ZLFcDQbX6lP9z@google.com> <CAMkAt6q0g5Ua=PwLXa2oA4zCQUaHuEQ3pTXycD61HU6-dtQ5Gg@mail.gmail.com>
 <Y028WrU3pmEQqWDq@google.com> <CAMkAt6pvT15teuYWjz7r1vmUP5McDp76qjxQ26_oeg5mTnv5NA@mail.gmail.com>
 <Y1AnHwVtOFShRxQD@google.com> <CAMkAt6rP7KbgUqmK+aiooSLfvRrMsRmp99cL0YWKBwpOJZc82A@mail.gmail.com>
 <Y1rHDlDskvSacLNp@google.com>
In-Reply-To: <Y1rHDlDskvSacLNp@google.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Thu, 27 Oct 2022 12:34:19 -0600
Message-ID: <CAMkAt6p+npmn_AKH3pA6d1mRY2VURkEcpXSaKqg_=KPm6B9WkQ@mail.gmail.com>
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
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 27, 2022 at 11:59 AM Sean Christopherson <seanjc@google.com> wrote:
>
> On Thu, Oct 27, 2022, Peter Gonda wrote:
> > On Wed, Oct 19, 2022 at 10:34 AM Sean Christopherson <seanjc@google.com> wrote:
> > >
> > > On Tue, Oct 18, 2022, Peter Gonda wrote:
> > > > On Mon, Oct 17, 2022 at 2:34 PM Sean Christopherson <seanjc@google.com> wrote:
> > > > >
> > > > > On Mon, Oct 17, 2022, Peter Gonda wrote:
> > > > > > I think this means we don't need to add VM_MODE_PXXV48_4K_SEV since we
> > > > > > can set up the c-bit from inside of vm_sev_create_*(), thoughts?
> > > > >
> > > > > Configuring the C-bit inside vm_sev_create_*() won't work (at least not well).
> > > > > The C-bit needs to be known before kvm_vm_elf_load(), i.e. can't be handled after
> > > > > __vm_create(), and needs to be tracked inside the VM, i.e. can't be handled before
> > > > > __vm_create().
> > > > >
> > > > > The proposed kvm_init_vm_address_properties() seems like the best fit since the
> > > > > C-bit (and TDX's S-bit) is stolen from GPA space, i.e. directly affects the other
> > > > > values computed in that path.
> > > > >
> > > > > As for the kvm_vm_arch allocation ugliness, when we talked off-list I didn't
> > > > > consider the need to allocate in kvm_init_vm_address_properties().  That's quite
> > > > > gross, especially since the pointer will be larger than the thing being allocated.
> > > > >
> > > > > With that in mind, adding .../include/<arch>/kvm_util.h so that "struct kvm_vm_arch"
> > > > > can be defined and referenced directly doesn't seem so bad.  Having to stub in the
> > > > > struct for the other architectures is annoying, but not the end of the world.
> > > >
> > > > I'll make "struct kvm_vm_arch" a non pointer member, so adding
> > > > /include/<arch>/kvm_util.h files.
> > > >
> > > > But I think we do not need VM_MODE_PXXV48_4K_SEV, see:
> > >
> > > I really don't want to open code __vm_create() with a slight tweak.  E.g. the
> > > below code will be broken by Ricardo's series to add memslot0 is moved out of
> > > ____vm_create()[1], and kinda sorta be broken again by Vishal's series to add an
> > > arch hook to __vm_create()[2].
> > >
> > > AFAICT, there is no requirement that KVM_SEV_INIT be called before computing the
> > > C-Bit, the only requirement is that KVM_SEV_INIT is called before adding vCPUs.
> > >
> > > [1] https://lore.kernel.org/all/20221017195834.2295901-8-ricarkol@google.com
> > > [2] https://lore.kernel.org/all/YzsC4ibDqGh5qaP9@google.com
> >
> > Oh I misunderstood your suggestion above.
> >
> > I should make KVM_SEV_INIT happen from kvm_arch_vm_post_create().  Add
> > VM_MODE_PXXV48_4K_SEV for c-bit setting inside of
> > kvm_init_vm_address_properties().
> >
> > Inside of vm_sev_create_with_one_vcpu() I use
> > __vm_create_with_vcpus(), then call KVM_SEV_LAUNCH_FINISH.
> >
> > Is that correct?
>
> Yep, I'm pretty sure that was what I was thinking.

Duh! Should have realized that at first. You said you were going to
rebase your selftest series. I'll follow up with a V6 ontop of that
rebase.
