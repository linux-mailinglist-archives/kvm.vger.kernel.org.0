Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19E983E8667
	for <lists+kvm@lfdr.de>; Wed, 11 Aug 2021 01:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235314AbhHJXXF (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 Aug 2021 19:23:05 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60820 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235242AbhHJXXE (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 10 Aug 2021 19:23:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628637761;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=zebpogOe1quBLKE4Uo3idNxbcVJ3dkkOF+OjhdeOFhQ=;
        b=FMrVYRLtPn/LMWUPRMnvWG5Vfsv5VTX2KRKmpoNAHk9OMZ2t5l6lpEgGfsn2kXq6r8ARic
        fVv03R+vTFACinhXKG+CJzCTCV+rJKO6WGnbmrD76l76OnXrODqSSvOl3j7tkIe0GrfTuT
        20/CaSJ7yIaXQMKcLpFTp0XYuxkHqnI=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-07jvgxabMKe8s9RVNocoFQ-1; Tue, 10 Aug 2021 19:22:40 -0400
X-MC-Unique: 07jvgxabMKe8s9RVNocoFQ-1
Received: by mail-qt1-f200.google.com with SMTP id e3-20020ac80b030000b029028ac1c46c2aso355699qti.2
        for <kvm@vger.kernel.org>; Tue, 10 Aug 2021 16:22:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zebpogOe1quBLKE4Uo3idNxbcVJ3dkkOF+OjhdeOFhQ=;
        b=AomwRKhIYBoA1tDSCnD604CMUg2dhzQX3VnDbAksbIICSGen8ASmK51iaNLZnB1mpq
         Ym9SbwKNc52J3OJTT03Os4YBnmSnTD34A/ZMPJ69cpthPeKnwVSmaFHwKmIBpYd9JZmH
         IhIwxu2YiU/YSVRiLLgl9jnhVQidL3uzhlqvzqTLnmr9tVvC9U0m3Sysl+1cVuWJQlMh
         TgWJSOr4mQzut9hYmjlKPplg74jjvPxVRR5zuigo3m/VDQvakesn0YOF5k00E2RX0841
         hLJPSRaY7UbcFq4ofC6/mjnoygJKPh/dzhrt83k46gNR1fEfn/WiPX9eeC3sUIQexI5g
         t+lQ==
X-Gm-Message-State: AOAM530Sr3kxXyaRa9yREf3oy7PzQ2FIgKw9UHbZHe3qvNwB5pXqOmsW
        Eut7XwC+ipbX9itxzZAK7DyM5mgTqxvxOzRxfrhesmSDGiFK/IrDWJyAJAOAbo3b0//NpPSgD4Q
        IrptvsevzQ2Mr
X-Received: by 2002:a05:620a:318b:: with SMTP id bi11mr17242547qkb.302.1628637759723;
        Tue, 10 Aug 2021 16:22:39 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxRqxrHLUeXL8415G82p0kwf+OoH+p90MLbtMF/Y3gvXjd4Z1rzFmseE9OfMSwFwyYvyHyAVA==
X-Received: by 2002:a05:620a:318b:: with SMTP id bi11mr17242527qkb.302.1628637759517;
        Tue, 10 Aug 2021 16:22:39 -0700 (PDT)
Received: from t490s (bras-base-toroon474qw-grc-92-76-70-75-133.dsl.bell.ca. [76.70.75.133])
        by smtp.gmail.com with ESMTPSA id b11sm5934711qtt.42.2021.08.10.16.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 16:22:38 -0700 (PDT)
Date:   Tue, 10 Aug 2021 19:22:37 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Mingwei Zhang <mizhang@google.com>
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
Message-ID: <YRMKPd2ZarXCX6vm@t490s>
References: <20210803044607.599629-1-mizhang@google.com>
 <20210803044607.599629-4-mizhang@google.com>
 <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com>
 <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
 <CAL715WLO9+CpNa4ZQX4J2OdyqOBsX0+g0M4bNe+A+6FVxB2OxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAL715WLO9+CpNa4ZQX4J2OdyqOBsX0+g0M4bNe+A+6FVxB2OxA@mail.gmail.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 09, 2021 at 05:01:39PM -0700, Mingwei Zhang wrote:
> Hi Paolo,

Hi, Mingwei,

> 
> I recently looked at the patches queued and I find this patch from
> Peter Xu (Cced), which is also adding 'page stats' information into
> KVM:
> 
> https://patchwork.kernel.org/project/kvm/patch/20210625153214.43106-7-peterx@redhat.com/
> 
> From a functionality point of view, the above patch seems duplicate
> with mine.

The rmap statistics are majorly for rmap, not huge pages.

> But in detail, Peter's approach is using debugfs with
> proper locking to traverse the whole rmap to get the detailed page
> sizes in different granularity.
> 
> In comparison, mine is to add extra code in low level SPTE update
> routines and store aggregated data in kvm->kvm_stats. This data could
> be retrieved from Jing's fd based API without any lock required, but
> it does not provide the fine granular information such as the number
> of contiguous 4KG/2MB/1GB pages.
> 
> So would you mind giving me some feedback on this patch? I would
> really appreciate it.

I have a question: why change to using atomic ops?  As most kvm statistics
seems to be not with atomics before.

AFAIK atomics are expensive, and they get even more expensive when the host is
bigger (it should easily go into ten-nanosecond level).  So I have no idea
whether it's worth it for persuing that accuracy.

Thanks,

-- 
Peter Xu

