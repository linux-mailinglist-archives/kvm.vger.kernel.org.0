Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1973B1FD286
	for <lists+kvm@lfdr.de>; Wed, 17 Jun 2020 18:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgFQQrQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 17 Jun 2020 12:47:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbgFQQrP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 17 Jun 2020 12:47:15 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E68C061755
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:47:14 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s18so3574121ioe.2
        for <kvm@vger.kernel.org>; Wed, 17 Jun 2020 09:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQoOO+VF4SBHpGOMcAz5jGxlKXeUrUgImS0zglw1/Uo=;
        b=Gzyi9/fcMu3VCfePJqRa51D4oz9qb4xhzSSdu0IECQ6t5vsEXW8/sePtO98+w5zDin
         HO3TsJLee5XV60S/wyy+zT0u/NogW8r1HinR6+wGJ30xpcf3ZAFTOfI3JjRa4BkL1IbJ
         o1PmNqUdp0zHqA1+j7nid9rcmzFBPa4l/D44BFQ71M1zmUpsLssvJ7+6ADIOT2XVevOK
         /qVEiBU1MFbXKlOoswkFkN6uJo8+vDMZc3g1a3gV3NgVRT/2WLaRBKFx5zgrkYvBI8ud
         O61JtuaEeNlQR8ijLGtkOHnYDfPwLhLqZIGagzsC383xHJz/dTeuMditEiHJ7ztMgyop
         K9Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQoOO+VF4SBHpGOMcAz5jGxlKXeUrUgImS0zglw1/Uo=;
        b=HM2/4OxndZQH1EoAje2r6fVnGVDTgjhpKxN39ZipOuHGPPX8HOcL8osg9VM1vHEg3R
         U7sRkomjPMY999Db//9Dy97pB/gKZkqV8yZACdb/aHRzh3TaF92E4yOXLL9sdolG03f/
         tfsuoR4XMkUxQXParqj4BF/UdJ6MJG6TYxwUonC5hmRK0GKr20n7nP8H8ihqYNS7H5CX
         Muv2GnOZKGtDrYwgiZV3f3QgRXIp0Y61Q9AmrVwruh1QeCSfn50V/6Fa3/yjWkR5Ikhi
         7vVh/42/VXtBG9Owzw1vVY5PsGQTbTAeaKiDNyUKpo1nLlY1EBUaYTqAAdBvMlNbrdZg
         RPOg==
X-Gm-Message-State: AOAM532T/nEK0A+Db3v2pkD2p7cOMTGBXSnkgxNha6grxKWWTfJkBU3U
        +qLP+FrbESNtqA1g7skN9VDhMPiX/W/SzFjL25gXPg==
X-Google-Smtp-Source: ABdhPJyspdBz5XZmNNacGUiyqAhl2DY9cyi9vJ5/SPZuoEnOMWtFiNLuNhrkq1K5MVzA228YLegc1IL58aQE/ReQvAI=
X-Received: by 2002:a05:6638:209:: with SMTP id e9mr180304jaq.48.1592412432984;
 Wed, 17 Jun 2020 09:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200616161427.375651-1-vkuznets@redhat.com> <CALMp9eSWXGQkOOzSrALfZDMj5JHSH=CsK1wKfdj2x2jtV4XJsw@mail.gmail.com>
 <87366vhscx.fsf@vitty.brq.redhat.com> <CALMp9eQ1qe4w5FojzgsUHKpD=zXqen_D6bBg4-vfHa03BdomGA@mail.gmail.com>
 <87wo45hqhy.fsf@vitty.brq.redhat.com>
In-Reply-To: <87wo45hqhy.fsf@vitty.brq.redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Wed, 17 Jun 2020 09:47:01 -0700
Message-ID: <CALMp9eQCbKz5aeacvMvBX4kq5Oxy5Tap3dUT4SZ_dnO-zmrPVQ@mail.gmail.com>
Subject: Re: [PATCH] KVM: SVM: drop MSR_IA32_PERF_CAPABILITIES from emulated MSRs
To:     Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Like Xu <like.xu@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 17, 2020 at 4:38 AM Vitaly Kuznetsov <vkuznets@redhat.com> wrote:

> Side note: MSR_IA32_PERF_CAPABILITIES can be returned by both
> KVM_GET_MSR_INDEX_LIST and KVM_GET_MSR_FEATURE_INDEX_LIST as we have it
> both as an emulated MSR filtered by kvm_x86_ops.has_emulated_msr() and
> a feature msr filtered by kvm_x86_ops.get_msr_feature(). But the later
> is a whitelist so MSR_IA32_PERF_CAPABILITIES won't appear on AMD and the
> promise "can be passed to the KVM_GET_MSRS" is kept.

So, how is MSR_IA32_PERF_CAPABILITIES different from, say,
MSR_K7_HWCR, which by its very name doesn't sound like it would be
supported on Intel CPUs? Why not just emulate
MSR_IA32_PERF_CAPABILITIES on AMD, just as we emulate MSR_K7_HWCR on
Intel?

My concern is that we don't seem to have a standard here. Each
individual MSR is handled ad hoc, which adds unnecessary complexity.
