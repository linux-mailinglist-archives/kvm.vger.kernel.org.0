Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FA1322F85
	for <lists+kvm@lfdr.de>; Tue, 23 Feb 2021 18:21:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233711AbhBWRVR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 23 Feb 2021 12:21:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:36789 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233704AbhBWRVO (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 23 Feb 2021 12:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614100788;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EsllZvb5aY/YCacxiEhrsEkqyhREKB3RZGWTsSboykY=;
        b=Hf/+WhtV55TrktYV2Ep76rnsm6czsgPAj7zRxyMri3bGnjI9KS+99uWs4rPY2M5IKE2nAD
        oyLiTb6lliJfhkOE9FZeefVVVm3swWiyyVf3BxDFUB9hf3tYLjzvrOw5DLr6waPr/8A1nV
        buY95zneiBtQIeHZcFQ3kNq94+zBDUc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-66-F-QgIzHpMcWoIr1NoCh09A-1; Tue, 23 Feb 2021 12:19:46 -0500
X-MC-Unique: F-QgIzHpMcWoIr1NoCh09A-1
Received: by mail-wr1-f71.google.com with SMTP id v18so5330143wrr.8
        for <kvm@vger.kernel.org>; Tue, 23 Feb 2021 09:19:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EsllZvb5aY/YCacxiEhrsEkqyhREKB3RZGWTsSboykY=;
        b=b3mML4eBXx2EnAPZhRZx3i5zGiNlH2Vf8nn/8620LEZq5O6F/GaogQqXheT7PCr0rB
         TGolKjESxSjREd7Wl+JJQGJhidSM2RxtgmF9VKaVGaqikczi37L5NMPnOMkr/nazbwxk
         oA73mveFDbz14WuuKxQZbhpUr6lT4xzMt+lOS9jExQ6Ye0eqwqQ0AgzD1MeC+A+WTnrX
         nkna55zjdDm3XPPfVE3Slj/7tD1wuZBYqvn9svwh3ogDqqZFmtVhXnnp7OGZUao3wLO1
         GLGgcpSiCpHOWkM5qqbt9j13wNW4SxLealjsKY9X2vfN8MPFhHT9kn+WTMISqUJxi3M6
         kO4A==
X-Gm-Message-State: AOAM530k9XK9XBfyxoUA/f6ti8CYx0ZPOvQLi/4GY1a5b6SnueepeiVj
        1vVz7DcNxEg0XK8Coh9xgBjcRMxOvEdK0y6Ut7yv3unUdK0XFjLT1tcgkAzXKooJ/KRNgYmiJhg
        i0pZK89ppistS
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr25495741wme.107.1614100784989;
        Tue, 23 Feb 2021 09:19:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyTqsbeZfswgBPjjTp7acWcwMD3JJBfE4MKCQO22zeb+8dT2melZmGj9anF8RdYT8XU3Oww2A==
X-Received: by 2002:a05:600c:2184:: with SMTP id e4mr25495729wme.107.1614100784852;
        Tue, 23 Feb 2021 09:19:44 -0800 (PST)
Received: from ?IPv6:2001:b07:add:ec09:c399:bc87:7b6c:fb2a? ([2001:b07:add:ec09:c399:bc87:7b6c:fb2a])
        by smtp.gmail.com with ESMTPSA id o124sm3591810wmo.41.2021.02.23.09.19.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 09:19:44 -0800 (PST)
Subject: Re: [PATCH 1/2] KVM: vmx/pmu: Fix dummy check if lbr_desc->event is
 created
To:     Sean Christopherson <seanjc@google.com>,
        Like Xu <like.xu@linux.intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
References: <20210223013958.1280444-1-like.xu@linux.intel.com>
 <YDU4II6Jt+E5nFmG@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <52a30738-08b5-740c-7c6e-b7a6edcbe552@redhat.com>
Date:   Tue, 23 Feb 2021 18:19:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <YDU4II6Jt+E5nFmG@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/02/21 18:15, Sean Christopherson wrote:
> If event
> creation fails in that flow, I would think KVM would do its best to create an
> event in future runs without waiting for additional actions from the guest.
> 
> Also, this bug suggests there's a big gaping hole in the test coverage.  AFAICT,
> event contention would lead to a #GP crash in the host due to lbr_desc->event
> being dereferenced, no?

Yes, testing contention would use the tools/testing/selftests/kvm 
framework rather than just kvm-unit-tests.

Paolo

