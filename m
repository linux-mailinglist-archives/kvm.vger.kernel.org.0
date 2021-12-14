Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6B1474EC4
	for <lists+kvm@lfdr.de>; Wed, 15 Dec 2021 00:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238361AbhLNXwY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Dec 2021 18:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbhLNXwX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Dec 2021 18:52:23 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66E30C061574
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:52:23 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id np3so15740973pjb.4
        for <kvm@vger.kernel.org>; Tue, 14 Dec 2021 15:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wfIG+SGhHD6pwHJa5r5iuZJEx4PYENWt/4XZr/efceQ=;
        b=cIBPM3bHEpE2ripHOiKOPSLGgA7lZ+ZqU0S/mPkqDqPVym3/AAWp8sJDP0dSxgM7T1
         PU051KjRc5v62e2k62uh3WZaP0OdEBoCumHlzO8cArQyi9fS7DW/4n5Pv0N1KC3lGdP7
         Y1uyvYkLHdxIxdCDxSlyAScU4M9RZcPvX0I4b+KFaxAIsmdm60UG47VeCOoK4TK0uOmk
         y2IP3f7FiMo9Sr2ul1ktPv61KMUtXO3BhTmzw2L8zDHR84PDFa1phUk+8fRP2h+La9kG
         vtNFfNRc8ZABBbHPdvjAtoX8v3Br7f0sIejsiSdBpmNbb5KWAu1Lfbhyi2QLkphIT/J+
         OPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wfIG+SGhHD6pwHJa5r5iuZJEx4PYENWt/4XZr/efceQ=;
        b=JTj7Ojjx0pewvhG6QFmzkCUbH+JBPgHaJrtr+kYjGoKQE56CdXDjv0IUWqPzRjbgr7
         dHnjFFaHq3ayL8/z7v47zv51pSGyiXBX+y03ST7cL4LUqr+RMKXhp+O4XytTVWF0TPqx
         9AAg1v74n3/sGeg9+frawF/YA0iWqPtVFwuOKvnfI8Q4gUKe1HCnBqPY6i0wWQiM0IUX
         2G4LRDE7VPEX/CmGYOHahGK62x9GQML1eXP0rP6/vToxMiIeBm2/AGjv8eFn5HqrQPVV
         sgIjK9+p5F6KlAHx3z/nBUQQVe8GEQkpY7ILhV1c2tg8B5qd0IyDhc08VPQPVKbCqZDB
         /45g==
X-Gm-Message-State: AOAM530Uapa2h8h7fiC50m/sby/Sna98hrMRMb+BLllAYQe2q2z9hWFF
        tgHcDZe0huxOM8XcTPMU3xZ8dA==
X-Google-Smtp-Source: ABdhPJyKR+hA9rCXZ4UpvUMDta6mvhVNjcjAmZ+p+FU2D2jdj+1XjszxzMdCQJWFh43KY4Ze3JCUQw==
X-Received: by 2002:a17:902:c20d:b0:142:1009:585d with SMTP id 13-20020a170902c20d00b001421009585dmr8211293pll.83.1639525942789;
        Tue, 14 Dec 2021 15:52:22 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id z22sm203225pfe.93.2021.12.14.15.52.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:52:22 -0800 (PST)
Date:   Tue, 14 Dec 2021 23:52:19 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>
Subject: Re: [PATCH 10/28] KVM: x86/mmu: Allow yielding when zapping GFNs for
 defunct TDP MMU root
Message-ID: <YbkuM4jEbJX6QQR6@google.com>
References: <20211120045046.3940942-1-seanjc@google.com>
 <20211120045046.3940942-11-seanjc@google.com>
 <CANgfPd_H3CZn_rFfEZoZ7Sa==Lnwt4tXSMsO+eg5d8q9n39BSQ@mail.gmail.com>
 <YbksiTgVdzN0Z6Dn@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbksiTgVdzN0Z6Dn@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Dec 14, 2021, Sean Christopherson wrote:
> Assuming there is exactly one helper, that would also address my
> concerns with kvm_tdp_mmu_zap_invalidated_roots() being unsafe to call in parallel,
> e.g. two zappers processing an invalid root would both put the last reference to
> a root and trigger use-after-free of a different kind.

I take that back.  So long as both callers grabbed a reference to the root, multiple
instances are ok.  I forgot that kvm_tdp_mmu_zap_invalidated_roots() doesn't take
roots off the list directly, that's handled by kvm_tdp_mmu_put_root().
