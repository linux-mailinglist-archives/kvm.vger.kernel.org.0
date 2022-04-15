Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E804502C6A
	for <lists+kvm@lfdr.de>; Fri, 15 Apr 2022 17:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354897AbiDOPPh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Apr 2022 11:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233750AbiDOPPf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Apr 2022 11:15:35 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D4E7D110F;
        Fri, 15 Apr 2022 08:13:07 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id m15-20020a7bca4f000000b0038fdc1394b1so4403247wml.2;
        Fri, 15 Apr 2022 08:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wzKRJmonvHo0HefAKYqm3SlJuD5FpHDtBNiS1uoGF98=;
        b=f4PqHt/qqb8cXY75v9eN9mmAf3VeS1rvzxN5xNELUqhhU67folOPqCzA7UuzVnyARJ
         MF20XshoL9gIhm0HbHjSl1Ecfhex8eiVukrqa7CJMY4K9JgxURYQheFyM80c5zq5AP2P
         pOjm8tiffxccI/wrYzCXu0nl/u9RrpY1WMUpeVgcub5eUsZVQLn3u9q9GCnmM7I6rECa
         erCpg0Ak74kM1L6m/PWHuvtKBWS/6pagkWtCQIgTV0CI0EERUBqgHUmXCtJ0+DbqSZxR
         kEgB4mRHIk0Gw4GcrudD5Nb4Di1qm7RhQUeljTopEzg+q8TAS0jcMk4cVIhg+k5NO+Ut
         R5XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wzKRJmonvHo0HefAKYqm3SlJuD5FpHDtBNiS1uoGF98=;
        b=p1zsnch5vRdgnz9nppr+a0eNcgQYgLewsdTCFoMDv9BfSep6FVEzWLOmoVFUpX2v7R
         CdGZJFu7YX9HmlzL1V7uH6vewabfC6PAs45L7WFGnV7EP1+r5QfdfUDhSPiJUe4gcO4j
         1kP0IBnxF2/D6VKmbW8mIg/Yl/HzdkALPhFgz/bfYJGVQwUQJQuvvWCjHIff5rUnGdVN
         Gnd4yU6tsleBu3GhonmCi3GhiLGM8d9RjAE3fky8JllthpBSPxNNJwRyMkZoTHkhCYlS
         ORgB8QsbLEbQxenBkftm1mbrx0IYowLT5vz+On9MX3KFS6uhZVTF9a+lRuCcYJdqqV1+
         Zl4g==
X-Gm-Message-State: AOAM533/6N4kDZFdTO+V+k5oxYNr9fRlGqUJKwkaX3Q030QvB2XnZQBG
        3dCoOuu+a+ivJOhvispL7kdkCGRt2shZBg==
X-Google-Smtp-Source: ABdhPJzYKbTFNbuIUSpN2NK5Mypk30gJoQP7G5liU6aWcR4qfYGxe5ZP0x48SZzGYAFX6eVqJEnaMw==
X-Received: by 2002:a7b:ce04:0:b0:38c:6c34:9aac with SMTP id m4-20020a7bce04000000b0038c6c349aacmr3692893wmc.142.1650035586068;
        Fri, 15 Apr 2022 08:13:06 -0700 (PDT)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id k11-20020a5d6d4b000000b0020599079f68sm4228167wri.106.2022.04.15.08.13.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Apr 2022 08:13:05 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <051a7d3d-4c0e-dc29-937f-be4fcc2f5eec@redhat.com>
Date:   Fri, 15 Apr 2022 17:13:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [RFC PATCH v5 098/104] KVM: TDX: Handle TDX PV report fatal error
 hypercall
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <d1bc7a6123b9b2c233518a5f234df99c3c6f458d.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <d1bc7a6123b9b2c233518a5f234df99c3c6f458d.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:49, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Wire up TDX PV report fatal error hypercall to KVM_SYSTEM_EVENT_CRASH KVM
> exit event.
> 
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>   arch/x86/kvm/vmx/tdx.c | 11 +++++++++++
>   1 file changed, 11 insertions(+)
> 
> diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
> index 123d4322da99..4d668a6c7dc9 100644
> --- a/arch/x86/kvm/vmx/tdx.c
> +++ b/arch/x86/kvm/vmx/tdx.c
> @@ -1157,6 +1157,15 @@ static int tdx_emulate_wrmsr(struct kvm_vcpu *vcpu)
>   	return 1;
>   }
>   
> +static int tdx_report_fatal_error(struct kvm_vcpu *vcpu)
> +{
> +	/* Exit to userspace device model for teardown. */
> +	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
> +	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_CRASH;
> +	vcpu->run->system_event.flags = tdvmcall_p1_read(vcpu);
> +	return 0;
> +}

With the latest SEV changes we have a data[] member.  Please set type 
instead to KVM_SYSTEM_EVENT_CRASH|KVM_SYSTEM_EVENT_NDATA_VALID and ndata 
to 1, so that the value of p1 (which will be a0 in the next series) can 
go in data[0].

Paolo
