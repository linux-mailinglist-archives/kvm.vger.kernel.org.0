Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 650046227A3
	for <lists+kvm@lfdr.de>; Wed,  9 Nov 2022 10:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230349AbiKIJyx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Nov 2022 04:54:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbiKIJyw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Nov 2022 04:54:52 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1159212AA3;
        Wed,  9 Nov 2022 01:54:52 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id l2so16587104pld.13;
        Wed, 09 Nov 2022 01:54:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/cF+nTzbb4wXr9g33DZh2lEIuIBdaVgjNRVTwUh5ZHs=;
        b=B787PQLzOG1LeL2qbIzTcmWnwI3mpl+19MZBxrf/Wlwmw8WLzJCcmqBQRSmnKOdxi/
         +0A270SZGa3GnT+XZsfvBtVfjvQRvxFfY3iOzXb5L6KtJhQp0OnA979xe1e7Cx0wkX1o
         fv/OfBW0iiojTf4WZcxhHdrytlIUh+UMX8xwPQUcpmSa7AR2RSJ+I+K5w0MzPWqNpCVL
         0CNWJmNVpXUCe/fqBarhuyI+kL9mbef6Z1EFqoGfAbCIwsgpGyKZQZEn1FT4Bi/uaHjp
         hHRufTm83qeT6roFy2oPfH0mPfn++JGaN7mg7W+YhZqxmfajEBBJaIDK4HfmOio8GPXI
         bm6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/cF+nTzbb4wXr9g33DZh2lEIuIBdaVgjNRVTwUh5ZHs=;
        b=GdQUvOAdY5RYWRPxKVfj/ySHpcI3inNDnSE7+1kPMAjd0bb/sUt+7cRTH1W+j9keYM
         zp2sGxQHey2SIiSx7HdwbO79y98a3KwAL95U8zoXbya53WI0jIgyr6PhvsJyw7WOUQDl
         K5Auc4ixwaRgE+ETqrZme/7VzJl8Hxs1HvqsjefkASb73B40y8uH2dHZG5t6beTrYJZx
         pZcxoAK24wnVBPSMGgk9nhpd/MUOrpPGtPsp6julFlSSCCk1q0TaHTxEB0WCzSKXhKp1
         tm/xudzEnzw6SG/cLGsUVGvplMvAcqYRhXRsUzm9zNrwgleRmR89auOSZ3kXXSK2YP9S
         qaDQ==
X-Gm-Message-State: ACrzQf0CStpeS0zK+CaPEPSfx81cXX5MRKAKXFt+24B6pz8YrGuZTwUH
        mnN2gQ4cfPpSLZm0d4T1nHE=
X-Google-Smtp-Source: AMsMyM6mBGlSUF5xtUZjtXcwFjs9dxOMVlkWWB6u4O9fc5uhqOGbKrb5T2NAc+6QfozGp1BtAAj/9g==
X-Received: by 2002:a17:902:834c:b0:187:49e0:fd4d with SMTP id z12-20020a170902834c00b0018749e0fd4dmr37691344pln.81.1667987691567;
        Wed, 09 Nov 2022 01:54:51 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id i16-20020a632210000000b0043a18cef977sm7073412pgi.13.2022.11.09.01.54.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 01:54:50 -0800 (PST)
Message-ID: <107f4040-e4cd-82df-01bc-f0d6a22be053@gmail.com>
Date:   Wed, 9 Nov 2022 17:54:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH v2 2/3] KVM: x86/svm/pmu: Add AMD PerfMonV2 support
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220919093453.71737-1-likexu@tencent.com>
 <20220919093453.71737-3-likexu@tencent.com> <Y1sKf/PgwHwtAibK@google.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <Y1sKf/PgwHwtAibK@google.com>
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

On 28/10/2022 6:47 am, Sean Christopherson wrote:
> What happens if userspace sets X86_FEATURE_PERFCTR_CORE when its not supported?
> E.g. will KVM be coerced into taking a #GP on a non-existent counter?

I'm getting a bit tired of this generic issue, what does KVM need to do when the 
KVM user space
sets a capability that KVM doesn't support (like cpuid). Should it change the 
guest cpuid audibly
or silently ? Should it report an error when the guest uses this unsupported 
capability at run time,
or should it just let the KVM report an error when user space setting the cpuid ?

For vPMU, I may prefer to report an error when setting the vpmu capability (via 
cpuid or perf_cap).

Please let me know what you think and make it law as an example to others.

Thanks,
Like Xu
