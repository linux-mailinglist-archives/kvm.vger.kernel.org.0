Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9531C69F7
	for <lists+kvm@lfdr.de>; Wed,  6 May 2020 09:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbgEFHW6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 May 2020 03:22:58 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:22943 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726451AbgEFHW6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 6 May 2020 03:22:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588749777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PAQFi5DmAuxLAp4Qxu8jHGyEya4c8hpKA4inepD4zvw=;
        b=NKaONBsjNpx/s49Ef1WoqP7ofvoNIYWvQO2s4SsO3U06NQ2YddU7hRHfD4R1RiOnTDnEMJ
        0T98cO8S5vxn1vhFuZZxDi0wnbUtc8zwfBMMMpL70qCGyGmPZ441rku+cTnQjShqW/5C0Z
        HN+cdrDKPZJWdje/xupTPfv7B8H8Vs4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-172-578HvLSWNlynXV00ztaB0g-1; Wed, 06 May 2020 03:22:55 -0400
X-MC-Unique: 578HvLSWNlynXV00ztaB0g-1
Received: by mail-wr1-f70.google.com with SMTP id e14so848249wrv.11
        for <kvm@vger.kernel.org>; Wed, 06 May 2020 00:22:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PAQFi5DmAuxLAp4Qxu8jHGyEya4c8hpKA4inepD4zvw=;
        b=Mky9ZlnOu+OFyhR2OLoKdy2/WAy7Sc1BbNXc/WSy877Ce9ZtyL/o4ukUATtAHBWqbw
         j2D7kPYKiNszFtxmKscPf4HyBVba6mOcWC/Knq8lz+aLRp9Kcjw5u3qH7VB9gjAFgLZw
         rYJtvCtLhaaAXC7tztMs5gtAQHpvBpFeZcX5zmQzYnGeklzvcBt59s21t+eMpn+g7jrZ
         IwY6dXV1oKFRhFqI2Fa11JwJLPx95cRfVcB7jWA3BLHKHuwreL65Hz/NEmVVhM9q4Q2o
         aLgzqduxtv4Xlxni4xx5hYKKksiGd8b138Xcr74m+75qBOP6NZIQcVPVto3rWrrnRYBK
         Qqkg==
X-Gm-Message-State: AGi0PubJKNaxz/HWfqm7MUFzznCpEOdWFVaHhmnYkz5uSizjhPqTu9Ij
        shKgxPnE6igKkP/i61Nho8X6kH4tVC/Q00n3tXVJjR3wXu3z/nQbdafycbuGzYN2Tr8ocHRVvTc
        FnShLeGWRomRJ
X-Received: by 2002:a7b:c10d:: with SMTP id w13mr2807026wmi.78.1588749774596;
        Wed, 06 May 2020 00:22:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypKjqbWk3J+KT20Dfvh+mDhrG00ULi4I4teLGNNxi48vnUTP/k2QiQ89DPaMCmFhJxFulfh75Q==
X-Received: by 2002:a7b:c10d:: with SMTP id w13mr2807008wmi.78.1588749774359;
        Wed, 06 May 2020 00:22:54 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:11d7:2f21:f38b:17e? ([2001:b07:6468:f312:11d7:2f21:f38b:17e])
        by smtp.gmail.com with ESMTPSA id o6sm1283509wrw.63.2020.05.06.00.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 00:22:53 -0700 (PDT)
Subject: Re: [PATCH kvm-unit-tests] KVM: VMX: add test for NMI delivery during
 HLT
To:     Andrew Jones <drjones@redhat.com>
Cc:     kvm@vger.kernel.org, Cathy Avery <cavery@redhat.com>
References: <20200505160512.22845-1-pbonzini@redhat.com>
 <20200506065816.tzl4jytqt3oxhfdq@kamzik.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <80f5c1f6-3c4f-a300-4a1e-10694618b704@redhat.com>
Date:   Wed, 6 May 2020 09:22:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506065816.tzl4jytqt3oxhfdq@kamzik.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/05/20 08:58, Andrew Jones wrote:
> On Tue, May 05, 2020 at 12:05:12PM -0400, Paolo Bonzini wrote:
>> From: Cathy Avery <cavery@redhat.com>
>>
>> Signed-off-by: Cathy Avery <cavery@redhat.com>
>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>> ---
>>  x86/vmx_tests.c | 120 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 120 insertions(+)
> 
> Much of this patch is using four space indentation instead of tabs.

Hmm, true -- because it's copied from svm_tests.c which uses 4 spaces.
I'll adjust it.

Paolo

