Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A10C7138B7
	for <lists+kvm@lfdr.de>; Sun, 28 May 2023 10:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjE1I0K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 28 May 2023 04:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjE1I0J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 28 May 2023 04:26:09 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71AF3DC;
        Sun, 28 May 2023 01:26:05 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so2040510a12.2;
        Sun, 28 May 2023 01:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685262365; x=1687854365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N6+DTVV6loeaE15ramj1mf1WcHodhXhBfUTYWqPaF2Q=;
        b=Zd+RzCVUYoy0Vci8TjnR01H0gZ3uYqrknhR0CCz+8agwdl3C+LBAfzGgyd7I74IREf
         bWQaq6rKNMdEEJ2VBvtIn37hQ1JEhtfMIluw4PYAsvVcNHY0zXefKL5HZlZsIaTZIbQq
         xt5LLLT8qmwgJG4Ko/tj+nazSpF6KRrzPDoC2Irs9wGApwpbCn35kpbsXhiiaV0kmBgt
         U4soZyeIwwaOWXk+r8ozXs3K0w1V7y8vuqVdgGq4vmg9KoSQ29rTJosLICoIF/APp8vK
         Z+f66Wb9QfTikmWotezjnmhej8aopEyS8evxPmk29Z5gqb2ClVnM0bYM8YNZXDHU3rpN
         xeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685262365; x=1687854365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N6+DTVV6loeaE15ramj1mf1WcHodhXhBfUTYWqPaF2Q=;
        b=TGjhwPhrCYZq8JUS+ILiEc/CbWcSt8Me4ur3PjIBfLg2yu9ndpEYeuKUhYxAu4SVzR
         KMvW/KnJ4hdDU4HkrPKnREtxIXDSRsMSfn38Gyz9gl7Vc+pX5AujNLP976c7VZc9V6/t
         4V7I0j9LD/XJ23sOvxsK4ODKu6FS+AtnuGDmV1igb5sPI5w8aDJK0WffpLN9GvR4y7WB
         bFOywl6A0BY5A/Enbwjmj/gUn8LrfstL9wLhxqkEUFvtFey2BRg1u6t+FJhWe7oDhbzC
         /v8B292VhCmqpFQHiyxAfrmolJI2BydAFvH1Zamhvh9lkH0r+tTIHrd0jEulMRe6n73X
         Kc7w==
X-Gm-Message-State: AC+VfDyL0GOsi9wwkVneT8oj/1qzoIMKe8ebDY3ofsU7WhlzkoOzoS/G
        GzTCesNjuGxQ99eKnMYyEWmo+yAA5Hg=
X-Google-Smtp-Source: ACHHUZ6N9yZRVJve2dZbW8nQuaCnMQla7/zfL7gL5guLkGGbrF0+4aoo/XJnit36m+5PejGI6cvchQ==
X-Received: by 2002:a05:6a20:2591:b0:10b:e88f:5983 with SMTP id k17-20020a056a20259100b0010be88f5983mr5846674pzd.43.1685262364681;
        Sun, 28 May 2023 01:26:04 -0700 (PDT)
Received: from localhost ([192.55.54.50])
        by smtp.gmail.com with ESMTPSA id w13-20020a65534d000000b00476d1385265sm4619232pgr.25.2023.05.28.01.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 May 2023 01:26:04 -0700 (PDT)
Date:   Sun, 28 May 2023 01:26:02 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Zhi Wang <zhi.wang.linux@gmail.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Paolo Bonzini <pbonzini@redhat.com>,
        erdemaktas@google.com, Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>
Subject: Re: [PATCH v13 021/113] KVM: TDX: Make pmu_intel.c ignore guest TD
 case
Message-ID: <20230528082602.GC1234772@ls.amr.corp.intel.com>
References: <cover.1678643051.git.isaku.yamahata@intel.com>
 <017a06174fa054ae264a2caba6f7f55e00f258e8.1678643052.git.isaku.yamahata@intel.com>
 <20230402115019.000046fd@gmail.com>
 <36fb638a-c9ff-0139-3e8e-7e8ff0bbff1f@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <36fb638a-c9ff-0139-3e8e-7e8ff0bbff1f@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Apr 19, 2023 at 04:21:21PM +0800,
Like Xu <like.xu.linux@gmail.com> wrote:

> On 2/4/2023 4:50 pm, Zhi Wang wrote:
> > Hi Like:
> > 
> > Would you mind to take a look on this patch? It would be nice to have
> > a r-b also from you. :)
> > 
> > On Sun, 12 Mar 2023 10:55:45 -0700
> > isaku.yamahata@intel.com wrote:
> > 
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > 
> > > Because TDX KVM doesn't support PMU yet (it's future work of TDX KVM
> > > support as another patch series) and pmu_intel.c touches vmx specific
> 
> It would be nice to have pmu support for tdx-guest from the very beginning.

It's supported in the public github repo.
https://github.com/intel/tdx/tree/kvm-upstream-workaround
As this patch series has 100+ patches, I don't want to bloat this patch more.


> If you guys are more open on the tdx development model, I'd like to help on
> those features.

This mainling list is the place.  


> > > structure in vcpu initialization, as workaround add dummy structure to
> > > struct vcpu_tdx and pmu_intel.c can ignore TDX case.
> 
> If the target is not to provide a workaround, how about other variants:
> 	- struct lbr_desc lbr_desc;
> 	- pebs ds_buffer;
> ?
> 
> We also need tdx selftest to verify the unavailability of these features.
> Also, it would be great to have TDX's "System Profiling Mode" featue back in
> the specification.

I don't think it's productive. Once merging this patch series, we can move on
to TDX PMU support (or whatever still missing feature) as second (or later)
step.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
