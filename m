Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3B762DDF
	for <lists+kvm@lfdr.de>; Wed, 26 Jul 2023 09:36:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232771AbjGZHga (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Jul 2023 03:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230313AbjGZHfq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Jul 2023 03:35:46 -0400
Received: from out-23.mta0.migadu.com (out-23.mta0.migadu.com [91.218.175.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DBF230EE
        for <kvm@vger.kernel.org>; Wed, 26 Jul 2023 00:34:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1690356859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9MvyIg4WX4FC4saOAR0a3u/5ZUoJFrgwpLRFuZ3L8NI=;
        b=HxmRlBh1R3Qz04vPLV2HtKiNn073H+nufoyvoEFWHm2to9R0fBsgxoMzjhNOGVO/z7mwJ1
        XKQ+lEBoCAg9+Oy+OSxHIBV69/3M27OchalM19dsr9NXs+/QM2y7OJfD7+VlzYNFgJqjMv
        8EgMZK92lCTk7kAQ/apRhL26O2Ys/Mc=
From:   Andrew Jones <andrew.jones@linux.dev>
To:     Shaoqin Huang <shahuang@redhat.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Eric Auger <eric.auger@redhat.com>, kvmarm@lists.linux.dev,
        kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 0/2] arm64: Define name for the original RES1 bit but now functinal bit
Date:   Wed, 26 Jul 2023 09:34:18 +0200
Message-ID: <169035653885.7626.4349313144140586163.b4-ty@linux.dev>
In-Reply-To: <20230724073949.1297331-1-shahuang@redhat.com>
References: <20230724073949.1297331-1-shahuang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 24 Jul 2023 03:39:46 -0400, Shaoqin Huang wrote:
> According the talk[1], because the architecture get updated, what used to be a
> RES1 bit becomes a functinal bit. So we can define the name for these bits, this
> also increase the readability.
> 
> [1] lore.kernel.org/ZLZQ6r4-9mVdg4Ry@monolith.localdoman
> 
> v1:
> https://lore.kernel.org/all/20230719031926.752931-1-shahuang@redhat.com/
> Thanks, Eric for the suggestions:
> - Rephrase the commit title in patch 1.
> - Use the _BITULL().
> - Delete the SCTLR_EL1_RES1 and unwind its definition into
> INIT_SCTLR_EL1_MMU_OFF.
> 
> [...]

Applied to arm/queue, thanks!

https://gitlab.com/jones-drew/kvm-unit-tests/-/commits/arm/queue

drew
