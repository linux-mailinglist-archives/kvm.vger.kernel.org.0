Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8071DE0BA
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 09:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728495AbgEVHTQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 May 2020 03:19:16 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37580 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728312AbgEVHTQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 22 May 2020 03:19:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590131954;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3eRhZPgzwHlAVBaV96QAFjAli90Hc9dV0FWyT4T3VPM=;
        b=fXLGgslKYLT9/fYeiI8PJjH41YuUo5gmDLUCs7QYWMBxRKaTIX0v6ER/TZydEyhlMDOwYH
        yKT0rNXahyGWb5VOESboxGkpe1D/Br9JbjWXoyzfin61HJT7TVfK16b0vjlMjDUtXxKk2k
        HOytBtm1I+EeQ64u+gVS2OWlKLZ7cEg=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-94-hSa7YSJAMNauJqw5-j86kA-1; Fri, 22 May 2020 03:19:12 -0400
X-MC-Unique: hSa7YSJAMNauJqw5-j86kA-1
Received: by mail-ej1-f71.google.com with SMTP id f17so4178963ejc.7
        for <kvm@vger.kernel.org>; Fri, 22 May 2020 00:19:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3eRhZPgzwHlAVBaV96QAFjAli90Hc9dV0FWyT4T3VPM=;
        b=OTVszk7Fa1VWAgjxCwofvyePENMJPWryeyy8JbUWz3f282wq4X8eMP5wwLRQ+wWJal
         syrVtJKHrHGh9RvEzxBz7L3B7il5HyscTSmWi648U47lKhpHWIHSasQBnR/tVGAHj5NM
         qpQTXYjz8hcrSpe4CrZ8eJGhAbZ4WRfM/5649uQfY1g8ukMmh8mxdx1sQtWaq6SnqquF
         nfCJJLR00euwzEyfvvqxUr/9OQBvIyYXfdyUX5aRQY/uWypI1BQglaubsu3rK/BzHmoB
         k9v8NsbUDz/y44o706ptJK0ii47hgiJI9B7Gn9cq890afuLb3nDKFnho40066uKzYHa7
         uZ1w==
X-Gm-Message-State: AOAM533I44/IUPGqmfn69Przfvb2YI0yemzdDpQsM8OfA/p9p9Eg3m9X
        wzuj6BmK7xOexwwICOp5XG4o56NHbhPd7YNktFaWBtFKzesHj8MQY7Mc6cNqT08sowkKGKKsXUJ
        r2jxp+R3gXGSV
X-Received: by 2002:a17:906:c108:: with SMTP id do8mr7314540ejc.134.1590131950881;
        Fri, 22 May 2020 00:19:10 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzqpaPg/j+E91dKDaUWaayxxQK1GpnPNN5A2mvKJxcgYV+KAVe637E2EplXz9PWs8Axj30QHQ==
X-Received: by 2002:a17:906:c108:: with SMTP id do8mr7314529ejc.134.1590131950652;
        Fri, 22 May 2020 00:19:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:71e6:9616:7fe3:7a17? ([2001:b07:6468:f312:71e6:9616:7fe3:7a17])
        by smtp.gmail.com with ESMTPSA id i9sm6382245edr.40.2020.05.22.00.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2020 00:19:09 -0700 (PDT)
Subject: Re: [PATCH 1/2 v4] KVM: nVMX: Fix VMX preemption timer migration
To:     Makarand Sonare <makarandsonare@google.com>, kvm@vger.kernel.org,
        pshier@google.com, jmattson@google.com
References: <20200522043634.79779-1-makarandsonare@google.com>
 <20200522043634.79779-2-makarandsonare@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e8ddc9b2-dd17-aace-7c69-69401d511e1b@redhat.com>
Date:   Fri, 22 May 2020 09:19:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200522043634.79779-2-makarandsonare@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/05/20 06:36, Makarand Sonare wrote:
>    #define KVM_STATE_NESTED_RUN_PENDING		0x00000002
>    #define KVM_STATE_NESTED_EVMCS		0x00000004

> +  /* Available with KVM_CAP_NESTED_STATE_PREEMPTION_TIMER */
> +  #define KVM_STATE_NESTED_PREEMPTION_TIMER	0x00000010

Putting this here is confusing, please rename it to
KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE and number it 0x1.  Also, I
think the capability is not needed since userspace can expect the flags
to be 0 on older kernels.

Paolo

