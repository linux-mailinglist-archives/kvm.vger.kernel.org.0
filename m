Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082484326FB
	for <lists+kvm@lfdr.de>; Mon, 18 Oct 2021 20:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233108AbhJRTAZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Oct 2021 15:00:25 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232650AbhJRTAZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Oct 2021 15:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634583493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YPCBK4+qqhN59Q6AXab9sUjlmniUhlFiGiZrEdBuk6s=;
        b=JgSfjavM+lQ+BK0DZmqJAWa382fTICfypWPKH35yF3B1Dgt9/ixHmXvrzjiN0J4gqiILXq
        EH7+ND4f3+0Wn8rpkDwjOUpNYcSi0f0IQbCO35BKcSUQu1TnkZoCmgSJobPiLFktWYCtGs
        +gefR6YKm8UhQjEXGwjy4+q1TZ4nOmE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-nXs3TInJOUu0is0nT8yK3A-1; Mon, 18 Oct 2021 14:58:12 -0400
X-MC-Unique: nXs3TInJOUu0is0nT8yK3A-1
Received: by mail-ed1-f72.google.com with SMTP id h19-20020aa7de13000000b003db6ad5245bso15325887edv.9
        for <kvm@vger.kernel.org>; Mon, 18 Oct 2021 11:58:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YPCBK4+qqhN59Q6AXab9sUjlmniUhlFiGiZrEdBuk6s=;
        b=Tzw2NZx6KyKSP2MB8WvYnPQnCzx8vf7aYwH9A2MmaEz1EeMapeW+Z0h/mLiZFF4b6O
         AW/H1GAywf6TPrgmLoF8shxRZ5HTbPZDP3mqChn+iXjnpxzm3K7Iuu2rscJp79MVISz7
         jQbnnO3i3MOskZAHIL/bUAmPdnFTrHyzygryy2pwA6G05aUxR1bDjLmBVo/P6b8ERrR1
         d/ZoxCGH0X2VWj6zm3mYR0ecL0eYQrJS4i3IZyfDEEM7+zeB61d4je6VoIXmpKNKRVFx
         J0Rp+GSgtzG6GeS0SrHoW2EY+a02ZsGLWLa/YBsB8C72xo1XZFn7VHYoMS/S5Q3XC5oI
         m5bA==
X-Gm-Message-State: AOAM532uOPX6j2yc9sC83G10hibbPmRx+Kwn5zgiNH7pHu2DxPDU1sVT
        ZlB01GlQzhDG/Vhw0B/8LaXo/uAjgV/1DpLFR2CLWjj1KW1+Ck2HXUHMHMJbDo2YAeyzi80xpFb
        WE7JFezxna8YC
X-Received: by 2002:a05:6402:2022:: with SMTP id ay2mr48453439edb.344.1634583490631;
        Mon, 18 Oct 2021 11:58:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwGzK2DGqC5lNBWwnAI2+ei1GtdSNm5wkCuN7xuHyVhKJiiPol/b31DZz0l2mHQvwfG1aPAMQ==
X-Received: by 2002:a05:6402:2022:: with SMTP id ay2mr48453414edb.344.1634583490469;
        Mon, 18 Oct 2021 11:58:10 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id y21sm9192732ejk.30.2021.10.18.11.58.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Oct 2021 11:58:09 -0700 (PDT)
Message-ID: <77444c94-e88a-ab96-cbea-674375ddee5c@redhat.com>
Date:   Mon, 18 Oct 2021 20:58:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH] KVM: cleanup allocation of rmaps and page tracking data
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        David Stevens <stevensd@chromium.org>
References: <20211018175333.582417-1-pbonzini@redhat.com>
 <YW25ZiTE1N6xS4FN@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YW25ZiTE1N6xS4FN@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/10/21 20:13, Sean Christopherson wrote:
>> Co-developed-by: Sean Christopherson<seanjc@google.com>
> Checkpatch will complain about a lack of
> 
> 	Signed-off-by: Sean Christopherson<seanjc@google.com>
> 
>> Signed-off-by: Paolo Bonzini<pbonzini@redhat.com>
>> ---
> ...
> 
>> +	bool shadow_root_alloced;
> Maybe "allocated" instead of "alloced"?

Sounds good.

Paolo

