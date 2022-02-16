Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3F34B8D7B
	for <lists+kvm@lfdr.de>; Wed, 16 Feb 2022 17:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236116AbiBPQLq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 11:11:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231317AbiBPQLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 11:11:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C5A220D0
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 08:11:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E577661ADA
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:11:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6558C340F1;
        Wed, 16 Feb 2022 16:11:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645027892;
        bh=l7BMR6xSlvfPDgdb+kvPztV70T1yhbN19zCY0hG1+UM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qmv3SriOioLAeW4gx7FEkNyhWz2YYOZhhO2AStYKWk9Z54sU7xaMR5iITt/rQpZCa
         N4xqbcKwb04UZDryhaPJfCwtC0aLfC7D66knCnPsXIx6Y+43dtxiR+GT2GrTZM6yTI
         16VhkXFaLYcps9l4BFnqgX+SP1m9neRUcqKyylwElZAM2fRncLan5dEb5AIOg3EHVi
         o89sn1oAYkCuQnrOy8XrY+8HZ9mLd+y/BCRH12SJRnSTbgI0lypa0kPvy+Bg/0Y9Cf
         Qm/gqCRLAU8RVXUSv3WsxdYJELRSjJV87EGabODk8/LWQj8xp56ornSlOwPtOwyW9h
         DAHLHJjmio3cw==
From:   Will Deacon <will@kernel.org>
To:     alexandru.elisei@arm.com, Muchun Song <songmuchun@bytedance.com>,
        julien.thierry.kdev@gmail.com
Cc:     catalin.marinas@arm.com, kernel-team@android.com,
        Will Deacon <will@kernel.org>, kvm@vger.kernel.org
Subject: Re: [PATCH kvmtool v2 1/2] x86: Fix initialization of irq mptable
Date:   Wed, 16 Feb 2022 16:11:21 +0000
Message-Id: <164502621159.1966798.7729544561664394060.b4-ty@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220216113735.52240-1-songmuchun@bytedance.com>
References: <20220216113735.52240-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 16 Feb 2022 19:37:34 +0800, Muchun Song wrote:
> When dev_hdr->dev_num is greater one, the initialization of last_addr
> is wrong.  Fix it.
> 
> 

Applied to kvmtool (master), thanks!

[1/2] x86: Fix initialization of irq mptable
      https://git.kernel.org/will/kvmtool/c/d4d6f1538966
[2/2] x86: Set the correct APIC ID
      https://git.kernel.org/will/kvmtool/c/20b93be583f6

Cheers,
-- 
Will

https://fixes.arm64.dev
https://next.arm64.dev
https://will.arm64.dev
