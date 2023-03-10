Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314FE6B4DF1
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 18:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCJREi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 12:04:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjCJREC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 12:04:02 -0500
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD201CBC9
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 09:02:08 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id q15-20020a63d60f000000b00502e1c551aaso1533010pgg.21
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 09:02:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678467728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HsfusCjCc210/E/HGWku9xtNSBTDQNBkrHBBfjpUrgw=;
        b=iSsFjWMG2Aib1vaWXXXWI2iTe/SiUJtBUSN9QgnyrwyhyULkmAbGuI8a+avapxsguv
         1uC2MT6ZwTj38FKKb/jWlrTWb83NoGtgF0k3Xwg6pkYfqOx72+77LIBm7vYmoWgLh3ay
         FP4oDTPKxGwqdw9QCIuCTo+MEyyhO+5UTL2/851s/1suiybpfRcS9QBN8Cb4bw55fsfb
         zBRyQcr8o1NL+WffxroVeWRAV5e77FCruKZhQQrcYERI5Mb2QEPtdW5/YdqWkO2HYgcI
         vAqMaeinIb1va2p0Vy7k/sh59W/GfJztes2RTWFdOHmCLyeQokwkHKVqJNl2Z72xmFOk
         ihUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678467728;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HsfusCjCc210/E/HGWku9xtNSBTDQNBkrHBBfjpUrgw=;
        b=IcftsbydO7Q6FSZ3w/b/bmtFFDDhtkXOwYY64vGgkaOegyA9Tx82FwdOx2AhBvIgI5
         +HYb+lxNZrGqFTvTehg4fjZjm/ZfHb1xnGnp0pr6F/GUezWZV1rM4MLBn0/5CNgIjbyb
         zrB1pixNhMtqMxoiWs79HmiBR3qq2uyeKLrXkpTQciK4WE4UBnMlziiXqLhLfmEad1Kv
         OugencTUkBQjePPG5m6GpZCsWziF1Qno7+d+1r192Brse+XRgoVxmOhgJ0SPUv0OKDEl
         ylXjbmBbU+k4EdTxw/4mTFPxxtacvLPrPJhiqtdbMXLiSzXEg9C/F4uK/Km0XMSEZ4ib
         8T0Q==
X-Gm-Message-State: AO0yUKWuK49hX0qmzkyd/10rnKqZFZ0lLBGBR6QhrFEWX9SO9Swj5czP
        MrFV7pRTx6f47GbFH6dvOJKLQ1w8Fwg=
X-Google-Smtp-Source: AK7set8hRm0G59X8lRz83J8/HnJ38K5SJesk7AwRkLXo6vd+rmcDG9eZZth6Gmi7fMS4eOegOQzUDud/nKc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:4f4c:b0:237:203f:1b76 with SMTP id
 w12-20020a17090a4f4c00b00237203f1b76mr9643928pjl.2.1678467727921; Fri, 10 Mar
 2023 09:02:07 -0800 (PST)
Date:   Fri, 10 Mar 2023 09:02:06 -0800
In-Reply-To: <7b763dae-e6c9-c269-2675-907430bbf21c@amd.com>
Mime-Version: 1.0
References: <20230227084016.3368-1-santosh.shukla@amd.com> <7b763dae-e6c9-c269-2675-907430bbf21c@amd.com>
Message-ID: <ZAtijt0srZ6b21Zi@google.com>
Subject: Re: [PATCHv4 00/11] SVM: virtual NMI
From:   Sean Christopherson <seanjc@google.com>
To:     Santosh Shukla <santosh.shukla@amd.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com,
        joro@8bytes.org, linux-kernel@vger.kernel.org,
        mail@maciej.szmigiero.name, mlevitsk@redhat.com,
        thomas.lendacky@amd.com, vkuznets@redhat.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 10, 2023, Santosh Shukla wrote:
> Gentle Ping?

I'm slowly working my into review mode for 6.4.  This is very much on my todo list.
