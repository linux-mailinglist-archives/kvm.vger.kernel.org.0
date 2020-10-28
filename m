Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F42C29D581
	for <lists+kvm@lfdr.de>; Wed, 28 Oct 2020 23:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728588AbgJ1WD3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Oct 2020 18:03:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:41726 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729710AbgJ1WDS (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 28 Oct 2020 18:03:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603922597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ridPRJ1LvRFxYHi2gAnRyeYeQZqM7yJdqJ8GPHQDCTI=;
        b=CN7sfmCYMnxtavRid1H7OcIWmtEpf807DvlopzL0LL8smmVKlDbpzvEYtzeIAP7cA6HSSW
        dCgFGrNF6Hw6CDkxvBFfjqZ7IQpYdFWT1cs4BUQiqcuVGLURCV0exh25r4U60ovTGEq8NX
        BDJLUwGGCWSpVbm4hsig9v2Y/rilYuk=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-67-6lH31mr0Pui8VUjGUEAxVw-1; Wed, 28 Oct 2020 11:01:23 -0400
X-MC-Unique: 6lH31mr0Pui8VUjGUEAxVw-1
Received: by mail-wm1-f71.google.com with SMTP id l23so1041754wmg.6
        for <kvm@vger.kernel.org>; Wed, 28 Oct 2020 08:01:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ridPRJ1LvRFxYHi2gAnRyeYeQZqM7yJdqJ8GPHQDCTI=;
        b=Xpq9pcoCzgqo34KCbM1Gm209/tbAV3gBsyk9NDF8YPMPBRRIHUKdw+p9Q/E5rxZWcZ
         RNW+b35qAYYwgCrnIZqw65q4ivauLDcghIy2ErC/9w/21Aczu3N/NfNdQ4ApuD0XYE/P
         TogLbWU1jc1UWyGh/+/F0k6W+XSrYffZ+5Z+PGIN6VWJZZH0vFMteXfOfTkJlfkmSUA+
         M53dm/Q9WxBlBEtdb9pzYsOEd3u6HnlUiToBQ4v+KpMLkKbm4MlfPT0RsMJkBDmM2cWg
         94n34UCtRISxAdGWlpmyk3LlA7swCHPMLTmqCiK4ZPs1RB6fGw/QCYg63N1dWCanWACb
         Mjjg==
X-Gm-Message-State: AOAM533YDlfHyvypRmpi+X559w3GSC8xV1uGa08/wX6EDFhiU2lzCXT4
        QvBwdIg3XwMfX/D8tNv1oDRLQb9WMK0zptj37m0RiwuF1Dm+HpfveQob13DXMV9UKvR/RMSF9GR
        xl+baoSzwoa6V
X-Received: by 2002:a5d:424a:: with SMTP id s10mr3438440wrr.130.1603897281940;
        Wed, 28 Oct 2020 08:01:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzK/CHIYjwACBHBt8dKepNyg7eUiEF/T5Ab2GPWm3ISZvo7NlhetD8d0Q6ozwqy2ck3A63AzQ==
X-Received: by 2002:a5d:424a:: with SMTP id s10mr3437925wrr.130.1603897276850;
        Wed, 28 Oct 2020 08:01:16 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id 30sm7374221wrs.84.2020.10.28.08.01.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2020 08:01:16 -0700 (PDT)
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ben Gardon <bgardon@google.com>
References: <20201027214300.1342-1-sean.j.christopherson@intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 0/3] KVM: x86/mmu: Add macro for hugepage GFN mask
Message-ID: <80038ae1-d603-dc22-1997-1ad7da0a936d@redhat.com>
Date:   Wed, 28 Oct 2020 16:01:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201027214300.1342-1-sean.j.christopherson@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/20 22:42, Sean Christopherson wrote:
> Add a macro, which is probably long overdue, to replace open coded
> variants of "~(KVM_PAGES_PER_HPAGE(level) - 1)".  The straw that broke the
> camel's back is the TDP MMU's round_gfn_for_level(), which goes straight
> for the optimized approach of using NEG instead of SUB+NOT (gcc uses NEG
> for both).  The use of '-(...)' made me do a double take (more like a
> quadrupal take) when reading the TDP MMU code as my eyes/brain have been
> heavily trained to look for the more common '~(... - 1)'.

The upside is that a "how many" macro such as KVM_PAGES_PER_HPAGE will
have only one definition that makes sense.  With a "mask" macro you
never know if the 1s are to the left or to the right.  That is, does
"gfn & KVM_HPAGE_GFN_MASK(x)" return the first gfn within the huge page
or the index of the page within the huge page?

This is actually a problem with this series; see this line in patch 3:

-	mask = KVM_PAGES_PER_HPAGE(level) - 1;
+	mask = ~KVM_HPAGE_GFN_MASK(level);
        ^^^^                  ^^^^

So it's a mask, but not _that_ mask, _another_ mask. :)  That's why I
don't really like "mask" macros, now the other question is how to
express bit masking with "how many" macros.

First of all, I think we all agree that when reading "x & how_many()" we
assume (or we check first thing of all) that the right side is a power
of two.  I like "x & -y" because---even if your eyes have trouble
distinguishing "-" from "~"---it's clearly not "x & (y-1)" and therefore
the only sensible operation that the AND can do "clear everything to the
right".

Now I realize that maybe my obsession for bit twiddling tricks is not
shared with everyone, and of course if you're debugging it you have to
look closer and check if it's really "x & -y" or "x & ~y", but at least
in normal cursory code reading that's how it works for me.


Paolo

