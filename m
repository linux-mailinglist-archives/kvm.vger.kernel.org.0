Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0691433CBE
	for <lists+kvm@lfdr.de>; Tue, 19 Oct 2021 18:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234210AbhJSQyi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 19 Oct 2021 12:54:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54072 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229846AbhJSQyh (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 19 Oct 2021 12:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634662344;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RjMQi48Y3BWRD5Wrxhvo6RSSyJjbJwh5TzWGFZw/n9U=;
        b=gxAknUuWaop6CXLzUcxMtyXC62cNx7F5dSR10KGM5k19xi3Q39+IwfLqobDgcPZp42DDYY
        C2jvLJSs2DfJwgK4cRIUU5K+bLU3P/WLiJapmWATTQ8LMGg/Af2eZMVfBw1xaBdOieEEgu
        brUe/Ydo0f2IbnSO/wY3Cx9swwSi0QY=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-42-gdLCxvqQPBGfc8zmwsJ1xQ-1; Tue, 19 Oct 2021 12:52:23 -0400
X-MC-Unique: gdLCxvqQPBGfc8zmwsJ1xQ-1
Received: by mail-wm1-f70.google.com with SMTP id d16-20020a1c1d10000000b0030d738feddfso1477454wmd.0
        for <kvm@vger.kernel.org>; Tue, 19 Oct 2021 09:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RjMQi48Y3BWRD5Wrxhvo6RSSyJjbJwh5TzWGFZw/n9U=;
        b=CpOO4YG/Yowf/z3noCm4R/uywC7ioy5Pggu7WTZC9hlUywnk5zRbOUd5WuQANJOKXi
         jRYuHrCLZlBlaDs4sNBHLkCuqRM0rqQoIfornqXtzKUbgBMYdcnLGhEQU83AVXdW2OCx
         Wsv9/ddk4VGlh4nYROnOEmidM+3m9JqTh3M4W1JiL4xD72SHohOTLk7jqJ934BNejVeL
         LxIVQA8FvxJK8yz5+aXm3OXOgnCZQpBBb6XX6xCMjMCOHCf5olkSsAZRcmqZd0LWVsZJ
         LV1iUMGlkOwzKLvWkKHMRQmgyNMA1gEnLDln/lKeY24k5pGnKZnaoetERMj43c7ZOHzb
         GTOw==
X-Gm-Message-State: AOAM531jdIzRQwXZVEdx0OpDzVGeyDFnkRdvSkx4N8YbwPIyTFAPXuFt
        z4RsuKgzqCDi5aKB7REV2vH1pVrh77+Pf2jMjkFR6cHns5FHJoiOSay/Vv0cUTU90krkZFwAALF
        ejJeSH4iWuGk8
X-Received: by 2002:adf:a390:: with SMTP id l16mr45622646wrb.291.1634662341713;
        Tue, 19 Oct 2021 09:52:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwFgKUnmqhDWkJbPB/NEuTMocAhYLf4akh06ar3YPj10YH9Ht4wI/IzCQvyoWjAcfV5wfHHlw==
X-Received: by 2002:adf:a390:: with SMTP id l16mr45622606wrb.291.1634662341377;
        Tue, 19 Oct 2021 09:52:21 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:8e02:b072:96b1:56d0? ([2001:b07:6468:f312:8e02:b072:96b1:56d0])
        by smtp.gmail.com with ESMTPSA id g33sm2427155wmp.45.2021.10.19.09.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 09:52:20 -0700 (PDT)
Message-ID: <166e2d66-1c16-29d4-3275-517310043ae0@redhat.com>
Date:   Tue, 19 Oct 2021 18:52:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH v2 0/7] KVM: VMX: PT (processor trace) optimization
 cleanup and fixes
Content-Language: en-US
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210827070249.924633-1-xiaoyao.li@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20210827070249.924633-1-xiaoyao.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/08/21 09:02, Xiaoyao Li wrote:
> Patch 1-3 are optimization and cleanup.
> 
> Patch 4-7 are fixes for PT. Patch 4 and 5 fix the virtulazation of PT to
> provide architectual consistent behavior for guest. Patch 6 fix the case
> that malicious userspace can exploit PT to cause vm-entry failure or #GP
> in KVM. Patch 7 fix the potential MSR access #GP if some PT MSRs not
> available on hardware.
> 
> Patch 3 and patch 7 are added in v2.

Queued patches 1-4, thanks.

Paolo

