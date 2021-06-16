Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B30BA3AA451
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 21:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232583AbhFPTaH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 15:30:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232357AbhFPTaG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 15:30:06 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 461D4C061574
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 12:28:00 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k6so2980211pfk.12
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 12:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HKHWGTrGy4FXlfxw+kBA8/G3Swt20UvMDMHWd03XfSI=;
        b=MvpzMUsWPVTqOgUKRuNaLOxMgx7TX6OCIW6JKZu9OmkLTfXDulnStMcRc+PJB/DxvP
         OsrgkLsF8YLFSPg2CSQ+SPR8zF9SP4BGYhrPH6xm+VoBC8un6uhgQKpjKfheJKbkyVwy
         mt5YkpaOpdSOWIE4wMmoREOw2fi/3UGaIT7e37eUe9vxSMsUv2CUHNfud5OZX3kntvK4
         9Bfd1MeAn3tdzcnEoMJh2crCqGqKI7fl1/zn0nUlu5IPJDBHJut53v5yR4ABQXAzQAoa
         htOYxpIxJtVV4qorPBsdIOdrRj+WuqPTgpRcOgoQerUuYCmAaYxYiovGrKbUQWi2uOwE
         k5sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HKHWGTrGy4FXlfxw+kBA8/G3Swt20UvMDMHWd03XfSI=;
        b=PF2Vw2xSL4XF4buZfGVVKw6rlnrjrbboCXah39arCbMt2Ezwf1zJXSfWP2fbG7gLA4
         IxloVz9k4lq8nUUN4sk1pSYz/Bwm/4dnb1b/WXQDltTOBhkqAZ3sFycmFucByhDlVWzM
         XTIaFx0je/h9aDmQXjqUB5n8v2zbGAgUKKLOgtZ1wmffKXbJfI1ugT/hbEABZeLU7AX0
         xmP9B3Qt/ejqeLL4xUxhkXynpya3j3oRUM1UmVe7kESv4gJH7yk3EEXowSt/c2NPswf4
         SsnP8yPvgFM2cUPgBi4wbiaUVHckjgOe5mNEwC8xQ3MhY2ZZdAJ57EtEOQ24N8kdgvT2
         WlKA==
X-Gm-Message-State: AOAM530BkXAectFtGngcdh+V/Eg8eCsCGK5MsuXXQnz/2kpllwX3Rqwv
        dDIu1faQdo7BUcPa/9tXwQ6JzA==
X-Google-Smtp-Source: ABdhPJyYDhzBr9VTK75qx4jKJm5EI6bN9PO9QhEPhWadgapVhjPn7zrGPanO4gLnlMiZG7s0gcIqtw==
X-Received: by 2002:a05:6a00:1404:b029:2eb:2f32:4ac2 with SMTP id l4-20020a056a001404b02902eb2f324ac2mr1341647pfu.22.1623871679357;
        Wed, 16 Jun 2021 12:27:59 -0700 (PDT)
Received: from google.com (254.80.82.34.bc.googleusercontent.com. [34.82.80.254])
        by smtp.gmail.com with ESMTPSA id k13sm2857886pfh.68.2021.06.16.12.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 12:27:58 -0700 (PDT)
Date:   Wed, 16 Jun 2021 19:27:55 +0000
From:   David Matlack <dmatlack@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, Ben Gardon <bgardon@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Junaid Shahid <junaids@google.com>,
        Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH 0/8] KVM: x86/mmu: Fast page fault support for the TDP MMU
Message-ID: <YMpQu6q1YViuLwhg@google.com>
References: <20210611235701.3941724-1-dmatlack@google.com>
 <639c54a4-3d6b-8b28-8da7-e49f2f87e025@redhat.com>
 <YMfFQnfsq5AuUP2B@google.com>
 <a13646ce-ee54-4555-909b-2d2977f65f59@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a13646ce-ee54-4555-909b-2d2977f65f59@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 15, 2021 at 09:16:00AM +0200, Paolo Bonzini wrote:
> On 14/06/21 23:08, David Matlack wrote:
> > I actually have a set of
> > patches from Ben I am planning to send soon that will reduce the number of
> > redundant gfn-to-memslot lookups in the page fault path.
> 
> That seems to be a possible 5.14 candidate, while this series is probably a
> bit too much for now.

Thanks for the feedback. I am not in a rush to get either series into
5.14 so that sounds fine with me. Here is how I am planning to proceed:

1. Send a new series with the cleanups to is_tdp_mmu_root Sean suggested
   in patch 1/8 [1].
2. Send v2 of the TDP MMU Fast Page Fault series without patch 1/8.
3. Send out the memslot lookup optimization series.

Does that sound reasonable to you? Do you have any reservations with
taking (2) before (3)?

[1] https://lore.kernel.org/kvm/YMepDK40DLkD4DSy@google.com/

> 
> Paolo
> 
