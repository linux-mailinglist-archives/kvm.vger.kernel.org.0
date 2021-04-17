Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFCA363016
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230442AbhDQMxQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 08:53:16 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56925 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236092AbhDQMxO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 08:53:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618663968;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xpi8u3rGuVt1oh/pHBvAbreNYDYIDAl7JDBjulEYZdI=;
        b=iqAwLz8FJ3YcRayZWoRPm2A1QAV4Pt6fWQSzLlM3JcZQovJ7KpI6EVUx+EYWEk9uJOsBr/
        EYYevFu2cjhgba5E2fsxOV33HhCVnk0IihvtYVksJu7XCOC745ngmW5LwAoWnpegT3Uf5E
        Gar1LIYEyt2nazNvZAK2Mi7M07gvAxc=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-466-7YQN0I90Om6oZxA1qGpg8Q-1; Sat, 17 Apr 2021 08:52:46 -0400
X-MC-Unique: 7YQN0I90Om6oZxA1qGpg8Q-1
Received: by mail-ed1-f70.google.com with SMTP id f1-20020a0564021941b02903850806bb32so2658214edz.9
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 05:52:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Xpi8u3rGuVt1oh/pHBvAbreNYDYIDAl7JDBjulEYZdI=;
        b=lFOxZ7lPibEgRPd8ExII4+haq/7Q2YQRGtOU56IxQQ123ht5Ady0UqGvABnep/yDTP
         bB+8oVcezPUtX/3W1GDi1HSCOPJLDf2nVUoYzv5O5/QAS6LdQXCnQ88DJswxdkEnnF4h
         50ZVXMYluIYFQ/7wA4r7XZmn2XK1mhsrN3WWgH1yPnuApMF+svk891vljZWFLufCgsJy
         mbTQ9dRVpsUH4WNTsV9Q2HYtRPhJbh9QqOr1AgRLeUIvgUNJ7D2U+DTfqFPB5P+lTuPX
         pSen2FnuI15/3T2SHVyO1ppOZn4UA47LWGJwCkMC+q0J+3zk8phA+kgLuEuYN8MPvXMs
         PsLA==
X-Gm-Message-State: AOAM533SZEPHykePCe++fVfc4qAVsAYdpDZZXCxYHCPWCfH3ME1sRE75
        QDNpBCtMxXuKQhYkbVTS2WQqqp3Gyu2Vpi566erpoFSsWm6K67wgJvsM3KERUTcIPP+xAyJ8p+P
        CY18aF0iqIyyt
X-Received: by 2002:a17:906:68da:: with SMTP id y26mr13241784ejr.442.1618663964878;
        Sat, 17 Apr 2021 05:52:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxTpOMr7Ij1+3mQXgHXxMH+0QmMKVahk4yLdYEs4lQyEzw/0HUv+6EV0v6H4vJbDRkDD6BlJA==
X-Received: by 2002:a17:906:68da:: with SMTP id y26mr13241776ejr.442.1618663964695;
        Sat, 17 Apr 2021 05:52:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id l9sm6156786ejz.96.2021.04.17.05.52.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 05:52:44 -0700 (PDT)
Subject: Re: [PATCH] doc/virt/kvm: move KVM_X86_SET_MSR_FILTER in section 8
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        linux-doc@vger.kernel.org
Cc:     Jonathan Corbet <corbet@lwn.net>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210316170814.64286-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e3286d6d-5b0b-9a40-072b-41f0209f2b21@redhat.com>
Date:   Sat, 17 Apr 2021 14:52:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210316170814.64286-1-eesposit@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/03/21 18:08, Emanuele Giuseppe Esposito wrote:
> KVM_X86_SET_MSR_FILTER is a capability, not an ioctl.
> Therefore move it from section 4.97 to the new 8.31 (other capabilities).

Here and in the subject I think KVM_X86_SET_MSR_FILTER should be 
replaced by KVM_CAP_PPC_MULTITCE.

Otherwise looks good, so I queued it.

Thanks,

Paolo

> To fill the gap, move KVM_X86_SET_MSR_FILTER (was 4.126) to
> 4.97, and shifted Xen-related ioctl (were 4.127 - 4.130) by
> one place (4.126 - 4.129).
> 
> Also fixed minor typo in KVM_GET_MSR_INDEX_LIST ioctl description
> (section 4.3).

