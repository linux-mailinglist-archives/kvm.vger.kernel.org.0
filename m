Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FD524D2CA4
	for <lists+kvm@lfdr.de>; Wed,  9 Mar 2022 10:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232360AbiCIJ76 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Mar 2022 04:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiCIJ74 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Mar 2022 04:59:56 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16A19129BB7;
        Wed,  9 Mar 2022 01:58:58 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id t1so1907682edc.3;
        Wed, 09 Mar 2022 01:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WvBJ1bCYmOpUz9sA2X7ttEKRPJ5e2lRH183jSE/0mtI=;
        b=D49GbhhMWElAvxVZqt+JI2yYnMree6VqtRkg2bg8NFou0W4gSTHSN1CPz+VECruU/M
         ZdojhZRGosAacK3OO0KLYjg4QM3U6dDHy9xk+odQsb/rDpDO0PFO7qz6EL6WfVs5uU0X
         d1FiVaCBGu84e6cPqImY37dxrixcVJnLVX8HgFdYYwHamMbeQLEI/13j4hJSjDIh4mLc
         npkKBZSdjXZs8dxVz7Uf0gW0Wchx7gO+e70LZnLM1gSRQR5W521GWuNwRW8JLUsAndtb
         wuHQJUNbHdDe5Qjv+n81SyZReygB5eMJZdMU4+1nNrvMBrEB3N2VnOP0iwnG0IqdgPSz
         Tbnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WvBJ1bCYmOpUz9sA2X7ttEKRPJ5e2lRH183jSE/0mtI=;
        b=aLV+C/OZTzTJlcvOxcDgkZ49mpmSEvJA8hw1o2dpV2wepVaK0S1Lzv8VD6bzFYxaMu
         N+A0nAF/Ceix6+mmw4bqm3jW49ZM/n6VRXKhEYN9I1hKawSb7UQ1H3fBuK9JNhapoiic
         kwwg5o+mamncoKJ/dHBPk9/TYvpF6NKyIP2i7prk4vCn+pdFn2B0tgmuEt5VfLA4ZuKF
         avyfq+M8+jSsIJrLxSGusgOoJ7fDm4V9X25RLqcq6177UFHMMksIV9oB6IWhmfMqVZ77
         /gIGrZO1cJ0p3V9tD0AFzu8LVJlsR8JR0R7zE12+InUihQG0AicLIMs8lwp4JThOAq4t
         g+SA==
X-Gm-Message-State: AOAM5328X69Y/d/gK9mtOC5TPuxpyRCgqPfPho8os5pjvWFUSPUXGi/F
        cqj2evXl/1LgRd0pWPC+3pw=
X-Google-Smtp-Source: ABdhPJw+njvmNggCfx5Yl4DtOUfmT/TZk9Zj9sdzyD2ye1Lh3M2PohyXgqqXuiVm1pN3S/h80TZSQw==
X-Received: by 2002:a05:6402:3582:b0:416:6413:d2ae with SMTP id y2-20020a056402358200b004166413d2aemr9704298edc.192.1646819936447;
        Wed, 09 Mar 2022 01:58:56 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id k19-20020a1709067ad300b006da92735c32sm544940ejo.16.2022.03.09.01.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 01:58:55 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <175b89f0-14a6-2309-041f-69314d9f191a@redhat.com>
Date:   Wed, 9 Mar 2022 10:58:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 08/25] KVM: x86/mmu: split cpu_mode from mmu_role
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        dmatlack@google.com
References: <20220221162243.683208-1-pbonzini@redhat.com>
 <20220221162243.683208-9-pbonzini@redhat.com> <YiemuYKEFjqFvDlL@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YiemuYKEFjqFvDlL@google.com>
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

On 3/8/22 19:55, Sean Christopherson wrote:
>>   static void shadow_mmu_init_context(struct kvm_vcpu *vcpu, struct kvm_mmu *context,
>> -				    const struct kvm_mmu_role_regs *regs,
>> -				    union kvm_mmu_role new_role)
>> +				    union kvm_mmu_role cpu_mode,
> Can you give all helpers this treatment (rename "role" => "cpu_mode")?  I got
> tripped up a few times reading patches because the ones where it wasn't necessary,
> i.e. where there's only a single kvm_mmu_role paramenter, were left as-is.
> 
> I think kvm_calc_shadow_npt_root_page_role() and kvm_calc_shadow_mmu_root_page_role()
> are the only offenders.

These take struct kvm_mmu_role_regs; they *return* union kvm_mmu_role 
but that is changed later in the series to the base part only.

Paolo
