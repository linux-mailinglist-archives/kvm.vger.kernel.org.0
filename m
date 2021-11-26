Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7CA45EC59
	for <lists+kvm@lfdr.de>; Fri, 26 Nov 2021 12:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbhKZLVX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Nov 2021 06:21:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239120AbhKZLTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Nov 2021 06:19:22 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DE8BC08EB39;
        Fri, 26 Nov 2021 02:35:23 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id y12so36841462eda.12;
        Fri, 26 Nov 2021 02:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x9VTEA3HK5NUEYZ+Itq+aDbO8qFSHwWm4ucc60qS7cE=;
        b=AM6YbBWIZ65HrakKGj1m3sFupGr79u8HpkhvQFYuHND0qOp31Kp/FREBqrrEu4jZmW
         h8VTVJMrg1fKolYAHWtXpCFc3Y/djmzyEmXJzCzB46ONgq6D02Sgb79F8lNM1mZVsQtT
         vMGwr6HzElhMofJ5IO6vWy/SfTpH1ZRW3uqNBNICMVRKZmjEQedtvEhoCevvrKRFUW6+
         nXtqKJ481RHgca0HgAITJUjQULieBkIYmTRsMhO/izysnByxoTAeRCUKiDZizO+Jp81W
         ieEPxo/p8hQOOyO+jYuTXAtM+R9tuZFixniO0UCrTLEDl4zJ5WN1cTmB0F32ggYy+dCs
         rXdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=x9VTEA3HK5NUEYZ+Itq+aDbO8qFSHwWm4ucc60qS7cE=;
        b=eTEY2qtwVo9pOX39jGwwtm/H72iOl33l2pVyOXucgvVfGfOheDz1/uQhsfVYmvketj
         eJyeYXRz7pMqRSIqYwmBz9UWaSks3HC94Q5RkW+yEinbG+D8eHMMc3szZjbxwdlRckvm
         AX/gcBca9cb5kakAUsMZiTARw04gsAgjpXSalTp5RLskI1dvU7fnP2FOl7VCyN571GWS
         r9K3qvMfJ3YbjcSqJ6mQSZKtafohJU20KLqOGeFdt0Kvd214pd5MsnHEgP9PhRPDaalG
         Y2P2fKlLs1mFSuS0N6Cb2eycw+uDUh8xs6g97YBfxeVmFYeMddjsaaGI8Yzdvphr7TiF
         lU2w==
X-Gm-Message-State: AOAM532tRvFEBQBdDWr4kpCeUiNF297FOaZID9SFAjALsqRm4VhkzZWP
        H4HzW0ClZTCs984zgzdUCYc=
X-Google-Smtp-Source: ABdhPJz7yk5Sfb6LQeqA5b3rLYs1OVwZZWRBhXj0YFoetrg+O4OqNPopdGsn1kptzHVQ8KSt+GaSUw==
X-Received: by 2002:a17:906:6582:: with SMTP id x2mr37924302ejn.38.1637922921920;
        Fri, 26 Nov 2021 02:35:21 -0800 (PST)
Received: from ?IPV6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.googlemail.com with ESMTPSA id e26sm3626452edr.82.2021.11.26.02.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Nov 2021 02:35:21 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <743fffd6-e0fb-6531-bfa6-c30103357ce2@redhat.com>
Date:   Fri, 26 Nov 2021 11:35:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 0/3] KVM: Scalable memslots implementation additional
 patches
Content-Language: en-US
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Igor Mammedov <imammedo@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1637884349.git.maciej.szmigiero@oracle.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <cover.1637884349.git.maciej.szmigiero@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/26/21 01:31, Maciej S. Szmigiero wrote:
> From: "Maciej S. Szmigiero"<maciej.szmigiero@oracle.com>
> 
> While the last "5.5" version of KVM scalable memslots implementation was
> merged to kvm/queue some changes from its review round are still pending.

You can go ahead and post v6, I'll replace.  However, note that I would 
prefer the current form instead of patch 2's atomic_long_cmpxchg.

Paolo
