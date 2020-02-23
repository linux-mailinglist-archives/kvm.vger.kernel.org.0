Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE981696BE
	for <lists+kvm@lfdr.de>; Sun, 23 Feb 2020 09:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbgBWIMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 23 Feb 2020 03:12:25 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:50937 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725980AbgBWIMZ (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 23 Feb 2020 03:12:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582445543;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BwYUjK8HxtbAMJrKBooyAEULF1GvPByjvn4wuyM0RUU=;
        b=D8C1rbA1eYIaxuTmhRiR1Hbgy3BQvZkK/Yq1QxsPG4MyDIPrckWRBbQomt/nprbFUez6wL
        A1VdxEvbUkb19JZV/784FT1xLhNVVuDWYMePyW/3ac4mZmTjq1y8np+fGYjJP1VA4JpARl
        afLqoZ4hWSQZ1fGvIUNUs+SRBqHnizs=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-324-gOhX6HGkOIeR5A6j9vbt1Q-1; Sun, 23 Feb 2020 03:12:21 -0500
X-MC-Unique: gOhX6HGkOIeR5A6j9vbt1Q-1
Received: by mail-wr1-f71.google.com with SMTP id d9so435969wrv.21
        for <kvm@vger.kernel.org>; Sun, 23 Feb 2020 00:12:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BwYUjK8HxtbAMJrKBooyAEULF1GvPByjvn4wuyM0RUU=;
        b=nGnRIlOXT5UsYz2qAYMunv56ON+7FBd//l8xUyct5+3C9e6M3Fz4xR907Ue/o1J5TE
         bmUfeVvafq4EGN//oVMMvzhBY5HVgt4MLdYScjSAbKYHRR8B6MtN9WohKkiP7NxeiP9C
         orQFfKilK0iI9EN1qGpBxs2RH+3loBnkK4jdXNFGD81obqA7xBJ1oZzO9Z5i1Si+qQgD
         CVcA91QMP99SjXSqVWovBMyPXq7tRYFp8/Wyz71g61KR7ipTrsrc4GIBDclnj8gTa226
         xxQugYvxA6pWhh6y1FLblgGSPJjXO934zlczgnbdt/le1usDC4E+/8Vvb+BBCL4VrEog
         4gBw==
X-Gm-Message-State: APjAAAVSlBSzhHku+DATb2ccBp02QzXJvA2i32r7GyfRHC1kzLEpxLXf
        T7tYDsM1tgo3KR4mJYcTEUz85k6rGvUP2rnr4jh9atM6WYPv8hTYOIWUzW14mNtD1NXHJAT6gga
        XLNdEVIpM6toe
X-Received: by 2002:adf:eec3:: with SMTP id a3mr56070671wrp.337.1582445540717;
        Sun, 23 Feb 2020 00:12:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqwOZ/DYXl+XcdxcNcioYWjyDgY1O/v59EztMIj07VWdCsNv6wIcLG+8kygyVI/R+698U9QzxQ==
X-Received: by 2002:adf:eec3:: with SMTP id a3mr56070638wrp.337.1582445540426;
        Sun, 23 Feb 2020 00:12:20 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:ec41:5e57:ff4d:8e51? ([2001:b07:6468:f312:ec41:5e57:ff4d:8e51])
        by smtp.gmail.com with ESMTPSA id g10sm369900wrr.13.2020.02.23.00.12.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Feb 2020 00:12:18 -0800 (PST)
Subject: Re: [PATCH 5/7] docs: fix broken references for ReST files that moved
 around
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Corentin Labbe <clabbe.montjoie@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <cover.1582361737.git.mchehab+huawei@kernel.org>
 <df38697632818443686a52340d6b38ef83cb0654.1582361738.git.mchehab+huawei@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a180d8c2-c51f-900f-0328-cba4dd29f521@redhat.com>
Date:   Sun, 23 Feb 2020 09:12:18 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <df38697632818443686a52340d6b38ef83cb0654.1582361738.git.mchehab+huawei@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/02/20 10:00, Mauro Carvalho Chehab wrote:
>  Documentation/virt/kvm/mmu.rst                      | 2 +-
>  Documentation/virt/kvm/review-checklist.rst         | 2 +-
>  arch/x86/kvm/mmu/mmu.c                              | 2 +-
>  include/uapi/linux/kvm.h                            | 4 ++--
>  tools/include/uapi/linux/kvm.h                      | 4 ++--

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

