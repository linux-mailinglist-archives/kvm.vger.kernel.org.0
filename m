Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFE84D7598
	for <lists+kvm@lfdr.de>; Sun, 13 Mar 2022 14:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234141AbiCMN45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 13 Mar 2022 09:56:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbiCMN4y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 13 Mar 2022 09:56:54 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2353BBF0;
        Sun, 13 Mar 2022 06:55:46 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id i8so20010740wrr.8;
        Sun, 13 Mar 2022 06:55:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rlMOnsFuU1AgOBi7rOi+2Mth/ukPdCXZlzT0m/8TXBw=;
        b=auZRoSCfL40y5lDr+kYRP4dasa23w7SteTZpUjA5FlrrkoQ44MZKozo9qQgIZPJwSL
         KwWIyJzs6j84238Id65mR7QSDgO3VEyhS/NaqkgkhAUYC6zKu7TQ9t4RmTg2JfhxX3m3
         KdKcVL9lkml8DTGKtjOsfB8JMUi5sSZwBy+uE63a6h/9yyqZ9GnXqei42wsoXuvL/+tW
         raNKkRwPUG5JKuXliWZMZNLQgSBqEEQuNPaittkTSh8sonlv3lJZAZWwWHohiJvAFT/M
         OBhHVhwPgVmoWm4LOON9NZokLFUlw77oYs0gjdUQbokE52lPxq4lsjp5qYAADUhKX6wq
         uL3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=rlMOnsFuU1AgOBi7rOi+2Mth/ukPdCXZlzT0m/8TXBw=;
        b=653cEXzvO41FNFekkBs3u2fDKt0/lf633673z5PSR18h5GyoOX7bXTvh52282yvOvo
         l+82TslEY1ejiNuub0oB7/bWJE5Byw0q4LCNdtLAhHafIrCuCz0iZavWsAEd7xOBFX+p
         ZMpUsY6HYH+WtzhDwpJv3TQoFwHPgv/NyVHIhzxO1+jUOKZ5WvegU0TT3uhJlB0hu3Gd
         qPD7qAN35goKS0aRR8Ejc7YJUUu1tQFWt9hJzK0jcSJvN8Myk4B5+UgDtsk0YCI0afuq
         s5t5x6n6isO8WV4GqaYUTAJOcG+sLVVsCu9q+WWcy55RZPwk8yYH+nWBj2SKv1oSbtrK
         M4Gg==
X-Gm-Message-State: AOAM532vStdOgSmtAwx/i3vR2KxkqCd8yJG47xJroaBks2VR0qBdiDaW
        B2Yk3Sw49rlU0yHYnfksV1g=
X-Google-Smtp-Source: ABdhPJx7oVZQgRT7yFlRnHna5og7MKNX9TD3EFwP7rCXQQa40QbUxWlgO9DXT3GUEBcBC2FGcnrmCg==
X-Received: by 2002:a5d:4441:0:b0:1f0:882d:77e9 with SMTP id x1-20020a5d4441000000b001f0882d77e9mr13354363wrr.718.1647179745374;
        Sun, 13 Mar 2022 06:55:45 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.googlemail.com with ESMTPSA id p125-20020a1c2983000000b00389cc36a3bfsm14721066wmp.6.2022.03.13.06.55.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Mar 2022 06:55:44 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <50a659fd-b597-7dee-f6fa-e447a552dc6c@redhat.com>
Date:   Sun, 13 Mar 2022 14:55:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v5 006/104] KVM: TDX: Add placeholders for TDX VM/vcpu
 structure
Content-Language: en-US
To:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <8572ed61be2bb771fc4dc1d366a1261c80b7f666.1646422845.git.isaku.yamahata@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <8572ed61be2bb771fc4dc1d366a1261c80b7f666.1646422845.git.isaku.yamahata@intel.com>
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
> +void __init tdx_pre_kvm_init(unsigned int *vcpu_size,
> +			unsigned int *vcpu_align, unsigned int *vm_size)
> +{
> +	*vcpu_size = sizeof(struct vcpu_tdx);
> +	*vcpu_align = __alignof__(struct vcpu_tdx);
> +
> +	if (sizeof(struct kvm_tdx) > *vm_size)
> +		*vm_size = sizeof(struct kvm_tdx);
> +}

No need for this function, I would just do

	vcpu_size = max(sizeof vcpu_vmx, sizeof vcpu_tdx);
	vcpu_align = max(...);
	vt_x86_ops.vm_size = max(...);

in vt_init.

Paolo
