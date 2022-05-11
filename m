Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B005231CA
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 13:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233498AbiEKLdp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 07:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231897AbiEKLdl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 07:33:41 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2D68441320
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 04:33:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652268820;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V5QQRo7axf4dVhDQ3Gkh9K00xyLHeOtfUYVCT5r93aA=;
        b=XGS38thp3bpkXqjYvOKbsjVUB7dbT5AbcCdB6jGPNUaETTsHrSy1F0uOSj6q9+pkR3TPOb
        TvHhrD315iWEIZdWGlbAoDtN6Msxf3Nb0uk9FlCXvFahwl6YvMcycLXcj6uFNQh1BHVs5H
        mTV/YkyckTQ0sRMYAwV5hkAIO/SEyEU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-483-UK5ONwxyMV6KAaN3-8eKJA-1; Wed, 11 May 2022 07:33:37 -0400
X-MC-Unique: UK5ONwxyMV6KAaN3-8eKJA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 899C5293248F;
        Wed, 11 May 2022 11:33:36 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 44BDA438BDF;
        Wed, 11 May 2022 11:33:34 +0000 (UTC)
Message-ID: <6c9add3244d86080ccd8c3c72a37b9ee112d45b8.camel@redhat.com>
Subject: Re: [PATCH v3 20/34] KVM: x86: KVM_REQ_TLB_FLUSH_CURRENT is a
 superset of KVM_REQ_HV_TLB_FLUSH too
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 14:33:33 +0300
In-Reply-To: <20220414132013.1588929-21-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-21-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:19 +0200, Vitaly Kuznetsov wrote:
> KVM_REQ_TLB_FLUSH_CURRENT is an even stronger operation than
> KVM_REQ_TLB_FLUSH_GUEST so KVM_REQ_HV_TLB_FLUSH needs not to be
> processed after it.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/x86.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index e5aec386d299..d3839e648ab3 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -3357,8 +3357,11 @@ static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
>   */
>  void kvm_service_local_tlb_flush_requests(struct kvm_vcpu *vcpu)
>  {
> -	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu))
> +	if (kvm_check_request(KVM_REQ_TLB_FLUSH_CURRENT, vcpu)) {
>  		kvm_vcpu_flush_tlb_current(vcpu);
> +		if (kvm_check_request(KVM_REQ_HV_TLB_FLUSH, vcpu))
> +			kvm_hv_vcpu_empty_flush_tlb(vcpu);
> +	}
>  
>  	if (kvm_check_request(KVM_REQ_TLB_FLUSH_GUEST, vcpu)) {
>  		kvm_vcpu_flush_tlb_guest(vcpu);


I think that this patch should be moved near patch 1 and/or even squished with it.

Best regards,
	Maxim Levitsky

