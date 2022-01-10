Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6AE488EA9
	for <lists+kvm@lfdr.de>; Mon, 10 Jan 2022 03:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238199AbiAJC2Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 9 Jan 2022 21:28:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237004AbiAJC2Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 9 Jan 2022 21:28:24 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B343C06173F;
        Sun,  9 Jan 2022 18:28:24 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id v25so9938360pge.2;
        Sun, 09 Jan 2022 18:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Fhwafi9bQ+TDzwB2W2ndiRkZ9PEJnYw2z5PZNEdD7RE=;
        b=ewqGyM5Or6tw7RubrPY8DI/4lX/ZCj/5O+ezsIkxL8PUlrTaCL4i6ebiApkkh3fqfJ
         ipwl4QoWlZpb7/3BPNmPrX73yB16nIfGIYCDbgNSfVlRxqraiE663zNJYJ8Da2zgI9WH
         N281w+t24Pr5DR2J60Lfn8ygHhYlPihqZWvIiZd5jkxyUezgxYL4MXKTwGrA2zyHAD2P
         BAH4cItrDJztW7r4UitYyBGYX2+94QkqMrxA4JBa1f57oxE6Asu2/fALGRmE7xG5nutK
         sNZkEVVCkwNAjebLqMukvMf5px9PB5jA9YCarURfblZcJXY4f4rkJ97+JX8Q74Z3Y06G
         BjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Fhwafi9bQ+TDzwB2W2ndiRkZ9PEJnYw2z5PZNEdD7RE=;
        b=j5Vi1iLfjbRIwyliXisskV7/gM7aqg/+wEL5flpu3oX0LRfkSGb/jlNxSjMx8xucd5
         pcae09eEqOzlmqf1lCxU2J2cxwV5U/+GvRc6GQ3IcQcgy8GShMWDzUqc1x9EVeazbJew
         PB+4VW1gp4uechQSex+2LGXLXIJwZtssSoeVD35iJRuClfLz9kVXCDP1xtGSKCSnTc8K
         1btQIdZ2oCdZglrEHVIIVvKOwFwWLZcbEIU4UmNWXb3YCu8tgzveTbIYUcG47WGokJTn
         P3PbIlBnbUmIoDsgAfZxXSpjqf/UnTeVOcLymbRJl63phF+P8QjoNurq/ClX3BQKQvow
         pTLA==
X-Gm-Message-State: AOAM531KWyDiZz5I7yIafutTveVSUv5RACihmeT1hxZxex2jYU0pAd58
        4lNMP1Pa//46WkLILjm33W0=
X-Google-Smtp-Source: ABdhPJzyt+qrQJqjvogHkAyHikJf20I4GUCSQWuNJiQ5FZBAJmzqEkNuYrNN0QH6FeJdmQFnE7Yq/Q==
X-Received: by 2002:a05:6a00:2484:b0:4bf:328f:3f07 with SMTP id c4-20020a056a00248400b004bf328f3f07mr442655pfv.86.1641781703766;
        Sun, 09 Jan 2022 18:28:23 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id w5sm4734941pfu.214.2022.01.09.18.28.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 09 Jan 2022 18:28:23 -0800 (PST)
Message-ID: <935a60a0-4197-54a1-8365-08556779e8f3@gmail.com>
Date:   Mon, 10 Jan 2022 10:28:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: linux-next: manual merge of the kvm tree with the tip tree
Content-Language: en-US
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Like Xu <like.xu@linux.intel.com>, Like Xu <likexu@tencent.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        KVM <kvm@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20220110131642.75375b09@canb.auug.org.au>
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220110131642.75375b09@canb.auug.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/1/2022 10:16 am, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the kvm tree got a conflict in:
> 
>    arch/x86/kvm/pmu.c
> 
> between commits:
> 
>    b9f5621c9547 ("perf/core: Rework guest callbacks to prepare for static_call support")
>    73cd107b9685 ("KVM: x86: Drop current_vcpu for kvm_running_vcpu + kvm_arch_vcpu variable")
> 
> from the tip tree and commit:
> 
>    40ccb96d5483 ("KVM: x86/pmu: Add pmc->intr to refactor kvm_perf_overflow{_intr}()")
> 
> from the kvm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
> 

The fix looks good to me. Thank you and please move on.
