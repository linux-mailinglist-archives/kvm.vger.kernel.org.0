Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F1636E86B
	for <lists+kvm@lfdr.de>; Thu, 29 Apr 2021 12:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240271AbhD2KKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 29 Apr 2021 06:10:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232629AbhD2KKK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 29 Apr 2021 06:10:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619690963;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7ZFyr5mpRghduXOnoE7H3sxU/6BfwiFPot9Qqrp6hRU=;
        b=SHFJfVW5cSPGkPwh5dMDg0ss4EEMQum0uDelhJciiROAo/EDehj8UdKsR96AJZ++PXEcN9
        UcbxfsoyXJmcXvZAIWtsvJkmpBR8ExLpukYh7zZi8YGhZuRPJN4BnkFHvk5tux0JcXzFwZ
        1zy1EzQpB++R9wPfJxKFymrT6pf421Y=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-32PjrZ06Ow27-dnz0-o_4Q-1; Thu, 29 Apr 2021 06:09:19 -0400
X-MC-Unique: 32PjrZ06Ow27-dnz0-o_4Q-1
Received: by mail-ed1-f71.google.com with SMTP id i17-20020a50fc110000b0290387c230e257so6314966edr.0
        for <kvm@vger.kernel.org>; Thu, 29 Apr 2021 03:09:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7ZFyr5mpRghduXOnoE7H3sxU/6BfwiFPot9Qqrp6hRU=;
        b=IyZqXOux8duOgO6CDJAwyF/TC7dNBGZEZb+EHE8kiHLUOEsQcOOd80iitX3TmTwfz6
         0SLjDusL+Fw6IHSX3SaPUl7X02geSDH+tdqgi9HIGebMElEasntoLDMKs9ZhlSU07q9k
         +HNcMZ2elpyVjkDuUdzpEI73E8nCuD3dJcFIHIycbAUmHjEqffxTKImRX37xVgUI5uoF
         g8qGog6vnfmTaE23J6DmcKH4SaWXw6BWGAtCAnqiKS0Q4tTggnqHzb/Xd/ZTqJXKjdhx
         LRF5CXVufpYznAI1+vq1qJUoSzFZ6K69deHwYyHconO2hFkP1WBgZTQLkeMPvHkxT/nq
         xorg==
X-Gm-Message-State: AOAM531P7ZiTmoiwUNTLshFupi7sIr8LXuLIMUgI323ZPTIjoOJW0Ul8
        vNL70CP21408zP8/EcmbjGVoERHIS/KfWRdJD1xklLEvmjG+7ZZVN6S14iJwMqZFf28jNgSa29U
        Wer0ndNXTEabl
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr16993718edb.28.1619690958432;
        Thu, 29 Apr 2021 03:09:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1YMOL4t+paQHX+lVQsNYt9WN5JUhsRxvn9uu0mM2C1D//VngYDfIF/6Qg3bG0hhfeHSGVxw==
X-Received: by 2002:a05:6402:2211:: with SMTP id cq17mr16993705edb.28.1619690958290;
        Thu, 29 Apr 2021 03:09:18 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id t15sm2010629edr.55.2021.04.29.03.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 03:09:17 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] KVM: x86: add MSR_KVM_MIGRATION_CONTROL
To:     Sean Christopherson <seanjc@google.com>,
        Steve Rutherford <srutherford@google.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Venu Busireddy <venu.busireddy@oracle.com>
References: <20210421173716.1577745-1-pbonzini@redhat.com>
 <20210421173716.1577745-3-pbonzini@redhat.com> <YIiMrWS60NuesU63@google.com>
 <CABayD+dKLTx5kQTaKASQkcam4OiHJueuL1Vf32soiLq=torg+w@mail.gmail.com>
 <YInAT6MYU2N0tKSW@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <cc0c6333-6c2f-e8f3-f838-3cb2492f007a@redhat.com>
Date:   Thu, 29 Apr 2021 12:09:16 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YInAT6MYU2N0tKSW@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/04/21 22:06, Sean Christopherson wrote:
> But there's only multiple meanings if we define the bit to be specific to
> page encryption.  E.g. if the bit is KVM_READY_FOR_MIGRATION, then its meaning
> (when cleared) is simply "please don't migrate me, I will die".  KVM doesn't
> care_why_  the guest is telling userspace that it's not ready for migration, nor
> does KVM care if userspace honors the indicator.

Makes sense, I'll change that.

Paolo

