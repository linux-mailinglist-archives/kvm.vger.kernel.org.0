Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A638391424
	for <lists+kvm@lfdr.de>; Wed, 26 May 2021 11:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbhEZJ41 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 May 2021 05:56:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:58017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233550AbhEZJ40 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 26 May 2021 05:56:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622022895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w1/fuk2aokiDTAmW7L8XmGlDE/rQN3ihSYviCoSIncE=;
        b=N2bPQA2mTFP+FIl7Ax8w01Agyz9fioHQLjJ9izIC7g/wjdGaDuQH/Qw0qFlTiK7hGpUeKt
        csyIrNwuqSwqmv5BpGQP5iyo0CaqVUbs8p7ysbrMLPQ8pRpOc42GukxFi2IAziZgiuaFxP
        3ytRRA8lepLJsEbIaqs1m16x9KxdXZc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80-2nUplXY2NYeozPrjTG3kGg-1; Wed, 26 May 2021 05:54:54 -0400
X-MC-Unique: 2nUplXY2NYeozPrjTG3kGg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 17408501E5;
        Wed, 26 May 2021 09:54:53 +0000 (UTC)
Received: from starship (unknown [10.40.192.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AFE795D9D7;
        Wed, 26 May 2021 09:54:50 +0000 (UTC)
Message-ID: <c43c40b7ca350f35cec250b490b6415c002d29d2.camel@redhat.com>
Subject: Re: [PATCH v2 2/5] KVM: VMX: Drop unneeded CONFIG_X86_LOCAL_APIC
 check from cpu_has_vmx_posted_intr()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Kechen Lu <kechenl@nvidia.com>, linux-kernel@vger.kernel.org
Date:   Wed, 26 May 2021 12:54:49 +0300
In-Reply-To: <20210518144339.1987982-3-vkuznets@redhat.com>
References: <20210518144339.1987982-1-vkuznets@redhat.com>
         <20210518144339.1987982-3-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2021-05-18 at 16:43 +0200, Vitaly Kuznetsov wrote:
> CONFIG_X86_LOCAL_APIC is always on when CONFIG_KVM (on x86) since
> commit e42eef4ba388 ("KVM: add X86_LOCAL_APIC dependency").
> 
> Suggested-by: Sean Christopherson <seanjc@google.com>
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/vmx/capabilities.h | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/capabilities.h b/arch/x86/kvm/vmx/capabilities.h
> index 8dee8a5fbc17..aa0e7872fcc9 100644
> --- a/arch/x86/kvm/vmx/capabilities.h
> +++ b/arch/x86/kvm/vmx/capabilities.h
> @@ -90,8 +90,7 @@ static inline bool cpu_has_vmx_preemption_timer(void)
>  
>  static inline bool cpu_has_vmx_posted_intr(void)
>  {
> -	return IS_ENABLED(CONFIG_X86_LOCAL_APIC) &&
> -		vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
> +	return vmcs_config.pin_based_exec_ctrl & PIN_BASED_POSTED_INTR;
>  }
>  
>  static inline bool cpu_has_load_ia32_efer(void)
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Best regards,
	Maxim Levitsky

