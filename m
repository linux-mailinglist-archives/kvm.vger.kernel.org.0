Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A495B47CE
	for <lists+kvm@lfdr.de>; Sat, 10 Sep 2022 19:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiIJR7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 13:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229451AbiIJR7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 13:59:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12C554199A;
        Sat, 10 Sep 2022 10:59:22 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id go6so121827pjb.2;
        Sat, 10 Sep 2022 10:59:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9LVUrGmgg5NlXwKIeiUGY0pBFtC3Dd7Xv1rjO/T4Xds=;
        b=nnsbvU4xT1jL/likGEbVZ8DRFDzCbfse76m0FvZSSTskw6aq70/qtBkDwC8poGl/0W
         04kWcA5DnWQN2RC+CqYP9h09n0DCCGElrI/Tp+Sd8sHXPUF50geQOzNHXDVGT41gmLmr
         nQjSP4GQyYQnifQT2HL6seGBx2ab5K36CjBwGh8FHN0/TiPgIN+/Jx8z/RTV5tT1buL0
         5PUXVJ0PRaY+UbR0CVbViITfXmEmn+Hxs1ZoP0biUOyAQrKQ+tWV1XKHeiZtEHL/ia3T
         u7znD9H5y/dcC+bcl26vM8DMUJCWgGGXKsR4Z83e5oF3KjQ8vh9GbVEfsJ40rGFBwoLu
         0Taw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9LVUrGmgg5NlXwKIeiUGY0pBFtC3Dd7Xv1rjO/T4Xds=;
        b=WLKbIOnKRHtAlP4dSYDEFVi/0iz2osVcqbrzRzztV0H5sddMikyLSqkprmKVeZkNmX
         YsRqwkGLZCNJ6dZov0sNpULCFEPIkuXDw+UUHtPqkZESeL7Kxm/KieF+aaKGZTucxlbS
         ndm4+s+JhIuUHN6FVUZYYJRjrPGo6U0l5JNg0kfs2GZ+r5cvafUnNQI72g3tZWQSmbF8
         duxFcrKKpT5t/U5dGOS8g3j7V9BaBu+KLrUKlLzponzAioOLmvVxIRWclu6HADOCI5Ay
         NvNWtMB59F7ssINoAc4Qk+xlQ5W+rh5WT3Fx3WnGONjHyTmvfMohZ2Zuwt1wYdMGtavh
         Z8ZQ==
X-Gm-Message-State: ACgBeo0zQe6c1Ir/bAKkQG9WtjgnIvgRAWteS8f0pWU0uTJHVobKdIBw
        5OBmtKhH0ORW1aTP4Qr7qVs=
X-Google-Smtp-Source: AA6agR6zuXYJLLRcg2B7OauT2NV/oypYC2K4jk3k6YC4e2wK/GYIk6d8jdXjt4kKHTZTfGc3hWMLoQ==
X-Received: by 2002:a17:90a:d343:b0:1fd:b437:7ae9 with SMTP id i3-20020a17090ad34300b001fdb4377ae9mr16285600pjx.73.1662832761350;
        Sat, 10 Sep 2022 10:59:21 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id z12-20020a170903018c00b00176d4b093e1sm2635869plg.16.2022.09.10.10.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 10:59:20 -0700 (PDT)
Date:   Sat, 10 Sep 2022 10:59:19 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Chao Gao <chao.gao@intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Yuan Yao <yuan.yao@linux.intel.com>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>
Subject: Re: [PATCH v4 09/26] KVM: Do processor compatibility check on resume
Message-ID: <20220910175919.GB699006@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <1c302387e21e689f103bf954f355cf49f73d1e82.1662679124.git.isaku.yamahata@intel.com>
 <YxqhtH2nOwfFV2zm@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxqhtH2nOwfFV2zm@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 10:15:16AM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Thu, Sep 08, 2022 at 04:25:25PM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >So far the processor compatibility check is not done on resume. It should
> >be done.  The resume is called for resuming from S3/S4.  CPUs can be
> >replaced or the kernel can resume from S4 on a different machine.  So
> 
> Are they valid cases handled by other kernel components? Trying to
> handle them in KVM only doesn't help as kernel is likely to fail
> somewhere else.

I guess no.  Actually without the compatibility check, kvm_resume() tries to
enable it by calling hardware_enable_nolock().  The real effect on error case of
this patch is to print out (potentially) more helpful message gracefully by
check_processor_compatibility instead of error message of haredware_enable.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
