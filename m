Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639305B4B56
	for <lists+kvm@lfdr.de>; Sun, 11 Sep 2022 04:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiIKCpv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 10 Sep 2022 22:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiIKCpt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 10 Sep 2022 22:45:49 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B359233A29;
        Sat, 10 Sep 2022 19:45:47 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id z9-20020a17090a468900b001ffff693b27so5094983pjf.2;
        Sat, 10 Sep 2022 19:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=YW6q0Ug4ODiNiFnU1n7bDTn4AUEnHpnmoBlpOQHBlK4=;
        b=lpXap2QJQyEtvavrHCYA61PbWKVZ7IC/5tX6/2oVZZHZWa6VrqtvLoPwrHXDY3T3y/
         iD7D0qeR1mW3s4wbeARntYA7Wdbi0zhXh2eV4qJyPoI0ifOTADIcxy1iAWECoz8lnspx
         OClbzNUQgQBLOmlhaHlVj7cnPIfeS7ZgEe1ikTwXVVpuW+ZH3jOpAApPzRoSOZR4MN7L
         naSHKlFVRXohHyLkMGdnPY5QZOUaToUNqXKYVNM0UVUW5Mb80RMf0QlAOIAMaEsCy9AY
         MBd2w7wXN6jkUkFR6waSkUgIOxIA4Z0+nTJxT3JdPqsmAbh7+IXeITlIyC3c5dFS8d+C
         yDNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=YW6q0Ug4ODiNiFnU1n7bDTn4AUEnHpnmoBlpOQHBlK4=;
        b=7EHyu8OgwqVNeaDhyLX5SjgmPOp32GvslyPe4p47AijsrWVHN7N5zhEjE+1MWbj1HI
         iaSRYk3+hMOW/JVGzALuzvVk5181TnUKdjym5+G4pDw4H2jaJ1nC8bWXbQr+pfT8kt4c
         KmtOrn4BZoGhHsgRCtMgIDdxnErVfkqZM2n78L89hJnhUbg4oIjyQm86AyVi+nrkTYeJ
         kJxERn7+DSogsU84N7jghtGvhnsj/1uPNVhvmnb62YqsMHCpqO0o99kxqRKZqxCUAQoq
         OXa5pCQWK6MBO0kHDdY7F2Vl2Th1nq0Fgf+1jzzRNTY2+MPwhkC0ipG+d3wnq1ut8bfd
         D4ig==
X-Gm-Message-State: ACgBeo1OH3LgMkhcrjbWFRgTqOHyDuIYPFdW1iuau+M22UxM33uhrxzo
        gqiekViRDBW1xDRn6Z5sKqc=
X-Google-Smtp-Source: AA6agR5/jkTEedt2xew1xi5+unQpqfcFXWt9uqb9DY+HTiCWVSv0f8tVOoLzAgMOhuIC0D+GLiFMIg==
X-Received: by 2002:a17:90a:bd12:b0:200:5112:3167 with SMTP id y18-20020a17090abd1200b0020051123167mr17142319pjr.109.1662864347152;
        Sat, 10 Sep 2022 19:45:47 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id mp17-20020a17090b191100b001f94d25bfabsm2683851pjb.28.2022.09.10.19.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Sep 2022 19:45:46 -0700 (PDT)
Date:   Sat, 10 Sep 2022 19:45:45 -0700
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
Subject: Re: [PATCH v4 12/26] KVM: x86: Move TSC fixup logic to KVM arch
 resume callback
Message-ID: <20220911024545.GE699006@ls.amr.corp.intel.com>
References: <cover.1662679124.git.isaku.yamahata@intel.com>
 <a01d2507055525529b1a9c116aa1eb81f4e20b2a.1662679124.git.isaku.yamahata@intel.com>
 <YxrTsE8iT6mTCZgg@gao-cwp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YxrTsE8iT6mTCZgg@gao-cwp>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 09, 2022 at 01:48:32PM +0800,
Chao Gao <chao.gao@intel.com> wrote:

> On Thu, Sep 08, 2022 at 04:25:28PM -0700, isaku.yamahata@intel.com wrote:
> >From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> >commit 0dd6a6edb012 ("KVM: Dont mark TSC unstable due to S4 suspend") made
> >use of kvm_arch_hardware_enable() callback to detect that TSC goes backward
> >due to S4 suspend.  It has to check it only when resuming from S4. Not
> >every time virtualization hardware ennoblement.  Move the logic to
> >kvm_arch_resume() callback.
> 
> IIUC, kvm_arch_resume() is called on the first CPU waking up from suspension.
> But the detection was done on every CPU. Is it a problem (i.e., we fail to
> detect TSC goes backward on some CPUs)?

The problem is, TSC fixup logic is only needed once on resuming.
The current code calls TSC fixup logic on each cpu onlining.  It's quick
plumbing the logic to each cpu online.  Although it won't harm to call the logic,
it's ugly and this time is good occasion to clean it up.

I will clarify the commit message.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
