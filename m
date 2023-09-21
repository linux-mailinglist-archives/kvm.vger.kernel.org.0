Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989517AA270
	for <lists+kvm@lfdr.de>; Thu, 21 Sep 2023 23:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232732AbjIUVRf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Sep 2023 17:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232715AbjIUVRR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Sep 2023 17:17:17 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C154A33C
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:40:42 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id 41be03b00d2f7-56f75e70190so1020801a12.3
        for <kvm@vger.kernel.org>; Thu, 21 Sep 2023 13:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695328842; x=1695933642; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=wY7skFGSh9IgJDFkQorAIyBJ+qj/XXwmSoR+xsvLutM=;
        b=UOaM2Rg6qraCS6wd+URfrumxXwnTkARTm/HgBSdVMTeJz6y1q8JILgq0ly6G6PZDNR
         iLNELILd1EYsAMN/XbOiTJtI0OeIGmcsUUZHNf92/1hCBLk1hwxZ1+/AEBAJKBoJGoZl
         wfvohXAhM7hMKimKCXSi4uSk7X5zUe/NcwBl7DLzJ6T6+VOTTysgMZy3urrEdfci8nC6
         z10pWlDEmjX6I3QLmcNmogzzunYoZEqrexF8cQ4BpnP4vyJVPzZ/kKrh1WfMlA/g3r2q
         dQT9Qif5xf6Ep4XNlr0VztqMn6/w6yxrPpxjn4559zievcRmX4mgoncw3WqyxM1RWU/l
         VG+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695328842; x=1695933642;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wY7skFGSh9IgJDFkQorAIyBJ+qj/XXwmSoR+xsvLutM=;
        b=Sd8NCN5HrsJBY1Zu565BfNgtlS95mNIwgzcF3MihrDDKOMXMIrPkpVpT+HlqwD3u51
         TWRw7/znENn5KVIe2WAoRNr2NWyYjup6i8raQh831duf1MKJlgw4c/9uxJ8JjMPEA0Qt
         L2UKeZGkxcbmO27D2qucPEVaT+a6f9LzJ8WlozPx2+IgTrSCNDNSTmzijWVjCH9hBjXt
         in3JHQRdCcXuVwEH38hSRi2ukxNLUI0Qc8hXuexpOUujYbWiNvisLOh7K+xzxgAfC7bc
         Khl+pJOU8IwqML4k3WKCwM/VV90J+yT113+xOf3bnYwx1coKLkyq+i1gSfxq8saywA5M
         5hPw==
X-Gm-Message-State: AOJu0YyUc6sZsNwhHwsEXx+aaiB4hq9bmAsYCg4q4xwl1CEGYTdvefou
        NqW7dKjwBQYC3N3ZGCfx5M6tvdKRauA=
X-Google-Smtp-Source: AGHT+IE2K20JyCSxvBs9FX0l9CJg9tnhr+0tXhOs9dF7vlRV4Ygmc3v4TCO+SwF3JM+aWjkkBb9ehZqxmwE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3307:0:b0:56c:24c2:488d with SMTP id
 z7-20020a633307000000b0056c24c2488dmr80575pgz.4.1695328842280; Thu, 21 Sep
 2023 13:40:42 -0700 (PDT)
Date:   Thu, 21 Sep 2023 13:40:40 -0700
In-Reply-To: <26822c313754e03b2c393e6fdefe495f117bbfff.1695327124.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1695327124.git.isaku.yamahata@intel.com> <26822c313754e03b2c393e6fdefe495f117bbfff.1695327124.git.isaku.yamahata@intel.com>
Message-ID: <ZQyqSI0HOmamJbWn@google.com>
Subject: Re: [RFC PATCH v2 3/6] KVM: selftests: Add tests for punch hole on guest_memfd
From:   Sean Christopherson <seanjc@google.com>
To:     isaku.yamahata@intel.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Zhi Wang <zhi.wang.linux@gmail.com>, chen.bo@intel.com,
        linux-coco@lists.linux.dev,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Ackerley Tng <ackerleytng@google.com>,
        Vishal Annapurve <vannapurve@google.com>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Xu Yilun <yilun.xu@intel.com>,
        Quentin Perret <qperret@google.com>, wei.w.wang@intel.com,
        Fuad Tabba <tabba@google.com>
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

On Thu, Sep 21, 2023, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> Punch hole implies the region is zeroed out. Add tests if the punched
> region has zero.
> Oppertunistically Remove unused member, pattern, in guest_run_test().

Heh, I didn't pretty much all the same stuff, except I opted to have
SET_ATTRIBUTE instead of FALLOCATE_ONLY, e.g. in case we end up with a test that's
wants a thrid flavor (or somehow neither?).

> Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> ---
>  .../kvm/x86_64/private_mem_conversions_test.c | 26 ++++++++++++++-----
>  1 file changed, 20 insertions(+), 6 deletions(-)
> 

...

> @@ -156,6 +163,10 @@ static void guest_run_test(uint64_t base_gpa, bool do_fallocate)
>  
>  		if (size > PAGE_SIZE) {
>  			memset((void *)gpa, p2, PAGE_SIZE);
> +
> +			/* Test if punch hole results in zeroing page. */
> +			guest_punch_hole_private(gpa, PAGE_SIZE);
> +			memcmp_g(gpa, 0, PAGE_SIZE);

I added a dedicated sub-test to provide a bit more variety in the tests.  I highly
doubt my version will ever find a bug that isn't caught by this approach, but if
nothing else, it's nice to have a completely separate sub-test.
