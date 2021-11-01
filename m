Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C30A544143B
	for <lists+kvm@lfdr.de>; Mon,  1 Nov 2021 08:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhKAHhn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Nov 2021 03:37:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:27102 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229933AbhKAHhl (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 1 Nov 2021 03:37:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635752107;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MNOma4vvxOloGXSLAi/odyhSzFceBTNSQSy0m1G0aB4=;
        b=Pt7BFcARxhNj2lnwcQrKflgIJQb4RY9uDRl2kRD+Oh5NvRarz0hUaUIJrXZgCmlnuIv9yY
        PqwBWy8NGHPFE1YorZJRicfR/JW0B1LQWYPwr+O0/DEchtWcrTLrP9Kja9MMznswXM7uWo
        tIAiBbLLEkl0/nzcX30ZRWon0IW0Bms=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-170-9U7AFNeCOPuSszgyYVuwwQ-1; Mon, 01 Nov 2021 03:35:06 -0400
X-MC-Unique: 9U7AFNeCOPuSszgyYVuwwQ-1
Received: by mail-ed1-f71.google.com with SMTP id h16-20020a05640250d000b003dd8167857aso14812105edb.0
        for <kvm@vger.kernel.org>; Mon, 01 Nov 2021 00:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MNOma4vvxOloGXSLAi/odyhSzFceBTNSQSy0m1G0aB4=;
        b=aaNGdkarKluk8Vku14mBjhA7x7Wqr8vBUj1gI1Wg3ZGLQs84t5QKCJ7XPG9MqN93xi
         O6KuQ5OrB/jVwggyJxTuX1w1Le4AjJVC0h4lRhonQ5kR9114g1oXbtzjTPpOShZZosiC
         jTBOhyCUHSzg9gbwCQ4of9zSml4BHEDA+33xCBQvgzzimKzRkfj1GWckdhCDp1qsKF37
         ksz2VSqMZsz1WTRLfjwhBJv/bvd4y6GZVi+fy4l6CXliLhaXGMkHUMN6AbiQGHtK1nmb
         27kUSRVUn24soM4O2CNavM+7tWZNupAJqCdbwyCpB0f78NBCwyk5KVyfHsP4iT+Nb8zl
         73cg==
X-Gm-Message-State: AOAM531oSOsSZhD/Sfbvl0prtVfTEmJK/x4zX4Zrfi+Xa7thU/NzJVGz
        OiYdb2uJCFVLMM/ur3I6L8KS7Lqk9TBwnCOZRgflXyPo0RnBD9ATRob1n7ZOleTGCfzIkGwNKHl
        2EC/bFpx77hpc
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr10233042edb.90.1635752105317;
        Mon, 01 Nov 2021 00:35:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIfdjCEKMp5soaUmg+1D8Y4IDiZmwS57fopx7EfX9mPmKtdHfySPC2hyvBM6GSLEzwsT841Q==
X-Received: by 2002:a05:6402:2552:: with SMTP id l18mr10233020edb.90.1635752105153;
        Mon, 01 Nov 2021 00:35:05 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id u9sm8776403edf.47.2021.11.01.00.35.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 00:35:04 -0700 (PDT)
Message-ID: <25f5228e-3ea1-1695-9615-899b24f46962@redhat.com>
Date:   Mon, 1 Nov 2021 08:35:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL 00/17] KVM: s390: Fixes and Features for 5.16
Content-Language: en-US
To:     Christian Borntraeger <borntraeger@de.ibm.com>
Cc:     KVM <kvm@vger.kernel.org>, Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@redhat.com>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
References: <20211031121104.14764-1-borntraeger@de.ibm.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211031121104.14764-1-borntraeger@de.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 31/10/21 13:10, Christian Borntraeger wrote:
> Paolo,
> 
> sorry for late pull request, I was moving...
> This is on top of kvm-s390-master-5.15-2 but for next.
> FWIW, it seems that you have not pulled kvm-s390-master-5.15-2 yet, so
> depending on 5.15-rc8 or not the fixes can also go via this pull
> request.
> 
> The following changes since commit 0e9ff65f455dfd0a8aea5e7843678ab6fe097e21:
> 
>    KVM: s390: preserve deliverable_mask in __airqs_kick_single_vcpu (2021-10-20 13:03:04 +0200)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvms390/linux.git  tags/kvm-s390-next-5.16-1
> 
> for you to fetch changes up to 3fd8417f2c728d810a3b26d7e2008012ffb7fd01:
> 
>    KVM: s390: add debug statement for diag 318 CPNC data (2021-10-27 07:55:53 +0200)

Pulled both, thanks!

Paolo

