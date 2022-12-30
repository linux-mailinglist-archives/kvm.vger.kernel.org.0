Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DDF765964C
	for <lists+kvm@lfdr.de>; Fri, 30 Dec 2022 09:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234811AbiL3IZk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 30 Dec 2022 03:25:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234427AbiL3IZi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 30 Dec 2022 03:25:38 -0500
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95585101DA
        for <kvm@vger.kernel.org>; Fri, 30 Dec 2022 00:25:35 -0800 (PST)
Date:   Fri, 30 Dec 2022 08:25:28 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
        s=protonmail; t=1672388733; x=1672647933;
        bh=fMA2ZNeMwaz5DbuniKVGv7Uhkszk4oAvhvyyLzk1WtM=;
        h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
         Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
        b=Kzh639DQ8WvwSbiGaFM/MUnuhl2vlI/DKHL4BwYrQhu2oxlT2golu4E7CHOwKHgaT
         s09nlKqBzeJQhoL5TQj8OR6ArAr8rdfb/b6cqaSgZizu7srxR5PxXtn37ffhkVyI7b
         eK1eoc33+fsYq+XYRSSaeYO9ns4cuKN+24TW7/2TkEl1bPrh5wMwqIfUZRaolktXM1
         4VpdVbm/Ayhyymzpdqrz4Wq+rLHnjUIYZC/zkihIhvAXA0J/xDwip+uI9nufmmrl7w
         /qKMMUOboIDA57xF4ChY2YckXwDdR1c9CJy7/QgxjKfsnjHhuryc1vzFeD/XPMyAUS
         sGihekYoE+ToQ==
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "firecracker-maintainers@amazon.com" 
        <firecracker-maintainers@amazon.com>,
        "criu@openvz.org" <criu@openvz.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
From:   scalingtree <scalingtree@proton.me>
Subject: checkpoint/restore: Adding more "Getters" to the KVM API
Message-ID: <jYlRLuV_6FcjxHyjMU6duqUMCE7tU6sS5ZZqbEmLWZCxJp3phctt1oA0n9obMkVv7fMQGXCIbwC53erkFxNI33XYvnrOpS8fY7mfUC0mu5c=@proton.me>
Feedback-ID: 64659969:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi lists,

(Re-sending as plain text.)

We are in the process of using an external tool (CRIU) to checkpoint/restor=
e a KVM-enabled virtual machine. Initially we target the hypervisor kvmtool=
 but the extension, if done well, should allow to checkpoint any hypervisor=
: like Qemu or firecracker.

CRIU can checkpoint and restore most of the application (or the VMM in our =
case) state except the state of the kernel module KVM. To overcome this lim=
itation, we need more getters in the KVM API to extract the state of the VM=
.

One example of a missing getter is the one for the guest memory. There is a=
 KVM_SET_MEMORY API call. But there is no equivalent getter: KVM_GET_MEMORY=
.=C2=A0

Can we add such getters to the KVM API? Any idea of the difficulty? I think=
 one of the difficulties will be to get the state of the architecture-speci=
fic state of KVM: for now, we are targetting Intel x86_64 architecture (VT-=
X).

Any feedback will be appreciated.

Best Regards,
ScalingTree

