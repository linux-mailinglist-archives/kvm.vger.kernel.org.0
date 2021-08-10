Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6F3E3E5030
	for <lists+kvm@lfdr.de>; Tue, 10 Aug 2021 02:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237087AbhHJACV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Aug 2021 20:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233022AbhHJACV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Aug 2021 20:02:21 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54CD4C061796
        for <kvm@vger.kernel.org>; Mon,  9 Aug 2021 17:01:51 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id a201so32783800ybg.12
        for <kvm@vger.kernel.org>; Mon, 09 Aug 2021 17:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u/6lDzTST0h+RyT6gU/s2Pzqgb7dbZvl8tVew71+7uA=;
        b=IXgv+KRKCsBVGj/yvVKxhDgYLPxGDqCg08pFEoQWD78TZ5q04i+NdqMAx4ATfGTjzw
         4WGCqlwrSPFRgWpVrn/ib1PojT8GhH/z+vSzChsEuY1BT8qfkINf45tByHzSPvTPE/Kb
         lmO2FQsPz6b2XPf3GWv8n8RcxKrlWUIdh8Ok56CktrS6Kj4WpwpsvSirqvi7QTzgx6dA
         KeXmPH9pdNz7lJPYPZUDAZvWBlqFohqgIg2+VRL4ZnuNZKFQ/c07903n/OxOSVjnMG+M
         SLUORF78yEpLGIKTTDGYqHyjyR5g9EgR7T8uJGbnVrOIu+TESiS+rTqcn4HncxJwXEg7
         mbFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u/6lDzTST0h+RyT6gU/s2Pzqgb7dbZvl8tVew71+7uA=;
        b=lIF6S+dc9E6m1r7mgc0aQYxiepqLh1E09RdaRDU35Efy+gNNu214dKu/0axzapaCk6
         /eoKhx5vv5Y0YH/ZQfLU2mDjYGbXFhp8jH8W+osjTiDV1faRaEa0WjuH98D1HaY1VXml
         AD5kan04scsA8WYRqLHMXHta8pnREF9RyvzFRD4Z+weBaVVu4RtMyw4Ydiw2V1wWG3Ot
         zT8TrpJFS+MjwVlZ53FgylfHRfZBIIYsm+EM6a5s415My7JoucDQK11Cwpi1j/XP/FWp
         auld7Si29N+xllo8xFCw21umry0pB4tFcz9N/ijN+nTzzJiMLMjSaW3sI74vxzURug2R
         tiwQ==
X-Gm-Message-State: AOAM531OXynrdFYjUOlPdYV1xtsmu3tecDiwtBzLDeB62B/NFle8kFC2
        d82U0ZorJl4oJOtzd9lNwsgW1TVxvJDfQz5GAj99Bg==
X-Google-Smtp-Source: ABdhPJwanymbJHXSzhVU3ouc2r4BMfkwlf0QQ5JwTtfL17PzN357+PpyPsNiUZT/wN15PZ4CaB5DKmXx7A8TZqps84M=
X-Received: by 2002:a25:dcd1:: with SMTP id y200mr33427728ybe.92.1628553710295;
 Mon, 09 Aug 2021 17:01:50 -0700 (PDT)
MIME-Version: 1.0
References: <20210803044607.599629-1-mizhang@google.com> <20210803044607.599629-4-mizhang@google.com>
 <CALMp9eR4AB0O7__VwGNbnm-99Pp7fNssr8XGHpq+6Pwkpo_oAw@mail.gmail.com> <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
In-Reply-To: <CAL715WJLfJc3dnLUcMRY=wNPX0XDuL9WzF-4VWMdS_OudShXHg@mail.gmail.com>
From:   Mingwei Zhang <mizhang@google.com>
Date:   Mon, 9 Aug 2021 17:01:39 -0700
Message-ID: <CAL715WLO9+CpNa4ZQX4J2OdyqOBsX0+g0M4bNe+A+6FVxB2OxA@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] KVM: x86/mmu: Add detailed page size stats
To:     Jim Mattson <jmattson@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Jing Zhang <jingzhangos@google.com>, peterx@redhat.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Paolo,

I recently looked at the patches queued and I find this patch from
Peter Xu (Cced), which is also adding 'page stats' information into
KVM:

https://patchwork.kernel.org/project/kvm/patch/20210625153214.43106-7-peterx@redhat.com/

From a functionality point of view, the above patch seems duplicate
with mine. But in detail, Peter's approach is using debugfs with
proper locking to traverse the whole rmap to get the detailed page
sizes in different granularity.

In comparison, mine is to add extra code in low level SPTE update
routines and store aggregated data in kvm->kvm_stats. This data could
be retrieved from Jing's fd based API without any lock required, but
it does not provide the fine granular information such as the number
of contiguous 4KG/2MB/1GB pages.

So would you mind giving me some feedback on this patch? I would
really appreciate it.

Thank you. Regards
-Mingwei

-Mingwei

On Mon, Aug 9, 2021 at 4:39 PM Mingwei Zhang <mizhang@google.com> wrote:
>
> Hi Jim,
>
> No, I don't think 512G is supported. So, I will remove the
> 'pages_512G' metric in my next version.
>
> Thanks.
> -Mingwei
>
> On Mon, Aug 9, 2021 at 3:26 PM Jim Mattson <jmattson@google.com> wrote:
> >
> > On Mon, Aug 2, 2021 at 9:46 PM Mingwei Zhang <mizhang@google.com> wrote:
> > >
> > > Existing KVM code tracks the number of large pages regardless of their
> > > sizes. Therefore, when large page of 1GB (or larger) is adopted, the
> > > information becomes less useful because lpages counts a mix of 1G and 2M
> > > pages.
> > >
> > > So remove the lpages since it is easy for user space to aggregate the info.
> > > Instead, provide a comprehensive page stats of all sizes from 4K to 512G.
> >
> > There is no such thing as a 512GiB page, is there? If this is an
> > attempt at future-proofing, why not go to 256TiB?
