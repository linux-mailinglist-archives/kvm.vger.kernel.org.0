Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7BD139B3D5
	for <lists+kvm@lfdr.de>; Fri,  4 Jun 2021 09:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFDH0W (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Jun 2021 03:26:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52199 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229994AbhFDH0V (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 4 Jun 2021 03:26:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622791475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ElFb664kDca3zTUpMXZCL5Csjp2/nyoNDD9HukhmOHM=;
        b=TnlVERX2WCccv73rRj+yMV72uhH/2GHU7sl8HB55t/ERJoXUzRYdL/CuKMoJrLWVT78foe
        XFg/BBEKf6L66s5ompGQJrLedD+9pEWksjvkh/xoghLGBf6cL0dryFAkhNicq74W/M5dOg
        2TuKJjL2eZ7HY8FgemWzln8LNQavm6k=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-41-mK2Abq33MDS8ko7a5owEZg-1; Fri, 04 Jun 2021 03:24:33 -0400
X-MC-Unique: mK2Abq33MDS8ko7a5owEZg-1
Received: by mail-ej1-f70.google.com with SMTP id e11-20020a170906080bb02903f9c27ad9f5so3038016ejd.6
        for <kvm@vger.kernel.org>; Fri, 04 Jun 2021 00:24:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ElFb664kDca3zTUpMXZCL5Csjp2/nyoNDD9HukhmOHM=;
        b=adByoCZvLky67KNBF8dnVLwOIJJRSc80dlF/LfvSuaSzEka/4OPsA0rkuNHekEgfnf
         s+9/fHOBOwH28JnDQWJeXgsA3BpggI6ZB5mvJE96PDe7b2epC9GYHjgjaTUjIT/yVX5/
         Qr6TxSwQhq1gxP9/Oy0p8xkASLh9za7JxIvQdUQFGsxTgtffmM8kbguo3ezUbKrlv7+p
         5hoK9rQG7D4IxM5pM4XYOTNByQ4xKQwJ9CfGiiZx7JPmrStt02qUv909/X0zrQmAfCTw
         IIYJsAh/GtCV7LtlQAHC7TUd8xGUjcdVaiheJy2ruT92fmcgxLUR7d+dmz9SPcHTPTBi
         yLIg==
X-Gm-Message-State: AOAM5314qnqLB8C6uSlWn3eWpjAjsnPBR3FRrBQw53PeuU3Z/VNoRKgC
        dQNbdN1myGkNyexkuQruJijXeXVnupEBGE7IchdJpwZGypC2HihVH5WB9Hv+dTfPSSCrC285RD4
        3mo7kiEQHjU14
X-Received: by 2002:a17:906:1401:: with SMTP id p1mr2849913ejc.526.1622791472784;
        Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwf6cQzWkBIEpZuWDj8mD3YKNJZw3J7U1/Ic7+UpRFaWTIKLqYoDPaxKjav78eW5CkReqQfnw==
X-Received: by 2002:a17:906:1401:: with SMTP id p1mr2849903ejc.526.1622791472650;
        Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id nc26sm2296091ejc.106.2021.06.04.00.24.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Jun 2021 00:24:32 -0700 (PDT)
Subject: Re: [RFC][PATCH] kvm: add suspend pm-notifier
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sergey Senozhatsky <senozhatsky@chromium.org>
Cc:     Marc Zyngier <maz@kernel.org>, Huacai Chen <chenhuacai@kernel.org>,
        Paul Mackerras <paulus@ozlabs.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Suleiman Souhlal <suleiman@google.com>, x86@kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-kernel@vger.kernel.org, linux-mips@vger.kernel.org,
        kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linux-s390@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>
References: <20210603164315.682994-1-senozhatsky@chromium.org>
 <87a6o614dn.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e4b4e872-4b22-82b7-57fc-65a7d10482c0@redhat.com>
Date:   Fri, 4 Jun 2021 09:24:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <87a6o614dn.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/06/21 09:21, Vitaly Kuznetsov wrote:
>>   
>>   	preempt_notifier_inc();
>> +	kvm_init_pm_notifier(kvm);
>>   
> You've probably thought it through and I didn't but wouldn't it be
> easier to have one global pm_notifier call for KVM which would go
> through the list of VMs instead of registering/deregistering a
> pm_notifier call for every created/destroyed VM?

That raises questions on the locking, i.e. if we can we take the 
kvm_lock safely from the notifier.

Paolo

