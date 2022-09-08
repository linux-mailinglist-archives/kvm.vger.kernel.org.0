Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C2D5B2996
	for <lists+kvm@lfdr.de>; Fri,  9 Sep 2022 00:51:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbiIHWvS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 18:51:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHWvR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 18:51:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE2BEC74A;
        Thu,  8 Sep 2022 15:51:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p1-20020a17090a2d8100b0020040a3f75eso3953818pjd.4;
        Thu, 08 Sep 2022 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=CnESWA6fsAdGXDSQptdGme5NPrDdOdeMs87qWYCmLhE=;
        b=c9GvSTrTiZqRy8QQYuYf2XwWsx8hBewT8BH2kerCOXnnzzQK/GAz90GJ4dDX/z7TG2
         dyMb/H3mthqDGnZMfgHoKeYJ36Ii1YmOWlZdB8Tpzn8IcvFlukc6MDccBaTI8Lb9IY6O
         E4Uf6SpmjklH95+vfws3GIH9i5zOhOUCeYpz3eBlBFKpu/T0Yt/slSgchVyR2Kmzd3Dj
         /7qrz+CCMJr9EIss4JNuWqyVbt4iNyA4PU4BtlerK1y3c6/mibOd2vUWDlXgwrhSBEYF
         bRE5qfFUBEEO5jkxQEouMHtHdPaYlFdvCMUZhpraRjGVEuVoJK1ma6LKwmlRLN3YiXNL
         Tgpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=CnESWA6fsAdGXDSQptdGme5NPrDdOdeMs87qWYCmLhE=;
        b=HpdhZ8H225YgryuJXp549UdVgdEo/kLyw09t8bdn/12t+R978xi7c8VptuJ7KYkxhO
         ykSa/tM87tcHn2QLqHuv6KVsPpoY9mRxeoElQ8nqDeQnjez7T9whRfoCGi5Jmp8kkx+B
         AsqDsfcWdJQ8+jDE5u4b7azFtmToEArTfkQDmEylS1s7T0JF7GiGlK7k3beswzbEUGNw
         i5MAALiIAy/TbQEc7hirSSrzc0EFFgpkbYqGrC8+OwYuSp//vC+TUtuhLJTEOMCtZtfn
         AlKg53k+xE2mpD/7Gsptypg4JhvIfu+2mGS8P+ivCniGXSjBjvYCd9XPzelZUGvK5WME
         x+VQ==
X-Gm-Message-State: ACgBeo0ozE7hJPu64Ir0jmHFvvbhCVT+JA3MLTFZHZ6m/OiBYeB3PwbQ
        T70PcI+txAjN8SmV8jp14pw=
X-Google-Smtp-Source: AA6agR5jDukAbN15luREi1qriKrYL+B6s6eprjSfERI5Y7vky3dv4/ZMnoDUs2wDf9SK4E78ZFkvLA==
X-Received: by 2002:a17:902:e94c:b0:171:3d5d:2d00 with SMTP id b12-20020a170902e94c00b001713d5d2d00mr10750372pll.2.1662677476138;
        Thu, 08 Sep 2022 15:51:16 -0700 (PDT)
Received: from localhost ([192.55.55.56])
        by smtp.gmail.com with ESMTPSA id x186-20020a6286c3000000b00540dd926464sm149546pfd.31.2022.09.08.15.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 15:51:15 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:51:13 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        isaku.yamahata@gmail.com, Kai Huang <kai.huang@intel.com>,
        Chao Gao <chao.gao@intel.com>,
        Atish Patra <atishp@atishpatra.org>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Qi Liu <liuqi115@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Huang Ying <ying.huang@intel.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 16/22] KVM: kvm_arch.c: Remove a global variable,
 hardware_enable_failed
Message-ID: <20220908225113.GA680494@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <91715ddc16f001bf2b76f68b57ebd59092b40591.1662084396.git.isaku.yamahata@intel.com>
 <20220907055657.y7dcseig2qvjue6t@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220907055657.y7dcseig2qvjue6t@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 07, 2022 at 01:56:57PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> > +static void hardware_enable(void *arg)
> > +{
> > +	atomic_t *failed = arg;
> > +
> > +	if (__hardware_enable((void *)__func__))
> > +		atomic_inc(failed);
> >  }
> 
> A side effect: The actual caller_name information introduced in Patch
> 3 for hardware_enable() is lost. I tend to keep the information, but
> depends on you and other guys. :-)

That's true.  But only kvm_arch_add_vm() calls hardware_enable() and other call
sites are converted to call __hardware_enable().  There is no confusion with
other callers with this patch series.  So I decided not to bother to pass
function name in addition to a failed counter.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
