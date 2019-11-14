Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1EF4FC8A2
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 15:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727002AbfKNORw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 09:17:52 -0500
Received: from foss.arm.com ([217.140.110.172]:43944 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbfKNORv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 09:17:51 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44BE730E;
        Thu, 14 Nov 2019 06:17:51 -0800 (PST)
Received: from donnerap.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1736A3F52E;
        Thu, 14 Nov 2019 06:17:49 -0800 (PST)
Date:   Thu, 14 Nov 2019 14:17:45 +0000
From:   Andre Przywara <andre.przywara@arm.com>
To:     Vladimir Murzin <vladimir.murzin@arm.com>
Cc:     Alexandru Elisei <alexandru.elisei@arm.com>,
        Andrew Jones <drjones@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH 09/17] arm: gic: Add test for flipping
 GICD_CTLR.DS
Message-ID: <20191114141745.32d3b89c@donnerap.cambridge.arm.com>
In-Reply-To: <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
References: <20191108144240.204202-1-andre.przywara@arm.com>
        <20191108144240.204202-10-andre.przywara@arm.com>
        <2e14ccd4-89f4-aa90-cc58-bebf0e2eeede@arm.com>
        <7ca57a0c-3934-1778-e3f9-a3eee0658002@arm.com>
Organization: ARM
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; aarch64-unknown-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 14 Nov 2019 13:39:33 +0000
Vladimir Murzin <vladimir.murzin@arm.com> wrote:

> Hi,
> 
> On 11/12/19 4:42 PM, Alexandru Elisei wrote:
> > Are we not testing KVM? Why are we not treating a behaviour different than what
> > KVM should emulate as a fail?
> 
> Can kvm-unit-tests be run with qemu TCG?

Yes, it does that actually by default if you cross compile. I also tested this explicitly on TCG: unlike KVM that actually passes all those tests.
If you set the environment variable ACCEL to either tcg or kvm, you can select this at runtime:
$ ACCEL=tcg arm/run arm/gic.flat -smp 3 -append irq

Cheers,
Andre
