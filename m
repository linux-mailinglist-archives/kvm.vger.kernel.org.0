Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED71D9F9E
	for <lists+kvm@lfdr.de>; Tue, 19 May 2020 20:37:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgESShv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 May 2020 14:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgESShu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 19 May 2020 14:37:50 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DF2DC08C5C2
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 11:37:49 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id w15so360044lfe.11
        for <kvm@vger.kernel.org>; Tue, 19 May 2020 11:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ukq4U4bhaGx/BxEZICOHMgvvHCN7gRfX69OD8Ug5nJ8=;
        b=hdoOvzQyr8p/pfR0tzbZhD8bTdnTt2VJ2wiF59WLjGel9YDl0tBbxVRNmo26mqAl8H
         k3/jRCp08thphnuZ7k8Qjs1/bJstD78aUCPaIwHKLlbTCaSfOW0bU5d1I+toorKpe2VG
         jFSrSspHLMGpRYjpqeQykoRqCQt/pEwLQ9a2NvFfh3zH44bU6EvXIv+MD7+oTHrHU5uN
         +OZ3ZAR7bDB374NxNFM3tPhYEmzMj+sq9FWua3dciQZzrKgoWhYfUrlJVNfi1WjjFiH+
         6og6li06vwaldl8PbxCLo/W0VxGttcxI6MCAjO1pVo2M7YKz3BLW+RCcFpQNY5i/iYpQ
         biQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ukq4U4bhaGx/BxEZICOHMgvvHCN7gRfX69OD8Ug5nJ8=;
        b=iughiukmBEir7CJj2C+imKtsTWz+O5eZTrYzloLcdcOzW5UA1qJgJR/a6dh5MZEjjc
         ENRQb24SFFbHgFk8bao5jcD2qGLXHq45zYPx1Xf9qU2sbBRg3jslFCjwGKVGuCNy/3eg
         asO1qYtfn7V5tfhUXKu3XEazINvItk+iyiF6i+4MKUNpXH8/WgZtSSTSssdEL30wiFTB
         CS32uizNfJI2xA/CNXYPxcAc19XoJlMQ7P1YaaWeiYlNCPPkhi6SYBCk6Sh1Vzj4Cb2n
         fBYzzQ2si/2CC4+deTVSle4FjQ2qlDnHliH1q6oXz3Hr0mIkTd5X8UmjgPkrxk0FvEIM
         6Hgg==
X-Gm-Message-State: AOAM532D8mTBH7Gq0tOEsF/J/KepCVBNhZNjWXP5yJn4IaiPQg/UKKkw
        DFqzW6NqBSrt+oji1VQFY/sUvddmaSpgb3NgPryjDA==
X-Google-Smtp-Source: ABdhPJzr9vyjWv7gfSfaxwWVJ2jAs3pdmlMuqe+6/DgxR/ifbfGj5DK9NaIwRduB9SggkajLVrwGSluKTmNHk1R/usQ=
X-Received: by 2002:a19:ed17:: with SMTP id y23mr163055lfy.162.1589913467376;
 Tue, 19 May 2020 11:37:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200519180743.89974-1-pbonzini@redhat.com>
In-Reply-To: <20200519180743.89974-1-pbonzini@redhat.com>
From:   Oliver Upton <oupton@google.com>
Date:   Tue, 19 May 2020 11:37:36 -0700
Message-ID: <CAOQ_Qsi7EZ6CYOrbCgZLmBFBaBgXWEu=50RrUROg8x5pyTy-SA@mail.gmail.com>
Subject: Re: [PATCH] KVM: x86: allow KVM_STATE_NESTED_MTF_PENDING in kvm_state flags
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 19, 2020 at 11:07 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> The migration functionality was left incomplete in commit 5ef8acbdd687
> ("KVM: nVMX: Emulate MTF when performing instruction emulation", 2020-02-23),
> fix it.
>
> Fixes: 5ef8acbdd687 ("KVM: nVMX: Emulate MTF when performing instruction emulation")
> Cc: stable@vger.kernel.org
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Oliver Upton <oupton@google.com>
> ---
>  arch/x86/kvm/x86.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 4f55a44951c3..0001b2addc66 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -4626,7 +4626,7 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
>
>                 if (kvm_state.flags &
>                     ~(KVM_STATE_NESTED_RUN_PENDING | KVM_STATE_NESTED_GUEST_MODE
> -                     | KVM_STATE_NESTED_EVMCS))
> +                     | KVM_STATE_NESTED_EVMCS | KVM_STATE_NESTED_MTF_PENDING))
>                         break;
>
>                 /* nested_run_pending implies guest_mode.  */
> --
> 2.18.2
>
