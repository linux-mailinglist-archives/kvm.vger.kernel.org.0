Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 778C76FBC46
	for <lists+kvm@lfdr.de>; Tue,  9 May 2023 03:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjEIBEs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 8 May 2023 21:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjEIBEp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 8 May 2023 21:04:45 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9862700;
        Mon,  8 May 2023 18:04:44 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-64115eef620so38718198b3a.1;
        Mon, 08 May 2023 18:04:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683594283; x=1686186283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A/eeFC8dcbPa4pCqEyWdKkytQsMGVfBsdFuIBBNLaI4=;
        b=Ids9hQYw3LSbClm+e+oSHj6XMgYdg3GeiZBlLd3gXX19ywvH/YEjxhUdCxqL1YPiAO
         2IX/0dwlyBdgXYszLhCqAmGWLrN8jcGN6nTDofvtQAJH2Cc5tIjyh73HvWXn03HiRCao
         RwZ4zsHPesKy+iRmvf4Kzi9YF3AjV+ikv9XKu/pv4FNe67oX8P8xLEpKqTdCW3dyDyyl
         l7BeNYemar6Gk+jUn85bqSP+TB8J+lw6Az8jdw6bh3FPYrIlUqtSo0G8kRkts6uLXHfX
         3RIJacgl0ptAJV5o41KdK2TyfudwjCzFQh34MUqizKcz5+SD3goaGp0Rwat6zNC2I/c9
         B2FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683594283; x=1686186283;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A/eeFC8dcbPa4pCqEyWdKkytQsMGVfBsdFuIBBNLaI4=;
        b=aK0XoaZMbHjOvODfG/4nUjghWu+yM0aNOzv8MpBn7p+H7FAQkIKgi8JXj5YJ6IDDf+
         7MzbjmdiGIqYsBw/IzjwA3ybnbav1Zlpd01atNJBgdbnaPMcH28ny+YKPAZC0hoFcCsk
         6v8tgihVghb72oNSn55nrRquSmqarvd7nQtttDjUQ3okSCf4e6+k+yarpCQ+oKo+pqLh
         308wP/9MHUIiX+4LGalw8x1pyBILX6FDKtwFz+DKA29yeEfZqbLXEH05T+E/oEape54u
         PV/Twf9suQwvYPamW/ecYOkpARkgi+Kl+ddrsA2q/ry+hcXFl+7ixH+kvz+RuiSH0fqJ
         zT5A==
X-Gm-Message-State: AC+VfDySNRlncdWuQYYC41SdTstTIVlvhavzXioL/xs+wm1rlab7dl63
        HP84SeC9QWPjNl46JohRmKgFzvLLPnE=
X-Google-Smtp-Source: ACHHUZ5sKdGmB7fo/A8VsSBn039olyGcgtYBkwC7l/jWfQClFlGNymESgeJ88HgoFLm9fFTNMzM7Ng==
X-Received: by 2002:a17:902:e5c6:b0:1a5:27d2:b6de with SMTP id u6-20020a170902e5c600b001a527d2b6demr21951662plf.3.1683594283413;
        Mon, 08 May 2023 18:04:43 -0700 (PDT)
Received: from [172.27.232.45] (ec2-16-163-40-128.ap-east-1.compute.amazonaws.com. [16.163.40.128])
        by smtp.gmail.com with ESMTPSA id l5-20020a17090270c500b001a641ea111fsm109074plt.112.2023.05.08.18.04.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 May 2023 18:04:43 -0700 (PDT)
Message-ID: <5aec4689-fe63-abff-94d4-8e42cf5bba66@gmail.com>
Date:   Tue, 9 May 2023 09:04:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/6] KVM: x86: Do not unload MMU roots when only
 toggling CR0.WP with TDP enabled
To:     Mathias Krause <minipli@grsecurity.net>, kvm@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
References: <20230322013731.102955-1-minipli@grsecurity.net>
 <20230322013731.102955-3-minipli@grsecurity.net>
 <e70af22a-f09f-aadb-8353-35b29d2def61@gmail.com>
 <b0d4b430-afd2-979c-e7d2-b53e131412ad@grsecurity.net>
Content-Language: en-US
From:   Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <b0d4b430-afd2-979c-e7d2-b53e131412ad@grsecurity.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/8/2023 5:30 PM, Mathias Krause wrote:
>>>    void kvm_post_set_cr0(struct kvm_vcpu *vcpu, unsigned long old_cr0,
>>> unsigned long cr0)
>>>    {
>>> +    /*
>>> +     * CR0.WP is incorporated into the MMU role, but only for
>>> non-nested,
>>> +     * indirect shadow MMUs.  If TDP is enabled, the MMU's metadata
>>> needs
>>> +     * to be updated, e.g. so that emulating guest translations does the
>>> +     * right thing, but there's no need to unload the root as CR0.WP
>>> +     * doesn't affect SPTEs.
>>> +     */
>>> +    if (tdp_enabled && (cr0 ^ old_cr0) == X86_CR0_WP) {
>>
>> Curiously, this patch only affects tdp_enabled, why does legacy MMU also
>> see comparable performance gains?
> 
> Because 'tdp_enabled' just implies EPT / NPT and only 'tdp_mmu_enabled'
> decides which MMU mode to use -- either legacy or TDP MMU (see
> kvm_configure_mmu() and now gets invoked from vmx.c / svm.c).
> 
Ah, get it, thanks. The name indeed confuses me (and perhaps others).
After dig into,
1. kvm modules has a param "tdp_mmu_enabled", (in the first place) 
indicates KVM level's willingness on enable two dimensional paging. 
However, it in the end depends on ept/npt enabled or not on vendor layer.
So, uses a "tdp_mmu_allowed" to intermediately record this willness in kvm 
module init phase.
	/*
	 * Snapshot userspace's desire to enable the TDP MMU. Whether or not the
	 * TDP MMU is actually enabled is determined in kvm_configure_mmu()
	 * when the vendor module is loaded.
	 */
	tdp_mmu_allowed = tdp_mmu_enabled;
2. When vendor module init --> kvm_configure_mmu()
	tdp_mmu_enabled = tdp_mmu_allowed && tdp_enabled;

    tdp_mmu_enabled's semantics becomes, as its name indicates, the 
eventual tdp mmu enablement status.

    And, tdp_enabled, is the general (ept_enabled | npt_enabled).

