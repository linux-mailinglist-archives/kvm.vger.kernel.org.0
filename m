Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1273296393
	for <lists+kvm@lfdr.de>; Thu, 22 Oct 2020 19:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898969AbgJVRN6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Oct 2020 13:13:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S369095AbgJVRNw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Oct 2020 13:13:52 -0400
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com [IPv6:2607:f8b0:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDE5CC0613CE
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 10:13:52 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id f97so1330999otb.7
        for <kvm@vger.kernel.org>; Thu, 22 Oct 2020 10:13:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kQQlSF/0lUzBXugc4fEPyjtlzyb7/jQQu7GyIK58eNM=;
        b=D5Hb6sVoyFHbSWGhGKpzNat9YJJsBpV9GEOlfoxFl4d9eZnnYrGZ1lLOLuXiDsBuh1
         d0cHrv1ykacVV2mVWES1MnNFc0LTOveQwXy3BJJ+JdVyy0XwnS35zjDAqjVEFbtRHfMg
         GGvSNBZbrhY2OE1YzQVsUx5NB5UXR5VevcBGBo+O/8uyW8SvFBzU2+SMfSSbaZpkLpir
         9OxFFdIWZU5m86vjW//qS+QC2GACQjySY5OkJJesvuexmypKrPTS24mesvCc/LBPysHJ
         uYT/r6dtAYtVPFO0mpGDe3MVIasJZxXRPh7q73s/ydSermTfaGVefT6OLVRX7njVYDVy
         dPKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kQQlSF/0lUzBXugc4fEPyjtlzyb7/jQQu7GyIK58eNM=;
        b=kIm6e5CvMdbgzFkY3WymvQ5WnYPvpXywnrTsx10fYZFa0dO+z/Gg32MJP0ZVvJjlZ0
         5EZ1/+n1/gPsyBPFnAwmeYkIchhRizmzBxsjLjuPNiNig1FEdvHPSVHy0VZVbxGZf67K
         rHQWYw58eQMIUx5WPNjFS5mneG8nU4RIi5rPuM+u8uapPFBvfNT1g9KiQiyO906qSgnx
         4oVJtB7nv9+a8ulVNLynjoVETk49+InNHi6GFXyTR70r0OiOuzO1AIpsbEdY+b2WTCmU
         hl7s2ZSP9qBfpJ1V5ZisgXGAzDoCAt89lP9Kd1nqfoZhZ+x9dnZtnxyzug3K8+SOiNrX
         wjXg==
X-Gm-Message-State: AOAM5321XayzHkZsfifSWMQATjW2Coa56EMVUG63TAIBTuLmAAzMselL
        KSWNqoG/Ybf5ZcosXdi4qblwnJHhk+F+/0Z1NbgBBA==
X-Google-Smtp-Source: ABdhPJx2w3YUlN/3PB1QFTGlbY/e6pEIoW08rIDoq2LlMVKf4jXtyet0dE+as4/GxxhMd5fC11yDQpdzkMicsNPvLWE=
X-Received: by 2002:a05:6830:10d3:: with SMTP id z19mr2731575oto.295.1603386831866;
 Thu, 22 Oct 2020 10:13:51 -0700 (PDT)
MIME-Version: 1.0
References: <1603330475-7063-1-git-send-email-wanpengli@tencent.com>
 <cfd9d16f-6ddf-60d5-f73d-bb49ccd4055f@redhat.com> <CALMp9eR3Ng-WBrumXaJAecLWZECf-1NfzW+eTA0VxWuAcKAjAA@mail.gmail.com>
 <281bca2d-d534-1032-eed3-7ee7705cb12c@redhat.com>
In-Reply-To: <281bca2d-d534-1032-eed3-7ee7705cb12c@redhat.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 22 Oct 2020 10:13:40 -0700
Message-ID: <CALMp9eQyJXko_CKPgg4xRDCsvOmA8zJvrg_kmU6weu=MwKBv0w@mail.gmail.com>
Subject: Re: [PATCH] KVM: X86: Expose KVM_HINTS_REALTIME in KVM_GET_SUPPORTED_CPUID
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 22, 2020 at 9:37 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 22/10/20 18:35, Jim Mattson wrote:
> > On Thu, Oct 22, 2020 at 6:02 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
> >>
> >> On 22/10/20 03:34, Wanpeng Li wrote:
> >>> From: Wanpeng Li <wanpengli@tencent.com>
> >>>
> >>> Per KVM_GET_SUPPORTED_CPUID ioctl documentation:
> >>>
> >>> This ioctl returns x86 cpuid features which are supported by both the
> >>> hardware and kvm in its default configuration.
> >>>
> >>> A well-behaved userspace should not set the bit if it is not supported.
> >>>
> >>> Suggested-by: Jim Mattson <jmattson@google.com>
> >>> Signed-off-by: Wanpeng Li <wanpengli@tencent.com>
> >>
> >> It's common for userspace to copy all supported CPUID bits to
> >> KVM_SET_CPUID2, I don't think this is the right behavior for
> >> KVM_HINTS_REALTIME.
> >
> > That is not how the API is defined, but I'm sure you know that. :-)
>
> Yes, though in my defense :) KVM_HINTS_REALTIME is not a property of the
> kernel, it's a property of the environment that the guest runs in.  This
> was the original reason to separate it from other feature bits in the
> same leaf.
>
> Paolo
>
We don't actually use KVM_GET_SUPPORTED_CPUID at all today. If it's
commonly being misinterpreted as you say, perhaps we should add a
KVM_GET_TRUE_SUPPORTED_CPUID ioctl. Or, perhaps we can just fix this
in the documentation?
