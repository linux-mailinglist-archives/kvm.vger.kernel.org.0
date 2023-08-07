Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BDF77235B
	for <lists+kvm@lfdr.de>; Mon,  7 Aug 2023 14:02:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbjHGMCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Aug 2023 08:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbjHGMCr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 7 Aug 2023 08:02:47 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F95D1FC8;
        Mon,  7 Aug 2023 05:02:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1bb893e6365so27632825ad.2;
        Mon, 07 Aug 2023 05:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691409725; x=1692014525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GUzrPfmRrMPt+i4UE/lAe9+fC5lOiUGAw2K7J8tfV2c=;
        b=d2GE3aQo5mQfZvlEF7f4oSva4EKJvypvIGy6IuBTAsIUE3RDscNyHs6Em+I3dvnLEN
         Obr3UC2AiaTlHrSkEsJ/2/LFeYfvI1DiNMw5FenkPOHuDossPPZc8ZfeJGsIy+R9emgH
         S+zPKCf80hsaVWKsNUpdmTN80mS2TgCrpRIY5tVhvkJPAPvo5KeS0X2Jwyldn9yI+g6Q
         Z55xF5Wu+GHCqh6GAMq9ECVbnwQqBc3oeadTkaDvDDfs5YsfG/1knWcS8z7eeL+BWZrT
         egWAAOtE1/vlGanMsyRR3IJqlk1YK1GLJmry94YPMykoZPpGbxmbd5/l8MnQYh04wIDr
         yzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691409725; x=1692014525;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GUzrPfmRrMPt+i4UE/lAe9+fC5lOiUGAw2K7J8tfV2c=;
        b=MXnsLErHJ9VZOsyQJLYTuC4A5hiBTRsVY58ivG6u0RFHg7ncdh8cy2x1eY5qDiPW4V
         qS4bZvvUERtyilxlAxosNjdWooEgR2O80M4V7DN+kkJDEj5xJ+qaMMuZa7cGotUaVHQJ
         kQ6Q9Pp6G7gLiKleXK9aeFPOaU5MbVNz+vhFjkrCkwzilYypWmjyZftkyi3vje7EzXtO
         AUVHc2FvPz10FM8sCH5J1f5BPgt20LHMDnpXPw/halxd+ZvmUc+7+/M+TRhztExJ3bI0
         21vMU5VuqwNvILaRbvHg+CabvpA/RjnKhT5gnchHz6bo29QcPwOuVa1tmXVdLOHR7lb7
         qxRw==
X-Gm-Message-State: AOJu0Ywqj9gFM3GMC4Y4d9rTPoS/mfkBZ83s2eQOjG9GoegtqZJ5EMTn
        NIR9umm27tbHnxBN72xj5vw=
X-Google-Smtp-Source: AGHT+IHWYNulalQMDqlB0MHADRqG5ScHqlrzXhiB9uHTqVA4K3003dWe9L2ntXhX6qq+PcVohtu+WA==
X-Received: by 2002:a17:902:c101:b0:1b5:edd:e3c7 with SMTP id 1-20020a170902c10100b001b50edde3c7mr7864273pli.16.1691409724767;
        Mon, 07 Aug 2023 05:02:04 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jc15-20020a17090325cf00b001b7ffca7dbcsm6752298plb.148.2023.08.07.05.02.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Aug 2023 05:02:04 -0700 (PDT)
Message-ID: <5581418b-2e1c-6011-f0a4-580df7e00b44@gmail.com>
Date:   Mon, 7 Aug 2023 20:01:55 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.14.0
Subject: Re: [PATCH 19/27] KVM: x86/mmu: Use page-track notifiers iff there
 are external users
To:     Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Yan Zhao <yan.y.zhao@intel.com>,
        Ben Gardon <bgardon@google.com>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
References: <20221223005739.1295925-1-seanjc@google.com>
 <20221223005739.1295925-20-seanjc@google.com>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221223005739.1295925-20-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/12/2022 8:57 am, Sean Christopherson wrote:
> +static inline void kvm_page_track_write(struct kvm_vcpu *vcpu, gpa_t gpa,
> +					const u8 *new, int bytes)
> +{
> +	__kvm_page_track_write(vcpu, gpa, new, bytes);
> +
> +	kvm_mmu_track_write(vcpu, gpa, new, bytes);
> +}

The kvm_mmu_track_write() is only used for x86, where the incoming parameter
"u8 *new" has not been required since 0e0fee5c539b ("kvm: mmu: Fix race in
emulated page table writes"), please help confirm if it's still needed ? Thanks.
A minor clean up is proposed.
