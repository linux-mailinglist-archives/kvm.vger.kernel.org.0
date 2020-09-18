Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FD0270709
	for <lists+kvm@lfdr.de>; Fri, 18 Sep 2020 22:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbgIRU2A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Sep 2020 16:28:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726118AbgIRU17 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 18 Sep 2020 16:27:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600460878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=vK2g5r+C+F4wrPWuK9qYoigf2noB+00M1zfYcqFoTLg=;
        b=gt7MiWWwt1WfO7+VYpl5Jcx/64v7J9FEZ5tJMSslyrOwFNa/WSHU7XSH4MgmasD59nUtOp
        oyVKSCr5fW4pXc6aUMj8iyILmZX2SKcJ2CG4xlTAFLyxDHB7uPcLC6/qROxRcJHr2A1YEq
        YXRcX4NJT3hY+Om0QrZ5Plz4AASaoyw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-aomeyOThP8KkxZ2eXPntlQ-1; Fri, 18 Sep 2020 16:27:56 -0400
X-MC-Unique: aomeyOThP8KkxZ2eXPntlQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B372988EF19;
        Fri, 18 Sep 2020 20:27:54 +0000 (UTC)
Received: from localhost (unknown [10.10.67.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97DFD9CBA;
        Fri, 18 Sep 2020 20:27:51 +0000 (UTC)
From:   Eduardo Habkost <ehabkost@redhat.com>
To:     qemu-devel@nongnu.org, Peter Maydell <peter.maydell@linaro.org>
Cc:     Richard Henderson <rth@twiddle.net>, kvm@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        Cameron Esfahani <dirty@apple.com>,
        Eduardo Habkost <ehabkost@redhat.com>
Subject: [PULL 0/4] x86 queue, 2020-09-18
Date:   Fri, 18 Sep 2020 16:27:46 -0400
Message-Id: <20200918202750.10358-1-ehabkost@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The following changes since commit 053a4177817db307ec854356e95b5b350800a216:

  Merge remote-tracking branch 'remotes/philmd-gitlab/tags/fw_cfg-20200918' into staging (2020-09-18 16:34:26 +0100)

are available in the Git repository at:

  git://github.com/ehabkost/qemu.git tags/x86-next-pull-request

for you to fetch changes up to 31ada106d891f56f54d4234ce58c552bc2e734af:

  i386: Simplify CPUID_8000_001E for AMD (2020-09-18 13:50:31 -0400)

----------------------------------------------------------------
x86 queue, 2020-09-18

Cleanups:
* Correct the meaning of '0xffffffff' value for hv-spinlocks (Vitaly Kuznetsov)
* vmport: Drop superfluous parenthesis (Philippe Mathieu-Daudé)

Fixes:
* Use generic APIC ID encoding code for EPYC (Babu Moger)

----------------------------------------------------------------

Babu Moger (2):
  i386: Simplify CPUID_8000_001d for AMD
  i386: Simplify CPUID_8000_001E for AMD

Philippe Mathieu-Daudé (1):
  hw/i386/vmport: Drop superfluous parenthesis around function typedef

Vitaly Kuznetsov (1):
  i386/kvm: correct the meaning of '0xffffffff' value for hv-spinlocks

 docs/hyperv.txt          |   2 +-
 include/hw/i386/vmport.h |   2 +-
 target/i386/cpu.h        |   4 +-
 target/i386/cpu.c        | 228 +++++++++++----------------------------
 target/i386/kvm.c        |   4 +-
 5 files changed, 68 insertions(+), 172 deletions(-)

-- 
2.26.2

