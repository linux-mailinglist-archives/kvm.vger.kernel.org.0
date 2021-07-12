Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E07C83C61C0
	for <lists+kvm@lfdr.de>; Mon, 12 Jul 2021 19:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234208AbhGLRXG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 12 Jul 2021 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233668AbhGLRXF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 12 Jul 2021 13:23:05 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB4EC0613E5
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:20:16 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id w127so25330235oig.12
        for <kvm@vger.kernel.org>; Mon, 12 Jul 2021 10:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/g8dTtqEdW34OwE46m1MAAewcTdXVykzo2F4gfcfFFQ=;
        b=FgzYbYWWchiFEX7JgzLKKjpNjSXbJFtN64/66JKLT7nxtDXqKdS6dmH55joKAL+sXz
         BxIQNE9emF49HbPJ+lPO2V++Kc5y++hSFU0F+z7Lv7o2iYOub3UWC1bAA0cp3kD/dOf6
         ji4OkDM89dDb2iK2vZzHUwweAI7g6BoUt7h6FmNNTDcQIyGIeuJofzEzyKxvL1Bvwz+O
         zQP9ciarNI2bFATzZ7+oGOi7/BoKEAC78+KpGDYMm/aySIVbDs9mJwnGFnjBAUkr15mJ
         iws9TWsO9v5liXhfcImCSsWYTZjUlhEtD6LHxZg14KIwkotAg7CKC4nCFuHiGlHCWWNx
         8OEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/g8dTtqEdW34OwE46m1MAAewcTdXVykzo2F4gfcfFFQ=;
        b=sQWkyN8UV9gbZcLCndYSOC6vzQkKqc9zIOstbADeoZoMQ6/iXdtWxR92HEo9CeVmRl
         vc6HQxxcjbhJGli2rcnHD7v55WMghPK0/jR1pYi/VLIMSWrNoVEXYfrCeW6rGxX7Lcvx
         zYRzxw3oH0KZ7EEIBqhm21Vb972oHtJrSsZofVyjxU/k4vCVDFJRxa/8cjHnmGN53NvF
         wmTwc5Nw2p+MSdDjlgXuQ3DCIU6zvqVOinjbl1NkUs7DN+fdScOm1JYrA+cbMr/N89XO
         rT2eeJ5H0qqToktS3ay4EQmAsbbHmhhSPaRn9IRa+ycpuVdU2tFgpx8djt8Aw5gARBMI
         zO/A==
X-Gm-Message-State: AOAM531WW88TANzGNtO/yGvdZLRc5dHdun9H4IG8ChaZvaTHwqGZTWKq
        OlNqAlqt8V0U5OxYBaFkzF0plYnEDP0XY6rSJiu2eg==
X-Google-Smtp-Source: ABdhPJwCTwS+1GiIchwcl2et26v1BPVnXTvxhpqTj7f2o9f4uQ8NqprnWvmsykCIPGrQTpb07BkYbdGEmxSQSDOApoo=
X-Received: by 2002:aca:1e07:: with SMTP id m7mr38610835oic.28.1626110415883;
 Mon, 12 Jul 2021 10:20:15 -0700 (PDT)
MIME-Version: 1.0
References: <1625825111-6604-1-git-send-email-weijiang.yang@intel.com>
 <1625825111-6604-7-git-send-email-weijiang.yang@intel.com>
 <CALMp9eQEs9pUyy1PpwLPG0_PtF07tR2Opw+1b=w4-knOwYPvvg@mail.gmail.com>
 <CALMp9eQ+9czB0ayBFR3-nW-ynKuH0v9uHAGeV4wgkXYJMSs1=w@mail.gmail.com>
 <20210712095305.GE12162@intel.com> <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
In-Reply-To: <d73eb316-4e09-a924-5f60-e3778db91df4@gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 12 Jul 2021 10:20:04 -0700
Message-ID: <CALMp9eQmK+asv7fXeUpF2UiRKL7VmZx44HMGj67aSqm0k9nKVg@mail.gmail.com>
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

On Mon, Jul 12, 2021 at 3:19 AM Like Xu <like.xu.linux@gmail.com> wrote:
>
> On 12/7/2021 5:53 pm, Yang Weijiang wrote:
> > On Fri, Jul 09, 2021 at 04:41:30PM -0700, Jim Mattson wrote:
> >> On Fri, Jul 9, 2021 at 3:54 PM Jim Mattson <jmattson@google.com> wrote=
:
> >>>
> >>> On Fri, Jul 9, 2021 at 2:51 AM Yang Weijiang <weijiang.yang@intel.com=
> wrote:
> >>>>
> >>>> If host is using MSR_ARCH_LBR_CTL then save it before vm-entry
> >>>> and reload it after vm-exit.
> >>>
> >>> I don't see anything being done here "before VM-entry" or "after
> >>> VM-exit." This code seems to be invoked on vcpu_load and vcpu_put.
> >>>
> >>> In any case, I don't see why this one MSR is special. It seems that i=
f
> >>> the host is using the architectural LBR MSRs, then *all* of the host
> >>> architectural LBR MSRs have to be saved on vcpu_load and restored on
> >>> vcpu_put. Shouldn't  kvm_load_guest_fpu() and kvm_put_guest_fpu() do
> >>> that via the calls to kvm_save_current_fpu(vcpu->arch.user_fpu) and
> >>> restore_fpregs_from_fpstate(&vcpu->arch.user_fpu->state)?
> >>
> >> It does seem like there is something special about IA32_LBR_DEPTH, tho=
ugh...
> >>
> >> Section 7.3.1 of the Intel=C2=AE Architecture Instruction Set Extensio=
ns
> >> and Future Features Programming Reference
> >> says, "IA32_LBR_DEPTH is saved by XSAVES, but it is not written by
> >> XRSTORS in any circumstance." It seems like that would require some
> >> special handling if the host depth and the guest depth do not match.
> > In our vPMU design, guest depth is alway kept the same as that of host,
> > so this won't be a problem. But I'll double check the code again, thank=
s!
>
> KVM only exposes the host's depth value to the user space
> so the guest can only use the same depth as the host.

The allowed depth supplied by KVM_GET_SUPPORTED_CPUID isn't enforced,
though, is it?
