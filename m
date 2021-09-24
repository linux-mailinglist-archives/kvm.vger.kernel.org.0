Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C776D41781A
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 18:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347261AbhIXQDF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 12:03:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22578 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1347247AbhIXQDA (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 24 Sep 2021 12:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632499286;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TudUTjEP0k1/HE5s4PUTK9xUpG/DldUIjjGXuBeaV2g=;
        b=g/ZgxEMRcj7I5tPKCwoWjr+qUzzUAuGynRLu0oeHn81ivyV435URmV1h89SiylcRllUI6R
        hj9mfwh9fEycRU9kca3jlhCt239czumGKCOZCsRaJmg9s6LmilQhi0jOBzHbnDj8N7OoEy
        h29hVIC4arbZ4a63QCidU42OdwACvcw=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-JKcAi0zuO1C23Z_ce2_lNA-1; Fri, 24 Sep 2021 12:01:20 -0400
X-MC-Unique: JKcAi0zuO1C23Z_ce2_lNA-1
Received: by mail-wr1-f69.google.com with SMTP id m1-20020a056000180100b0015e1ec30ac3so8468563wrh.8
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 09:01:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TudUTjEP0k1/HE5s4PUTK9xUpG/DldUIjjGXuBeaV2g=;
        b=mpOspoFM5bzcY0qOo0InWrpsmGbSxVpEx1O0LYHg2RoFyjXq8Xu75MTBcG+yq/fo5u
         Xf4f56OE0SyDZ8iCualoxkkOoCAAfmfGl+x71k6nk3BT3euZdKVePdBJ8440iGD1t+Xi
         0bFvJE81v0kkutqWiiQuOAqMLTLfbpq1mDQatD9+FziX0PRyY5XE+pbCFz3nP7waEvKq
         z7jiySjiAa56afe6QQxrzs18ZpyFgR0bUUx3aiWWm3hCmhSl4OVkunhHS89bZQem4BVh
         xIt9b3+8P0VbGlxm9pJtWKa7j3knhMJ+0xtug/5SCuzCO8ADMSpR48U3CAa5zXWSHYwC
         8hTw==
X-Gm-Message-State: AOAM532MmTctLj58Zi8PdNoobpgXV2+5Ru9kLzNhRgTPUUsNx2QkLLzv
        zcp6uzIkr9xxUFQEry4O3G7hvBRa3AJv369UzBLC/huQQCJzjhEyHjNTBIsYvYjST6QZS71J1Id
        /v3+HryWIFzv2
X-Received: by 2002:a7b:c845:: with SMTP id c5mr1032237wml.17.1632499279515;
        Fri, 24 Sep 2021 09:01:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/wZXfPe7Vy8SRZtDxf4Y674y47Z6H0NCE2CsQlcz9CeIwPLUy83tbmW0CljWDa+ec8tDF2Q==
X-Received: by 2002:a7b:c845:: with SMTP id c5mr1032205wml.17.1632499279322;
        Fri, 24 Sep 2021 09:01:19 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id i203sm12811432wma.7.2021.09.24.09.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Sep 2021 09:01:18 -0700 (PDT)
Message-ID: <4005b824-549a-094d-82f2-e921fcd22912@redhat.com>
Date:   Fri, 24 Sep 2021 18:01:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [GIT PULL] KVM/rseq changes for Linux 5.15-rc3
Content-Language: en-US
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>
References: <20210923181252.44385-1-pbonzini@redhat.com>
 <CAHk-=wjp7psdNc8KpxVDmcVYaAAxDUvvFTgx21OwZJzkghktLg@mail.gmail.com>
 <87r1deqa6b.fsf@disp2133>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87r1deqa6b.fsf@disp2133>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 24/09/21 17:13, Eric W. Biederman wrote:
> Does anyone have any idea what to call
> tracehook_notify_resume so that it describes it's current usage?

There isn't a more precise definition than "sundry slowpaths to be 
invoked before returning to userspace".  Whenever one of the triggering 
conditions becomes true, set_notify_resume() is called and 
tracehook_notify_resume() will execute them all.

Paolo

