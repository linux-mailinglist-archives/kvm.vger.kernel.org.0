Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F34E676742
	for <lists+kvm@lfdr.de>; Sat, 21 Jan 2023 16:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229751AbjAUPlW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 21 Jan 2023 10:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjAUPlV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 21 Jan 2023 10:41:21 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ACF176596
        for <kvm@vger.kernel.org>; Sat, 21 Jan 2023 07:41:19 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F2138106F;
        Sat, 21 Jan 2023 07:42:00 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E8BD63F67D;
        Sat, 21 Jan 2023 07:41:17 -0800 (PST)
Date:   Sat, 21 Jan 2023 15:41:11 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Marc Zyngier <maz@kernel.org>
Cc:     Will Deacon <will@kernel.org>,
        Rajnesh Kanwal <rkanwal@rivosinc.com>, apatel@ventanamicro.com,
        atishp@rivosinc.com, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 1/1] riscv: pci: Add --force-pci option for riscv
 VMs.
Message-ID: <Y8wHlz1u5nkragEB@monolith.localdoman>
References: <20230118172007.408667-1-rkanwal@rivosinc.com>
 <Y8lIFLdsAAOqMo0Y@arm.com>
 <20230119181615.GB20563@willie-the-truck>
 <86ilh0m66s.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86ilh0m66s.wl-maz@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Sat, Jan 21, 2023 at 12:18:51PM +0000, Marc Zyngier wrote:
> On Thu, 19 Jan 2023 18:16:15 +0000,
> Will Deacon <will@kernel.org> wrote:
> > 
> > On Thu, Jan 19, 2023 at 01:39:32PM +0000, Alexandru Elisei wrote:
> > > Hi,
> > > 
> > > CC'ing the kvmtool maintainers and other people that might be interested in this
> > > thread. Sorry for hijacking your patch!
> > > 
> > > On Wed, Jan 18, 2023 at 05:20:07PM +0000, Rajnesh Kanwal wrote:
> > > > Adding force-pci option to allow forcing virtio
> > > > devices to use pci as the default transport.
> > > 
> > > arm is in the same situation, MMIO is the default virtio transport. I was bitten
> > > by that in the past. It also cought other people unaware, and I remember maz
> > > complaining about it on the list.
> > > 
> > > So I was thinking about adding a new command line parameter, --virtio-transport,
> > > with the possible values mmio-legacy, mmio, pci-legacy and pci. Then each
> > > architecture can define the default value for the transport. For arm, that would
> > > be pci.
> > > 
> > > What do you guys think?
> > 
> > That sounds good to me. Then we can remove --force-pci altogether and maybe
> > have PCI as the default for everybody? Should make the tool a little easier
> > to use across architectures.
> 
> I'd rather keep --force-pci in order no to break existing scripting.
> It just won't do anything once we make PCI the default (which we
> definitely should).

My plan was to mark --force-pci and --virtio-legacy as deprecated in the
help message and to parse them to set the correct value for
--virtio-transport (so if --force-pci and --virtio-legacy is specified,
the value for --virtio-transport pci-legacy). So as not to break CIs and
existing scripts.

Since I would be already parsing them, I was wondering if it would be
useful to also print a warning on the command line for users to switch to
--virtio-transport. Any opinions about this?

Thanks,
Alex

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
