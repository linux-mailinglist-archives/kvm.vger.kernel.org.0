Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5EE107A43
	for <lists+kvm@lfdr.de>; Fri, 22 Nov 2019 22:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbfKVVyO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Nov 2019 16:54:14 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36300 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726546AbfKVVyO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Nov 2019 16:54:14 -0500
Received: by mail-io1-f66.google.com with SMTP id s3so9816645ioe.3
        for <kvm@vger.kernel.org>; Fri, 22 Nov 2019 13:54:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ajwa07jKMPmgiUGDsgSbFRAq3o3KiP/SnzlJlGk5Whk=;
        b=PqlfzPABaiAUJnO46LffQcNIoAV4T/Mjuw86KnWwrerltBYHE703W3ohFhLFMAEPmW
         9U6p/L+ej88saOMLsIdpHNAw4jKFLhmKdi4Z+3OjTPrOJHgeMCpf62h+4c7GMiCfdc7o
         umxE3iCcAsEz6pDccDAN8NHKLJ1WWLN8n5bOtqd90grJmBKcvNr5TFv73MWkqdy48wWX
         JW5HvC7yaqG2DvDHIFN3KFra/b5seqJS/oGyRicpu9wZqn/KgC2YARQ+deHWZHSSXL3/
         KhkI3AfPJwTMTjO3JgpxAU0bpoamWtIngZ9fEajZuv/TuCy2oMIaVYYs72Nvz+Rk9EFD
         O2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ajwa07jKMPmgiUGDsgSbFRAq3o3KiP/SnzlJlGk5Whk=;
        b=DHSz1xIZbTvxdATKSNQpk0UeVS3le7qtGqLhWi6wYYiYYHFr+5udzqr/4Mu11xenvT
         qXA50TBL5iEr0uROuE5npg9tNRquuOcP3QEFFCJvnU6CYlX/7sjRI2SLqsfokhqvAUNl
         ofjGPZyggPN+IA69fx2GFJSJhqzHLQMuUmcf/AcNS+HIiFDXIuFsG9vNGfI5L62LGb5L
         4WPBjxmL3ZWj4dcxuNgx2r5gKVmBNnH/MNdzGkmxr9N/pF+zUAh5xt6akx3F7YJkykhY
         4myCReBEvBlksWzRdb5ten2vI0Y5UQRClIjhuuh/RXusftYkECzSXPr8qszmDpy7EMSl
         Dunw==
X-Gm-Message-State: APjAAAXaubf+1ZVkcG4c/Vi5Js/1oJB+MQmefQ0a6hz16Q52aKe/3DtY
        /qRhl91AJQg7iQicXqyc+4YmryHySFU8LbmcBnq7UQ==
X-Google-Smtp-Source: APXvYqzqIZiwHNC4+DS53kG98RlWpwmyJfarCLFXbFoHqR356hYwDLvQ8W886xpA99p9usJrlTQTBhju+IdOwCWvS24=
X-Received: by 2002:a6b:e701:: with SMTP id b1mr14736953ioh.119.1574459652364;
 Fri, 22 Nov 2019 13:54:12 -0800 (PST)
MIME-Version: 1.0
References: <20191121203344.156835-1-pgonda@google.com> <20191121203344.156835-3-pgonda@google.com>
 <d876b27b-9519-a0a0-55c2-62e57a783a7f@amd.com> <CALMp9eRVNDvy65AFDz=KjUT0M0rCtgCECuMS0nUZqAhy2S=MsA@mail.gmail.com>
 <CAMkAt6paein2dHHD-wZ8Eke4tUb_8GNuiH_3-RHkiBHx=jjwUg@mail.gmail.com>
 <c423d85d-b7d4-7f1c-0b5b-d3f62b35b6da@amd.com> <CALMp9eTL=j_c7HYhp2rX+1w-SKXa1zr+wAJM=GAnJjKFtuYt-Q@mail.gmail.com>
 <64a08d60-ba65-a5a6-07f7-d26cd6d0ed9e@amd.com>
In-Reply-To: <64a08d60-ba65-a5a6-07f7-d26cd6d0ed9e@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 22 Nov 2019 13:54:00 -0800
Message-ID: <CALMp9eTfJ88d6Vbk4ncPD9WQX1yv9qL_WjewoQpCG8yvi7tn2A@mail.gmail.com>
Subject: Re: [PATCH 2/2] KVM x86: Mask memory encryption guest cpuid
To:     Brijesh Singh <brijesh.singh@amd.com>
Cc:     Peter Gonda <pgonda@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 22, 2019 at 1:28 PM Brijesh Singh <brijesh.singh@amd.com> wrote=
:
>
>
>
> On 11/22/19 3:24 PM, Jim Mattson wrote:
> > On Fri, Nov 22, 2019 at 1:22 PM Brijesh Singh <brijesh.singh@amd.com> w=
rote:
> >>
> >> Ah, I missed the fact that we don't need to pass the SevES
> >> bit to the guest because guest actually does not need it.
> >> It just needs the SevBit to make decision whether its
> >> safe to call the RDMSR for SEV_STATUS. The SEV_STATUS
> >> MSR will give information which SEV feature is enabled.
> >
> > Why does it have to be safe to read the SEV_STATUS MSR? We read
> > nonexistent MSRs all the time.
> >
>
> The MSR access happens very early in the boot, IIRC calling this MSR on
> non AMD platform may result in #GP. If OS is not ready to handle the
> #GP so early then we will have problem.

Ah. So, the SEV CPUID bit simply indicates the presence of the
SEV_STATUS MSR. Nothing more, nothing less.

>
>
> >> thanks
> >>
> >> On 11/22/19 1:52 PM, Peter Gonda wrote:
> >>> I am not sure that the SevEs CPUID bit has the same problem as the Se=
v
> >>> bit. It seems the reason the Sev bit was to be passed to the guest wa=
s
> >>> to prevent the guest from reading the SEV MSR if it did not exist. If
> >>> the guest is running with SevEs it must be also running with Sev. So
> >>> the guest  can safely read the SevStatus MSR to check the SevEsEnable=
d
> >>> bit because the Sev CPUID bit will be set.
> >>>
> >>> If I look at the AMD patches for ES. I see just that,
> >>> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fg=
ithub.com%2FAMDESE%2Flinux%2Fcommit%2Fc19d84b803caf8e3130b1498868d0fcafc755=
da7&amp;data=3D02%7C01%7Cbrijesh.singh%40amd.com%7C86545e99d62e4f8e8eb508d7=
6f92720c%7C3dd8961fe4884e608e11a82d994e183d%7C0%7C0%7C637100547082927245&am=
p;sdata=3D5YsknSUmboS95T0OfLWvJ%2BcOQQk5sIllGfshNqf0j6Y%3D&amp;reserved=3D0=
,
> >>> it doesn't look for the SevEs CPUID bit.
> >>>
> >>> } else {
> >>>     /* For SEV, check the SEV MSR */
> >>>     msr =3D __rdmsr(MSR_AMD64_SEV);
> >>>     if (!(msr & MSR_AMD64_SEV_ENABLED))
> >>>       return;
> >>>     /* SEV state cannot be controlled by a command line option */
> >>>     sme_me_mask =3D me_mask;
> >>>     sme_me_status |=3D SEV_ACTIVE;
> >>>     physical_mask &=3D ~sme_me_mask;
> >>> +
> >>> +  if (!(msr & MSR_AMD64_SEV_ES_ENABLED))
> >>> +    return;
> >>> +
> >>> +  sme_me_status |=3D SEV_ES_ACTIVE;
> >>>     return;
> >>> }
> >>>
> >>> }
> >>>
> >>>
> >>> On Fri, Nov 22, 2019 at 9:18 AM Jim Mattson <jmattson@google.com> wro=
te:
> >>>>
> >>>> Does SEV-ES indicate that SEV-ES guests are supported, or that the
> >>>> current (v)CPU is running with SEV-ES enabled, or both?
> >>>>
> >>>> On Fri, Nov 22, 2019 at 5:01 AM Brijesh Singh <brijesh.singh@amd.com=
> wrote:
> >>>>>
> >>>>>
> >>>>> On 11/21/19 2:33 PM, Peter Gonda wrote:
> >>>>>> Only pass through guest relevant CPUID information: Cbit location =
and
> >>>>>> SEV bit. The kernel does not support nested SEV guests so the othe=
r data
> >>>>>> in this CPUID leaf is unneeded by the guest.
> >>>>>>
> >>>>>> Suggested-by: Jim Mattson <jmattson@google.com>
> >>>>>> Signed-off-by: Peter Gonda <pgonda@google.com>
> >>>>>> Reviewed-by: Jim Mattson <jmattson@google.com>
> >>>>>> ---
> >>>>>>    arch/x86/kvm/cpuid.c | 8 +++++++-
> >>>>>>    1 file changed, 7 insertions(+), 1 deletion(-)
> >>>>>>
> >>>>>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
> >>>>>> index 946fa9cb9dd6..6439fb1dbe76 100644
> >>>>>> --- a/arch/x86/kvm/cpuid.c
> >>>>>> +++ b/arch/x86/kvm/cpuid.c
> >>>>>> @@ -780,8 +780,14 @@ static inline int __do_cpuid_func(struct kvm_=
cpuid_entry2 *entry, u32 function,
> >>>>>>                 break;
> >>>>>>         /* Support memory encryption cpuid if host supports it */
> >>>>>>         case 0x8000001F:
> >>>>>> -             if (!boot_cpu_has(X86_FEATURE_SEV))
> >>>>>> +             if (boot_cpu_has(X86_FEATURE_SEV)) {
> >>>>>> +                     /* Expose only SEV bit and CBit location */
> >>>>>> +                     entry->eax &=3D F(SEV);
> >>>>>
> >>>>>
> >>>>> I know SEV-ES patches are not accepted yet, but can I ask to pass t=
he
> >>>>> SEV-ES bit in eax?
> >>>>>
> >>>>>
> >>>>>> +                     entry->ebx &=3D GENMASK(5, 0);
> >>>>>> +                     entry->edx =3D entry->ecx =3D 0;
> >>>>>> +             } else {
> >>>>>>                         entry->eax =3D entry->ebx =3D entry->ecx =
=3D entry->edx =3D 0;
> >>>>>> +             }
> >>>>>>                 break;
> >>>>>>         /*Add support for Centaur's CPUID instruction*/
> >>>>>>         case 0xC0000000:
