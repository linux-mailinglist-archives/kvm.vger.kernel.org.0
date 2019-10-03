Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE9ACAB44
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 19:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733107AbfJCQPR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 12:15:17 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37762 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732097AbfJCQPQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 12:15:16 -0400
Received: by mail-io1-f65.google.com with SMTP id b19so6909913iob.4
        for <kvm@vger.kernel.org>; Thu, 03 Oct 2019 09:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwoJ9x/CptVFOYYUSaQdv01VllsP4QeffyoClOX85BU=;
        b=p0siVdZennr0gmzQGy0y2PNbP8WC6xILQpwIZyIfVtpaDWsfw9W7kEoyQGHNLq9CDu
         GIXgz2iDHcr0w7X8IPRMXHymzrT+HUYBNGJ7SZsk1djkloZE9MhnCQW0JWwg8fJ/etUh
         yJC91qdxoXQqkkKP83YyWe3yoT4PWixn+Ay5/H6g2KgO9//sXp+w9CpVQ/3xhFFbFahM
         xajpZeexOEPzUGZnJGXwPIXNVE9T+0SrDWMHQjV22yUmeSfjFt2AnwbDPVBmEpeh8Pxz
         bJkuEVn3Roy/Kpz83BZxo3HAtyQtdzrCAgcJ/KFy3iXCthrY3PnpIOxucRnS6jnBd++z
         b+0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwoJ9x/CptVFOYYUSaQdv01VllsP4QeffyoClOX85BU=;
        b=Potx7Jl5ihlvpsBcXSSYdtN+n3DaldYyLL36QQmG9o2bcAeBownrUXJPh93WhCEaAr
         4mkXzR8qLShJERnJEGwYnBmBw+l+p4gIjDP2tlalCqZJ290HJxScXFVB4T51s0fxt+Rk
         48UI4q1UNDqczzYw9aCDqkKIvk8FXrMhWFGi4COwa5N1RxIRamCydHz/RsNWyHU18rfb
         Bk5qgYUXAxn353SDJxqVhoL6nOLmi4tJDguRDJFplpCKYLzdppHQYBSsN92rpTHpUdCR
         K25H3Kj9E6uCQ5tpFeh2ZXbnmGzDjljy7VV3Fa6U5z5Wmacz4vqrWbvqOxbXhzyQF1am
         Ilhg==
X-Gm-Message-State: APjAAAV8X42DygXWdcgMMfX70DiDobwpnfW+ADHpbOqYi5DkrrKRt+GD
        xhPo/2bdyucwFqfAQk/FwFNWwXgFs/lLI2wf9bQ1FQ==
X-Google-Smtp-Source: APXvYqwjgn5SEWkSn6gEiWnIv/MHcjJfhZQBJrtgdT9mYKPjN0d+d3MbuQO/RW1r+BHFMhA2eXDigFgh9GV1UrGHlFo=
X-Received: by 2002:a92:4a0d:: with SMTP id m13mr10286192ilf.119.1570119314283;
 Thu, 03 Oct 2019 09:15:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190904001422.11809-1-aaronlewis@google.com> <87o900j98f.fsf@vitty.brq.redhat.com>
 <CALMp9eRbDAB0NF=WVjHJWJNPgsTfE_s+4CeGMkpJpXSGP9zOyg@mail.gmail.com>
 <87sgp5g88z.fsf@vitty.brq.redhat.com> <17bf8eb1-a63d-8081-776f-930133ea26e1@amd.com>
In-Reply-To: <17bf8eb1-a63d-8081-776f-930133ea26e1@amd.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 3 Oct 2019 09:15:03 -0700
Message-ID: <CALMp9eQVFnFB8p=10H4oDzw6TwAEFRNkyAQOpKNi8L0x_r+ivw@mail.gmail.com>
Subject: Re: [Patch] KVM: SVM: Fix svm_xsaves_supported
To:     "Moger, Babu" <Babu.Moger@amd.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        kvm list <kvm@vger.kernel.org>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 3, 2019 at 9:02 AM Moger, Babu <Babu.Moger@amd.com> wrote:
>
>
>
> On 9/9/19 3:54 AM, Vitaly Kuznetsov wrote:
> > Jim Mattson <jmattson@google.com> writes:
> >
> >> On Wed, Sep 4, 2019 at 9:51 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
> >>
> >>> Currently, VMX code only supports writing '0' to MSR_IA32_XSS:
> >>>
> >>>         case MSR_IA32_XSS:
> >>>                 if (!vmx_xsaves_supported() ||
> >>>                     (!msr_info->host_initiated &&
> >>>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
> >>>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
> >>>                         return 1;
> >>>                 /*
> >>>                  * The only supported bit as of Skylake is bit 8, but
> >>>                  * it is not supported on KVM.
> >>>                  */
> >>>                 if (data != 0)
> >>>                         return 1;
> >>>
> >>>
> >>> we will probably need the same limitation for SVM, however, I'd vote for
> >>> creating separate kvm_x86_ops->set_xss() implementations.
> >>
> >> I hope separate implementations are unnecessary. The allowed IA32_XSS
> >> bits should be derivable from guest_cpuid_has() in a
> >> vendor-independent way. Otherwise, the CPU vendors have messed up. :-)
> >>
> >> At present, we use the MSR-load area to swap guest/host values of
> >> IA32_XSS on Intel (when the host and guest values differ), but it
> >> seems to me that IA32_XSS and %xcr0 should be swapped at the same
> >> time, in kvm_load_guest_xcr0/kvm_put_guest_xcr0. This potentially adds
> >> an additional L1 WRMSR VM-exit to every emulated VM-entry or VM-exit
> >> for nVMX, but since the host currently sets IA32_XSS to 0 and we only
> >> allow the guest to set IA32_XSS to 0, we can probably worry about this
> >> later.
> >
> > Yea, I was suggesting to split implementations as a future proof but a
> > comment like "This ought to be 0 for now" would also do)
>
> Hi, Anyone actively working on this?
>
> I was trying to expose xsaves on AMD qemu guest. Found out that we need to
> get this above code working before I can expose xsaves on guest. I can
> re-post these patches if it is ok.
>
> Sorry, I dont have the complete background. From what I understood, we
> need to add the same check as Intel for MSR_IA32_XSS in get_msr and set_msr.
>
> static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
> ..
>
>  case MSR_IA32_XSS:
>                 if (!vmx_xsaves_supported() ||
>                     (!msr_info->host_initiated &&
>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>                         return 1;
>                 msr_info->data = vcpu->arch.ia32_xss;
>                 break;
> ..
> ..
> }
>
> static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
> {
> ..
> ..
>   case MSR_IA32_XSS:
>                 if (!vmx_xsaves_supported() ||
>                     (!msr_info->host_initiated &&
>                      !(guest_cpuid_has(vcpu, X86_FEATURE_XSAVE) &&
>                        guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))))
>                         return 1;
>                 /*
>                  * The only supported bit as of Skylake is bit 8, but
>                  * it is not supported on KVM.
>                  */
>                 if (data != 0)
>                         return 1;
>                 vcpu->arch.ia32_xss = data;
>                 if (vcpu->arch.ia32_xss != host_xss)
>                         add_atomic_switch_msr(vmx, MSR_IA32_XSS,
>                                 vcpu->arch.ia32_xss, host_xss, false);
>                 else
>                         clear_atomic_switch_msr(vmx, MSR_IA32_XSS);
>                 break;
> ...
> }
>
> We probably don't need last "if & else" check as we are setting it 0 now.
> Does this look accurate?

Aaron is working on it, and I think he's close to being ready to send
out the next revision.
