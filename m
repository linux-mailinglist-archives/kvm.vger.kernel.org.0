Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA2834C4D8C
	for <lists+kvm@lfdr.de>; Fri, 25 Feb 2022 19:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbiBYSWA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Feb 2022 13:22:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiBYSV5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 25 Feb 2022 13:21:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DF37E1FEF8D
        for <kvm@vger.kernel.org>; Fri, 25 Feb 2022 10:21:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645813281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=g1SxaQgp/6WOc0KKmfEav99FpX07fm1Map4Q3PyyPfo=;
        b=OBwiCqd4uKtHxtKEkpVlrInSWxuD6hAXyBJRYtGa+S6mxr+qkavMMn2yyFBOLzyH4KI7++
        n0HpAGNVKkm79HJyAdQ7nFkUD75h6djM346RaDAtNMN0X59kszFvb634Y8MTbLEgr3vyOb
        4N7VsjUL/BDq84u72/TnHjI7uM0fVLA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-NNPaVFfsPo-tmx-Z6-K_Tg-1; Fri, 25 Feb 2022 13:21:18 -0500
X-MC-Unique: NNPaVFfsPo-tmx-Z6-K_Tg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 502311854E21;
        Fri, 25 Feb 2022 18:21:17 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B6B892BCD0;
        Fri, 25 Feb 2022 18:21:14 +0000 (UTC)
Message-ID: <506c34bc80d1bb740ddf38e6476ad0e16c097282.camel@redhat.com>
Subject: Re: [PATCH 1/4] KVM: x86: hyper-v: Drop redundant 'ex' parameter
 from kvm_hv_send_ipi()
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-kernel@vger.kernel.org
Date:   Fri, 25 Feb 2022 20:21:13 +0200
In-Reply-To: <20220222154642.684285-2-vkuznets@redhat.com>
References: <20220222154642.684285-1-vkuznets@redhat.com>
         <20220222154642.684285-2-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-02-22 at 16:46 +0100, Vitaly Kuznetsov wrote:
> 'struct kvm_hv_hcall' has all the required information already,
> there's no need to pass 'ex' additionally.
> 
> No functional change intended.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  arch/x86/kvm/hyperv.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kvm/hyperv.c b/arch/x86/kvm/hyperv.c
> index 6e38a7d22e97..15b6a7bd2346 100644
> --- a/arch/x86/kvm/hyperv.c
> +++ b/arch/x86/kvm/hyperv.c
> @@ -1875,7 +1875,7 @@ static void kvm_send_ipi_to_many(struct kvm *kvm, u32 vector,
>  	}
>  }
>  
> -static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool ex)
> +static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc)
>  {
>  	struct kvm *kvm = vcpu->kvm;
>  	struct hv_send_ipi_ex send_ipi_ex;
> @@ -1889,7 +1889,7 @@ static u64 kvm_hv_send_ipi(struct kvm_vcpu *vcpu, struct kvm_hv_hcall *hc, bool
>  	u32 vector;
>  	bool all_cpus;
>  
> -	if (!ex) {
> +	if (hc->code == HVCALL_SEND_IPI) {

I am thinking, if we already touch this code,
why not to use switch here instead on the hc->code,
so that we can catch this function being called with something else than
HVCALL_SEND_IPI_EX

>  		if (!hc->fast) {
>  			if (unlikely(kvm_read_guest(kvm, hc->ingpa, &send_ipi,
>  						    sizeof(send_ipi))))
> @@ -2279,14 +2279,14 @@ int kvm_hv_hypercall(struct kvm_vcpu *vcpu)
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_send_ipi(vcpu, &hc, false);
> +		ret = kvm_hv_send_ipi(vcpu, &hc);
>  		break;
>  	case HVCALL_SEND_IPI_EX:
>  		if (unlikely(hc.fast || hc.rep)) {
>  			ret = HV_STATUS_INVALID_HYPERCALL_INPUT;
>  			break;
>  		}
> -		ret = kvm_hv_send_ipi(vcpu, &hc, true);
> +		ret = kvm_hv_send_ipi(vcpu, &hc);
>  		break;
>  	case HVCALL_POST_DEBUG_DATA:
>  	case HVCALL_RETRIEVE_DEBUG_DATA:



Other than this minor nitpick:

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>


Best regards,
	Maxim Levitsky

