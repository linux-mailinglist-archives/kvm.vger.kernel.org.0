Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21C8E379FFC
	for <lists+kvm@lfdr.de>; Tue, 11 May 2021 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbhEKGui (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 May 2021 02:50:38 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:2440 "EHLO
        szxga07-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbhEKGuh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 May 2021 02:50:37 -0400
Received: from DGGEMS404-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4FfT3t4RqZzCr86;
        Tue, 11 May 2021 14:46:50 +0800 (CST)
Received: from [10.174.187.224] (10.174.187.224) by
 DGGEMS404-HUB.china.huawei.com (10.3.19.204) with Microsoft SMTP Server id
 14.3.498.0; Tue, 11 May 2021 14:49:21 +0800
Subject: Re: [PATCH v3 0/2] KVM: x86: Enable dirty logging lazily for huge
 pages
To:     <linux-kernel@vger.kernel.org>, <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Ben Gardon <bgardon@google.com>
References: <20210429034115.35560-1-zhukeqian1@huawei.com>
CC:     <wanghaibin.wang@huawei.com>
From:   Keqian Zhu <zhukeqian1@huawei.com>
Message-ID: <cca6e81d-fec6-d461-3580-54865f11ee51@huawei.com>
Date:   Tue, 11 May 2021 14:49:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
MIME-Version: 1.0
In-Reply-To: <20210429034115.35560-1-zhukeqian1@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.187.224]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

ping. ^_^

On 2021/4/29 11:41, Keqian Zhu wrote:
> Hi,
> 
> Currently during start dirty logging, if we're with init-all-set,
> we write protect huge pages and leave normal pages untouched, for
> that we can enable dirty logging for these pages lazily.
> 
> Actually enable dirty logging lazily for huge pages is feasible
> too, which not only reduces the time of start dirty logging, also
> greatly reduces side-effect on guest when there is high dirty rate.
> 
> Thanks,
> Keqian
> 
> Changelog:
> 
> v3:
>  - Discussed with Ben and delete RFC comments. Thanks.
> 
> Keqian Zhu (2):
>   KVM: x86: Support write protect gfn with min_level
>   KVM: x86: Not wr-protect huge page with init_all_set dirty log
> 
>  arch/x86/kvm/mmu/mmu.c          | 38 ++++++++++++++++++++++++++-------
>  arch/x86/kvm/mmu/mmu_internal.h |  3 ++-
>  arch/x86/kvm/mmu/page_track.c   |  2 +-
>  arch/x86/kvm/mmu/tdp_mmu.c      | 16 ++++++++++----
>  arch/x86/kvm/mmu/tdp_mmu.h      |  3 ++-
>  arch/x86/kvm/x86.c              | 37 +++++++++-----------------------
>  6 files changed, 57 insertions(+), 42 deletions(-)
> 
