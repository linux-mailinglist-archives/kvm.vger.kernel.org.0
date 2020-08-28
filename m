Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F17C625606D
	for <lists+kvm@lfdr.de>; Fri, 28 Aug 2020 20:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728041AbgH1S0M (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Aug 2020 14:26:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728015AbgH1S0L (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Aug 2020 14:26:11 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACE60C061264
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:26:10 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id e6so1485354oii.4
        for <kvm@vger.kernel.org>; Fri, 28 Aug 2020 11:26:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hqUqx1RmvHPBG8Zj+KDot2f98RZr07Relqmo3BGJ1Qo=;
        b=lVMAiYzq9FpvylCJp2L5H2E+rXavRZZEz3i7sxgZrmh6DbIxEUcckSn7Kt9qrMhMOU
         RsUT9QPC0bFl7YKxLE3yyu72ZJUvlrhIFsfLK4xxNSVAu7TuzELfn67Sf/APSLAgzlwV
         W9C+vXHez1FOkimfLB+NFzGMbo8C3Aw2f/+6SyU8gAIX1PfuNDU5OKik47Twn76zv2gi
         02UDN6QJ/QrGKT0LPavo5cY9xMtcIhmn3zPcZeYqs11TwMXrfgEO87y+vVcJSNSJ0UuJ
         Myff+xQr1k7ZoPKZ09EvDq4J1hAtVV9bpSqyPqrTboOBPLkVx/+tG8suYAvuAvx2VNDx
         mpGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hqUqx1RmvHPBG8Zj+KDot2f98RZr07Relqmo3BGJ1Qo=;
        b=lFGVFHf11E6ewiLNXDtYO9IwvVUFtkstS4OHjBL3G3SYWWDZ6sx2mm8bQM2SAYYBsA
         jKmUZHSnwriDK1HofYgCHolAQ8BeaVQAd4aQdixbvCM6EdTjb2z3qlItU2MlJNCcWRT1
         gwgU9+49svsT9C1oxyiv3wSF5W5So5MCj19tTRMgalxeQ/AukYM3T+J+KlqGwAHPxrJ5
         /PT3l1mkJLsHns5HQZXQVFGS7NpVDLXxGDbFjFEPEgfMkMRzp0WHZUSDXibRANAzzUEg
         YSO1B0mvIZegewlnUT5+5WYtdIdcd84yMbMX9MN/is/KhUeiR6QfOU4z8IKZ0kxj8ZQt
         XVkQ==
X-Gm-Message-State: AOAM530nADcc3zxJ0do643Vb940uoVkb3hBPNQtGAAxf2qaKRs+sFXbl
        uja1CySzMOimPceRW/2NI7OJV2LCNKXOxk5VMLGS2A==
X-Google-Smtp-Source: ABdhPJzG1rHK+aUkTRkutV+E8P9Dg9bigNNvk7UB10vRylGo4Be+rslbfxTMDmJYWx7E7cJB+nsgjOiQsGgJObcFCqE=
X-Received: by 2002:aca:4b12:: with SMTP id y18mr230959oia.28.1598639169551;
 Fri, 28 Aug 2020 11:26:09 -0700 (PDT)
MIME-Version: 1.0
References: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
In-Reply-To: <1598581422-76264-1-git-send-email-robert.hu@linux.intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 28 Aug 2020 11:25:58 -0700
Message-ID: <CALMp9eRD+Uyzcitj=7qa41n0VBK6pRLPbtP1wYOXQV5EN_59Pg@mail.gmail.com>
Subject: Re: KVM: x86: emulating RDPID failure shall return #UD rather than #GP
To:     Robert Hoo <robert.hu@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        kvm list <kvm@vger.kernel.org>, Robert Hu <robert.hu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 27, 2020 at 7:23 PM Robert Hoo <robert.hu@linux.intel.com> wrote:
>
> Per Intel's SDM, RDPID takes a #UD if it is unsupported, which is more or
> less what KVM is emulating when MSR_TSC_AUX is not available.  In fact,
> there are no scenarios in which RDPID is supposed to #GP.
>
> Fixes: fb6d4d340e (KVM: x86: emulate RDPID)
> Signed-off-by: Robert Hoo <robert.hu@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
