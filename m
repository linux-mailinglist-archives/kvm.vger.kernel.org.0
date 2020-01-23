Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49C521463F8
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 09:55:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728792AbgAWIzw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 03:55:52 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27894 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726061AbgAWIzv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 03:55:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579769750;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Zk983o09Ptf4EhRmMF4WXJnJTt4L7VbNZwtev+QYBaI=;
        b=gxEeycyaheyg8k3i8SiQs0WFXsuIU8IdLvfXaOtv7Oz2XjFd6RP+sdWJKIEviMDuCabqCq
        7azw6TbYFtcASxdz59qrtRNPIey6wReposyTwKkqe7wIUe1lbLpVpmZNeJ7doLPGbvp2Xs
        oAB9scli9aLTuDfqDszwPAdYILt4SbU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-UPnUgKjONU-FUaVUYN9MYw-1; Thu, 23 Jan 2020 03:55:48 -0500
X-MC-Unique: UPnUgKjONU-FUaVUYN9MYw-1
Received: by mail-wr1-f70.google.com with SMTP id j4so1400826wrs.13
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 00:55:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Zk983o09Ptf4EhRmMF4WXJnJTt4L7VbNZwtev+QYBaI=;
        b=iNLTeM+BVVGnsrVWzGWgsq9ArmVPO0zRSQECYsYYCCU9iG7WuyhtX6yNKX2PHWrs6S
         5ZTFHmM4dFkYPBTPpGQrqqQ3qPXLnBlhdP8xqh3FIsJk+PibzB539bxCsoCO2pPxHuZU
         7j0p1hah9UEa/aHwmNdhj0Ocd+upHNCBM+eB3p+e5Ok5xBhwq5mPXpeLX7SjQXeuNbEF
         lWfMnsJvnk5FkZiJi27WYMbISo+7eUm+JZ0lWqhqb4AdCaepBrOEO4Mt4+mlb2/5NpFw
         2sLJgspD59NEBRohvrxRbFgTGc4WWrwvxyD+iL9yt4fU1yYM7DFaNVoPoOYtz79UlcTs
         vBCg==
X-Gm-Message-State: APjAAAXw13HGPTu7XzhBZyM8wd5iHh4QBqnZcem30hG670QyceDDEref
        8TtE3snktCSWQpw6eEjBergQW/+sqW/T5d8xP8iITt5btj1bX/R9xtkYrxw6/ol9ofjerUXRSPI
        /6zbx7rwYF5Ue
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr16424026wrp.142.1579769747114;
        Thu, 23 Jan 2020 00:55:47 -0800 (PST)
X-Google-Smtp-Source: APXvYqwnuRG5Gyj3liW/33dXUeXlqykkdo4u0Q5K5x2W7UXL4cqcNjhOB7QGvEAUrNPuajc7OkoP3g==
X-Received: by 2002:adf:ef4e:: with SMTP id c14mr16423996wrp.142.1579769746853;
        Thu, 23 Jan 2020 00:55:46 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id o2sm1258790wmh.46.2020.01.23.00.55.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 00:55:46 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: nVMX: set rflags to specify success in handle_invvpid() default case
In-Reply-To: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
References: <1579749241-712-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 23 Jan 2020 09:55:44 +0100
Message-ID: <8736c6sga7.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> In handle_invvpid() default case, we just skip emulated instruction and
> forget to set rflags to specify success. This would result in indefinite
> rflags value and thus indeterminate return value for guest.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
> 	Chinese New Year is coming. Happy Spring Festival! ^_^

Happy Spring Festival!

> ---
>  arch/x86/kvm/vmx/nested.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 7608924ee8c1..985d3307ec56 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -5165,7 +5165,7 @@ static int handle_invvpid(struct kvm_vcpu *vcpu)
>  		break;
>  	default:
>  		WARN_ON_ONCE(1);
> -		return kvm_skip_emulated_instruction(vcpu);
> +		break;
>  	}
>  
>  	return nested_vmx_succeed(vcpu);

Your patch seems to do the right thing, however, I started wondering if
WARN_ON_ONCE() is the right thing to do. SDM says that "If an
unsupported INVVPID type is specified, the instruction fails." and this
is similar to INVEPT and I decided to check what handle_invept()
does. Well, it does BUG_ON(). 

Are we doing the right thing in any of these cases?

-- 
Vitaly

