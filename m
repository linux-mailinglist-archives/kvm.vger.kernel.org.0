Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92CC0146340
	for <lists+kvm@lfdr.de>; Thu, 23 Jan 2020 09:19:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728760AbgAWITC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Jan 2020 03:19:02 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:42807 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728609AbgAWITB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 23 Jan 2020 03:19:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579767540;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bysCcDvz/jfiZfCpE98ZIttDvvt27rdUT5PWLkNOfig=;
        b=ZBw4nAeXivrRa7Jwj367RgvLmLVqbmLSX09//tDKoqcb4HqOvX1fCgigjdFT+NHJ1WIabq
        OKulI97B8IRljTy++pIkQENMAXI6g7hjTyyQmPL69Md/oD/2WPT1OR3kg9sT3WXhv1Ricg
        Wx8CBf31/yq0JaItSGhdg/xx8WS6PRY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-255-lYsHJTbgMlyOM0kE26j-mg-1; Thu, 23 Jan 2020 03:18:59 -0500
X-MC-Unique: lYsHJTbgMlyOM0kE26j-mg-1
Received: by mail-wr1-f71.google.com with SMTP id v17so1344604wrm.17
        for <kvm@vger.kernel.org>; Thu, 23 Jan 2020 00:18:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=bysCcDvz/jfiZfCpE98ZIttDvvt27rdUT5PWLkNOfig=;
        b=KgXzJNhkhr/rhsfPrezu9ceswdIfeq3dxJa4jrrM2VO7oQsMJNrS2B4x/xAStYPkZm
         fHsHGVVmAnr1UXocPJjff4+ADGLGjCv2fhkyMlcC7SdQdnCTcNSClDjhDxweIQJIslMb
         GIBQVoMTFcpT6TQ1krXmIlsJLdf3tJZbTG0Mnb/Dpj51Q3vjAVVHWwNGbyotB4joH2/l
         wUbia+YP+xOyWeZoHREv8qwuzPZ16cDFiNm/yB28n1bxPICWwNOmti60ikRttECtgxdu
         L8CjHR0a7KtD7ArQaPq5Wn0meB4Cs1LiMoAyswRQo5xs0QKWk6L0kaEzPR1IneAyooB0
         kuDQ==
X-Gm-Message-State: APjAAAVV+2kYtGw6+VlJ4agiZwptKcC6Fz6yZYULi1+pe2cocxDXwt0B
        zExj+pI0NZUIc24mPoa0/5/9CwavYYrwGFDK11ukwtBB/c87sutYsyG8CUN6JZTfeyQl6synQ4p
        7OBx0NmMlhT7p
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr16502172wrm.345.1579767538341;
        Thu, 23 Jan 2020 00:18:58 -0800 (PST)
X-Google-Smtp-Source: APXvYqxwNFQVhHKQZr8hBPP16Ectz0uGnw/P9B76b7XHQvlf45dLRX4kMNIvzwba00hvwIxTzZLG/g==
X-Received: by 2002:adf:e6cb:: with SMTP id y11mr16502152wrm.345.1579767538096;
        Thu, 23 Jan 2020 00:18:58 -0800 (PST)
Received: from vitty.brq.redhat.com (g-server-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id x6sm1627676wmi.44.2020.01.23.00.18.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2020 00:18:57 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     linmiaohe <linmiaohe@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org, x86@kernel.org,
        pbonzini@redhat.com, rkrcmar@redhat.com,
        sean.j.christopherson@intel.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, hpa@zytor.com
Subject: Re: [PATCH] KVM: nVMX: delete meaningless nested_vmx_run() declaration
In-Reply-To: <1579745300-13029-1-git-send-email-linmiaohe@huawei.com>
References: <1579745300-13029-1-git-send-email-linmiaohe@huawei.com>
Date:   Thu, 23 Jan 2020 09:18:55 +0100
Message-ID: <875zh2shzk.fsf@vitty.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

linmiaohe <linmiaohe@huawei.com> writes:

> From: Miaohe Lin <linmiaohe@huawei.com>
>
> The function nested_vmx_run() declaration is below its implementation. So
> this is meaningless and should be removed.
>
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
> ---
>  arch/x86/kvm/vmx/nested.c | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 95b3f4306ac2..7608924ee8c1 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -4723,8 +4723,6 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
>  	return nested_vmx_succeed(vcpu);
>  }
>  
> -static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch);
> -
>  /* Emulate the VMLAUNCH instruction */
>  static int handle_vmlaunch(struct kvm_vcpu *vcpu)
>  {

Reviewed-by: Vitaly Kuznetsov <vkuznets@redhat.com>

-- 
Vitaly

