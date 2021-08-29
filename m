Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C553C3FA83E
	for <lists+kvm@lfdr.de>; Sun, 29 Aug 2021 04:35:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233635AbhH2Cg2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 28 Aug 2021 22:36:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbhH2Cg1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 28 Aug 2021 22:36:27 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 313C4C061756
        for <kvm@vger.kernel.org>; Sat, 28 Aug 2021 19:35:36 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id s16so11781726ilo.9
        for <kvm@vger.kernel.org>; Sat, 28 Aug 2021 19:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=RudsPPL2jXFkdPRzt+igCskpzL+QGPjfc2x3ccwPC9w=;
        b=J9dShv8oT22vhmmqH2pkP0XLxIOEJ7tW9eSIEdnG1fyr3GwcpVNpmGYZWHtUTPwbdc
         lKZST7xRrEZtCCb+YWt8Xhzpj6P/kSiXR0smrgRiSTf5HtapPENUniwt6x6XneYgBx0f
         MhIbbwvej2DS9j87DesFkvJyYr27DVk+uIr34OeQabcGSnyM56UwM+VJQyZowkGY0Neh
         OsWFl9GKalS1FqlEsxb3bHlOl0fYVMlSmFGYXE7WCyXLDSvB9bwTTYN1vCxZ84vvyh5r
         lSjypE12DhI1TxK1lGSxbhqQx8NkclxW++kh+LZbm+cV6BzzD9CA8RVPG7HK+8BEXDGe
         18qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=RudsPPL2jXFkdPRzt+igCskpzL+QGPjfc2x3ccwPC9w=;
        b=Z2fgwVSEubtoi3ZwLNwKjmT7/ikjSFge4VLPUZPVkIrm9dgikWt4Tw1ps8kSfRv4Py
         026gUYg2dHZwzjathRA/AACWf6cC+R03xhESkzZ3ffzhuol8X+dfiS9hx9vY6rcytiDW
         YTUFp9rVa9OxyaycnSQXo0c3LEh8a93iKfevGgSlbFZGefeS2rWaCP69gS1jfmQE5Bsf
         ardviGdr1kMXY/XEUEPZ3XhBH/QVZexsybTapTrZDsJRgHRHqDSitLCIM2HYdt4UY2S0
         hSUkuZwfV0RglWIUySpB1+j1KD43oU1zZx6qt7TtVKMT2NlddSTNS5Mjm4DCr0Lz8y8G
         QqoA==
X-Gm-Message-State: AOAM533nzPGebWHaeDkehilpeeDiJLTRp5y35wOvKtKFU29WGH3eo7od
        /BqPmWadvseTdbvSu52KhL6PVI5JYbNgssIB
X-Google-Smtp-Source: ABdhPJwqUHMTxEkDQA8hFpGHHEo0tu8/O2NMjK/5E7lfYuh/Mo0XzToNBlb9dDEkFv0S5CWvSmaOLA==
X-Received: by 2002:a92:cda4:: with SMTP id g4mr11981754ild.236.1630204534995;
        Sat, 28 Aug 2021 19:35:34 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id h11sm1851451ilc.7.2021.08.28.19.35.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 19:35:34 -0700 (PDT)
Date:   Sun, 29 Aug 2021 02:35:30 +0000
From:   Oliver Upton <oupton@google.com>
To:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
        Jim Mattson <jmattson@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Jing Zhang <jingzhangos@google.com>,
        Raghavendra Rao Anata <rananta@google.com>,
        James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Andrew Jones <drjones@redhat.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v7 3/7] KVM: arm64: Allow userspace to configure a vCPU's
 virtual offset
Message-ID: <YSryci4dSuRAEg+g@google.com>
References: <20210816001217.3063400-1-oupton@google.com>
 <20210816001217.3063400-4-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816001217.3063400-4-oupton@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 16, 2021 at 12:12:13AM +0000, Oliver Upton wrote:
> Allow userspace to access the guest's virtual counter-timer offset
> through the ONE_REG interface. The value read or written is defined to
> be an offset from the guest's physical counter-timer. Add some
> documentation to clarify how a VMM should use this and the existing
> CNTVCT_EL0.
> 
> Signed-off-by: Oliver Upton <oupton@google.com>
> Reviewed-by: Andrew Jones <drjones@redhat.com>

Hrm...

I was mulling on this patch a bit more and had a thought. As previously
discussed, the patch implements virtual offsets by broadcasting the same
offset to all vCPUs in a guest. I wonder if this may tolerate bad
practices from userspace that will break when KVM supports NV.

Consider that a nested guest may set CNTVOFF_EL2 to whatever value it
wants. Presumably, we will need to patch the handling of CNTVOFF_EL2 to
*not* broadcast to all vCPUs to save/restore NV properly. If a maligned
VMM only wrote to a single vCPU, banking on this broadcasting
implementation, it will fall flat on its face when handling an NV guest.

So, should we preemptively move to the new way of the world, wherein
userspace accesses to CNTVOFF_EL2 are vCPU-local rather than VM-wide?

No strong opinions in either direction, but figured I'd address it since
I'll need to respin this series anyway to fix ECV+nVHE.

--
Thanks,
Oliver
