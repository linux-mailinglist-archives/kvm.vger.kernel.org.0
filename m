Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC234667A62
	for <lists+kvm@lfdr.de>; Thu, 12 Jan 2023 17:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbjALQL1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Jan 2023 11:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjALQLF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Jan 2023 11:11:05 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7192165C8
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:02:49 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id c4-20020a1c3504000000b003d9e2f72093so12095736wma.1
        for <kvm@vger.kernel.org>; Thu, 12 Jan 2023 08:02:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=wEGLcc/K4lhhVttssI3Nds8zaZY0zckGsYHeWj2YldM=;
        b=XDDv+Nk9dsKMI4B0650QXm8ARlJBifjMtB8uQBteWkNPsxKH3dLM+aEZv6hSm+9ma6
         fGGtuLjljHnqR9JWgSbVq0zVXMpl49cKYDwOauiP9BaQVVmc86+T2ufBDb30LJ4io9m5
         5SQnA4Lvhk6bw6DKdqE+wVIF2UGf0WXDZp6d5EdO9mQiv6Y/rVBPlCOL7Pt7MCy3Yha8
         4B82Mp7ovBicnSrRcxrNYjy6atrzmVlAjY46EBTJ08hjKDah211NGogkhzk+IO1WD9ow
         2F6izZCrHfnNvonxx9/cmVEbGWol0G7HLpwDTjAwD73Xx1dGYqahqqKwm1TexTN7ifK3
         nMTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:content-language
         :references:cc:to:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wEGLcc/K4lhhVttssI3Nds8zaZY0zckGsYHeWj2YldM=;
        b=NBWxqII7gJuWNOefTdj1ivI6RHmu5P5KvfZBi0hKV0S3dUmF6b4TU+89rqite/0fte
         ULTMMdQ0n+7ui6qzebek6ZPMJHDXYUMBN5ldIZ2mSQMcnCeUpkG4MdaKRbjUCk+NsYsS
         eVfK06MZuKpPVWNFTCCIYpP7hJp/tH0BpcgcuUKeux+I4pAAjDaNTCQCKi4DIUS5knhC
         7rOZwrPKzYjB+WGJnXEhmNoEMsEWsAdKby0UpZHMGzFTTtHKdHYAZsEbSRVfqVr4gMOT
         AUVYR8YmIovzu/DFyGVNCPyqfX843RXTOPeTa4qEtUZi+JInksC/rkJUjz89KUge3e/8
         sMig==
X-Gm-Message-State: AFqh2kqFO1Wa2WVTYndf3a2jrkagqQPUryR12Bs1ybAKXTgo142lr2JA
        ZOjG8RjJDs1NihRt9bjXNTo=
X-Google-Smtp-Source: AMrXdXtNuU+I1q6eUFkApOWQ/VwRNKuTQzuo84XYQoH9r068pI9b08qFxUPH8XGIQsz/Cg9EFGqNSA==
X-Received: by 2002:a05:600c:1d8a:b0:3d9:ebab:ccff with SMTP id p10-20020a05600c1d8a00b003d9ebabccffmr13924709wms.33.1673539367847;
        Thu, 12 Jan 2023 08:02:47 -0800 (PST)
Received: from [10.85.34.175] (54-240-197-225.amazon.com. [54.240.197.225])
        by smtp.gmail.com with ESMTPSA id o5-20020a05600c510500b003b4ff30e566sm9271075wms.3.2023.01.12.08.02.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Jan 2023 08:02:47 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <33e1de6d-a6af-bd96-fbb3-e34e61138cd1@xen.org>
Date:   Thu, 12 Jan 2023 16:02:46 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 1/4] KVM: x86/xen: Fix lockdep warning on "recursive"
 gpc locking
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Michal Luczaj <mhal@rbox.co>
References: <20230111180651.14394-1-dwmw2@infradead.org>
Content-Language: en-US
Organization: Xen Project
In-Reply-To: <20230111180651.14394-1-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/01/2023 18:06, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> In commit 5ec3289b31 ("KVM: x86/xen: Compatibility fixes for shared runstate
> area") we declared it safe to obtain two gfn_to_pfn_cache locks at the same
> time:
> 	/*
> 	 * The guest's runstate_info is split across two pages and we
> 	 * need to hold and validate both GPCs simultaneously. We can
> 	 * declare a lock ordering GPC1 > GPC2 because nothing else
> 	 * takes them more than one at a time.
> 	 */
> 
> However, we forgot to tell lockdep. Do so, by setting a subclass on the
> first lock before taking the second.
> 
> Fixes: 5ec3289b31 ("KVM: x86/xen: Compatibility fixes for shared runstate area")
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> ---
>   arch/x86/kvm/xen.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 

Reviewed-by: Paul Durrant <paul@xen.org>

