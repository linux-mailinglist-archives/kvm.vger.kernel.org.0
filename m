Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41D9621BAF1
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 18:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728249AbgGJQbJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 12:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgGJQbH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 12:31:07 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E279FC08C5DC
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:31:07 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id v6so6663575iob.4
        for <kvm@vger.kernel.org>; Fri, 10 Jul 2020 09:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L5x+RXQcTKt3brgLCNXmzu/Q4sL3Ui6tQW0Y7yTVLkY=;
        b=B6/Y2AU3K+d29kPJXoL4LW3xcHmtRXC6hGouqLD94eTzfrcaV3Fglva7FhbL4FBWcn
         7CNit1lq96RQZfb339mk7OObuhLv9SvsOopZ5KKDqxtyUP5OkUl3So/xWJuSYxFPAnD0
         M+cC9gw93b5yvVZkCiPNJBcka2dTkqqMjjpN1B8/fJ/d2uYNUOhQbv2l2wjmIHMZJiV7
         JKgQOz8OPcH4mfjfFUrRPX+wgE/dFIBA7R+ynDnnOb99sDUc/8fY2mu0lZJMQGXNi5SM
         mdf35MSYI92URNmkPnr9bRMUTfCVa5SC6EUlRv+V61BsDiSWajXEiDX+k1gstuu/tsOB
         p2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5x+RXQcTKt3brgLCNXmzu/Q4sL3Ui6tQW0Y7yTVLkY=;
        b=hyp7y4Hf3oMrZ8lnQgRMMhPcT93idw9QJsZWJtZmw23yahIz6EBm4/x8HJG5IQilUf
         z1X+Q6sTiQTtpD4QKQvSrtYOi8iBN0D40gs93wHrhc8UxMwP1XWPh3MennFsv1nq04DP
         HGGe0hF36LWWEW+xtEwjj5Abelyax7Wr+CNzzmxFv4yw9GWk7k8sufeE/FmOxnYekJUT
         KMzb2CQcYVnkOOYwP1kOBfP16aVeGDqd0CPWta7fERKEZnnI0SabH/xF5ggaxCAxeL2M
         2TE/98EAbJ1fTkfpcFESMqYTU31/Tc6tDpUwQ8LZf4H9yUF+4SnrxzykwMMPLmBVPfhC
         gQ2g==
X-Gm-Message-State: AOAM532+PnPImgtXcILy9h7f0MJF6Mc4CthA/xeJNk2IXV23RaHLLO10
        fpkKIpELBhoRxdRBaVPcZKiEG83UgUx1inqDOMDcPQ==
X-Google-Smtp-Source: ABdhPJz4f+wmTdCN8HsvGt2xu/V0GtBoahjoaJjauggHLbwoRMsmtNf5nAOu00p52lQl8ZVL2r2qaIf0UU+lXGLR09U=
X-Received: by 2002:a5e:c311:: with SMTP id a17mr18924402iok.12.1594398666301;
 Fri, 10 Jul 2020 09:31:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200710154811.418214-1-mgamal@redhat.com>
In-Reply-To: <20200710154811.418214-1-mgamal@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 10 Jul 2020 09:30:55 -0700
Message-ID: <CALMp9eRfZ50iyrED0-LU75VWhHu_kVoB2Qw55VzEFzZ=0QCGow@mail.gmail.com>
Subject: Re: [PATCH v3 0/9] KVM: Support guest MAXPHYADDR < host MAXPHYADDR
To:     Mohammed Gamal <mgamal@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 10, 2020 at 8:48 AM Mohammed Gamal <mgamal@redhat.com> wrote:
>
> When EPT is enabled, KVM does not really look at guest physical
> address size. Address bits above maximum physical memory size are reserved.
> Because KVM does not look at these guest physical addresses, it currently
> effectively supports guest physical address sizes equal to the host.
>
> This can be problem when having a mixed setup of machines with 5-level page
> tables and machines with 4-level page tables, as live migration can change
> MAXPHYADDR while the guest runs, which can theoretically introduce bugs.

Huh? Changing MAXPHYADDR while the guest runs should be illegal. Or
have I missed some peculiarity of LA57 that makes MAXPHYADDR a dynamic
CPUID information field?

> In this patch series we add checks on guest physical addresses in EPT
> violation/misconfig and NPF vmexits and if needed inject the proper
> page faults in the guest.
>
> A more subtle issue is when the host MAXPHYADDR is larger than that of the
> guest. Page faults caused by reserved bits on the guest won't cause an EPT
> violation/NPF and hence we also check guest MAXPHYADDR and add PFERR_RSVD_MASK
> error code to the page fault if needed.
