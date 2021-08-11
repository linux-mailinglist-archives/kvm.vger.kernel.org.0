Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 997B63E8F12
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 12:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237142AbhHKKxy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Aug 2021 06:53:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58023 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231143AbhHKKxx (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Aug 2021 06:53:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628679209;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VNUeFA/VGbCjn6UGdXkeMajDHrCe7/a+UXRYkfFt3ME=;
        b=Yq9gYayLfUnWLrmfLY0uRbRJRvbJJzXnLvB43eRUJ94kBcVvwr15zfq62PVyR1WWGldjJi
        4JQh4+m8nArMxy9QHzl/RQsUfXwnc9wJFVOve/IB3+iSXONDm/uBvPwjsJ0F5lER1rhARr
        wuPPuqwM9SkKi+hZc4+ZBNFP2kLk1EQ=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-183-B5hSDqgDPJmU09Z_LqVvZQ-1; Wed, 11 Aug 2021 06:53:28 -0400
X-MC-Unique: B5hSDqgDPJmU09Z_LqVvZQ-1
Received: by mail-ej1-f69.google.com with SMTP id v19-20020a170906b013b02905b2f1bbf8f3so525902ejy.6
        for <kvm@vger.kernel.org>; Wed, 11 Aug 2021 03:53:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VNUeFA/VGbCjn6UGdXkeMajDHrCe7/a+UXRYkfFt3ME=;
        b=Kl8Gxt3cslhFUXF3G5/muCT6HXl2oRvelZ+WUw84Lsqyk8KffeD1mtENUhdIoKrRfu
         ssoBbGYgYmxZHGW7ZoYJYZiO3hx4enbAFNE4FJgv66MV6M3nJVwSwqkHTqinJTRfeGvn
         7zAOrto/CNt5++9AjYxtb+4BZNoZrzhXvKv+1EhHmggYGAKhSU0wCgpbKR+pKAN1Ze8V
         DAjdL8YJuqx0pYelkycM26TxBQ7iJQls6s+t3yBTXDNrUNoyiCW/SY9zybBuy+nleG4a
         KP0tr2tCNyY6arRKO8ZN2MmrKRwXEoY0E72lzNANr20UF31tVG9UsnJLs6albDmkZc5P
         6klA==
X-Gm-Message-State: AOAM531ADhowtrNvLfxYtGCmoodHsAScilPPOGyIdQ1nhjzf5ZY16ONQ
        fZ4La/5N7UQnyRlyC+qKpFy2FjANp1prPdc7OuNkezuXbn94TRQe6TPD1Un1GcFZQxbdyof2sJj
        epP/cHJYgB86+
X-Received: by 2002:a17:906:1ec9:: with SMTP id m9mr3096285ejj.115.1628679206648;
        Wed, 11 Aug 2021 03:53:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz9VOGfu/HBIG5glyW6XLRjV3vpSIcPk0H1oaLr2fsEabGlkR15ocEUv8UxqOv91kvO44EqXg==
X-Received: by 2002:a17:906:1ec9:: with SMTP id m9mr3096263ejj.115.1628679206471;
        Wed, 11 Aug 2021 03:53:26 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id j13sm2839038edr.89.2021.08.11.03.53.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 03:53:25 -0700 (PDT)
Subject: Re: [PATCH v3 0/5] Linear and Logarithmic histogram statistics
To:     Jing Zhang <jingzhangos@google.com>, KVM <kvm@vger.kernel.org>,
        KVMPPC <kvm-ppc@vger.kernel.org>,
        Sean Christopherson <seanjc@google.com>,
        Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Oliver Upton <oupton@google.com>,
        David Rientjes <rientjes@google.com>,
        David Matlack <dmatlack@google.com>
References: <20210802165633.1866976-1-jingzhangos@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <6865c425-30d2-9db6-7b6b-9ab665ddc352@redhat.com>
Date:   Wed, 11 Aug 2021 12:53:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210802165633.1866976-1-jingzhangos@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 02/08/21 18:56, Jing Zhang wrote:
> This patchset adds linear and logarithmic histogram stats support and extend
> some halt polling stats with histogram.
> Histogram stats is very useful when we need to know the distribution of some
> latencies or any other stuff like used memory size, huge page size, etc.
> Below is a snapshot for three logarithmic histogram stats added in this
> patchset. halt_poll_success_hist shows the distribution of wait time before a
> success polling. halt_poll_fail_hist shows the distribution of wait time before
> a fail polling. halt_wait_hist shows the distribution of wait time of a VCPU
> spending on wait after it is halted. The halt polling parameters is halt_poll_ns
> = 500000, halt_poll_ns_grow = 2, halt_poll_ns_grow_start = 10000,
> halt_poll_ns_shrink = 2;
>  From the snapshot, not only we can get an intuitive overview of those latencies,
> but also we can tune the polling parameters based on this; For example, it shows
> that about 80% of successful polling is less than 132000 nanoseconds from
> halt_poll_success_hist, then it might be a good option to set halt_poll_ns as
> 132000 instead of 500000.
> 
> halt_poll_success_hist:
> Range		Bucket Value	Percent     Cumulative Percent
> [0, 1)		 0		 0.000%      0.000%
> [1, 2)		 0		 0.000%      0.000%
> [2, 4)		 0		 0.000%      0.000%
> [4, 8)		 0		 0.000%      0.000%
> [8, 16)		 0		 0.000%      0.000%
> [16, 32)	 0		 0.000%      0.000%
> [32, 64)	 0		 0.000%      0.000%
> [64, 128)	 0		 0.000%      0.000%
> [128, 256)	 3		 0.093%      0.093%
> [256, 512)	 21		 0.650%      0.743%
> [512, 1024)	 43		 1.330%      2.073%
> [1024, 2048)	 279		 8.632%      10.705%
> [2048, 4096)	 253		 7.828%      18.533%
> [4096, 8192)	 595		 18.410%     36.943%
> [8192, 16384)	 274		 8.478%      45.421%
> [16384, 32768)	 351		 10.860%     56.281%
> [32768, 65536)	 343		 10.613%     66.894%
> [65536, 131072)  421		 13.026%     79.920%
> [131072, 262144) 459		 14.202%     94.121%
> [262144, 524288) 190		 5.879%      100.000%
> 
> 
> halt_poll_fail_hist:
> Range		Bucket Value	Percent     Cumulative Percent
> [0, 1)		 0		 0.000%      0.000%
> [1, 2)		 0		 0.000%      0.000%
> [2, 4)		 0		 0.000%      0.000%
> [4, 8)		 0		 0.000%      0.000%
> [8, 16)		 0		 0.000%      0.000%
> [16, 32)	 0		 0.000%      0.000%
> [32, 64)	 0		 0.000%      0.000%
> [64, 128)	 21		 0.529%      0.529%
> [128, 256)	 398		 10.020%     10.549%
> [256, 512)	 613		 15.433%     25.982%
> [512, 1024)	 437		 11.002%     36.984%
> [1024, 2048)	 264		 6.647%      43.630%
> [2048, 4096)	 302		 7.603%      51.234%
> [4096, 8192)	 350		 8.812%      60.045%
> [8192, 16384)	 488		 12.286%     72.331%
> [16384, 32768)	 258		 6.495%      78.827%
> [32768, 65536)	 227		 5.715%      84.542%
> [65536, 131072)  232		 5.841%      90.383%
> [131072, 262144) 246		 6.193%      96.576%
> [262144, 524288) 136		 3.424%      100.000%
> 
> 
> halt_wait_hist:
> Range			    Bucket Value    Percent	Cumulative Percent
> [0, 1)			     0		     0.000%	 0.000%
> [1, 2)			     0		     0.000%	 0.000%
> [2, 4)			     0		     0.000%	 0.000%
> [4, 8)			     0		     0.000%	 0.000%
> [8, 16)			     0		     0.000%	 0.000%
> [16, 32)		     0		     0.000%	 0.000%
> [32, 64)		     0		     0.000%	 0.000%
> [64, 128)		     0		     0.000%	 0.000%
> [128, 256)		     0		     0.000%	 0.000%
> [256, 512)		     0		     0.000%	 0.000%
> [512, 1024)		     0		     0.000%	 0.000%
> [1024, 2048)		     0		     0.000%	 0.000%
> [2048, 4096)		     7		     0.127%	 0.127%
> [4096, 8192)		     37		     0.671%	 0.798%
> [8192, 16384)		     69		     1.251%	 2.049%
> [16384, 32768)		     94		     1.704%	 3.753%
> [32768, 65536)		     150	     2.719%	 6.472%
> [65536, 131072)		     233	     4.224%	 10.696%
> [131072, 262144)	     276	     5.004%	 15.700%
> [262144, 524288)	     236	     4.278%	 19.978%
> [524288, 1.04858e+06)	     176	     3.191%	 23.169%
> [1.04858e+06, 2.09715e+06)   94		     16.207%	 39.376%
> [2.09715e+06, 4.1943e+06)    1667	     30.221%	 69.598%
> [4.1943e+06, 8.38861e+06)    825	     14.956%	 84.554%
> [8.38861e+06, 1.67772e+07)   111	     2.012%	 86.566%
> [1.67772e+07, 3.35544e+07)   76		     1.378%	 87.944%
> [3.35544e+07, 6.71089e+07)   65		     1.178%	 89.123%
> [6.71089e+07, 1.34218e+08)   161	     2.919%	 92.041%
> [1.34218e+08, 2.68435e+08)   250	     4.532%	 96.574%
> [2.68435e+08, 5.36871e+08)   188	     3.408%	 99.982%
> [5.36871e+08, 1.07374e+09)   1		     0.018%	 100.000%
> 
> ---
> 
> * v2 -> v3
>    - Rebase to kvm/queue, commit 8ad5e63649ff
>      (KVM: Don't take mmu_lock for range invalidation unless necessary)
>    - Specify inline explicitly for histogram stats update functions
>    - Use array_index_nospec to clamp the index to histogram array size
>    - Remove constant macros for histogram array size and bucket size
>    - Addressed other comments from Paolo.
> 
> * v1 -> v2
>    - Rebase to kvm/queue, commit 1889228d80fe
>      (KVM: selftests: smm_test: Test SMM enter from L2)
>    - Break some changes to separate commits
>    - Fix u64 division issue Reported-by: kernel test robot <lkp@intel.com>
>    - Address a bunch of comments by David Matlack <dmatlack@google.com>
> 
> [1] https://lore.kernel.org/kvm/20210706180350.2838127-1-jingzhangos@google.com
> [2] https://lore.kernel.org/kvm/20210714223033.742261-1-jingzhangos@google.com
> 
> ---
> 
> Jing Zhang (5):
>    KVM: stats: Support linear and logarithmic histogram statistics
>    KVM: stats: Update doc for histogram statistics
>    KVM: selftests: Add checks for histogram stats bucket_size field
>    KVM: stats: Add halt_wait_ns stats for all architectures
>    KVM: stats: Add halt polling related histogram stats
> 
>   Documentation/virt/kvm/api.rst                | 28 ++++++--
>   arch/arm64/kvm/guest.c                        |  4 --
>   arch/mips/kvm/mips.c                          |  4 --
>   arch/powerpc/include/asm/kvm_host.h           |  1 -
>   arch/powerpc/kvm/book3s.c                     |  5 --
>   arch/powerpc/kvm/book3s_hv.c                  | 18 ++++-
>   arch/powerpc/kvm/booke.c                      |  5 --
>   arch/s390/kvm/kvm-s390.c                      |  4 --
>   arch/x86/kvm/x86.c                            |  4 --
>   include/linux/kvm_host.h                      | 67 ++++++++++++++-----
>   include/linux/kvm_types.h                     |  6 ++
>   include/uapi/linux/kvm.h                      | 11 +--
>   .../selftests/kvm/kvm_binary_stats_test.c     | 12 ++++
>   virt/kvm/binary_stats.c                       | 34 ++++++++++
>   virt/kvm/kvm_main.c                           | 16 +++++
>   15 files changed, 165 insertions(+), 54 deletions(-)
> 
> 
> base-commit: 8ad5e63649ffaa9207b8fde932f3bd59a72c4c94
> 

Queued, thanks.

Paolo

