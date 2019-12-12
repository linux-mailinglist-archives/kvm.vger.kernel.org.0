Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35E9511C377
	for <lists+kvm@lfdr.de>; Thu, 12 Dec 2019 03:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727877AbfLLCp0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 21:45:26 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:30812 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727705AbfLLCp0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 21:45:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576118725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=kn1ymEsIwqFhOaQmJJrBrdgBfZaZLt84rJ0YsSsfEE0=;
        b=dx/UAx652RMxAdp5Py9rL9mQ4ohV7rB/ivMhZGnRn8y42gL6ifAwLoOlIXAHVHk8p5CYr2
        sdnbIZiCF3bDxzu9IlFFH1XvMN8niPAHZA8FIqlmOpvacyWCQPifKj72iwfbMZ292b6Oq5
        IPfnfvN2IOrAkTSugIyNgy4h+ey3vDU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-207-m7tiwnYoMNWSXDhCrk-rfw-1; Wed, 11 Dec 2019 21:45:24 -0500
X-MC-Unique: m7tiwnYoMNWSXDhCrk-rfw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F1F2E1800D63;
        Thu, 12 Dec 2019 02:45:22 +0000 (UTC)
Received: from localhost.localdomain.com (vpn2-54-40.bne.redhat.com [10.64.54.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 589426609A;
        Thu, 12 Dec 2019 02:45:17 +0000 (UTC)
From:   Gavin Shan <gshan@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, rkrcmar@redhat.com, paulus@ozlabs.org,
        maz@kernel.org, jhogan@kernel.org, drjones@redhat.com,
        vkuznets@redhat.com, gshan@redhat.com
Subject: [PATCH 0/3] Standardize kvm exit reason field
Date:   Thu, 12 Dec 2019 13:45:09 +1100
Message-Id: <20191212024512.39930-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Some utilities (e.g. kvm_stat) have the assumption that same filter
field "exit_reason" for kvm exit tracepoint. However, they're varied
on different architects. It can be fixed for the utilities to pick
different filter names, or standardize it to have unified name "exit_reas=
on",
The series takes the second approach, suggested by Vitaly Kuznetsov.

I'm not sure which git tree this will go, so I have one separate patch
for each architect in case they are merged to different git tree.

Gavin Shan (3):
  kvm/mips: Standardize kvm exit reason field
  kvm/powerpc: Standardize kvm exit reason field
  kvm/aarch64: Standardize kvm exit reason field

 arch/mips/kvm/trace.h          | 10 +++++-----
 arch/powerpc/kvm/trace_booke.h | 10 +++++-----
 arch/powerpc/kvm/trace_pr.h    | 10 +++++-----
 virt/kvm/arm/trace.h           | 14 ++++++++------
 4 files changed, 23 insertions(+), 21 deletions(-)

--=20
2.23.0

