Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 708C561D92D
	for <lists+kvm@lfdr.de>; Sat,  5 Nov 2022 10:42:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229533AbiKEJme (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 5 Nov 2022 05:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKEJmd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 5 Nov 2022 05:42:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6775221E
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 02:42:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 090E3B815C6
        for <kvm@vger.kernel.org>; Sat,  5 Nov 2022 09:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E03EC433D6;
        Sat,  5 Nov 2022 09:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667641349;
        bh=JN6aU2159+LnIGdVUDFlVD7XJbpBPoujgJJuF+mYRII=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PcYuG0V+rCExyWsyXI9kd/0Y8E/9ufh8ploElPHjPWPige8l3QF5Op90x7/rnyotA
         MiItM2Xxj6vzq6OQz5M62Eybdk+A1RKg1JMNen6cKv6mj+qypW80gL8GSNSizysH63
         by2BLGrUPVtf+GrICFx+1u6I0ifUCLCTkpXdOar3RE/omguTAd/IEPZDH36fCFP2Bl
         P4wIMsX+OoeJ22+LuvWDLYoP60H2INCpeisWFmU7d3uDtmnUzZYgY5w/BfYmNj1PDK
         X3lA5gp+C9qSKijkIXEnnAW5QyBe6zeO8kLAtKIBXrN+Usa11aEYEQLFhdSbU/v7Ro
         sFHCEIU+IT+DQ==
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1orFh5-0041Ff-9v;
        Sat, 05 Nov 2022 09:42:27 +0000
MIME-Version: 1.0
Date:   Sat, 05 Nov 2022 09:42:26 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Ricardo Koller <ricarkol@google.com>,
        Reiji Watanabe <reijiw@google.com>
Subject: Re: [PATCH v2 01/14] arm64: Add ID_DFR0_EL1.PerfMon values for
 PMUv3p7 and IMP_DEF
In-Reply-To: <Y2V6WIu40Cg2ShXV@google.com>
References: <20221028105402.2030192-1-maz@kernel.org>
 <20221028105402.2030192-2-maz@kernel.org> <Y2V6WIu40Cg2ShXV@google.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <778e0ed6767f1d0771bee1cc54b0c49c@kernel.org>
X-Sender: maz@kernel.org
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: oliver.upton@linux.dev, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvmarm@lists.linux.dev, kvm@vger.kernel.org, james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com, ricarkol@google.com, reijiw@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2022-11-04 20:47, Oliver Upton wrote:
> On Fri, Oct 28, 2022 at 11:53:49AM +0100, Marc Zyngier wrote:
>> Align the ID_DFR0_EL1.PerfMon values with ID_AA64DFR0_EL1.PMUver.
>> 
>> Signed-off-by: Marc Zyngier <maz@kernel.org>
> 
> Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
> 
> FYI, another pile of ID reg changes is on the way that'll move DFR0 to 
> a
> generated definition.
> 
> https://lore.kernel.org/linux-arm-kernel/20220930140211.3215348-1-james.morse@arm.com/
> 

Eh, another of these. The usual way we deal with this churn
is to have a stable branch in the arm64 tree which I pull into
the offending branch in the kvmarm tree.

Thanks for the heads up!

         M.
-- 
Jazz is not dead. It just smells funny...
