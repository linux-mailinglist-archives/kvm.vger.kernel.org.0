Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38009339A6C
	for <lists+kvm@lfdr.de>; Sat, 13 Mar 2021 01:30:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhCMA1D (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 Mar 2021 19:27:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbhCMA0o (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 Mar 2021 19:26:44 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DAA2C061574
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:26:44 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id n17so9121725plc.7
        for <kvm@vger.kernel.org>; Fri, 12 Mar 2021 16:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vNRpYg3mNXhJ4EvT4QVsetlahXm7tTJ+Ei2tmIgYcGk=;
        b=CwuBwBYEqQ0MfZY/RYslKueCBMpAtG8LOwNU5tg4QcEpihijcpdWqSNQzo7XIkAMQ4
         0+WF9LwmesCxenPaTSRwhrlJ6tiNHdcs9EDFeYwYkIlsxY+Aq6GuzW/IPcWiNHkMV9ZC
         s3eXk860yJTAMfSN09JR0Tlev4icJsi8QVf3hRl76DzHYCvLcx8EMZePHXT+AalyHl3b
         47jxQXpDCPT62S3w9eOPvM1OBF4EVSArHcYP0kPHogzuTMBOvRihfXFsi2OLrAspQKVM
         7cl7JcXUpU0GIzeQgEIaK43ro6uMdiZZ/iLoGCMVy2S8Ka52YA98xU/Y5fw3gGEJvW2b
         Ft2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vNRpYg3mNXhJ4EvT4QVsetlahXm7tTJ+Ei2tmIgYcGk=;
        b=k7TpUFK3FZOTWk4LBO5TMlpIPJ3zg93R1O75Ti12IlroashFrjzKQrlSzP8MOab6P3
         iGqh8vo2ScGVCJ8DeWV+qNT54TO9yVzxDfz1gDeJokNTpdS4lp22r2WlcaTVDGGXgTWf
         lXRa/Gw3JbpOFhj25mXdxaeH00TNYRXIR/NM5lOfFvypNCOUFFAP8FGDlvvmnzpPLEAB
         3hZyrQhq+4sByBKxpvZeu4htnaGuFMT5JSm9JfgDUn7PyTI0jVmXS2b/2gq2HA1zD2Yv
         fdSfaWaehI5PVkmWAZIU1rW5Te8JksD1ZWHYUyqYk7RXQiJd0AtJWOev2mY9k8gq1KNC
         Pi3A==
X-Gm-Message-State: AOAM53302C8YWgySI7AoaxsLXmglOap1knSHaD7F0/38szPK9YH/x5Da
        3q+QTaFXSxZ9tICiVXc08wD1Xg==
X-Google-Smtp-Source: ABdhPJyrDVEwyIJWQ/zoMQWV8ziBMF1idnxWF6Q8rvjlerzFXMpFvXoH3nEYW46ep6JDtJXBpoaOfA==
X-Received: by 2002:a17:903:189:b029:e5:d7c3:a264 with SMTP id z9-20020a1709030189b02900e5d7c3a264mr1056141plg.6.1615595203624;
        Fri, 12 Mar 2021 16:26:43 -0800 (PST)
Received: from google.com ([2620:15c:f:10:e1a6:2eeb:4e45:756])
        by smtp.gmail.com with ESMTPSA id co20sm3409772pjb.32.2021.03.12.16.26.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 16:26:43 -0800 (PST)
Date:   Fri, 12 Mar 2021 16:26:36 -0800
From:   Sean Christopherson <seanjc@google.com>
To:     "wangyanan (Y)" <wangyanan55@huawei.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>,
        Andrew Jones <drjones@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 04/15] KVM: selftests: Force stronger HVA alignment (1gb)
 for hugepages
Message-ID: <YEwGvHe+wcaEG0W8@google.com>
References: <20210210230625.550939-1-seanjc@google.com>
 <20210210230625.550939-5-seanjc@google.com>
 <9a870968-f381-3e0b-2840-62b7c2b2e032@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a870968-f381-3e0b-2840-62b7c2b2e032@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 25, 2021, wangyanan (Y) wrote:
> 
> On 2021/2/11 7:06, Sean Christopherson wrote:
> > Align the HVA for hugepage memslots to 1gb, as opposed to incorrectly
> > assuming all architectures' hugepages are 512*page_size.
> > 
> > For x86, multiplying by 512 is correct, but only for 2mb pages, e.g.
> > systems that support 1gb pages will never be able to use them for mapping
> > guest memory, and thus those flows will not be exercised.
> > 
> > For arm64, powerpc, and s390 (and mips?), hardcoding the multiplier to
> > 512 is either flat out wrong, or at best correct only in certain
> > configurations.
> > 
> > Hardcoding the _alignment_ to 1gb is a compromise between correctness and
> > simplicity.  Due to the myriad flavors of hugepages across architectures,
> > attempting to enumerate the exact hugepage size is difficult, and likely
> > requires probing the kernel.
> > 
> > But, there is no need for precision since a stronger alignment will not
> > prevent creating a smaller hugepage.  For all but the most extreme cases,
> > e.g. arm64's 16gb contiguous PMDs, aligning to 1gb is sufficient to allow
> > KVM to back the guest with hugepages.
> I have implemented a helper get_backing_src_pagesz() to get granularity of
> different
> backing src types (anonymous/thp/hugetlb) which is suitable for different
> architectures.
> See:
> https://lore.kernel.org/lkml/20210225055940.18748-6-wangyanan55@huawei.com/
> if it looks fine for you, maybe we can use the accurate page sizes for
> GPA/HVA alignment:).

Works for me.  I'll probably just wait until your series is queued to send v2.

Thanks again!
