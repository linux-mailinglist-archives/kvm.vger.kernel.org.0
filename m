Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A57D3EF038
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 18:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbhHQQdW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 12:33:22 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:40374 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229477AbhHQQdV (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 12:33:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629217967;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AwlQ32nbtd+hjp/fxoi8kJbjSm7VsIyjZaetwBPpk0Y=;
        b=L3mX7e/3FQ07dNfGdveW1MZDCWWeirp0c+Fb/AQYWN8tPmgdjM8OG8dG7/0uJngS2rVe00
        G6KkwIX7ZDerI+ewqxDZ629rnF5AGue1UXBY5RHGNH7SbQB41Dzk9hcWXyz3pjlI4emwMJ
        CIRewr6yc+R1PTPSRlbKzYAvDjeQk+s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-118-whk63u52Nf-yYNrHWQVqzw-1; Tue, 17 Aug 2021 12:32:46 -0400
X-MC-Unique: whk63u52Nf-yYNrHWQVqzw-1
Received: by mail-wm1-f71.google.com with SMTP id f19-20020a1c1f13000000b002e6bd83c344so946596wmf.3
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 09:32:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AwlQ32nbtd+hjp/fxoi8kJbjSm7VsIyjZaetwBPpk0Y=;
        b=eMC53UUZXcMz2IH/4Aw+Y53K7ZP67OlUdKBPZjgogk8xl0cck2paWoipV71AOBhlzd
         7uk0c6iBsnAo+qfvRJyFzMeMqlQI1JJ52Sd0lNpXhViaNnWjG+qnPTttxi59t4PNbJHt
         ekje6io+2sKhp+tuum7z6NZvqzL3hfLpl0f7JoBfF7TAHwZ82hKf823WpsjPc3SkiIlv
         gUlQcVs+5ipQ4vfgOYdYnA++OY+BylOrKHNWZO3C3iA1mQDKvPFHgWmx9OUgdDCU0XZF
         K4dABm7NUyZBhTH7sG+KeQClLFfme7qXSpUCBUu9TpdDmEZqKprO3Qj/QpRGBslXaBGZ
         3k1Q==
X-Gm-Message-State: AOAM533DrreB/lXiJIe+xaOlqzJuDl1RPBWFyazIrwDukjIJgJ9tGgKP
        sDqXPIvALaFGK+Hlm7QsHFtzH3C5yO4glJY+X0YJ9K/uQX/vo2pw0OmzI/ilZEWjhWNuOJp9jej
        WgoDid8QSH9upYCtK6Hsa/OA7TAA/P0EkZ4T/iBt8qMdq4eeLFXjRbhyCouUIYgrz
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr5179080wrt.226.1629217964798;
        Tue, 17 Aug 2021 09:32:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwMJCcYPUHVU8yjKtJYrLiw+Md+qWmOarkciP0cgLNxW8rE93pg1Ebun+7oZFVWBLYOcwDKKA==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr5179029wrt.226.1629217964444;
        Tue, 17 Aug 2021 09:32:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id o14sm2454877wms.2.2021.08.17.09.32.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 09:32:43 -0700 (PDT)
Subject: Re: [RFC PATCH 00/13] Add support for Mirror VM.
To:     Steve Rutherford <srutherford@google.com>,
        Ashish Kalra <Ashish.Kalra@amd.com>
Cc:     qemu-devel@nongnu.org, thomas.lendacky@amd.com,
        brijesh.singh@amd.com, ehabkost@redhat.com, mst@redhat.com,
        richard.henderson@linaro.org, jejb@linux.ibm.com, tobin@ibm.com,
        dovmurik@linux.vnet.ibm.com, frankeh@us.ibm.com,
        dgilbert@redhat.com, kvm@vger.kernel.org
References: <cover.1629118207.git.ashish.kalra@amd.com>
 <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <0fcfafde-a690-f53a-01fc-542054948bb2@redhat.com>
Date:   Tue, 17 Aug 2021 18:32:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <CABayD+fyrcyPGg5TdXLr95AFkPFY+EeeNvY=NvQw_j3_igOd6Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/08/21 01:53, Steve Rutherford wrote:
> Separately, I'm a little weary of leaving the migration helper mapped
> into the shared address space as writable.

A related question here is what the API should be for how the migration 
helper sees the memory in both physical and virtual address.

First of all, I would like the addresses passed to and from the 
migration helper to *not* be guest physical addresses (this is what I 
referred to as QEMU's ram_addr_t in other messages).  The reason is that 
some unmapped memory regions, such as virtio-mem hotplugged memory, 
would still have to be transferred and could be encrypted.  While the 
guest->host hypercall interface uses guest physical addresses to 
communicate which pages are encrypted, the host can do the 
GPA->ram_addr_t conversion and remember the encryption status of 
currently-unmapped regions.

This poses a problem, in that the guest needs to prepare the page tables 
for the migration helper and those need to use the migration helper's 
physical address space.

There's three possibilities for this:

1) the easy one: the bottom 4G of guest memory are mapped in the mirror 
VM 1:1.  The ram_addr_t-based addresses are shifted by either 4G or a 
huge value such as 2^42 (MAXPHYADDR - physical address reduction - 1). 
This even lets the migration helper reuse the OVMF runtime services 
memory map (but be careful about thread safety...).

2) the more future-proof one.  Here, the migration helper tells QEMU 
which area to copy from the guest to the mirror VM, as a (main GPA, 
length, mirror GPA) tuple.  This could happen for example the first time 
the guest writes 1 to MSR_KVM_MIGRATION_CONTROL.  When migration starts, 
QEMU uses this information to issue KVM_SET_USER_MEMORY_REGION 
accordingly.  The page tables are built for this (usually very high) 
mirror GPA and the migration helper operates in a completely separate 
address space.  However, the backing memory would still be shared 
between the main and mirror VMs.  I am saying this is more future proof 
because we have more flexibility in setting up the physical address 
space of the mirror VM.

3) the paranoid one, which I think is what you hint at above: this is an 
extension of (2), where userspace invokes the PSP send/receive API to 
copy the small requested area of the main VM into the mirror VM.  The 
mirror VM code and data are completely separate from the main VM.  All 
that the mirror VM shares is the ram_addr_t data.  Though I am not even 
sure it is possible to use the send/receive API this way...

What do you think?

Paolo

