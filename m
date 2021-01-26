Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7D030409C
	for <lists+kvm@lfdr.de>; Tue, 26 Jan 2021 15:41:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405873AbhAZOkp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Jan 2021 09:40:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40267 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391310AbhAZOjm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 26 Jan 2021 09:39:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611671895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oe0wvqDebMI0CXdGaiTIbnTKoPtRWBVqJDqyisah7eU=;
        b=SZ9f3s1YRRkQHC2H4/8rPdhlpto0dPIaYL4qBXV2MmeyTfYid/d/5pRF+p04BitXIRtV99
        TT5veEBjQkZjs1/pXHAJZ8hfNSWrxUu7ON0JStLVrqw44eTvr91hyAjzp1ZtJBPV1A1ttQ
        zVJNMHorCUIVNPdLzeG2lMaacDvzEKY=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-27-ARhLfyYBMCqNCA0EeBVj2A-1; Tue, 26 Jan 2021 09:38:12 -0500
X-MC-Unique: ARhLfyYBMCqNCA0EeBVj2A-1
Received: by mail-ed1-f72.google.com with SMTP id r4so9434288eds.4
        for <kvm@vger.kernel.org>; Tue, 26 Jan 2021 06:38:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oe0wvqDebMI0CXdGaiTIbnTKoPtRWBVqJDqyisah7eU=;
        b=BMexZeR0dUnxIF1B2DZAcJ25g/STWE5pSQu4yif8ln1ALLzM3UCDMeR8qE+YiOD/xE
         Uxqo2MmGpsk4TfJ0Zlukg/Kbnf5WLEAtauqDbK2hGFEa4Lkvf6oVBBsaQdbO6YTuhl8Z
         w4xJrN5YSvs4D6bOapISPC+Kt0vWQUh3zvuTdp4S51JNk8/nyuJW0fh6iOlHMU8vXaDu
         xe5bMs/Op2u0oRuoF7Rf5WlmXvHVRsrvgb33Hz/at71kxd10u5AkeeFb8RopVZ/z+Snx
         VpJcPaRLHPurdtAFpft2oJY6C5mzauEArEYkQZA7ds/qKzxQzk7h2I4Tr6o1X1m+MaVm
         i2JQ==
X-Gm-Message-State: AOAM533snCHdFDH2mJHCdJiEjMwOaNkPRzgDVE5svd7690rjpi0f8tnP
        RrKB1QfJfsT+LhO3LN6VutRXpu9X9BOJKNJqvdtzRz1MsH3rjAKkkxXL0QoBfsh7MXjBmXt4agb
        A2YSxUcZb8WAm
X-Received: by 2002:a17:907:2851:: with SMTP id el17mr3445307ejc.405.1611671891323;
        Tue, 26 Jan 2021 06:38:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwQ4GBnxdpp/J9Y1B6D0WQXhMe0svsRoxYvq0qLC77MuBwovQsJGin47Xvchi8pU47I84DrNQ==
X-Received: by 2002:a17:907:2851:: with SMTP id el17mr3445302ejc.405.1611671891185;
        Tue, 26 Jan 2021 06:38:11 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h12sm9956507ejf.95.2021.01.26.06.38.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 06:38:10 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Peter Xu <peterx@redhat.com>, Peter Shier <pshier@google.com>,
        Peter Feiner <pfeiner@google.com>,
        Junaid Shahid <junaids@google.com>,
        Jim Mattson <jmattson@google.com>,
        Yulei Zhang <yulei.kernel@gmail.com>,
        Wanpeng Li <kernellwp@gmail.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>
References: <20210112181041.356734-1-bgardon@google.com>
 <20210112181041.356734-16-bgardon@google.com> <YAjIddUuw/SZ+7ut@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 15/24] kvm: mmu: Wrap mmu_lock cond_resched and needbreak
Message-ID: <460d38b9-d920-9339-1293-5900d242db37@redhat.com>
Date:   Tue, 26 Jan 2021 15:38:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YAjIddUuw/SZ+7ut@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21/01/21 01:19, Sean Christopherson wrote:
> What if we simply make the common mmu_lock a union? The rwlock_t is 
> probably a bit bigger, but that's a few bytes for an entire VM. And 
> maybe this would entice/inspire other architectures to move to a similar 
> MMU model.

Looking more at this, there is a problem in that MMU notifier functions 
take the MMU lock.

Yes, qrwlock the size is a bit larger than qspinlock.  However, the fast 
path of qrwlocks is small, and if the slow paths are tiny compared to 
the mmu_lock critical sections that are so big as to require 
cond_resched.  So I would consider just changing all architectures to an 
rwlock.

Paolo

