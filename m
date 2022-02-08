Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 388764ADFC7
	for <lists+kvm@lfdr.de>; Tue,  8 Feb 2022 18:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384330AbiBHRhc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Feb 2022 12:37:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384253AbiBHRh2 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Feb 2022 12:37:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79EFFC061576
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 09:37:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4458CB81CB4
        for <kvm@vger.kernel.org>; Tue,  8 Feb 2022 17:37:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6A6C004E1;
        Tue,  8 Feb 2022 17:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644341846;
        bh=JKHJOojfS8FhAcMS7Z7icwQjWdHq6AqagfXL8gLr5mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qvPl4OJE0SWbYT+h1FCKcs9L3sweRhol6J8IlsNyzxIQAcVKENRdjs40Ol+cw7Ugj
         XPNKznAn/1sMoGcCy0dwM455kw539o1CjlqTpfbppkIO5KYHze2quRjOW8vWm2T/Uw
         2sg+8jGAV71xfUwbQvanGAeexxRDqyNK3sRM34jH/ZzaHdhSg+NlNXGT6yWDScxmcB
         iRjopie42c8n3AZg/6lOwzmBSblZDkqL+yyyV5EkYRuWcfytEALbcgNrLoq8zmbcCd
         4MguBk5AiIE5oXFhr7Fy+hyO5ZQ3EXArBuXC01XctRtEUM5f2TNjUUGXGf4Q0PoIDj
         Lnq0G0eLbgOAg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1nHUQd-006KsJ-FJ; Tue, 08 Feb 2022 17:37:24 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     kvmarm@lists.cs.columbia.edu, Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Drop unused param from kvm_psci_version()
Date:   Tue,  8 Feb 2022 17:37:22 +0000
Message-Id: <164434147328.3931943.5227606914668090468.b4-ty@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220208012705.640444-1-oupton@google.com>
References: <20220208012705.640444-1-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, oupton@google.com, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 8 Feb 2022 01:27:05 +0000, Oliver Upton wrote:
> kvm_psci_version() consumes a pointer to struct kvm in addition to a
> vcpu pointer. Drop the kvm pointer as it is unused. While the comment
> suggests the explicit kvm pointer was useful for calling from hyp, there
> exist no such callsite in hyp.

Applied to next, thanks!

[1/1] KVM: arm64: Drop unused param from kvm_psci_version()
      commit: dfefa04a90cf9a20090cfa096153d64f95b7e33f

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


