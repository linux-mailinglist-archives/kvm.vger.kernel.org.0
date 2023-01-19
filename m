Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B116740B1
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 19:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjASSQb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 13:16:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbjASSQ1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 13:16:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FBC76923B
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 10:16:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A8A4C61D12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 18:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 941C2C433EF;
        Thu, 19 Jan 2023 18:16:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674152181;
        bh=OCbq/hp3qsWGAwo25w+Lf2Xj/oSyOf48wgkqgx7HatA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sWmN2Jx5BOslAg8EVYSTgbyobox4+AwcGWwpHvGnefcaXzJxfi3guQ2EQAdmlOZs8
         uYXvaKvZ8P38MgxZn3zL9cZ8RV49rzXLn+GgbY4reVPuu3LrvJ3Zb6FdRI4mINYUz8
         SJZhBhumCiFWVYET9l/mhaB72BQaH07qAnlKEvsgXN46kA+7lsrgn1q6LlgsrlL95T
         /TWpqf4/LIsmPedX7zHv14xLzfBxzlSFX5s9P6LCiodl3qTYsTIsMq2T00RFw/9Ko8
         1Qj/Pk3N+LJqajeWdoIV2LEFJRH6gG4Bz9YHR8GHNf5C9DV+6ywb2fuK5qolvRPdcf
         ZtUy2BT6H4kTQ==
Date:   Thu, 19 Jan 2023 18:16:15 +0000
From:   Will Deacon <will@kernel.org>
To:     Alexandru Elisei <alexandru.elisei@arm.com>
Cc:     Rajnesh Kanwal <rkanwal@rivosinc.com>, apatel@ventanamicro.com,
        atishp@rivosinc.com, kvm@vger.kernel.org,
        julien.thierry.kdev@gmail.com, maz@kernel.org,
        andre.przywara@arm.com
Subject: Re: [PATCH kvmtool 1/1] riscv: pci: Add --force-pci option for riscv
 VMs.
Message-ID: <20230119181615.GB20563@willie-the-truck>
References: <20230118172007.408667-1-rkanwal@rivosinc.com>
 <Y8lIFLdsAAOqMo0Y@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8lIFLdsAAOqMo0Y@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jan 19, 2023 at 01:39:32PM +0000, Alexandru Elisei wrote:
> Hi,
> 
> CC'ing the kvmtool maintainers and other people that might be interested in this
> thread. Sorry for hijacking your patch!
> 
> On Wed, Jan 18, 2023 at 05:20:07PM +0000, Rajnesh Kanwal wrote:
> > Adding force-pci option to allow forcing virtio
> > devices to use pci as the default transport.
> 
> arm is in the same situation, MMIO is the default virtio transport. I was bitten
> by that in the past. It also cought other people unaware, and I remember maz
> complaining about it on the list.
> 
> So I was thinking about adding a new command line parameter, --virtio-transport,
> with the possible values mmio-legacy, mmio, pci-legacy and pci. Then each
> architecture can define the default value for the transport. For arm, that would
> be pci.
> 
> What do you guys think?

That sounds good to me. Then we can remove --force-pci altogether and maybe
have PCI as the default for everybody? Should make the tool a little easier
to use across architectures.

Will
