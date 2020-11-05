Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8FD02A8498
	for <lists+kvm@lfdr.de>; Thu,  5 Nov 2020 18:15:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731677AbgKERPa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Nov 2020 12:15:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:32324 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731595AbgKERP3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 5 Nov 2020 12:15:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604596528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ZN6f9cdzyB53mwjnLkaf9hNEOsf9avkMMDM3/cvRSUU=;
        b=hkbcnv5SW0MnvTTNhagLeLa3tgKiQpn9JK61FonK+NSM1PuJBhC/3ymYTlKzlsSYj38QJn
        Tib4zZ4KkQwNTo++tzydFFLP3EICqpwFweNMOGbtSxGmoY7+jaa/zNnAe1qSG9h/YYlWN3
        +YTEobRFbXDMto+96eX0rAvKp7pc6eM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-132-m_NFKJiWP4i4i-7CuEbFow-1; Thu, 05 Nov 2020 12:15:26 -0500
X-MC-Unique: m_NFKJiWP4i4i-7CuEbFow-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5ACA5101F7A0;
        Thu,  5 Nov 2020 17:15:25 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0BECA6CE4F;
        Thu,  5 Nov 2020 17:15:24 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     yadong.qi@intel.com
Subject: [PATCH 0/2] KVM: x86: emulate wait-for-SIPI and SIPI-VMExit
Date:   Thu,  5 Nov 2020 12:15:22 -0500
Message-Id: <20201105171524.650693-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The first patch is new, the second is a rebase of Yadong's patch

Paolo Bonzini (1):
  KVM: x86: fix apic_accept_events vs check_nested_events

Yadong Qi (1):
  KVM: x86: emulate wait-for-SIPI and SIPI-VMExit

 arch/x86/include/asm/vmx.h      |  1 +
 arch/x86/include/uapi/asm/vmx.h |  2 ++
 arch/x86/kvm/lapic.c            | 30 ++++++++++++++++---
 arch/x86/kvm/vmx/nested.c       | 53 ++++++++++++++++++++++++---------
 arch/x86/kvm/vmx/vmx.c          |  2 +-
 5 files changed, 69 insertions(+), 19 deletions(-)

-- 
2.26.2

