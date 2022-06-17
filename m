Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1CA54F2B9
	for <lists+kvm@lfdr.de>; Fri, 17 Jun 2022 10:21:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380878AbiFQIVT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 17 Jun 2022 04:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380876AbiFQIVQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 17 Jun 2022 04:21:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CBA68982
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 01:21:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3482461F71
        for <kvm@vger.kernel.org>; Fri, 17 Jun 2022 08:21:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847C9C3411B;
        Fri, 17 Jun 2022 08:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655454073;
        bh=W2Ginzv0iaA6XSuuFMDWgNtEDCY4cfJBuvI+BxE8JME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t4+zHCvGZjfjXcYFtoD9CeeZln8e39/Qx/aPuTg8H9kW+eXrylGP8+xVKeu9uZpTl
         XTlSTYddmtf9DGCqqHg7x2W//pCgOvCeSeJFX57H+Q2BFBoAlZuMWm8R07pdrNwzqx
         I0sFdPyPZlR9j/50EK8WMfA+RXuH1rkmdJGjVSgFv6ZBTtyrB1MyNankaJiDep6WfW
         Z5j93PRNVfq8DgcePG7T1EFA5ZjglC9k8D7n2xzQAf4xky6tnHd3QBF9EtaxPiyQ1U
         mKmjqSu+57Cz5z04ax7aYjGBNxSguOFJ4JfM2e2lcEyiKBeBE6GSSWVMS7hThUKUGe
         YhXHnY2JrP00Q==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1o27E7-001F60-8g;
        Fri, 17 Jun 2022 09:21:11 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Cc:     Catalin Marinas <catalin.marinas@arm.com>, kernel-team@android.com,
        Will Deacon <will@kernel.org>
Subject: Re: [PATCH] KVM: arm64: Add Oliver as a reviewer
Date:   Fri, 17 Jun 2022 09:21:08 +0100
Message-Id: <165545405829.771018.16969597411109895074.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220616085318.1303657-1-maz@kernel.org>
References: <20220616085318.1303657-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: maz@kernel.org, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, catalin.marinas@arm.com, kernel-team@android.com, will@kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 16 Jun 2022 09:53:18 +0100, Marc Zyngier wrote:
> Oliver Upton has agreed to help with reviewing the KVM/arm64
> patches, and has been doing so for a while now, so adding him
> as to the reviewer list.
> 
> Note that Oliver is using a different email address for this
> purpose, rather than the one his been using for his other
> contributions.

Applied to fixes, thanks!

[1/1] KVM: arm64: Add Oliver as a reviewer
      commit: 8507e0b6edb3ac24cdf86f7cfba74eaeee00bf27

Cheers,

	M.
-- 
Marc Zyngier <maz@kernel.org>

