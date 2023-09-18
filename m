Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBE57A50CA
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 19:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbjIRRPM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 13:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbjIRRPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 13:15:10 -0400
Received: from out-213.mta1.migadu.com (out-213.mta1.migadu.com [95.215.58.213])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C8E7A2
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 10:15:04 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1695057302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f5gDnQ+vbW/swFSOMqP5K+xBHb3CMY5siz4f0e8auM8=;
        b=ZGgsZz13jPr+JKAe5V3bNFFEBoUqQMRSHEpo/5seHdo5o/ew8PFGZM+CF8fmgDrWvBEzfz
        F2XfWJsDj4i6Is2y8CKYshuwbDMHKwqQHtK6S17K8utdFrXge5wVel9Xj4WBxPD5m0G6m1
        hm1sLiPE2t4vNPqIVasDSXoFcoJrxXA=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc:     Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Marc Zyngier <maz@kernel.org>, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Jing Zhang <jingzhangos@google.com>
Subject: Re: [PATCH] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
Date:   Mon, 18 Sep 2023 17:14:50 +0000
Message-ID: <169505728619.3220441.6873711747214008692.b4-ty@linux.dev>
In-Reply-To: <20230913165645.2319017-1-oliver.upton@linux.dev>
References: <20230913165645.2319017-1-oliver.upton@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS,TO_EQ_FM_DIRECT_MX autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 13 Sep 2023 16:56:44 +0000, Oliver Upton wrote:
> A double-asterisk opening mark to the comment (i.e. '/**') indicates a
> comment block is in the kerneldoc format. There's automation in place to
> validate that kerneldoc blocks actually adhere to the formatting rules.
> 
> The function comment for arm64_check_features() isn't kerneldoc; use a
> 'regular' comment to silence automation warnings.
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Don't use kerneldoc comment for arm64_check_features()
      https://git.kernel.org/kvmarm/kvmarm/c/7b424ffcd458

--
Best,
Oliver
