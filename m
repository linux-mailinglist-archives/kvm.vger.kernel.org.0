Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 244A036303E
	for <lists+kvm@lfdr.de>; Sat, 17 Apr 2021 15:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236355AbhDQNXx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 17 Apr 2021 09:23:53 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:54153 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234904AbhDQNXr (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sat, 17 Apr 2021 09:23:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618665800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yw4f9VhSLXXjilbd0IdU8Ck10pIC4eDkCvAmZBVAhG8=;
        b=EAAz0oigrhNBX55vcauKnN5Ba2Leto7RrLNRT95eETDpCEZeHtP3R5DlBD2gX01vvOh0qA
        WlYDG82Bqv0hbPsN4l4PN+oeYQ2G4Og0UkQdwry12JxC27DH/mY48x9bDWW6aSYQmwU8kA
        5PJ4GcEoZf8Q52ki2mm2qAcnShPaqJI=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-285-lJoKVS5LMMSxYJCcD0fOKA-1; Sat, 17 Apr 2021 09:23:18 -0400
X-MC-Unique: lJoKVS5LMMSxYJCcD0fOKA-1
Received: by mail-ed1-f70.google.com with SMTP id k20-20020aa7d2d40000b0290382b9d237d6so8651018edr.17
        for <kvm@vger.kernel.org>; Sat, 17 Apr 2021 06:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yw4f9VhSLXXjilbd0IdU8Ck10pIC4eDkCvAmZBVAhG8=;
        b=cpeLxD3NvEt7zr/ZOdlI9US1TA5fXwCUB0aG0gGJ0+QvgX0CEck+4ztP3sQLkkq02b
         r78G/1DZDgRmIBjZukGEfSgQdD450vlSQchgFEwL3tuL78634xKg6+spE0lEqiod3STA
         dmIpZK3D6877EpSBPAKLjcDQXP5H0D2uB+hARQRVsZ5bdxtMkNZgEaxffRsEPkQp72CD
         XIM4879KdklIBnGYdfSnak16GR/Hy8fVWZ0Yyz+KoS3rYOhwXiWR256zhVbzekjd6+jr
         HDoBk9EQgfMMmasVzH7dZ4Iu+yaxDYgwcjXZGyt4quxrLm1TKgEbVT4LAIlPWw3aMeVH
         CR1A==
X-Gm-Message-State: AOAM532Dhe26tezmkMVKLcpkkFczyYyfwqRR4Sid4LMaBQFYov0dwSi5
        zp8syvqTpbH5nPLhLJNZ4BU/swq37QRk9ZF81D8HlRaf3Rah2TFNVWm21xO3jOKHthxoj//macI
        6Y7HTLobZ1Aiq
X-Received: by 2002:a05:6402:30a3:: with SMTP id df3mr1872148edb.230.1618665797759;
        Sat, 17 Apr 2021 06:23:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL6auAjlxcSnKoUJ3m9fol+gzEWBwhJEWW+ep+Ef3WHVkpTmoMhEHYolklG1TwSW06UNPrbw==
X-Received: by 2002:a05:6402:30a3:: with SMTP id df3mr1872123edb.230.1618665797611;
        Sat, 17 Apr 2021 06:23:17 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id d21sm6393214ejz.14.2021.04.17.06.23.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Apr 2021 06:23:17 -0700 (PDT)
Subject: Re: [PATCH v6 03/10] KVM: selftests: Use flag CLOCK_MONOTONIC_RAW for
 timing
To:     Yanan Wang <wangyanan55@huawei.com>,
        Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ben Gardon <bgardon@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Peter Xu <peterx@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com
References: <20210330080856.14940-1-wangyanan55@huawei.com>
 <20210330080856.14940-4-wangyanan55@huawei.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <1f892f30-1a72-1bcb-462f-b3d6f2bababb@redhat.com>
Date:   Sat, 17 Apr 2021 15:23:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210330080856.14940-4-wangyanan55@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/03/21 10:08, Yanan Wang wrote:
> In addition to function of CLOCK_MONOTONIC, flag CLOCK_MONOTONIC_RAW can
> also shield possiable impact of NTP, which can provide more robustness.
> 
> Suggested-by: Vitaly Kuznetsov<vkuznets@redhat.com>
> Signed-off-by: Yanan Wang<wangyanan55@huawei.com>
> Reviewed-by: Ben Gardon<bgardon@google.com>
> Reviewed-by: Andrew Jones<drjones@redhat.com>

I'm not sure about this one, is the effect visible?

Paolo

