Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D5273E8A0B
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 08:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234609AbhHKGK2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 02:10:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47264 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234501AbhHKGK1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 02:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628662204;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Lt7s6a/ADOsLO3OlJslpQTleS5qgFcdo019Iim0BZnY=;
        b=T/QBgTuowrlNGm8NI7gdLXxC+a8kLB2St0BxPKD3wm2uzEUbeRT7Fwj7DzY27P9F1FDhu+
        M25G3jWnNkBrit3I8D6vKjChasfSGfSrJuOLa8WYU9s1MfP0pV1ks1Ip6SEZQ8R+Gg+58G
        3cZXvbhhFuC3vXovccpFBREqg8fZH0Q=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-NiOgtYwMO7OLi3MuzXGRNg-1; Wed, 11 Aug 2021 02:09:58 -0400
X-MC-Unique: NiOgtYwMO7OLi3MuzXGRNg-1
Received: by mail-wr1-f71.google.com with SMTP id z10-20020a5d440a0000b0290154e0f00348so353933wrq.4
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 23:09:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lt7s6a/ADOsLO3OlJslpQTleS5qgFcdo019Iim0BZnY=;
        b=IPZyaX8ev3yerWKL0YWod8jbxVJpWQ/libzwVEeGXDWTdORjez0cSL4ZQBVphEAQVk
         WwiwbOz2OiPAIxFoBIPg2RgxL1oxOTHOT4pVR/K6DepclfJvxnamtxZlCZ5zCj6BIhw4
         vkoB5SgaKk89LaTurhfDQPiPL76HUNk2/X6v1zqX24OreM9ERq4cE+bYzWiE193LkwCF
         YxA5kusFBz/o/jOPfLkc/mBbXfVjFwA0e1zzOqRLoibmOcLLX+OeDiUxkmyE7mMXBlfA
         AUYC8HalY082lD03ShmJBwzXrXyvfAv/y11mmEfecDbmRxDnlFwd5g2nJ8y5Fb2Kb7qS
         oMWg==
X-Gm-Message-State: AOAM530I+gv/3vigcNYDuM6/PhqgsR0QoyppMYnZnwfVtc4ByaMIEriY
        RJzo5eAxoDU0VMP1jmf4VghBqcb69ne8AU7drLTsPefZXGRHe6haSvmk16R0+SIRiEHYfaZHBgS
        HcgE5zNO+xtd5
X-Received: by 2002:a7b:c041:: with SMTP id u1mr25265964wmc.95.1628662197576;
        Tue, 10 Aug 2021 23:09:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxAjRPWrxT2VPV0q6Mq4630l0CqJLrcYde5bLE6JqFuzM5k1RpHnY4jVZWpcU2E+dDNhKzYiw==
X-Received: by 2002:a7b:c041:: with SMTP id u1mr25265946wmc.95.1628662197428;
        Tue, 10 Aug 2021 23:09:57 -0700 (PDT)
Received: from thuth.remote.csb (nat-pool-str-t.redhat.com. [149.14.88.106])
        by smtp.gmail.com with ESMTPSA id k31sm7171198wms.31.2021.08.10.23.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 23:09:56 -0700 (PDT)
Subject: Re: [PATCH v12] qapi: introduce 'query-x86-cpuid' QMP command.
To:     Eduardo Habkost <ehabkost@redhat.com>,
        Markus Armbruster <armbru@redhat.com>
Cc:     Valeriy Vdovin <valeriy.vdovin@virtuozzo.com>,
        qemu-devel@nongnu.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Eric Blake <eblake@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Laurent Vivier <lvivier@redhat.com>, kvm@vger.kernel.org,
        Denis Lunev <den@openvz.org>,
        Vladimir Sementsov-Ogievskiy <vsementsov@virtuozzo.com>
References: <20210728125402.2496-1-valeriy.vdovin@virtuozzo.com>
 <87eeb59vwt.fsf@dusky.pond.sub.org>
 <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
From:   Thomas Huth <thuth@redhat.com>
Message-ID: <2191952f-6989-771a-1f0a-ece58262d141@redhat.com>
Date:   Wed, 11 Aug 2021 08:09:55 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210810185644.iyqt3iao2qdqd5jk@habkost.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/08/2021 20.56, Eduardo Habkost wrote:
> On Sat, Aug 07, 2021 at 04:22:42PM +0200, Markus Armbruster wrote:
>> Is this intended to be a stable interface?  Interfaces intended just for
>> debugging usually aren't.
> 
> I don't think we need to make it a stable interface, but I won't
> mind if we declare it stable.

If we don't feel 100% certain yet, it's maybe better to introduce this with 
a "x-" prefix first, isn't it? I.e. "x-query-x86-cpuid" ... then it's clear 
that this is only experimental/debugging/not-stable yet. Just my 0.02 €.

  Thomas

