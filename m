Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2231E2CF
	for <lists+kvm@lfdr.de>; Wed, 17 Feb 2021 23:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233406AbhBQWvx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Feb 2021 17:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbhBQWvp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Feb 2021 17:51:45 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53083C0613D6
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 14:51:05 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id g20so155319plo.2
        for <kvm@vger.kernel.org>; Wed, 17 Feb 2021 14:51:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gWwYr0s0Pd0lrE6qpWWSKWiLIJ1ICefuI8SGvs5PCCI=;
        b=BwNEZo/uMnUvV84uNLV3wlI9IibOa+RKEp/9kxTKuAmnJLZcXhpudPHAJvEPVJjqyg
         CLnO11IA8QWPIXTX3gm6aU1pDPJpimH8EzKuKxZTuJxN+CZ/COpYtSOKnWlRyLGRr9cg
         oUEl+hTELV4NX+aMLxwObKsBJ+EgAN62bQOfQnYnJsguTWG2cTJOuqt3Lf2VvFfxG9C/
         R9dYYXf4wJb7HK2xnf0svEOuwawqPgutBJDMelz/OnywFdmIgW8RJMj/gyKFLhjf5SfC
         G3t4cSm44H3qGb2tVoew+wnwHHNq9XOiCyPqD/fTt3nwCN6GmUeuSmMKLtquG2pCYwoM
         tE4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gWwYr0s0Pd0lrE6qpWWSKWiLIJ1ICefuI8SGvs5PCCI=;
        b=T9eB9ckYC4wPZhatJxjvj3+uZvB/g1gMca2xKUErewyzZ0+rRiPRtM6VVT591iU/L9
         dbNn703JPf+G9ghATJJx4k1ikt1Mcwm+gEGC7Qz3JmRYgs/wY/NCvoAHc8BJmGOWUaQV
         Er+PFSq3wl+bzf6Bhs85LZOsmsz928+SeLFbgMaVzrJaCwbh3uj73VQof1P7FsVyi0sZ
         YXaPOQDCb0YlPyAh/pAZ3rLxnatECPfB0hcxLyvBP2nEdInmKXP8B3JJTXuDKvvMJTeD
         WldCNdGZmlpG0lkfnXAI0T6Gz8ZFSU3xcxVqj2V41AE81UrMDoD1T3vdQXAHTxtHXKV4
         vtaA==
X-Gm-Message-State: AOAM532KxVGy/o9AJJm94bqreD4oRgv7brAJu899wVIFbR4g8lNPoZUw
        tO3VLJwv5+eTWaYvTH0o4MGUfg==
X-Google-Smtp-Source: ABdhPJx9fClsRISNCiWm/gQ103a2Y9OtUG2MLjoFzn7CA4sDZy/+YZ1vnqhdpdDfd30MCJfDu9jOzw==
X-Received: by 2002:a17:90b:1bcf:: with SMTP id oa15mr1043843pjb.78.1613602264695;
        Wed, 17 Feb 2021 14:51:04 -0800 (PST)
Received: from google.com ([2620:15c:f:10:dc76:757f:9e9e:647c])
        by smtp.gmail.com with ESMTPSA id q13sm2735111pfg.61.2021.02.17.14.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 14:51:04 -0800 (PST)
Date:   Wed, 17 Feb 2021 14:50:57 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Makarand Sonare <makarandsonare@google.com>
Subject: Re: [PATCH 00/14] KVM: x86/mmu: Dirty logging fixes and improvements
Message-ID: <YC2d0ZkdCOJEWlng@google.com>
References: <20210213005015.1651772-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213005015.1651772-1-seanjc@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Feb 12, 2021, Sean Christopherson wrote:
> Paolo, this is more or less ready, but on final read-through before
> sending I realized it would be a good idea to WARN during VM destruction
> if cpu_dirty_logging_count is non-zero.  I wanted to get you this before
> the 5.12 window opens in case you want the TDP MMU fixes for 5.12.  I'll
> do the above change and retest next week (note, Monday is a US holiday).

Verified cpu_dirty_logging_count does indeed hit zero during VM destruction.

Adding a WARN to KVM would require adding an arch hook to kvm_free_memslots(),
otherwise the count will be non-zero if the VM is destroyed with dirty logging
active.  That doesn't seem worthwhile, so I'm not planning on pursuing a WARN
for the upstream code.
