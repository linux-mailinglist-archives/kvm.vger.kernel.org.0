Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 931EA21E714
	for <lists+kvm@lfdr.de>; Tue, 14 Jul 2020 06:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725816AbgGNEnk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jul 2020 00:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgGNEnk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jul 2020 00:43:40 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1A56C061755
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:43:39 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id t74so10569960lff.2
        for <kvm@vger.kernel.org>; Mon, 13 Jul 2020 21:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qEP+SeQ8Nan2aFjB5HWY6BOGbALAKhAs4bQzQ/wO6bs=;
        b=klN2+h2h57/N5kUwIxmCpK5L0jVCoVernvR4xYScVgBwMnTB07Dlok2pShnerwZTrX
         8cQzIqiPuv4anEWYHImh0XKkDSD3tzMBpRbKSvHXhK6DxcDPkl8WjZD4tTjiEBHDO1B6
         dBV5q9sRkQ5lcHZxH6o8I3VnTgb/lyUCFLOokBQw95VotXZsIsP95kVMuYWQxaiLkQnL
         RvkWF+ItCLfv+yukQSZNRneHDnJCK/y0P/gl1TiY9/fIaOXN3AW8aNn+fZlUITF5jZEM
         OaU2INFQMAALCc5bFQW7oK0LPnDmFk9ajBszcJgx+H5x2sR5KY30oLM9yIJNxhtF7CtZ
         y0qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qEP+SeQ8Nan2aFjB5HWY6BOGbALAKhAs4bQzQ/wO6bs=;
        b=SDUNYTJIrP1G+64AuLlHArHv6LRMh5c3feg3Ii3qmpGc8HtkFjI85IO2D3OJaDrqP5
         ZLV+FzFMxevxZWBGJHq4bUS8ijnGQO92PFkaasHsoPd22Yfysc1e+NmRWQvIt8CWARUO
         ksC01SbAmcT4hoRtquWtX3SEYEtvg5ZCzm08byEJ6wuk1Z6QZDknL5vcgT6+NhSfe9l8
         bicEAKbGQNfhtD4hAO+gqF5KL1KY4wUay1V68BuNCfIfxfblGJKufn6skX/Q22YmGB7j
         nig7OtcV2ZR1ymj0L6sdk/1t9mD0nsSo9Q25wUcpUJHTt3j48SHvqLVXjZlJIKSM5K+N
         kMzA==
X-Gm-Message-State: AOAM532ZcfIe+NknCMgI3FxnoERp5mQUtfWd6QJf+jXJskBnZHi8oYqQ
        dpVN+pACGRJNcqYitUU3uGGCegEaYNU+QTue5AjR2Q==
X-Google-Smtp-Source: ABdhPJzlCP1H3GjoMk5wm4MBXaitCOGbzsZc6U0zrQI7Lqk7WCNFDdw2YqNWjEjMoTVBtUHtV+l0W2bZ2cMu5DhVy1c=
X-Received: by 2002:a19:e93:: with SMTP id 141mr1205791lfo.107.1594701817783;
 Mon, 13 Jul 2020 21:43:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200714002355.538-1-sean.j.christopherson@intel.com> <20200714002355.538-2-sean.j.christopherson@intel.com>
In-Reply-To: <20200714002355.538-2-sean.j.christopherson@intel.com>
From:   Oliver Upton <oupton@google.com>
Date:   Mon, 13 Jul 2020 21:43:26 -0700
Message-ID: <CAOQ_QshGiwLmm5Sun8TOMJNwx3GFPB=YEMPkzwqczqV4aDYmsg@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH 1/2] nVMX: Restore active host RIP/CR4
 after test_host_addr_size()
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Karl Heubaum <karl.heubaum@oracle.com>,
        Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 13, 2020 at 5:23 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Perform one last VMX transition to actually load the host's RIP and CR4
> at the end of test_host_addr_size().  Simply writing the VMCS doesn't
> restore the values in hardware, e.g. as is, CR4.PCIDE can be left set,
> which causes spectacularly confusing explosions when other misguided
> tests assume setting bit 63 in CR3 will cause a non-canonical #GP.
>
> Fixes: 0786c0316ac05 ("kvm-unit-test: nVMX: Check Host Address Space Size on vmentry of nested guests")
> Cc: Krish Sadhukhan <krish.sadhukhan@oracle.com>
> Cc: Karl Heubaum <karl.heubaum@oracle.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  x86/vmx_tests.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 29f3d0e..cb42a2d 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -7673,6 +7673,11 @@ static void test_host_addr_size(void)
>                 vmcs_write(ENT_CONTROLS, entry_ctrl_saved | ENT_GUEST_64);
>                 vmcs_write(HOST_RIP, rip_saved);
>                 vmcs_write(HOST_CR4, cr4_saved);
> +
> +               /* Restore host's active RIP and CR4 values. */
> +               report_prefix_pushf("restore host state");
> +               test_vmx_vmlaunch(0);
> +               report_prefix_pop();
>         }
>  }
>
> --
> 2.26.0
>
