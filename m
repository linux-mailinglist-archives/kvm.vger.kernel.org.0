Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5527E663361
	for <lists+kvm@lfdr.de>; Mon,  9 Jan 2023 22:44:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjAIVoJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Jan 2023 16:44:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237817AbjAIVoA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Jan 2023 16:44:00 -0500
Received: from out-232.mta0.migadu.com (out-232.mta0.migadu.com [91.218.175.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D0025B
        for <kvm@vger.kernel.org>; Mon,  9 Jan 2023 13:43:59 -0800 (PST)
Date:   Mon, 9 Jan 2023 21:43:54 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1673300638;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xbCLhBUzavGvG6c3ScGTHtSjvbga3hu28++gvcUxwl8=;
        b=IhklmKxUzNJ2e4QpxD/W8OMcGp0a3IW5OMC1sGupanX/e1/QFm7yotMJqNQH29goylwigJ
        39N107C5oISicBdIdMKHJL1+LSlFTQMm0hqUOrSf+7eMpZK/wwAxDZu77ts9oPbcrTniTt
        E2viycKhsStBMASDzut8GxmLOk/x4VM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        andrew.jones@linux.dev, maz@kernel.org, alexandru.elisei@arm.com,
        eric.auger@redhat.com, reijiw@google.com
Subject: Re: [kvm-unit-tests PATCH v3 4/4] arm: pmu: Print counter values as
 hexadecimals
Message-ID: <Y7yKmr3pGnIJyxdX@google.com>
References: <20230109211754.67144-1-ricarkol@google.com>
 <20230109211754.67144-5-ricarkol@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109211754.67144-5-ricarkol@google.com>
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jan 09, 2023 at 09:17:54PM +0000, Ricardo Koller wrote:
> The arm/pmu test prints the value of counters as %ld.  Most tests start
> with counters around 0 or UINT_MAX, so having something like -16 instead of
> 0xffff_fff0 is not very useful.
> 
> Report counter values as hexadecimals.
> 
> Reported-by: Alexandru Elisei <alexandru.elisei@arm.com>
> Signed-off-by: Ricardo Koller <ricarkol@google.com>

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>

--
Thanks,
Oliver
