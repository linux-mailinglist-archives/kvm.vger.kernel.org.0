Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA491BC151
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 16:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgD1Obv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 10:31:51 -0400
Received: from rhea.dragonbox.de ([95.216.39.121]:64692 "EHLO
        rhea.dragonbox.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727114AbgD1Obv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 10:31:51 -0400
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Apr 2020 10:31:49 EDT
Received: from bigevilshop (p4FC9321D.dip0.t-ipconnect.de [79.201.50.29])
        (Authenticated sender: evildragon@openpandora.org)
        by rhea.dragonbox.de (Postfix) with ESMTPSA id AA572780531;
        Tue, 28 Apr 2020 16:26:25 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=openpandora.org;
        s=2020; t=1588083985;
        bh=Cp1GbbIebWOVj7lHaBObu5tJ0h8gF9t75KwpoxSij4Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pLFyr0wmRBqIDAcf4G7s469wh45tFiC4VymgSYgv6+KCx9fklNhqG845wd/rsorJH
         UL94zxxdnCX0wxw+iKLzw9QzeIk/diWb0RWXIvfufEuE4qcD7+rU/2Fwh22X1Dud6q
         tvuPq7UpvRs/KuCuzzk+gJ/jjks9mXBa6QF8Lr1bppFFHX+JFRmT8qbd6ooTRwWkBS
         t0a/4T3hX8eWFW/OpMXQKKEXj+2pMln4R9/t/1DaTnQIGih73TMdpzaKnpjW46eSmk
         3rcqkczSF3k+wv0UbIP65h1ZEyB22LBi61x3XTrZ/qFBJ0yfosGXIg9xGEcnSCePFg
         qHnHWojPihVrQ==
Message-ID: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
Subject: Re: Against removing aarch32 kvm host support
From:   Michael Mrozek <EvilDragon@openpandora.org>
To:     Marc Zyngier <maz@kernel.org>, Lukas Straub <lukasstraub2@web.de>
Cc:     kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel@pyra-handheld.com
Date:   Tue, 28 Apr 2020 16:26:05 +0200
In-Reply-To: <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
References: <20200428143850.4c8cbd2a@luklap>
         <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Am Dienstag, den 28.04.2020, 14:30 +0100 schrieb Marc Zyngier:

Hi,

well, the PCBs are currently in production, the cases are already here (coating
is currently being delayed as the company has closed down due to Corona right
now), so the first 500 units would be ready to be shipped in around 2 - 3 months
at latest.

The non-existance problem would therefore be solved then.

So far, AFAIK, the Letux team has tried their best to get as close to possible
to mainline kernel and support as many classic devices (OMAP3 and OMAP4 devices
as well), so removing 32bit support from mainline would surely be a step back
for a lot of older devices as well.

I know we have to accept the decision, but so far, I've known Linux to support
as many older devices as possible as well - removing KVM Host 32bit support
would be a step back here.

Is there a specific reason for that?
Is it too complex to maintain alongside the aarch64 KVM Host?

> Hi Lukas,
> 
> Thanks for your email.
> 
> On 2020-04-28 13:38, Lukas Straub wrote:
> > Hello Everyone,
> > As a preorder of the Pyra handheld, (OMAP5 SoC with 2x cortex-a15 arm 
> > cores)
> > I'm against removing KVM host support for aarch32. I'm probably going 
> > to use
> > this device for more than 5 years and thus the latest lts-kernel is no 
> > option
> > for me.
> 
> So let me spell it out. You are against the removal of a feature that 
> you don't
> use yet, that you may of may not use on a device that doesn't exist yet, 
> which
> you may or may not still be using by the time 5.4/5.6 aren't supported 
> anymore.
> You don't seem to have the strongest case, I'm afraid.
> 
> But nothing is lost! The code is still in the git tree, ou can always 
> revert
> the removal patches and revive the port if you are so inclined. It will 
> just need
> to be stand-alone, and not depend on the arm64 code, which is now 
> evolving its own
> separate way.
> 
> Cheers,
> 
>          M.
-- 
Mit freundlichen Grüßen,

Michael Mrozek

-----------------------
OpenPandora GmbH
Geschäftsführer: Michael Mrozek

Schäffbräustr. 11
85049 Ingolstadt
Deutschland
Tel.: 0841 / 990 5548
http://www.openpandora.de/
HRB 4879, Amtsgericht Ingolstadt
-----------------------
eMail: mrozek@openpandora.org

