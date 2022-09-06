Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63F505AF7F4
	for <lists+kvm@lfdr.de>; Wed,  7 Sep 2022 00:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbiIFW0y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 6 Sep 2022 18:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiIFW0g (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 6 Sep 2022 18:26:36 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB84D1106;
        Tue,  6 Sep 2022 15:26:00 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso16427738pjk.0;
        Tue, 06 Sep 2022 15:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=4L5OM+4nHsHAFuitjpat6Ve05SKglqmd1Yj6EfO0tM0=;
        b=Ie8fDhm02XtEFf+eMaHwY9b/Tc6pi7XmSmNw7XEpM8A4m4Nk1RyjRl5Y5436UU7axE
         fkDMQFN33QwfKXMGkUGQrgb435gqWVCiaf5CAz+mKvLUIxXWuXA+BW2VWBWgo1kNAlTg
         r+eTw+2zOaD82Ri7nqh0xEXGzvyBF25q0AcvUb4S2cu7Ev1Jnie7TJh6X5228aNcLtgo
         luGiPB6/GyfPNy+2ZNRXsa6x5L0HOwJQu9l23I1/XcBoF2CooJpPFfMPE69JZjgsVBDD
         +dIQLxBklIkTKpD75VDqxBaMqmRJDVDFoHF1YcRqdODTX6SdJJgnFaCJYoAXR2F/p1Pp
         dvBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=4L5OM+4nHsHAFuitjpat6Ve05SKglqmd1Yj6EfO0tM0=;
        b=SD3qiAPbZkcn9EbQ4kXtG94BIrhtf/8yfyHaObrPXnkM5IMeGjK43dTbg1sq3hZc7Z
         FLHiDPDYjqxqYrpI+EHVYOaUNPEDASzrEzyuolNEE4QZ2QhvpPMiOsoQhU/8+tHABjWD
         ivOvl//6Lhg6giS1DKxbeEcAFxSORLYOSDNwG7AfVcda403nR5lzh3woErD4/w1mihAD
         jdvLzyqTukY2CDqOPU0waGKDsYXHyc5Tcunjgq6fQdaeABf2LGfrHgl6XQfSpGV4Z9Pk
         kxeNbn0EqpVhTZ+4+Vg7rqZnJ4LbuQ3/WhdPwNzU+TERRqs/vh5bvyePh8P3EF5dJHIs
         Vw2A==
X-Gm-Message-State: ACgBeo28pYngmJ65fFnbRY/HBQJUJ1aoDUVen2rBmcDl64bfFyZfhW6D
        46SQpZ8NZTYsyn+eciLIdj74ImA7Dnk47Q==
X-Google-Smtp-Source: AA6agR6d/uZWXiTHy1kujjJk0MeqsQ2wpg8I3r2Vp4chA/Q4rHd0dg6FNgZnobOCbxAScF4H+rjOaw==
X-Received: by 2002:a17:902:cec1:b0:172:e677:553b with SMTP id d1-20020a170902cec100b00172e677553bmr448297plg.99.1662503159489;
        Tue, 06 Sep 2022 15:25:59 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id p123-20020a625b81000000b0053670204aeasm10741248pfb.161.2022.09.06.15.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 15:25:58 -0700 (PDT)
Date:   Tue, 6 Sep 2022 15:25:57 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will@kernel.org>, isaku.yamahata@gmail.com,
        Kai Huang <kai.huang@intel.com>, Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 00/22] KVM: hardware enable/disable reorganize
Message-ID: <20220906222557.GB443010@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <87tu5lvnk0.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87tu5lvnk0.wl-maz@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 05, 2022 at 04:38:39PM +0100,
Marc Zyngier <maz@kernel.org> wrote:

> On Fri, 02 Sep 2022 03:17:35 +0100,
> isaku.yamahata@intel.com wrote:
> > 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > Changes from v2:
> > - Replace the first patch("KVM: x86: Drop kvm_user_return_msr_cpu_online()")
> >   with Sean's implementation
> > - Included all patches of "Improve KVM's interaction with CPU hotplug" [2]
> >   Until v2, Tried to cherry-pick the least patches of it. It turned out that
> >   all the patches are desirable.
> > 
> > This patch series is to implement the suggestion by Sean Christopherson [1]
> > to reorganize enable/disable cpu virtualization feature by replacing
> > the arch-generic current enable/disable logic with PM related hooks. And
> > convert kvm/x86 to use new hooks.
> 
> This series totally breaks on arm64 when playing with CPU hotplug. It
> very much looks like preemption is now enabled in situations where we
> don't expect it to (see below for the full-blown horror show). And
> given the way it shows up in common code, I strongly suspect this
> affects other architectures too.
> 
> Note that if I only take patch #6 (with the subsequent fix that I
> posted this morning), the system is perfectly happy with CPUs being
> hotplugged on/off ad-nauseam.
> 

Thanks for testing. As the discussion in 10/22, it seems like we need to relax
the condition of WARN_ON or BUG_ON of preemptible(). Let me cook a version
to relax it.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
