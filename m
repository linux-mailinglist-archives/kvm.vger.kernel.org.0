Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52011681983
	for <lists+kvm@lfdr.de>; Mon, 30 Jan 2023 19:41:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237185AbjA3SlO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 30 Jan 2023 13:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237159AbjA3Sk6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 30 Jan 2023 13:40:58 -0500
X-Greylist: delayed 540 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 10:40:19 PST
Received: from out-21.mta1.migadu.com (out-21.mta1.migadu.com [IPv6:2001:41d0:203:375::15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6E0233CD
        for <kvm@vger.kernel.org>; Mon, 30 Jan 2023 10:40:19 -0800 (PST)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1675103475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iDcqrs/xuzO6IdPSvSvQfi+l+MKWADi+VSLIybsBcrI=;
        b=rgEVZ9d6cmLtzBlExV/5V3P97cwb7RQ0MSzQtLbjtphHMoRefKa14pn55fimXT7EDHdh7G
        8/Cm+BCu0PjnNTdje5AIPVJmSJ6zEiaVtBfNZOo3+mK/+UtdIiwhRMXoC805NKkYKfhX3Q
        2NlznwTbyi8EsbVLkkns/HbmY7VIvMs=
From:   Oliver Upton <oliver.upton@linux.dev>
To:     Marc Zyngier <maz@kernel.org>,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
        kvmarm@lists.linux.dev
Cc:     Oliver Upton <oliver.upton@linux.dev>,
        James Morse <james.morse@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH] KVM: arm64: Drop Columbia-hosted mailing list
Date:   Mon, 30 Jan 2023 18:31:08 +0000
Message-Id: <167510336268.1083059.2860531240390777372.b4-ty@linux.dev>
In-Reply-To: <20230113132809.1979119-1-maz@kernel.org>
References: <20230113132809.1979119-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 13:28:09 +0000, Marc Zyngier wrote:
> After many years of awesome service, the kvmarm mailing list hosted by
> Columbia is being decommissioned, and replaced by kvmarm@lists.linux.dev.
> 
> Many thanks to Columbia for having hosted us for so long, and to the
> kernel.org folks for giving us a new home.
> 
> 
> [...]

Applied to kvmarm/next, thanks!

[1/1] KVM: arm64: Drop Columbia-hosted mailing list
      https://git.kernel.org/kvmarm/kvmarm/c/960c3028a1d5

--
Best,
Oliver
