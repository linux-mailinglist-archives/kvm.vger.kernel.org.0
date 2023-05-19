Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2091470918F
	for <lists+kvm@lfdr.de>; Fri, 19 May 2023 10:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbjESITj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 May 2023 04:19:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbjESITh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 May 2023 04:19:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E744012C;
        Fri, 19 May 2023 01:19:36 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id d9443c01a7336-1ae454844edso21910765ad.1;
        Fri, 19 May 2023 01:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684484376; x=1687076376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cBPTBQJcWgrD1ck85tj9B2uBPpRSLI2KXmbj8yOJQPY=;
        b=KuLJyU6hW58eytl8iY+ZnDCNBxula7ibr0UbUgsh+h4MAd0V7XUfBOrGhbcLaII8qr
         3kxz3SzkiCRc4G8LFxkJxizFOurvP6gkM38usO2exmF84H8nSxvFjq1d1sQWMoxZaIRb
         GBkkLZAdlXNo61/d8CQkKIpe5nHkEIMtDREObIz2C6kBDkxTnpWZULEp7CqnmfJeHKFf
         yFOKErP1+dS8SR+lcI27BYqHa2OO7u1Xd35bKO2b/1b8AgynxFQ/8HTKMwRiCvO8B4Mu
         FMumc45E/ewJLb1BSMn3SXTo3ogpYOcO9teEVAHzQZqp/EZu4Obv8/bPvIUO+SMyu5+m
         nTdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684484376; x=1687076376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cBPTBQJcWgrD1ck85tj9B2uBPpRSLI2KXmbj8yOJQPY=;
        b=C211nOSc5o7oS/OhA9M5a0mUw9Pkx7x99fx51hFtB84ESNQ3W2ZmFEaga7HcLGcPFY
         JCWOQBLHTq1kL0RcHlIFWQtib47obMWjg/e0GKnCnbOJ5OlSDrKUMOGHtK2sdWy711ob
         eBM27MzHPk7UF/vswRnyGBauIl0ohKKNdsNyXHxIU8fWGgutvPDR+umaM4a3ftZwKg8Y
         vL19dhJW9LDZpzVMtHyCYhY7roW4PgcL/vZLFHiQV0TiBwLBMUcnOa+toYuN76IXIscs
         HLa0CdIcpDL2ys+GesEOrU2ujnk6x9KYmSrpT0IpN0eJJr2lU3qWzIPs30EvQm6gaRUA
         7+pQ==
X-Gm-Message-State: AC+VfDy9YjHYhbWv3S+et71Deqznn8pHxxnW2DCAiDAWdnM/2uFy7psE
        9cYS4cL2JbOE6M3jAXyibIWDKm4aag4=
X-Google-Smtp-Source: ACHHUZ47olpGeP4NYofUMmsojjC4HPGjCkXAQts1zGDobaEvLHQRbRVqpQO6570VKS9gBn5qKL9zhw==
X-Received: by 2002:a17:902:f813:b0:1ae:48b2:3c2b with SMTP id ix19-20020a170902f81300b001ae48b23c2bmr1794928plb.30.1684484376320;
        Fri, 19 May 2023 01:19:36 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-39.three.co.id. [116.206.28.39])
        by smtp.gmail.com with ESMTPSA id a4-20020a1709027d8400b001ab12545508sm2827353plm.67.2023.05.19.01.19.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 May 2023 01:19:35 -0700 (PDT)
Message-ID: <68577e7d-a8ea-a3b5-4289-436a55e57f41@gmail.com>
Date:   Fri, 19 May 2023 15:19:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: Fwd: Persistent rt_sigreturn segfaults on KVM VMs after upgrade
 to 5.15
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Theodor Milkov <tm@del.bg>
References: <71288f04-546c-9af3-e29a-eb3c44e0d948@gmail.com>
 <babafe0f-3154-fb0a-346f-2bbea48a366e@gmail.com>
 <ZGY9twXBuTWpliAB@google.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <ZGY9twXBuTWpliAB@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/18/23 22:01, Sean Christopherson wrote:
> On Thu, May 18, 2023, Bagas Sanjaya wrote:
>> On 5/18/23 20:57, Bagas Sanjaya wrote:
>>> Hi,
>>>
>>> I notice a regression report on Bugzilla [1]. Quoting from it:
>>>
>>>> I'm experiencing sporadic but persistent segmentation faults on the KVM
>>>> VMs I manage. These faults began appearing after upgrading from Linux
>>>> Kernel 4.x to 5.15.59. I further upgraded to 5.15.91 and transitioned the
>>>> userspace from Debian 10 (buster) to Debian 11 (bullseye), yet the issues
>>>> persist. Notably, the libc has also changed in the process as seen in the
>>>> following error logs:
> 
> Was the host or guest kernel upgraded?  If the guest kernel was upgraded, it's
> unlikely, though still possible, that this is a KVM bug.
> 

The reporter [1] said that this regression occurs on guest kernel.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217457#c3

-- 
An old man doll... just what I always wanted! - Clara

