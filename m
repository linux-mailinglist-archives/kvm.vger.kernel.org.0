Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B1FA7A49A4
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239793AbjIRMaJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240072AbjIRLQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 07:16:38 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9CD103
        for <kvm@vger.kernel.org>; Mon, 18 Sep 2023 04:16:15 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 223EDC433C7;
        Mon, 18 Sep 2023 11:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695035774;
        bh=5xOQIAZDrjMp5xfSoE5rAuprJRVprVkvhT6Y07nT/rU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GsAgQQ47ibnwefXL7lFxd5zgP6z9oVKRf1ndR9gcqvajxusSdYn62f9UxmjY71OeC
         25G1kBQkhGCo8xWb4DoB3/tOpx5ws64sqGluetLt3zyUzx9ND49QBl6sivf9lJUK+q
         XdAWMQ56mOvHILydO+HurcbWnjGwlGFUPLAHS8J+jpwD/Zvg3eDPi1ohdbME3A460i
         NR9ZI0UNsDSSr8c4OXz81UsSkaVqAgAbZVWdX0mycnAuyVO9ENqVfHesecGzjV4s09
         TfhEwEmOqYqTQZjSxe/hD00rjut0DUfQnHkDTwqdtzIBf9Uti5Uv6SNkv1pn6Ttdjx
         t4bIuswIG9dXQ==
Date:   Mon, 18 Sep 2023 12:16:09 +0100
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>, maz@kernel.org,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, julien.thierry.kdev@gmail.com
Subject: Re: [kvmtool PATCH 0/6] RISC-V AIA irqchip and Svnapot support
Message-ID: <20230918111609.GB18214@willie-the-truck>
References: <20230725152430.3351564-1-apatel@ventanamicro.com>
 <CAK9=C2WkkEpA3YM99HMNRk743mkhk2FDEpV_ffG3UWH9Vy3YkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAK9=C2WkkEpA3YM99HMNRk743mkhk2FDEpV_ffG3UWH9Vy3YkA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Sep 14, 2023 at 10:26:34PM +0530, Anup Patel wrote:
> On Tue, Jul 25, 2023 at 8:54 PM Anup Patel <apatel@ventanamicro.com> wrote:
> >
> > The latest KVM in Linux-6.5 has support for:
> > 1) Svnapot ISA extension support
> > 2) AIA in-kernel irqchip support
> >
> > This series adds corresponding changes in KVMTOOL to use the above
> > mentioned features for Guest/VM.
> >
> > These patches can also be found in the riscv_aia_v1 branch at:
> > https://github.com/avpatel/kvmtool.git
> >
> > Anup Patel (6):
> >   Sync-up header with Linux-6.5-rc3 for KVM RISC-V
> >   riscv: Add Svnapot extension support
> >   riscv: Make irqchip support pluggable
> >   riscv: Add IRQFD support for in-kernel AIA irqchip
> >   riscv: Use AIA in-kernel irqchip whenever KVM RISC-V supports
> >   riscv: Fix guest/init linkage for multilib toolchain
> 
> Friendly ping ?

It all looks pretty self-contained, but please send another version
importing the headers for v6.5 now that it has been released.

Cheers,

Will
