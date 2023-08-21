Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEAA782DF6
	for <lists+kvm@lfdr.de>; Mon, 21 Aug 2023 18:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236192AbjHUQMQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 21 Aug 2023 12:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235599AbjHUQMQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 21 Aug 2023 12:12:16 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18913119
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 09:11:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-56385c43eaeso3738786a12.1
        for <kvm@vger.kernel.org>; Mon, 21 Aug 2023 09:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692634309; x=1693239109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=u3QjzztrdUek9NmbsnBxXwIbW573YOZ8AspNggbaDLI=;
        b=orQ0mERyXnuswm1Zmd5V0G2Yd7o2mRzbpRQ7ehInterfzMqEr/DJqjkfLX2fLO8nb1
         P4+xMkEb20m4pfjtjTdl5wdE4FS9QBsEODvaFJtNedeTxKJXtW80WVogUppoc8CR6PQW
         ct5vvuGn+2UjNqdutlSSVWqL5+0wcs/RKZWVH6s2pJ0PC+pCxv7SOGmFNfNNnhuC5+e+
         8W9b8zzdeqle2AdclPRpkGE7V234Q3wB/BbTtvmm2oNECNKY8GkQEjpxWXuZblQ071aI
         1Y/WiFg0fwvKhPhN6kl4rXSH/ZydK0sKD/yajDyMXvjkrDFwpoSk4TFwDnMI447FuN2s
         LXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692634309; x=1693239109;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u3QjzztrdUek9NmbsnBxXwIbW573YOZ8AspNggbaDLI=;
        b=CCvi2ao2k1/6YzT8xRHoMwTPly7gl9cQKZ2KsoM5D1/Gd4MmT3L7wvNCe2WfXTowqG
         CMDky+uwcMsNJFIHFi9TrFRS34O0PRrTTbwtJaSWUwK71LHwW3/Crip/pW6kCfZANfcC
         BG1DY15RCPACk5E+DWor/SfVQg3h79SsA83ObQqH5PF2qaJKBOoMQJBLboehWSltkAfy
         Tvz+UGqaOfiwF8mmCvQAfzZOwZsKSsUNaVhJyvPScNMRyaAg9ngkD1AoqBlIrw3Lvr4o
         /VXaf+qsqJMjvaXhziz+zjIIe7eDtlRhKUcJQr3aaPDZi9hXUp5paXkoGYiEkB3rvDBY
         6mlQ==
X-Gm-Message-State: AOJu0YytfDqs/aWzjlyeauLZnXZV67lRrMk0w0Kqezbr6vMkiOGUp3fK
        f0Fl8SOY3eTaebYBasBA25cNPels5Ck=
X-Google-Smtp-Source: AGHT+IHzfmmumYzE550NGIbVGdL815/OeQTYhHvf+Kl0A5LkJNaTRpp1roY3W2fsxg8AP46Z9G3DSRXLuGg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:754f:0:b0:564:6e43:a00d with SMTP id
 f15-20020a63754f000000b005646e43a00dmr885355pgn.3.1692634308794; Mon, 21 Aug
 2023 09:11:48 -0700 (PDT)
Date:   Mon, 21 Aug 2023 09:11:46 -0700
In-Reply-To: <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
Mime-Version: 1.0
References: <1692588392-58155-1-git-send-email-hao.xiang@linux.alibaba.com>
 <ZOMWM+YmScUG3U5W@chao-email> <6d10dcf7-7912-25a2-8d8e-ef7d71a4ce83@linux.alibaba.com>
 <ZOM/8IVsRf3esyQ1@chao-email> <33f0e9bb-da79-6f32-f1c3-816eb37daea6@linux.alibaba.com>
Message-ID: <ZOOMwvPd/Cz/cEmv@google.com>
Subject: Re: [PATCH] kvm: x86: emulate MSR_PLATFORM_INFO msr bits
From:   Sean Christopherson <seanjc@google.com>
To:     Hao Xiang <hao.xiang@linux.alibaba.com>
Cc:     Chao Gao <chao.gao@intel.com>, kvm@vger.kernel.org,
        shannon.zhao@linux.alibaba.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, Aaron Lewis <aaronlewis@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+Aaron

When resending a patch, e.g. to change To: or Cc:, tag it RESEND.  I got three
copies of this...

On Mon, Aug 21, 2023, Hao Xiang wrote:
> 
> 
> On 2023/8/21 18:44, Chao Gao wrote:
> > On Mon, Aug 21, 2023 at 05:11:16PM +0800, Hao Xiang wrote:
> > > For reason that,
> > > 
> > > The turbo frequency info depends on specific machine type. And the msr value
> > > of MSR_PLATFORM_INFO may be diferent on diffrent generation machine.
> > > 
> > > Get following msr bits (needed by turbostat on intel platform) by rdmsr
> > > MSR_PLATFORM_INFO directly in KVM is more reasonable. And set these msr bits
> > > as vcpu->arch.msr_platform_info default value.
> > > -bit 15:8, Maximum Non-Turbo Ratio (MAX_NON_TURBO_LIM_RATIO)
> > > -bit 47:40, Maximum Efficiency Ratio (MAX_EFFICIENCY_RATIO)
> > 
> > I don't get why QEMU cannot do this with the existing interface, e.g.,
> > KVM_SET_MSRS.
> > 
> > will the MSR value be migrated during VM migration?
> > 
> > looks we are in a dilemma. on one side, if the value is migrated, the value can
> > become inconsisntent with hardware value. On the other side, changing the ratio
> > bits at runtime isn't the architectural behavior.
> > 
> > And the MSR is per-socket. In theory, a system can have two sockets with
> > different values of the MSR. what if a vCPU is created on a socket and then
> > later runs on the other socket?
> > 
> 
> Set these msr bits (needed by turbostat on intel platform) in KVM by
> default.
> Of cource, QEMU can also set MSR value by need. It does not conflict.

It doesn't conflict per se, but it's still problematic.  By stuffing a default
value, KVM _forces_ userspace to override the MSR to align with the topology and
CPUID defined by userspace.  And if userspace uses KVM's "default" CPUID, or lack
thereof, using the underlying values from hardware are all but guaranteed to be
wrong.

The existing code that sets MSR_PLATFORM_INFO_CPUID_FAULT really should not exist,
i.e. KVM shouldn't shouldn't assume userspace wants to expose CPUID faulting to
the guest.  That particular one probably isn't worth trying to retroactively fix.

Ditto for setting MSR_IA32_ARCH_CAPABILITIES; KVM is overstepping, but doing so
likely doesn't cause problems.

MSR_IA32_PERF_CAPABILITIES is a different story.  Setting a non-zero default value
is blatantly wrong, as KVM will advertise vPMU features even if userspace doesn't
advertise.  Aaron is planning on sending a patch for this one (I'm hoping we can
get away with retroactively dropping the code without having to add a quirk).

*If* we need KVM to expose the ratios to userspace, then the correct way to do so
is handle turbo and efficiency ratio information is to by implementing support in
kvm_get_msr_feature(), i.e. KVM_GET_MSRS on /dev/kvm.  Emphasis on "if", because
I would prefer to do nothing in KVM if that information is already surfaced to
userspace through other mechanisms in the kernel.
