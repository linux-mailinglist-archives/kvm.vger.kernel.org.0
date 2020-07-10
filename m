Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF121BEBA
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 22:47:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgGJUre (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 16:47:34 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20189 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbgGJUrd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 16:47:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594414052;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0KyzkthEHmjk2KrhesUnqCIjW0M1liv3DtBOsmQyB8=;
        b=HljbtM8B0ktOwNW7yZn59Puj0skyEZ0kmEiCWM8bQ+UDtvISiGmXMoiVnDAlngUUcPYbuA
        0sN+HLgC6J+d3eR7xGujJThyMbupnLqc+k8ZXD6V2SvODeOg3NKWgplW7Y6GIK/NMBKSlO
        w9rKjG3SKAhzR1hCT3kg8FNgQ6FE9KI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-cPAsFZnWM1u_YqGvxY2d4g-1; Fri, 10 Jul 2020 16:47:30 -0400
X-MC-Unique: cPAsFZnWM1u_YqGvxY2d4g-1
Received: by mail-wr1-f69.google.com with SMTP id b14so7248352wrp.0
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 13:47:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F0KyzkthEHmjk2KrhesUnqCIjW0M1liv3DtBOsmQyB8=;
        b=Uoxwf6rckzgS82k7FluKRWLEtZvSFvS2pwWeS20MeHzJneHmHbSGkXh7C5XsLTgJFW
         AJepkfc5k66sclW9/3UoG7EAQXT5G6F7DvpCVmSlEGHg/dGASz4i3wPMFyvLf4U18BMf
         sBxc/DSzK0idIQV/nmvgYqbevc9GTFcuimLgMhzm3S7eJ5ZOySXeycXJ0nMEwt4EPGuS
         UvAB1453IqJp8lZvY5VwIWTWyKSDeu+GApGT9ldojpDZJD6oavjQ3Fun1vBJL8Ji8sq6
         g5oB1wooN+IrTh1tCCRItLuIwbIPOepk4fNWB3suvAPuN+t27ihboujQp1E1DIxm7Y3Q
         uR3A==
X-Gm-Message-State: AOAM530sfXQ/IweN2km696TT3tcPZnP9uHu/1l9wzU48BgOI9Ac/6kXq
        odzhBm85OEuIoiBd2UtKwYdYbgi343j8YxN+LipscFLy3hClY9kUze9O3tkXmYJHWm09GGBoMPG
        euMC6S8ReA2gm
X-Received: by 2002:a5d:6781:: with SMTP id v1mr66523553wru.383.1594414049547;
        Fri, 10 Jul 2020 13:47:29 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzLEI1j1HN09XxC7+EX5XwYHOpDo5t3AJBHJePxEBG3v88Vf5BMvZy/faXciu0K5STE1vlQbw==
X-Received: by 2002:a5d:6781:: with SMTP id v1mr66523542wru.383.1594414049277;
        Fri, 10 Jul 2020 13:47:29 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ef:39d9:1ecb:6054? ([2001:b07:6468:f312:ef:39d9:1ecb:6054])
        by smtp.gmail.com with ESMTPSA id 68sm10983394wmz.40.2020.07.10.13.47.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 13:47:28 -0700 (PDT)
Subject: Re: [kvm-unit-tests PATCH 0/4] x86: svm: bare-metal fixes
To:     Nadav Amit <namit@vmware.com>
Cc:     kvm@vger.kernel.org
References: <20200710183320.27266-1-namit@vmware.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <3f602533-600c-0ad5-4726-e2fa9a588d7c@redhat.com>
Date:   Fri, 10 Jul 2020 22:47:26 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200710183320.27266-1-namit@vmware.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 10/07/20 20:33, Nadav Amit wrote:
> These patches are intended to allow the svm tests to run on bare-metal.
> The second patch indicates there is a bug in KVM.
> 
> Unfortunately, two tests still fail on bare-metal for reasons that I
> could not figure out, with my somewhat limited SVM knowledge.
> 
> The first failure is "direct NMI while running guest". For some reason
> the NMI is not delivered. Note that "direct NMI + hlt" and others pass.
> 
> The second is npt_rw_pfwalk_check. Even after the relevant fixes,
> exit_info_2 has a mismatch, when the expected value (of the faulting
> guest physical address) is 0x641000 and the actual is 0x641208. It might
> be related to the fact that the physical server has more memory, but I
> could not reproduce it on a VM with more physical memory.

Could be much worse---and could be bugs in KVM too, though we're
definitely faring better than six months ago.

Thanks, queued patches 2-4 and sent a replacement for patch 1.

Paolo

