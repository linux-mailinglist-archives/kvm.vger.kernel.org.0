Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4384369AC
	for <lists+kvm@lfdr.de>; Thu, 21 Oct 2021 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbhJURuK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Oct 2021 13:50:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:59830 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232335AbhJURt5 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 21 Oct 2021 13:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634838461;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RBfAVrB74SlDq2h9NJPSX6K7Aqze9lO+g3JyEdnqq0o=;
        b=E4hIKrS5rjh/W4UzlCxkmELBnpPg5xCrIbULgCbP99RIKUUknLCCgi4aJjpAQbI0ss84a1
        qEr78jVzBFHCfDKsU/kVb1m8OYeS+MXhOhTYfwjY5z0EwonEnmXCMX9JhaZ9TQPZ/QShQ4
        zthxJHXFBk/ton3KIcERmNKlEmyYGN0=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-0jiXHdslOV-Qw0PsdHL0IA-1; Thu, 21 Oct 2021 13:47:39 -0400
X-MC-Unique: 0jiXHdslOV-Qw0PsdHL0IA-1
Received: by mail-ed1-f70.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so1136440edv.10
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 10:47:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=RBfAVrB74SlDq2h9NJPSX6K7Aqze9lO+g3JyEdnqq0o=;
        b=5xU2ZgzEI5sLY86nC/ab1b9C/W0xJ6ttJTOQzdVFxP7ujT2Q8GEQdftBqUOXTMa+Jx
         w2AifIwLPHtjLiuyCFHrlfrKq8OSlNn8TilNtmC3CjZ03ymwzFR5B6C1IkxeFPZ7o/RY
         KnUiROLL51yR01PTaYP1jk0y+MqvC8LCEiD3LYaCUkHoRUavm3BE6PsRAciZMme/OZgL
         GmiKUsSP8QujDz3i7Z2pSOqKTZeqrmz/jYsB4dtthlM5u62P4VlFe3nsh7zYru8pt0FB
         61tK5c5ZjMkth2GrnDotqsdO8BaQpmjhQIcvAcJOrwxTtl5l3CkwnDrSS/lGNnR2Kgfy
         b9ZQ==
X-Gm-Message-State: AOAM532jWpgaQD4awoiZ2Y9qlbOUY8M9JP7gFoQu79wxKJP9Wlhomv1z
        VIV6zvXI5/2BZeiyKWUdl2RppAwYJt2+bPhEx/OwuhnxUIa8B0tIEULhewWDXqPEWLfaUehy3fP
        PmZvPzBEa5ShK
X-Received: by 2002:a05:6402:5209:: with SMTP id s9mr9387317edd.250.1634838458467;
        Thu, 21 Oct 2021 10:47:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyozM7RYS3i1RxKK7/0nw1ZHM3yaMyHXPKQ7O7RuXaEgIeNvfeqoaeF55tmEtZS7kqr9HaGXA==
X-Received: by 2002:a05:6402:5209:: with SMTP id s9mr9387290edd.250.1634838458241;
        Thu, 21 Oct 2021 10:47:38 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id d18sm3286859ejo.80.2021.10.21.10.47.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Oct 2021 10:47:37 -0700 (PDT)
Message-ID: <435767c0-958d-f90f-d11a-cff42ab1205c@redhat.com>
Date:   Thu, 21 Oct 2021 19:47:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/8] KVM: SEV-ES: fixes for string I/O emulation
Content-Language: en-US
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     fwilhelm@google.com, seanjc@google.com, oupton@google.com
References: <20211013165616.19846-1-pbonzini@redhat.com>
In-Reply-To: <20211013165616.19846-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/10/21 18:56, Paolo Bonzini wrote:
> This series, namely patches 1 and 8, fix two bugs in string I/O
> emulation for SEV-ES:
> 
> - first, the length is completely off for "rep ins" and "rep outs"
>    operation of size > 1.  After setup_vmgexit_scratch, svm->ghcb_sa_len
>    is in bytes, but kvm_sev_es_string_io expects the number of PIO
>    operations.
> 
> - second, the size of the GHCB buffer can exceed the size of
>    vcpu->arch.pio_data.  If that happens, we need to go over the GHCB
>    buffer in multiple passes.
> 
> The second bug was reported by Felix Wilhelm.  The first was found by
> me by code inspection; on one hand it seems *too* egregious so I'll be
> gladly proven wrong on this, on the other hand... I know I'm bad at code
> review, but not _that_ bad.

Ping.

Paolo

