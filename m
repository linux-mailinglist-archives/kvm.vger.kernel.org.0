Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB923A77CD
	for <lists+kvm@lfdr.de>; Tue, 15 Jun 2021 09:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229960AbhFOHSM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Jun 2021 03:18:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:37689 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229488AbhFOHSK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 15 Jun 2021 03:18:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623741366;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A0q6Xx4brx+c25Twsh66TttRM2bYGQLJmZoJQKNwuOw=;
        b=QyBYmFPGP9J9PcUwzmqf51ug+KnLsUI5zWms4oOfindgA/hZRp9AYs5NDCTowdjJ6hUOYr
        3SY87v6qxt+XNRhro/o69Bnan++jpUhC+GifWXHDNPkGcEXAsxEknvdhsFlt6DKasxb2ku
        oEbzgXprEj/0N3QFw7lMnoTLaBzxLF0=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-2YnCQ55YO8GjUdImBv-Dgg-1; Tue, 15 Jun 2021 03:16:05 -0400
X-MC-Unique: 2YnCQ55YO8GjUdImBv-Dgg-1
Received: by mail-ej1-f71.google.com with SMTP id nd10-20020a170907628ab02903a324b229bfso4093188ejc.7
        for <kvm@vger.kernel.org>; Tue, 15 Jun 2021 00:16:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A0q6Xx4brx+c25Twsh66TttRM2bYGQLJmZoJQKNwuOw=;
        b=QNoX3XQ1LCqnB3Knm55efR9FBgBXFQ+zH+2Ey32xzxodd+nyqUI5FPNhgL0V0zS2XR
         Zfur3fq07snOBFic+d3GaMC+/nqq9iuiP5NNgopNgXtw9/v49ENLLNZYPl20EdevLpV3
         OQetZFZgp+U/GCP0YO2/YfGfib+lXYPKdqo3jS2nSiemXr2tK7iww/+IHSPJSWqYjDsv
         hfI8AMybPJMcnOIi4ykrdjBJ/33FSffQObCtzQwMcruoLKU9DNjSZmqCSK6uvQFCYS8b
         YDZ13F2+eYQd89kIEup32UKUbq2Qf5rgnrqrLnISrjCljHMG9f6dTSf2IOKfOFo4PkME
         J8vg==
X-Gm-Message-State: AOAM532YW9cPG2yDXcP2b/eQ9WzzBijHFkANWaMQORCe/FxW5UhfiRcK
        WdFWJLfJcC9Uaz7a2dwWKKbbdDOTitmugTkTyCA12mI1L9EX49AqPFkQh5h5tAitS+sAEP5Rw+S
        fE3MqF/evzx8t
X-Received: by 2002:a17:906:3b87:: with SMTP id u7mr19759544ejf.548.1623741363967;
        Tue, 15 Jun 2021 00:16:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwX+jEZ595NIKvqTz9Kzb3Vztd3HmwdOrayLPAJCfJwOcxMUbqRFo4WvyYmyD+iNFrJDH5VSQ==
X-Received: by 2002:a17:906:3b87:: with SMTP id u7mr19759530ejf.548.1623741363790;
        Tue, 15 Jun 2021 00:16:03 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e? ([2001:b07:6468:f312:5e2c:eb9a:a8b6:fd3e])
        by smtp.gmail.com with ESMTPSA id q16sm10885819edt.26.2021.06.15.00.16.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 00:16:03 -0700 (PDT)
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
 <YMfFQnfsq5AuUP2B@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <a13646ce-ee54-4555-909b-2d2977f65f59@redhat.com>
Date:   Tue, 15 Jun 2021 09:16:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YMfFQnfsq5AuUP2B@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/06/21 23:08, David Matlack wrote:
> I actually have a set of
> patches from Ben I am planning to send soon that will reduce the number of
> redundant gfn-to-memslot lookups in the page fault path.

That seems to be a possible 5.14 candidate, while this series is 
probably a bit too much for now.

Paolo

