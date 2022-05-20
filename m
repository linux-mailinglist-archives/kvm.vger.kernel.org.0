Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE4C52EE7B
	for <lists+kvm@lfdr.de>; Fri, 20 May 2022 16:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350498AbiETOtz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 May 2022 10:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350494AbiETOtq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 May 2022 10:49:46 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026511737EF;
        Fri, 20 May 2022 07:49:44 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id en5so11126992edb.1;
        Fri, 20 May 2022 07:49:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3lQxYbWXEP6uwC0KR1H8SjH5k3UicDj1ai6gDVQrEtI=;
        b=Qc4Z7iVvog+zQB82KcR6ielXaXYpNOWCAt8CUU9cXNlzEq6A6C1M/tX5nMx8Xs7vYS
         vuqrTYf6yR0sifhuKxsEx3PfOFXL/395V/IpZ+yXtKeq6K2pT/b/5WgWOcDhxDNsRlkY
         U57E/0G0LKzY7uCglzvDzoOPnmEGM53fEovsSE5QJkEXJe6vOVwP9Gq9QlqI+fMdIew2
         sPUdX9pfo5Npiu3VpD9fNecYoXRuPRfQQ7Sno3kRjnYyJdGW9QP7lqDzuwivHEjWrw1p
         t1cs+zW9s41+n3+U6MU7FV/uc3+1Z9c9/M/OJ55fAQFGkvj+UQMvpIu6MCephR0L06sO
         WS8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3lQxYbWXEP6uwC0KR1H8SjH5k3UicDj1ai6gDVQrEtI=;
        b=hwdUnlauP/QU8Snk3z4xBxBc4XEMsL0MjDTT8Wfsp76TSvIA/URhXlWptipvA50ONT
         OZ6fYZ7gf2aaKoqyj0Mw/hREPIXCnSZA0W5seN/XuL9HsWH+MkDblpqMRBuTU6X+nIFW
         zZcfs4vL5QTWP3acroXbTpjW8zSPnO+2Du8v/yk/jJF2Ki2fUFbhG5WrEWbAUkJjtgNW
         fp8ZcmKUZWc8iN8VJzQqL0t1atFlFEWHRyyTuLZxo0U0H6VcLZtmqG43F4xpzTuLP819
         qN4dz5fdnn8cY+XxQLf956RIZZgow+UrGFyMD6FFzhWE9Gij3y71v/u2w4G9OhaMQP32
         uwgA==
X-Gm-Message-State: AOAM532+lBBwd3OTXQTEFhLm1c9UMjBoQ1znsPd/rhlE71hMkgYyA1Qj
        XyY8t8aqeGj2mJzXL3dMVvk1Wk8QBuOeuQ==
X-Google-Smtp-Source: ABdhPJzouOMsHp5AumLigjIAucsoC6vK+9Cp9dTYqJqCpkMV1w2fMIUyqFUcWwS8nHDlBaYG1plAwQ==
X-Received: by 2002:a05:6402:4396:b0:427:f2dc:b11 with SMTP id o22-20020a056402439600b00427f2dc0b11mr11479587edc.298.1653058182595;
        Fri, 20 May 2022 07:49:42 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id ra48-20020a17090769b000b006fe9a2874cdsm1808233ejc.103.2022.05.20.07.49.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 07:49:42 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <035a5300-27e1-e212-1ed7-0449e9d20615@redhat.com>
Date:   Fri, 20 May 2022 16:49:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 6/8] KVM: Fix multiple races in gfn=>pfn cache refresh
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw@amazon.co.uk>,
        Mingwei Zhang <mizhang@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
References: <20220427014004.1992589-1-seanjc@google.com>
 <20220427014004.1992589-7-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220427014004.1992589-7-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/27/22 03:40, Sean Christopherson wrote:
> +		 * Wait for mn_active_invalidate_count, not mmu_notifier_count,
> +		 * to go away, as the invalidation in the mmu_notifier event
> +		 * occurs_before_  mmu_notifier_count is elevated.
> +		 *
> +		 * Note, mn_active_invalidate_count can change at any time as
> +		 * it's not protected by gpc->lock.  But, it is guaranteed to
> +		 * be elevated before the mmu_notifier acquires gpc->lock, and
> +		 * isn't dropped until after mmu_notifier_seq is updated.  So,
> +		 * this task may get a false positive of sorts, i.e. see an
> +		 * elevated count and wait even though it's technically safe to
> +		 * proceed (becase the mmu_notifier will invalidate the cache
> +		 *_after_  it's refreshed here), but the cache will never be
> +		 * refreshed with stale data, i.e. won't get false negatives.

I am all for lavish comments, but I think this is even too detailed.  What about:

                 /*
                  * mn_active_invalidate_count acts for all intents and purposes
                  * like mmu_notifier_count here; but we cannot use the latter
                  * because the invalidation in the mmu_notifier event occurs
                  * _before_ mmu_notifier_count is elevated.
                  *
                  * Note, it does not matter that mn_active_invalidate_count
                  * is not protected by gpc->lock.  It is guaranteed to
                  * be elevated before the mmu_notifier acquires gpc->lock, and
                  * isn't dropped until after mmu_notifier_seq is updated.
                  */

Paolo
