Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8E5463D788
	for <lists+kvm@lfdr.de>; Wed, 30 Nov 2022 15:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbiK3OFa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 30 Nov 2022 09:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiK3OF1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 30 Nov 2022 09:05:27 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82667CAAD
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:05:12 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso1471705wme.5
        for <kvm@vger.kernel.org>; Wed, 30 Nov 2022 06:05:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=eNxxHpm2n+OH/EyW5l0fPtKv9Ooz5FbCEnr1nOb0dk8=;
        b=coY1jm/+7O79YMkeilvP23+krEH/VdhR8yDqz3saTFVvTEHrN2Pd30n26aOG8IL3mc
         kWXczAnERpGNcCY0uSJxaROyR6V87DcsSWwDctf2DFmR8Bic2TlI2NrkofzgcORYeHgU
         Xi7Flglvg5JQYj5xLclcO+XUOn+riEzy1wLvNo5NPM6n5BuTshtJ1Cbl5T0UbAdl5oK/
         4uwLO8AEkilp1gvUrqWzQVxztdO5Phi9nbY3GVDAoYX9+BwLhPK5Z4WrTDU2MIEp5AMn
         uX0meUhf0UucTSN3svn7QuIxu6dBJOVDx3LCbrdXZS9XhN17EYrQSx3FB8e+xdnx7mrh
         URQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eNxxHpm2n+OH/EyW5l0fPtKv9Ooz5FbCEnr1nOb0dk8=;
        b=EB+71TXZR9H1lLn3mD2MrIGkHCgVovmUvXjFm6eWLBTgvcReUPRaWNdH3dUaQhJjh9
         8D/5wG+cXRuY3Na2tdMNGO2INirxQtvRTDz0weyUHicuzr+hFZvzvyakfscnULQcnymP
         +6sdy737gURyfUj3ui2Zy9WTRMsPdnQdxr08Zf31eUuSe5mk3pKPivTwCWIioC7UYXgq
         xhbNQHiG+xBDjGNNNKgu2fKxAve4GSrCcmjX13KIuNdAKPSdoolIcr56Pg0U3KJbL0PX
         XD6Mhstpp9X+Q6J731dQ91/RmaczbxPhaxoq54LCHMMaSySJf+vh9dk+35F/G01GwjiS
         /OUA==
X-Gm-Message-State: ANoB5pmOoFS24KZt24/cMGRuz9gxBxOovhTVSql/+ozEKbhTXTi3n+tO
        eLzFK9+QH6YQImLJc5QTSc0=
X-Google-Smtp-Source: AA0mqf6Bxi4JZf/Lzlq8HLnh96uLC9Gjzh34yQEYoBvcAKa87P27kgbA2ssR1Bw9oGYK1p0eptVbaw==
X-Received: by 2002:a05:600c:1d08:b0:3cf:7556:a54f with SMTP id l8-20020a05600c1d0800b003cf7556a54fmr34530668wms.143.1669817110254;
        Wed, 30 Nov 2022 06:05:10 -0800 (PST)
Received: from [192.168.23.148] (54-240-197-233.amazon.com. [54.240.197.233])
        by smtp.gmail.com with ESMTPSA id fn7-20020a05600c688700b003c6b70a4d69sm1998668wmb.42.2022.11.30.06.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Nov 2022 06:05:09 -0800 (PST)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <fe8c0bdb-1045-55cb-2628-58b96de3cb83@xen.org>
Date:   Wed, 30 Nov 2022 14:05:09 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v1 1/2] KVM: x86/xen: Reconcile fast and slow paths for
 runstate update
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
References: <20221127122210.248427-1-dwmw2@infradead.org>
 <20221127122210.248427-2-dwmw2@infradead.org>
Organization: Xen Project
In-Reply-To: <20221127122210.248427-2-dwmw2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/11/2022 12:22, David Woodhouse wrote:
> From: David Woodhouse <dwmw@amazon.co.uk>
> 
> Instead of having a completely separate fast path for the case where the
> guest's runstate_info fits entirely in a page, recognise the similarity.
> 
> In both cases, the @update_bit pointer points to the byte containing the
> XEN_RUNSTATE_UPDATE flag directly in the guest, via one of the GPCs.
> 
> In both cases, the actual guest structure (compat or not) is built up
> from the fields in @vx, following preset pointers to the state and times
> fields. The only difference is whether those pointers point to the kernel
> stack (in the split case) or to guest memory directly via the GPC.
> 
> We can unify it by just setting the rs_state and rs_times pointers up
> accordingly for each case. Then the only real difference is that dual
> memcpy which can be made conditional, so the whole of that separate
> fast path can go away, disappearing into the slow path without actually
> doing the slow part.
> 
> Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>

Reviewed-by: Paul Durrant <paul@xen.org>

