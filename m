Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6FC23CEF2
	for <lists+kvm@lfdr.de>; Wed,  5 Aug 2020 21:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgHESef (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 5 Aug 2020 14:34:35 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:21113 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727951AbgHES2E (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 5 Aug 2020 14:28:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596652067;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9f+2zDm4d3yS1aPT9FWf6YX+aMMcQwVi71lbZAVl4mM=;
        b=Ye94rlgkpeQm0/kbdI2xEyDwqcmNrLlcP1Ak9pixRvCvFDci9PvFMKS0irlMv28ceFXUOR
        7oLTxDW0hydILnUPaPMD69icTUcdebh8ZIqgwmDtysrRwNEfAYpWPrCI8GSfzv1+LxBGIC
        TxJSepVBZ7n3NlAm+qH2xRX1liM0L3w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-202-DEDEph0kNymbWTpUshH9nA-1; Wed, 05 Aug 2020 14:27:45 -0400
X-MC-Unique: DEDEph0kNymbWTpUshH9nA-1
Received: by mail-wm1-f72.google.com with SMTP id h205so3035827wmf.0
        for <kvm@vger.kernel.org>; Wed, 05 Aug 2020 11:27:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9f+2zDm4d3yS1aPT9FWf6YX+aMMcQwVi71lbZAVl4mM=;
        b=ICGnrwipE/EbGGlGFk8RXEcO0GREda8YDBrVhfgxw7khuISQ6v9ULNbm6jblCPp+8q
         3tDboPwLZiAwmKpKWXrt9zT3AN8NfnBq4DDh8i/JVgQnkzYZAvIYrdJbol2e4Fuv5AhX
         bNW8sjTNhk/hVJ99BDsvBAWNaEiTPZ5TlvbDfSfkcF1UCkHo3BPHmcp6O4WeCrKDrlyB
         P6AzscR0UycUqUPNIkJt1f01dC4M+GWPzV0+iRp0XbFuDMzhzyjf8JFnszZjmeFCS1wg
         jpDxzRoBO8jYyXUne3SLwAP0dTBTpHzRqVKgOw4b4G2LMHodJ8/wn+jPvh0b8C1DMSW8
         In9w==
X-Gm-Message-State: AOAM530LzLpfwTIhpSdLO1qgmAWPqP0RR/1N+hKx9hpzEzgpcwhjQKzl
        2/X8t6lEhT5rtW6WyOn1hK/yIadNxifhIutUiFbU6/jPaRxDA3Kz7BCbdtFou//x0nFJ7XJrkM3
        LiIUCjC83tmcr
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr3749369wrf.309.1596652064626;
        Wed, 05 Aug 2020 11:27:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy+KGNj0NBLJYeB8xi8DpGwW88pM+R8FK55z7m1ZgGHhl3YLU9QV1yCfid7toTnvyJBWOJg6Q==
X-Received: by 2002:adf:9e8b:: with SMTP id a11mr3749340wrf.309.1596652064286;
        Wed, 05 Aug 2020 11:27:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id f124sm3610601wmf.7.2020.08.05.11.27.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2020 11:27:43 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 updates for 5.9
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Scull <ascull@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Christoffer Dall <christoffer.dall@arm.com>,
        David Brazdil <dbrazdil@google.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        James Morse <james.morse@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Peng Hao <richard.peng@oppo.com>,
        Quentin Perret <qperret@google.com>,
        Will Deacon <will@kernel.org>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel-team@android.com
References: <20200805175700.62775-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <879fd9c1-b0ce-1085-dade-64a7bf40bb4f@redhat.com>
Date:   Wed, 5 Aug 2020 20:27:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200805175700.62775-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 05/08/20 19:56, Marc Zyngier wrote:
> Hi Paolo,
> 
> This is the bulk of the 5.9 patches for KVM/arm64. It is a pretty busy
> merge window for us this time, thanks to the ongoing Protected KVM
> work. We have changes all over the map, but the most important piece
> probably is the way we now build the EL2 code on non-VHE systems. On
> top of giving us better control over what gets pulled in there, it
> allowed us to enable instrumentation on VHE systems.
> 
> The rest is a mixed bag of new features (TTL TLB invalidation, Pointer
> Auth on non-VHE), preliminary patches for NV, some early MMU rework
> before the 5.10 onslaught, and tons of cleanups.
> 
> A few things to notice:
> 
> - We share a branch with the arm64 tree, which has gone in already.
> 
> - There are a number of known conflicts with Sean's MMU cache rework,
>   as well as the late fixes that went in 5.8. The conflicts are pretty
>   simple to resolve, and -next has the right resolutions already.

Ok, since I have already an x86 conflict I'll wait to pull this until
next week.

Paolo

