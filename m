Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBCD69B412
	for <lists+kvm@lfdr.de>; Fri, 23 Aug 2019 17:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733218AbfHWP5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 23 Aug 2019 11:57:50 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33318 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732573AbfHWP5u (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 23 Aug 2019 11:57:50 -0400
Received: by mail-io1-f65.google.com with SMTP id z3so21249486iog.0
        for <kvm@vger.kernel.org>; Fri, 23 Aug 2019 08:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YzmO5vDazxZEv+eGIyMMpgD3a27rsRTFdR31V3fYocg=;
        b=pZMEdmjWwlB8d4vSg3OTMlnAxwkw/DN3K9qFY1/WsOI5Yoy/ucZcNP4+LWivcbsoil
         skHsD19bqkkKy+2Jxp3uTenO8QDfSZ+ias5xnQjqDbEOx8BJD5rz76jk5vzE8u+0if3N
         7BZDg/GvoJK8Bfkq2F5zAI+pOXq8QcD7j01fD/vIa5I48w38qczhY7EbNBZtu3nPfa2z
         fTOdSILYj/XMHF85uQ8L1dTmYbhajc6yOKRujQVCfrneE/NImaeXyQYOw2MKYfD39V2z
         m+fNBkzVkZ/vUvkCQ/xITUg14XgmM7le/7PG7QoxHxpstLlxxOy/NRFCsRozT07EWhV0
         s7uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YzmO5vDazxZEv+eGIyMMpgD3a27rsRTFdR31V3fYocg=;
        b=JtjW+8ngUXtCG1Uiy0S2K7GKVDTx4ZrfV9NZrnP20QC4LQYXggdtQkb9/w5Xc5ILLk
         NHONIV6LuJOP0a0qY7Nv4mbDFLJ6ehSEzySuW6jS5LM8ipNLYazO0WTUZ1+0jTv9gAiO
         00U0QscL5g1gbA/anzV6WtbOnHd964p+TNH+6BySpQ92h7q6P/oc9wgYskmnMKg/IKsb
         WAEeO5kckP7DlQM34wgBjN/FAoZpxWAWMtQePlk/WTBjeAOLeYev+WSrnUdMcsYHr6aG
         ts6bYGW1NV1SKEEZiOQONJDJrWHO69X+kO+TFILegrxuCP3DFagC3rgV5AeX0v0tU5t7
         G8sQ==
X-Gm-Message-State: APjAAAWE2WAmv3ovk/3EQgti2PluC19ieZOlPHdGqkhE02nM2TeiS1Ls
        POzMS+FSOMZXYIxJeMHhy4dxFvHDPRY6kVTUgsIRQg==
X-Google-Smtp-Source: APXvYqzj7H79tFPtuMQ/mbMOy03HDY6BK5hQOKuglOeKm8efgjCeDPriY49FxP8iZN0ZLwBZkYOjWViLccDKZ3R971g=
X-Received: by 2002:a02:a809:: with SMTP id f9mr5686345jaj.111.1566575869010;
 Fri, 23 Aug 2019 08:57:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190424231724.2014-1-krish.sadhukhan@oracle.com>
 <20190424231724.2014-7-krish.sadhukhan@oracle.com> <CALMp9eR8u6qPF5Gv-UEXSmB9NX=H=AGb4jh4d=mEm7jyTqBfWg@mail.gmail.com>
 <a2889868-eb62-5843-f3d2-fe066055e80c@oracle.com>
In-Reply-To: <a2889868-eb62-5843-f3d2-fe066055e80c@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 23 Aug 2019 08:57:38 -0700
Message-ID: <CALMp9eRCE22HACZZ_=3nZgpx7MbSBWPEJdMXZchp7EB3K-hkVg@mail.gmail.com>
Subject: Re: [PATCH 6/8][KVM nVMX]: Load IA32_PERF_GLOBAL_CTRL MSR on vmentry
 of nested guests
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 22, 2019 at 10:29 PM Krish Sadhukhan
<krish.sadhukhan@oracle.com> wrote:
>
>
> On 8/15/19 3:44 PM, Jim Mattson wrote:
> > On Wed, Apr 24, 2019 at 4:43 PM Krish Sadhukhan
> > <krish.sadhukhan@oracle.com> wrote:
> >> According to section "Loading Guest State" in Intel SDM vol 3C, the
> >> IA32_PERF_GLOBAL_CTRL MSR is loaded on vmentry of nested guests:
> >>
> >>      "If the =E2=80=9Cload IA32_PERF_GLOBAL_CTRL=E2=80=9D VM-entry con=
trol is 1, the
> >>       IA32_PERF_GLOBAL_CTRL MSR is loaded from the IA32_PERF_GLOBAL_CT=
RL
> >>       field."
> >>
> >> Signed-off-by: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> >> Suggested-by: Jim Mattson <jmattson@google.com>
> >> Reviewed-by: Karl Heubaum <karl.heubaum@oracle.com>
> >> ---
> >>   arch/x86/kvm/vmx/nested.c | 4 ++++
> >>   1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> >> index a7bf19eaa70b..8177374886a9 100644
> >> --- a/arch/x86/kvm/vmx/nested.c
> >> +++ b/arch/x86/kvm/vmx/nested.c
> >> @@ -2300,6 +2300,10 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu=
, struct vmcs12 *vmcs12,
> >>          vcpu->arch.cr0_guest_owned_bits &=3D ~vmcs12->cr0_guest_host_=
mask;
> >>          vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_=
bits);
> >>
> >> +       if (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PERF_GLOBAL=
_CTRL)
> >> +               vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
> >> +                            vmcs12->guest_ia32_perf_global_ctrl);
> >> +
> >>          if (vmx->nested.nested_run_pending &&
> >>              (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
> >>                  vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
> >> --
> >> 2.17.2
> >>
> > This isn't quite right. The GUEST_IA32_PERF_GLOBAL_CTRL value is just
> > going to get overwritten later by atomic_switch_perf_msrs().
> >
> > Instead of writing the vmcs12 value directly into the vmcs02, you
> > should call kvm_set_msr(), exactly as it would have been called if
> > MSR_CORE_PERF_GLOBAL_CTRL had been in the vmcs12
> > VM-entry MSR-load list. Then, atomic_switch_perf_msrs() will
> > automatically do the right thing.
>
>
> I notice that the existing code for VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL
> in load_vmcs12_host_state() doesn't use kvm_set_msr():
>
>              if (vmcs12->vm_exit_controls &
> VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL)
>                  vmcs_write64(GUEST_IA32_PERF_GLOBAL_CTRL,
>                          vmcs12->host_ia32_perf_global_ctrl);
>
> This should also be changed to use kvm_set_msr() then ?

Yes. The VMWRITE here is incorrect, but fortunately it is also unreachable.
