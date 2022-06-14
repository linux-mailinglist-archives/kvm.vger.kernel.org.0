Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5CE54B3FA
	for <lists+kvm@lfdr.de>; Tue, 14 Jun 2022 16:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244977AbiFNOzZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Jun 2022 10:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232474AbiFNOzX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Jun 2022 10:55:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6992934BB0
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:55:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso6406349pja.2
        for <kvm@vger.kernel.org>; Tue, 14 Jun 2022 07:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Jk+q1kBSr1iLlwUrx1/Ew+sbApOYsm+K0Nuz7NCfdtY=;
        b=Qrhdx33mc3ZQNVey74/Hqgvb21OHpWNCSCVthTULGBYOt07IFbZAu7ZN1zVpxi2IxD
         hpFHJegsfF2bWNDIjzczk78u9gZ2s924APo6SloTQMQoO/NviJXcVs6uIptcmW1qLmnC
         tIHsUOVIHsdpg0FyZD6aHH8EKBxGW0Cn90hc+4dJfDt23BbqefEF9usNQqLSYrd9szCX
         z0xvKrAftSrtLlAuwbgE30i10kH7d+2Zk4cjefVTPHkaPBe6Lmbs5RZqDKsCdBfMsYQz
         FPnna5B4L/mumEXCi1qf/c8CF3y4Sk7gqHbi99jRW2YL4MFE6/t4KrAHynQZhCjkuhHa
         3Tbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Jk+q1kBSr1iLlwUrx1/Ew+sbApOYsm+K0Nuz7NCfdtY=;
        b=A5x+NNH+P2z77gs8E9wcW0mNnwtKSKBfznt/pqh37Nj7FOYyYhURjI19SgJk9ULqnO
         KYVymkpAPauE2W/qc4IT9Enq6/GooI9PLrrvhIA1lOth0KUewoF5E4YILHGLjMAb7bdC
         wCX27GCqdtSxpDO8KgISyPrfRXVIkK+5s6cZMiCCO8Wfz1PfsJXvGcQSij/tBSvIh+TM
         /3xlhHbgsv53sUwDlgnIP0MXnnDUOdlsrJ5ZQ40J2hGvHW1WesTSUloJxxgkhMm2PNPQ
         42bu8KHJ3vLYf4wqpU2RoqYJc7GZ7sDEu6v2UZeIMTqgOpi+zqqkPsC0IkrekvPhqxMN
         Vv9g==
X-Gm-Message-State: AJIora97V9RFgml16X7UktLYNXaXy3f/ZXZy3PfPvRQ0+Vfow5flp3bN
        5IgGBxotZ//pbOodFYcIHrhMDXbafiKjLw==
X-Google-Smtp-Source: AGRyM1sjkaWJlyt+OoaGBMF4b6E573E8yA654f0J/WdNKyN+LetmCplaLVzJHeXAXl9oM1d35aaBtQ==
X-Received: by 2002:a17:90b:1e44:b0:1e2:e772:5f08 with SMTP id pi4-20020a17090b1e4400b001e2e7725f08mr5121185pjb.129.1655218522685;
        Tue, 14 Jun 2022 07:55:22 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id ij29-20020a170902ab5d00b001676daaf055sm7308261plb.219.2022.06.14.07.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:55:22 -0700 (PDT)
Date:   Tue, 14 Jun 2022 14:55:18 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [GIT PULL] More KVM changes for Linux 5.19-rc3
Message-ID: <YqihVgV1AHGJ1GKw@google.com>
References: <20220614083552.1559600-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614083552.1559600-1-pbonzini@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 14, 2022, Paolo Bonzini wrote:
> Maxim Levitsky (7):
>       KVM: x86: document AVIC/APICv inhibit reasons
>       KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base

This patch has a bug that breaks 32-bit builds, and undoubtedly does weird things
for 64-bit builds.

[*] https://lore.kernel.org/all/20220610191813.371682-1-seanjc@google.com
