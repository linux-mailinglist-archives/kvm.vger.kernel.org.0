Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2C921D3D65
	for <lists+kvm@lfdr.de>; Thu, 14 May 2020 21:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbgENT0m (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 May 2020 15:26:42 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54063 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727805AbgENT0m (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 14 May 2020 15:26:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589484400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Ym4kZHOpu9FP2AlLtBKdZrfkBRnuiojLGkis8wXb9d0=;
        b=TrE0kS6INIWiRwkYKYNsx0GQl3gyeRlUSVbJtWT6fCfOFOWxxCRcgPO5+6gvUxDk7r06IY
        dSfDnGhAl8tD9QRe6T3ChnWsQz6UQeD7biSRERZetNFVnYHIYsn+/D1qP8aBVkJ42DsUcs
        KTqwt2Nq7IotoAovjS65uJjse4Qmqm4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-NtkrUXSwPSqMuX1UHr2xjw-1; Thu, 14 May 2020 15:26:32 -0400
X-MC-Unique: NtkrUXSwPSqMuX1UHr2xjw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B67658018A5;
        Thu, 14 May 2020 19:26:31 +0000 (UTC)
Received: from thuth.com (ovpn-112-56.ams2.redhat.com [10.36.112.56])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BD0965C254;
        Thu, 14 May 2020 19:26:28 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>
Cc:     Laurent Vivier <lvivier@redhat.com>,
        Drew Jones <drjones@redhat.com>,
        Bill Wendling <morbo@google.com>
Subject: [kvm-unit-tests PATCH 00/11] Misc fixes and CI improvements
Date:   Thu, 14 May 2020 21:26:15 +0200
Message-Id: <20200514192626.9950-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Here's a set of accumulated patches that fix the various problems with
our CI pipelines, and then update the Gitlab-CI to use Fedora 32 instead
of 30. Additionally, the new version of Clang in Fedora 32 is finally
also able to compile the kvm-unit-tests (with some small fixes included
in this series), so we can now also add a CI test with this compiler, too.

Andrew Jones (1):
  Fix out-of-tree builds

Bill Wendling (2):
  x86: use a non-negative number in shift
  x86: use inline asm to retrieve stack pointer

Mohammed Gamal (1):
  x86/access: Fix phys-bits parameter

Paolo Bonzini (1):
  x86: avoid multiply defined symbol

Thomas Huth (6):
  Fixes for the umip test
  Always compile the kvm-unit-tests with -fno-common
  Fix powerpc issue with the linker from Fedora 32
  Update the gitlab-ci to Fedora 32
  vmx_tests: Silence warning from Clang
  Compile the kvm-unit-tests also with Clang

 .gitlab-ci.yml       | 17 +++++++++++++++--
 Makefile             |  2 +-
 configure            |  8 +++-----
 lib/auxinfo.h        |  3 +--
 lib/x86/fault_test.c |  2 +-
 lib/x86/usermode.c   |  2 +-
 powerpc/flat.lds     | 19 ++++++++++++++++---
 x86/Makefile.common  |  1 +
 x86/svm_tests.c      |  2 +-
 x86/umip.c           |  6 ++++--
 x86/unittests.cfg    |  2 +-
 x86/vmx_tests.c      | 10 +++++++---
 12 files changed, 52 insertions(+), 22 deletions(-)

-- 
2.18.1

