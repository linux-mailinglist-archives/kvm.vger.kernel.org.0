Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F51D415B3E
	for <lists+kvm@lfdr.de>; Thu, 23 Sep 2021 11:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240222AbhIWJq2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 23 Sep 2021 05:46:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238217AbhIWJq1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 23 Sep 2021 05:46:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632390296;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Op2qoA0X6Ury/zosiAJXrERLFd0OXj6FZBc06wzqmPc=;
        b=B2AOMBIx2iD1GXOzpT19Ku/fNVXKwazwKfbFG2Mu92fj/aR3BWGZEPJ0rn7yRifp6YHZFm
        ut+zOKgVoBSCIz/Q9urtZNyH0Fx9yKMhXXaCnHxcJSLFHrEnfx1MAxAJA9P3O6g+oYOnOK
        IO+E/shgXpTToSCuGO8eca77lAL8nKQ=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-RbEDTqNsNxi3RXzeCeltbA-1; Thu, 23 Sep 2021 05:44:54 -0400
X-MC-Unique: RbEDTqNsNxi3RXzeCeltbA-1
Received: by mail-ed1-f72.google.com with SMTP id q17-20020a50c351000000b003d81427d25cso6190851edb.15
        for <kvm@vger.kernel.org>; Thu, 23 Sep 2021 02:44:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Op2qoA0X6Ury/zosiAJXrERLFd0OXj6FZBc06wzqmPc=;
        b=U/MBvZZju8eyH6+Jes2Sq/nnl/+O0QgdM6aVjDmgcoHw5guppzk7hchwlPWldcn9NB
         5gmhjUaFV6FbuIbeUT9Jk0vX5j1dVfRdsKDU2Z5drUKX91Z7qg3Agl2yCTMpy2Z9vaE3
         /17pXagqhw7Cgnq19rqHedOsmQxQdX8zR+6SSujcL9L0HFC2mS6ac4qKoR0zYfkaLkWk
         lPfFvIWFUYGLXUqi2+Q+Fam9SHZjBccq/3QpFnKCsJeepC0FYoGGD2ByIyVmAYT+pJQ1
         nhnjjFqWmJgkGEOt0v/UJroW0NySmBYwtoV9WMBiVc67iwoiN19Aj5nLRXSgaF5xf/ux
         3+nw==
X-Gm-Message-State: AOAM533LGZdM/tivvghAYukxn6h4miS8lHmaoCP/95Wtwm1NHLHWfDb6
        SKOkA428xk+0rAJZrHByr2pnGrYIs0GdKtIwXEv2IG7MUkS/vufoc16ZzL9DzfQZNq+HVH6dran
        fk0ujtzXWfWWD
X-Received: by 2002:a50:d88a:: with SMTP id p10mr4332445edj.274.1632390293738;
        Thu, 23 Sep 2021 02:44:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyPCN0OqTken5jvVkYlVKwejgNBxL3gEDAFz0FGtJBhVhqwLaHEpc/KSsW/W8jn3S34zdGMNA==
X-Received: by 2002:a50:d88a:: with SMTP id p10mr4332419edj.274.1632390293499;
        Thu, 23 Sep 2021 02:44:53 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id bj10sm2653827ejb.17.2021.09.23.02.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Sep 2021 02:44:52 -0700 (PDT)
To:     Marc Zyngier <maz@kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>,
        Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMARM <kvmarm@lists.cs.columbia.edu>,
        Will Deacon <will@kernel.org>,
        David Matlack <dmatlack@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        Jim Mattson <jmattson@google.com>,
        Ben Gardon <bgardon@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Venkatesh Srinivas <venkateshs@google.com>
References: <20210922010851.2312845-1-jingzhangos@google.com>
 <20210922010851.2312845-3-jingzhangos@google.com>
 <87czp0voqg.wl-maz@kernel.org>
 <d16ecbd2-2bc9-2691-a21d-aef4e6f007b9@redhat.com>
 <YUtyVEpMBityBBNl@google.com> <875yusv3vm.wl-maz@kernel.org>
 <a1e77794-de94-1fb7-c7d3-a80c34f770a4@redhat.com>
 <8735pvvip9.wl-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v1 3/3] KVM: arm64: Add histogram stats for handling time
 of arch specific exit reasons
Message-ID: <2120a93b-2e15-117d-349c-9045cef23439@redhat.com>
Date:   Thu, 23 Sep 2021 11:44:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <8735pvvip9.wl-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/21 09:45, Marc Zyngier wrote:
> On Thu, 23 Sep 2021 07:36:21 +0100,
> Paolo Bonzini <pbonzini@redhat.com> wrote:
>>
>> On 22/09/21 20:53, Marc Zyngier wrote:
>>> I definitely regret adding the current KVM trace points, as they
>>> don't show what I need, and I can't change them as they are ABI.
>>
>> I disagree that they are ABI.  And even if you don't want to change
>> them, you can always add parameters or remove them.
> 
> We'll have to agree to disagree here. Experience has told me that
> anything that gets exposed to userspace has to stay forever. There are
> countless examples of that on the arm64 side (cue the bogomips debate,
> the recent /proc/interrupts repainting).

Files certainly have the problem that there are countless ways to parse 
them, most of them wrong.  This for example was taken into account when 
designing the binary stats format, where it's clear that the only fixed 
format (ABI) is the description of the stats themselves.

However yeah, you're right that what constitutes an API is complicated. 
  Tracepoints and binary stats make it trivial to add stuff (including 
adding more info in the case of a tracepoint), but removing is tricky.

Another important aspect is whether there are at all any tools using the 
tracepoints.  In the case of the block subsystem there's blktrace, but 
KVM doesn't have anything fancy (tracing is really only used by humans 
via trace-cmd, or by kvmstat which doesn't care about which tracepoints 
are there).

> We had that discussion a few KSs ago (triggered by this[1] if I
> remember correctly), and I don't think anything has changed since.
> 
> As for removing them, that would probably be best for some (if not
> most) of them.

I'd say just go ahead.  System calls are removed every now and then if 
they are considered obsolete or a failed experiment.  Tracepoints are in 
the same boat.

Paolo

