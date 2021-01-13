Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85E72F4BD4
	for <lists+kvm@lfdr.de>; Wed, 13 Jan 2021 13:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725911AbhAMM4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jan 2021 07:56:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25485 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725809AbhAMM4Y (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 13 Jan 2021 07:56:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610542497;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0lgVRo6CQ9NzWlGI1TykX+pxELJPZRPvZtRz/475DZc=;
        b=ZifFLbxN4hLm73fM9b5KFMOSWsLoybHmRk1RfnknBbez0i5bIupA9QAP9dQ+KKrpEbW4KR
        v3JBno3WV2n/Q1XFtyUjDxWXv0ups4SWhcxdjtd5CFBBjQl09jS+54uQgygs4WqKSA0FfG
        Bf1lCVazcpXz/0seIBUp9/P6//mw5WY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-488-hBrnjB94N0OQ-Gjd05s8OQ-1; Wed, 13 Jan 2021 07:54:56 -0500
X-MC-Unique: hBrnjB94N0OQ-Gjd05s8OQ-1
Received: by mail-ed1-f72.google.com with SMTP id f19so801123edq.20
        for <kvm@vger.kernel.org>; Wed, 13 Jan 2021 04:54:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0lgVRo6CQ9NzWlGI1TykX+pxELJPZRPvZtRz/475DZc=;
        b=l0yeWcgGZFVl+rWRKDy3HhR0oMDSP8ZBKQk7WOfBdEjscmeTaAZvSxpIlDYGulH7GD
         FXFcaOYUS1YvHVijy+0iiAsnyWd6S6F82/gcvb7ssYvMiR2VXpMDFHiGsbdXpUbotQUQ
         Bpri0KHwp3djW7Z4PEOz7hBoqNYly+BHHJ6FyBYfVmq8DLztwweOMWuywRB4L7+Mromc
         WFNv/K72oWQI2okevwJGI+FBxZVKVA/UNxjPSheP9sHIBeVSl0dsLZfXVdQN4+8Ip1N8
         f0YveEBSKSwvqcK9TZrX9T3w6CZcCtQWtxPYe+wakUayI5NetXSbdc387ygqfKIRvP4y
         Z2WA==
X-Gm-Message-State: AOAM530u75LCEDi080nlm72T8LAoEgK5ZrF198/fJTxekeS2EaOpNMyO
        Kv4t0O80F6FheDgco3DiA2AWibmvW7NwhsJYFCoFDL5rbcvvWZJbi/82/E9iw6LlPth05zj6SdE
        yhZBUD4mhLdFl
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr1399603ejw.430.1610542494997;
        Wed, 13 Jan 2021 04:54:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzBAbgplulFKo9eP75wGHcb584+trku5uwL0gCASCjo/ZigzcaALTL85slMCjEGciyLubpwAA==
X-Received: by 2002:a17:906:8051:: with SMTP id x17mr1399592ejw.430.1610542494870;
        Wed, 13 Jan 2021 04:54:54 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id k16sm677031ejd.78.2021.01.13.04.54.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Jan 2021 04:54:53 -0800 (PST)
Subject: Re: [PATCH 1/2] Enumerate AVX Vector Neural Network instructions
To:     Yang Zhong <yang.zhong@intel.com>
Cc:     Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, tony.luck@intel.com, seanjc@google.com,
        vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
        joro@8bytes.org, kyung.min.park@intel.com, x86@kernel.org
References: <20210105004909.42000-1-yang.zhong@intel.com>
 <20210105004909.42000-2-yang.zhong@intel.com>
 <8fa46290-28d8-5f61-1ce4-8e83bf911106@redhat.com>
 <20210105121456.GE28649@zn.tnic> <20210112021321.GA9922@yangzhon-Virtual>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <be47fd98-9d76-a35f-3ee2-7de2144dbdd6@redhat.com>
Date:   Wed, 13 Jan 2021 13:54:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210112021321.GA9922@yangzhon-Virtual>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

>>> Boris, is it possible to have a topic branch for this patch?
>>
>> Just take it through your tree pls.
>>
>> Acked-by: Borislav Petkov <bp@suse.de>
>>
>    
>    Paolo, Boris has acked this kernel patch, and if i need send new patchset to add this
>    acked-by info ? or kvm tree will directly pull this patchset? thanks.

I'll take care of it shortly.

Paolo

