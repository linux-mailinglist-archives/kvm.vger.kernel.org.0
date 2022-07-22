Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F6F57E5AB
	for <lists+kvm@lfdr.de>; Fri, 22 Jul 2022 19:34:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbiGVReL (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Jul 2022 13:34:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235065AbiGVReK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Jul 2022 13:34:10 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A108CEB2;
        Fri, 22 Jul 2022 10:34:09 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id t3so6715747edd.0;
        Fri, 22 Jul 2022 10:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G8wV1o9o6SN/p0PWSM9C28UoTIzC1ku8DpyZxiwFv3E=;
        b=X1aBufQJAIrSZNSx8ZHnnf+MXDY0THmUHcFObNk2PcKLW1PP13HzP1mxHbhBd6SJJW
         nHx/qsfrIbMODP1dr2PIjaFbCL7F7jg08WqhzblKtiqSYvM5AcMypYvowfdxenvOJRtS
         5RPnB1wgCoW2PSr7mJvUQSE2URnPC7fiE2/0kXQkJnc/AEbP/jNMfx9cpaxz07mYJhbU
         72szGkVHcZebY3DK1UrICbm2MqBi3TZqo4RDtKD2Ja4t7+sc3NnNRyGzPNqTlFK9e4VG
         uMgJkLhsQqofYFjbsIGGNE6vc05wvFwh/C9D8gwC5na5ySDxU8J/kODmmEZyVv8TtlPq
         GKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=G8wV1o9o6SN/p0PWSM9C28UoTIzC1ku8DpyZxiwFv3E=;
        b=14BwcQooIM7bwqofvmfNcmsHEBXY2Y8M7WdFOngER/96bHBIHR8aM07hQq2LyMkQZ6
         h97ZDL93Lmstefk4O5X4bOvZm3qg6sPgcSTkKv/QzC7RGTRqXUOTCvUAcHrDpuoibHr4
         PPILV+iZbQxd4KtG4xnAoZsmuh1Mn4N745owvQMY3mLBDzzbSomEEW/Kr3CMq3xK8NE+
         0ic54tORjIJDpatgBUHeySA+ZZ8OiDzFUzl7ujwdNlOh1XdbP8eE2cykfMKHrr3p6NYW
         mSEHIsxa72z+T7XPZlpEzImTtixu0MvHtRfXmAOBs4IPF0CU9se2xug1ocgBAiFKUA4e
         0h3g==
X-Gm-Message-State: AJIora9B3dS0bhKh7mZAi/1pk7sxqTbU9gnxVsqnf6IY+eFYe8jQMcM4
        tcmnF13v/u70DGf0frD4dAY=
X-Google-Smtp-Source: AGRyM1vb2Aa2MfX5JDtVJrsdGpFw+uv9M6/mUx8CIXnfLz7uKg9KNU2nM8HATusYDlxB76zAPjRa5w==
X-Received: by 2002:a05:6402:529a:b0:43b:b8e4:fca5 with SMTP id en26-20020a056402529a00b0043bb8e4fca5mr978244edb.344.1658511247874;
        Fri, 22 Jul 2022 10:34:07 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id j16-20020a50ed10000000b0043ab36d6019sm2842711eds.9.2022.07.22.10.34.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jul 2022 10:34:07 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <860ea999-76c3-9ffe-054c-2f88bb914a56@redhat.com>
Date:   Fri, 22 Jul 2022 19:34:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] Revert "KVM: nVMX: Do not expose MPX VMX controls when
 guest MPX disabled"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        oliver.upton@linux.dev
References: <20220722104329.3265411-1-pbonzini@redhat.com>
 <YtrB8JEuc1Il1EOO@google.com>
 <0f8dde12-576b-1579-38c9-496306aeeb81@redhat.com>
 <YtrdJWmk/2RkcQi7@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YtrdJWmk/2RkcQi7@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 7/22/22 19:23, Sean Christopherson wrote:
> Can you drop the PERF_GLOBAL_CTRL revert?  I figured out how to achieve what you
> intended, but in a more robust (and IMO more logical) manner.
> 
> If you don't drop it before I concoct the series, I'll just include a throwaway
> patch to revert it.

I didn't drop it in the end (pushed before reading this), but it's 
intended to be temporary and I'll of course drop it if your series 
supersedes it instead of building upon it.

You don't need to include the revert but you can also do that if you prefer.

Paolo
