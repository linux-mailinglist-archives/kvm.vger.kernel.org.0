Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3635A8373
	for <lists+kvm@lfdr.de>; Wed, 31 Aug 2022 18:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbiHaQrc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 31 Aug 2022 12:47:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231269AbiHaQrb (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 31 Aug 2022 12:47:31 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8416DD83E0
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:47:30 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id 78so482677pgb.13
        for <kvm@vger.kernel.org>; Wed, 31 Aug 2022 09:47:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=fZoi3p3476nwHsYBDa4XTnSE2m3eJYPB3/6zUX1N3co=;
        b=MNNk2M7Rd8IZwujALXwYdexGhMVh0a3g5yNMDQxIajaK7VUbyG5v4pPNyKSLeJxG2E
         C62GAUeKX1bc8mtz1WyAJkZtayMZDtuyFY0HaJnC+rqCDePcfU9vfopylZiHoVIgK/H7
         ufaTsobDW2z12sdUZWdTnRnBqWKkAQpiLMNFrcIYWAsQvjJ5KrZZ3bXMLYOxVDj/XiTn
         XJ9rx4a8lq22iZAu8fSXv3SgaQN3YfmaWkXXUJE4mAUiojo7qeqKwOUT1TlLxAYnM78/
         0br2LQH8SIbgFVolJu35MgahLlvOMsf+ggX4yrnWkbAZlkjIau2SnP2WeyQBxzc6dCYR
         cQaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=fZoi3p3476nwHsYBDa4XTnSE2m3eJYPB3/6zUX1N3co=;
        b=z1P2Rvw4AmsLGiU+RLU1YI1K71WBWYU3xrwxtBmgCUXjqLMh6eqA2BAszyM8O9zbCU
         luUI2g9TLzmlrdaCWKK1jtYoiyJbZKnNaSCn5nUpaBX2Q7t/cF/Jkd3WP5jGgf4nGlBu
         D4N3yCJyK8VIINQo3SP3Gur5QZZTXud0JEGNvvPlyqqbQxaX62UkQt3+nzrQSfkWtom0
         igpneLKOQtNWCLBfbjWgeyXGcrzYmNuQKEwqSCn5Oodm5AEWnv+jAhn49PNuzOovmjTy
         zaeAjDssYRDqnJQjUwVmA/tElZaprbyi7kQKDV4UNNx+8wbnSkTb6G3JQghaO/acpeWk
         kqTA==
X-Gm-Message-State: ACgBeo3SUe7Y0lIHepKonARaUKFdLK2g8OiGqkZp3UNP+qDi+l7XzC14
        3nEOGs+Cig1sAS1a7vw22AB3Jw==
X-Google-Smtp-Source: AA6agR6l6Gx05I14b1x1kX7vZr9f8vzqO532weKY3nU629ltrcGvZlbRbJvHn9N2HDKY/6jLzV4ucA==
X-Received: by 2002:a63:8048:0:b0:42b:73ef:ac8f with SMTP id j69-20020a638048000000b0042b73efac8fmr21867879pgd.446.1661964449973;
        Wed, 31 Aug 2022 09:47:29 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id r14-20020a17090a4dce00b001fde4a4c28csm1501668pjl.37.2022.08.31.09.47.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 09:47:29 -0700 (PDT)
Date:   Wed, 31 Aug 2022 16:47:25 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Li RongQing <lirongqing@baidu.com>
Subject: Re: [PATCH 15/19] KVM: x86: Explicitly skip optimized logical map
 setup if vCPU's LDR==0
Message-ID: <Yw+QnR8xu23ToD9g@google.com>
References: <20220831003506.4117148-1-seanjc@google.com>
 <20220831003506.4117148-16-seanjc@google.com>
 <0459cd1568afdbb451190518c2bdaa5a821987df.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0459cd1568afdbb451190518c2bdaa5a821987df.camel@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Aug 31, 2022, Maxim Levitsky wrote:
> On Wed, 2022-08-31 at 00:35 +0000, Sean Christopherson wrote:
> > Explicitly skip the optimized map setup if the vCPU's LDR is '0', i.e. if
> > the vCPU will never response to logical mode interrupts.  KVM already
> > skips setup in this case, but relies on kvm_apic_map_get_logical_dest()
> > to generate mask==0.  KVM still needs the mask=0 check as a non-zero LDR
> > can yield mask==0 depending on the mode, but explicitly handling the LDR
> > will make it simpler to clean up the logical mode tracking in the future.
> 
> If I am not mistaken, the commit description is a bit misleading - in this
> case we just don't add the vCPU to the map since it is unreachable, but we do
> continue creating the map.

I'll reword.  I intended that to mean "skip the optimized setup for the vCPU", but
even that is unnecessarily confusing.
