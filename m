Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E903A24C6EE
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 23:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgHTVBK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 17:01:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728398AbgHTVBI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 17:01:08 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9022C061386
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:01:07 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z22so3132580oid.1
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 14:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b+3Ln31i8a6+ZKWFc7O5Q805fFIpbqFGnXfp+JT2jZE=;
        b=RnXKPDEsmDEN0w2peAI9EVJvs5JicwgJffVB9D6emIEnf/GxYS0JafKwbnr/a8rkNK
         Xhb1nVn7Wu1ID8MmHaZZoRlPORlWzyIiBkFUS9TxUtVoZ/o1ejNfC0476MwKOfTQ0Qvt
         NY/WaA+n6TXdpwi/+6Z28qqa6l4eaDqOwI0cgKsW/KVExRCBt7NCYBdZzkF31hf3qDhr
         zc3M1jaXh/oOwAO4nu5M+QTJorLN621yUm8d8sLvCAkf0pEyPaCPhFnrjorGbps29npy
         jUugX7QA2QA3SQL1TUKAMlk46Jbsta2ee5mW8BkaTwEkMzuw9+tavYqsW2wLjNdqWpdr
         5WIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b+3Ln31i8a6+ZKWFc7O5Q805fFIpbqFGnXfp+JT2jZE=;
        b=TFFUu5jfOCldF5AjXBXh8hayZpPNM/JcLseykbMngE6glHsfHr+Uq1w0r5++N3/nly
         IxDXvKXkxuGr2hi5OBN2OUrHKwR/uF0ZY5bkb54WXGzQ1QBv1peKS/3HIVlT3fogmGqP
         KvzNeRgWaEWJWNjIVXDOZgUSvnB1Zt/a/blw4kRYs/5C67YRRjc4g5WbmVCt9XlTDoIf
         L10JP5WEDIOnvXDcZW4czhHrdrpoZhUjus4ljkZzmiemuocot+7306dkAlkV34OLypoi
         Q7NeuJTpATtdV8UQHWgbYczLjV5mnnsFxUi7Q613Ni/hYrMJwpjrAlzDfn4mYICYjvXg
         O5TA==
X-Gm-Message-State: AOAM53155Dh5aXBB5100lK2iBGj1Z9mSb7X0zizyAPjiBz9Jth96AWLo
        pNW2fY0YlwJZRMipanPWm7pPBfD/klcUr7JHfshbcw==
X-Google-Smtp-Source: ABdhPJzXe+KtJ7t8KrxIrZ9FUoQpuTEo5DCEz/sbYRPxsLdQJEIX2u1oeMuogZzFNt5m05MuMJt6l9wY8b7zWQu+EQI=
X-Received: by 2002:aca:b942:: with SMTP id j63mr180088oif.28.1597957266525;
 Thu, 20 Aug 2020 14:01:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200820133339.372823-1-mlevitsk@redhat.com> <20200820133339.372823-3-mlevitsk@redhat.com>
In-Reply-To: <20200820133339.372823-3-mlevitsk@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 20 Aug 2020 14:00:55 -0700
Message-ID: <CALMp9eQycCn-wTUfFkqH3M7vzsRsYphO=GU8EwHt3tomnp=mng@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] KVM: nSVM: rename nested 'vmcb' to vmcb12_gpa in
 few places
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Wanpeng Li <wanpengli@tencent.com>,
        Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 20, 2020 at 6:33 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
>
> No functional changes.
>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 10 +++++-----
>  arch/x86/kvm/svm/svm.c    | 13 +++++++------
>  arch/x86/kvm/svm/svm.h    |  2 +-
>  3 files changed, 13 insertions(+), 12 deletions(-)
>
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index fb68467e6049..f5b17920a2ca 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -431,7 +431,7 @@ int enter_svm_guest_mode(struct vcpu_svm *svm, u64 vmcb_gpa,
For consistency, should the vmcb_gpa argument be renamed to vmcb12_gpa as well?


> @@ -579,7 +579,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
>
>         /* Exit Guest-Mode */
>         leave_guest_mode(&svm->vcpu);
> -       svm->nested.vmcb = 0;
> +       svm->nested.vmcb12_gpa = 0;
Perhaps in a follow-up change, this could be set to an illegal value
rather than 0?


> @@ -1018,7 +1018,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
>
>         /* First fill in the header and copy it out.  */
>         if (is_guest_mode(vcpu)) {
> -               kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb;
> +               kvm_state.hdr.svm.vmcb_pa = svm->nested.vmcb12_gpa;
It's unfortunate that we have "_pa" on the LHS on "_gpa" on the RHS. Oh, well.


> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 562a79e3e63a..d33013b9b4d7 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1102,7 +1102,7 @@ static void init_vmcb(struct vcpu_svm *svm)
>         }
>         svm->asid_generation = 0;
>
> -       svm->nested.vmcb = 0;
> +       svm->nested.vmcb12_gpa = 0;
Here, too, perhaps this could be changed from 0 to an illegal value in
a follow-up change.

Reviewed-by: Jim Mattson <jmattson@google.com>
