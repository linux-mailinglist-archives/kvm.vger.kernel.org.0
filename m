Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6978630F83C
	for <lists+kvm@lfdr.de>; Thu,  4 Feb 2021 17:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236983AbhBDQl6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 4 Feb 2021 11:41:58 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:51203 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236828AbhBDO4E (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 4 Feb 2021 09:56:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612450479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ryp3p6DrRmlDDRDQgmrayD8IdcDXnf65jisZJnC4oKY=;
        b=OcHPZspHx+UZLaRSgUsH1xJL9+st3Cfoln7p5MygJgwpE5dvelcw/7mEQUm7WEuPmY0YFH
        BKoM8XuX4pBQb0CMBtYYifCsvUaPEiwY9yLA1eXvJLGIuV8s/a4iDzb4ca87NJRgqaH/bn
        WLTHjYjBPCqRrATjp9kxxuOeXdIPzp0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-vmuJiG3TMniMS0-JCckPLg-1; Thu, 04 Feb 2021 09:54:35 -0500
X-MC-Unique: vmuJiG3TMniMS0-JCckPLg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 664AB100C612;
        Thu,  4 Feb 2021 14:54:34 +0000 (UTC)
Received: from virtlab511.virt.lab.eng.bos.redhat.com (virtlab511.virt.lab.eng.bos.redhat.com [10.19.152.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1768060BE2;
        Thu,  4 Feb 2021 14:54:34 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc:     seanjc@google.com
Subject: [PATCH v2 0/2] KVM: x86: cleanups for MOV from/to DR
Date:   Thu,  4 Feb 2021 09:54:31 -0500
Message-Id: <20210204145433.243806-1-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This is the new version of the "KVM: x86: move kvm_inject_gp up from
kvm_set_dr to callers" patch.

Paolo Bonzini (2):
  KVM: x86: reading DR cannot fail
  KVM: x86: move kvm_inject_gp up from kvm_set_dr to callers

 arch/x86/include/asm/kvm_host.h |  2 +-
 arch/x86/kvm/kvm_emulate.h      |  2 +-
 arch/x86/kvm/svm/svm.c          | 13 +++++--------
 arch/x86/kvm/vmx/vmx.c          | 20 +++++++++++---------
 arch/x86/kvm/x86.c              | 28 +++++++++-------------------
 5 files changed, 27 insertions(+), 38 deletions(-)

-- 
2.26.2

