Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D2B4C023B
	for <lists+kvm@lfdr.de>; Tue, 22 Feb 2022 20:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235244AbiBVTrN (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 22 Feb 2022 14:47:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229882AbiBVTrK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 22 Feb 2022 14:47:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A5EB6D3AE;
        Tue, 22 Feb 2022 11:46:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8AD29B819BE;
        Tue, 22 Feb 2022 19:46:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1136CC340E8;
        Tue, 22 Feb 2022 19:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645559200;
        bh=AO+AwoLjIRy8xeREpj4ZerrCDKNDgw8iIzulz3f0Gyw=;
        h=From:To:Cc:Subject:Date:From;
        b=g6fxgOv90tpRhGjPfhOJs/JTZBa/+QIEeLpMkEFWanv2jkRLxbVoyjqjA77xswg5V
         0CH0fFR0LbKcDh+U0sUefys7FQeG1Tw/Q2yvvCSw4FbjviGLzVqN9q5wU5d5ppt/PL
         Pvk/OkcgpZSPh2y4yN17yhNNMJlDgVHU6KQ1kIj5UcpyE2gkc8Uxk4UVrgRcdynJGR
         ild990vpM4vSnR0/BxfR8iwarS0xgpGM98LgaUTeZKw8i5zL1zVOEGMyk1rx/Lnpi2
         TItqJI2gEZ6BsC+eR//hQ5+TaIAIGRkSEb8bfixSHCcO9p7w2UQwcmwbK3EVPMupjR
         Y+bzMvr8PjOyQ==
From:   broonie@kernel.org
To:     Paolo Bonzini <pbonzini@redhat.com>, KVM <kvm@vger.kernel.org>
Cc:     Aaron Lewis <aaronlewis@google.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: manual merge of the kvm tree with the kvm-fixes tree
Date:   Tue, 22 Feb 2022 19:46:35 +0000
Message-Id: <20220222194635.1892866-1-broonie@kernel.org>
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

Today's linux-next merge of the kvm tree got a conflict in:

  arch/x86/kvm/x86.c

between commit:

  127770ac0d043 ("KVM: x86: Add KVM_CAP_ENABLE_CAP to x86")

from the kvm-fixes tree and commit:

  8a2897853c53f ("KVM: x86: return 1 unconditionally for availability of KVM_CAP_VAPIC")

from the kvm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc arch/x86/kvm/x86.c
index 8a66d10c7a8dc,16d29d41908fa..0000000000000
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@@ -4245,7 -4235,7 +4247,8 @@@ int kvm_vm_ioctl_check_extension(struc
  	case KVM_CAP_EXIT_ON_EMULATION_FAILURE:
  	case KVM_CAP_VCPU_ATTRIBUTES:
  	case KVM_CAP_SYS_ATTRIBUTES:
 +	case KVM_CAP_ENABLE_CAP:
+ 	case KVM_CAP_VAPIC:
  		r = 1;
  		break;
  	case KVM_CAP_EXIT_HYPERCALL:
