Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F645232C9
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238636AbiEKMRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237500AbiEKMRb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:17:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BCE8648302
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271449;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bcZFRYTKLactxBX9oYfEagpDJc8Hncop/DdMPPKBCuQ=;
        b=GEy2iTdX1OhFJX7ocyrs9s2hPG6vDXZd0jA8VuB0CxAI0LxIi9xNs1+46adY7QcIXNa7jh
        mWC4VkDw1EUXNfre5K2i0hu03bZhZDnmVtSIhfCaES1eQGR8FZbcdIVgf3DVbeGHTy5gzb
        QJNjEbfxZN4qDPhej7ANgIANPKC2hpw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-Z2XXL7WZPASg_zPsh1D3EQ-1; Wed, 11 May 2022 08:17:26 -0400
X-MC-Unique: Z2XXL7WZPASg_zPsh1D3EQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4D338101161C;
        Wed, 11 May 2022 12:17:26 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0C37A14C26A3;
        Wed, 11 May 2022 12:17:23 +0000 (UTC)
Message-ID: <75de69e533590b5c5b10f15050081662c3f054f4.camel@redhat.com>
Subject: Re: [PATCH v3 27/34] KVM: selftests: Sync 'struct
 hv_enlightened_vmcs' definition with hyperv-tlfs.h
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:17:23 +0300
In-Reply-To: <20220414132013.1588929-28-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-28-vkuznets@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> 'struct hv_enlightened_vmcs' definition in selftests is not '__packed'
> and so we rely on the compiler doing the right padding. This is not
> obvious so it seems beneficial to use the same definition as in kernel.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  tools/testing/selftests/kvm/include/x86_64/evmcs.h | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> index cc5d14a45702..b6067b555110 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> @@ -41,6 +41,8 @@ struct hv_enlightened_vmcs {
>  	u16 host_gs_selector;
>  	u16 host_tr_selector;
>  
> +	u16 padding16_1;
> +
>  	u64 host_ia32_pat;
>  	u64 host_ia32_efer;
>  
> @@ -159,7 +161,7 @@ struct hv_enlightened_vmcs {
>  	u64 ept_pointer;
>  
>  	u16 virtual_processor_id;
> -	u16 padding16[3];
> +	u16 padding16_2[3];
>  
>  	u64 padding64_2[5];
>  	u64 guest_physical_address;
> @@ -195,15 +197,15 @@ struct hv_enlightened_vmcs {
>  	u64 guest_rip;
>  
>  	u32 hv_clean_fields;
> -	u32 hv_padding_32;
> +	u32 padding32_1;
>  	u32 hv_synthetic_controls;
>  	struct {
>  		u32 nested_flush_hypercall:1;
>  		u32 msr_bitmap:1;
>  		u32 reserved:30;
> -	} hv_enlightenments_control;
> +	}  __packed hv_enlightenments_control;
>  	u32 hv_vp_id;
> -
> +	u32 padding32_2;
>  	u64 hv_vm_id;
>  	u64 partition_assist_page;
>  	u64 padding64_4[4];
> @@ -211,7 +213,7 @@ struct hv_enlightened_vmcs {
>  	u64 padding64_5[7];
>  	u64 xss_exit_bitmap;
>  	u64 padding64_6[7];
> -};
> +} __packed;
>  
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                     0
>  #define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP                BIT(0)

Makes sense.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

