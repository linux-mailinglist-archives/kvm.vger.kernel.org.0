Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76ADD3CB8F4
	for <lists+kvm@lfdr.de>; Fri, 16 Jul 2021 16:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbhGPOoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jul 2021 10:44:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:50402 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240528AbhGPOoG (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 16 Jul 2021 10:44:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626446471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z8XgazHaSaFYbppKUAFPtdkOLmoZld8wNP3xTo/qIeI=;
        b=Cm/+xLLfhEUHb2LGeKqVykdsOFM2JUsT6KtbnUc2RE/jRtzd1FwBsuMHFnDZg8bFUEGLk8
        tN6mczHDVaBHtxNkXd4UJY+LzugZSa5b8Si3hL2TMXmk6KQMRvBeW5DQ3I0lBiQV2xPicp
        WZWJwsWshyuTkvd9m6s+Z28Wwt78zWs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-352-xBh7JsSsMD2ZZDeh4qspFA-1; Fri, 16 Jul 2021 10:41:07 -0400
X-MC-Unique: xBh7JsSsMD2ZZDeh4qspFA-1
Received: by mail-wm1-f72.google.com with SMTP id k8-20020a05600c1c88b02901b7134fb829so1294129wms.5
        for <kvm@vger.kernel.org>; Fri, 16 Jul 2021 07:41:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Z8XgazHaSaFYbppKUAFPtdkOLmoZld8wNP3xTo/qIeI=;
        b=lMksT4vhQVGpHXAaWI46MOH/7Mn9WVHjdDyyndQLslfk3bl50ZW8RNoB1la8GwJYqV
         BI7yO2mJuVCWJVAfoD+iJgOEArJNmcQBazP+KMhxYQQb+hhoqpkiSJT/idK+5/0qWGL8
         a84mfbdgQrBG3g0MQqcC9UmnJ/gNUF2xfvpFiHFZiGcGcCNaUjIfZ2a9e6vC0UykMkKx
         E4JRDYeWzvUY0MvNlchmPZBYHNzdjPOknXs3MgBdOVI7/l2xpwCLpoMCksOT4QKFn08x
         CjeKrOzqxovJ8VQCNVxQ+2FCNimwUEf1Efv9tgGiYMxFg2KA1Bc85/mpY2RlojkzsPWU
         Ys2w==
X-Gm-Message-State: AOAM533jiGhvL0loKBGv6kjjl38fqmV66DgvGndKj/gFtaavl8n661Uj
        B2HkDgzGrxtZoWesvYO0K64YrpXMBOP4kr8LLlemGPbFxmN3DdTZ5/qfFXOJWNK8zz88aP3rivM
        QOlfbh4hYS3Tk
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr11154054wms.50.1626446466444;
        Fri, 16 Jul 2021 07:41:06 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxWdoky2KjCr2ox5O8bhUTxWJ8ULL5wgA4y7xfyrLqCZMspJJ4SpfnI+K8oRPVEc6zZVQhJwA==
X-Received: by 2002:a05:600c:1c08:: with SMTP id j8mr11154030wms.50.1626446466168;
        Fri, 16 Jul 2021 07:41:06 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 140sm8282837wmb.43.2021.07.16.07.41.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 07:41:05 -0700 (PDT)
To:     stsp <stsp2@yandex.ru>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20210714213846.854837-1-pbonzini@redhat.com>
 <6f2305c0-77a8-42af-f5e9-2664119b6b2e@yandex.ru>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: x86: accept userspace interrupt only if no event is
 injected
Message-ID: <f6bd5b5b-2a4a-64e2-0a7b-a2bcdd3f541d@redhat.com>
Date:   Fri, 16 Jul 2021 16:41:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <6f2305c0-77a8-42af-f5e9-2664119b6b2e@yandex.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/07/21 09:27, stsp wrote:
>> +    if (kvm_event_needs_reinjection(vcpu))
>> +        return false;
>> +
> 
> kvm_event_needs_reinjection() seems
> to miss exception.pending check.
> Don't we need it too?

Yes, good point.

Paolo

