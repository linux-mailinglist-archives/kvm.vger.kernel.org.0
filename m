Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFFC75835B6
	for <lists+kvm@lfdr.de>; Thu, 28 Jul 2022 01:40:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiG0XkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 19:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbiG0Xj6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 19:39:58 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63FF3AE78;
        Wed, 27 Jul 2022 16:39:57 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c139so487652pfc.2;
        Wed, 27 Jul 2022 16:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=p442nXLXAOZRcv+94Q684jDX8TVbbWTp/gcLJwOXX+A=;
        b=jPBI0Ycntp69I51ne0TN1jsgVup7yxCEsc5QGJLiJRsrtOHyPBVQgsEjEM6eG6084F
         nsURI8JfizNvVXUVj2kYFThtseLegKEJ9dI5T/xnPma+YdwrlfhCx4fhXWBT8dAW8/nn
         7Q0jqblHvkPj9WJx6NHL8rlGxeBgfjgM3eqRF5NT2zF4kzOiMY1uyqj728/Hoiw6WPGD
         PC47gukhNIRXPdmQlAjvw+JaIZZEgdd7SpODeWGNgbbUBUSjSFi7lhp1JKeTkRh/V02K
         r50ncEsIV3KBqMXcxSKKiUpYOmCqgB998c4k1NP5gze6CaUx2MKAuxt700tGxokhI6vq
         md7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=p442nXLXAOZRcv+94Q684jDX8TVbbWTp/gcLJwOXX+A=;
        b=DT7Okq+4V3hsdVbWhfXVbm4FaJD8fsvxWJcCK80IqCo5yFtxDEkzzMWMyciTS0ePGQ
         t1ytIablyX2ZSv9rkGgZjQy2yvBPuVyJit1aPdXxwX5jUGrhmZ5zqk3emO+1iEN9iW2F
         u0KdrytwQCNdG/CNVbgigB9+0ObHTMW9MXzzs1L99jjWbQHr+68OcTItt3k8pgikvsMn
         VcHp2ZqxzshRwoi4MXTlLdIWtCJW1gnc6PUr1iJwJyn3t2ZliTDhLueFo7iJIG7/GdrA
         3XCcTIb64Ldi987cLGQcR84fpG66QQhYHniNMTJsjloguVxYD7D0sQ/Ac822XGRC+hMB
         oxbA==
X-Gm-Message-State: AJIora/h6s5AFc+uc9Wz4QmoSkEsHMSnfeaBfccM59TcrggtA/g/IVzQ
        RNj/76eZ59XrkZ9FTQ3EUc4=
X-Google-Smtp-Source: AGRyM1sVjvFFZjDF/xCwbBFsQzYhoF10W2YAiWw4h2MfxldU/DH7d4JnPU15WFGIyRb3a7iCJ7aYWg==
X-Received: by 2002:a63:112:0:b0:419:e88d:7a2a with SMTP id 18-20020a630112000000b00419e88d7a2amr21227973pgb.410.1658965197220;
        Wed, 27 Jul 2022 16:39:57 -0700 (PDT)
Received: from localhost ([192.55.54.49])
        by smtp.gmail.com with ESMTPSA id p7-20020a170902ebc700b0016d1f6d1b99sm14206091plg.49.2022.07.27.16.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 16:39:56 -0700 (PDT)
Date:   Wed, 27 Jul 2022 16:39:55 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 041/102] KVM: VMX: Introduce test mode related to EPT
 violation VE
Message-ID: <20220727233955.GC3669189@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <cadf3221e3f7b911c810f15cfe300dd5337a966d.1656366338.git.isaku.yamahata@intel.com>
 <52915310c9118a124da2380daf3d753a818de05e.camel@intel.com>
 <20220719144936.GX1379820@ls.amr.corp.intel.com>
 <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <9945dbf586d8738b7cf0af53bfb760da9eb9e882.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jul 20, 2022 at 05:13:08PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Tue, 2022-07-19 at 07:49 -0700, Isaku Yamahata wrote:
> > On Fri, Jul 08, 2022 at 02:23:43PM +1200,
> > Kai Huang <kai.huang@intel.com> wrote:
> > 
> > > On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > > > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > > > 
> > > > To support TDX, KVM is enhanced to operate with #VE.  For TDX, KVM programs
> > > > to inject #VE conditionally and set #VE suppress bit in EPT entry.  For VMX
> > > > case, #VE isn't used.  If #VE happens for VMX, it's a bug.  To be
> > > > defensive (test that VMX case isn't broken), introduce option
> > > > ept_violation_ve_test and when it's set, set error.
> > > 
> > > I don't see why we need this patch.  It may be helpful during your test, but why
> > > do we need this patch for formal submission?
> > > 
> > > And for a normal guest, what prevents one vcpu from sending #VE IPI to another
> > > vcpu?
> > 
> > Paolo suggested it as follows.  Maybe it should be kernel config.
> > (I forgot to add suggested-by. I'll add it)
> > 
> > https://lore.kernel.org/lkml/84d56339-4a8a-6ddb-17cb-12074588ba9c@redhat.com/
> > 
> > > 
> 
> OK.  But can we assume a normal guest won't sending #VE IPI?

Theoretically nothing prevents that.  I wouldn't way "normal".
Anyway this is off by default.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
