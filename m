Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B001211E97
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 10:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbgGBIZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 04:25:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728461AbgGBIW4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 04:22:56 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E9C320874;
        Thu,  2 Jul 2020 08:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593678175;
        bh=pbs0tL/KRHo9Or+8WKf0S/Y8rnUfyyi5aMuo4ndjDb0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uk4KAbidTKiBkRHckpKADLipXJTOreeNHvPrKb0/67ZecOH6IgOJjzNDBtWfmaXOG
         KBUxXgWmt2fdxdnW+sjvGjf3tbkPUnCPmPBVE2tPjGoOcPG+gnL67tX8o8kLujvEde
         oi5fWrU2KfcDFL147o//XX8GD29gNVVwbL56CLYY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jquUg-008JXG-8g; Thu, 02 Jul 2020 09:22:54 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 02 Jul 2020 09:22:54 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
In-Reply-To: <20200702030132.20252-4-wangjingyi11@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <fe9699e3ee2131fe800911aea1425af4@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-02 04:01, Jingyi Wang wrote:
> If gicv4.1(sgi hardware injection) supported, we test ipi injection
> via hw/sw way separately.

nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
isn't as such visible to the guest itself (it only sees a GICv3).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
