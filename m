Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91A38F231D
	for <lists+kvm@lfdr.de>; Thu,  7 Nov 2019 01:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbfKGAMG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Nov 2019 19:12:06 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40901 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727228AbfKGAMG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Nov 2019 19:12:06 -0500
Received: by mail-io1-f68.google.com with SMTP id p6so269401iod.7
        for <kvm@vger.kernel.org>; Wed, 06 Nov 2019 16:12:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K1W4zXhIo48IZ3JQ0PDcJgJZlTFycrHLauqvooUkv8k=;
        b=shiNvGjJ8nncsfbrwMoKTPKYH7f50X2sbwAQ+r2/jr7SOmf27mHll4vLjPFUwCOL6J
         ymJTW6PqsZps+ld5lTPf1gPb60v9ACOqS2ZmimVc7NoNVs1VoHs2/DzdGn3dRR8oSNy0
         8Oaz7fSd7u4K2JbVvPeAvbCDJLxi8JjoNoAtj53jzAccXAFeXHXh2kdlNBJzLtNVnt3G
         vDT2oq8UCZLQu7S8fjDSL/r9k6exiKkHTYGGBF3vCMmiM3L2f6ppxE4DByR/i2PAUsTw
         DsslpJb/Lc2bYdxb9m64B4AJrf/7qJVOnhtRrZttNrnfZxt8RDT+E/AVwSieFaUz/srU
         4J1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K1W4zXhIo48IZ3JQ0PDcJgJZlTFycrHLauqvooUkv8k=;
        b=Ana9E3K+vs5methApmUKaEEzUd8zkhdjrZbogt/M6zt+iDPRdkpqaBuO1r8eWK7uU+
         g8QrRoIKQd6mCAG8i6C4VVT+Mh3hhTY5phetMGzCqzgNtolDoUxeny2mTr40gWbNdckV
         vfWi/L0tiGaTMgHF39RazUk86yudsLOWUEN6VKjgtm+u1KB+DH22CYZuAp/1u8R0LRUb
         TK62Asq8zOCCj+Ygq5Fc5vQRuQao5FgmBcP5TGZPjjnaT8qnrMsN1GgszamvL3QNxcd5
         ILv3iS9eR7xhp+LTZWGMbYKdfoVt9H/basPNMqMh7NewXaHG2U7QCskSd55tZH9I7XLP
         MOWg==
X-Gm-Message-State: APjAAAVN85dsq2GXOkL1sM6AWfOkrJuSxfE3e109XTrSh1cfbAjL33hK
        pHxpRrpjv2+zSAp+T544a1xBO8B6qScWESRY12V6wg==
X-Google-Smtp-Source: APXvYqylI2h1nULHG7q/ETYc69lcnyuAJmDUk8Xn85bQHzm8do1ayI8GU7IjRMDE5dcS1nrZIe4vmifpC5m+38fC238=
X-Received: by 2002:a5d:8146:: with SMTP id f6mr492811ioo.108.1573085524034;
 Wed, 06 Nov 2019 16:12:04 -0800 (PST)
MIME-Version: 1.0
References: <20191105191910.56505-1-aaronlewis@google.com> <20191105191910.56505-4-aaronlewis@google.com>
 <3BEC7F65-1EE2-446F-9AC2-15FB4ED342B0@oracle.com>
In-Reply-To: <3BEC7F65-1EE2-446F-9AC2-15FB4ED342B0@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 6 Nov 2019 16:11:53 -0800
Message-ID: <CALMp9eQ30WP1nxA5RsK0DzUXOzwsbEHCK8ek4sYuR04sEph5Rg@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] kvm: vmx: Rename function find_msr() to vmx_find_msr_index()
To:     Liran Alon <liran.alon@oracle.com>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 5, 2019 at 1:31 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 5 Nov 2019, at 21:19, Aaron Lewis <aaronlewis@google.com> wrote:
> >
> > Rename function find_msr() to vmx_find_msr_index() to share
> > implementations between vmx.c and nested.c in an upcoming change.
> >
> > Reviewed-by: Jim Mattson <jmattson@google.com>
> > Signed-off-by: Aaron Lewis <aaronlewis@google.com>
> > ---
> > arch/x86/kvm/vmx/vmx.c | 10 +++++-----
> > arch/x86/kvm/vmx/vmx.h |  1 +
> > 2 files changed, 6 insertions(+), 5 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> > index c0160ca9ddba..39c701730297 100644
> > --- a/arch/x86/kvm/vmx/vmx.c
> > +++ b/arch/x86/kvm/vmx/vmx.c
> > @@ -835,7 +835,7 @@ static void clear_atomic_switch_msr_special(struct vcpu_vmx *vmx,
> >       vm_exit_controls_clearbit(vmx, exit);
> > }
> >
> > -static int find_msr(struct vmx_msrs *m, unsigned int msr)
> > +int vmx_find_msr_index(struct vmx_msrs *m, u32 msr)
>
> The change from static to non-static should happen in the next patch instead of this rename patch.
> Otherwise, if the next patch is reverted, compiling vmx.c will result in a warning.

What warning are you anticipating?

> The rest of the patch looks fine.
>
> -Liran
>
> > {
> >       unsigned int i;
> >
> > @@ -869,7 +869,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
> >               }
> >               break;
> >       }
> > -     i = find_msr(&m->guest, msr);
> > +     i = vmx_find_msr_index(&m->guest, msr);
> >       if (i < 0)
> >               goto skip_guest;
> >       --m->guest.nr;
> > @@ -877,7 +877,7 @@ static void clear_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr)
> >       vmcs_write32(VM_ENTRY_MSR_LOAD_COUNT, m->guest.nr);
> >
> > skip_guest:
> > -     i = find_msr(&m->host, msr);
> > +     i = vmx_find_msr_index(&m->host, msr);
> >       if (i < 0)
> >               return;
> >
> > @@ -936,9 +936,9 @@ static void add_atomic_switch_msr(struct vcpu_vmx *vmx, unsigned msr,
> >               wrmsrl(MSR_IA32_PEBS_ENABLE, 0);
> >       }
> >
> > -     i = find_msr(&m->guest, msr);
> > +     i = vmx_find_msr_index(&m->guest, msr);
> >       if (!entry_only)
> > -             j = find_msr(&m->host, msr);
> > +             j = vmx_find_msr_index(&m->host, msr);
> >
> >       if ((i < 0 && m->guest.nr == NR_MSR_ENTRIES) ||
> >               (j < 0 &&  m->host.nr == NR_MSR_ENTRIES)) {
> > diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
> > index 0c6835bd6945..34b5fef603d8 100644
> > --- a/arch/x86/kvm/vmx/vmx.h
> > +++ b/arch/x86/kvm/vmx/vmx.h
> > @@ -334,6 +334,7 @@ void vmx_set_virtual_apic_mode(struct kvm_vcpu *vcpu);
> > struct shared_msr_entry *find_msr_entry(struct vcpu_vmx *vmx, u32 msr);
> > void pt_update_intercept_for_msr(struct vcpu_vmx *vmx);
> > void vmx_update_host_rsp(struct vcpu_vmx *vmx, unsigned long host_rsp);
> > +int vmx_find_msr_index(struct vmx_msrs *m, u32 msr);
> >
> > #define POSTED_INTR_ON  0
> > #define POSTED_INTR_SN  1
> > --
> > 2.24.0.rc1.363.gb1bccd3e3d-goog
> >
>
