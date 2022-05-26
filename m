Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91896534D83
	for <lists+kvm@lfdr.de>; Thu, 26 May 2022 12:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347079AbiEZKkF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 May 2022 06:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239467AbiEZKkC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 May 2022 06:40:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3C1E5CC16D
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:40:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653561599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8EWAiYBYk725y81Cip9A4eLxA/2E8LypU9bh49pcKwc=;
        b=fi/ftpi73Qv8jrtWgb3G5LYUKA5rqE77dbcaT9sgoY5hgTEE/AMYVbz75I0sQykrCN8ImV
        BQXv9yF06YWyyJ2UwXlu4K/fiSYfJhKGDioqoutTjUPnPxbNNgx8kCQS2gXQgCGx8TOoov
        F6ixtds3IlhleZFQOVK42Yatqm4a/eU=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-379-C8AByQE4NL25OaN3X3p-Pw-1; Thu, 26 May 2022 06:39:58 -0400
X-MC-Unique: C8AByQE4NL25OaN3X3p-Pw-1
Received: by mail-ed1-f72.google.com with SMTP id bm4-20020a0564020b0400b0042be0b4ba34so295391edb.20
        for <kvm@vger.kernel.org>; Thu, 26 May 2022 03:39:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8EWAiYBYk725y81Cip9A4eLxA/2E8LypU9bh49pcKwc=;
        b=bVrxQUh8TrExBuJ7vYCMFpbymmxjV13v/E5ZEC18fR8dxIqaGHFFOZ39cunK8xQZ0s
         CVlprY9eTJ4FhXBiZ35U5BROEjNGw2nAoTfVre8fQ8MBn28VVYkGzomwfVHLtgRiDcKm
         +MmdfaEX/mhcvxZGmZEnihnMh9co2M3KZdX273qEHfFxBq9oVNy87PPm+S8k5ibVQWOQ
         FteAXLgpBEy+NNFwThhLzany302zQ2PD6iPQOwopqjaWqfTug50rpcnn6cVwTMBQXQ/c
         wpYvdHI6s+668OtT5irHz38N09LwCgf6GUH99ZdBCLM2FhZOZkfIcjQ+KY18Qx2guQC9
         CisQ==
X-Gm-Message-State: AOAM531JSuyK+4q7/ts8XVMX+frvPB2+Ijv7xXXXDUxUA8Fh5KnWT3v9
        Mq2CGac9OxnAgRU4qo5Xc1oGvAV/J+Ahl86tEQDkVwB7MHY/dPb9rj3Donsrp3GlnyIOWZXRc/h
        DEEQlcXZTRsvV
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr33758319ejo.647.1653561596931;
        Thu, 26 May 2022 03:39:56 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwtAO6TZgqMXrEm2H/AdlTd7mXLZMlmxf6oRDjQkfiY76qayygnuLVMz3FRQqkQ3im8y4fEOA==
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr33758303ejo.647.1653561596722;
        Thu, 26 May 2022 03:39:56 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id q14-20020a50c34e000000b0042bb015df6asm641485edb.6.2022.05.26.03.39.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 May 2022 03:39:56 -0700 (PDT)
Message-ID: <8baca98e-63d6-f7dd-067b-05f8e0dc381f@redhat.com>
Date:   Thu, 26 May 2022 12:39:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 1/2] KVM: VMX: Sanitize VM-Entry/VM-Exit control pairs at
 kvm_intel load time
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        Lei Wang <lei4.wang@intel.com>
References: <20220525210447.2758436-1-seanjc@google.com>
 <20220525210447.2758436-2-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220525210447.2758436-2-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/25/22 23:04, Sean Christopherson wrote:
>   
> +#define VMCS_ENTRY_EXIT_PAIR(name, entry_action, exit_action) \
> +	{ VM_ENTRY_##entry_action##_##name, VM_EXIT_##exit_action##_##name }
> +
>   static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   				    struct vmx_capability *vmx_cap)
>   {
> @@ -2473,6 +2476,24 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf,
>   	u64 _cpu_based_3rd_exec_control = 0;
>   	u32 _vmexit_control = 0;
>   	u32 _vmentry_control = 0;
> +	int i;
> +
> +	/*
> +	 * LOAD/SAVE_DEBUG_CONTROLS are absent because both are mandatory.
> +	 * SAVE_IA32_PAT and SAVE_IA32_EFER are absent because KVM always
> +	 * intercepts writes to PAT and EFER, i.e. never enables those controls.
> +	 */
> +	struct {
> +		u32 entry_control;
> +		u32 exit_control;
> +	} vmcs_entry_exit_pairs[] = {
> +		VMCS_ENTRY_EXIT_PAIR(IA32_PERF_GLOBAL_CTRL, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_PAT, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_EFER, LOAD, LOAD),
> +		VMCS_ENTRY_EXIT_PAIR(BNDCFGS, LOAD, CLEAR),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_RTIT_CTL, LOAD, CLEAR),
> +		VMCS_ENTRY_EXIT_PAIR(IA32_LBR_CTL, LOAD, CLEAR),

No macros please, it's just as clear to expand them especially since the 
#define is far from the struct definition.

Paolo

