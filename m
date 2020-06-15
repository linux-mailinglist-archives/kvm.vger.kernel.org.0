Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF981F977A
	for <lists+kvm@lfdr.de>; Mon, 15 Jun 2020 14:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730097AbgFOM7Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 15 Jun 2020 08:59:25 -0400
Received: from foss.arm.com ([217.140.110.172]:47210 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730070AbgFOM7Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 15 Jun 2020 08:59:24 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E334431B;
        Mon, 15 Jun 2020 05:59:23 -0700 (PDT)
Received: from arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2461D3F6CF;
        Mon, 15 Jun 2020 05:59:23 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:59:21 +0100
From:   Dave Martin <Dave.Martin@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kernel-team@android.com
Subject: Re: [PATCH 0/4] KVM/arm64: Enable PtrAuth on non-VHE KVM
Message-ID: <20200615125920.GJ25945@arm.com>
References: <20200615081954.6233-1-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200615081954.6233-1-maz@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Jun 15, 2020 at 09:19:50AM +0100, Marc Zyngier wrote:
> Not having PtrAuth on non-VHE KVM (for whatever reason VHE is not
> enabled on a v8.3 system) has always looked like an oddity. This
> trivial series remedies it, and allows a non-VHE KVM to offer PtrAuth
> to its guests.

How likely do you think it is that people will use such a configuration?

The only reason I can see for people to build a kernel with CONFIG_VHE=n
is as a workaround for broken hardware, or because the kernel is too old
to support VHE (in which case it doesn't understand ptrauth either, so
it is irrelevant whether ptrauth depends on VHE).

I wonder whether it's therefore better to "encourage" people to turn
VHE on by making subsequent features depend on it where appropriate.
We do want multiplatform kernels to be configured with CONFIG_VHE=y for
example.


I ask this, because SVE suffers the same "oddity".  If SVE can be
enabled for non-VHE kernels straightforwardly then there's no reason not
to do so, but I worried in the past that this would duplicate complex
code that would never be tested or used.

If supporting ptrauth with !VHE is as simple as this series suggests,
then it's low-risk.  Perhaps SVE isn't much worse.  I was chasing nasty
bugs around at the time the SVE KVM support was originally written, and
didn't want to add more unknowns into the mix...

(Note, this is not an offer from me to do the SVE work!)

[...]

Cheers
---Dave
