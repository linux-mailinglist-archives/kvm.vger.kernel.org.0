Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BA029F01
	for <lists+kvm@lfdr.de>; Fri, 24 May 2019 21:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731918AbfEXTWy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 May 2019 15:22:54 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44339 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727344AbfEXTWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 May 2019 15:22:54 -0400
Received: by mail-wr1-f68.google.com with SMTP id w13so2688285wru.11
        for <kvm@vger.kernel.org>; Fri, 24 May 2019 12:22:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ug4Bl3el14wpTnYvRfqXJCkiW+ZQVz0A+SEzks8ca+c=;
        b=e/HH+VpYkra4+JXOqb6am+jYGOVgL5JUUzX5rFKQlOKvL5De05BefWLObbM7oB7+QZ
         vpPZxuXomJCTPFeOvS7dbFQKYUr3d5dvJaYeXFYIu4zXZGXlTPx5MViwKF6sISFTCeKE
         Gq7N0zR1igO33ad1zMt8fyJlA++CJfLFr8pFTYVvl8w2z0gqzyPsZ9B5W9FTTnBFNRnm
         INJQ6ZAv8haNObzCZiaOtmbKTJWFN+YlOnGuFk2ITkG1lgqdd6bFQx6kjf142Rr5mb0F
         My08u59yi6fgFlPc5nmNaWU8bSdUGJ558U6O4A0t2xoSf6dQhT44DPSmoCDXx4ICkd7Z
         h/QA==
X-Gm-Message-State: APjAAAW0ASVGx2NZ9as6rurVr/eyHqmuoOq6Vb9tMroUMeC7QnaFxgqY
        0MHgR6hyJcsoPsTSamieFtprb11TkHs=
X-Google-Smtp-Source: APXvYqxc9I/gqPCwUGGqH4wF3p5c19c142inhBUwCyjvflRF3Erk2N54jSOBP2OotGkbtC4HE70Ugw==
X-Received: by 2002:a5d:4b81:: with SMTP id b1mr39369544wrt.217.1558725772192;
        Fri, 24 May 2019 12:22:52 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id n5sm4642955wrj.27.2019.05.24.12.22.51
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 May 2019 12:22:51 -0700 (PDT)
Subject: Re: [PATCH 1/3] MAINTAINERS: KVM: arm/arm64: Remove myself as
 maintainer
To:     Christoffer Dall <christoffer.dall@arm.com>
Cc:     Marc Zyngier <marc.zyngier@arm.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20190524144745.227242-1-marc.zyngier@arm.com>
 <20190524144745.227242-2-marc.zyngier@arm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1adc9268-438e-6c24-7883-690960d1c060@redhat.com>
Date:   Fri, 24 May 2019 21:22:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190524144745.227242-2-marc.zyngier@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/05/19 16:47, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> I no longer have time to actively review patches and manage the tree and
> it's time to make that official.

Thanks Christopher for your work, I hope to meet you anyway at KVM Forum!

Paolo

> Huge thanks to the incredible Linux community and all the contributors
> who have put up with me over the past years.
> 
> I also take this opportunity to remove the website link to the Columbia
> web page, as that information is no longer up to date and I don't know
> who manages that anymore.
> 
> Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  MAINTAINERS | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5cfbea4ce575..4ba271a8e0ef 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -8611,14 +8611,12 @@ F:	arch/x86/include/asm/svm.h
>  F:	arch/x86/kvm/svm.c
>  
>  KERNEL VIRTUAL MACHINE FOR ARM/ARM64 (KVM/arm, KVM/arm64)
> -M:	Christoffer Dall <christoffer.dall@arm.com>
>  M:	Marc Zyngier <marc.zyngier@arm.com>
>  R:	James Morse <james.morse@arm.com>
>  R:	Julien Thierry <julien.thierry@arm.com>
>  R:	Suzuki K Pouloze <suzuki.poulose@arm.com>
>  L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>  L:	kvmarm@lists.cs.columbia.edu
> -W:	http://systems.cs.columbia.edu/projects/kvm-arm
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git
>  S:	Maintained
>  F:	arch/arm/include/uapi/asm/kvm*
> 

