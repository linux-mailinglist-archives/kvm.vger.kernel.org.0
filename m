Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DECA18D209
	for <lists+kvm@lfdr.de>; Fri, 20 Mar 2020 15:57:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbgCTO5K (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 20 Mar 2020 10:57:10 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51162 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726954AbgCTO5K (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 20 Mar 2020 10:57:10 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 4C48A412ED;
        Fri, 20 Mar 2020 14:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-type:content-type:content-transfer-encoding:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1584716227; x=
        1586530628; bh=K6htX74C27YM3FdTGCH5YfvzLmfREUXCxRhp7ycnrhQ=; b=T
        NTdwLookb6ulI0Lfs0K8PQZ3TMSe/J8+ZetHVsENxTU0F6fHiVe5H7k2QJNXj+E7
        LWzX9uQjTOtoAW/1JE53/ZAm8e0/oxlJ+yldlq6/f2QDVZahsC5RNtGxHR2WbjxB
        6boY8Va2T+yX65WujzhkjFidGxp4aw2mTJLDnBelUo=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1jBDfE4814zS; Fri, 20 Mar 2020 17:57:07 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 20A46412E8;
        Fri, 20 Mar 2020 17:57:07 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Fri, 20
 Mar 2020 17:57:07 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Cameron Esfahani <dirty@apple.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH 0/2] Add support of hvf accel
Date:   Fri, 20 Mar 2020 17:55:39 +0300
Message-ID: <20200320145541.38578-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

HVF is a para-virtualized QEMU accelerator for macOS based on              =
                                                                           =
                        Hypervisor.framework (HVF). Hypervisor.framework is=
 a thin user-space                                                         =
                                                wrapper around Intel VT/VMX=
 that enables to run VMMs such as QEMU in                                  =
                                                                        non=
-privileged mode.                                                          =
                                                                           =
                                                                           =
                                                                           =
                                             The unit tests can be run on m=
acOS to verify completeness of the HVF                                     =
                                                                     accel =
implementation.

Roman Bolshakov (2):
  scripts/arch-run: Support testing of hvf accel
  README: Document steps to run the tests on macOS

 README.macOS.md       | 47 +++++++++++++++++++++++++++++++++++++++++++
 README.md             |  6 ++++--
 scripts/arch-run.bash | 13 ++++++++++++
 3 files changed, 64 insertions(+), 2 deletions(-)
 create mode 100644 README.macOS.md

--=20
2.24.1

