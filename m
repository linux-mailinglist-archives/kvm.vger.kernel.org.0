Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 73A742C7DC
	for <lists+kvm@lfdr.de>; Tue, 28 May 2019 15:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfE1NhM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 May 2019 09:37:12 -0400
Received: from 2.mo177.mail-out.ovh.net ([178.33.109.80]:56996 "EHLO
        2.mo177.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbfE1NhM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 May 2019 09:37:12 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 May 2019 09:37:11 EDT
Received: from player692.ha.ovh.net (unknown [10.108.35.59])
        by mo177.mail-out.ovh.net (Postfix) with ESMTP id BFC7BF9DDA
        for <kvm@vger.kernel.org>; Tue, 28 May 2019 14:17:28 +0200 (CEST)
Received: from kaod.org (deibp9eh1--blueice1n4.emea.ibm.com [195.212.29.166])
        (Authenticated sender: clg@kaod.org)
        by player692.ha.ovh.net (Postfix) with ESMTPSA id 5CF0263FC174;
        Tue, 28 May 2019 12:17:21 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     Paul Mackerras <paulus@samba.org>
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>,
        David Gibson <david@gibson.dropbear.id.au>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        kvm-ppc@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH 0/2] KVM: PPC: Book3S HV: XIVE: fixes for the KVM devices 
Date:   Tue, 28 May 2019 14:17:14 +0200
Message-Id: <20190528121716.18419-1-clg@kaod.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 2798987168892029812
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedghedtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuqfggjfdpvefjgfevmfevgfenuceurghilhhouhhtmecuhedttdenucesvcftvggtihhpihgvnhhtshculddquddttddm
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

First patch fixes a host crash in PCI passthrough when using the
XICS-on-XIVE or the XIVE native KVM device. Second patch fixes locking
in code accessing the KVM memslots.

Thanks,

C.

Cédric Le Goater (2):
  KVM: PPC: Book3S HV: XIVE: do not clear IRQ data of passthrough
    interrupts
  KVM: PPC: Book3S HV: XIVE: take the srcu read lock when accessing
    memslots

 arch/powerpc/kvm/book3s_xive.c        | 4 ++--
 arch/powerpc/kvm/book3s_xive_native.c | 8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

-- 
2.21.0

