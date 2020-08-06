Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1FA23DEF6
	for <lists+kvm@lfdr.de>; Thu,  6 Aug 2020 19:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730584AbgHFRf3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Aug 2020 13:35:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:57750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729549AbgHFRfX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Aug 2020 13:35:23 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA80822DA7;
        Thu,  6 Aug 2020 12:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596715965;
        bh=d/Xylb6F3zb0kZ2gd52Fq58UKLgcP+AqxybVL4QzT0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMfbAypuu0haKllRVB9om26o5NMUVEcwU2Mxvwec2f1tRqgDaqBDg6MH6qyOvTPlQ
         U62cg7k10H/gnnKyYkfzt4gzRtQIvvBQ6lOkj/xjC/uHZcaV/dnWjHDOsPeXiFEfhB
         AP+cO9p5XsCl4BwlUqCP7NsLnkIjnV8/Yd+yHfH8=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1k3bgh-000F1t-K2; Thu, 06 Aug 2020 09:55:47 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Aug 2020 09:55:47 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     yangerkun <yangerkun@huawei.com>
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        james.morse@arm.com, drjones@redhat.com, marc.zyngier@arm.com,
        christoffer.dall@linaro.org, stable-commits@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: Patch "KVM: arm64: Make vcpu_cp1x() work on Big Endian hosts" has
 been added to the 4.4-stable tree
In-Reply-To: <6084bc97-11ea-4b7d-086e-fb98880fca6c@huawei.com>
References: <159230500664142@kroah.com>
 <6084bc97-11ea-4b7d-086e-fb98880fca6c@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <dec976884660057c6705be64e1e1cd20@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: yangerkun@huawei.com, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, james.morse@arm.com, drjones@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, stable-commits@vger.kernel.org, kvm@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Kun,

On 2020-08-06 03:26, yangerkun wrote:
> Hi,
> 
> Not familiar with kvm. And I have a question about this patch. Maybe
> backport this patch 3204be4109ad("KVM: arm64: Make vcpu_cp1x() work on
> Big Endian hosts") without 52f6c4f02164 ("KVM: arm64: Change 32-bit
> handling of VM system registers") seems not right?

This seems sensible. Please post a backport of this patch, assuming
you are in a position to actually test it (I'm not able to run BE
kernels, let alone userspace).

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
