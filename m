Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC4F358D6CF
	for <lists+kvm@lfdr.de>; Tue,  9 Aug 2022 11:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241275AbiHIJwj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 9 Aug 2022 05:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239708AbiHIJwi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 9 Aug 2022 05:52:38 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE941764E
        for <kvm@vger.kernel.org>; Tue,  9 Aug 2022 02:52:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id bv3so13698181wrb.5
        for <kvm@vger.kernel.org>; Tue, 09 Aug 2022 02:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0cSMItw43Inoh4zQjHN+Z8emn7wwacjZUGBhHGz1e3E=;
        b=xJF35BEQ5tZLqa8VNjVOfBR2KZGwgp6H7zJQ8Fxt6DZ3Exl9idAfddGaMKlr1o8BNL
         +Ac6rlapC9jx32x0JlaYIj66ieaChyMRSRyhawpeY9iWcdy8RMD9liyGMDCRI971ycwj
         R7TFQjDektMghZ/B5Ijdxae87tEkjcLSwu88fGuBqt1PMHmnYtfHJrx/E+FOTsayZRNJ
         qNBOOWg/MfW82JIMA3mBO3FHznwP9DcmDoX7uhzxXQYXqCPfLwyYVR911qWOXVD8Fwtx
         ynB74TU3kDSAyL7pXF8eXkZXlL3kyARJq5yYWP46cN4ThgjJGe9BzUUdqbl+XpDq0nMr
         X13Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0cSMItw43Inoh4zQjHN+Z8emn7wwacjZUGBhHGz1e3E=;
        b=DM5yYa6eBdhHbd7E9rrZG8ojlHT6T/py3MqPvnRe4ycMCn52fD9esQun+K01T52qqq
         njEjvcxkBEtvdOw/OXj+wsAnTHSMiu0Du7u4soe7rj8YbTtm+joy13RZbnvWnWoPTEtT
         F7OaZ6/BXjj8jEcMEdkj5fXgymFxJIAGY188E5xiIsueg8Cz9AxTT+7//JpIx/aqLzrP
         YIhH85rPma1ecW30c3nUZDStUwKZxLiCFRow0V3bK782eufwTq7A53VfnWoDleFTPSIM
         AqSpxNA/ZC5/po6Zjwsjpvd10ICZ2m/12wrihQA/jSInghUszlq+st9PFA3eqwPrcQWn
         telQ==
X-Gm-Message-State: ACgBeo2NaNrRdeo4RmTcgbrbgKybvn+9QxPSvZ9KOTI/GESmY56J0BJB
        cjY4eLZ6vbcK4aYvlZ8JjnMeXw==
X-Google-Smtp-Source: AA6agR4zhCZdVwjx2GfHcDO9PAwRTBUvUUT/20IK7SHa+xhi/brSTBsFfVIRZFv8VyKeG1d9MwxusQ==
X-Received: by 2002:a5d:5b18:0:b0:220:63db:c7ca with SMTP id bx24-20020a5d5b18000000b0022063dbc7camr14300227wrb.719.1660038755350;
        Tue, 09 Aug 2022 02:52:35 -0700 (PDT)
Received: from myrica (cpc92880-cmbg19-2-0-cust679.5-4.cable.virginm.net. [82.27.106.168])
        by smtp.gmail.com with ESMTPSA id r27-20020adfa15b000000b0021d70a871cbsm13411917wrr.32.2022.08.09.02.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 02:52:35 -0700 (PDT)
Date:   Tue, 9 Aug 2022 10:52:33 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     will@kernel.org, kvm@vger.kernel.org, suzuki.poulose@arm.com,
        sami.mujawar@arm.com
Subject: Re: [PATCH kvmtool 1/4] Makefile: Add missing build dependencies
Message-ID: <YvIuYTlYaYx9XfxN@myrica>
References: <20220722141731.64039-1-jean-philippe@linaro.org>
 <20220722141731.64039-2-jean-philippe@linaro.org>
 <Yt5vrPljvE0lMHPX@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yt5vrPljvE0lMHPX@monolith.localdoman>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jul 25, 2022 at 11:26:15AM +0100, Alexandru Elisei wrote:
> > @@ -590,6 +590,7 @@ cscope:
> >  # Escape redundant work on cleaning up
> >  ifneq ($(MAKECMDGOALS),clean)
> >  -include $(DEPS)
> > +-include $(STATIC_DEPS)
> 
> In the spirit in keeping the makefile as small as possible and reading
> fewer files, maybe STATIC_DEPS should be included only if the target is
> $(PROGRAM)-static.

Right this adds a measurable overhead, about 2-5% on a make invocation
without anything to do. It's not noticeable since the feature tests still
take most of the time, but optimizing it may be worthwhile

Thanks,
Jean

