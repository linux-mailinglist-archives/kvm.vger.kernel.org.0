Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97912211F9F
	for <lists+kvm@lfdr.de>; Thu,  2 Jul 2020 11:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgGBJRy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Jul 2020 05:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:42782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727057AbgGBJRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Jul 2020 05:17:54 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9682A20702;
        Thu,  2 Jul 2020 09:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593681473;
        bh=riJbnj3lW3s52zzCoIpgx8rEdxBveXjj8C/8uqF6YXA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mS7Kx7xYu+bjeniGuvdTqxDXvaGhLAfh6dHUKqojLyPj+YnkZTflqYGw3OX9HzrGD
         Ycbo5dO99JLrgJFCqQFaHhTZl218E1kvwpL41NITMDrC54GRgfV/COebsqB+sSI+Fo
         +8yCWS16sszLfyai63yMS9HBlW9Q1vmMRZc1cKTw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jqvLs-008L2R-4Q; Thu, 02 Jul 2020 10:17:52 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Thu, 02 Jul 2020 10:17:52 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Jingyi Wang <wangjingyi11@huawei.com>
Cc:     drjones@redhat.com, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu
Subject: Re: [kvm-unit-tests PATCH v2 3/8] arm64: microbench: gic: Add gicv4.1
 support for ipi latency test.
In-Reply-To: <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
References: <20200702030132.20252-1-wangjingyi11@huawei.com>
 <20200702030132.20252-4-wangjingyi11@huawei.com>
 <fe9699e3ee2131fe800911aea1425af4@kernel.org>
 <a570c59c-965f-8832-b0c3-4cfc342f18fe@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <10c3562dc019a3440d82dd507918faef@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: wangjingyi11@huawei.com, drjones@redhat.com, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-07-02 10:02, Jingyi Wang wrote:
> Hi Marc,
> 
> On 7/2/2020 4:22 PM, Marc Zyngier wrote:
>> On 2020-07-02 04:01, Jingyi Wang wrote:
>>> If gicv4.1(sgi hardware injection) supported, we test ipi injection
>>> via hw/sw way separately.
>> 
>> nit: active-less SGIs are not strictly a feature of GICv4.1 (you could
>> imagine a GIC emulation offering the same thing). Furthermore, GICv4.1
>> isn't as such visible to the guest itself (it only sees a GICv3).
>> 
>> Thanks,
>> 
>>          M.
> 
> Yes, but to measure the performance difference of hw/sw SGI injection,
> do you think it is acceptable to make it visible to guest and let it
> switch SGI injection mode?

It is of course acceptable. I simply object to the "GICv4.1" 
description.

         M.
-- 
Jazz is not dead. It just smells funny...
