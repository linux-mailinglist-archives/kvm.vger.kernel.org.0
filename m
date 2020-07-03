Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F1AC213E76
	for <lists+kvm@lfdr.de>; Fri,  3 Jul 2020 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgGCRUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 3 Jul 2020 13:20:30 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:34035 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726236AbgGCRU3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 3 Jul 2020 13:20:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593796828;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GIrvmUybK9vIMsIuhctNNg5TFcmK5sb/DzyUMikX9ag=;
        b=OcfvNsQ1JkTWx1my8Shq1xCvxhSyNb9O5NVloyY4Ky09fed4Q1Aqmf9Ju2R2Y76XBJYzNI
        ULF+Abrfc7VEvPA739x5S9xs/zSKihNV4iD2cXu9AsG98V0d0aZreZjcrAYLRmo3wXtRJt
        aiBdZ9cRsTuMKHzlfTVbFxxDtE2tbLI=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-69-rOaK0udMOZqaYIeSB5N95A-1; Fri, 03 Jul 2020 13:20:26 -0400
X-MC-Unique: rOaK0udMOZqaYIeSB5N95A-1
Received: by mail-wr1-f69.google.com with SMTP id y13so32332810wrp.13
        for <kvm@vger.kernel.org>; Fri, 03 Jul 2020 10:20:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GIrvmUybK9vIMsIuhctNNg5TFcmK5sb/DzyUMikX9ag=;
        b=pTsdpGMy8X4H5lWjYiGkiNAKq4FMMHR3T8f6UwmgDjVbZRqcqhZymVwQTSUHHmsQXT
         qDgFCMEOGfsWdaTuZt6YKksvK71fazDmTFxhigb36aJ0p29gYJeu2M6ja0m8VNz2xD+r
         gZZ3cqHfQKYTF+B2y/XzarcB67VrqndGDxgEW6NrMIhpBP87KvNYzGXyzSCasjaV7WzS
         kW8yNtA7yO0ySCNeHTbcSBwjhwUTQ13ZkCesMiW+MM2O+dxDmv6S55Sa4tPWpVSrSc+G
         f69j47eavn8u+EaAWEadZcVvUpXqvQEUdVWNgR/1xYv5xihXirdNE3AGImJlgm7+fBQT
         YIqw==
X-Gm-Message-State: AOAM5335RLfnt04Ks8jM6zHgT1hFfx8RMa8brjUulcEY7eiv6NoUZELz
        KDXTJsheigsqPtKlcpCgMI76EQpSiw8goCksUbMQHXx3wA3we4dQcKTDZ6lSlx5bHtT7VDBsHBJ
        WiMgIXR094c3L
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr36751676wrv.162.1593796825660;
        Fri, 03 Jul 2020 10:20:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxEj4nYzQT8PtT0A7YMDIG3zf3Bw2nrpkhBVtgp3w6WYZI5o/bOZlfO5uPgLCBwZoNy5PQGQA==
X-Received: by 2002:a5d:62d1:: with SMTP id o17mr36751657wrv.162.1593796825426;
        Fri, 03 Jul 2020 10:20:25 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:5cf9:fc14:deb7:51fc? ([2001:b07:6468:f312:5cf9:fc14:deb7:51fc])
        by smtp.gmail.com with ESMTPSA id z10sm9510926wrm.21.2020.07.03.10.20.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2020 10:20:24 -0700 (PDT)
Subject: Re: [PATCH 0/6] KVM: x86/mmu: Files and sp helper cleanups
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200622202034.15093-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <c28ce09b-b5a4-eb0d-0b01-6c1e413fe796@redhat.com>
Date:   Fri, 3 Jul 2020 19:20:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200622202034.15093-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 22/06/20 22:20, Sean Christopherson wrote:
> Move more files to the mmu/ directory, and an mmu_internal.h to share
> stuff amongst the mmu/ files, and clean up the helpers for retrieving a
> shadow page from a sptep and/or hpa.
> 
> Sean Christopherson (6):
>   KVM: x86/mmu: Move mmu_audit.c and mmutrace.h into the mmu/
>     sub-directory
>   KVM: x86/mmu: Move kvm_mmu_available_pages() into mmu.c
>   KVM: x86/mmu: Add MMU-internal header
>   KVM: x86/mmu: Make kvm_mmu_page definition and accessor internal-only
>   KVM: x86/mmu: Add sptep_to_sp() helper to wrap shadow page lookup
>   KVM: x86/mmu: Rename page_header() to to_shadow_page()
> 
>  arch/x86/include/asm/kvm_host.h    | 46 +---------------------
>  arch/x86/kvm/mmu.h                 | 13 ------
>  arch/x86/kvm/mmu/mmu.c             | 58 +++++++++++++++------------
>  arch/x86/kvm/{ => mmu}/mmu_audit.c | 12 +++---
>  arch/x86/kvm/mmu/mmu_internal.h    | 63 ++++++++++++++++++++++++++++++
>  arch/x86/kvm/{ => mmu}/mmutrace.h  |  2 +-
>  arch/x86/kvm/mmu/page_track.c      |  2 +-
>  arch/x86/kvm/mmu/paging_tmpl.h     |  4 +-
>  8 files changed, 108 insertions(+), 92 deletions(-)
>  rename arch/x86/kvm/{ => mmu}/mmu_audit.c (96%)
>  create mode 100644 arch/x86/kvm/mmu/mmu_internal.h
>  rename arch/x86/kvm/{ => mmu}/mmutrace.h (99%)
> 

Queued, thanks.

Paolo

