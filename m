Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DBF6C35F9
	for <lists+kvm@lfdr.de>; Tue, 21 Mar 2023 16:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjCUPlf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 21 Mar 2023 11:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231582AbjCUPld (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 21 Mar 2023 11:41:33 -0400
Received: from out-8.mta1.migadu.com (out-8.mta1.migadu.com [IPv6:2001:41d0:203:375::8])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EBF313501
        for <kvm@vger.kernel.org>; Tue, 21 Mar 2023 08:41:28 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679413287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QvxSsq7y3ApZDI5RYQ/vz56iD3el/CYc8dT0qIs1x4g=;
        b=LhVW8jnewR5Veq+X+UClGyUaa9piY8SXqvgR9MowCRyL+1YrxQXosLdTansUI0BW++m2kk
        LGU9MPmq25SXuI/8Zi6unFq29SBV2+c0bt1ow+v6kz0qKIRuK21eqZrpKFae0VMPoLzio9
        100o8ga3OOX9k9YD0XtYCPuABFJD3RM=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>, kvmarm@lists.linux.dev
Cc:     "open list:ARM" <kvm@vger.kernel.org>,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [kvm-unit-tests PATCH v3 0/3] arm: Use gic_enable/disable_irq() macro to clean up code
Date:   Tue, 21 Mar 2023 16:41:23 +0100
Message-Id: <167940943514.820115.10265149359868996572.b4-ty@linux.dev>
In-Reply-To: <20230303031148.162816-1-shahuang@redhat.com>
References: <20230303031148.162816-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2 Mar 2023 22:11:44 -0500, Shaoqin Huang wrote:
> Some tests still use their own code to enable/disable irq, use
> gic_enable/disable_irq() to clean up them.
> 
> The first patch fixes a problem which will disable all irq when use
> gic_disable_irq().
> 
> The patch 2-3 clean up the code by using the macro.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
