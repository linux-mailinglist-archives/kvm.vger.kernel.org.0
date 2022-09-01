Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A12B5A9A35
	for <lists+kvm@lfdr.de>; Thu,  1 Sep 2022 16:27:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234719AbiIAOYe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Sep 2022 10:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234708AbiIAOYN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Sep 2022 10:24:13 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2B6760DA
        for <kvm@vger.kernel.org>; Thu,  1 Sep 2022 07:23:43 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id x23so17227961pll.7
        for <kvm@vger.kernel.org>; Thu, 01 Sep 2022 07:23:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=u1QIchoXmcZhKqcTXwRL0Lys0s3kZnbhQdWBa8IvCKQ=;
        b=FUyJK0q2UBzSbxHXcF/B7LnZl9ofQg/lbncmRMOYiS01zNRZFiO9sdpBG3oTQ5+uUY
         ZdB+k3/y0YsYIejusF5oA0Dfo7Mbl8vz8JmkeCklOqs1Su+BPk63Ry6/Hog7tGaqv2D6
         StMP5+sumAo9S2Z6O3E0o+6fGzKC816LxES8J4a2kX/oh4QgPXOr/t1RfetBO2NK0smI
         OWKw/0/uvJvT317UNy5RZwyjXXa+8aqD6FbYP0f7aiTeFbFfc99kEVH6E1Sy1nTkujx/
         NcEN5c7HwOQqZ9tYzzCdQvOAINdyMXKIfp9aBZJcwYi2+p5ZPWrlg6YQGAuI7GeJadyn
         tTxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=u1QIchoXmcZhKqcTXwRL0Lys0s3kZnbhQdWBa8IvCKQ=;
        b=Ho4u91CC/FFqKxk6QsOgIR5DFfqgg+JQ4CujTTGADRHnl9HJGLMZNl/GnYuLyAtv9C
         k7eOBN8so4nW7aAo82yXwrmihJiH3vBs21Xocg796AmWWTQ+nw5vaBuHlTLTRh+r0yD9
         yYyub2JHOYuZIE7pzCSaCLmSAEXmEyENMGLw7bn3H+ggtIcGCNn5cwZvWDGFE7wOkGsX
         a6fwtZ1AfOfBkyoBMxqhGUHO0RGfh9zilGl3Fywo4jUBsZixJC7y0PILjbJ3058S6yQv
         cl538nRyL0KBzgXPcGr9ii+OC8Z7Bm47tNOKCtEXFbTjsDLa5y+1/0q8Oovtm+VA7wYC
         EldA==
X-Gm-Message-State: ACgBeo2WjuBtrmp7K7xQIRNsjxbn2bUUFTJNYJWfwV/NOBKKphAbQHqY
        IacHssuqtL3AwaM4stuEfTJKqA==
X-Google-Smtp-Source: AA6agR4YkFHEdoyOLlOiMu5KQtAKCivarev6LoDIC6j3xbaB8WtbnGWOmaAasm45Ugewsk+FjAahmg==
X-Received: by 2002:a17:90b:4c47:b0:1fa:dd14:aabd with SMTP id np7-20020a17090b4c4700b001fadd14aabdmr9088995pjb.76.1662042223109;
        Thu, 01 Sep 2022 07:23:43 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id x17-20020a170902ec9100b00174a69f69b8sm10127904plg.51.2022.09.01.07.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 07:23:42 -0700 (PDT)
Date:   Thu, 1 Sep 2022 14:23:39 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org, like.xu.linux@gmail.com,
        kan.liang@linux.intel.com, wei.w.wang@intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/15] Introduce Architectural LBR for vPMU
Message-ID: <YxDAa6sV1CUyGpoN@google.com>
References: <20220831223438.413090-1-weijiang.yang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220831223438.413090-1-weijiang.yang@intel.com>
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

On Wed, Aug 31, 2022, Yang Weijiang wrote:
> The old patch series was queued in KVM/queue for a while and finally
> moved to below branch after Paolo's refactor. This new patch set is 
> built on top of Paolo's work + some fixes, it's tested on legacy platform
> (non-ArchLBR) and SPR platform(ArchLBR capable).

...

> Changes in this version:
> 1. Fixed some minor issues in the refactored patch set.
> 2. Added a few minor fixes due to recent vPMU code cleanup.

Please elaborate on what was broken, i.e. why this was de-queued, as well as on
what was fixed an dhow.  That will help bring me up to speed and expedite review.
