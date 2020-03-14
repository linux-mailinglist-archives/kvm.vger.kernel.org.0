Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0BFE1859D0
	for <lists+kvm@lfdr.de>; Sun, 15 Mar 2020 04:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727618AbgCODsF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Mar 2020 23:48:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:50690 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726668AbgCODsF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Mar 2020 23:48:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584244084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+wI+Katt2B9iBvQM+m42r6eAfXCBwyIbY32hHPOqodY=;
        b=NnfgRCvBCn/GaTQLbCZ7tQD2WitdVVHlM3Jt2tuJ5IwBWNuOvSHweSXAVHxYFr55LxiD2h
        /qh+fTwUvn1cgshUlh+ewzeFNrRo/gv44FOks2ZMn2mvk1ZKSlSgi3O/anTt3QY9zUFB/F
        UtQ3SRyoY/DHG7GcRvq93+uWqe/f2ao=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-ufovLFyZOlG7aYJmaC-cOQ-1; Sat, 14 Mar 2020 07:44:14 -0400
X-MC-Unique: ufovLFyZOlG7aYJmaC-cOQ-1
Received: by mail-wr1-f71.google.com with SMTP id w6so5818373wrm.16
        for <kvm@vger.kernel.org>; Sat, 14 Mar 2020 04:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+wI+Katt2B9iBvQM+m42r6eAfXCBwyIbY32hHPOqodY=;
        b=aTJJ2fbHNBQRMdNdJA+gE6gw1+RXoCGLMYGQNVG/dhSLQ602H3lNAx8GXzvZKvgM/G
         b1bO8kl4HjHBJlunyiT9UgoJv3hU/13cvRhJ9EEMTbSTuqHOv2J81S/K0bsseMVft59B
         y8SKOgcOxnLEMYv4iHe0RKY3VRP67uujLVzK6vFBsWChsLX2pYF0J5qAV5n99dtxKnHr
         gZxpPJd9UIYzwY3hCtXTWdd/+ykYvwPbTFTUlLmaIU0u0EJU+hwT8Ye32O06AHh8c+KR
         GjTllTA2djr+zCk2frys4gJK0/XnD4SujB+hUkqAZJOEYqU4YbT085ZuhD7inor4VnWP
         3NwA==
X-Gm-Message-State: ANhLgQ1Ko49xlwf4NNz2edsRemVUy94F5w8wCuf8nIGIOvEPjLfksAaE
        poo31WcH2bo0ZFOMEbS/kVukLwzd5l1XxobngG+MaFzt2EOPHGg9KyS1Ff3SohAX4izRLdWr9uH
        Psynb18NSWJBr
X-Received: by 2002:a5d:4ad1:: with SMTP id y17mr16826602wrs.119.1584186252842;
        Sat, 14 Mar 2020 04:44:12 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtGQujQBDPJMeGWC8imKxYt047fJRgD+QoxLNG3I9FMKNqZ/hXK22R2f33AuPowfOCC/Cbgtg==
X-Received: by 2002:a5d:4ad1:: with SMTP id y17mr16826585wrs.119.1584186252578;
        Sat, 14 Mar 2020 04:44:12 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.174.5])
        by smtp.gmail.com with ESMTPSA id b6sm27523772wrv.43.2020.03.14.04.44.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Mar 2020 04:44:12 -0700 (PDT)
Subject: Re: [PATCH 0/2] KVM: selftests: Introduce steal-time tests for x86_64
 and AArch64
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org
References: <20200313155644.29779-1-drjones@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <90bc7327-c2f5-364f-13ad-be45828e0f5d@redhat.com>
Date:   Sat, 14 Mar 2020 12:44:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200313155644.29779-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 13/03/20 16:56, Andrew Jones wrote:
> Test steal/stolen-time on x86 and AArch64 to make sure what gets
> reported to the guest is consistent with run-delay.
> 
> The first patch of this series is just kvm selftests API cleanup. The
> series is based on kvm/queue and some in-flight patches that are also
> based on kvm/queue
>  KVM: selftests: Share common API documentation
>  KVM: selftests: Enable printf format warnings for TEST_ASSERT
>  KVM: selftests: Use consistent message for test skipping
>  KVM: selftests: s390x: Provide additional num-guest-pages adjustment
> 
> Thanks,
> drew
> 
> 
> Andrew Jones (2):
>   KVM: selftests: virt_map should take npages, not size
>   KVM: selftests: Introduce steal-time test
> 
>  tools/testing/selftests/kvm/.gitignore        |   2 +
>  tools/testing/selftests/kvm/Makefile          |  12 +-
>  .../selftests/kvm/demand_paging_test.c        |   3 +-
>  tools/testing/selftests/kvm/dirty_log_test.c  |   3 +-
>  .../testing/selftests/kvm/include/kvm_util.h  |   7 +-
>  .../testing/selftests/kvm/include/test_util.h |   1 +
>  tools/testing/selftests/kvm/lib/kvm_util.c    |  17 +-
>  tools/testing/selftests/kvm/lib/test_util.c   |  15 +
>  tools/testing/selftests/kvm/steal_time.c      | 352 ++++++++++++++++++
>  .../kvm/x86_64/set_memory_region_test.c       |   2 +-
>  .../selftests/kvm/x86_64/vmx_dirty_log_test.c |  11 +-
>  11 files changed, 401 insertions(+), 24 deletions(-)
>  create mode 100644 tools/testing/selftests/kvm/steal_time.c
> 

Queued, thanks.

Paolo

