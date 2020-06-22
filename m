Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 125B62031A2
	for <lists+kvm@lfdr.de>; Mon, 22 Jun 2020 10:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725957AbgFVIKM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 22 Jun 2020 04:10:12 -0400
Received: from foss.arm.com ([217.140.110.172]:54280 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726778AbgFVIJ6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 22 Jun 2020 04:09:58 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3EEF31FB;
        Mon, 22 Jun 2020 01:09:56 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F32DF3F6CF;
        Mon, 22 Jun 2020 01:09:54 -0700 (PDT)
Subject: Re: [PATCH 0/4] arm64/x86: KVM: Introduce KVM_CAP_STEAL_TIME
To:     Andrew Jones <drjones@redhat.com>, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     pbonzini@redhat.com, maz@kernel.org
References: <20200619184629.58653-1-drjones@redhat.com>
From:   Steven Price <steven.price@arm.com>
Message-ID: <20aaad52-c45a-7fe1-8295-6c4df748a1d8@arm.com>
Date:   Mon, 22 Jun 2020 09:09:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200619184629.58653-1-drjones@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19/06/2020 19:46, Andrew Jones wrote:
> This series introduces a KVM CAP for steal time to arm64 and x86.
> For arm64 the cap resolves a couple issues described in the second
> patch's commit message. The cap isn't necessary for x86, but is
> added for consistency.
> 
> Thanks,
> drew

LGTM, being able to probe whether nodelayacct has been specified makes 
sense and having it available before VCPU creation is even better. FWIW 
feel free to add:

Reviewed-by: Steven Price <steven.price@arm.com>

Thanks,

Steve

> Andrew Jones (4):
>    KVM: Documentation minor fixups
>    arm64/x86: KVM: Introduce steal time cap
>    tools headers kvm: Sync linux/kvm.h with the kernel sources
>    KVM: selftests: Use KVM_CAP_STEAL_TIME
> 
>   Documentation/virt/kvm/api.rst           | 20 ++++++++++++++++----
>   arch/arm64/kvm/arm.c                     |  3 +++
>   arch/x86/kvm/x86.c                       |  3 +++
>   include/uapi/linux/kvm.h                 |  1 +
>   tools/include/uapi/linux/kvm.h           | 15 +++++++++++++++
>   tools/testing/selftests/kvm/steal_time.c |  8 ++++++++
>   6 files changed, 46 insertions(+), 4 deletions(-)
> 

