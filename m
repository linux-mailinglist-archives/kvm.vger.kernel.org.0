Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B830275E5E
	for <lists+kvm@lfdr.de>; Wed, 23 Sep 2020 19:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726674AbgIWRLK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Sep 2020 13:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIWRLJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Sep 2020 13:11:09 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E03C0613D1
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:11:09 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id a2so402658otr.11
        for <kvm@vger.kernel.org>; Wed, 23 Sep 2020 10:11:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FeiiwT7dy9vr47NT7pjgw3junlFoaewgeW3zaJFROxc=;
        b=MOOek79ve9vzTaguN5u3sFjj6RpzMp50NMX7QWqg0Lk4d8RcOjM6RaMKlzDHuRABH3
         MUhXP6bhNQdR92GEz3GpiYSEqov/Oqio2do2XMDvZRGxhYAa1hxaeYCLpiVjyYEmWXr4
         nUEfZZbtO9aA3xwO8E7fqw5wQ4cXpt9PZQaUiYobNhx+8FuVSzeAAJ1O9QyI8fXYrXRE
         IkpSnZSR0CMZecb4RxN7bQxlwWTMFIxBX6g3gJiXZCw3hiSJE+gM1fIVWRCEuLCZf6jI
         FgEiq9pBdMyYG2I8qeh0hP3XwWPgeodZWALYweUhN61lWPNDpk2sHb3pxxqmfGYfJ6qF
         vEmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FeiiwT7dy9vr47NT7pjgw3junlFoaewgeW3zaJFROxc=;
        b=Gb87mRIT60biiyePQxuZlwzedLo0LQEQ12Zi1U5DCRiO443nGIKwUHcSZKDKDTDU7M
         UZV7y0AnjAyAOtGyT4PJIWfGfNi1DtiWGohbaI3NOyXw5nKH1NyACl61eJ9eQFE3dhgM
         E8DiEQbaiHV6bdQ9LQFplxWqtNYSs24NG3zYkQFqvsS/KU29H5E7OEc1dAaqlfWPlA3Z
         KCuLd1c/ctK98z6w8wnAK4E6otLzraPl0xAV2Jf/6sQf+Y6OZKTIJ7kb9nMhUFV7afUU
         naIJUxxPjhc/R0673n6h/Z1o8kW8aRAKgaDWdA+5ihgfplb/JstqPBJTSNx5YDDJGp1o
         TXNg==
X-Gm-Message-State: AOAM533lzZz1B0AenWlQYc7E/VSdzs0Ame9jYcMQA/se3RX4m0NX27wH
        Fj4rJRtHjLUFpOBVNKyHoFrdS6a8ExGB64wXHh6ioA==
X-Google-Smtp-Source: ABdhPJx5OR2uQx762PlhO9GISWKgmk9r5adzY/TBnwRBxompVlbmsXEaVkIVD5Jof3LIYLoh6MZ1+WHFU0pzsbOmBcU=
X-Received: by 2002:a9d:1c8f:: with SMTP id l15mr435591ota.241.1600881068463;
 Wed, 23 Sep 2020 10:11:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200923165048.20486-1-sean.j.christopherson@intel.com> <20200923165048.20486-4-sean.j.christopherson@intel.com>
In-Reply-To: <20200923165048.20486-4-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 23 Sep 2020 10:10:57 -0700
Message-ID: <CALMp9eR78C_3eYshQmHLJ8_RZuaP0MXCkYCNdVbxNfSW=ZN08g@mail.gmail.com>
Subject: Re: [PATCH 3/4] KVM: VMX: Rename RDTSCP secondary exec control name
 to insert "ENABLE"
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 23, 2020 at 9:51 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Rename SECONDARY_EXEC_RDTSCP to SECONDARY_EXEC_ENABLE_RDTSCP in
> preparation for consolidating the logic for adjusting secondary exec
> controls based on the guest CPUID model.
>
> No functional change intended.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
