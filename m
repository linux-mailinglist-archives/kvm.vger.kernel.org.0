Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33FB46908D
	for <lists+kvm@lfdr.de>; Mon,  6 Dec 2021 07:55:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238108AbhLFG6x (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 6 Dec 2021 01:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231181AbhLFG6x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 6 Dec 2021 01:58:53 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7510C0613F8;
        Sun,  5 Dec 2021 22:55:24 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id x15so38933217edv.1;
        Sun, 05 Dec 2021 22:55:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o9/QtGK9oR+PrbKeE9O4NaKGRuklRnvYi5sQipG8Enc=;
        b=d6IND9OTMwwK50ar0cFqieEXuAWqFDOjyT4zVU1m7cKjMdYwZxA8jeXxZCySLM9vZX
         smZ3ygaYolkzkTSSuPtY512CN/k8I4UrZQeer7nHJc1GACuZAjuBqsFXlU0Btaz2MvhB
         2E38s1yMnK7t6gKj2qm19als4cKUbY4+TacDRzrQ2K7BkI7aWIQm26Vp4OVqb1qT4eSx
         wewmqb6sbk64O0kH1qahQFNhga8r3z9DDY+nGaYKVYhYEGXyz72DpUuHe5FhyDWL63Bt
         5xHWLtABvwfAoP3zltTS9pZbzOmYMcd6lgiI9/lXa/NPO5/U2GV4sPMQRE+GvcJqr689
         +jSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=o9/QtGK9oR+PrbKeE9O4NaKGRuklRnvYi5sQipG8Enc=;
        b=3dz6jSyBB3E5XqfGaZRCPfbmIsiWoYhnmvDHqIzxcu+B4CmX6ByhzRRaoOB0dRwL0e
         0pui6EsY198ZlIwyzWmXJs3dnFzranUZxwio7VzCgT/Z9AuRbL5XhOWzWJ3EDIRBraGp
         lH3k4RYcoN+sCOfC2V+7tJj8eVa3q4qme+UXGktuWwFuxaCDUMn14v76hB/tlzUs1SMh
         us65E++mHpL2RZ/gbbZfHHwGssmcwsm5XGF/3CfXBNhsIU9q6A8Emj3/w1+O5L2FpdME
         8iu5zUiRvJdjIJUVBQ2ziGD/LmQyywRgdVzEyfrkzo7nULsD5yJlZ0N/WijUYRA95ThM
         rweg==
X-Gm-Message-State: AOAM531RvENt2QusX8orTgNakFkXyaRrswLutY1uNl+F66wa6uG1gD30
        8TgDppb23AbvndkCA3Rw1pM=
X-Google-Smtp-Source: ABdhPJwYqKZmlCWEZj0I93ny3t+QY6z5iqs2bFYfD74gFkyEWa9hwKRH/foduwTPpflNmOjjj1BuBA==
X-Received: by 2002:a17:907:3e8a:: with SMTP id hs10mr42611615ejc.58.1638773723166;
        Sun, 05 Dec 2021 22:55:23 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id g11sm7466198edz.53.2021.12.05.22.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Dec 2021 22:55:22 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <56b9d000-8743-52cb-4f10-4d3fa2b30f29@redhat.com>
Date:   Mon, 6 Dec 2021 07:55:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [KVM] d3750a0923:
 WARNING:possible_circular_locking_dependency_detected
Content-Language: en-US
To:     kernel test robot <oliver.sang@intel.com>,
        David Matlack <dmatlack@google.com>
Cc:     0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@lists.01.org, kvm@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Janis Schoetterl-Glausch <scgl@linux.vnet.ibm.com>,
        Junaid Shahid <junaids@google.com>,
        Oliver Upton <oupton@google.com>,
        Harish Barathvajasankar <hbarath@google.com>,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>
References: <20211205133039.GD33002@xsang-OptiPlex-9020>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20211205133039.GD33002@xsang-OptiPlex-9020>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/5/21 14:30, kernel test robot wrote:
>
> Chain exists of:
>   fs_reclaim --> mmu_notifier_invalidate_range_start --> &(kvm)->mmu_lock
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(kvm)->mmu_lock);
>                                lock(mmu_notifier_invalidate_range_start);
>                                lock(&(kvm)->mmu_lock);
>   lock(fs_reclaim);
>

David, this is yours; basically, kvm_mmu_topup_memory_cache must be 
called outside the mmu_lock.

Paolo
