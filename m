Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E5EB22CBD
	for <lists+kvm@lfdr.de>; Mon, 20 May 2019 09:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbfETHP1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 May 2019 03:15:27 -0400
Received: from 2.mo4.mail-out.ovh.net ([46.105.72.36]:40466 "EHLO
        2.mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730011AbfETHP0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 20 May 2019 03:15:26 -0400
Received: from player158.ha.ovh.net (unknown [10.109.143.24])
        by mo4.mail-out.ovh.net (Postfix) with ESMTP id 8015E1F1EB1
        for <kvm@vger.kernel.org>; Mon, 20 May 2019 09:15:24 +0200 (CEST)
Received: from kaod.org (lfbn-1-10649-41.w90-89.abo.wanadoo.fr [90.89.235.41])
        (Authenticated sender: clg@kaod.org)
        by player158.ha.ovh.net (Postfix) with ESMTPSA id 6F3B95D35F16;
        Mon, 20 May 2019 07:15:19 +0000 (UTC)
From:   =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
To:     kvm-ppc@vger.kernel.org
Cc:     Paul Mackerras <paulus@samba.org>,
        David Gibson <david@gibson.dropbear.id.au>,
        kvm@vger.kernel.org,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>
Subject: [PATCH 0/3] KVM: PPC: Book3S HV: XIVE: assorted fixes on vCPU and RAM limits
Date:   Mon, 20 May 2019 09:15:11 +0200
Message-Id: <20190520071514.9308-1-clg@kaod.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 6056215602387061719
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrgeduuddruddtjedguddvudcutefuodetggdotefrodftvfcurfhrohhfihhlvgemucfqggfjpdevjffgvefmvefgnecuuegrihhlohhuthemucehtddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello,

Here are a couple of fixes for issues in the XIVE KVM device when
testing the limits : RAM size and number of vCPUS.

Based on 5.2-rc1.

Available on GitHub:

    https://github.com/legoater/linux/commits/xive-5.2

Thanks,

C. 

Cédric Le Goater (3):
  KVM: PPC: Book3S HV: XIVE: clear file mapping when device is released
  KVM: PPC: Book3S HV: XIVE: do not test the EQ flag validity when
    reseting
  KVM: PPC: Book3S HV: XIVE: fix the enforced limit on the vCPU
    identifier

 arch/powerpc/kvm/book3s_xive_native.c | 46 ++++++++++++++++-----------
 1 file changed, 27 insertions(+), 19 deletions(-)

-- 
2.20.1

