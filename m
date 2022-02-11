Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5694B4B241B
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 12:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343612AbiBKLQh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 06:16:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233622AbiBKLQf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 06:16:35 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E4D7AE64
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:16:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644578193;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=UzdZoc1ECG5crN5WeDHv4EcL6o8IY8l6QLLymfvZCEA=;
        b=iJfEhwC+q3fG5P6bJ6iFMGLCWPIavX/N8kjVQiNpBDhARQPsLUSLqGl1lQlzKyiNluodnK
        SKxjPUI/0A7TOvKBGGyIySPAQABIjKtjEifNXy0fNqGInaMSlZVhRqPkOHWWrBTPGejg1n
        nkGXw+85I+i7sDKjMNiHxQ3RevE7Uv0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-79-u6gSjDVlOJeIA38CmtiFcg-1; Fri, 11 Feb 2022 06:16:32 -0500
X-MC-Unique: u6gSjDVlOJeIA38CmtiFcg-1
Received: by mail-wm1-f69.google.com with SMTP id v185-20020a1cacc2000000b0034906580813so5763184wme.1
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 03:16:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UzdZoc1ECG5crN5WeDHv4EcL6o8IY8l6QLLymfvZCEA=;
        b=704R7YBgcNtJwXO1FaPxPKu/AsAR7t+6Fqm8t/RHOd2Vpokjv+Fh6vGPD2iYPwApnz
         /me38FGy7Egk2FnokVtZgxxvzqTd0JmzicP64Jx8tjMHhJt7N1AgmZc/YF42EOB+ktKS
         fD4s+Rop0g7QTtP6AUOOES7eIjVHhpC2S9+ak8Ixj6k0FmWWPX+eqEYC0otxMpPxBGTn
         1p/IOmfvPdHwi58UaKwZT6S7q8am6mVbIZWlmehF0RIAAPRM3Tj98TU/q45hU+JzkhPS
         4PnQvH6CG/vKjPsc0w5GaTxBg8Vay7BYDD/9KFbV5XG8lHWc3duU8uTAqhjxpzqVb4ae
         ysYg==
X-Gm-Message-State: AOAM530CIrwPeTutZJzTXcwiBVe/w3gxlYS/4Waki3gY76cUygxBB9g0
        ZucoCToHN4cPAZNsTywv8YIUwhhI/LIvzCijLJjD6Hqfa52IJE/mWSvpC0uVldGmL1PC+zQv0V+
        tvVICPgHn/WtS
X-Received: by 2002:adf:d841:: with SMTP id k1mr986389wrl.29.1644578191138;
        Fri, 11 Feb 2022 03:16:31 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyP54xcz6c2X8mYBTklUkWw6ZWry2xTHUvff39cx18UUukR/DLcnbFDJ5/w2n/uoH1fKqVgdA==
X-Received: by 2002:adf:d841:: with SMTP id k1mr986377wrl.29.1644578190922;
        Fri, 11 Feb 2022 03:16:30 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id 11sm24868572wrb.30.2022.02.11.03.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 03:16:30 -0800 (PST)
Message-ID: <9c0125cd-bf69-50f6-7fe8-2b8d860bde04@redhat.com>
Date:   Fri, 11 Feb 2022 12:16:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 03/12] KVM: x86: do not deliver asynchronous page faults
 if CR0.PG=0
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        vkuznets@redhat.com, mlevitsk@redhat.com, dmatlack@google.com
References: <20220209170020.1775368-1-pbonzini@redhat.com>
 <20220209170020.1775368-4-pbonzini@redhat.com> <YgWbgfSrzAhd97LG@google.com>
 <YgWcS/0naKPdAn2E@google.com> <YgWcwQYHIFCb2pvH@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgWcwQYHIFCb2pvH@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 00:16, Sean Christopherson wrote:
> Third time's a charm...
> 
> 	if (kvm_pv_async_pf_enabled(vcpu))
> 		return false;
> 
> 	if (vcpu->arch.apf.send_user_only &&
> 	    static_call(kvm_x86_get_cpl)(vcpu) == 0)
> 		return false;
> 
> 	/* L1 CR0.PG=1 is guaranteed if the vCPU is in guest mode (L2). */
> 	if (is_guest_mode(vcpu))
> 		return !vcpu->arch.apf.delivery_as_pf_vmexit;
> 
> 	return is_paging(vcpu);
> 
> 

Went for this, but with slightly different final "if":

         if (is_guest_mode(vcpu)) {
                 /*
                  * L1 needs to opt into the special #PF vmexits that are
                  * used to deliver async page faults.
                  */
                 return vcpu->arch.apf.delivery_as_pf_vmexit;
         } else {
                 /*
                  * Play it safe in case the guest does a quick real mode
                  * foray.  The real mode IDT is unlikely to have a #PF
                  * exception setup.
                  */
                 return is_paging(vcpu);
         }

Paolo

