Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B69D5FEB33
	for <lists+kvm@lfdr.de>; Fri, 14 Oct 2022 10:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiJNIyY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Oct 2022 04:54:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229658AbiJNIyX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Oct 2022 04:54:23 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4401DA58;
        Fri, 14 Oct 2022 01:54:21 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id b5so3765962pgb.6;
        Fri, 14 Oct 2022 01:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dGx4DR91AHMtyy59g5UbkX45izOPK7p3T7j1FkT3gPs=;
        b=NOGGVZVA2t9YMvwaxRO7IwHjqxWy1tel+WkWqxRjHHsbilJOpnSchrit/mwSGPgqP/
         t5fz4ayYCZe+i+ucW1E1n3vpm70RpGAKoNV8gRVOspSFn2VHcTbp5wI5MQDDrXANxgfg
         WcYIXEDrjH5wuJvG4uUec+y1EAShIfol0T82lo4g0P93mPhX03D2yyLyss376d64natb
         qEXcfOlIuo7ieldxwlnBH9ndS8P6m2fIDLXDLLWjXhAHnRk5UiTr5lemovwYn5gBr9b6
         o6+6wLeJuyi7hDqs8cQPvcxMNwUMy/xM/W02yewzAQ8BQ/9IXHkpYoVUquqxfcqzmrfa
         2Ydg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dGx4DR91AHMtyy59g5UbkX45izOPK7p3T7j1FkT3gPs=;
        b=s7ovhQLJmItQI2Ysak91Sx+21VkQ6NsdJUmMxLjc5TbUx0aDLlgAXes3MftbAwvW2G
         JSKYU5rXmgb8sZ0koACzFKUgxXK/smGHxegBQCG5LB4hglcN4+dU3MQuA2278Yk8FV/C
         zJD+WN1meWxiyvdfnM096m8zHmBR67pZbVP3dUEkS0Cly4H48EKpsEoIrArJ9j+uwUA1
         Calcm2ofYATK2FHCpZyVGANGiLDK6YzpDasqhIiBejl11kYzTG9NTyk6wd/yH2LPP26e
         wKphxl0dV5D4IDtU0jjUuhwZO/tPoy1gk79IyqpCxIqvNU3kVKxkiY93tmr7RTKuxM8/
         TiLw==
X-Gm-Message-State: ACrzQf3TlcVAvV/RpsgBXAO+5yD7E9/oAE4VIuas1QrCvb0TxOmwv+bA
        n8uz8/dzSZh4UHok7pdxAtw=
X-Google-Smtp-Source: AMsMyM6khNFTbzWgxwhh8jgTUnH6lQQjvLGeXk3EEj93bvvCcFw/YUwFWDmeGwRoamh6d0CAC0lr1w==
X-Received: by 2002:a63:e544:0:b0:462:2c80:f521 with SMTP id z4-20020a63e544000000b004622c80f521mr3477166pgj.549.1665737660835;
        Fri, 14 Oct 2022 01:54:20 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id m14-20020a17090a668e00b00203ab277966sm4538076pjj.7.2022.10.14.01.54.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Oct 2022 01:54:20 -0700 (PDT)
Message-ID: <a90c28df-eb54-f20a-13a5-9ee4172f870e@gmail.com>
Date:   Fri, 14 Oct 2022 16:54:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Subject: Re: [PATCH v3 1/3] KVM: x86/pmu: Stop adding speculative Intel GP
 PMCs that don't exist yet
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20220919091008.60695-1-likexu@tencent.com>
 <Y0CAHch5UR2Lp0tU@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y0CAHch5UR2Lp0tU@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/10/2022 3:38 am, Sean Christopherson wrote:
> Does this need Cc:stable@vger.kernel.org?  Or is this benign enough that we don't
> care?

Considering stable kernel may access IA32_OVERCLOCKING_STATUS as well,
cc stable list helps to remove the illusion of pmu msr scope for stable tree 
maintainers.

> 
> No need for a v4, the above nits can be handled when applying.

Thanks, so kind of you.

> 
>> Suggested-by: Jim Mattson<jmattson@google.com>
>> Signed-off-by: Like Xu<likexu@tencent.com>
>> Reviewed-by: Jim Mattson<jmattson@google.com>
>> ---
> In the future, please provide a cover letter even for trivial series, it helps
> (me at least) mentally organize patches.

Roger that.

> 
> Thanks!
> 
