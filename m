Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0228358FD66
	for <lists+kvm@lfdr.de>; Thu, 11 Aug 2022 15:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiHKNas (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 09:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235451AbiHKNam (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 09:30:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A69E6C109;
        Thu, 11 Aug 2022 06:30:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f30so16114612pfq.4;
        Thu, 11 Aug 2022 06:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=01vDtU88eCW5oD/3dn74II/8dGaHIJjwfRBEKULz+Ko=;
        b=WizdRfX4kJ9hcmdF4NeLaiTx+zNIwoHMN9U88yYQD2WZ0SX7p0018GcFFdSEAVZA/T
         0RvjX3ePnH4gHEGue+d2o9tmGuYhiN8xaQ/ACOi4ktNRzu+7twhaDm/g5EOmi83dyvXs
         qjR04olAmCHCZ54kngN3gIXK7TeJOzf6luHUinxGojbie0ixEiCCjOhpxkkufkuMzZZy
         JE0FtSvN2+nplqnNMf8fX2YIyz6r0IUc3j/3fEI7UhMdiWr9HpVsvU4+ufAXHB2SerRR
         dUsfea858QiBjWVqX51OZ0bRCsdhxYzKxnWGESIb2ar+ozMbCWVbcXP3rKB20jLhMdas
         9jnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=01vDtU88eCW5oD/3dn74II/8dGaHIJjwfRBEKULz+Ko=;
        b=ATzcaYI/Ai5Kkxq9AZWRrmXc75OuNhitG60oTqvQDIM4+wnaQKvFufg+6TwA3qEPQ7
         QhmK7O44wBDcwjX9cn+n13jD6FaUZ5FjE7hF1dzA2DH8j08Dglh8MkNz8vr0si/vPuOE
         CaeLkn4RjdcDdO43zdTqHpe0+R9pzJ4ASKsdrV9obmxAyo1ciYrGtf/lfd6/uy0qcJfz
         R6tV18yhJCmDCo426F5vLKqGGoE7oUsLTbEtXkfm7kjA3l3paVu1B+RLpMP9ZzjNfRSH
         giveSd8Tk1325p0yw+F1KE2yeyJP4LbXfN1S+HYScPy0h+658B7iYPnLivt4HMDP955H
         uvlQ==
X-Gm-Message-State: ACgBeo2z83hdb+Z3hRt9xEAe1zjvZH20pF8Wp0xKJ1WjSzwryC0XDEdO
        vN0+XWoeT1UkxI0BbIzTbMQ=
X-Google-Smtp-Source: AA6agR7RqRgGF7gnHBdcw3opMUr1MxD/qxKr4atILgFzBkbhrCw1horw85HYBR1is/Y0dbIQzLHz+A==
X-Received: by 2002:aa7:88c4:0:b0:52f:755c:a354 with SMTP id k4-20020aa788c4000000b0052f755ca354mr15639081pff.81.1660224640865;
        Thu, 11 Aug 2022 06:30:40 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-16.three.co.id. [116.206.28.16])
        by smtp.gmail.com with ESMTPSA id p2-20020a170902780200b00170d34cf7f3sm6563336pll.257.2022.08.11.06.30.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Aug 2022 06:30:40 -0700 (PDT)
Message-ID: <1db2a0cd-bef1-213c-a411-3d39d378743a@gmail.com>
Date:   Thu, 11 Aug 2022 20:30:36 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH next 0/2] Documentation: KVM:
 KVM_CAP_VM_DISABLE_NX_HUGE_PAGES documentation fixes
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Matlack <dmatlack@google.com>,
        Ben Gardon <bgardon@google.com>, Peter Xu <peterx@redhat.com>,
        kvm@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220811063601.195105-1-pbonzini@redhat.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220811063601.195105-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/11/22 13:36, Paolo Bonzini wrote:
> Queued, thanks.
> 
> Paolo
> 
> 

Thanks for picking this up. However, Stephen noted that the issue is
already showed up on mainline [1]. Maybe this series should be queued
for 6.0 release (as -rc fixes), right?

[1]: https://lore.kernel.org/linux-next/20220809164147.131f87d0@canb.auug.org.au/

-- 
An old man doll... just what I always wanted! - Clara
