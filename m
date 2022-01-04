Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE3F4846F1
	for <lists+kvm@lfdr.de>; Tue,  4 Jan 2022 18:25:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235236AbiADRZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Jan 2022 12:25:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiADRZm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Jan 2022 12:25:42 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 344BBC061761
        for <kvm@vger.kernel.org>; Tue,  4 Jan 2022 09:25:42 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id g2so33270202pgo.9
        for <kvm@vger.kernel.org>; Tue, 04 Jan 2022 09:25:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Dt2cPCWEsFZ5AbysL4UkCn7JLhXrIdEBz/GoqAR1B90=;
        b=NB45Tda4CCIIb04U+XDNPZB5azw6aHsshMgvWalK1tJ39OAsDe72/kEJOx2fW6bMeG
         tdvxvimXmORNQJzTeQrOyhivszDBnLT8eQInnyfZfolZS7FmpwztJM3S9a9Qu4+VtC2M
         XFGVtgFPc13suxJgngyMOg/NAezoiRxTuw4/UY7x4PKzEKqMPvcwvzWS3+Sl3S+Rxiu7
         x/o3xwv5hYV55SYKUd/p7bh/PQkMYHKz4q4gbc4Lx5E4CtUdZ7SJt8TvcJyCLsrUsuGi
         eBKr98sjqDjtwnHVKO4OGB2Tm3jkPAMw+iNPG/nrLuXah3b7/A2gYBxhdZrtoeZxuAxV
         +j4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Dt2cPCWEsFZ5AbysL4UkCn7JLhXrIdEBz/GoqAR1B90=;
        b=RLi/6MlXQ6WrtHelGn/8R+VczBUHCbkU5kg/N6ZsFfzwjz9CUQY6jb+rYk/UX6854z
         4qIthNBejHWBLT/Dw06VYIEq7sbMUNaSpLOkT00ZO/2YCkoO897Dhhl2Q9d1cVX0eLKM
         TbvlPTld6w8OxUxgCyp/0I6gJac/l20D9loSmVTqJeslQWTJanE2uSqmVgoxgJgNgnZp
         WxHO0WKkaWwrHZfMqwudF5+nmt6/2v5tXzgLHP5Rd6c6pTD8lTMTfbooZgj6fTcVdiAK
         +tURVX5aQc5C3dzjTXyELtw4soEprfGhSwK9WlEdTugZ9Br0d8HpB38NUaJIGZXU9g5K
         hCXQ==
X-Gm-Message-State: AOAM532DJ3GGfk6yadq0jWNoHFFmpHHf601NswXmGzXqe32L1qlsATV6
        9JuCeuy3S2lMehSeRNwFdokgaw==
X-Google-Smtp-Source: ABdhPJwQvdabyHoNNTGEbHXwTynNfe/NdjpWJGah72K6zT+sA3YPBHP0aoiMjx0n1cqTIwmYvhLhXQ==
X-Received: by 2002:a05:6a00:2304:b0:4ba:4cbb:8289 with SMTP id h4-20020a056a00230400b004ba4cbb8289mr51337276pfh.79.1641317141421;
        Tue, 04 Jan 2022 09:25:41 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ip2sm36902413pjb.34.2022.01.04.09.25.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Jan 2022 09:25:40 -0800 (PST)
Date:   Tue, 4 Jan 2022 17:25:37 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Joerg Roedel <joro@8bytes.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Like Xu <likexu@tencent.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 01/17] perf/x86/intel: Add EPT-Friendly PEBS for Ice
 Lake Server
Message-ID: <YdSDEUJQgJQfZjWD@google.com>
References: <20211210133525.46465-1-likexu@tencent.com>
 <20211210133525.46465-2-likexu@tencent.com>
 <Yc321e9o16luwFK+@google.com>
 <69ad949e-4788-0f93-46cb-6af6f79a9f24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69ad949e-4788-0f93-46cb-6af6f79a9f24@gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Dec 31, 2021, Like Xu wrote:
> On 31/12/2021 2:13 am, Sean Christopherson wrote:
> > On Fri, Dec 10, 2021, Like Xu wrote:
> > > The new hardware facility supporting guest PEBS is only available on
> > > Intel Ice Lake Server platforms for now. KVM will check this field
> > > through perf_get_x86_pmu_capability() instead of hard coding the cpu
> > > models in the KVM code. If it is supported, the guest PEBS capability
> > > will be exposed to the guest.
> > 
> > So what exactly is this new feature?  I've speed read the cover letter and a few
> > changelogs and didn't find anything that actually explained when this feature does.
> > 
> 
> Please check Intel SDM Vol3 18.9.5 for this "EPT-Friendly PEBS" feature.
> 
> I assume when an unfamiliar feature appears in the patch SUBJECT,
> the reviewer may search for the exact name in the specification.

C'mon, seriously?  How the blazes am I supposed to know that the feature name
is EPT-Friendly PEBS?  Or that it's even in the SDM (it's not in the year-old
version of the SDM I currently have open) versus one of the many ISE docs?

This is not hard.  Please spend the 30 seconds it takes to write a small blurb
so that reviewers don't have to spend 5+ minutes wondering WTF this does.

  Add support for EPT-Friendly PEBS, a new CPU feature that enlightens PEBS to
  translate guest linear address through EPT, and facilitates handling VM-Exits
  that occur when accessing PEBS records.  More information can be found in the
  <date> release of Intel's SDM, Volume 3, 18.9.5 "EPT-Friendly PEBS".
