Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2A348F389
	for <lists+kvm@lfdr.de>; Sat, 15 Jan 2022 01:46:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231594AbiAOAqM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Jan 2022 19:46:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbiAOAqL (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Jan 2022 19:46:11 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F18C061574
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 16:46:10 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id a7so11735479plh.1
        for <kvm@vger.kernel.org>; Fri, 14 Jan 2022 16:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bkM1TIVQ6Ac38f4nYsJNosa7HutS0fQKr+FWU8XPdnk=;
        b=Yc/kl/Jbg9szpRv3k/IzparKqDb+3nAG79byiWJRAr6vcPID2qlK8Ll7ZhhGCQxKM8
         qpnrDHGWORdYlTddFCIZc3MwCkKJ+fDE8F+hQJxxhm6k96biUQ7dMGQW/z3MvNn5zSzy
         PmScnf2Ogg3ual4pUmmzq0EY4RbSN0/fWiSwf1cEac5e7yiSwjXuOqje1y8O9c/zgSew
         aiQXMfsTxHHUXkMmh9zVcyjNklwiC2R/OcvtXjeHssebaHJfchlO0gd2PjZCHQwS36eg
         KG15qUqzse9nkL3f8QZK/jx+X7zzcJfoyFCvcuIZh/bCI9p1Ut74ePaZy9y6y00xUXbc
         Vbwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bkM1TIVQ6Ac38f4nYsJNosa7HutS0fQKr+FWU8XPdnk=;
        b=hxDkFnmT8X5zDNEbMOz0sqroMEHyU2PF5EGqfKfuNWg5akNkQgXIBR5DXGh5gR8RK/
         l3gjkbEk23GKYD0BWuRsQl1urK4idRll5oNuO+kKtHBVGngEOASr45Xdno7WICPXl3Uq
         tdrxzw5j5DQN1rd1h5tH1lhsisPwbOFvemHiWOd5HY4dK1/XH03zFdHRFB9w+FJQhKwe
         BxVO6EtzIs+31X9oYeWQNBDzdK2JZ3D7x27bC0N5/KQFoGyt6F561romW8QK89QT76hc
         VEK2V0rErO3zFNH8uRQiSPf7RjQABDnjW3gfvOcvw+MjCSQ0LNFtLC7zK2ZXRic14Hvb
         JO5Q==
X-Gm-Message-State: AOAM530V5Cj9ZTfCygZKWo4C9hgqsfdDl9lKBw+79bk5DroqMVwyecSx
        5ARkdocYlVR4h4Jvx2KMyjx/Pg==
X-Google-Smtp-Source: ABdhPJyjoEesRbQZZc0Tgpt+hvNhPOuvvNTkD9qfCCr7Q29ROSTPcf1hYZdlomlI4VxXqYxmdiidyQ==
X-Received: by 2002:a17:902:e5c9:b0:14a:2da3:e60f with SMTP id u9-20020a170902e5c900b0014a2da3e60fmr11538953plf.100.1642207570237;
        Fri, 14 Jan 2022 16:46:10 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id t25sm5504034pgv.9.2022.01.14.16.46.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 16:46:09 -0800 (PST)
Date:   Sat, 15 Jan 2022 00:46:06 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wang Guangju <wangguangju@baidu.com>
Cc:     pbonzini@redhat.com, sean.j.christopherson@intel.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: enhance the readability of function
 pic_intack()
Message-ID: <YeIZTkYCfkTE0Lob@google.com>
References: <20220112085153.4506-1-wangguangju@baidu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220112085153.4506-1-wangguangju@baidu.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jan 12, 2022, Wang Guangju wrote:
> From: wangguangju <wangguangju@baidu.com>
> 
> In function pic_intack(), use a varibale of "mask" to
> record expression of "1 << irq", so we can enhance the
> readability of this function.

Please wrap at ~75 chars.

> Signed-off-by: wangguangju <wangguangju@baidu.com>
> ---
>  arch/x86/kvm/i8259.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8259.c b/arch/x86/kvm/i8259.c
> index 814064d06016..ad6b64b11adc 100644
> --- a/arch/x86/kvm/i8259.c
> +++ b/arch/x86/kvm/i8259.c
> @@ -216,12 +216,14 @@ void kvm_pic_clear_all(struct kvm_pic *s, int irq_source_id)
>   */
>  static inline void pic_intack(struct kvm_kpic_state *s, int irq)
>  {
> -	s->isr |= 1 << irq;
> +	int mask;

Needs a newline, and could also be:

	int mask = 1 << irq;

or even

	int mask = BIT(irq);

That said, I oddly find the existing code more readable.  Maybe "irq_mask" instead
of "mask"?  Dunno.  I guess I don't have a strong opinion :-)
