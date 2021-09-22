Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3D9414A33
	for <lists+kvm@lfdr.de>; Wed, 22 Sep 2021 15:10:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231663AbhIVNMK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 Sep 2021 09:12:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:42790 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230309AbhIVNMK (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 22 Sep 2021 09:12:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632316239;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c1g2Uc8Mxkh8RS5U1ag7IVGNROzqxKAw9As6tAn8C4k=;
        b=AJpyBZK5pGNxHJCo50dRb617wu/fORoizdYTD/OICl5O7iFjMVSAGSY7ZuRzgKcngBx7fG
        lbCMM3ZY0epW+5zyGL2nLXpVCqbrMLouW6x+Sj+vxxK21sU81Fsg0MX5o7Aw4XFOyw0urF
        /RF3ZYFASUXkTfR1qh2joDQW/jnOmIs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-dSFiXEq3OdGJPBpmXLSgUw-1; Wed, 22 Sep 2021 09:10:38 -0400
X-MC-Unique: dSFiXEq3OdGJPBpmXLSgUw-1
Received: by mail-wr1-f72.google.com with SMTP id s14-20020adff80e000000b001601b124f50so2128250wrp.5
        for <kvm@vger.kernel.org>; Wed, 22 Sep 2021 06:10:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=c1g2Uc8Mxkh8RS5U1ag7IVGNROzqxKAw9As6tAn8C4k=;
        b=MHIYgRuq+AN19Wa6WvXAh2euAYdDcMzw6TLTJyOg3U6/JgQnMwunZED2dztx8wOaw4
         VFO1y/1MFwhe/Y0Z3TQbI0kuTCjH3w0+DTTeA0xewzloqUApJ0H7s75GM/VH+ABqMAaZ
         C98qAamQ5jy7iUAniSVToP2H2Uhu+t4a6JixrfVg4XAecq3vQ/FkMPHCdNUuRixmm2u8
         ZJn8TEWM7LsR6SlgbKq3ccrehdR5YHdEOAci6o7aEnxVU8bjPn2OlHpL+zktxW34Bezp
         dQ64fx8nLTEH2sTdN+WRfalZpgG7S8+K6WoMS+0UO/Oj0krbI354gSwJS6gVcrPSLgWX
         Qilg==
X-Gm-Message-State: AOAM533lBhhtHQBIAAnp9rc7ArlR4BtroYlnDQsORevdfnxnHwEoU3zj
        5aV2dql0D5P4r0HDK3LzcsZKdQzFhm4JkXtQ0/qnN8CfN3mS0eD939mtEolh/SAIQ7I9kvO8XRT
        SwgcfNZDP/9S+
X-Received: by 2002:adf:b748:: with SMTP id n8mr41395064wre.133.1632316236716;
        Wed, 22 Sep 2021 06:10:36 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx909tESasiL7JG1tq1m/7V3E47aqg5+rIq8v5Nd99r+QbbMjads7cSzq/NTvYM7r+Xz+pBDQ==
X-Received: by 2002:adf:b748:: with SMTP id n8mr41395030wre.133.1632316236386;
        Wed, 22 Sep 2021 06:10:36 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id o13sm2530025wri.53.2021.09.22.06.10.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 06:10:35 -0700 (PDT)
Subject: Re: [PATCH v2 0/3] KVM: selftests: Small fixes for
 dirty_log_perf_test
To:     David Matlack <dmatlack@google.com>
Cc:     kvm@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Ben Gardon <bgardon@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Yanan Wang <wangyanan55@huawei.com>
References: <20210917173657.44011-1-dmatlack@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <4ae41c7e-0205-7b7a-f092-54c5b1e26b23@redhat.com>
Date:   Wed, 22 Sep 2021 15:10:34 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210917173657.44011-1-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 17/09/21 19:36, David Matlack wrote:
> This series fixes 2 bugs in dirty_log_perf_test:
>   - Incorrect interleaving of help messages for -s and -x (patch 2)
>   - Buffer overflow when using multiple slots (patch 3)
> 
> Both bugs were introduced by commit 609e6202ea5f ("KVM: selftests:
> Support multiple slots in dirty_log_perf_test").
> 
> Patch 1 is a small tangentially related cleanup to use a consistent
> flag for the backing source across all selftests.
> 
> v2:
>   - Add Ben and Andrew's SOB to patches 1 and 2
>   - Delete stray newline in patch 2 [Andrew]
>   - Make print_available_backing_src_types static [Andrew]
>   - Create a separate dirty bitmap per slot [Andrew, Ben]
> 
> v1: https://lore.kernel.org/kvm/20210915213034.1613552-1-dmatlack@google.com/
> 
> David Matlack (3):
>    KVM: selftests: Change backing_src flag to -s in demand_paging_test
>    KVM: selftests: Refactor help message for -s backing_src
>    KVM: selftests: Create a separate dirty bitmap per slot
> 
>   .../selftests/kvm/access_tracking_perf_test.c |  6 +-
>   .../selftests/kvm/demand_paging_test.c        | 13 ++--
>   .../selftests/kvm/dirty_log_perf_test.c       | 63 +++++++++++++------
>   .../testing/selftests/kvm/include/test_util.h |  4 +-
>   .../selftests/kvm/kvm_page_table_test.c       |  7 +--
>   tools/testing/selftests/kvm/lib/test_util.c   | 17 +++--
>   6 files changed, 69 insertions(+), 41 deletions(-)
> 

Queued these now, thanks.

Paolo

