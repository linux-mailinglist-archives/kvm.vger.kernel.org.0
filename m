Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8653C743E
	for <lists+kvm@lfdr.de>; Tue, 13 Jul 2021 18:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhGMQWD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 13 Jul 2021 12:22:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33879 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229445AbhGMQWC (ORCPT
        <rfc822;kvm@vger.kernel.org>); Tue, 13 Jul 2021 12:22:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626193152;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=IKVqomoT0+BX/LOE4TAY66OOA7ax5nwI7YQz3iP8naI=;
        b=H0if5XFUt7zRfq22u0iGGaYeNvpYMzs3LjlzZxO6lTIC5PK8Tmis2q3eIENZF6chiVSmuN
        8lUh4FLpPGISPvhidNAWU9xTvfBEmUOc6nvEXG2RMSmTGRdTuWcTiFtKey+wbjUbYbaRID
        qeRRV/VsL/bzKzThp+GMD1hsQHO7e+Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-319-F77P_d2pPHCDuI2aVeBIcg-1; Tue, 13 Jul 2021 12:19:11 -0400
X-MC-Unique: F77P_d2pPHCDuI2aVeBIcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A82F680006E;
        Tue, 13 Jul 2021 16:19:09 +0000 (UTC)
Received: from localhost (ovpn-113-28.rdu2.redhat.com [10.10.113.28])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6518B60C05;
        Tue, 13 Jul 2021 16:19:09 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Eduardo Habkost <ehabkost@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>
Subject: [PULL 00/11] x86 queue, 2021-07-13
Date:   Tue, 13 Jul 2021 12:09:46 -0400
Message-Id: <20210713160957.3269017-1-ehabkost@redhat.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Sorry for submitting this so late.  I had to deal with build=0D
issues caused by other patches (now removed from the queue).=0D
=0D
The following changes since commit eca73713358f7abb18f15c026ff4267b51746992=
:=0D
=0D
  Merge remote-tracking branch 'remotes/philmd/tags/sdmmc-20210712' into st=
aging (2021-07-12 21:22:27 +0100)=0D
=0D
are available in the Git repository at:=0D
=0D
  https://gitlab.com/ehabkost/qemu.git tags/x86-next-pull-request=0D
=0D
for you to fetch changes up to 294aa0437b7f6a3e94653ef661310ef621859c87:=0D
=0D
  numa: Parse initiator=3D attribute before cpus=3D attribute (2021-07-13 0=
9:21:01 -0400)=0D
=0D
----------------------------------------------------------------=0D
x86 queue, 2021-07-13=0D
=0D
Bug fixes:=0D
* numa: Parse initiator=3D attribute before cpus=3D attribute=0D
  (Michal Privoznik)=0D
* Fix CPUID level for AMD (Zhenwei Pi)=0D
* Suppress CPUID leaves not defined by the CPU vendor=0D
  (Michael Roth)=0D
=0D
Cleanup:=0D
* Hyper-V feature handling cleanup (Vitaly Kuznetsov)=0D
=0D
----------------------------------------------------------------=0D
=0D
Michael Roth (1):=0D
  target/i386: suppress CPUID leaves not defined by the CPU vendor=0D
=0D
Michal Privoznik (2):=0D
  numa: Report expected initiator=0D
  numa: Parse initiator=3D attribute before cpus=3D attribute=0D
=0D
Vitaly Kuznetsov (7):=0D
  i386: clarify 'hv-passthrough' behavior=0D
  i386: hardcode supported eVMCS version to '1'=0D
  i386: make hyperv_expand_features() return bool=0D
  i386: expand Hyper-V features during CPU feature expansion time=0D
  i386: kill off hv_cpuid_check_and_set()=0D
  i386: HV_HYPERCALL_AVAILABLE privilege bit is always needed=0D
  i386: Hyper-V SynIC requires POST_MESSAGES/SIGNAL_EVENTS privileges=0D
=0D
Zhenwei Pi (1):=0D
  target/i386: Fix cpuid level for AMD=0D
=0D
 hw/core/machine.c              |   3 +-=0D
 hw/core/numa.c                 |  45 ++++----=0D
 target/i386/cpu.h              |   3 +=0D
 target/i386/kvm/hyperv-proto.h |   6 ++=0D
 target/i386/kvm/kvm_i386.h     |   1 +=0D
 docs/hyperv.txt                |   9 +-=0D
 hw/i386/pc.c                   |   1 +=0D
 target/i386/cpu.c              |  21 +++-=0D
 target/i386/kvm/kvm-stub.c     |   5 +=0D
 target/i386/kvm/kvm.c          | 189 ++++++++++++++++++---------------=0D
 10 files changed, 172 insertions(+), 111 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

