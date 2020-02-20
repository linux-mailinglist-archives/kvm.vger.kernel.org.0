Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCD1E165F09
	for <lists+kvm@lfdr.de>; Thu, 20 Feb 2020 14:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728199AbgBTNoG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Feb 2020 08:44:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55477 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728079AbgBTNoG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Feb 2020 08:44:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582206245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9GnCMDDr9bENW9WQppVm9UUnxyqhxQmFQhfd/rFn4fo=;
        b=LTY9u1hH1HPAuKqAfxibwn5+nxaXOt9zdo6mnRy5wiVp1SmjhDkAB9aD6nfQpfc8WDe5Kx
        Ibg7ITcu/ZPulK794ZbYU22uHGrn94o4IuQstdQHr8L1BXhFuQOSQLntHV4nAMJhkwIYV2
        aGRYMsP2DIwd/i8yFY64ub5wi2ckIgw=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-72-r7o5qxpZMjujrMLnR9TIGg-1; Thu, 20 Feb 2020 08:44:03 -0500
X-MC-Unique: r7o5qxpZMjujrMLnR9TIGg-1
Received: by mail-wm1-f72.google.com with SMTP id g138so613843wmg.8
        for <kvm@vger.kernel.org>; Thu, 20 Feb 2020 05:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=9GnCMDDr9bENW9WQppVm9UUnxyqhxQmFQhfd/rFn4fo=;
        b=CDiEs3eVeFfQRs4Qtbydb3n5LMMEF6DtHFpob9Mihx13WSzNmfNSYRUBZgH88tn4CJ
         tbyICsttfENLNtoPT0qDaLn64S1/BTIpOw+mvejox2bsMGy0jRntLBKYLV/ftESqaGtx
         VfaqQtrNK56VSzGaJ1Br835gvL0M0a9d4FeAHvA9K2GP9+0IRMTOWdKGXKe9VfdYrBti
         mn0bwAvZdqf5SipQexD6o7dZiK4zVZ/SGSnTkV1Mt76cETVJPNnuesntC07VuhB33Dpb
         lFIp0qh18+3nhCHXPTuoxTgD1yhebGl7V20ccs92PkZyMMx/faZjiZbU+OW0p3MyH8lp
         FEoQ==
X-Gm-Message-State: APjAAAWNCT2tSOkMzTLTPsyqL4VjwyKp+JZadOUDA238r4/fQnVMtCaL
        3WlOYVpe1U4IsiPhfUBQpR80VtbYT8j0pLLkVMYSUHBm+MoJvvJY+pS8GuFmR7Vp7mDpuF4W0rr
        vyq72oRZhRBIJ
X-Received: by 2002:a05:600c:4105:: with SMTP id j5mr4820233wmi.28.1582206242468;
        Thu, 20 Feb 2020 05:44:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqyUpHy0hlSQ8YseVyGjJV91s1b+icW0ezutQz33mhkVlVtICBPEbWyT+7sWDM88+qD5srIPjg==
X-Received: by 2002:a05:600c:4105:: with SMTP id j5mr4820213wmi.28.1582206242154;
        Thu, 20 Feb 2020 05:44:02 -0800 (PST)
Received: from vitty.brq.redhat.com (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id a9sm4992690wrn.3.2020.02.20.05.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 05:44:01 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: enable -Werror
In-Reply-To: <1581535233-42127-1-git-send-email-pbonzini@redhat.com>
References: <1581535233-42127-1-git-send-email-pbonzini@redhat.com>
Date:   Thu, 20 Feb 2020 14:44:00 +0100
Message-ID: <875zg174rj.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Paolo Bonzini <pbonzini@redhat.com> writes:

> Avoid more embarrassing mistakes.  

"avoid more" != "make less" :-)

> At least those that the compiler can catch.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  arch/x86/kvm/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
> index b19ef421084d..4654e97a05cc 100644
> --- a/arch/x86/kvm/Makefile
> +++ b/arch/x86/kvm/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  ccflags-y += -Iarch/x86/kvm
> +ccflags-y += -Werror
>  
>  KVM := ../../../virt/kvm

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

