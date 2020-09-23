Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A23275821
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgIWMna (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 08:43:30 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45586 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726130AbgIWMna (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 23 Sep 2020 08:43:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600865009;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tuk6dAmFoIhJ7ZB+Jfr9nrTvwW81F8MtBWAMn/4WSe8=;
        b=GyliSPy3TJzbeZXKXtrUg3RUQXLOPNaqKSkKK8n6VP2Qgo9tDo0Sx9Bk5C8lNocjXAwDif
        MJ9Sfe6H2+Hw4H55aSBREF1ZC3+wB9UCvINWhHzbHeZNqSqqcImW0jGtcayPLE5z5gDALT
        fKlRgjNsx8Eq1bCZe/Ue0X1RXmoqRFs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-448-QP-6mofdMfq2CDadFn-Icw-1; Wed, 23 Sep 2020 08:43:27 -0400
X-MC-Unique: QP-6mofdMfq2CDadFn-Icw-1
Received: by mail-wm1-f71.google.com with SMTP id w3so2181605wmg.4
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 05:43:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tuk6dAmFoIhJ7ZB+Jfr9nrTvwW81F8MtBWAMn/4WSe8=;
        b=gyETJ375oL0WtcfbrURW6FqUpZDfEiEfBpBCquog7zSHe2KiQY/vfjm2XALOTW1oAx
         g3k4TxFPDnH4YORpWwuFmaMc7EmrGyHS6kE6QdrHH7w/ZYeTj9isOIo4b0rPkYBdkVvM
         Yce5accn/CHXtaDIsKsizRnpJ/OKkpNo5cvzh6p4kEsIiHsmwk3KooNWh3OlHKu1R7gO
         6XCnqjZtg9KpEpXOUAIieKMKVoc+EVUNT1qZ5A9uTtGrB4mR1r4kWMjAAajmHTXNhOJy
         WjELObVBev30mDQPjATWqUafh4+kmsfhgG3nBvPWtkfai+UmsfV11zEjMpPuifh3qvnA
         rJRg==
X-Gm-Message-State: AOAM530WPFMQR2mjo6zJvdaghLqIjuD11bc8r5WBEIpNztAxU2K/ffkD
        SEdFl6xcqLAJyJ2n8qPke5tfcRhgOWXTSab6r5+lUs4UmiiVkDnnWmXIwDhH0J3fOIMl3CW+Vem
        c/XZozb4gMeGG
X-Received: by 2002:a1c:4187:: with SMTP id o129mr6205690wma.113.1600865006349;
        Wed, 23 Sep 2020 05:43:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7Ke3U7ksa+AtG5AgcqNxDZMOwwmv8ZRzG1SiJiS5vgyYkHBn80SzwfbEt4yoS144hPlkuZA==
X-Received: by 2002:a1c:4187:: with SMTP id o129mr6205673wma.113.1600865006094;
        Wed, 23 Sep 2020 05:43:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:15f1:648d:7de6:bad9? ([2001:b07:6468:f312:15f1:648d:7de6:bad9])
        by smtp.gmail.com with ESMTPSA id z11sm30383948wru.88.2020.09.23.05.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Sep 2020 05:43:25 -0700 (PDT)
Subject: Re: [PATCH 0/3] i386/kvm: Assume IRQ routing is always available
To:     Eduardo Habkost <ehabkost@redhat.com>, qemu-devel@nongnu.org
Cc:     Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Sergio Lopez <slp@redhat.com>, kvm@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Marcelo Tosatti <mtosatti@redhat.com>
References: <20200922201922.2153598-1-ehabkost@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <68fe355a-10de-0810-f001-46a4f9d8f3f2@redhat.com>
Date:   Wed, 23 Sep 2020 14:43:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200922201922.2153598-1-ehabkost@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/09/20 22:19, Eduardo Habkost wrote:
> KVM_CAP_IRQ_ROUTING is available since 2019 (Linux v2.6.30), so
> we can safely assume it's always present and remove some runtime
> checks.
> 
> Eduardo Habkost (3):
>   i386/kvm: Require KVM_CAP_IRQ_ROUTING
>   i386/kvm: Remove IRQ routing support checks
>   i386/kvm: Delete kvm_allows_irq0_override()
> 
>  target/i386/kvm_i386.h |  1 -
>  hw/i386/fw_cfg.c       |  2 +-
>  hw/i386/kvm/apic.c     |  5 ++---
>  hw/i386/kvm/ioapic.c   | 33 ++++++++++++++++-----------------
>  hw/i386/microvm.c      |  2 +-
>  hw/i386/pc.c           |  2 +-
>  target/i386/kvm-stub.c |  5 -----
>  target/i386/kvm.c      | 17 +++++------------
>  8 files changed, 26 insertions(+), 41 deletions(-)
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

