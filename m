Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 562204AC661
	for <lists+kvm@lfdr.de>; Mon,  7 Feb 2022 17:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386798AbiBGQpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Feb 2022 11:45:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241542AbiBGQmv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Feb 2022 11:42:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9E67BC0401D1
        for <kvm@vger.kernel.org>; Mon,  7 Feb 2022 08:42:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644252169;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U6bdEsmc3Bn+BGw6PqjFX1lB6VH5X8LSh2tIq7pNIv8=;
        b=BS1Kj6dZkQ+CbytXshkP1Sv+ipjEX6LGrj0+HZJV9LJo4cBH6jN5A6Ke4y4bpMir9PBI6i
        8SFsq26GFR5CciLuk6ixnaGotN8TD3BlCSyV4cDik04GM4Ao8nHAkoqWRBlRNgxyhTINB2
        gjNDEKf5OYleFPmM9Lo+eqo3vMLmcp4=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-14-UqOJ3pBYOT6g2LAYRLKCsw-1; Mon, 07 Feb 2022 11:42:48 -0500
X-MC-Unique: UqOJ3pBYOT6g2LAYRLKCsw-1
Received: by mail-ed1-f72.google.com with SMTP id o6-20020a50c906000000b0040f6ac3dbb5so1901364edh.17
        for <kvm@vger.kernel.org>; Mon, 07 Feb 2022 08:42:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=U6bdEsmc3Bn+BGw6PqjFX1lB6VH5X8LSh2tIq7pNIv8=;
        b=B8od/CeMSavVsCAuAfX71Fed8UKa+aUbCQad/UVJL1a+xo78f29wmQMBU3PPG4Zxhj
         oppPepPamaJYUVxfFp2suZV+h7D0sbv3MU3KEVFECAI/oL0TTm5cE2oA0XiqJPb4IGsx
         qbqmrnSLTXYRzpF/rlriJVRYE9AvubF2aV0D/hCYtDizm9VNJB5Qx4nEODCvb0LshUg3
         lckV7yoEx9JqduWW63Ws34huPclJLe7KAWoYHSf6epzv15qqcPvuvqwfAkcGUM2NPyoc
         ShHawrBVEVWOfBSjR2k1WHH0PxiyM7YNQESbrjmWi6iGH/w4Xn5oQDYN9uxrRr+Clyd+
         6aKw==
X-Gm-Message-State: AOAM5329JpbhtuZCBj+4m5Pr89+dotGBwRcvjx0fn8Pzfl1yVFqFPMX5
        WCiODkHXPLinPRns+i3BTEDiRsv+qFzY0rqgoRCSppRFhvPiExhUIbq+3d9QINUA2a8lQKrDVp7
        At4APBP/RnS50
X-Received: by 2002:aa7:da50:: with SMTP id w16mr250699eds.59.1644252167389;
        Mon, 07 Feb 2022 08:42:47 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxRZXgp9kMEzWISPZ3qEzeCoj7XWzWobXDvF8ycPazO3v7jVRnopWoKYmsYl6WB/Tk2J3ManQ==
X-Received: by 2002:aa7:da50:: with SMTP id w16mr250677eds.59.1644252167244;
        Mon, 07 Feb 2022 08:42:47 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id x13sm2848344eds.7.2022.02.07.08.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 08:42:46 -0800 (PST)
Message-ID: <07bf09c7-2f66-cb0c-8439-46da0a05f84c@redhat.com>
Date:   Mon, 7 Feb 2022 17:42:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 7/7] KVM: VMX: Use local pointer to vcpu_vmx in
 vmx_vcpu_after_set_cpuid()
Content-Language: en-US
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <20220204204705.3538240-1-oupton@google.com>
 <20220204204705.3538240-8-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220204204705.3538240-8-oupton@google.com>
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

On 2/4/22 21:47, Oliver Upton wrote:
> There is a local that contains a pointer to vcpu_vmx already. Just use
> that instead to get at the structure directly instead of doing pointer
> arithmetic.
> 
> No functional change intended.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>   arch/x86/kvm/vmx/vmx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
> index 60b1b76782e1..11b6332769c5 100644
> --- a/arch/x86/kvm/vmx/vmx.c
> +++ b/arch/x86/kvm/vmx/vmx.c
> @@ -7338,11 +7338,11 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
>   						vmx_secondary_exec_control(vmx));
>   
>   	if (nested_vmx_allowed(vcpu))
> -		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits |=
> +		vmx->msr_ia32_feature_control_valid_bits |=
>   			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>   			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
>   	else
> -		to_vmx(vcpu)->msr_ia32_feature_control_valid_bits &=
> +		vmx->msr_ia32_feature_control_valid_bits &=
>   			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
>   			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
>   

Queued, thanks.

Paolo

