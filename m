Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391A151D84C
	for <lists+kvm@lfdr.de>; Fri,  6 May 2022 14:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379958AbiEFM7U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 May 2022 08:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392216AbiEFM65 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 May 2022 08:58:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB49669701
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 05:54:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D9C9CE3633
        for <kvm@vger.kernel.org>; Fri,  6 May 2022 12:54:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03ACC385A9;
        Fri,  6 May 2022 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651841696;
        bh=nhyak/BXdR3N2cEVi/9Vu4R6yxmp/0xsiPirHOY61Zo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZluufjK40wIGN/R/8UiO6aPpDicTMcC2DNpkmzYDx0I+fbByA16W5ZExKYw+o4uXp
         VOC77xGhHrvlcT//vXBKs6GqdVkGeows1IsLbFbN7q9bt423+zz9R4UvLhH6sl0QRZ
         N+26tUC+aprSToE7Sx5rpei+RyIHIzMch7BeF/aqmev78orsPB1qfRVb7fs63chWaA
         o1ufaBB7ZNwolvgtY3z4PHRCHPpfEgVMSI4A1a4baLyi8ougQauNO0xDCRDqdcNcU0
         KjkLmfepO5hd41sT9nn1UfCkb9Pmu/UzLg/kQTizetwg+pDyvLaE68adxCBjdtPCjQ
         AUzTudaaWmjfQ==
Date:   Fri, 6 May 2022 13:54:50 +0100
From:   Will Deacon <will@kernel.org>
To:     Atish Patra <atishp@rivosinc.com>
Cc:     julien.thierry.kdev@gmail.com, maz@kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
Subject: Re: [RFC PATCH kvmtool 0/3] Add Sstc extension support
Message-ID: <20220506125450.GB22892@willie-the-truck>
References: <20220304101023.764631-1-atishp@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304101023.764631-1-atishp@rivosinc.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 04, 2022 at 02:10:20AM -0800, Atish Patra wrote:
> This series adds Sstc extension which was ratified recently.
> 
> The first two patches adds the ISA extension framework which allows
> to define and update the DT for any multi-letter ISA extensions. 
> 
> The last patch just enables Sstc extension specifically if the hardware
> supports it.
> 
> The series can also be found at
> https://github.com/atishp04/kvmtool/tree/sstc_v1
> 
> The kvm & Qemu patches can be found at
> 
> KVM: https://github.com/atishp04/linux/tree/sstc_v2
> OpenSBI: https://github.com/atishp04/opensbi/tree/sstc_v1
> Qemu: https://github.com/atishp04/qemu/tree/sstc_v1 
> 
> [1] https://drive.google.com/file/d/1m84Re2yK8m_vbW7TspvevCDR82MOBaSX/view
> 
> Atish Patra (3):
> riscv: Update the uapi header as per Linux kernel
> riscv: Append ISA extensions to the device tree
> riscv: Add Sstc extension support

These look fine to me. What's the status of the kernel-side changes?

Will
