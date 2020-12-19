Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570012DED8F
	for <lists+kvm@lfdr.de>; Sat, 19 Dec 2020 07:49:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgLSGsX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 19 Dec 2020 01:48:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgLSGsX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 19 Dec 2020 01:48:23 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01504C0617B0;
        Fri, 18 Dec 2020 22:47:42 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id g1so4267321ilk.7;
        Fri, 18 Dec 2020 22:47:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Wk6t8sHPNiHUq86Hk7vb9MNGSh7YoiBHUFBjV6/4jKk=;
        b=c30o2HBeq05cSqOEQdOa6wiS/izSJgVnuYfYzGxwoz86xvSD31uDuvdhVrBjXPlnVL
         n+05RZCepixgDqHiq+BnCbLwCCAvV9xJN7MOgd84TPDv1QMiYXOISq/XigO8flRbCVwb
         FCoSJTfXW7/zN9w3qYB60SCt9+vJMvjYlLDZZtakJJmpAk9S9hFdokkL8XA8R+Lfn0NO
         uoWu+NkmD99NIDihiuY/Q0qyfzxs5SApBTVvGV2o2vduaNf0+YGqF9djtgR5qmlNjNm7
         Gu88cNOq5nGbQ0ZPRXMV+SFdck8fIP5clIMCMducicgU2aTChQPCsqV2Ce5YErbLM9Fd
         Vftw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Wk6t8sHPNiHUq86Hk7vb9MNGSh7YoiBHUFBjV6/4jKk=;
        b=aNmvvnCBgu4lEQLdOnaMDJPloQcAzexVTgCY+9wtZCOt9To71bOkgdK/8up1omAZ+P
         5mOlA4ersV14baLhy7Xu7l3yctmskosgpseRhcYt4sr5iGqBrxBDYnWwbPbjIe4eY5Rs
         1/KoJTQeN28XFE23vH6S4vJlzvQevt1iXynOcgkQbs1OofzN8zdC+wg5v1Wa+N6exv1g
         Ik2QqbmtkkfcXuFgHzNdbcKAMPvWvE++uIS0PH5igvZrlhNxO6+Cd213Ywjf2wxfOjH0
         8eqWnFcNue7hG5Q2SstkZJB+K1q2Ym8oDnS11C+pvSDMz3Ysy/wPWauDxRPDmvVL3e08
         3V6Q==
X-Gm-Message-State: AOAM530NYruC0//HLiGIEwa22HaFN7JmL1ziPmaDvp29dFUoYr1pkDT9
        mmZMkbyIfmGKXyp+ic2nULE=
X-Google-Smtp-Source: ABdhPJy9nmmL+U6aFQ6rVyueGA4/0VtZMPBuRCj/KYbNlG/RpBUitac8pxYBnh0xBXdGinmH2QZ3Ag==
X-Received: by 2002:a92:de50:: with SMTP id e16mr7903342ilr.144.1608360462157;
        Fri, 18 Dec 2020 22:47:42 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id p17sm8232295ils.45.2020.12.18.22.47.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 22:47:41 -0800 (PST)
Date:   Fri, 18 Dec 2020 23:47:39 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update email address for Sean Christopherson
Message-ID: <20201219064739.GA3541709@ubuntu-m3-large-x86>
References: <20201119183707.291864-1-sean.kvm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201119183707.291864-1-sean.kvm@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 19, 2020 at 10:37:07AM -0800, Sean Christopherson wrote:
> From: Sean Christopherson <seanjc@google.com>
> 
> Update my email address to one provided by my new benefactor.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Jarkko Sakkinen <jarkko@kernel.org>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
> Cc: Wanpeng Li <wanpengli@tencent.com>
> Cc: Jim Mattson <jmattson@google.com>
> Cc: Joerg Roedel <joro@8bytes.org>
> Cc: kvm@vger.kernel.org
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
> Resorted to sending this via a private dummy account as getting my corp
> email to play nice with git-sendemail has been further delayed, and I
> assume y'all are tired of getting bounces.
> 
>  .mailmap    | 1 +
>  MAINTAINERS | 2 +-
>  2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 1e14566a3d56..a0d1685a165a 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -287,6 +287,7 @@ Santosh Shilimkar <ssantosh@kernel.org>
>  Sarangdhar Joshi <spjoshi@codeaurora.org>
>  Sascha Hauer <s.hauer@pengutronix.de>
>  S.Çağlar Onur <caglar@pardus.org.tr>
> +Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
>  Sean Nyekjaer <sean@geanix.com> <sean.nyekjaer@prevas.dk>
>  Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
>  Sebastian Reichel <sre@kernel.org> <sre@debian.org>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4a34b25ecc1f..0478d9ef72fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9662,7 +9662,7 @@ F:	tools/testing/selftests/kvm/s390x/
>  
>  KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
>  M:	Paolo Bonzini <pbonzini@redhat.com>
> -R:	Sean Christopherson <sean.j.christopherson@intel.com>
> +R:	Sean Christopherson <seanjc@google.com>
>  R:	Vitaly Kuznetsov <vkuznets@redhat.com>
>  R:	Wanpeng Li <wanpengli@tencent.com>
>  R:	Jim Mattson <jmattson@google.com>
> -- 
> 2.29.2.299.gdc1121823c-goog
> 

Not sure how it happened but commit c2b1209d852f ("MAINTAINERS: Update
email address for Sean Christopherson") dropped the MAINTAINERS
hunk so it still shows your @intel.com address. I almost sent a patch
there before I realized there was a .mailmap entry while looking through
git history.

Cheers,
Nathan
