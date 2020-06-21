Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4EC2027F3
	for <lists+kvm@lfdr.de>; Sun, 21 Jun 2020 04:17:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgFUCRz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 20 Jun 2020 22:17:55 -0400
Received: from mail-40131.protonmail.ch ([185.70.40.131]:22781 "EHLO
        mail-40131.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729080AbgFUCRy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 20 Jun 2020 22:17:54 -0400
Date:   Sun, 21 Jun 2020 02:17:51 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592705872;
        bh=RyMYJgcIWIeKtyr1aZ4PHI1VVxEnAIQogrseNbR10iM=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=RDzyPljgarO3TV+sT9ACCYCoIcB1FvvtpHz3PZzgu5g55zDuEghJEv7ZNddTOoXkt
         VTTtXZ3uc9DJUJOu1zsUws+ZURgWB/WTdvEVPt1CdKvqM5EZqnP2iBEVQukrpaJJaA
         d/YonHtk0IJABfnP4/W+eKuRE/suzUHrASSPxzb4=
To:     kvm@vger.kernel.org
From:   Rob Gill <rrobgill@protonmail.com>
Cc:     Rob Gill <rrobgill@protonmail.com>
Reply-To: Rob Gill <rrobgill@protonmail.com>
Subject: [PATCH] Add MODULE_DESCRIPTION to kvm kernel module
Message-ID: <20200621021739.27160-1-rrobgill@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The user tool modinfo is used to get information on kernel modules, includi=
ng a
description where it is available.

This patch adds a brief MODULE_DESCRIPTION to the kvm.ko module

Signed-off-by: Rob Gill <rrobgill@protonmail.com>
---
 virt/kvm/kvm_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index a852af5c3..008cd4050 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -68,6 +68,7 @@
=20
 MODULE_AUTHOR("Qumranet");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Kernel-based Virtual Machine driver");
=20
 /* Architectures should define their poll value according to the halt late=
ncy */
 unsigned int halt_poll_ns =3D KVM_HALT_POLL_NS_DEFAULT;
--=20
2.17.1


