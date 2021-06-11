Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D1F03A465B
	for <lists+kvm@lfdr.de>; Fri, 11 Jun 2021 18:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhFKQVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Jun 2021 12:21:17 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbhFKQVQ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 11 Jun 2021 12:21:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623428358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RDL7ttxouIIhaHWr6IKTrlhJt0/pNbx4H3jjDvgIxo4=;
        b=jK+/J8cFNERIaDG016UYBy8EJplYBKx/f4UcDNZg0ezwuncU9U8KRmtrOLho9PCFze/70o
        vX8xoPWMphAbf+/sPefV2bTPJ0CXT6/zQFxQL8J0VH4XfeJn2q6oJLqW4lgfW9JMsz96ZO
        FV1wiCufGtgJwdfZoARkUwZA9QMeSQE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-OcIpOjSIMJ-f6ITbmm0khA-1; Fri, 11 Jun 2021 12:19:16 -0400
X-MC-Unique: OcIpOjSIMJ-f6ITbmm0khA-1
Received: by mail-wr1-f71.google.com with SMTP id e9-20020a5d6d090000b0290119e91be97dso2879524wrq.1
        for <kvm@vger.kernel.org>; Fri, 11 Jun 2021 09:19:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RDL7ttxouIIhaHWr6IKTrlhJt0/pNbx4H3jjDvgIxo4=;
        b=D49/lKTUAJbI9mOQF2gfs5/S1rsDc+GtpdkYdEI2l8iY11avux6yxtv0xmjZKGkkbV
         sAnT2+ZxgxyG9eyJ1zR/tRbhfTk3RW9PJ86V7uVal9aCTTNwzKvzlmWYRoTxb0Z8y8HC
         qk3Z1hF9lnV/5VF0Y+trY9/s47ip5ofAsTcXxxpT+ffZBvJUJbskKD/1jceNnL0eHzsu
         inCKl1Z/0Es9purido+FpYr12aW394BC+FT1fwBy7AbnWtn4QGhTjEZXzMEb2LJSeFNq
         /H8HPWPnSlgbOrxxbWaPU/Amoqjs+CL8GjgnxQeAbQJ6IpjIcF2llZZsk/jHLwXDFJnE
         Z2Ow==
X-Gm-Message-State: AOAM530sZQ32RrYXVlml3sp8qUmbClPAuvV9rGNOiF9norV5yEaCJ7Wl
        WTK8YGmzOMWcmpJ/FbRssPvPTizlKBqxvqfRUM720NnXyCRfSd8X4Bv7/HX3w2eMC5Vgvx/63O3
        vMtBtAJhphFi+
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr4852383wmj.134.1623428355026;
        Fri, 11 Jun 2021 09:19:15 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyINgCDbOBo9OC8UrfvxSwKA7rBXMHFGZv2HIog3Y74jrQqfeuhH0vfLgmiy1dyQd4XDq/0HQ==
X-Received: by 2002:a7b:c1c5:: with SMTP id a5mr4852366wmj.134.1623428354871;
        Fri, 11 Jun 2021 09:19:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o18sm13192206wmh.38.2021.06.11.09.19.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 09:19:14 -0700 (PDT)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210610220026.1364486-1-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86/mmu: Calculate and check "full" mmu_role for
 nested MMU
Message-ID: <b2084f55-3ce5-57c4-f580-d6a2de6ce612@redhat.com>
Date:   Fri, 11 Jun 2021 18:19:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210610220026.1364486-1-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/06/21 00:00, Sean Christopherson wrote:
> things like the number of levels in the guest's page tables are
> surprisingly important when walking the guest page tables

Along which path though?  I would have naively expected those to be 
driven only by the context->root_level.

Paolo

