Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDFB43C6224
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhGLRsL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:48:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231592AbhGLRsL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:48:11 -0400
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E72DC0613DD
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:45:22 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id 75-20020a9d08510000b02904acfe6bcccaso19666090oty.12
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=f5dWuORs6KCnd0V1Z5DOk+p+49s/w8Htm+2uXk9ECuc=;
        b=q+5j/qHZjMMGvYA2NBvrIxVDwWt+AT46/ShbrWHNKFdOuxq3L0jzpZmkdg97loiATk
         5L8DoPhlG/Eloi/M7j57lKkemqfPZ1b300qAcU/vMF0/eMtjYATHWk56GJJxoVhDNU/s
         MeimQ3vooWBA5HGIUCANcpinA1PS+vE/08aBy7vG7fVVE+7YtzHXjpJXhXbNi8nP5i5p
         R5B2ZoKQULtypz7PHQ/eZ0Cjw+ArP8qkxLCtdn4buddle6EusHrtRBlNr0IwmaaNJ9rk
         NsNN1jYATcm3M2veD5v/domkVIcGrvaSbpDGiMUWM9WNg6A33Zt/C5kFL7MCXhBVC6mu
         qJ4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=f5dWuORs6KCnd0V1Z5DOk+p+49s/w8Htm+2uXk9ECuc=;
        b=o29kG9DFbywDUg8rIutHgDisxL3HsC2G0OeaKMxzifN18/ydR1KYgE43Y9edbbH7W6
         ELLiH/lvwzPSyE68/oVZxaex5n60+MJyNtg7B/3WwZiNlO+qkYONjJiNoaYfXUJE8Ciw
         GA/lFHnfrtOZ4ZDtF5Us/YnMZqzEGDfinDqYwRpC7VzCKAiBq7GmcGNX4CBYQY/JQybk
         ++UHSrP+/OTf77PoIVEa9LpTnODCMMHEYiUZmE5f84v38EA+h+rgTfgc+K0NMbT4ZHlZ
         5z3kwzu919Ab0NWdYidPL44XIXA3kFSoSmyKMtUDq6zQgH3yFYGRmO96gpVxHgxYHFiW
         ov5A==
X-Gm-Message-State: AOAM533KF/S0pFqXrqVAb5IiwMZSnQE/loGQsI1nURvMcN2Ef/9dOEPk
        3LkUo5i7Dy77d6ee75dsutoq7Qgj704y7ySXt3BNRQ==
X-Google-Smtp-Source: ABdhPJyHVCIJC5KQts3p+sus6xBqXFh72vhLVqLQJFGn9DnjIqr34KLRUCbCqE4TKBeLUcbiIbBm3JadKJWlCXjuEic=
X-Received: by 2002:a9d:550e:: with SMTP id l14mr130156oth.241.1626111921557;
 Mon, 12 Jul 2021 10:45:21 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com> <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
 <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
In-Reply-To: <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Jul 2021 10:45:10 -0700
Message-ID: <CALMp9eSWDmWerj5CaxRyMiNqnBf1akHHaWV2Cfq_66Xjg-0MEw@mail.gmail.com>
Subject: Re: [PATCH v5 06/13] KVM: x86/vmx: Save/Restore host MSR_ARCH_LBR_CTL state
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Yang Weijiang <weijiang.yang@intel.com>, pbonzini@redhat.com,
        seanjc@google.com, vkuznets@redhat.com, wei.w.wang@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "kan.liang@linux.intel.com" <kan.liang@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 12, 2021 at 10:20 AM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Jul 12, 2021 at 3:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
> >
> > On 12/7/2021 5:53 pm, Yang Weijiang wrote:
> > > On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
> > >> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wro=
te:
> > >>>
> > >>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.c=
om> wrote:
> > >>>>
> > >>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> > >>>> and reload it after vm-exit.
> > >>>
> > >>> I don't see anything being done here "before VM-entry" or "after
> > >>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> > >>>
> > >>> In any case, I don't see why this one MSR is special. It seems that=
 if
> > >>> the host is using the architectural LBR MSRs, then *all* of the hos=
t
> > >>> architectural LBR MSRs have to be saved on vcpu_load and restored o=
n
> > >>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() d=
o
> > >>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> > >>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> > >>
> > >> It does seem like there is something special about IA32_LBR_DEPTH, t=
hough...
> > >>
> > >> Section 7.3.1 of the Intel=C2=AE Architecture Instruction Set Extens=
ions
> > >> and Future Features Programming Reference
> > >> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
> > >> XRSTORS in any circumstance." It seems like that would require some
> > >> special handling if the host depth and the guest depth do not match.
> > > In our vPMU design, guest depth is alway kept the same as that of hos=
t,
> > > so this won't be a problem. But I'll double check the code again, tha=
nks!
> >
> > KVM only exposes the host's depth value to the user space
> > so the guest can only use the same depth as the host.
>
> The allowed depth supplied by KVM_GET_SUPPORTED_CPUID isn't enforced,
> though, is it?

Also, doesn't this end up being a major constraint on future
platforms? Every host that this vCPU will ever run on will have to use
the same LBR depth as the host on which it was started.
