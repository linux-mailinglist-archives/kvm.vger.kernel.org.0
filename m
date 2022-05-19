Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38F4C52D51E
	for <lists+kvm@lfdr.de>; Thu, 19 May 2022 15:53:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232608AbiESNwt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 May 2022 09:52:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239658AbiESNva (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 May 2022 09:51:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9611D3587E;
        Thu, 19 May 2022 06:50:51 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id n8so4876330plh.1;
        Thu, 19 May 2022 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=pKpFP9RGX9sn0Ig4M9NyUZOvPgJ7w1TiKhqL9WQm+0Q=;
        b=jcDYZfi759s5Mlu7jhgne/ZPbKHLfvvjfv6oJd+gHZ3g6OuiO+nPZTJfUSLFDzX/zW
         Rd55HQgTBfSGejtBMv+tWitvZoPNWz4m5+8QYr/iV1lOpQqSFHzWoNchEv0GPnJaUGY2
         C9ZyuQ4k/GMq6YCyUQ71k05QccqPR9JkB7V58r/Mk7x8IxYAAzliowzXiI61O3ytUm5/
         g8kAwPi1etRjB0pKorOjK999mBuWxnE00xztW0AV8grEZ/+71hU19i7raFNDjZb0F5Cn
         AwdY0hZcNVpQu6KGRvo73eJD7lM59+4QLk/NI+X7O6l/Qn1jNCl/nRy5pqspUvjT3XAv
         KRBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=pKpFP9RGX9sn0Ig4M9NyUZOvPgJ7w1TiKhqL9WQm+0Q=;
        b=eD3KcaqH0+AaqFwuxTjJjA6pQ3PpdrUR2JCMYzAdYvCjBR0FxmSoHyH4eeyt8jUtJd
         g/TJj5PpNxZ+CGcnBAaa/Aiks/3sKXuYzgsIDm1Xoh4Yg+0a9v2SG6ryWpD+f79CK334
         LFI27F8YowKohqcVbD9P2Rt5mQHLYROlGvx2FV2BEouOBtHB5PKr/zf8Rln6CTaZ5tsK
         6c0DziIjUtUlck4ZgK5dXDkNuBALVxYj9eS7wDUzsq5gBsQkVgOFzeEo5VM788Fu8k3F
         f5MOT/5Oq+W/BQNii2vjTSuzT+pE6Fy1im7k1XY2kfJwmKtrB5qxfaD0nAxBsg3Eyz9i
         qIzQ==
X-Gm-Message-State: AOAM531ZtSE9mxnGL4speKIskc1Ov8hNPY2dih2EEvwizubOLnSJfsoF
        qzX+6aI8rAP83o5MO7VHi2sI+TZLPIZhIQ==
X-Google-Smtp-Source: ABdhPJxVTxmk3s33tgplIYzlfkFACaXmVnGcM5PsTGgW557aQqH+WvVreHsA3E6F3i5Z2tSPG98iZA==
X-Received: by 2002:a17:902:b289:b0:161:df12:8b04 with SMTP id u9-20020a170902b28900b00161df128b04mr2670353plr.125.1652968226721;
        Thu, 19 May 2022 06:50:26 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.86])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a034b00b001cd4989ff62sm3449153pjf.41.2022.05.19.06.50.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 May 2022 06:50:26 -0700 (PDT)
Message-ID: <d7461fd4-f6ec-1a0b-6768-0008a3092add@gmail.com>
Date:   Thu, 19 May 2022 21:50:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH RESEND v12 00/17] KVM: x86/pmu: Add basic support to
 enable guest PEBS via DS
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>
References: <20220411101946.20262-1-likexu@tencent.com>
 <87fsl5u3bg.fsf@redhat.com> <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
In-Reply-To: <e0b96ebd-00ee-ead4-cf35-af910e847ada@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/5/2022 9:31 pm, Like Xu wrote:
> ==== Test Assertion Failure ====
>     lib/x86_64/processor.c:1207: r == nmsrs
>     pid=6702 tid=6702 errno=7 - Argument list too long
>        1    0x000000000040da11: vcpu_save_state at processor.c:1207 
> (discriminator 4)
>        2    0x00000000004024e5: main at state_test.c:209 (discriminator 6)
>        3    0x00007f9f48c2d55f: ?? ??:0
>        4    0x00007f9f48c2d60b: ?? ??:0
>        5    0x00000000004026d4: _start at ??:?
>     Unexpected result from KVM_GET_MSRS, r: 29 (failed MSR was 0x3f1)
> 
> I don't think any of these failing tests care about MSR_IA32_PEBS_ENABLE
> in particular, they're just trying to do KVM_GET_MSRS/KVM_SET_MSRS.

One of the lessons I learned here is that the members of msrs_to_save_all[]
are part of the KVM ABI. We don't add feature-related MSRs until the last
step of the KVM exposure feature (in this case, adding MSR_IA32_PEBS_ENABLE,
MSR_IA32_DS_AREA, MSR_PEBS_DATA_CFG to msrs_to_save_all[] should take
effect along with exposing the CPUID bits).

Awaiting a ruling from the core guardian on this part of the git-bisect deficiency.
