Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7A55232D8
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 14:18:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242003AbiEKMSc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 08:18:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242419AbiEKMSR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 08:18:17 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 906D760DBE
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 05:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652271488;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LtYY4R/LNfNudsYTtU8NsySwT/0G0nazzicIYxX/mQ8=;
        b=jJNJ9d17Eyn3FizVM/VAHx8yFfGubFfkJfNIBjRULCayEV0MUAC5isFyT1BAp8NlhFR3+A
        8FBf1MQAxo0z06x9z9ULz7OYANvRA45MBI10LZL+l9+BHjtqnDVD4XZTSLKRiQaPrEqUbh
        5MNvJ6O18rOzKHIt10FkeUaXl9wTpiw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-611-gEMEARiNM4SrYMYcoMIM7Q-1; Wed, 11 May 2022 08:18:07 -0400
X-MC-Unique: gEMEARiNM4SrYMYcoMIM7Q-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DDB41811E84;
        Wed, 11 May 2022 12:18:06 +0000 (UTC)
Received: from starship (unknown [10.40.192.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 99BA1438EDC;
        Wed, 11 May 2022 12:18:04 +0000 (UTC)
Message-ID: <8f230a18484723194405a53165fbda1035708c72.camel@redhat.com>
Subject: Re: [PATCH v3 30/34] KVM: selftests: Sync 'struct
 hv_vp_assist_page' definition with hyperv-tlfs.h
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 11 May 2022 15:18:03 +0300
In-Reply-To: <20220414132013.1588929-31-vkuznets@redhat.com>
References: <20220414132013.1588929-1-vkuznets@redhat.com>
         <20220414132013.1588929-31-vkuznets@redhat.com>
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

On Thu, 2022-04-14 at 15:20 +0200, Vitaly Kuznetsov wrote:
> 'struct hv_vp_assist_page' definition doesn't match TLFS. Also, define
> 'struct hv_nested_enlightenments_control' and use it instead of opaque
> '__u64'.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  .../selftests/kvm/include/x86_64/evmcs.h      | 22 ++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/kvm/include/x86_64/evmcs.h b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> index b6067b555110..9c965ba73dec 100644
> --- a/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> +++ b/tools/testing/selftests/kvm/include/x86_64/evmcs.h
> @@ -20,14 +20,26 @@
>  
>  extern bool enable_evmcs;
>  
> +struct hv_nested_enlightenments_control {
> +	struct {
> +		__u32 directhypercall:1;
> +		__u32 reserved:31;
> +	} features;
> +	struct {
> +		__u32 reserved;
> +	} hypercallControls;
> +} __packed;
> +
> +/* Define virtual processor assist page structure. */
>  struct hv_vp_assist_page {
>  	__u32 apic_assist;
> -	__u32 reserved;
> -	__u64 vtl_control[2];
> -	__u64 nested_enlightenments_control[2];
> -	__u32 enlighten_vmentry;
> +	__u32 reserved1;
> +	__u64 vtl_control[3];
> +	struct hv_nested_enlightenments_control nested_control;
> +	__u8 enlighten_vmentry;
> +	__u8 reserved2[7];
>  	__u64 current_nested_vmcs;
> -};
> +} __packed;
>  
>  struct hv_enlightened_vmcs {
>  	u32 revision_id;

Seems to match the spec.

Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>

Best regards,
	Maxim Levitsky

