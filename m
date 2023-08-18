Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B444A7815AF
	for <lists+kvm@lfdr.de>; Sat, 19 Aug 2023 01:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242145AbjHRXOy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Aug 2023 19:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241927AbjHRXOg (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Aug 2023 19:14:36 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E482430C4
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 16:14:34 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5637a108d02so1784430a12.2
        for <kvm@vger.kernel.org>; Fri, 18 Aug 2023 16:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692400474; x=1693005274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5DZepNUwrlYIieQTJr9Dh/3tOxOseVHo5Xld8dMNuNg=;
        b=lsQ+HVzfe/LvJcjpi5EkUeNksPQ4SKFkDuitTo8QZ8/V1sWcr6kxph8TKOQUDPuQY6
         3R+Pf/jmvF5hwJvwA/qd5EZ3umv7mDUrFv27YvRHTc8kZljL+me7hAdDiSfTlWvFfEj/
         coNhxIPQ3jfxMfHlGddYmQDEEwSQ+Y5RTQnvOpYtmp6kPuX7mXVgS6zWmHmU+sPbmIdm
         3HwG+UlgYVsM7jRmT+4vVPawxf3yitDSjepBo5MpteRZM1D0Vdl8EmV210P/oEzmRyXa
         r4YJEufogWKx1B2Git+TQpUucYnwL9g/7hgB267fQrq1A8h/ysQfdzEjFcPJQrGcpD54
         aN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692400474; x=1693005274;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5DZepNUwrlYIieQTJr9Dh/3tOxOseVHo5Xld8dMNuNg=;
        b=AZLR+tURY7Bv96d4+S2nBMcMqzRTzFwwRjtIF1lsRgDG43R2IwlLsDkiQZaDV7J094
         igbeDhall2FpLpYXIfUoH1udYgfI39S23yECJkn9tJdxRLtPWz6nTqUtxTJziiw0Wr3b
         omogsPWDInHZfrriMMkqtNU2vC6mc5N4dUT/CT3QJRZRfNv1GR49FwIHpAlQYZUrkdir
         ZdJWv2rzzefLJzNJ5FyKYO5i4cfv/1QG3Odnu3yIxlqHRoImZdKepek9QyN/nOEVCSd8
         MbNmYa5nS8EYkRON8m4ENq2HypldBTRQ73L+03wSS64bJ2EwYjhUe0p6+vugituvN6Cr
         CgCg==
X-Gm-Message-State: AOJu0YzK54QNd6pe/LK6syUJXOB+1a1TB+wZvysXuQ9xY+f07yJVGqJE
        Ifc3IrkZPnQESlyeKzZFUpryexThMvo=
X-Google-Smtp-Source: AGHT+IF9HyPZ8NYi1dOCnWJqmB9Xg8StOO2+i4hjQBZ6kPAEn5MgrO+XU77nUxSPGBzB9RxPZ8c5rXOzSME=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a63:3ecd:0:b0:565:56be:4dee with SMTP id
 l196-20020a633ecd000000b0056556be4deemr124213pga.8.1692400474224; Fri, 18 Aug
 2023 16:14:34 -0700 (PDT)
Date:   Fri, 18 Aug 2023 16:14:18 -0700
In-Reply-To: <cover.1692119201.git.isaku.yamahata@intel.com>
Mime-Version: 1.0
References: <cover.1692119201.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
Message-ID: <169239820500.1761806.6161030396328593760.b4-ty@google.com>
Subject: Re: [PATCH 0/8] KVM: gmem: Adding hooks for SEV and TDX
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@intel.com
Cc:     isaku.yamahata@gmail.com, Michael Roth <michael.roth@amd.com>,
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
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 15 Aug 2023 10:18:47 -0700, isaku.yamahata@intel.com wrote:
> From: Isaku Yamahata <isaku.yamahata@intel.com>
> 
> This patch series for KVM guest memfd is to have common code base for SEV and
> TDX.  Several minor fixes.  Based on this patch series, TDX KVM can defer page
> clearing without mmu lock.
> 
> Isaku Yamahata (6):
>   KVM: gmem: Make kvm_gmem_bind return EBADF on wrong fd
>   KVM: gmem: removed duplicated kvm_gmem_init()
>   KVM: gmem: Fix kvm_gmem_issue_arch_invalidate()
>   KVM: gmem: protect kvm_mmu_invalidate_end()
>   KVM: gmem: Avoid race with kvm_gmem_release and mmu notifier
>   RFC: KVM: gmem: Guarantee the order of destruction
> 
> [...]

Applied patches 1 and 2 to kvm-x86 guest_memfd.  I'll post the alternative
approach for fixing the unlocking bug next week (need to test, and I'm out of
time this week).

Regarding the initialize/invalidate hooks, I resurrected the discussion from
the previous version[*], I'd like to bottom out on a solution in that thread
before applying anything.

[*] https://lore.kernel.org/all/ZN%2FwY53TF2aOZtLu@google.com

[1/8] KVM: gmem: Make kvm_gmem_bind return EBADF on wrong fd
      https://github.com/kvm-x86/linux/commit/07ac04fbefce
[2/8] KVM: gmem: removed duplicated kvm_gmem_init()
      https://github.com/kvm-x86/linux/commit/9ab46d91d5ea

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
