Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43CD69F0D4
	for <lists+kvm@lfdr.de>; Tue, 27 Aug 2019 18:54:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbfH0Qyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Aug 2019 12:54:53 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36672 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730255AbfH0Qyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Aug 2019 12:54:52 -0400
Received: by mail-io1-f65.google.com with SMTP id o9so47900407iom.3
        for <kvm@vger.kernel.org>; Tue, 27 Aug 2019 09:54:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BOHjP5tc+yZEVIg0MRWpIDqFx5JGItaQGHN16Joy+r0=;
        b=LImm1TiukFBu1ne3V7tPK2lDYmzuj4dXh0BahpqBrLhOmjWkDLnm/+5PTe3ynD9tjH
         3XO3s77urhRAkPCJvyFYH2S/cMFGJGwZxjg2ayfTkmUG2Rivg5KffODDoQFNRXU80j8t
         d5cfVGq6PNQlHoymLKxlyBXEg+XYcR3YSqC5V4orbtB0uLss5o3lShya2h7UKi8EhK20
         a6Ie04+q1CTmYyMfDZ/9+cduzuB9Jtw56n677JSg5QmeYjrvThjfFgjahv2w/php93wL
         ROP+Q6EXNx+KrJf+TpmFmxO2HF+ENHmNFMQv0LMoCbbLTeEfuQXe8TVXTWsyVx9fwNkD
         b6bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BOHjP5tc+yZEVIg0MRWpIDqFx5JGItaQGHN16Joy+r0=;
        b=gtwWe53GkLiCq9xus50w/C4yEGVEwMChlGB1cZvHxTzen7gF8YY/tIWjMyBk+j/Fiy
         Ge69b/2s7jpyksy4OnJzGSbRNesNlfodsfoVJB/mWZBSDud5EkYTkuPGZ027xEaf3IeL
         vVLU5oOZ5HXICnzTR8Tb0BVbeuhIeddtkcWl9X2oNFQaIClYgL4YbSc1DmbAaxxcJ9iw
         l9spCK8J1QiLKgXWytPDcknErR9I/NDQ6xZHUYLBF7RjIhpGrPW4jc1qaGby53OzORix
         TvLqrS4px95NUiGKXjiDkmpFrviHZzY5SjLIeXpWm7KnR8K7areMuTc/cLfXpH6VJjf0
         9HAQ==
X-Gm-Message-State: APjAAAV9WtVP85cfBveJPH6UhNn2l6gRw1mmbfbJ+RC96Le7EUo/cZFK
        EuNjRoNkBgPUZzG8FSgm87SCsS7QyYgvLn+CrzrDdw==
X-Google-Smtp-Source: APXvYqzBwOW0kq4D3Mw5u/JNKSwavZ6FcPJ53+ULO/GuH3d4BgNMAL73A0JC9I8uiX/MO/BzJqUbGTpEmT9lC18aBec=
X-Received: by 2002:a6b:6a15:: with SMTP id x21mr23262943iog.40.1566924890982;
 Tue, 27 Aug 2019 09:54:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190827160404.14098-1-vkuznets@redhat.com> <20190827160404.14098-4-vkuznets@redhat.com>
In-Reply-To: <20190827160404.14098-4-vkuznets@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Tue, 27 Aug 2019 09:54:39 -0700
Message-ID: <CALMp9eRyabQA8v5cJ1AwmtFdNFvWQz2jQ+iGTRQjow7r4FV3xA@mail.gmail.com>
Subject: Re: [PATCH 3/3] KVM: x86: announce KVM_CAP_HYPERV_ENLIGHTENED_VMCS
 support only when it is available
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Roman Kagan <rkagan@virtuozzo.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 27, 2019 at 9:04 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:
>
> It was discovered that after commit 65efa61dc0d5 ("selftests: kvm: provide
> common function to enable eVMCS") hyperv_cpuid selftest is failing on AMD.
> The reason is that the commit changed _vcpu_ioctl() to vcpu_ioctl() in the
> test and this one can't fail.
>
> Instead of fixing the test is seems to make more sense to not announce
> KVM_CAP_HYPERV_ENLIGHTENED_VMCS support if it is definitely missing
> (on svm and in case kvm_intel.nested=0).
>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index d1cd0fcff9e7..ef2e8b138300 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3106,7 +3106,6 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>         case KVM_CAP_HYPERV_EVENTFD:
>         case KVM_CAP_HYPERV_TLBFLUSH:
>         case KVM_CAP_HYPERV_SEND_IPI:
> -       case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
>         case KVM_CAP_HYPERV_CPUID:
>         case KVM_CAP_PCI_SEGMENT:
>         case KVM_CAP_DEBUGREGS:
> @@ -3183,6 +3182,8 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>                 r = kvm_x86_ops->get_nested_state ?
>                         kvm_x86_ops->get_nested_state(NULL, NULL, 0) : 0;
>                 break;
> +       case KVM_CAP_HYPERV_ENLIGHTENED_VMCS:
> +               r = kvm_x86_ops->nested_enable_evmcs != NULL;

You should probably have an explicit break here, in case someone later
adds another case below.

>         default:
>                 break;
>         }
> --
> 2.20.1
>
