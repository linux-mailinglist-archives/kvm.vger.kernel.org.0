Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE81BC567
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728319AbgD1Qj1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:39:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:49412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728106AbgD1Qj0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:39:26 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F2E12206D6;
        Tue, 28 Apr 2020 16:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588091966;
        bh=8RpWHwtl4RZqT1ZbuFdwUYbYF9iOnIhy5wLRan7Ele0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C3O5HAnG/zI1EGbjpMSLFe4PPxjQXabbbGgb9/ZXUha0QkwEz2h9CJvqtGWWD//7q
         UqNTUwFQ9bNLrNTP5PiiThvSwqZxl2lJG1893SB4WE+ax/9unkmYml66+Suxe/7MgL
         n0o8XYwfyFRJMUv5hbxlnekwyonUpKdOGUuo1o2c=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
        by disco-boy.misterjones.org with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <maz@kernel.org>)
        id 1jTTGW-007QwJ-AY; Tue, 28 Apr 2020 17:39:24 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 28 Apr 2020 17:39:24 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Michael Mrozek <EvilDragon@openpandora.org>
Cc:     Lukas Straub <lukasstraub2@web.de>, kvmarm@lists.cs.columbia.edu,
        kvm@vger.kernel.org, kernel@pyra-handheld.com
Subject: Re: Against removing aarch32 kvm host support
In-Reply-To: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
References: <20200428143850.4c8cbd2a@luklap>
 <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
 <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
User-Agent: Roundcube Webmail/1.4.3
Message-ID: <f5c18fe4ca1d0cc3de5723b82ca4dafc@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: EvilDragon@openpandora.org, lukasstraub2@web.de, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, kernel@pyra-handheld.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Michael,

On 2020-04-28 15:26, Michael Mrozek wrote:
> Am Dienstag, den 28.04.2020, 14:30 +0100 schrieb Marc Zyngier:
> 
> Hi,
> 
> well, the PCBs are currently in production, the cases are already here 
> (coating
> is currently being delayed as the company has closed down due to Corona 
> right
> now), so the first 500 units would be ready to be shipped in around 2 - 
> 3 months
> at latest.
> 
> The non-existance problem would therefore be solved then.

And then? Are these 500 machines going to be instantly turned into 
production KVM
hosts? Over 7 years, we have identified at most *four* users. Four users 
over a
few billion 32bit ARM devices running Linux. What are the odds that you 
will
actually use KVM in any significant way? None whatsoever.

> So far, AFAIK, the Letux team has tried their best to get as close to 
> possible
> to mainline kernel and support as many classic devices (OMAP3 and OMAP4 
> devices
> as well), so removing 32bit support from mainline would surely be a 
> step back
> for a lot of older devices as well.

Read the above. No users. Which means that KVM/arm is untested and is 
just
bit-rotting. It is also incomplete and nobody is interested in putting 
the
required effort to help it moving forward. Hell, the whole ARM port is 
now
on life support, and you worry about KVM?

> I know we have to accept the decision, but so far, I've known Linux to 
> support
> as many older devices as possible as well - removing KVM Host 32bit 
> support
> would be a step back here.

Linux is known to support as many *useful* devices and features as 
possible.
KVM isn't one of them.

> Is there a specific reason for that?

Please read the threads on the subject.

> Is it too complex to maintain alongside the aarch64 KVM Host?

It certainly gets in the way of making significant changes to the arm64 
port.

And as I said, feel free to revive the port anytime. The code is still 
there,
the documentation available, and you're lucky enough to have one of the 
few
machines capable of virtualization. If all of a sudden you end-up 
finding
the killer use case for KVM/arm, I'll applaud its return. In the 
meantime,
the arm64 will be able to move at a much faster pace. As it turns out,
it has actual users.

Thanks,

       M.

> 
>> Hi Lukas,
>> 
>> Thanks for your email.
>> 
>> On 2020-04-28 13:38, Lukas Straub wrote:
>> > Hello Everyone,
>> > As a preorder of the Pyra handheld, (OMAP5 SoC with 2x cortex-a15 arm
>> > cores)
>> > I'm against removing KVM host support for aarch32. I'm probably going
>> > to use
>> > this device for more than 5 years and thus the latest lts-kernel is no
>> > option
>> > for me.
>> 
>> So let me spell it out. You are against the removal of a feature that
>> you don't
>> use yet, that you may of may not use on a device that doesn't exist 
>> yet,
>> which
>> you may or may not still be using by the time 5.4/5.6 aren't supported
>> anymore.
>> You don't seem to have the strongest case, I'm afraid.
>> 
>> But nothing is lost! The code is still in the git tree, ou can always
>> revert
>> the removal patches and revive the port if you are so inclined. It 
>> will
>> just need
>> to be stand-alone, and not depend on the arm64 code, which is now
>> evolving its own
>> separate way.
>> 
>> Cheers,
>> 
>>          M.
> --
> Mit freundlichen Grüßen,
> 
> Michael Mrozek
> 
> -----------------------
> OpenPandora GmbH
> Geschäftsführer: Michael Mrozek
> 
> Schäffbräustr. 11
> 85049 Ingolstadt
> Deutschland
> Tel.: 0841 / 990 5548
> http://www.openpandora.de/
> HRB 4879, Amtsgericht Ingolstadt
> -----------------------
> eMail: mrozek@openpandora.org

-- 
Jazz is not dead. It just smells funny...
