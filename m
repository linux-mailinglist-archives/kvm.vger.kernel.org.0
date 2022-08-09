Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E0458D719
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 12:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240721AbiHIKFv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 06:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241323AbiHIKFq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 06:05:46 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4F991EAC9
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 03:05:44 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id v3so13822169wrp.0
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 03:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=87GRMo3aWccVg1tJE1Y4QJEISnFKW+1wZmaZv6DvTZ8=;
        b=VWtyCozLDvNEevBaQBTRqLHrR5mHOyIHMWCM/g567zMsPWsC4AaTbSAmzkIwfrnPX9
         gMq8eSlHp7WFTY8kGWoXtFNrCLIRyc6qLNGkXl3AsvtBG5M1YeKLZFNTjfxhLyKDmJdF
         bL0+CsveZAyOOZL6dJubG9/rIGN25QhA2V4oA2R+hHyzk9faAGftJ/vQ6Yc8qwgtiiC8
         afBwqfsldvT/Dio9wt0jsVcVgdJE4aSSCyNhUYtgsRX3bkxJjEHBe7HlWydvrL3bBgrf
         TNOPp2Ogl+V8N45OvyOaFdKWLAUp5azIiDDCblyPE2eYo4doglRqBRm8mfVd7hB9lLNb
         PVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=87GRMo3aWccVg1tJE1Y4QJEISnFKW+1wZmaZv6DvTZ8=;
        b=ht4iaQtnjsWNTH+7OVCTPB13cdkStaalbg3/LPg6RveAj9BL5MT6Hb8iRIaFvjtmmV
         W1My0B+GDoHyKRhwU/n9K14z5QiHQ1MhJeBH7dx34mkn6FBhB8G+Xl7YyD2RCa5IbgQu
         QY4aA6dqIygKsBdXkFQPJFFM/QiwQAeQ7mwf7UmcaWmja1xHdviVsyi0hpzcJiZh6z4L
         acg4Jmy1c8IFFSkcJDtLMokrfaKvfJp/MW33bTAjy3+Hbia30w+1+zWMba26JOmGXBYR
         WZQ7dYtJGMIKGlA0fNz7r/DZIzzbQf3zvM6B5OeK3R6AZPuSzu/6N9K1AmgUInHZLWrD
         GGeg==
X-Gm-Message-State: ACgBeo2cR/YMLEZb95KhHtmv5kGkppLQA71mEkTx4hTZbKukLlvc6vk9
        T0PW0yxbP9Fj8WBgX6J8UZ5jJQ==
X-Google-Smtp-Source: AA6agR6oXF0dj54LOhTxCr8AEDa22Jc3jjaaKAPrNZznuD8OUx2ZFK7L2GapqZkR5PXAv7zCpwlz+Q==
X-Received: by 2002:a05:6000:4083:b0:21f:fb6:9293 with SMTP id da3-20020a056000408300b0021f0fb69293mr13538658wrb.303.1660039543424;
        Tue, 09 Aug 2022 03:05:43 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id d14-20020adfe84e000000b0021badf3cb26sm15788883wrn.63.2022.08.09.03.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 03:05:43 -0700 (PDT)
Date:   Tue, 9 Aug 2022 11:05:41 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        sami.mujawar@arm.com, kvm@vger.kernel.org, suzuki.poulose@arm.com
Subject: Re: [PATCH kvmtool 0/4] Makefile and virtio fixes
Message-ID: <YvIxdeajd9rY5tav@myrica>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
 <165962469392.742851.16474615486987710130.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165962469392.742851.16474615486987710130.b4-ty@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 04, 2022 at 04:02:27PM +0100, Will Deacon wrote:
> On Fri, 22 Jul 2022 15:17:28 +0100, Jean-Philippe Brucker wrote:
> > A few small fixes for kvmtool:
> > 
> > Patch 1 fixes an annoying issue when building kvmtool after updating
> > without a make clean.
> > 
> > Patch 2 enables passing ARCH=i386 and ARCH=x86_64.
> > 
> > [...]
> 
> I wasn't sure whether you were going to respin patch 2 based on Alexandru's
> comment, but I actually ran into the legacy IRQ issue so I went ahead and
> applied the series. I can, of course, queue extra stuff on top if you like!

Right I was away, thanks for picking those up. I don't think patch 2 needs
any change but I may send an optimization for patch 1

Thanks,
Jean

