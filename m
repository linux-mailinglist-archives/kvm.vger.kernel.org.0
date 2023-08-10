Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528337781E2
	for <lists+kvm@lfdr.de>; Thu, 10 Aug 2023 21:55:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbjHJTze (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 10 Aug 2023 15:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229890AbjHJTzd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 10 Aug 2023 15:55:33 -0400
Received: from mail-vk1-xa31.google.com (mail-vk1-xa31.google.com [IPv6:2607:f8b0:4864:20::a31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002AC2720
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:55:28 -0700 (PDT)
Received: by mail-vk1-xa31.google.com with SMTP id 71dfb90a1353d-4872c3dff53so371384e0c.1
        for <kvm@vger.kernel.org>; Thu, 10 Aug 2023 12:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1691697328; x=1692302128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=IeUEtLNCBueCk26TVmOxk+FIioqZ1Dj8pH3cliM6DxE=;
        b=epXnByH/8ejipWZo8Gb7nTwQIot/GhIq6Zi2XbtAvEHRT6rzd+Q4jHSQQlTWXHb60q
         gINIrabf/GTYSoBPy7c8i78Gm4BQXVkL/r+FwVxDoiwJVWGMhae1csh/tMVn/FLI8t3E
         pqf3PmRBAKug7p5h4e8EvQr3Fvg1Pi53FaCseprgn9yGsuZ1cb19UZr9qnXVPjxalbhM
         YylmeAyUGBv4v/fog83TCEF35F3sWOvujH7w5YJaHv2Rn933ExBzzOl/vytWguFn0x1D
         abL6pmAHQGmUyN774L9fxm5hEdGGbVC/XHiOsYPALFJl5524UTxSnrKU8nDAz9/5ddGb
         MkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691697328; x=1692302128;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IeUEtLNCBueCk26TVmOxk+FIioqZ1Dj8pH3cliM6DxE=;
        b=HZNuFu81OjWA6Vg7rilDFTgRFOqnIWdDgiw+xu6/KT1Pi8crO5XZKMMndAP3x5+H+j
         6ep87dguRIyG+jpojX9wt6yOjQIhMLbCD9PzeojYNrmPKIbcxlsEemo2ggR8p52xHo/O
         JRVx1870chfR3ymc+5r0K5ZsYDvi1h/fsKTSpLky+PyAWpMl5eiILOHviHoQs2GYlm9f
         9BnIfx7ausj+8StqQ1ixbiS0t2xBhdCyPwRpLWvigCmDJ+utV6GV6iFHqZwiJSyNkLi/
         j7OdhuXyI5EPAGQ+PGHdIgeZoBar3xAJoT7nzXLL8t7R8YPt+pFMYGLLzb8XPPWA9rCl
         P/7Q==
X-Gm-Message-State: AOJu0YzkPaNspQOhgfFEAxW3vaMaBBIQacE/fxfLISz3jhX7X828epj9
        5iIFrQfT69mmxmEg0Twv8l6YwuiL1wXRyTi5Q7tw8w==
X-Google-Smtp-Source: AGHT+IEWUaoxig8eLTa1Ao/y0Xm6kZQA+s+ujJtuQUpZdS0k/HgqODK8DhNBiVCDevZu+xAsNk7PNr0fqO0zVQv77iY=
X-Received: by 2002:a1f:6011:0:b0:45e:892b:d436 with SMTP id
 u17-20020a1f6011000000b0045e892bd436mr2462082vkb.12.1691697328020; Thu, 10
 Aug 2023 12:55:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230602161921.208564-1-amoorthy@google.com> <20230602161921.208564-2-amoorthy@google.com>
 <ZInRNigDyzeuf79e@google.com> <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
In-Reply-To: <CAF7b7moOw5irHbZmjj=40H3wJ0uWK5qRhQXpxAk3k4MBg3cH3Q@mail.gmail.com>
From:   Anish Moorthy <amoorthy@google.com>
Date:   Thu, 10 Aug 2023 12:54:51 -0700
Message-ID: <CAF7b7mqczaqwFhFaoicOtWHGEf50f-14cuCXSPj36eZsuCoGUg@mail.gmail.com>
Subject: Re: [PATCH v4 01/16] KVM: Allow hva_pfn_fast() to resolve read-only faults.
To:     Sean Christopherson <seanjc@google.com>
Cc:     oliver.upton@linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev, pbonzini@redhat.com, maz@kernel.org,
        robert.hoo.linux@gmail.com, jthoughton@google.com,
        bgardon@google.com, dmatlack@google.com, ricarkol@google.com,
        axelrasmussen@google.com, peterx@redhat.com, nadav.amit@gmail.com,
        isaku.yamahata@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I figured I'd start double checking my documentation changes before
sending out the next version, since those have been a persistent
issue. So, here's what I've currently got for the commit message here

> hva_to_pfn_fast() currently just fails for read faults where
> establishing writable mappings is forbidden, which is unnecessary.
> Instead, try getting the page without passing FOLL_WRITE. This allows
> the aforementioned faults to (potentially) be resolved without falling
> back to slow GUP.
