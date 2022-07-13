Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D4E572AC0
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 03:25:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233067AbiGMBZO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Jul 2022 21:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiGMBZN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Jul 2022 21:25:13 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DC3A9E4D;
        Tue, 12 Jul 2022 18:25:10 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id o12so8940752pfp.5;
        Tue, 12 Jul 2022 18:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lLVPqkAosf4PMRQEQYaadoJXwt8EeuULJlkcdFwNO5I=;
        b=B3q76OKlJH/WK2kX1d1ivrevP1y7t/dh0/y25Dc29gwW7fWS7lUnEYhVxiSZTcE3Qr
         mPM/Wnd3Oidsct+y7iaIdTpms3azEN/j0kJ8WVkcXShAgz5EG2gvBuvaMHMaoXKqMD4P
         xDDymwv2f9xKMsgJJtoGg7xBBrGvebN3lwrkVFEIOfmcA3VKLPUcWD3lygcJ6ZbKZIbE
         iavoSG2WK5wZ5wNjz23rB0TaEPITJAdvUA8y/ewC7B02GE0/z2dvDhJHgMKX2P9BC34B
         QFviBH/M7eISgtNoiT/MYeGxLniFcR9SzxFzWd2uo75HXdDgLkM3ZA9Dzxctcl/xFJw6
         noiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=lLVPqkAosf4PMRQEQYaadoJXwt8EeuULJlkcdFwNO5I=;
        b=ldm1zUi94QmsVsOpGDhokkNmsit7rqtfs35FHlhqxWf8bE5OghILaYQtsbVJLrOwQu
         8S0yPYlDaP0skes5fTSFGrFDy1n6vSM+Z95y1JDw3NC39J8z+kYlD+C0okCPW9ndQbfN
         r5ow0VApkUPtmbey6dZPXIROOWRfUjYbW3GT7/xzcRpeIcducPV0FGf0WWvNsa698w4G
         jL4xLCMw96pJ9krWsXsw3MWQdmPpNa/E25WaYVAqU0+7J1i6DP2BiKpgKSu4nVw7Ayny
         lZBlEK6WAQ/G+xIqtQQeLoPUYZzmbw9K5cc5JaR22NOVBxIf6y7764v5tRSQq+aBM1yU
         6y5A==
X-Gm-Message-State: AJIora/rkWRQUh2o/8EbuxzTRAWpee4Ppgann61QBH+W98TmmE4h/Ntj
        ZTK0mbavrzDWDz7F4aodKqM=
X-Google-Smtp-Source: AGRyM1t/PvoUPzuwOuxtxCDO8hbxX2kEiwxedN3AAuJIdQYri7xRyqf6eMPlveI5NwPf0B5EtA+ojw==
X-Received: by 2002:aa7:93a5:0:b0:51b:e0f8:97a6 with SMTP id x5-20020aa793a5000000b0051be0f897a6mr945321pff.44.1657675510216;
        Tue, 12 Jul 2022 18:25:10 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id w19-20020a63af13000000b0041562fd3c13sm6748931pge.4.2022.07.12.18.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 18:25:09 -0700 (PDT)
Date:   Tue, 12 Jul 2022 18:25:07 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 032/102] KVM: x86/mmu: introduce config for PRIVATE
 KVM MMU
Message-ID: <20220713012507.GO1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <fa5a472216f0394fab06e2fee29d42fdc1ed33af.1656366338.git.isaku.yamahata@intel.com>
 <873d12c1ebe3a64e3f11133308df064f2b581d8e.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <873d12c1ebe3a64e3f11133308df064f2b581d8e.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 08, 2022 at 01:53:48PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Mon, 2022-06-27 at 14:53 -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > To Keep the case of non TDX intact, introduce a new config option for
> > private KVM MMU support.  At the moment, this is synonym for
> > CONFIG_INTEL_TDX_HOST && CONFIG_KVM_INTEL.  The new flag make it clear
> > that the config is only for x86 KVM MMU.
> 
> What is the "new flag"?

Oops. flags should be "config". Will fix it. Thanks for pointing it out.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
