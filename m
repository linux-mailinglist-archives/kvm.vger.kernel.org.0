Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5F4263093
	for <lists+kvm@lfdr.de>; Wed,  9 Sep 2020 17:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730187AbgIIPbi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Sep 2020 11:31:38 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:28563 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730225AbgIIP3U (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 9 Sep 2020 11:29:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599665341;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nYNO+AKEPgBW6vTBqHGF1fYVln/0uSeBDRwExSc81XY=;
        b=PAliqYGoha/RSfTw1zMP5g2X9kve15l/euOmQWKbcTd5VVPAsGPa/AH4ez+xl/yFhp+Bfs
        qhibSPtdaRCI8FV0A+1E20gkThWIlkFG8ztXsFDo6mhN646nhd11j79HVr66CDiMh9fLLz
        bwcteESidN2Z47zTkQkwpcfAxTsuuuY=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-COr26fmvPkqTC0imphpi6Q-1; Wed, 09 Sep 2020 11:20:33 -0400
X-MC-Unique: COr26fmvPkqTC0imphpi6Q-1
Received: by mail-ej1-f69.google.com with SMTP id dc22so1422308ejb.21
        for <kvm@vger.kernel.org>; Wed, 09 Sep 2020 08:20:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nYNO+AKEPgBW6vTBqHGF1fYVln/0uSeBDRwExSc81XY=;
        b=ud65tdzBztFS5eXnT07shmqt7iWPlAI0m2ZASzVHL+4lAPHeWCF5PpULAv2murV8t0
         /DUW2HRoT/EpApCmWLYWMyYOFyQGR5Aegsgc7S9qavkJ1euX5BEbO1XfkM755ddaKtyO
         HpG4fgxROZV9QgSfqjrTsUWMJFMin0gBuui55uTtwlwRtC6MCJbbUY9TaksMPe6NK3nf
         HvL2O6I05bNDiUX2KyWxfPckrH10npj9XrwiC2ZGrX6BgRicrrLkeFekf75HYR1TlHop
         ctCgsXhj0dAAqAxqiD45snqDlwksf8PgysSPKBS2ikNH0U9kXPY8BLgITuihEKqSVfZK
         VpXg==
X-Gm-Message-State: AOAM531IpEuC35yFHoikw2PYDopPxiXlDW78gOtnrIPvy9rhkGG6i/cH
        FZDs5pvzhjUYzT8RcMl7K07R9PZAcM77mOfba+oMFZC8cl5HihV6gVxnyc8zlxO5fPzwg2X74Gx
        iulNwRXbrxODn
X-Received: by 2002:aa7:c1c3:: with SMTP id d3mr4712075edp.228.1599664832292;
        Wed, 09 Sep 2020 08:20:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy/buxcR3k3TYh22ywGq6QmpgD+APHFSZ/u2IydDFW2LmR/OY3181D7GwPj31tu14P28jmFEw==
X-Received: by 2002:aa7:c1c3:: with SMTP id d3mr4712059edp.228.1599664832099;
        Wed, 09 Sep 2020 08:20:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4025:be55:3943:81a0? ([2001:b07:6468:f312:4025:be55:3943:81a0])
        by smtp.gmail.com with ESMTPSA id b10sm2399995eje.65.2020.09.09.08.20.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Sep 2020 08:20:31 -0700 (PDT)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.9
To:     Marc Zyngier <maz@kernel.org>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Eric Auger <eric.auger@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Steven Price <steven.price@arm.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org
References: <20200904104530.1082676-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f7afbf0f-2e14-2720-5d23-2cd01982e4d1@redhat.com>
Date:   Wed, 9 Sep 2020 17:20:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200904104530.1082676-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/09/20 12:45, Marc Zyngier wrote:
> Hi Paolo,
> 
> Here's a bunch of fixes for 5.9. The gist of it is the stolen time
> rework from Andrew, but we also have a couple of MM fixes that have
> surfaced as people have started to use hugetlbfs in anger.

Hi Marc,

I'll get to this next Friday.

Paolo

> Please pull,
> 
> 	M.
> 
> The following changes since commit 9123e3a74ec7b934a4a099e98af6a61c2f80bbf5:
> 
>   Linux 5.9-rc1 (2020-08-16 13:04:57 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.9-1
> 
> for you to fetch changes up to 7b75cd5128421c673153efb1236705696a1a9812:
> 
>   KVM: arm64: Update page shift if stage 2 block mapping not supported (2020-09-04 10:53:48 +0100)
> 
> ----------------------------------------------------------------
> KVM/arm64 fixes for Linux 5.9, take #1
> 
> - Multiple stolen time fixes, with a new capability to match x86
> - Fix for hugetlbfs mappings when PUD and PMD are the same level
> - Fix for hugetlbfs mappings when PTE mappings are enforced
>   (dirty logging, for example)
> - Fix tracing output of 64bit values
> 
> ----------------------------------------------------------------
> Alexandru Elisei (1):
>       KVM: arm64: Update page shift if stage 2 block mapping not supported
> 
> Andrew Jones (6):
>       KVM: arm64: pvtime: steal-time is only supported when configured
>       KVM: arm64: pvtime: Fix potential loss of stolen time
>       KVM: arm64: Drop type input from kvm_put_guest
>       KVM: arm64: pvtime: Fix stolen time accounting across migration
>       KVM: Documentation: Minor fixups
>       arm64/x86: KVM: Introduce steal-time cap
> 
> Marc Zyngier (2):
>       KVM: arm64: Do not try to map PUDs when they are folded into PMD
>       KVM: arm64: Fix address truncation in traces
> 
>  Documentation/virt/kvm/api.rst     | 22 ++++++++++++++++++----
>  arch/arm64/include/asm/kvm_host.h  |  2 +-
>  arch/arm64/kvm/arm.c               |  3 +++
>  arch/arm64/kvm/mmu.c               |  8 +++++++-
>  arch/arm64/kvm/pvtime.c            | 29 +++++++++++++----------------
>  arch/arm64/kvm/trace_arm.h         | 16 ++++++++--------
>  arch/arm64/kvm/trace_handle_exit.h |  6 +++---
>  arch/x86/kvm/x86.c                 |  3 +++
>  include/linux/kvm_host.h           | 31 ++++++++++++++++++++++++++-----
>  include/uapi/linux/kvm.h           |  1 +
>  10 files changed, 83 insertions(+), 38 deletions(-)
> 

