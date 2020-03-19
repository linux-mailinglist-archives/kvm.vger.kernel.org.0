Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7375018B324
	for <lists+kvm@lfdr.de>; Thu, 19 Mar 2020 13:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgCSMSl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Mar 2020 08:18:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725787AbgCSMSl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Mar 2020 08:18:41 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6518E20663;
        Thu, 19 Mar 2020 12:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584620320;
        bh=9n5iSscoqYAjXl49/svHpLf5qsJKzfPfCazHWgnTthY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hMSyvzWudmn5PzqltwH9zVaoJflLaueZMoY7JuIBTmbwkmjCNT2hHrPKP5wQH72Yh
         QFw0yTyO2UEaw6WkBq6MKpEtt6gXN8nHKmL84bm4cma4fb8H2wB9x2hE3YrL1/HpSO
         TyT89wwVpUtFpxgCHtakHPiwm6ZKyuZAtda9p8uI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jEu8E-00Dvom-M6; Thu, 19 Mar 2020 12:18:38 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 19 Mar 2020 12:18:38 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Robert Richter <rrichter@marvell.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Auger <eric.auger@redhat.com>,
        James Morse <james.morse@arm.com>,
        Julien Thierry <julien.thierry.kdev@gmail.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: Re: [PATCH v5 21/23] KVM: arm64: GICv4.1: Reload VLPI configuration
 on distributor enable/disable
In-Reply-To: <7f112d75-166b-24eb-538d-e100242d8e9a@huawei.com>
References: <20200304203330.4967-1-maz@kernel.org>
 <20200304203330.4967-22-maz@kernel.org>
 <7f112d75-166b-24eb-538d-e100242d8e9a@huawei.com>
Message-ID: <ed4b6d1f4a156e22c5c619e197fa4752@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.10
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, jason@lakedaemon.net, rrichter@marvell.com, tglx@linutronix.de, eric.auger@redhat.com, james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-03-18 03:17, Zenghui Yu wrote:
> On 2020/3/5 4:33, Marc Zyngier wrote:
>> Each time a Group-enable bit gets flipped, the state of these bits
>> needs to be forwarded to the hardware. This is a pretty heavy
>> handed operation, requiring all vcpus to reload their GICv4
>> configuration. It is thus implemented as a new request type.
> 
> [note to myself]
> ... and the status are forwarded to HW by programming VGrp{0,1}En
> fields of GICR_VPENDBASER when vPEs are made resident next time.

I've added something based on this comment to the commit message.

Thanks!

         M.
-- 
Jazz is not dead. It just smells funny...
