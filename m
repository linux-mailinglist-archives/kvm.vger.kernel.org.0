Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7209750D9D
	for <lists+kvm@lfdr.de>; Wed, 12 Jul 2023 18:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbjGLQLC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 12 Jul 2023 12:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjGLQLB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 12 Jul 2023 12:11:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E687F134
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 09:11:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 844E5616F1
        for <kvm@vger.kernel.org>; Wed, 12 Jul 2023 16:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C106C433C8;
        Wed, 12 Jul 2023 16:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689178259;
        bh=WFNIzpDUi9gvHUdJ7iaD5PxIsrG8kFtV0An+KtYVdAY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ld8T9Fg8JhiFT8MWyN90nrZykBoUJ80ljo65bUmsngefIp23GijCuijopnzmzUTbm
         cxu5bHVBa5rZaAmkZaDkEVb2Oxki+c46+shtAELJN0wxmrxK5okuwlMgAQ0zGDBQbD
         pcxFl7OQTwGyEfdbOe/fjBMNWJ9msi+mhXx8RdTH0Vyjz/nBZHY5BO5TbLRMwOSNln
         5HFUZMHTfDKGceZnR2RRgLOzU0vFScJXgRVap91XkqMO8SCy2d+mjFzl2tT3OtV/ML
         CmQ5MSP+uDymGZCJJEiGiHkN4jZ1bQBgCq12BktA4QyhGsasa86f8FDok6sYQsdEZJ
         41wrsaQfB0UPA==
Date:   Wed, 12 Jul 2023 17:10:54 +0100
From:   Will Deacon <will@kernel.org>
To:     Anup Patel <apatel@ventanamicro.com>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Andrew Jones <ajones@ventanamicro.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [kvmtool PATCH v3 0/8] RISC-V SBI enable/disable, Zbb, Zicboz,
 and Ssaia support
Message-ID: <20230712161053.GA2986@willie-the-truck>
References: <20230706173804.1237348-1-apatel@ventanamicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230706173804.1237348-1-apatel@ventanamicro.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 06, 2023 at 11:07:56PM +0530, Anup Patel wrote:
> The latest KVM in Linux-6.4 has support for:
> 1) Enabling/disabling SBI extensions from KVM user-space
> 2) Zbb ISA extension support
> 3) Zicboz ISA extension support
> 4) Ssaia ISA extension support
> 
> This series adds corresponding changes in KVMTOOL to use the above
> mentioned features for Guest/VM.
> 
> These patches can also be found in the riscv_sbi_zbb_zicboz_ssaia_v3
> branch at: https://github.com/avpatel/kvmtool.git
> 
> Changes since v2:
>  - Rebased on commit 0b5e55fc032d1c6394b8ec7fe02d842813c903df
>  - Updated PATCH1 to sync-up header with released Linux-6.4

Bah, now we're back to the __DECLARE_FLEX_ARRAY breakage :(

In file included from include/linux/kvm.h:15,
                 from x86/include/kvm/kvm-cpu-arch.h:6,
                 from include/kvm/kvm-cpu.h:4,
                 from include/kvm/ioport.h:4,
                 from hw/rtc.c:4:
x86/include/asm/kvm.h:511:17: error: expected specifier-qualifier-list before ‘__DECLARE_FLEX_ARRAY’
  511 |                 __DECLARE_FLEX_ARRAY(struct kvm_vmx_nested_state_data, vmx);
      |                 ^~~~~~~~~~~~~~~~~~~~


Will
