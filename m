Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3E76B4C1F
	for <lists+kvm@lfdr.de>; Fri, 10 Mar 2023 17:07:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjCJQHY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Mar 2023 11:07:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbjCJQGm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Mar 2023 11:06:42 -0500
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 114F0420B
        for <kvm@vger.kernel.org>; Fri, 10 Mar 2023 08:05:00 -0800 (PST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 55175AD7;
        Fri, 10 Mar 2023 08:05:43 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BD8B3F5A1;
        Fri, 10 Mar 2023 08:04:58 -0800 (PST)
Date:   Fri, 10 Mar 2023 16:04:51 +0000
From:   Alexandru Elisei <alexandru.elisei@arm.com>
To:     Rajnesh Kanwal <rkanwal@rivosinc.com>
Cc:     atishp@rivosinc.com, apatel@ventanamicro.com, kvm@vger.kernel.org,
        will@kernel.org, julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com, jean-philippe@linaro.org
Subject: Re: [PATCH kvmtool 1/1] Add virtio-transport option and deprecate
 force-pci and virtio-legacy.
Message-ID: <ZAtUBHkyA19IOrjt@monolith.localdoman>
References: <20230306120329.535320-1-rkanwal@rivosinc.com>
 <ZAtG2Jk6VOOyT0xJ@monolith.localdoman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZAtG2Jk6VOOyT0xJ@monolith.localdoman>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

On Fri, Mar 10, 2023 at 03:03:52PM +0000, Alexandru Elisei wrote:
[..]
> On Mon, Mar 06, 2023 at 12:03:29PM +0000, Rajnesh Kanwal wrote:
[..]
> > +int virtio_tranport_parser(const struct option *opt, const char *arg, int unset)
> 
> If --virtio-transport is not specified on the kvmtool command line, then
> the default transport is set to VIRTIO_PCI, because that is the first
> member in the virtio_trans enum, and struct kvm is initialized to 0 in
> kvm__new() when it's allocated with calloc.
> 
> The above can be obscure for someone who is not familiar with the code. I
> think making the default explicit, by setting kvm->cfg.virtio_transport =
> VIRTIO_PCI in kvm_cmd_run_init(), before the command line arguments are
> parsed, would be clearer.

On second though, struct kvm_config relies on all the fields being set to zero
by kvm__new(), so there's no need to special case virtio_transport.

Thanks,
Alex
