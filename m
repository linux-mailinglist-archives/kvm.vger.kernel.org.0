Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11922D0313
	for <lists+kvm@lfdr.de>; Sun,  6 Dec 2020 12:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgLFK5u (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 6 Dec 2020 05:57:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:40067 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725767AbgLFK5t (ORCPT
        <rfc822;kvm@vger.kernel.org>); Sun, 6 Dec 2020 05:57:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607252183;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zb05xp01BEyQm5LEh62oLhnL6kPgxUW55TugbE4oo4M=;
        b=OIzdyX3pM6H9Xey4luTP2WCVUDsv7QeNSp2Wz17G6BZcBYq/pzLgF0rJFWN5nmlsqhQF17
        Bu0KLcrgzddPfSn4if0xK5AdehrziCyusGS/HPtxnlAyRno4yblBMWKyzcnq/kCVn3uaa6
        ZKjc7aoW+38Igr6Udjuap3WtSZTlLbk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-332-TdiRe3hJMQeUegLYyCSYZA-1; Sun, 06 Dec 2020 05:56:21 -0500
X-MC-Unique: TdiRe3hJMQeUegLYyCSYZA-1
Received: by mail-wm1-f72.google.com with SMTP id r5so4058077wma.2
        for <kvm@vger.kernel.org>; Sun, 06 Dec 2020 02:56:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zb05xp01BEyQm5LEh62oLhnL6kPgxUW55TugbE4oo4M=;
        b=ZvX6nKk9X0UPe0xHu6hVWy/M5M/UtgNuwfhQJ5vCu7bV7pkSDFWmC1pC2f4PDPaSe3
         73ud3YdVeeUaCK9mrM0AszPv44bI4Q/PR7E6qK0I7zeuKH4bfSCsBG46l++4xcYX/RX6
         bRM/DEw0DndXrS+RJNNyEBrVTa75q+Mk9686GdtJJJDRitG78LlFwB8emyFh4PRxhKW1
         un9U6fn5iaUKgAmYW7sc2Sse4S4QOqE1HHN3m5TrDJSgFP6TWiUJdQgLIj3pFM2ZhF9G
         fZ5Ao3A4SfcFYr16wJuyiqPwhAHEJZs/BZyXYwiQ6NsZRvM1wIyKyayH7f9WdrcyC/qg
         y2JQ==
X-Gm-Message-State: AOAM533lUW0QevYQ5gJUQN1+42PXyZNApbr3Z24LzGPpaDHIRAXarG9N
        gqdyqFPsavMel+NnwEi45DZW3hO3DIiYveqdExJ9fDuR2xOK/E/kTUvGWXiGE3FGxniIQgPrWB8
        XqrVtxoZhjiTm
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr12991479wmg.37.1607252180121;
        Sun, 06 Dec 2020 02:56:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyGX3cca6nPagY2g70Cl2YOoYgsl0EaRP4WwTL7DXdmVUAvbBY8Gmu27mN+p01TBovcAihFAA==
X-Received: by 2002:a7b:cf37:: with SMTP id m23mr12991464wmg.37.1607252179933;
        Sun, 06 Dec 2020 02:56:19 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.gmail.com with ESMTPSA id w17sm10634246wru.82.2020.12.06.02.56.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Dec 2020 02:56:18 -0800 (PST)
Subject: Re: [GIT PULL] KVM/arm64 fixes for 5.10, take #5
To:     Marc Zyngier <maz@kernel.org>
Cc:     Keqian Zhu <zhukeqian1@huawei.com>, Will Deacon <will@kernel.org>,
        Yanan Wang <wangyanan55@huawei.com>, kernel-team@android.com,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20201204181914.783445-1-maz@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <f8775fc2-8501-1674-03f4-d6660987a86f@redhat.com>
Date:   Sun, 6 Dec 2020 11:56:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201204181914.783445-1-maz@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 04/12/20 19:19, Marc Zyngier wrote:
> Hi Paolo,
> 
> A week ago, I was hoping being done with the 5.10 fixes. I should
> obviously know better.
> 
> Thanks to Yanan's excellent work, we have another set of page table
> fixes, all plugging issues introduced with our new page table code.
> The problems range from memory leak to TLB conflicts, all of which are
> serious enough to be squashed right away.
> 
> Are we done yet? Fingers crossed.

Pulled, thanks.  I am not sure I'll get my own pull request to Linus 
today, though.

Paolo


> Please pull,
> 
> 	M.
> 
> The following changes since commit 23bde34771f1ea92fb5e6682c0d8c04304d34b3b:
> 
>    KVM: arm64: vgic-v3: Drop the reporting of GICR_TYPER.Last for userspace (2020-11-17 18:51:09 +0000)
> 
> are available in the Git repository at:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-fixes-5.10-5
> 
> for you to fetch changes up to 7d894834a305568a0168c55d4729216f5f8cb4e6:
> 
>    KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort() (2020-12-02 09:53:29 +0000)
> 
> ----------------------------------------------------------------
> kvm/arm64 fixes for 5.10, take #5
> 
> - Don't leak page tables on PTE update
> - Correctly invalidate TLBs on table to block transition
> - Only update permissions if the fault level matches the
>    expected mapping size
> 
> ----------------------------------------------------------------
> Yanan Wang (3):
>        KVM: arm64: Fix memory leak on stage2 update of a valid PTE
>        KVM: arm64: Fix handling of merging tables into a block entry
>        KVM: arm64: Add usage of stage 2 fault lookup level in user_mem_abort()
> 
>   arch/arm64/include/asm/esr.h         |  1 +
>   arch/arm64/include/asm/kvm_emulate.h |  5 +++++
>   arch/arm64/kvm/hyp/pgtable.c         | 17 ++++++++++++++++-
>   arch/arm64/kvm/mmu.c                 | 11 +++++++++--
>   4 files changed, 31 insertions(+), 3 deletions(-)
> 

