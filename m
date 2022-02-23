Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71A904C1CBB
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 21:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244586AbiBWUA5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 15:00:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234260AbiBWUAy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 15:00:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DCD27FC4;
        Wed, 23 Feb 2022 12:00:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03D5617A4;
        Wed, 23 Feb 2022 20:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0123C340E7;
        Wed, 23 Feb 2022 20:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645646425;
        bh=DNaS5nEsaghqF5/p/pvOR81erUDcQR6ZRHgWGUSoSUE=;
        h=From:To:Cc:Subject:Date:From;
        b=RMZjxwhTDl5y3mpkk24R6+2nCsCs56AjgVjmRNJHsUp3IBpqMFANmIYL34eHucMcB
         XYQis2gr/78mwJftWTkXZfjKUT4AOlnjDI4+uM6RPwUu8VtuMpRxzoSqI/Uh1Z/rec
         XCXH+cDyMHrl57rGAkKaNXiqZoEzywJATcKxs/7BjGKrXDzQvIWjHA3Q/l+23cWCKQ
         0DRTBjZJsMyeWlsLztJkXrdVK5angB8yaTZPEJgX0YaUNFgvqdZppXEsp0H485dTRR
         DTDeIxYDX5+lNUJxjVGX8zlFvgHlRgpCvkkks7RePeGv+h99yzYe//pl36rl5L9PBW
         9CUlZD7atb5+g==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janis Schoetterl-Glausch <scgl@linux.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Nicholas Piggin <npiggin@gmail.com>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Date:   Wed, 23 Feb 2022 20:00:19 +0000
Message-Id: <20220223200019.1891646-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

FIXME: Add owner of second tree to To:
       Add author(s)/SOB of conflicting commits.

Today's linux-next merge of the kvm tree got a conflict in:

  include/uapi/linux/kvm.h

between commit:

  93b71801a8274 ("KVM: PPC: reserve capability 210 for KVM_CAP_PPC_AIL_MODE_3")

from the kvm-fixes tree and commit:

  d004079edc166 ("KVM: s390: Add capability for storage key extension of MEM_OP IOCTL")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc include/uapi/linux/kvm.h
index 507ee1f2aa96b,dbc550bbd9fa3..0000000000000
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@@ -1134,7 -1140,7 +1140,8 @@@ struct kvm_ppc_resize_hpt 
  #define KVM_CAP_VM_GPA_BITS 207
  #define KVM_CAP_XSAVE2 208
  #define KVM_CAP_SYS_ATTRIBUTES 209
 -#define KVM_CAP_S390_MEM_OP_EXTENSION 210
 +#define KVM_CAP_PPC_AIL_MODE_3 210
++#define KVM_CAP_S390_MEM_OP_EXTENSION 211
  
  #ifdef KVM_CAP_IRQ_ROUTING
  
