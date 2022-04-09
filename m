Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A3134FA192
	for <lists+kvm@lfdr.de>; Sat,  9 Apr 2022 04:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235630AbiDICOb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 8 Apr 2022 22:14:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231728AbiDICOa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 8 Apr 2022 22:14:30 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F02A0E10;
        Fri,  8 Apr 2022 19:12:23 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id n18so9423840plg.5;
        Fri, 08 Apr 2022 19:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=nK7BuI/Nd8JVLzwpjCS8lCeoKTexehkY0d3WwXKF09w=;
        b=VF39/a63kLpYR8kdjiE2ZnhyT8TnTcSLmSibW63ciww/YV5D31QEHz4l65kcjh+Qbp
         KqHFxTlZBRNoIueeez+L2e+bXdWxSpKP9A9tagAli9NwswXKnRCIZgIry5Rpp2Wm3aMj
         1NKKIISniOgD7/3KlZpr+shnG+MrJrYW8lOIklWJFYyONaN5bjhh+NWiGLjZhqmBlSq+
         enXi1EnZ3zfkH7B2YfXWW0OuwjLmJYG2uYWJc6NkyhhL3NWfPEaJXT6tF2BxGMY5rRLL
         r0bFPAG1N+H9OVkyjtytP70VvGcrmKZqwBGlEUni65ZeENP0VvpLsqSdSoXSIbxn/OWx
         WoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=nK7BuI/Nd8JVLzwpjCS8lCeoKTexehkY0d3WwXKF09w=;
        b=kiP2XI0+IaAxeTvelcf8CMPEt12wMlFqt9f3TGHmHasm5V+rKIVBgqp9V5gHw2c/a7
         7dbSXlQad5ZCPSS4f4Y2VD6NYfpn8HUMy6G3CfJTBTSR6rIRtwd7rO9D0qSoXa3t+9DP
         8vnbmyFJ2lwtNkdHIIZl00PVgxEdwS/t3PJDGuio9cjp32t1BGOq6e0CAs41iQict8im
         qSdF6TNeMT6w/wloYiW9fTGME3tgcs1Sd7iu2pRtXS+0gBgmVrQHcMe60exNIYhN/CcG
         5cyzhJrsXmNWrsJbZLy+xg4HiREVRMUo8LQmRjsOy1QLWl6qEH4R456d0iLZRAJ9/mmR
         v+vw==
X-Gm-Message-State: AOAM532zHE9AyqlVEUBsMJhy0VbztJDEYbMhtTlylL+s6q0AchQx3UGj
        e+XC+DJ7yPaRtu08eqoyy/UkkT2Wdq4=
X-Google-Smtp-Source: ABdhPJyzTzH+1nsTahkVGm7Vbx58pkC04PEoExOT1R7dhgcNlYBh/fQmh4uFUvIP2vZkvOlDR0s82g==
X-Received: by 2002:a17:902:9892:b0:158:1fe6:df65 with SMTP id s18-20020a170902989200b001581fe6df65mr5826342plp.85.1649470343533;
        Fri, 08 Apr 2022 19:12:23 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.114])
        by smtp.gmail.com with ESMTPSA id ca16-20020a056a00419000b004fdf8a00b64sm18157217pfb.176.2022.04.08.19.12.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 19:12:23 -0700 (PDT)
Message-ID: <e6c98dd1-5659-00c4-5567-045e64cb43f7@gmail.com>
Date:   Sat, 9 Apr 2022 10:12:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH 0/4] kvm: minor fixes and cleanups
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>, kvm list <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20220408163715.462096-1-pbonzini@redhat.com>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220408163715.462096-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/4/2022 12:37 am, Paolo Bonzini wrote:
> Queued, thanks.
> 
> Paolo
Sorry, my carelessness may bring the following warning from linux-next:

WARNING: From:/Signed-off-by: email address mismatch:
'From: Like Xu <like.xu.linux@gmail.com>' != 'Signed-off-by: Like Xu 
<likexu@tencent.com>'

Please let me know if we need to tweak out a better new version.

> 
> 
