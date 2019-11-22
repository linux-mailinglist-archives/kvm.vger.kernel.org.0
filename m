Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB2DC1078BC
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 20:54:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbfKVTw4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 14:52:56 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:45693 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727555AbfKVTwy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 14:52:54 -0500
Received: by mail-io1-f68.google.com with SMTP id v17so9344110iol.12
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 11:52:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9YR3TdCRnULySeY1ifV5J5Y0S/GAMiJz+y2t57j2q2M=;
        b=tKu4RlXP8/mkTuRGysYaQgHAWElZaPURVUix7oCpmswuhh2GO6/9BJ2b5+CgW4MXWd
         0BQ0tt3k+PG3KeS53AEoVLC+KnlyIM/+hri/igF2Zm96Wqv4bQ14rXHgdfF1lNS7BIy2
         RUVa39qLqimBmekJeyEltiaqmep35acyMlag/W0m9SUorQa/sZgHrayKSiZLH7cnnncK
         RrMP2c8ZSZnO5LdqTE89MhLGGRIekZSadeX0Btv8mP+LbWlbot2Cbj1Pehl/30o3CBUX
         SQnLM4rLbgxjA2DVR9oG6hcJPxKMDHSTEVDtSdvdQ19abCjDJKt8F8uvchWdGCwshqUK
         mNGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9YR3TdCRnULySeY1ifV5J5Y0S/GAMiJz+y2t57j2q2M=;
        b=IM1EEK5WuIlj/axKr+XzxE9uY0oe8DVn6e62EjrF5j4rV6A+bagLg2kA74TR2UMcGS
         WIrzGhcVsdrNuxqLS7w4MPmem2V8NMtiduM9elgwSOFhAYZMCe8Khm256KKk+BP0+m2k
         oGzbhlR8I1oCDjLO4xmqMlDCgUGRu7kFxfGh4p30OX/Nl0M4w/UuX/hV6Tq5FQGs8Epy
         YbSQQoKlZFOiAbKmT6BspUPMrvGeDIrpXaPEBs/pAxR5cJMGfywejiu04Mz29Fse8Isq
         AdGPmY1ThfAEXYdgZvzHVq/rCYrUTclZspKMrL6E7ijkunUMOTLk472msdgT0MqXkggV
         erLw==
X-Gm-Message-State: APjAAAXNX7haQ4XPyUbyMToj+4NKkdEHzsIh3XgcB/+NbNGMIo7tBcwM
        +rPJx0GamwHvbQtv7Q6i52KTpMbk+3IpxbYcPciFZQ==
X-Google-Smtp-Source: APXvYqwfY1aspQ/GZmGnSDh3eoyXdFTdb/sVKFYE7JuHBjVYasE3sS5ku0UsD5DIsnKRVH/ySwQR+OEhslnWwA0xwDY=
X-Received: by 2002:a5d:8985:: with SMTP id m5mr8972775iol.193.1574452373508;
 Fri, 22 Nov 2019 11:52:53 -0800 (PST)
MIME-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com> <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com> <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
In-Reply-To: <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
From:   Peter Gonda <pgonda@google.com>
Date:   Fri, 22 Nov 2019 11:52:42 -0800
Message-ID: <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Jim Mattson <jmattson@google.com>
Cc:     Brijesh Singh <brijesh.singh@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am not sure that the SevEs CPUID bit has the same problem as the Sev
bit. It seems the reason the Sev bit was to be passed to the guest was
to prevent the guest from reading the SEV MSR if it did not exist. If
the guest is running with SevEs it must be also running with Sev. So
the guest  can safely read the SevStatus MSR to check the SevEsEnabled
bit because the Sev CPUID bit will be set.

If I look at the AMD patches for ES. I see just that,
https://github.com/AMDESE/linux/commit/c19d84b803caf8e3130b1498868d0fcafc755da7,
it doesn't look for the SevEs CPUID bit.

} else {
  /* For SEV, check the SEV MSR */
  msr = __rdmsr(MSR_AMD64_SEV);
  if (!(msr & MSR_AMD64_SEV_ENABLED))
    return;
  /* SEV state cannot be controlled by a command line option */
  sme_me_mask = me_mask;
  sme_me_status |= SEV_ACTIVE;
  physical_mask &= ~sme_me_mask;
+
+  if (!(msr & MSR_AMD64_SEV_ES_ENABLED))
+    return;
+
+  sme_me_status |= SEV_ES_ACTIVE;
  return;
}

}


On Fri, Nov 22, 2019 at 9:18 AM Jim Mattson <jmattson@google.com> wrote:
>
> Does SEV-ES indicate that SEV-ES guests are supported, or that the
> current (v)CPU is running with SEV-ES enabled, or both?
>
> On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com> wrote:
> >
> >
> > On 11/21/19 2:33 PM, Peter Gonda wrote:
> > > Only pass through guest relevant CPUID information: Cbit location and
> > > SEV bit. The kernel does not support nested SEV guests so the other data
> > > in this CPUID leaf is unneeded by the guest.
> > >
> > > Suggested-by: Jim Mattson <jmattson@google.com>
> > > Signed-off-by: Peter Gonda <pgonda@google.com>
> > > Reviewed-by: Jim Mattson <jmattson@google.com>
> > > ---
> > >  arch/x86/kvm/cpuid.c | 8 +++++++-
> > >  1 file changed, 7 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> > > index 946fa9cb9dd6..6439fb1dbe76 100644
> > > --- a/arch/x86/kvm/cpuid.c
> > > +++ b/arch/x86/kvm/cpuid.c
> > > @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_cpuid_entry2 *entry, u32 function,
> > >               break;
> > >       /* Support memory encryption cpuid if host supports it */
> > >       case 0x8000001F:
> > > -             if (!boot_cpu_has(X86_FEATURE_SEV))
> > > +             if (boot_cpu_has(X86_FEATURE_SEV)) {
> > > +                     /* Expose only SEV bit and CBit location */
> > > +                     entry->eax &= F(SEV);
> >
> >
> > I know SEV-ES patches are not accepted yet, but can I ask to pass the
> > SEV-ES bit in eax?
> >
> >
> > > +                     entry->ebx &= GENMASK(5, 0);
> > > +                     entry->edx = entry->ecx = 0;
> > > +             } else {
> > >                       entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
> > > +             }
> > >               break;
> > >       /*Add support for Centaur's CPUID instruction*/
> > >       case 0xC0000000:
