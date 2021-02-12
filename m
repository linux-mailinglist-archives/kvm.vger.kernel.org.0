Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FDDA3197AE
	for <lists+kvm@lfdr.de>; Fri, 12 Feb 2021 02:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229829AbhBLBDP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Feb 2021 20:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhBLBDN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Feb 2021 20:03:13 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5CC3C061786
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:02:33 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id i20so7019100otl.7
        for <kvm@vger.kernel.org>; Thu, 11 Feb 2021 17:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G0c1aSIeooVn4US+T6upq5lsDdJzeDCNMF30EK7w2HE=;
        b=S1InspJro/5H+/PPv2oAx/fl5V6hyGWL2V07Fg3jY4OGhk7QkxsIb/sueJeRJV02HL
         vylAZdhY8uYBMpNfhqwnNreL+ozzlyjbiQMJWd4jGTb1kEpDzhINj1U+tZPDVsKqVQ5Q
         WH3ZM3gldRXDXrzlAyyhdu57JAketnJNAdAr3uMyVN8UkuJp0wmn+4NBd6sydZFeOdWg
         0KoknN/LH5ri3CTAElpVGI69ZBbINnYQ87g+CBt9UmFg7VPk+bE+a6KUrmA4rBWWDoPe
         t1JRPOJ0qO42TURynD57svVquAdzTlZ0lyrlpb7aTBUgHu/cbDF4GLgH9xh6JmBfEebV
         DNgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G0c1aSIeooVn4US+T6upq5lsDdJzeDCNMF30EK7w2HE=;
        b=pUC+efNLNDM/+EAUfoAZq9W1U7fDlmv0uWTmeZcLNTp3OfddD6Im5VEnyV9FZJpVB3
         gsIT4jmR+RGCGG6e1y+dXSvjeqIMCJj6kDwqpgBFyJyG1OCCFCWMm727Q8eMOYH6+f3B
         mHP1+/wmB+34GTBu9/DAXkKB51hsqwIbaCPKYTmZl3Z7ECv6myyq+Ln58SlKmYIdGjBA
         GKW4zbTBvctq5T2Qg+V78IrTFz3NHQJ1x1d4f2u0UlHlTN3WiU+9E3Zf41u74VniBhjp
         4n3BaVDqYH+20ksu+py+1gPzfqouo7w1JsOqaHdIA6uXqFrO4BuVUSN0QIBROG31/p5Z
         WviQ==
X-Gm-Message-State: AOAM531w4Fjp4zFUJSnWoVIQyx8cCp9/87HH2A4pC2/31NsJ6Q3OeJqb
        XYV+9v1hOO7sh3TpYmCYE/kVChyv9z7TvEI+ETOygQ==
X-Google-Smtp-Source: ABdhPJz9r6ERkoLQdfI+Dwjfs+b2Nx+GXUAiPbP59fdVrcF4sukekzYTaNysdabBFweaMURitABWaV8HPVOUGwzLdmQ=
X-Received: by 2002:a05:6830:543:: with SMTP id l3mr452534otb.241.1613091752913;
 Thu, 11 Feb 2021 17:02:32 -0800 (PST)
MIME-Version: 1.0
References: <20210212003411.1102677-1-seanjc@google.com> <20210212003411.1102677-3-seanjc@google.com>
In-Reply-To: <20210212003411.1102677-3-seanjc@google.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 11 Feb 2021 17:02:21 -0800
Message-ID: <CALMp9eR2fun289DuqSC87hkTyzT3KpvDwojhRis8KqLJS5_qaw@mail.gmail.com>
Subject: Re: [PATCH 2/3] KVM: x86: Advertise INVPCID by default
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Babu Moger <babu.moger@amd.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Feb 11, 2021 at 4:34 PM Sean Christopherson <seanjc@google.com> wrote:
>
> Advertise INVPCID by default (if supported by the host kernel) instead
> of having both SVM and VMX opt in.  INVPCID was opt in when it was a
> VMX only feature so that KVM wouldn't prematurely advertise support
> if/when it showed up in the kernel on AMD hardware.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
