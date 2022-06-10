Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49E31545B62
	for <lists+kvm@lfdr.de>; Fri, 10 Jun 2022 06:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238858AbiFJE4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jun 2022 00:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiFJE4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jun 2022 00:56:46 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 605531ABF94
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 21:56:44 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gd1so23124323pjb.2
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 21:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=wWjtS385ZKQca2fjL2X4GDJv94vUWqUo8oxBcA17Ies=;
        b=gtNaxGcrVWIEuUSDw+7YizT9InDhgtV0YWzTxToR6qrnPi2m+QTVqyYQkXrU4mjFcZ
         PF9v0Ocz57khVnS9m25ojEANjXCXe754sf6z78iUlOGI5k8aOL9pewPuVwW4dVyCxn70
         n/cR5JJQ86ca04ShNRF3eTheKK4ApTJ9uIUiA+6Ml6CcttIWco340JJ1M0cbtzQ7jQyw
         Nu5x0QTypgeDZDZmyr8QVIo7q2mnd269pu8UNG89z/LwuAgqCefU183fMcj2QG8OWcOL
         xJOs42J+Kx798Sve3YJ8JUy39gBY4PX/st6CoUXdPfoSHraAuHCxkq4pvQo1NGzBJkDY
         lZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wWjtS385ZKQca2fjL2X4GDJv94vUWqUo8oxBcA17Ies=;
        b=RIK5Fkkz2fqh5aQPUtYLeMU3mXwicdPHaVDwkHPAdci/AnS7S80ckM8pqX+Lg7VCBv
         s5NcLhYQDGuDij65vDH9jorc0Cog0ZAieePwr/M1vKx0GLTSNIii3eSWAnp0PM+G6l52
         gRLCMtKoyTXRjMQOIAwuzPnf6jzLwn18l7dzqXGx3VK0fKz8QZ7KTWehiqJSOriF0ZSY
         Qs4jw1WJeAIlW1cBU9E4IYxLOh5qWwiIQpPygiv3cwoWD0weGbi2W6jp6O4X2V5iuOVq
         wsA6xWlfyxGpUaUetVlXpoRaJwb65Pho92pF70pn7/8vZInZ5/NO0cq/K1DRxMcvuB0/
         E7Aw==
X-Gm-Message-State: AOAM531qsBRLjiR5CoQqQjglGAPyd2tmwebVWy0/e1ILvVVy7vN4IwkR
        OI73gOklZ7vkaK0duluuEJE=
X-Google-Smtp-Source: ABdhPJzfaznNqpjJenRj8K6+LfT+W9IUkHfnjgg+CsF7BP8rn7xIwWjXJ8DGco3s2PpX5u/KFSQQhg==
X-Received: by 2002:a17:902:ea0c:b0:163:ed09:9e5f with SMTP id s12-20020a170902ea0c00b00163ed099e5fmr43126571plg.86.1654837003910;
        Thu, 09 Jun 2022 21:56:43 -0700 (PDT)
Received: from [192.168.255.10] ([203.205.141.21])
        by smtp.gmail.com with ESMTPSA id l5-20020a17090a4d4500b001e0b971196csm597604pjh.57.2022.06.09.21.56.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 21:56:43 -0700 (PDT)
Message-ID: <a77e6ccf-e694-b71d-b4e6-fa851459382c@gmail.com>
Date:   Fri, 10 Jun 2022 12:56:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [kvm-unit-tests PATCH 3/3] x86: Skip perf related tests when pmu
 is disabled
Content-Language: en-US
To:     Jim Mattson <jmattson@google.com>,
        "Yang, Weijiang" <weijiang.yang@intel.com>
Cc:     kvm@vger.kernel.org,
        "Paolo Bonzini - Distinguished Engineer (kernel-recipes.org) (KVM HoF)" 
        <pbonzini@redhat.com>
References: <20220609083916.36658-1-weijiang.yang@intel.com>
 <20220609083916.36658-4-weijiang.yang@intel.com>
 <587f8bc5-76fc-6cd7-d3d7-3a712c3f1274@gmail.com>
 <987d8a3d-19ef-094d-5c0e-007133362c30@intel.com>
 <CALMp9eT4JD-jTwOmpsayqZvheh4BvWB2aUiRAGsxNT145En6xg@mail.gmail.com>
 <ddff538b-81c4-6d96-bda8-6f614f1304fa@gmail.com>
 <CALMp9eQL1YmS+Ysn7ZPQjcha6HoqALNVTBqTLO7iTFpZMgyUAg@mail.gmail.com>
 <CALMp9eRO0K7L=OtoE4MWok6_7cy0DX5FyjPw6Sv83cZBCws0AQ@mail.gmail.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <CALMp9eRO0K7L=OtoE4MWok6_7cy0DX5FyjPw6Sv83cZBCws0AQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/6/2022 12:22 pm, Jim Mattson wrote:
> On Thu, Jun 9, 2022 at 9:16 PM Jim Mattson <jmattson@google.com> wrote:
>>
>> On Thu, Jun 9, 2022 at 7:49 PM Like Xu <like.xu.linux@gmail.com> wrote:
>>
>>> RDPMC Intel Operation:
> 
> Actually, the key phrase is also present in the pseudocode you quoted:
> 
>>> MSCB = Most Significant Counter Bit (* Model-specific *)
>>> IF (((CR4.PCE = 1) or (CPL = 0) or (CR0.PE = 0)) and (ECX indicates a supported
>>> counter))
>   ...
> 
> The final conjunct in that condition is false under KVM when
> !enable_pmu, because there are no supported counters.

Uh, I have lifted a stone and smashed my own feet.

Please move on with #GP expectation.
