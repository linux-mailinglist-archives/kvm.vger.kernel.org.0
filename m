Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472F62BAF12
	for <lists+kvm@lfdr.de>; Fri, 20 Nov 2020 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729865AbgKTPe4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Nov 2020 10:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728712AbgKTPez (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Nov 2020 10:34:55 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3A9C0613CF;
        Fri, 20 Nov 2020 07:34:55 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id k27so13408272ejs.10;
        Fri, 20 Nov 2020 07:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6uOgdlOhVXDU8mZtdZkmcMf4t6d0Tanr16y2zzS03oU=;
        b=P/JQOoZ9GJdsHvoOcoEjmgKIZzC5EiOKdhx4NiogsPfYx4HPJNmjbRuA9qkmrhuEy4
         vKgari3Nlo7Oqy3J22JytG/mvFV8DxbXhr9iTX81dS+tfxVL4w4Zn39NR69aeWCtvZJk
         dCC1qEU+sIAeX5PzmcT7pYvBZRuo8iccG3WbOJCuXdFDtH3E1zOx/nhHN7Cl/YJp+oxW
         dSS1Xrs9k9FhsTrK6T9RN6N6g33lIrutlb4EO/5kZ61XWLEcHU3Wx8gvvxYaI3jy6oA0
         +ar9qXeLoALPTdrgdHgA4Q9j0CNh7gfWM+prU3rv1mWRnRk62AJhTfnImnh8BcUAiobX
         KCKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6uOgdlOhVXDU8mZtdZkmcMf4t6d0Tanr16y2zzS03oU=;
        b=sQuIzGyzULzCXi+imhnAo4xm7y+Qwh9GLVaTaPKWdO6CTeodH/H9l75e2puPcac4dq
         GiHxXCr1i/1VVnImbq1VCRalxxmX6AFkRGIahKhO1O7z4qvj+b3AVkDHKs1HIHGj/JNx
         xg+Sybc0NQURk2wiMZLN2KzDoDKiRo27Iy6FCvGa8L+jwAc6X1oO38RTXADbPSOZQV+/
         XsI3MQseFj6KlQ/q1i+1MtTmq5JnINP74nINhOSGUTsJX2rOa/HPceWlJFmkiZHCGFY/
         hUL1XBauMDboO1V5gVC2NnGMEwFyoH11f38EI1zrg0TS5TTk97H5ID6A6U/YNyfBbJAB
         f6VA==
X-Gm-Message-State: AOAM531z7Nzv9IVaf6+YZ7vrkzBJ4oTmRqIIWBxiLGYzVeYeRgPAg9e1
        Z59UAuve0MYwVlMepj0v27TkTL6waOg=
X-Google-Smtp-Source: ABdhPJxHXB4MelqKTDMQcZu1qmvfW5ohwl6kGbGXpJdcwVOgcaXQ+5biEQtWEPvr2Ui5BwBW5bs0tw==
X-Received: by 2002:a17:907:3da3:: with SMTP id he35mr6753591ejc.9.1605886493516;
        Fri, 20 Nov 2020 07:34:53 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id cw15sm1260640ejb.64.2020.11.20.07.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2020 07:34:52 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Subject: Re: [PATCH] MAINTAINERS: Update email address for Sean Christopherson
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org
References: <20201119183707.291864-1-sean.kvm@gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <2d20bbfa-4ae0-6305-a502-852d6e70488a@redhat.com>
Date:   Fri, 20 Nov 2020 16:34:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201119183707.291864-1-sean.kvm@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/11/20 19:37, Sean Christopherson wrote:
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
>   .mailmap    | 1 +
>   MAINTAINERS | 2 +-
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 1e14566a3d56..a0d1685a165a 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -287,6 +287,7 @@ Santosh Shilimkar <ssantosh@kernel.org>
>   Sarangdhar Joshi <spjoshi@codeaurora.org>
>   Sascha Hauer <s.hauer@pengutronix.de>
>   S.Çağlar Onur <caglar@pardus.org.tr>
> +Sean Christopherson <seanjc@google.com> <sean.j.christopherson@intel.com>
>   Sean Nyekjaer <sean@geanix.com> <sean.nyekjaer@prevas.dk>
>   Sebastian Reichel <sre@kernel.org> <sebastian.reichel@collabora.co.uk>
>   Sebastian Reichel <sre@kernel.org> <sre@debian.org>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4a34b25ecc1f..0478d9ef72fc 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -9662,7 +9662,7 @@ F:	tools/testing/selftests/kvm/s390x/
>   
>   KERNEL VIRTUAL MACHINE FOR X86 (KVM/x86)
>   M:	Paolo Bonzini <pbonzini@redhat.com>
> -R:	Sean Christopherson <sean.j.christopherson@intel.com>
> +R:	Sean Christopherson <seanjc@google.com>
>   R:	Vitaly Kuznetsov <vkuznets@redhat.com>
>   R:	Wanpeng Li <wanpengli@tencent.com>
>   R:	Jim Mattson <jmattson@google.com>
> 

Applied, thanks.

Paolo
