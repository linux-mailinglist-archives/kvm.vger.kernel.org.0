Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3223FCE35
	for <lists+kvm@lfdr.de>; Tue, 31 Aug 2021 22:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240809AbhHaUNC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Aug 2021 16:13:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44467 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232018AbhHaUM6 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 31 Aug 2021 16:12:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630440722;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KbgJ2Vu8JpD26GA6OCHo87Wy3/ZN8Be3JYXsPNbuv+A=;
        b=dPzS/KxZuvbhqgYRqmtzGrHRbSvD0TLuCiHS1J7SyxE76rzLchGZurRdyM5zrokWj84pSF
        px2Vihe9M2Iuk80XychrhRQiptqTYzJ1EKV5MtnUdowpkoh1dHjFEXF9fvuOgAtqPDEs9G
        vyi1OX5r8NzeESmSMO87HXJGRvTP0rQ=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-J4SE84o4ORqv82QtBtEHBg-1; Tue, 31 Aug 2021 16:10:43 -0400
X-MC-Unique: J4SE84o4ORqv82QtBtEHBg-1
Received: by mail-wm1-f70.google.com with SMTP id r125-20020a1c2b830000b0290197a4be97b7so114635wmr.9
        for <kvm@vger.kernel.org>; Tue, 31 Aug 2021 13:10:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KbgJ2Vu8JpD26GA6OCHo87Wy3/ZN8Be3JYXsPNbuv+A=;
        b=eYBa1Azdv6eKNYPdIRr+ngb+UyiFQZfJgvIyu+LXjo7ZwwoebPabhmnAeRsTPNJ/EY
         wBf4o24TY9QZPugfxcMERFEgbxdF5XskxM2wYDyhS6lK2lExUhTVNFE/sSDttClZqF9b
         j/97YL22JtslTfIHE1wWThz6pTEuBHAXGS5MYRrCOmyFl/xsdAeWv0HFJSutqUxhM52c
         Nd/7njVnmwS5MYRhSkXvBchKX3QkFvPVBZMqW/ZWpgQBAppQk4bCBiyBiuRdpWdQO7CD
         tglazDan60gjhWfeEIw1dthE6BTPjPxrnw0nfn0nuggh0Blohk4Jrj2v9dic0Z0owjzt
         rYVQ==
X-Gm-Message-State: AOAM531e7caPisWbM9k3Cg6YBO/gfzjwYihxH2oYoaR05PVE6H1fIoNi
        hI4E+skNjFfYdPONNlv1m6XltSFLw5GMXa00kNVGmK7//zsNwvNrV2YC2taKnOkcAiGfwM4hqPF
        +o7oP06KifseV
X-Received: by 2002:adf:edc2:: with SMTP id v2mr33399005wro.255.1630440642151;
        Tue, 31 Aug 2021 13:10:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFHxJK6CuUyH4fIACh8WCgho8ld2f48k7iz12CJXT9s8M02Pmju/iUqJTv/KchgQNGbkL+Og==
X-Received: by 2002:adf:edc2:: with SMTP id v2mr33398977wro.255.1630440641934;
        Tue, 31 Aug 2021 13:10:41 -0700 (PDT)
Received: from [192.168.3.132] (p4ff23bf5.dip0.t-ipconnect.de. [79.242.59.245])
        by smtp.gmail.com with ESMTPSA id u23sm3315346wmc.24.2021.08.31.13.10.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 13:10:41 -0700 (PDT)
Subject: Re: [GIT PULL] virtio: a last minute fix
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc:     KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Carpenter <dan.carpenter@oracle.com>, david@redhat.com,
        dverkamp@chromium.org, hch@lst.de, jasowang@redhat.com,
        liang.z.li@intel.com, mst@redhat.com, tiny.windzz@gmail.com,
        jasowang@redhat.com
References: <20210829115343-mutt-send-email-mst@kernel.org>
 <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
Message-ID: <6aaa0ca9-61ed-7ea3-de61-56dcd04ce88b@redhat.com>
Date:   Tue, 31 Aug 2021 22:10:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wjYkPWoQWZEHXzd3azugRO4MCCEx9dBYKkVJLrk+1gsMg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 29.08.21 20:11, Linus Torvalds wrote:
> On Sun, Aug 29, 2021 at 8:53 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>>
>> Donnu if it's too late - was on vacation and this only arrived
>> Wednesday. Seems to be necessary to avoid introducing a regression
>> in virtio-mem.
> 
> Heh. Not too late for 5.14, but too late in the sense that I had
> picked this one up manually already as commit 425bec0032f5
> ("virtio-mem: fix sleeping in RCU read side section in
> virtio_mem_online_page_cb()").

Thanks Michael for sending this last minute and thanks Linus for picking 
it up independently early! Awesome :)

-- 
Thanks,

David / dhildenb

