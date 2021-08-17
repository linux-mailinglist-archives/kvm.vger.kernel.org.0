Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F0B3EE8EC
	for <lists+kvm@lfdr.de>; Tue, 17 Aug 2021 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235078AbhHQIzM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 17 Aug 2021 04:55:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35519 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234347AbhHQIzK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 17 Aug 2021 04:55:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1629190476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q7dT68S5InJZhNBx9TRr7Eqppd3kXow67HBH2rTIYNw=;
        b=VFwZz4ABAO1IiJ4ZCFy/N3T9rl7aMA082XpLoC1J0bAnwsKpwDBAxZmYQ/dpMpDVaPw0qt
        Hp4s6FLev3+/1DGj8x3EPIIRIo/bW2WTVOF/N6NVx52Hye/+LZigDIBGqkmEacMkHGWkw2
        7bVd0P8IqMaSfh4oy3WHzlSWAZWiTLg=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-576-DE_bqB72Px-mDvfb2herLA-1; Tue, 17 Aug 2021 04:54:35 -0400
X-MC-Unique: DE_bqB72Px-mDvfb2herLA-1
Received: by mail-ed1-f71.google.com with SMTP id d12-20020a50fe8c0000b02903a4b519b413so10291124edt.9
        for <kvm@vger.kernel.org>; Tue, 17 Aug 2021 01:54:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q7dT68S5InJZhNBx9TRr7Eqppd3kXow67HBH2rTIYNw=;
        b=BhAWVv3SoRp1aFx/4ryfFRNaW1a+X9PAirg2H2HlieFsRPnAJ1uiPmkscDz8hLbCTG
         kj4n5AfqAoANZ2+4UQRtGZLeIp6gvbD6bfVZqYjcxInkXPzvk5VBGsm0TAT6/sQ2E6IY
         mpmy5fK+rIwi1ThkpsMgvqAqJmvVReuawBZvOp/y7CElmn9xd+8oo/RzwbkmtXmHeiyU
         Pm/Rg1wrx4wkBgBuNBbsDbn1FClF8Uns+lZr/yCrYOgeCXCdpxx3bgkg/uSGeOSmohcY
         0M5aeykH6wfpHVA6tWAa2F3kr2W4wMbotJxURe6oBGwaNCxLItBdArkzWjMbhnPo7n57
         0R+Q==
X-Gm-Message-State: AOAM532T2FBPKPVF6Yuz4Ik7WgYROUHmb+xm2nEN4VlKVrGGGSVZLDMt
        L4f3bnndQ+GAbg4Mw8qKS2iPoYBnAI0N7OzP6k8yBbSiEj2DVBPZLZC6FQXILypV3XLhhVX0Iv9
        OvNPJzRy/aO/K
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr2755611ejc.409.1629190473902;
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzyaZzx8M+BoKRkmTA5CfaBnIow9YCTFU9Nx/CQxSA2xF72pC5gtASADBR6/oFNOwPsBO4xVA==
X-Received: by 2002:a17:906:7302:: with SMTP id di2mr2755582ejc.409.1629190473745;
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id gh23sm484905ejb.27.2021.08.17.01.54.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 01:54:33 -0700 (PDT)
Subject: Re: [PATCH 0/3] clean up interface between KVM and psp
To:     Mingwei Zhang <mizhang@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alper Gun <alpergun@google.com>,
        Borislav Petkov <bp@alien8.de>,
        David Rienjes <rientjes@google.com>,
        Marc Orr <marcorr@google.com>, Peter Gonda <pgonda@google.com>,
        Vipin Sharma <vipinsh@google.com>
References: <20210816202441.4098523-1-mizhang@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c66484d2-3524-d061-1e65-70dab0703cc3@redhat.com>
Date:   Tue, 17 Aug 2021 10:54:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816202441.4098523-1-mizhang@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 16/08/21 22:24, Mingwei Zhang wrote:
> This patch set is trying to help make the interface between KVM and psp
> cleaner and simpler. In particular, the patches do the following
> improvements:
>   - avoid the requirement of psp data structures for some psp APIs.
>   - hide error handling within psp API, eg., using sev_decommission.
>   - hide the serialization requirement between DF_FLUSH and DEACTIVATE.
> 
> Mingwei Zhang (3):
>    KVM: SVM: move sev_decommission to psp driver
>    KVM: SVM: move sev_bind_asid to psp
>    KVM: SVM: move sev_unbind_asid and DF_FLUSH logic into psp

No objections apart from the build failure on patch 1.  However, it's up 
to Tom whether they prefer this logic in KVM or the PSP driver.

Paolo

