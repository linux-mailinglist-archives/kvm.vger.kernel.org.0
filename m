Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15855279375
	for <lists+kvm@lfdr.de>; Fri, 25 Sep 2020 23:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgIYVZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 25 Sep 2020 17:25:43 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:27495 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729602AbgIYVZJ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 25 Sep 2020 17:25:09 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601069108;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=riPiictfFiIPQJlTMTSKGVFjrTw+MUxj8C340DbapCg=;
        b=B3aBd+Jue2bvAbXjiEM1w6FNqfTOtmarFP/uinTcrEcl+kxzOKfW/unSbDOtcAzJ4Vp7ck
        /jYEHvh9MyybB5wHQ2yRAEsgQ9Rex7YSLqG4Szx2xt+kk0MEnOilkmht1LW+4+tRyfxtGS
        ybLhW4rKoJ+Hm0rfpmYnEYS9inxDN0g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-Jvac28q1OW-BOtrDY0X4fQ-1; Fri, 25 Sep 2020 17:25:06 -0400
X-MC-Unique: Jvac28q1OW-BOtrDY0X4fQ-1
Received: by mail-wr1-f72.google.com with SMTP id g6so1588462wrv.3
        for <kvm@vger.kernel.org>; Fri, 25 Sep 2020 14:25:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=riPiictfFiIPQJlTMTSKGVFjrTw+MUxj8C340DbapCg=;
        b=qYevBqHdUYGL0cevsbfbuRIXrRFUw7DZuwrCaErD5QjT2z99Ood81FPKg/nndDTE7S
         VfzFrTYl1X7bAhYF7QbUGf82sFFo5Q055YEeWk6XJnXIBoKtQ1/hI/sU/Xxl8DHzSdYd
         h+OY5TQ035yTJQOemO5tUrPm63bNDfQWH+Qhw83Hmpl4CCt3hWnpLOVchr98mVWK/+xW
         pvuCg3/asR9I+Gtv2UNysGqWZC8aEdOFttq/A43ddQfAqFe34Jcg6YjhIu2ycCDOsOFG
         6MEmp8LaF7AmoeT5f8iZyTqO3UYSlqoM6WjcJRTQ1rBRVqWdC00QCkd6Vjh1JoAgNqIC
         eGUA==
X-Gm-Message-State: AOAM5302xFKcoQVOcFgek7BmTjPNLosLr836rhFzGdkjaVJT0Dy61Hn3
        CUCIZfx8wSyunbT6o7uEgPloBxIPmffWVGrDNmqWH8ICtvz5djCm302hgG0QKPORIKznTybawDA
        mJ2TczMUQ1w9w
X-Received: by 2002:a7b:c345:: with SMTP id l5mr467587wmj.123.1601069105673;
        Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF2fQVEB7mP0ZwLnuAqdfMg6p/VNXOUmn9kn/+6c9aR8oV+ZoJZ2QK6RmI7vvWOd/+MBuBrQ==
X-Received: by 2002:a7b:c345:: with SMTP id l5mr467575wmj.123.1601069105475;
        Fri, 25 Sep 2020 14:25:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:ec9b:111a:97e3:4baf? ([2001:b07:6468:f312:ec9b:111a:97e3:4baf])
        by smtp.gmail.com with ESMTPSA id h2sm4282661wrp.69.2020.09.25.14.25.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2020 14:25:04 -0700 (PDT)
Subject: Re: [PATCH v2 6/8] KVM: x86/mmu: Rename 'hlevel' to 'level' in
 FNAME(fetch)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Junaid Shahid <junaids@google.com>
References: <20200923183735.584-1-sean.j.christopherson@intel.com>
 <20200923183735.584-7-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c7f7d08f-7f1e-455c-e265-c77d78eb537f@redhat.com>
Date:   Fri, 25 Sep 2020 23:25:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200923183735.584-7-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 23/09/20 20:37, Sean Christopherson wrote:
> Rename 'hlevel', which presumably stands for 'host level', to simply
> 'level' in FNAME(fetch).  The variable hasn't tracked the host level for
> quite some time.

One could say that it stands for "huge" level...  I am not too attached
to it, the only qualm is that "level" is usually used as the starting or
current level and rarely as the end level in a loop.  But then it's used
like that in __direct_map, so...

Paolo

