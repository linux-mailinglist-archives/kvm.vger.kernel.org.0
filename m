Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1AC952C137
	for <lists+kvm@lfdr.de>; Wed, 18 May 2022 19:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240810AbiERRSp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 18 May 2022 13:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240799AbiERRSn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 18 May 2022 13:18:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 836EF1FD858
        for <kvm@vger.kernel.org>; Wed, 18 May 2022 10:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652894321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0BnymVMEzqHt15JHGr551ETl2svdvZxWrL7y2dAiM+Y=;
        b=N3x9UDZUCHN2c3C9jny3/MSTdp7BPhIStK61BaCy76zCknXqKOsHyG5wIXkgfSI/Lq/GGq
        hgVg0xraKsfEcWMJlcjU1e55oyRD2nA/2kKLIyUdDnBU+Lc+AA52So6ZScQqzQqhdmzauQ
        wa65aEr6ReKBbNTYJctYWcpcUCeTDDQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-624-NAZMGsfCMHmaHC6yFq_7GQ-1; Wed, 18 May 2022 13:18:36 -0400
X-MC-Unique: NAZMGsfCMHmaHC6yFq_7GQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9D56D38349AD;
        Wed, 18 May 2022 17:18:34 +0000 (UTC)
Received: from starship (unknown [10.40.192.55])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 943C52166B26;
        Wed, 18 May 2022 17:18:32 +0000 (UTC)
Message-ID: <92fb7b8962e1da874dde2789f0d9c1f3887a63dc.camel@redhat.com>
Subject: Re: [PATCH v5 16/17] KVM: x86: nSVM: always intercept x2apic msrs
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, seanjc@google.com, joro@8bytes.org,
        jon.grimm@amd.com, wei.huang2@amd.com, terry.bowman@amd.com
Date:   Wed, 18 May 2022 20:18:31 +0300
In-Reply-To: <20220518162652.100493-17-suravee.suthikulpanit@amd.com>
References: <20220518162652.100493-1-suravee.suthikulpanit@amd.com>
         <20220518162652.100493-17-suravee.suthikulpanit@amd.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 2022-05-18 at 11:26 -0500, Suravee Suthikulpanit wrote:
> From: Maxim Levitsky <mlevitsk@redhat.com>
> 
> As a preparation for x2avic, this patch ensures that x2apic msrs
> are always intercepted for the nested guest.
> 
> Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Tested-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  arch/x86/kvm/svm/nested.c | 5 +++++
>  arch/x86/kvm/svm/svm.h    | 9 +++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
> index f209c1ca540c..b61f8939c210 100644
> --- a/arch/x86/kvm/svm/nested.c
> +++ b/arch/x86/kvm/svm/nested.c
> @@ -230,6 +230,11 @@ static bool nested_svm_vmrun_msrpm(struct vcpu_svm *svm)
>  			break;
>  
>  		p      = msrpm_offsets[i];
> +
> +		/* x2apic msrs are intercepted always for the nested guest */
> +		if (is_x2apic_msrpm_offset(p))
> +			continue;
> +
>  		offset = svm->nested.ctl.msrpm_base_pa + (p * 4);
>  
>  		if (kvm_vcpu_read_guest(&svm->vcpu, offset, &value, 4))
> diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
> index 818817b11f53..309445619756 100644
> --- a/arch/x86/kvm/svm/svm.h
> +++ b/arch/x86/kvm/svm/svm.h
> @@ -517,6 +517,15 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
>  	return svm->nested.ctl.nested_ctl & SVM_NESTED_CTL_NP_ENABLE;
>  }
>  
> +static inline bool is_x2apic_msrpm_offset(u32 offset)
> +{
> +	/* 4 msrs per u8, and 4 u8 in u32 */
> +	u32 msr = offset * 16;
> +
> +	return (msr >= APIC_BASE_MSR) &&
> +	       (msr < (APIC_BASE_MSR + 0x100));
> +}
> +
>  /* svm.c */
>  #define MSR_INVALID				0xffffffffU
>  

Just one thing, this patch should be earlier in the series (or even first one),
to avoid having a commit window where the problem exists, where malicious
L1 can get access to L0's apic msrs this way.

Best regards,
	Maxim Levitsky

