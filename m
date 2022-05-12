Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB76B52518D
	for <lists+kvm@lfdr.de>; Thu, 12 May 2022 17:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356097AbiELPrm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 May 2022 11:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356098AbiELPrj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 May 2022 11:47:39 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97C7354BDC;
        Thu, 12 May 2022 08:47:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ks9so11103858ejb.2;
        Thu, 12 May 2022 08:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P5aufxyg2ZFLSRWZ9cegNiz9UdTy7RurGMl808VFZD4=;
        b=Rfmjix0f5/MK3lzb3UOgFzoerzCubi7FLEETxbiNkjblhpVwKg7bnJ3i8Ngxa4sy8r
         0njzYZKl1KkYKBh3LvMpnvuyqWogx3JkX64kBvNynwMqVJ4gxoNVkoVDN3EXjgq/MJFA
         hrp3rsJFjALGV95+5d3fJeUMyFmuoEmnMViSVWSEd/opG+/npL7nThLuVnz5Eo7UFkf7
         xxJQ2pNTjce6V33BsRCcswktJl3N0f75GufkLaS25pXLznfhI7wbqudUDWuCuw8W4xDU
         hFZKX0zB65a0lmOYZET+Ckuvh/9vJM+n+NHsP3KmEOCVjEFfn4s7WX+bxpe1+7N+Bc87
         38Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P5aufxyg2ZFLSRWZ9cegNiz9UdTy7RurGMl808VFZD4=;
        b=fC8EjZepC+HwUVZukY1mqoaXnTJvbUkgq0auS82oWL9/FQX1zDVOr6WRcwJqvaWsot
         hC85Nyibrs8DI3uuRRfpl9Sa6+CpvgBOLuDAy7KFsNFL2AabY4hDUaIdGVmOk+xYH04s
         uDIUDikvXIgLQgJtvWMT+iqAv9iacqqK+agtaaVHlsohTA+/IFQQzUp1rX+G56qgkzd/
         DJxZiTn4FJGyKBJTRTunoMTuhbwDqzaZDJF+zgwKxkGaQQ5i0kENw8UqIKFOl1mfvQaQ
         Kr5aXeCT9sVTp0aiMMNs7jcGY1wfbTUzWbRCuDoBgxcYzR08v2QHHH5TDlLH8a9klES+
         ufNA==
X-Gm-Message-State: AOAM530CoE6gBjG1D9e0m7UXZEB2yGFL9DzJEU4VmBexavOgXcAjGYxz
        9posu6TXScgA9PVmlQIMJTE=
X-Google-Smtp-Source: ABdhPJwzuWBbAOAWsgxofgvDo2UMwcDDjh5OAFI+T8esSQqMW9WOJNL7/BvxyHxz4sFyOHYrBNmCfA==
X-Received: by 2002:a17:906:4fce:b0:6f4:f41c:3233 with SMTP id i14-20020a1709064fce00b006f4f41c3233mr456633ejw.117.1652370458179;
        Thu, 12 May 2022 08:47:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id jr3-20020a170906514300b006f4b2aab627sm2195926ejc.222.2022.05.12.08.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 08:47:37 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <87e16c11-d57b-92cd-c10b-21d855f475ef@redhat.com>
Date:   Thu, 12 May 2022 17:47:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] KVM: x86: fix a typo in __try_cmpxchg_user that caused
 cmpxchg to be not atomic
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Joerg Roedel <joro@8bytes.org>,
        Sean Christopherson <seanjc@google.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Jim Mattson <jmattson@google.com>, x86@kernel.org,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
References: <20220202004945.2540433-5-seanjc@google.com>
 <20220512101420.306759-1-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220512101420.306759-1-mlevitsk@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/12/22 12:14, Maxim Levitsky wrote:
> Yes, this is the root cause of the TDP mmu leak I was doing debug of in the last week.
> Non working cmpxchg on which TDP mmu relies makes it install two differnt shadow pages
> under same spte.

Awesome!  And queued, thanks.

Paolo
