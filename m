Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F4A5B2587
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 20:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiIHSVZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 14:21:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiIHSVW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 14:21:22 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC487E6B84;
        Thu,  8 Sep 2022 11:21:21 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id b21so5811960plz.7;
        Thu, 08 Sep 2022 11:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=okUBJLXHbCVSBkroQZFDOrOTjmtVmUpB5jI9jfOC3/Y=;
        b=b7ih9pm4fO55T6Bv8NR5HfeUOZi+8KkI9j8EEUapjGNaX0raRmJyv8yKOBaMTJMqX/
         nwLj9YFdh2ZDmJuHmvNjQLNhY8GErTArfX3iPbFO3XPxemxlVZ5SAT20+jZK7q3Ztr9I
         L4s3KPn8KDuq+laGNvPtKEgWKF2yDC105h22TtSqydVjWb0PfDHk6YKOuPznitGdqt9o
         GuN8YH+Nt286VHdbK/QvDWMUWOxrI0MnTRkAAyeM7cpF9W344w3qEH27Uvbb6weJfvUU
         wxWecM81VxPtsETlQEIgUeWfx9Uo77zdiG0R5VX8jGhAu3Ed0s5UlZRE/nB3EjNPojev
         AF8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=okUBJLXHbCVSBkroQZFDOrOTjmtVmUpB5jI9jfOC3/Y=;
        b=WdW8zVSr6zOoqTKehXoUWXVLApeqAo7mpEMfRsMrIPi05Fp28/b/BSfkpyxTDbMNvr
         H95ikigpUumTf554TiRO4gUViISaEj1oVz+ANsV9l9KUf/IB2XoA8si3lmDHTYsx0BGt
         u/7m/+G91SY4F5c1us0C0CLmnLDgWPXwEj8A5Kt2OUXw5uYmOHkqPU30vkBSwc14EMEi
         epJvnOeZ+s6Jc2/wX/3jzeMfvogtpilARwb/tEdRiGlRENHTeXM7oaB9U1g150R8bg5N
         2zCRKfc/DX9NYlwwOdyd990iyXbr4/JHe5R5qNp4ZVKq17F0PY9X1f2s/WR3iBy0I7Q7
         Tb7w==
X-Gm-Message-State: ACgBeo3io0rb8z+cBG6uFZFgArjibPeQIokok9XYpgC0PrVrookla1/C
        Lf3rNsAgGue0tfQyf8xwfuo=
X-Google-Smtp-Source: AA6agR6uzQdJkEBK6v5j0UzVnYVImYScSKk+ctwwjMcR93s7t6qwU1wiZczwMwTttih1BpL0YxIx2w==
X-Received: by 2002:a17:903:124f:b0:171:4c36:a6bf with SMTP id u15-20020a170903124f00b001714c36a6bfmr10144836plh.0.1662661281017;
        Thu, 08 Sep 2022 11:21:21 -0700 (PDT)
Received: from localhost ([192.55.55.51])
        by smtp.gmail.com with ESMTPSA id jc3-20020a17090325c300b00174abcb02d6sm10463866plb.235.2022.09.08.11.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 11:21:20 -0700 (PDT)
Date:   Thu, 8 Sep 2022 11:21:19 -0700
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
Subject: Re: [PATCH v3 09/22] KVM: Do processor compatibility check on resume
Message-ID: <20220908182119.GA470011@ls.amr.corp.intel.com>
References: <cover.1662084396.git.isaku.yamahata@intel.com>
 <b5bf18656469f667d1015cc1d62e5caba2f56e96.1662084396.git.isaku.yamahata@intel.com>
 <20220905084014.uanoazei77i3xjjo@yy-desk-7060>
 <20220905092712.5mque5oajiaj7kuq@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220905092712.5mque5oajiaj7kuq@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Sep 05, 2022 at 05:27:12PM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Sep 05, 2022 at 04:40:14PM +0800, Yuan Yao wrote:
> > On Thu, Sep 01, 2022 at 07:17:44PM -0700, isaku.yamahata@intel.com wrote:
> > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > >
> > > So far the processor compatibility check is not done on resume. It should
> > > be done.
> >
> > The resume happens for resuming from S3/S4, so the compatibility
> > checking is used to detecte CPU replacement, or resume from S4 on an
> > different machine ?
> 
> By did experiments, I found the resume is called once on CPU 0 before
> other CPUs come UP, so yes it's necessary to check it.

I've added the commit message.

    KVM: Do processor compatibility check on resume
    
    So far the processor compatibility check is not done on resume. It should
    be done.  The resume is called for resuming from S3/S4.  CPUs can be
    replaced or the kernel can resume from S4 on a different machine.  So
    compatibility check is desirable.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
