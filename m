Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4982B75454C
	for <lists+kvm@lfdr.de>; Sat, 15 Jul 2023 01:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbjGNXKF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jul 2023 19:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjGNXKE (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jul 2023 19:10:04 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779E61980
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 16:10:03 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9922d6f003cso320581966b.0
        for <kvm@vger.kernel.org>; Fri, 14 Jul 2023 16:10:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689376202; x=1691968202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CtlXy1KLlp4Z9yr6f0vE8608JmRv00GbNepTwupN+LE=;
        b=E9WUWUwO4fT8t1PSs2eneHvRvExhJfDAB1Eiz7qKASKfVkyOHvYwhqSlb7jDvR7Cp2
         wH/kkMTysu7N+XClYuMaQDyCdxSSXS2qg6KcjPj7SHIU5wFPX0fyat9Hva9Oe3CHEEcy
         8dAY0aoypyRqpn+6CxjyzHYrBgviVStGJPhXdJcFNwsPDZX9WRmZKZ5t56f228q5Kkb7
         cJCYrrtypevJTCjG4uyS1tW3Sgc2UwRZXhT9KzT2O+E0cOfeSq0rCBPg0Fp5nKS2hlOu
         Q0OI8Mvra8I0kZKkuee6umJ5KvaUQ4wzBCgQtctCxdPJ5DXcWhY68iy9Cm05c6UXtrIo
         Lrhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689376202; x=1691968202;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CtlXy1KLlp4Z9yr6f0vE8608JmRv00GbNepTwupN+LE=;
        b=kNRyfGa0K+h/Z4OHmq54+nsp4uBhd7mhnhlzj+86bsT4NVfbZGqKl7VwIkUoDLaC/7
         Rbci/n0nG614B+BUEGaIEsNSymOCD0RebV84gMeet7M208j0FdehV4i4OTDBY5FNbIHe
         KufnqcDF2NqLqRfGAe2qVofnLK5EKPT/6NjiOzGnm0HJxdZPOtuMdUIsZMwFVfXa4s3u
         HyzPfPozqGsidpyBLqOEBGvBqO+G24UMJ+xl8ulHOxvA6gkPG3JOFMSNm18HHu1ljE+Q
         DHTpTKeZoyC3Y54sQ+8WdoKMUAmKkBd5pU56zb3x0Orw3y6Vo6l6nZj9GpLBdz3l0d91
         HPFA==
X-Gm-Message-State: ABy/qLYsSImIbs88SOUOXtptO7YFTWNkH78u3SmNOB4Z73RC5bIywTnE
        +Mvp6ZO7QPxi40A71orQWBxFq9pkF0ow5hCcaAOTgw==
X-Google-Smtp-Source: APBJJlEWt+RnTz5aE6m/JAWabL+RG8/hq9gYwcXNzUAKsTyzNO+L298+3KtLUjnyJkm89EAh80GKMWiiPRpnSTIGYKI=
X-Received: by 2002:a17:906:20dd:b0:98d:5293:55f7 with SMTP id
 c29-20020a17090620dd00b0098d529355f7mr5323184ejc.6.1689376201775; Fri, 14 Jul
 2023 16:10:01 -0700 (PDT)
MIME-Version: 1.0
References: <ZFWli2/H5M8MZRiY@google.com> <diqzr0pb2zws.fsf@ackerleytng-ctop.c.googlers.com>
 <ZLGiEfJZTyl7M8mS@google.com>
In-Reply-To: <ZLGiEfJZTyl7M8mS@google.com>
From:   Vishal Annapurve <vannapurve@google.com>
Date:   Fri, 14 Jul 2023 16:09:50 -0700
Message-ID: <CAGtprH-VCqUgqK8gk40KaQZD8trXbWYk8KmA612Og1ep1Dko=Q@mail.gmail.com>
Subject: Re: Rename restrictedmem => guardedmem? (was: Re: [PATCH v10 0/9]
 KVM: mm: fd-based approach for supporting KVM)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Ackerley Tng <ackerleytng@google.com>, david@redhat.com,
        chao.p.peng@linux.intel.com, pbonzini@redhat.com,
        vkuznets@redhat.com, jmattson@google.com, joro@8bytes.org,
        mail@maciej.szmigiero.name, vbabka@suse.cz,
        yu.c.zhang@linux.intel.com, kirill.shutemov@linux.intel.com,
        dhildenb@redhat.com, qperret@google.com, tabba@google.com,
        michael.roth@amd.com, wei.w.wang@intel.com, rppt@kernel.org,
        liam.merwick@oracle.com, isaku.yamahata@gmail.com,
        jarkko@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com, brauner@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 14, 2023 at 12:29=E2=80=AFPM Sean Christopherson <seanjc@google=
.com> wrote:
> ...
> And _if_ there is a VMM that instantiates memory before KVM_CREATE_VM, IM=
O making
> the ioctl() /dev/kvm scoped would have no meaningful impact on adapting u=
serspace
> to play nice with the required ordering.  If userspace can get at /dev/kv=
m, then
> it can do KVM_CREATE_VM, because the only input to KVM_CREATE_VM is the t=
ype, i.e.
> the only dependencies for KVM_CREATE_VM should be known/resolved long bef=
ore the
> VMM knows it wants to use gmem.

I am not sure about the benefits of tying gmem creation to any given
kvm instance. I think the most important requirement here is that a
given gmem range is always tied to a single VM - This can be enforced
when memslots are bound to the gmem files.

I believe "Required ordering" is that gmem files are created first and
then supplied while creating the memslots whose gpa ranges can
generate private memory accesses.
Is there any other ordering we want to enforce here?

> ...
> Practically, I think that gives us a clean, intuitive way to handle intra=
-host
> migration.  Rather than transfer ownership of the file, instantiate a new=
 file
> for the target VM, using the gmem inode from the source VM, i.e. create a=
 hard
> link.  That'd probably require new uAPI, but I don't think that will be h=
ugely
> problematic.  KVM would need to ensure the new VM's guest_memfd can't be =
mapped
> until KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM (which would also need to verify t=
he
> memslots/bindings are identical), but that should be easy enough to enfor=
ce.
>
> That way, a VM, its memslots, and its SPTEs are tied to the file, while a=
llowing
> the memory and the *contents* of memory to outlive the VM, i.e. be effect=
ively
> transfered to the new target VM.  And we'll maintain the invariant that e=
ach
> guest_memfd is bound 1:1 with a single VM.
>
> As above, that should also help us draw the line between mapping memory i=
nto a
> VM (file), and freeing/reclaiming the memory (inode).
>
> There will be extra complexity/overhead as we'll have to play nice with t=
he
> possibility of multiple files per inode, e.g. to zap mappings across all =
files
> when punching a hole, but the extra complexity is quite small, e.g. we ca=
n use
> address_space.private_list to keep track of the guest_memfd instances ass=
ociated
> with the inode.

Are we talking about a different usecase of sharing gmem fd across VMs
other than intra-host migration?
If not, ideally only one of the files should be catering to the guest
memory mappings at any given time. i.e. any inode should be ideally
bound to (through the file) a single kvm instance, as we we are
planning to ensure that guest_memfd can't be mapped until
KVM_CAP_VM_MOVE_ENC_CONTEXT_FROM is invoked on the target side.
