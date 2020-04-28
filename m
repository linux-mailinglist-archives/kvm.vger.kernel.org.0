Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46F391BC521
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 18:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbgD1Q0O (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 12:26:14 -0400
Received: from muru.com ([72.249.23.125]:51636 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727920AbgD1Q0O (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 12:26:14 -0400
Received: from atomide.com (localhost [127.0.0.1])
        by muru.com (Postfix) with ESMTPS id 8684180F3;
        Tue, 28 Apr 2020 16:27:02 +0000 (UTC)
Date:   Tue, 28 Apr 2020 09:26:11 -0700
From:   Tony Lindgren <tony@atomide.com>
To:     Michael Mrozek <EvilDragon@openpandora.org>
Cc:     Marc Zyngier <maz@kernel.org>, Lukas Straub <lukasstraub2@web.de>,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        kernel@pyra-handheld.com
Subject: Re: Against removing aarch32 kvm host support
Message-ID: <20200428162611.GW43721@atomide.com>
References: <20200428143850.4c8cbd2a@luklap>
 <916b6072a4a2688745a5e3f75c1c8c01@misterjones.org>
 <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c67a3722611d1ec9fe1e8a1fbe65956b32147c3.camel@openpandora.org>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

* Michael Mrozek <EvilDragon@openpandora.org> [200428 14:27]:
> Am Dienstag, den 28.04.2020, 14:30 +0100 schrieb Marc Zyngier:
> I know we have to accept the decision, but so far, I've known Linux to support
> as many older devices as possible as well - removing KVM Host 32bit support
> would be a step back here.
> 
> Is there a specific reason for that?
> Is it too complex to maintain alongside the aarch64 KVM Host?

I don't know the details, but ideally things would be set up
in a way where folks interested in patching 32-bit arm kvm support
can do so without causing issues for 64-bit kvm development.

That being said, I don't know who might be interested in doing
all the work for that. It's unrealistic to expect Marc to do this
work if he's not using it.

Features that are used get more resources, and features that are
less used end up just bitrotting into a broken state in about
six weeks in the Linux kernel :)

Regards,

Tony
