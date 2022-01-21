Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1964967C5
	for <lists+kvm@lfdr.de>; Fri, 21 Jan 2022 23:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232893AbiAUWUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Jan 2022 17:20:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232516AbiAUWUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Jan 2022 17:20:52 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A38C06173B
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:20:50 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso30210351wmj.2
        for <kvm@vger.kernel.org>; Fri, 21 Jan 2022 14:20:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=plAqQ1BRYw9kzUekn9PRJRDnkbfDvH4L1RVPSJPx+uE=;
        b=bJId4QLdFuV1WWYeQqItbZbbg+RXMGeCpwAsAyLRfYfTIQUnufFuLeXbvW5HG6l3Hg
         d0XtoudPytuTT0cORNagk07GcCE1zL7FNAmijewXvJ9mPq2Ju7Y+LbitqusPPX9b5fd1
         jOgZVqIvkXyGuop9hnVou+WBFx92bzObBuJV7Ubp9eDxTjm8lmKsNn0GIV9em028kkeq
         AQLme7j6hBhcZ8Uc8V5Q75O4/IQmVsCJwHQxAuBWKm+FlXW2rw2YgIWxP1/hH5LK5sBF
         2g2rHsBxUt2pvBdOhOulZ/rZbT12+7qZoMA7OaZ0dfw8KUXP/TbRdaPSOjeIq2aGM7Ho
         L74A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=plAqQ1BRYw9kzUekn9PRJRDnkbfDvH4L1RVPSJPx+uE=;
        b=tLVXyijfgvq6SIEJFK9k67cQ/ORH6eOnd1b/3rm2APpJ1X0YTydNsHuHNBp8jNxS4y
         Om/GAPTlrKuarVPhLByn30lHFR1LtGR9Z+Hl0GLnVKcaFJlXN2Kb0QIrQsVeHlQoahKy
         LYOPsD7gowalHzi1F/qc3aEIW818BHstLG5K1dXy2mGHfdr2BlM/VHYv2IoFxIyjFdfi
         bluTv2GraVTXBBVyF+egFH24CoQr/aUKDHd5y5Pd9hDuv/axEl4O9W/dm8T3WONcEcSY
         ticwVBreJL96ao6FP3URlhMdvW/juf1h7khggwIQZZnPnSmrJQ7kw1W0FzlAtFBeYEnB
         IjtA==
X-Gm-Message-State: AOAM531funPJozHs12te4yY5yc+cqE0YcgXKJre1IurdL8p0JczFdJoP
        8xcCXQoo0AG9TrCc6k7+937wJjVoQW0wuw5BUthFYo6fvgE=
X-Google-Smtp-Source: ABdhPJwCmEAuiKe7yoZVHiwx53vZ0QAJEJbzbXMdw+r4Y8CxVfJ8ah4ZgWBWltaTxIpXf3gIoHIcYqHEV2XAF2sOaIY=
X-Received: by 2002:a7b:c148:: with SMTP id z8mr2487650wmi.110.1642803647060;
 Fri, 21 Jan 2022 14:20:47 -0800 (PST)
MIME-Version: 1.0
References: <20220121210702.635477-1-daviddunn@google.com>
In-Reply-To: <20220121210702.635477-1-daviddunn@google.com>
From:   David Dunn <daviddunn@google.com>
Date:   Fri, 21 Jan 2022 14:20:36 -0800
Message-ID: <CABOYuvYB49_PL9FOUXXn9YvhjQMyt1pDHa1zfmxJyRWAMANF9A@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] KVM: x86: Provide per VM capability for disabling
 PMU virtualization
To:     kvm@vger.kernel.org, pbonzini@redhat.com,
        Like Xu <like.xu.linux@gmail.com>,
        Jim Mattson <jmattson@google.com>, cloudliang@tencent.com,
        Sean Christopherson <seanjc@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Please ignore this v3 patchset.  I made an error and did not amend my
commits prior to creating this patch set.  I will send out v4 shortly.
