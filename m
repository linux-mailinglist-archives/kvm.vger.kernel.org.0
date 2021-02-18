Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FAC031EE4D
	for <lists+kvm@lfdr.de>; Thu, 18 Feb 2021 19:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhBRS3o (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 Feb 2021 13:29:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49754 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbhBRRJm (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 18 Feb 2021 12:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613668094;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DnXL5td/rfCWV/9goF4hFIOXRkwcCqyl6Ts3in+Jf7k=;
        b=U/2ZnvWc1pNzbVmpslPxbqHhe98t7LjHAmzqc+VPEJ+V/DdRurUeO8RxAuN0K6dZTXwx84
        Z9YsTeu8hVJHXkH2XBlSJsxPuQ/saTn7MNafOvnP1gdiFFygIncTm+kPNhJJI2eRcMh+V5
        oFNOa0tB4gpYgh5B8HeM0dVJgJK7f/E=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-qaFXBEgpNTCr05FmLvRaeg-1; Thu, 18 Feb 2021 12:08:12 -0500
X-MC-Unique: qaFXBEgpNTCr05FmLvRaeg-1
Received: by mail-wr1-f70.google.com with SMTP id e13so1261827wrg.4
        for <kvm@vger.kernel.org>; Thu, 18 Feb 2021 09:08:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DnXL5td/rfCWV/9goF4hFIOXRkwcCqyl6Ts3in+Jf7k=;
        b=Y8dozl8YWjFoYg3UPpDuCQUv+QY/jY4eRzMPgoxXvzvw44+khJFhZoECmoUFrHgQ1v
         /MTB+Bg0sCuAqTHZPSRLip6oIG8zEmsaI9NLkSfzBGNKkbTLz4dSAMtU5svmy38+Wo12
         dCOwgzMp+I1eJtI3jgSH4FnsNDqP62j7GULzzx8M9dNROQzTreDK+FKDj0nDBYFmzVxh
         IEb7W6zdD7rTYiGzreQJfw7WO1mdiQLHlu7yXh1X+PpklOnMOUPpt0xpquiB9mElhPL8
         PisVCciw3iy1ugOohNMdRkbhcTwW2GFoAb9Zfy8KwA0OEGQiOdZRseAW5Mufcnkj7u7k
         SI+w==
X-Gm-Message-State: AOAM532K+WfskjempiOjYOae1uwt8H8bU6MRf4Q/QpTLg3JhnBnY7XKz
        8DxyiyPrv6h1f6wgDoXjBX+sFXU1j7dpXVSidqscjdcLegz4/DKYA2a6WlAlXyHH797f1ny5CeC
        vnl2PhDQ+1toU
X-Received: by 2002:a05:6000:c1:: with SMTP id q1mr5409275wrx.114.1613668091041;
        Thu, 18 Feb 2021 09:08:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzW7QsKV+sfG8pky5kvnopuPoDLVp/kO709Ty1mNrxU68YKizV3qyUWGG66EB9VKJl7wZFfOw==
X-Received: by 2002:a05:6000:c1:: with SMTP id q1mr5409238wrx.114.1613668090810;
        Thu, 18 Feb 2021 09:08:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id r7sm8232164wmh.38.2021.02.18.09.08.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 09:08:10 -0800 (PST)
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
 <20210213005015.1651772-13-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 12/14] KVM: x86/mmu: Don't set dirty bits when disabling
 dirty logging w/ PML
Message-ID: <9293da48-8bad-0b70-4548-3df7931b6bee@redhat.com>
Date:   Thu, 18 Feb 2021 18:08:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210213005015.1651772-13-seanjc@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/02/21 01:50, Sean Christopherson wrote:
> This means that spurious PML entries will be created for memslots with 
> dirty logging disabled if at least one other memslot has dirty logging 
> enabled, but for all known use cases, dirty logging is a global VMM 
> control.

This is not true.  For example QEMU uses dirty logging to track changes 
to the framebuffer.

However, what you're saying below is true: after a MR_CREATE there will 
be no shadow pages, and when they are created with mmu_set_spte they 
will not have the dirty bits set.  So there's really no change here for 
the case of only some memslots having dirty logging enabled.  Queued 12 
and 13 as well then!

Paolo

> Furthermore, spurious PML entries are already possible since 
> dirty bits are set only when a dirty logging is turned off, i.e. 
> memslots that are never dirty logged will have dirty bits cleared.

