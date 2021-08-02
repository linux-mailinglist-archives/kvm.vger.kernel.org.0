Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9780D3DDE31
	for <lists+kvm@lfdr.de>; Mon,  2 Aug 2021 19:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHBRHE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Aug 2021 13:07:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40080 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhHBRHD (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 2 Aug 2021 13:07:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1627924013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V4lwMKCC7NlkG4ATSmT+uT5CYPJxY1OG3QxbgWoAHRM=;
        b=fm6W7bh9ITXL6rH3Fn1GfMX6Hpb2khuFX0YXv7mxob+LFreu8LkA+D3F4O2l3K1nl98HZZ
        A2h+IqICyls0LYCFhA5mhHFn0M/mJ9C8/nNUZztJXSkqWBJTDllOyshbmIOHH2be6Fjb0C
        TDxzfEDinJLIzWhfgDQIGVIXg69OLZE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-50-7LeN2IfKNTyu7Vfia9FLrQ-1; Mon, 02 Aug 2021 13:06:52 -0400
X-MC-Unique: 7LeN2IfKNTyu7Vfia9FLrQ-1
Received: by mail-wm1-f72.google.com with SMTP id q188-20020a1ca7c50000b0290241f054d92aso3052764wme.5
        for <kvm@vger.kernel.org>; Mon, 02 Aug 2021 10:06:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V4lwMKCC7NlkG4ATSmT+uT5CYPJxY1OG3QxbgWoAHRM=;
        b=Saj15SezAMx8DMyKG593bnzB0WXTLIAuUR7QU1IuAnGHcSHbCoH7BTDlig6ThBydVh
         gl+P7E1jz6zhO2x6mcHiO4ZWlOHN6ui6MG3NZwfeOoS1gUNbUL39RfpmgJ4LCe/bh9PC
         Io3mqGDObQ7qTxhR3H3uZ09PtbUvZo5TUX1obADBGgH6G0B4npguN+hL0XBNK8n90gEi
         MbKHPCYW7M+RJ43aUGprDy4Yzig0FQijORs5coD3194UVIsX8QvNieuBskbRQt2nE3oL
         zrgg4HwSiF0JE8MWhZwK5RN5vtPvcU4JQp03EuCwGu6DiAH8IJYZJoM2qPl6fJFFL8TC
         e5Yg==
X-Gm-Message-State: AOAM530IA6crsvoXnGY1yG4M9/XdNZeTo5mtGaTpX4Em3GVDOkke5EXK
        o5fuEc3XdEDi+ww2Pl/AX3hRrHV0cedL21eMcETW+UZsTh+7JNgh/pa3subMmarsWmxFruTkWN8
        /DssNL2nFpAOizlvy3suX4336ORnmpDfwrHrwT5xRq5xxkuFAoL8/ijxofgfq5/sd
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr18972759wro.207.1627924011259;
        Mon, 02 Aug 2021 10:06:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyo5sPteImDc9abUNEZYX0kzt1dGg74F8oz5KGqicdPKEDIqO068oh3dyWbeHS0FkMU9BubBg==
X-Received: by 2002:adf:f1c6:: with SMTP id z6mr18972742wro.207.1627924011077;
        Mon, 02 Aug 2021 10:06:51 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id j6sm10537227wmq.29.2021.08.02.10.06.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 10:06:50 -0700 (PDT)
Subject: Re: [PATCH] KVM: x86: Exit to userspace when kvm_check_nested_events
 fails
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20210728115317.1930332-1-pbonzini@redhat.com>
 <87o8am62ac.fsf@vitty.brq.redhat.com>
 <73c45041-6bb3-801c-bd80-f48b2e525548@redhat.com>
 <YQGZpPUC5TViIRih@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f309e9ff-92f3-8dd3-6c31-071e02b9c387@redhat.com>
Date:   Mon, 2 Aug 2021 19:06:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YQGZpPUC5TViIRih@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 28/07/21 19:53, Sean Christopherson wrote:
> Alternatively, what about punting all of this in favor of targeting the full
> cleanup[*] for 5.15?  I believe I have the bandwidth to pick that up.

That's fine of course.  I'll keep this in queue for the moment so that I 
can at least run Jim's testcase, but otherwise won't merge it to kvm/next.

Paolo

