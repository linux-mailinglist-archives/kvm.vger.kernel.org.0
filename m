Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53797766F1A
	for <lists+kvm@lfdr.de>; Fri, 28 Jul 2023 16:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236965AbjG1OPK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 28 Jul 2023 10:15:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236969AbjG1OPJ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 28 Jul 2023 10:15:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1003A94
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 07:15:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B8F36213B
        for <kvm@vger.kernel.org>; Fri, 28 Jul 2023 14:15:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA60DC433C8;
        Fri, 28 Jul 2023 14:15:02 +0000 (UTC)
Date:   Fri, 28 Jul 2023 15:15:00 +0100
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
Subject: Re: [PATCH v2 08/26] arm64: Add HDFGRTR_EL2 and HDFGWTR_EL2 layouts
Message-ID: <ZMPNZKXHgbgAWj1v@arm.com>
References: <20230728082952.959212-1-maz@kernel.org>
 <20230728082952.959212-9-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230728082952.959212-9-maz@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jul 28, 2023 at 09:29:34AM +0100, Marc Zyngier wrote:
> As we're about to implement full support for FEAT_FGT, add the
> full HDFGRTR_EL2 and HDFGWTR_EL2 layouts.
> 
> Reviewed-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Marc Zyngier <maz@kernel.org>

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
