Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6269921240E
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 15:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729035AbgGBNDS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 09:03:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726343AbgGBNDS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 09:03:18 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D492220772;
        Thu,  2 Jul 2020 13:03:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593694998;
        bh=DU/qEXJhyo5s+7zwwietRnCmtfRVZjPerieDNN6bTyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bb02j41HDWRtcMeJGS5a/HmXQ23YjPopSGVn5Fy7ifGkuKU7hIY3kMM/XusJII12W
         Qqptkx7RxdiW6bkN5AuaLpY2SK+5RBPUXi1KWdbe5MQ588jxSdV3Xp/0xtqtYgy4u9
         zLTqhAs1lybS/8Simh/QLfLI7YZkb7+9nkhv0tls=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jqys0-008PHk-Es; Thu, 02 Jul 2020 14:03:16 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 02 Jul 2020 14:03:16 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Auger Eric <eric.auger@redhat.com>
Cc:     Jingyi Wang <wangjingyi11@huawei.com>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
In-Reply-To: <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <dabc2406-4a7f-61cf-cdbd-b0b79d97bf2c@redhat.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <688823451d3d4a0cb4d346bb7f7b99aa@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: eric.auger@redhat.com, wangjingyi11@huawei.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Eric,

On 2020-07-02 13:36, Auger Eric wrote:
> Hi Marc,
> 
> On 7/2/20 10:22 AM, Marc Zyngier wrote:
>> On 2020-07-02 04:01, Jingyi Wang wrote:
>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>> via hw/sw way separately.
>> 
>> nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
>> imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
>> isn't as such visible to the guest itself (it only sees a GICv3).
> 
> By the way, I have just downloaded the latest GIC spec from the ARM
> portal and I still do not find the GICD_CTLR_ENABLE_G1A,
> GICD_CTLR_nASSGIreq and GICD_TYPER2_nASSGIcap. Do I miss something?

The latest spec still is the old one. There is a *confidential* erratum
to the spec that adds the missing bits, but nothing public.

You unfortunately will have to take my word for it.

         M.
-- 
Jazz is not dead. It just smells funny...
