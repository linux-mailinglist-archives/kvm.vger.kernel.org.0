Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BAD3AD131
	for <lists+kvm@lfdr.de>; Fri, 18 Jun 2021 19:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbhFRRel (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Jun 2021 13:34:41 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54800 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234292AbhFRRef (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Jun 2021 13:34:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624037545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5O7zgLDKRYY6G6eiJkRemhZqC/jfLI1t6/bNmPfwOko=;
        b=SiwHt1TWx9YT9qJQ4ybyWtsvn2/TyZzZFVV3xWokfC5IwQBam8N++M7AhuzlNNnTnJsS0Q
        raW8xJ3qbhq9JGcSRNPcGtdQ59WohDW5jcl3MgReFgpyxj5yoTANeneJDAlmMd83XjKvT2
        c1iAM1E0gjzMMYNXJODvvY7yI8DKolQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-442-0sW04295MLqbTAlwD2wW0g-1; Fri, 18 Jun 2021 13:32:24 -0400
X-MC-Unique: 0sW04295MLqbTAlwD2wW0g-1
Received: by mail-wr1-f72.google.com with SMTP id d9-20020adffbc90000b029011a3b249b10so4638057wrs.3
        for <kvm@vger.kernel.org>; Fri, 18 Jun 2021 10:32:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5O7zgLDKRYY6G6eiJkRemhZqC/jfLI1t6/bNmPfwOko=;
        b=AednLG0LfnCFBK7JpDMtcjuiV90N9ndic5KQbyI5lHGCfFIvzw5JB8fCXyO/JzBhEI
         B+EnzPt/NTWgnTln/LnQ22U4vULzthWPPaGenP8pwtHQMHCJcnk9D9cBg179a7tq4SmS
         UfKPUxh5PcU459GQb43tGGWcWRix8bczEhvjRddznWvo6Y+jHNcABZqVeMUXRsl8DuHz
         J7WKU7H4+1pvclU/pOuSjOehXX7nwmLKTgZ3EbTHYNJjLJkGQKqtC512ZujS/ZZ61Vl2
         crsqbp4Dp7VERCZnpuZGxPPFk0LjdpcfWy8rlLN4MRfHnEFeiP9KL8n5phV/G6+bPJID
         efXQ==
X-Gm-Message-State: AOAM531cGtJABgyINmxHhnW64rCMsmWMBZ/kbOKW0MzqwQolwMl1qmXF
        Fsot23m2YQfCYyZk/vzBgjtJfxICBYyuKiDNg75RGKiidD/IkCmHYYq5ieak5jESVz5n8qIGKPI
        ntZ9HjwJe44Hq
X-Received: by 2002:a05:600c:4f0c:: with SMTP id l12mr12803756wmq.123.1624037543251;
        Fri, 18 Jun 2021 10:32:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwRIvrPVBn+hxiSRBo4hRV62VWIMYo9rMLym4XKajEoBKkDfwNAGl6mfrU8ff+PBKKWImgFeA==
X-Received: by 2002:a05:600c:4f0c:: with SMTP id l12mr12803745wmq.123.1624037543095;
        Fri, 18 Jun 2021 10:32:23 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id g17sm12060743wrh.72.2021.06.18.10.32.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Jun 2021 10:32:22 -0700 (PDT)
To:     Michal Hocko <mhocko@suse.com>, Jim Mattson <jmattson@google.com>
Cc:     Denis Efremov <efremov@linux.com>, joe@perches.com,
        kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <0c00d96c46d34d69f5f459baebf3c89a507730fc.camel@perches.com>
 <20200603101131.2107303-1-efremov@linux.com>
 <CALMp9eSFkRrWLjegJ5OC7kZ4oWtZypKRDjXFQD5=tFX4YLpUgw@mail.gmail.com>
 <YMw2YeWHFsn+AFmN@dhcp22.suse.cz>
 <CALMp9eR9n6N5EB-nUEJPM=e2YtE3_tQBDHj0uP3T2dcGsutSCQ@mail.gmail.com>
 <YMzSM2WAmxpXIHhJ@dhcp22.suse.cz>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] KVM: Use vmemdup_user()
Message-ID: <e5db7325-90ee-aee2-413f-9c21f48b50e5@redhat.com>
Date:   Fri, 18 Jun 2021 19:32:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMzSM2WAmxpXIHhJ@dhcp22.suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/06/21 19:04, Michal Hocko wrote:
> On Fri 18-06-21 09:53:53, Jim Mattson wrote:
>> In any case, these allocations *should* be accounted, shouldn't they?
> 
> This is more of a question to maintainers. Are these objects easy to
> request by userspace without any bounds?

This particular one need not be accounted because the allocation only 
lasts for the duration of the ioctl. The allocation below in 
kvm_vcpu_ioctl_set_cpuid

      e2 = kvmalloc_array(cpuid->nent, sizeof(*e2), GFP_KERNEL_ACCOUNT);

is long term and is already accounted for.

kvm_vcpu_ioctl_set_cpuid2 should also use kvmalloc_array and 
GFP_KERNEL_ACCOUNT.  However, it wasn't doing so before this patch went 
in, either.

Paolo

