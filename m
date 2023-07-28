Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0554C766F0C
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 16:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236934AbjG1OLr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 10:11:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236932AbjG1OLp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 10:11:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D36DA35A9
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7133C6214E
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80E41C433C8;
        Fri, 28 Jul 2023 14:11:39 +0000 (UTC)
Date:   Fri, 28 Jul 2023 15:11:36 +0100
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Eric Auger <eric.auger@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Andre Przywara <andre.przywara@arm.com>,
        Chase Conklin <chase.conklin@arm.com>,
        Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
        Darren Hart <darren@os.amperecomputing.com>,
        Miguel Luis <miguel.luis@oracle.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 01/26] arm64: Add missing VA CMO encodings
Message-ID: <ZMPMmKCHlFPe//4R@arm.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-2-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-2-maz@kernel.org>
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 09:29:27AM +0100, Marc Zyngier wrote:
> Add the missing VA-based CMOs encodings.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

In case you need more acks for the arm64 bits:

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
