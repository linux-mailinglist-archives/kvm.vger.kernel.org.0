Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63C065BA9E0
	for <lists+kvm@lfdr.de>; Fri, 16 Sep 2022 12:03:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbiIPKDC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Sep 2022 06:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbiIPKDA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Sep 2022 06:03:00 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CF4AB068;
        Fri, 16 Sep 2022 03:02:59 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id bu5-20020a17090aee4500b00202e9ca2182so1379154pjb.0;
        Fri, 16 Sep 2022 03:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=0kJO6sKHhZWzWtdjnIjVe92KBA3BK4LC3Mn37i7AeX8=;
        b=p5dgLW1X5KELWDXXhAUsrm4m15zadrqj1lyXqbaHgTHEBaqIdsDIec/ASw4PWaCLzl
         mRjUyPTXf9AwsWy7oc5NgLkSWi6Dd3HtNffTrp7d5AliYRbkhLcw0VhDwwVLpAEWpXhy
         iDjvoyKXUkLoE22LpTkZAjFSO+uKgW0r6Q/qAVrCZ3tcnDowlFuNnj+mj4Dldy6u5Qbq
         L1G8HUVCFy7D4Ns/7lnc2iRPilklPtqB1G7czENDScgqa/OdvWBAaaA1QHq0Dm81TKpg
         mxXD0gAKH66fFzTIuniSjdogWnFvMC5fwBxwFJZjDzlQy8s6NBTvc2uEUwA+1QT/SzBs
         NzjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=0kJO6sKHhZWzWtdjnIjVe92KBA3BK4LC3Mn37i7AeX8=;
        b=A8U+CYaODHKnhfEG3rfseHhPi76od6TP276qBtI1YBsvZ7d5TdxYhu14bW1XTfM7T+
         ovJX2BlH7LE8Ztb1Tk8FoW1zdTqqpahOSRgBbDkuluAB01kyQ0IDf+DoInlnuUR0tjkF
         iVcNyQ/4OZIbFMCw1lXTqPqtkbjFu7Z60H0Ewfj1Z8D8XFv3J9eXYHzgrz+lXhHci3dq
         2B36vatFsMzLrbwrAErjSciXPxTzKnMqnEN5W33n2edWtUicExhxJ1Wo1Z0hbuJ00kEX
         2I/T5KBjvF5Bj/wXjdaogMG7CXsIQQVXSVDOM0K8+AP90BnNNObJhRZXnVRIGA2oGJ8w
         4eVg==
X-Gm-Message-State: ACrzQf1GZ0dFuHZTBGMwWh1HzutSf+kCC2haXDBpWOuHaYBFLDhavJuB
        QOBZJhlFWeA+nVxRYNPIjlU=
X-Google-Smtp-Source: AMsMyM7k8Y3tBuvK67O01/8DM9XrV7JgALu+SPeEXJUUjRgAjamHbiu7z9m6S031Kj6gZJHX3OmfKA==
X-Received: by 2002:a17:90b:2496:b0:1ef:a94:7048 with SMTP id nt22-20020a17090b249600b001ef0a947048mr4688475pjb.244.1663322579130;
        Fri, 16 Sep 2022 03:02:59 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id y1-20020aa79421000000b00537daf64e8esm14094571pfo.188.2022.09.16.03.02.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Sep 2022 03:02:58 -0700 (PDT)
Message-ID: <08cd7add-b2a5-da3f-1d2c-efa0e7c80511@gmail.com>
Date:   Fri, 16 Sep 2022 18:02:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.2.2
Subject: Re: [PATCH] selftests: kvm: Fix a compile error in
 selftests/kvm/rseq_test.c
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Liam Merwick <liam.merwick@oracle.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jinrong Liang <cloudliang@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220802071240.84626-1-cloudliang@tencent.com>
 <YxjAZOGF9uSE2+AT@google.com>
 <fdfb143a-45c4-aaff-aa95-d20c076ff555@oracle.com>
From:   JinrongLiang <ljr.kernel@gmail.com>
In-Reply-To: <fdfb143a-45c4-aaff-aa95-d20c076ff555@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 2022/9/8 00:54, Liam Merwick wrote:
> On 07/09/2022 17:01, Sean Christopherson wrote:
>> On Tue, Aug 02, 2022, Jinrong Liang wrote:
>>> From: Jinrong Liang <cloudliang@tencent.com>
>>>
>>> The following warning appears when executing:
>>>     make -C tools/testing/selftests/kvm
>>>
>>> rseq_test.c: In function ‘main’:
>>> rseq_test.c:237:33: warning: implicit declaration of function 
>>> ‘gettid’; did you mean ‘getgid’? [-Wimplicit-function-declaration]
>>>            (void *)(unsigned long)gettid());
>>>                                   ^~~~~~
>>>                                   getgid
>>> /usr/bin/ld: /tmp/ccr5mMko.o: in function `main':
>>> ../kvm/tools/testing/selftests/kvm/rseq_test.c:237: undefined 
>>> reference to `gettid'
>>> collect2: error: ld returned 1 exit status
>>> make: *** [../lib.mk:173: 
>>> ../kvm/tools/testing/selftests/kvm/rseq_test] Error 1
>>>
>>> Use the more compatible syscall(SYS_gettid) instead of gettid() to 
>>> fix it.
>>> More subsequent reuse may cause it to be wrapped in a lib file.
>>>
>>> Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
>>> ---
>>
>> Reviewed-by: Sean Christopherson <seanjc@google.com>
>>
> 
> Can a 'Cc: stable@vger.kernel.org' be added also as e923b0537d28 got 
> backported to v5.15.58
> 
> Reviewed-by: Liam Merwick <liam.merwick@oracle.com>
> 
> 
>>
>> Paolo, do you want to grab this for 6.0?  It doesn't look like we're 
>> going to have
>> a more elegant solution anytime soon...
> 
Ping?
