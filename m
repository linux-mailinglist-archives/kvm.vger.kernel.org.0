Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3926391422
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:54:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233694AbhEZJ4Q (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:56:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233676AbhEZJ4N (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 05:56:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622022882;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Je3rYCWKpxnMq5kbnyKTwS1wEZr0Sa6J/l5c5NVM4Zo=;
        b=Tgdq5T3GEnMuAYrQGOt14LiRocU4BJR3bCsEmGrBR3Eqo5A4nCMatNl8eSnLFCr8rcCBsy
        yuzbzMF4E1HL9Hm2q7QJFUZ9Ol3h09ql+xnDi6dj3rbGbLLmb16d6CwOr1vokMZozWvRYd
        vc0etelqBfhke/AdWn/3+V8MgZThCOQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-235-b5fk2i9dOuuox-Z-FbOlyw-1; Wed, 26 May 2021 05:54:38 -0400
X-MC-Unique: b5fk2i9dOuuox-Z-FbOlyw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 641CB501E3;
        Wed, 26 May 2021 09:54:37 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC53C19718;
        Wed, 26 May 2021 09:54:34 +0000 (UTC)
Message-ID: <7ee401dab650422712e0dda78107e5d9acf6f1d4.camel@redhat.com>
Subject: Re: [PATCH v2 1/5] KVM: SVM: Drop unneeded CONFIG_X86_LOCAL_APIC
 check for AVIC
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 12:54:33 +0300
In-Reply-To: <20210518144339.1987982-2-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> AVIC dependency on CONFIG_X86_LOCAL_APIC is dead code since
> commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").

Indeed!
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/svm/avic.c | 2 --
>  arch/x86/kvm/svm/svm.c  | 4 +---
>  2 files changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/arch/x86/kvm/svm/avic.c b/arch/x86/kvm/svm/avic.c
> index 712b4e0de481..1c1bf911e02b 100644
> --- a/arch/x86/kvm/svm/avic.c
> +++ b/arch/x86/kvm/svm/avic.c
> @@ -29,9 +29,7 @@
>  
>  /* enable / disable AVIC */
>  int avic;
> -#ifdef CONFIG_X86_LOCAL_APIC
>  module_param(avic, int, S_IRUGO);
> -#endif
>  
>  #define SVM_AVIC_DOORBELL	0xc001011b
>  
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index dfa351e605de..8c3918a11826 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -1010,9 +1010,7 @@ static __init int svm_hardware_setup(void)
>  	}
>  
>  	if (avic) {
> -		if (!npt_enabled ||
> -		    !boot_cpu_has(X86_FEATURE_AVIC) ||
> -		    !IS_ENABLED(CONFIG_X86_LOCAL_APIC)) {
> +		if (!npt_enabled || !boot_cpu_has(X86_FEATURE_AVIC)) {
>  			avic = false;
>  		} else {
>  			pr_info("AVIC enabled\n");


