Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2394DB9F9
	for <lists+kvm@lfdr.de>; Wed, 16 Mar 2022 22:12:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358094AbiCPVMc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 17:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358171AbiCPVM1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 17:12:27 -0400
X-Greylist: delayed 62 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 16 Mar 2022 14:11:11 PDT
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5BF43394
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 14:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=date:from:to:subject:message-id:mime-version;
  bh=zDUoc12E1CnZ/3w5Qjf2PFSbrPcn+lZ9qe+uf7WtJfs=;
  b=fjKtB75K+emp1EJAT1vmsPHGS3sTCXKs38scE1bNRbWftbPPrB+ph6pi
   KuU/fDlNl5GyITPw3OvxOJ8oPeCCWIg+pMolFEl+a3V5NPwdqeO6ffe9i
   FAiGMqAyRt46vzG5pO1S160RWKBxoX4H5DRDCWsZeccLUp1CgvW70siqX
   U=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=julia.lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,187,1643670000"; 
   d="scan'208";a="26539020"
Received: from 203.107.68.85.rev.sfr.net (HELO hadrien) ([85.68.107.203])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2022 22:10:07 +0100
Date:   Wed, 16 Mar 2022 22:10:06 +0100 (CET)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        linux-riscv@lists.infradead.org, anup@brainfault.org
Subject: question about arch/riscv/kvm/mmu.c
Message-ID: <alpine.DEB.2.22.394.2203162205550.3177@hadrien>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

The function kvm_riscv_stage2_map contains the code:

mmu_seq = kvm->mmu_notifier_seq;

I noticed that in every other place in the kernel where the
mmu_notifier_seq field is read, there is a read barrier after it.  Is
there some reason why it is not necessary here?

thanks,
julia
