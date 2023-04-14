Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51BD96E2A77
	for <lists+kvm@lfdr.de>; Fri, 14 Apr 2023 21:09:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbjDNTJc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 15:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjDNTJb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 15:09:31 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63A61703
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 12:09:28 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id i6so12928896lfp.1
        for <kvm@vger.kernel.org>; Fri, 14 Apr 2023 12:09:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681499367; x=1684091367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jVnUlhBA6jdlz83dcJuvBqHrUvd0hrnnS1oyxuPo19o=;
        b=n+f05nLeF9RRty+4PwYX2MJg35RU6XoRr+aQ19NimDsWDexyxXCssREQrw7SW0a+os
         Iiyatkx5HMRAITqlMSWlD250jp074ZpMQTZFA9Vky6cBe5M6L6C/uopa5mUK/zjuNVJb
         mClWHu6XEOn0ft7bPzsulddypbIq4+JXVkzb3TDdSYLGoxD0G7qLgrfaKJwrR+rC3UXG
         7n5F9ieBZ4jJ+6Hm4PAmAL+JEDjSlXNfjMTDTg+bc390JlShIvanch/UD0BJlrQFiWrM
         ZzRil+jfJNwT5qx/fUzCxC2Ye7qfT8f+Z7Hq9HvjsbyRoiW4q+v5DRRf1TX7TOPQmfRL
         69WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681499367; x=1684091367;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jVnUlhBA6jdlz83dcJuvBqHrUvd0hrnnS1oyxuPo19o=;
        b=d1VjjPS5YAC9DrL/PDe3aGgW+ek+npuuJSEjBciatRoH6EcjykzG6jUmgE4NWh+iw7
         HkkLXaHfozVBI9ndjoJp4U5ofXGYnsEkGe3CEZFY5kZS3Iltt87c2TMBNzVB7YFj+UHP
         IJLhKgqndwnaAegiiTA73BDV8GINQkVEqZwW4HTkzawdW15pgEBwZLnvwGNfcroKorn4
         GUbeZhPi6Lnp1j2cvpiFO/qiVUqAOu4hhn2L5aYC3MWYB7j136PZeXlYHtpUubgi8j3E
         NDTOILt01I7tfO4qouuovg8ShgQ/abVUcIeptzbFKp1MIQLosJGDDTBqtuXqFe04RF98
         rvUw==
X-Gm-Message-State: AAQBX9dSw/BjHW25QwWFEIRlSiBWHlKt6DSAZHliI40rQdTzDyO7TnOx
        AUotYIQFjlA7ZRhACLWj98NnkY9VA7zIf1DFNwoN+g==
X-Google-Smtp-Source: AKy350b8TidBfwv6qQzVGUQWXE7sAbTgCZlg7xzVKfrDkf6OsFRioS7iHXlH0PzzFYOYdb1JlfpxYyihqWlf6Tu7heA=
X-Received: by 2002:ac2:454e:0:b0:4db:1c2a:a96e with SMTP id
 j14-20020ac2454e000000b004db1c2aa96emr39617lfm.9.1681499366734; Fri, 14 Apr
 2023 12:09:26 -0700 (PDT)
MIME-Version: 1.0
References: <20230407201921.2703758-1-sagis@google.com> <20230414100350.00000955.zhi.wang.linux@gmail.com>
In-Reply-To: <20230414100350.00000955.zhi.wang.linux@gmail.com>
From:   Sagi Shahar <sagis@google.com>
Date:   Fri, 14 Apr 2023 12:09:15 -0700
Message-ID: <CAAhR5DEdX0SOfRTwzCdBSNvfUwf_z6BT6TGaaCY-Uuis=URqiQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/5] Add TDX intra host migration support
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Erdem Aktas <erdemaktas@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
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

On Fri, Apr 14, 2023 at 12:04=E2=80=AFAM Zhi Wang <zhi.wang.linux@gmail.com=
> wrote:
>
> On Fri,  7 Apr 2023 20:19:16 +0000
> Sagi Shahar <sagis@google.com> wrote:
>
> Hi:
>
> Is there any userspace using these APIs? I cant find them in AMD-QEMU rep=
o
> and upstream QEMU repo. It would nice to first take a look on how userspa=
ce
> is going to use it.
>
We are using a different userspace VMM internally so we didn't make
changes to QEMU.
I've uploaded our selftests which exercise these APIs to our public
GitHub so you can take a look there:
https://github.com/googleprodkernel/linux-cc/commit/62c8dba4c3cf06e37501807=
7a6d9f491c933dc6d

Note that these are a slightly older version based on TDX V10 API.
They also use the
KVM_CAP_VM_COPY_ENC_CONTEXT_FROM instead of KVM_CAP_VM_MOVE_ENC_CONTEXT_FRO=
M

> > This patchset adds support for TDX intra host migration using the same
> > API which was added for SEV intra host migration here:
> > https://lore.kernel.org/all/20211021174303.385706-1-pgonda@google.com/
> >
> > This patchset relies on the latest TDX patches from Intel:
> > - fd-based approach for supporing KVM v10 and
> >   https://lore.kernel.org/lkml/20221202061347.1070246-1-chao.p.peng@lin=
ux.intel.com/
> > - TDX host kernel support v10
> >   https://lore.kernel.org/lkml/cover.1678111292.git.kai.huang@intel.com=
/
> > - KVM TDX basic feature support v13
> >   https://lore.kernel.org/cover.1678643051.git.isaku.yamahata@intel.com
> >
> > The tree can be found at https://github.com/googleprodkernel/linux-cc/t=
ree/copyless
> > and is based on Intel's tdx tree at https://github.com/intel/tdx/tree/k=
vm-upstream
> >
> > In the TDX case, we need to transfer the VM state from multiple sources=
:
> >
> >  * HKID and encrypted VM state is transfered between the kvm_tdx
> >    objects.
> >  * Encrypted and runtime state is transfered between the vcpu_tdx
> >    objects.
> >  * The EPT table backing TD's private memory is transfered at the
> >    kvm-mmu level. This is needed since the secure EPT table managed by
> >    the TD module remains the same after the migration so moving the
> >    current private EPT table eliminates the need to rebuild the private
> >    EPT table to match the secure EPT table on the destination.
> >  * Information regarding the current shared/private memory is trasfered
> >    using the mem_attr_array stored at the kvm object.
> >  * Additional information derived from shared/private memory state is
> >    trasfered at the memslot level.
> >
> > Tested with selftests locally. I will attach the self test in the next
> > version after we send the new TDX selftest framework patches based on
> > KVM TDX basic feature support v13.
> >
> > Sagi Shahar (5):
> >   KVM: Split tdp_mmu_pages to private and shared lists
> >   KVM: SEV: Refactor common code out of sev_vm_move_enc_context_from
> >   KVM: TDX: Add base implementation for tdx_vm_move_enc_context_from
> >   KVM: TDX: Implement moving private pages between 2 TDs
> >   KVM: TDX: Add core logic for TDX intra-host migration
> >
> >  arch/x86/include/asm/kvm_host.h |   5 +-
> >  arch/x86/kvm/mmu.h              |   2 +
> >  arch/x86/kvm/mmu/mmu.c          |  60 ++++++++
> >  arch/x86/kvm/mmu/tdp_mmu.c      |  88 +++++++++++-
> >  arch/x86/kvm/mmu/tdp_mmu.h      |   3 +
> >  arch/x86/kvm/svm/sev.c          | 175 +++--------------------
> >  arch/x86/kvm/vmx/main.c         |  10 ++
> >  arch/x86/kvm/vmx/tdx.c          | 245 ++++++++++++++++++++++++++++++++
> >  arch/x86/kvm/vmx/tdx.h          |   2 +
> >  arch/x86/kvm/vmx/x86_ops.h      |   5 +
> >  arch/x86/kvm/x86.c              | 166 ++++++++++++++++++++++
> >  arch/x86/kvm/x86.h              |  16 +++
> >  12 files changed, 613 insertions(+), 164 deletions(-)
> >
>
