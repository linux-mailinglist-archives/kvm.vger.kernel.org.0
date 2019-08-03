Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E4D804AA
	for <lists+kvm@lfdr.de>; Sat,  3 Aug 2019 08:30:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbfHCGaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Aug 2019 02:30:10 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56163 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726612AbfHCGaI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Aug 2019 02:30:08 -0400
Received: by mail-wm1-f68.google.com with SMTP id a15so69932399wmj.5
        for <kvm@vger.kernel.org>; Fri, 02 Aug 2019 23:30:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=k16GciQDdsFXL1/gbaqPADgfBEVZRulBTAenPeqqAmY=;
        b=bI8MP4NInL0ZnOzhUhw9wTGbl0h+yBwHY4NR+sYDCrb4PM7mDkFCW8JuvFu02OMExS
         Axr5m8wsDlrC96vi9FJmZrSkua22Ar/eERfyPNSfxhnxLYga7jeqOFfCKVgMhV3brm7M
         tbNKejzwWRW9oLKxhwE8f5eU68sL58rxBKTLwcq+Tew/aiHFRJcMFchPCBBC82wvkKx4
         JR0fhC/qhb7/G5uAx6lg6GMIl2YfOZzirWymCYD0cRSbQOscnbULLJ+2Jy0erQplkU/z
         JP1turwe424vxkrrvtA4yCJ7uPlBkoR3w1eL4BCyWBFUbv/tEg2M0BWaO1mjo08qEO/B
         XytQ==
X-Gm-Message-State: APjAAAX5pBwZJGp/MRcywSuBFCcvDNLQQ+AvuPW2t3Tr5D4Sbm70TMHb
        rJMDvlPp3tijYwN4fBs9n7anXw==
X-Google-Smtp-Source: APXvYqwS/D+b20geKl9iYom06BhFEyIz+muV/nijzcR5qufyNkHyVlr9BYRCDyDFBdrU0znfJ4mHcQ==
X-Received: by 2002:a7b:c202:: with SMTP id x2mr7504795wmi.49.1564813805534;
        Fri, 02 Aug 2019 23:30:05 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:4013:e920:9388:c3ff? ([2001:b07:6468:f312:4013:e920:9388:c3ff])
        by smtp.gmail.com with ESMTPSA id o20sm200895026wrh.8.2019.08.02.23.30.04
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 02 Aug 2019 23:30:05 -0700 (PDT)
Subject: Re: [PATCH 0/3] KVM: x86/mmu: minor MMIO SPTE cleanup
To:     Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190801203523.5536-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <c2860baa-6ef9-1020-eb6f-886a3b7cda65@redhat.com>
Date:   Sat, 3 Aug 2019 08:30:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190801203523.5536-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01/08/19 22:35, Sean Christopherson wrote:
> A few loosely related MMIO SPTE patches to get rid of a bit of cruft that
> has been a source of annoyance when mucking around in the MMIO code.
> 
> No functional changes intended.
> 
> Sean Christopherson (3):
>   KVM: x86: Rename access permissions cache member in struct
>     kvm_vcpu_arch
>   KVM: x86/mmu: Add explicit access mask for MMIO SPTEs
>   KVM: x86/mmu: Consolidate "is MMIO SPTE" code
> 
>  Documentation/virtual/kvm/mmu.txt |  4 ++--
>  arch/x86/include/asm/kvm_host.h   |  2 +-
>  arch/x86/kvm/mmu.c                | 31 +++++++++++++++++--------------
>  arch/x86/kvm/mmu.h                |  2 +-
>  arch/x86/kvm/vmx/vmx.c            |  2 +-
>  arch/x86/kvm/x86.c                |  2 +-
>  arch/x86/kvm/x86.h                |  2 +-
>  7 files changed, 24 insertions(+), 21 deletions(-)
> 

Queued, thanks.

Paolo
