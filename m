Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF8C4D75A6
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 15:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234212AbiCMOB3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 10:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiCMOB1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 10:01:27 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F907EDBB;
        Sun, 13 Mar 2022 07:00:17 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id i8so20020864wrr.8;
        Sun, 13 Mar 2022 07:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QLl98LlWQXwwlb6AX7WfU7kVVIv601QJbbRmu10S8Uk=;
        b=EJznyYr4gZ6XVNEiGGA9RfICM+rwqho1fB8tZAaCTDDNJrC4xgJ6GsPbtlW9ETRTLz
         7ICEIggZodzPgMkM1Whzd0tuTLmdkKDFsC8NMBVRJFxIEcLm6RwYhvVUO5qu7lneZZZU
         ICAKBqiURf9ASQIfwtXvMKqoerh8Eto+ZFj1La63jEFfUdbhswDAUyuCI3zx+uNeEKva
         2pKJcbEZk5sdD7G9y6cujGpWNh9LTXKDM4HVj+zSZk+Ip2Ld76a44Ama0oc+3O/YCLuY
         ZqABotgkC/Lh7PeJfFXdVrrNi0kIOxO217NnClEU6jO1EnBNBqroUBM1BMoWQLjj/Ybb
         JsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QLl98LlWQXwwlb6AX7WfU7kVVIv601QJbbRmu10S8Uk=;
        b=sST+g4tji96TTGLYv/wMqqlKlt8efsKS8bsGHH8lp//5MRo8pviUuvBFZb4IQA87Qj
         PkQqXotHhcyvHpSd4bV56ZL/Tuh2ThxGGUL/PmrEy7KS7mk2a+82RHhdLcej5f8c3cgk
         e/9Jwj0HnlwkVqz4943HF6cWGKbwB1HnKCIPvx5COHSUYzKAi0+gCP22dyo1VKJTrufo
         xF5mPkXIgjsX1P34ADBt8dTUG6vGEZNLt4qohwT7mF6/8u7AHKzBHKEh9mKKxacRIkeA
         afGQPhadsvK/IX1uXqiyhCAK6PS9YH2lfmJp1hnftxn08IBF1SDEu2cXRrLNR131fwjx
         nQ1A==
X-Gm-Message-State: AOAM533HiZY9dwlxkiJH2t+SrXkveNHm2PVfDHg7uDsAYBYD+KbY1tIo
        DjGDGTaO9nUJSuuwpzvAce/GrMVhlR8=
X-Google-Smtp-Source: ABdhPJxeGajEjsSmpjaYC5aP5L/SMKRak+wf7cvNAKoH3eFOB/ZSXH/2L1WDZuqmzfwgr5YqhY34XQ==
X-Received: by 2002:adf:d4c1:0:b0:1f0:59ad:7fb0 with SMTP id w1-20020adfd4c1000000b001f059ad7fb0mr13622707wrk.288.1647180016459;
        Sun, 13 Mar 2022 07:00:16 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id k18-20020adfe8d2000000b0020294da2b42sm16917548wrn.117.2022.03.13.07.00.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 07:00:16 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <994378c4-8558-6c23-af40-e1914d5fc5b6@redhat.com>
Date:   Sun, 13 Mar 2022 15:00:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 004/104] KVM: Enable hardware before doing arch VM
 initialization
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <9fa862520b817bf7d029ce0d030ad17b799f1472.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <9fa862520b817bf7d029ce0d030ad17b799f1472.1646422845.git.isaku.yamahata@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> From: Sean Christopherson <sean.j.christopherson@intel.com>
> 
> Swap the order of hardware_enable_all() and kvm_arch_init_vm() to
> accommodate Intel's TDX, which needs VMX to be enabled during VM init in
> order to make SEAMCALLs.
> 
> This also provides consistent ordering between kvm_create_vm() and
> kvm_destroy_vm() with respect to calling kvm_arch_destroy_vm() and
> hardware_disable_all().
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>

and please submit this as a preparation patch that can be committed 
separately.

Paolo

> ---
>   virt/kvm/kvm_main.c | 14 +++++++-------
>   1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 0afc016cc54d..52f72a366beb 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -1105,19 +1105,19 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   		rcu_assign_pointer(kvm->buses[i],
>   			kzalloc(sizeof(struct kvm_io_bus), GFP_KERNEL_ACCOUNT));
>   		if (!kvm->buses[i])
> -			goto out_err_no_arch_destroy_vm;
> +			goto out_err_no_disable;
>   	}
>   
>   	kvm->max_halt_poll_ns = halt_poll_ns;
>   
> -	r = kvm_arch_init_vm(kvm, type);
> -	if (r)
> -		goto out_err_no_arch_destroy_vm;
> -
>   	r = hardware_enable_all();
>   	if (r)
>   		goto out_err_no_disable;
>   
> +	r = kvm_arch_init_vm(kvm, type);
> +	if (r)
> +		goto out_err_no_arch_destroy_vm;
> +
>   #ifdef CONFIG_HAVE_KVM_IRQFD
>   	INIT_HLIST_HEAD(&kvm->irq_ack_notifier_list);
>   #endif
> @@ -1145,10 +1145,10 @@ static struct kvm *kvm_create_vm(unsigned long type)
>   		mmu_notifier_unregister(&kvm->mmu_notifier, current->mm);
>   #endif
>   out_err_no_mmu_notifier:
> -	hardware_disable_all();
> -out_err_no_disable:
>   	kvm_arch_destroy_vm(kvm);
>   out_err_no_arch_destroy_vm:
> +	hardware_disable_all();
> +out_err_no_disable:
>   	WARN_ON_ONCE(!refcount_dec_and_test(&kvm->users_count));
>   	for (i = 0; i < KVM_NR_BUSES; i++)
>   		kfree(kvm_get_bus(kvm, i));

