Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29F8B4AD817
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 13:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbiBHMCt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 07:02:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234109AbiBHMCs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 07:02:48 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DF9C03FEC0;
        Tue,  8 Feb 2022 04:02:47 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id j14so28179882ejy.6;
        Tue, 08 Feb 2022 04:02:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d8Mwo7JcHs/wX7xi36MAMo625linEGbluO6vnnk1iro=;
        b=RvkQ1iTnjOrBg7vdOhC4yM87M1Fp34phG3HzQ9I4VaZGlzSIAUcmlO84g9hEpgzjGQ
         3SuCMgBm1MVYtrHL+arHmbIDVWLVKq6VTraB6h0ERLR8Uj+XYdiRJ07XjXu46/ynz7nQ
         6R3erY+mvsnF2z3iKt7jvGAsZt41DAjslU7al1878FsWDg/xq86vgN8907LIFrNkkWRs
         qG2GqZSs/KODmKA5kBg6x+2YR6RSN2/AyrFa0PGxoDDa69jf2elJF1LfX2iG8+l96sfl
         ij6H01jmLbdtXxvlXMF1zjze/bnwXv+gXKJlRWQosa2KzWx4T2kxbqYFdiZ4fpVjdodG
         7Q6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=d8Mwo7JcHs/wX7xi36MAMo625linEGbluO6vnnk1iro=;
        b=ZL9xkmOPpKzrWEj7cF3YA2qDbIWfdusjlLDihDM9KuGBh0XVLc5hKv13eGYeSrMWgy
         fqFhlhehWwoy+/yIq2wmzqymi7SVd+ibx8ubihxAqXRU8ya4aSZHzL4LCk3gUxwJfd51
         ttOdiMsmGX6WsV5A87CbjvWvWUG117aO//ghUdJdI16S7wLzDrZyEWONUZ2uuATQwiyu
         APZHBZZhHt35T3+KjFN+nkBKF9H310SVo6/rs2D0VbObg+leV/N+ofIomLQZnkItzHZP
         awq4HsKcXXfPahFZ5JC+P8eg0MrOHgadLISB1uDIT1Ktfk6tdu1FAfqkLAuMnrDlcHHR
         8n3A==
X-Gm-Message-State: AOAM531P7KlfLqAEYBhJVJtZHeJPfqgxQKQkCtI6r1E5thrO0UE/Fz4A
        JsJTVGsqX66tWaJsdjJ9LL0=
X-Google-Smtp-Source: ABdhPJxtI78Az8LQBoK78nSzfP62yfqSFerWFtypvbBZInDZIcG92vJYBss/dkF80ZGfvgtZFDVaUg==
X-Received: by 2002:a17:906:58d0:: with SMTP id e16mr3357767ejs.454.1644321766016;
        Tue, 08 Feb 2022 04:02:46 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id l2sm6513889eds.28.2022.02.08.04.02.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 04:02:45 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <f48b498a-879d-6698-6217-971f71211389@redhat.com>
Date:   Tue, 8 Feb 2022 13:02:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RESEND 00/30] My patch queue
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Tony Luck <tony.luck@intel.com>,
        "Chang S. Bae" <chang.seok.bae@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Wanpeng Li <wanpengli@tencent.com>,
        Ingo Molnar <mingo@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        intel-gvt-dev@lists.freedesktop.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        David Airlie <airlied@linux.ie>,
        Zhi Wang <zhi.a.wang@intel.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Borislav Petkov <bp@alien8.de>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>
References: <20220207155447.840194-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220207155447.840194-1-mlevitsk@redhat.com>
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

On 2/7/22 16:54, Maxim Levitsky wrote:
> This is set of various patches that are stuck in my patch queue.
> 
> KVM_REQ_GET_NESTED_STATE_PAGES patch is mostly RFC, but it does seem
> to work for me.
> 
> Read-only APIC ID is also somewhat RFC.
> 
> Some of these patches are preparation for support for nested AVIC
> which I almost done developing, and will start testing very soon.
> 
> Resend with cleaned up CCs.

1-9 are all bugfixes and pretty small, so I queued them.

10 is also a bugfix but I think it should be split up further, so I'll 
resend it.

For 11-30 I'll start reviewing them, but most of them are independent 
series.

Paolo
