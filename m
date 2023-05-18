Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9E2E708772
	for <lists+kvm@lfdr.de>; Thu, 18 May 2023 20:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbjERSE4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 18 May 2023 14:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjERSEu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 18 May 2023 14:04:50 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D22E710E
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 11:04:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba8338f20bdso2794194276.0
        for <kvm@vger.kernel.org>; Thu, 18 May 2023 11:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684433088; x=1687025088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vCrVtwdIraNV2irdPKpgDX1UCTkhSG6uoeDckqbr3Es=;
        b=gQ9Z3F2vw3+VareHpKfWGGRTctpzyfv4csZGMg2YaLnhnyXjwobQQGO/wA6h0O+lJ3
         9kRuqIngT8mGqWAbR+pbqmRCfc5Jn53wOJ8dC3SAyCq8ku2lJdrNYJDeS8QtzHJ11P3Z
         E2zgzhaLMfDysfnU9WzOecKRSRWAyK4ygjJIW9rT5PCi+ujIXjfWUjOifb86jt0FfJmB
         GEkCOzRHGp2BucWTHjYw1OeO0PpAGtx1WzumH46CcmmxMrIiXFUzYpmzuiK4RX3JyUhT
         x3dng1sy9tSLjWIox+YKLGWhx3LBS+vUH5O4fhooCf6bPzJXXs7MqY8SDb0+JZ8KHABy
         HwWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684433088; x=1687025088;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCrVtwdIraNV2irdPKpgDX1UCTkhSG6uoeDckqbr3Es=;
        b=GpQwr5F57HLvPEtfxTSFlja/sp+TS4lyTxzC7o3ddgIkUDHXFD+hVwYmJX/ZhNQrJ1
         4hhLqL2lRslFnHq4R101bJ1ZX4IzLN0niQuU80MGmbIRid+LG0N9VyfRcbL7cjHSujp7
         9hAsSNdnnjb3fvhaa1ORfPgZnorBsir0p0wuRFuSAhKRbXwM2pvB9OyEX1/P0hYMNcpP
         fzfT66YKL+9vG0d0Cvcc0b4toXLc/vwpd6lI02KsBtOP171lweZyeEVJTA+8iep9qwGo
         M864wY+p6lcRgbkjTN6yxU0pQ55iSHD+mFz1Y8nSKo0imQwQNO1GnWa2FQ0qosF+IoNL
         Gj5Q==
X-Gm-Message-State: AC+VfDwhiiPQlIxZAC8K6PFf4e7tgA7j1kxK0TLcCsY322kzfmTs4KJP
        Ekmn4MMl1kkHdBiBkCDHKwQsy+m/pT0=
X-Google-Smtp-Source: ACHHUZ6WUkWetnPqPXPZQxsXjjLbLmLdZFTJ9NTfgI7Sfh4L6noylG2KxLFdoGMzzXRn4d8670caCGGziEM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:2e0b:0:b0:ba8:93c3:331a with SMTP id
 u11-20020a252e0b000000b00ba893c3331amr1627455ybu.5.1684433088097; Thu, 18 May
 2023 11:04:48 -0700 (PDT)
Date:   Thu, 18 May 2023 11:04:46 -0700
In-Reply-To: <ZGXqo+tG35S2c+QQ@yzhao56-desk.sh.intel.com>
Mime-Version: 1.0
References: <20230513003600.818142-1-seanjc@google.com> <20230513003600.818142-4-seanjc@google.com>
 <ZGNO5gYKOhhnslsp@yzhao56-desk.sh.intel.com> <ZGTpsvZed+r3Low1@google.com> <ZGXqo+tG35S2c+QQ@yzhao56-desk.sh.intel.com>
Message-ID: <ZGZovmcrdh8NcWqb@google.com>
Subject: Re: [PATCH v3 03/28] drm/i915/gvt: Verify hugepages are contiguous in
 physical address space
From:   Sean Christopherson <seanjc@google.com>
To:     Yan Zhao <yan.y.zhao@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi Wang <zhi.a.wang@intel.com>, kvm@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ben Gardon <bgardon@google.com>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, May 18, 2023, Yan Zhao wrote:
> On Wed, May 17, 2023 at 07:50:26AM -0700, Sean Christopherson wrote:
> > On Tue, May 16, 2023, Yan Zhao wrote:
> > > hi Sean
> > > 
> > > Do you think it's necessary to double check that struct page pointers
> > > are also contiguous?
> > 
> > No, the virtual address space should be irrelevant.  The only way it would be
> > problematic is if something in dma_map_page() expected to be able to access the
> > entire chunk of memory by getting the virtual address of only the first page,
> > but I can't imagine that code is reading or writing memory, let alone doing so
> > across a huge range of memory.
> Yes, I do find arm_iommu version of dma_map_page() access the memory by getting
> virtual address of pages passed in, but it's implemented as page by page, not only
> from the first page.
> 
> dma_map_page
>   dma_map_page_attrs
>     ops->map_page
>       arm_iommu_map_page

Heh, thankfully this is ARM specific, which presumably doesn't collide with KVMGT.

>          __dma_page_cpu_to_dev
>            dma_cache_maint_page
> 
> Just a little worried about the condition of PFNs are contiguous
> while they belong to different backends, e.g. one from system memory and
> one from MMIO.
> But I don't know how to avoid this without complicated checks.
> And this condition might not happen in practice.

IMO, assuming that contiguous pfns are vritually contiguous is wrong, i.e. would
be a bug in the other code.  The above dma_cache_maint_page() get's this right,
and even has a well written comment to boot.
