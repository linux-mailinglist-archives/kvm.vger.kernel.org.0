Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A5247150E
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 18:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbhLKRr1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 11 Dec 2021 12:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhLKRr0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 11 Dec 2021 12:47:26 -0500
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 761C0C061714
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 09:47:26 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id cf39so11480776lfb.8
        for <kvm@vger.kernel.org>; Sat, 11 Dec 2021 09:47:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=duVrd96PNRshWKtg4UOlv42sD0qi3K1fzHB5Mspl/Ko=;
        b=QCeACeMXD8DaL2BL5PZ+mEJmegRIOcsHYaoANjrLNBtTQk4dK9qzAPKZoORJ7lszWA
         FzGjPNyuwpIjiSPwK2wHSKRQLtzMM587r36d1pXcEG5jgHk7Qe7rp1En/VgwDGHwAc+5
         DP9yOY+68yArWwHHNmtyflDc9lJzlOrSeg2uZ9qxriKM/mrBcyWIDaGffN2aUNLigv3e
         PGTk8PbBoDfyjU3d3guvhZ8Ve9OT3REugAsv7iN3VlUN5FlBYOxZzGGbe7zXhI2E1IPG
         jbNhv1jk65kafqPxtbVtYtkex+Wn4AnPTH3vqNLvpwVWfIyu9MubA5Ui9TcoQNlGzO2N
         fCAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=duVrd96PNRshWKtg4UOlv42sD0qi3K1fzHB5Mspl/Ko=;
        b=jpwaMarNYVIT5E/sldu+TWoWM66iDPVc6Qlce+YtcwbyH14zx5AL/oSZZcp4dUIjoJ
         /UDJEL4OYiwuL0zMiHjwA+MgagD9iJFKd7SC4cy4WOiA1b3pNWKqaCDlSfDlwc2beH5d
         rOMw+4wVYzRQin6svxlZSI6zEeATX+z4Ar1jN4tIwNos8IQdlrf8T9CWmdi6GUNOR5AR
         Ib+d98Hnhvftn5sMhptsJrFr6cPxzHhaJ3jO3gooptfO7uqRIsuSa1mZo1md6uyZ+UHg
         iRuGcXG+EQJVx8x29uEfOld9FKYNxUrY7hslHphOt+uyx+UsNiEzuyXJwYOl4SKUmJ9R
         Ez9A==
X-Gm-Message-State: AOAM531l+Wj8za39tmA+xZ4Bck8MqSSQ3qqwwABYI34oV/C/xtQMOFYu
        RPbzE5zvFzUYsGyN97aSvW1ZnixD6keQLKJ2qizozQ==
X-Google-Smtp-Source: ABdhPJxNE8S9ES8bR36etOmpzMEtkh7K6QbS5Pp+C+L2iNC7nNAOaBy5T0rURuBjGGM+uNj+lBdlyLcRgrQEqko2/Wg=
X-Received: by 2002:a05:6512:3503:: with SMTP id h3mr20039161lfs.235.1639244844213;
 Sat, 11 Dec 2021 09:47:24 -0800 (PST)
MIME-Version: 1.0
References: <CALrw=nEaWhpG1y7VNTGDFfF1RWbPvm5ka5xWxD-YWTS3U=r9Ng@mail.gmail.com>
 <d49e157a-5915-fbdc-8103-d7ba2621aea9@redhat.com> <CALrw=nHTJpoSFFadmDL2EL95D2kAiH5G-dgLvU0L7X=emxrP2A@mail.gmail.com>
 <YaaIRv0n2E8F5YpX@google.com> <CALrw=nGrAhSn=MkW-wvNr=UnaS5=t24yY-TWjSvcNJa1oJ85ww@mail.gmail.com>
 <CALrw=nE+yGtRi-0bFFwXa9R8ydHKV7syRYeAYuC0EBTvdFiidQ@mail.gmail.com>
 <CALzav=fyaXAn4CLRW2qKTrROGUh6+F4bphhfoMZ13Qp5Njx3gw@mail.gmail.com> <e995aceb-40cc-e4cc-f3c8-2e8c2877a896@redhat.com>
In-Reply-To: <e995aceb-40cc-e4cc-f3c8-2e8c2877a896@redhat.com>
From:   David Matlack <dmatlack@google.com>
Date:   Sat, 11 Dec 2021 09:46:57 -0800
Message-ID: <CALzav=d2-Q2GfuSZYo7J-SZyt9vH7GLZeSTNYtKPE=H+p0RLsw@mail.gmail.com>
Subject: Re: Potential bug in TDP MMU
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Ignat Korchagin <ignat@cloudflare.com>, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>, stevensd@chromium.org,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 10, 2021 at 5:49 PM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 12/11/21 02:34, David Matlack wrote:
> > The stacks help, thanks for including them. It seems like a race
> > during do_exit teardown. One thing I notice is that
> > do_exit->mmput->kvm_mmu_zap_all can interleave with
> > kvm_vcpu_release->kvm_tdp_mmu_put_root (full call chains omitted),
> > since the former path allows yielding. But I don't yet see that could
> > lead to any issues, let alone cause us to encounter a PFN in the EPT
> > with a zero refcount.
>
> Can it? The call chains are
>
>      zap_gfn_range+2229
>      kvm_tdp_mmu_put_root+465
>      kvm_mmu_free_roots+629
>      kvm_mmu_unload+28
>      kvm_arch_destroy_vm+510
>      kvm_put_kvm+1017
>      kvm_vcpu_release+78
>      __fput+516
>      task_work_run+206
>      do_exit+2615
>      do_group_exit+236
>
> and
>
>      zap_gfn_range+2229
>      __kvm_tdp_mmu_zap_gfn_range+162
>      kvm_tdp_mmu_zap_all+34
>      kvm_mmu_zap_all+518
>      kvm_mmu_notifier_release+83
>      __mmu_notifier_release+420
>      exit_mmap+965
>      mmput+167
>      do_exit+2482
>      do_group_exit+236
>
> but there can be no parallelism or interleaving here, because the call
> to kvm_vcpu_release() is scheduled in exit_files() (and performed in
> exit_task_work()).  That comes after exit_mm(), where mmput() is called.

Ah I was thinking each thread in the process would be run do_exit()
concurrently (first thread enters mmput() but the refcount is not at
zero and proceeds to task_work_run, second enters mmput() and the
refcount is at zero and invokes notifier->release()).

>
> Even if the two could interleave, they go through the same zap_gfn_range
> path.  That path takes the lock for write and only yields on the 512
> top-level page structures.  Anything below is handled by
> tdp_mmu_set_spte's (with mutual recursion between handle_changed_spte
> and handle_removed_tdp_mmu_page), and there are no yields on that path.
>
> Paolo
