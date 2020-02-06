Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB20C15410A
	for <lists+kvm@lfdr.de>; Thu,  6 Feb 2020 10:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgBFJUx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 6 Feb 2020 04:20:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726365AbgBFJUw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 6 Feb 2020 04:20:52 -0500
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52C220661;
        Thu,  6 Feb 2020 09:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580980852;
        bh=OLFFLNqCbDSFfQtHQSD4S3WJhdgjdY6yY7r/ApixNQI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUjayvQSPGLqWi9k5XeWoU7NpzkvF7eRVL3RN0w+Fm9KWIwVDTRWx1rVqysXYkFJG
         9ieMkvejCKuK+YyMdZCiCREQyAMkMQOw/jTk+M705X6qqzyrzKJx9gk+wS+qGWWHBa
         Vq7kqzA0VRvfDPzwgxZrY3O5Bu+01okRYwZ/qyBY=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1izdL8-003HVm-4j; Thu, 06 Feb 2020 09:20:50 +0000
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 06 Feb 2020 09:20:50 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Will Deacon <will@kernel.org>, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
        julien.grall@arm.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 00/16] arm: Allow the user to define the memory
 layout
In-Reply-To: <ea711081-142a-6897-72c9-323d95d6311e@arm.com>
References: <1569245722-23375-1-git-send-email-alexandru.elisei@arm.com>
 <20200205171612.GC908@willie-the-truck>
 <ea711081-142a-6897-72c9-323d95d6311e@arm.com>
Message-ID: <162a7982334c8c96072a7bdd2e72b622@kernel.org>
X-Sender: maz@kernel.org
User-Agent: Roundcube Webmail/1.3.8
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: alexandru.elisei@arm.com, will@kernel.org, kvm@vger.kernel.org, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, julien.grall@arm.com, andre.przywara@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2020-02-05 17:18, Alexandru Elisei wrote:
> Hi,
> 
> On 2/5/20 5:16 PM, Will Deacon wrote:
>> On Mon, Sep 23, 2019 at 02:35:06PM +0100, Alexandru Elisei wrote:
>>> The guest memory layout created by kvmtool is fixed: regular MMIO is 
>>> below
>>> 1G, PCI MMIO is below 2G, and the RAM always starts at the 2G mark. 
>>> Real
>>> hardware can have a different memory layout, and being able to create 
>>> a
>>> specific memory layout can be very useful for testing the guest 
>>> kernel.
>>> 
>>> This series allows the user the specify the memory layout for the
>>> virtual machine by expanding the -m/--mem option to take an <addr>
>>> parameter, and by adding architecture specific options to define the 
>>> I/O
>>> ports, regular MMIO and PCI MMIO memory regions.
>>> 
>>> The user defined memory regions are implemented in patch #16; I 
>>> consider
>>> the patch to be an RFC because I'm not really sure that my approach 
>>> is the
>>> correct one; for example, I decided to make the options arch 
>>> dependent
>>> because that seemed like the path of least resistance, but they could 
>>> have
>>> just as easily implemented as arch independent and each architecture
>>> advertised having support for them via a define (like with RAM base
>>> address).
>> Do you plan to repost this with Andre's comments addressed?
> 
> The series will conflict with my other series which add support for 
> assignable
> BARs and PCIE. I am definitely still interested in reposting this
> because I think
> it's very useful, and I'll do it after the other patches get merged.

I'd be happy to review the rebased version. I definitely need it to
support some of my most funky HW...

         M.
-- 
Jazz is not dead. It just smells funny...
