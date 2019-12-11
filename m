Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4649A11A7A0
	for <lists+kvm@lfdr.de>; Wed, 11 Dec 2019 10:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728520AbfLKJm3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Dec 2019 04:42:29 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54718 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728447AbfLKJm3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Wed, 11 Dec 2019 04:42:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576057348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=yeeGoXVN9EsciEofZA0hvU6BC3U1cgy/S61t4Mc9KT4=;
        b=EY03U9PHL+4XaUa0PDlXCvbQQRONJcWopVRT/v7Lwo+T73QDoRq6CPZc0kjg+cum68vdB9
        Ignwj9zNr1/V/vGUJ/l9vxYVjZT/Ayw/tRaW0UqZdKX/yL166uXJW2GwB6ynWs0LLaGzgq
        2BuEWWpFGt6LKtTt8D8+DRSNY01jzXQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-3iJghz3zOa2j2L5H8YZ-TA-1; Wed, 11 Dec 2019 04:42:27 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BCBA107BA98
        for <kvm@vger.kernel.org>; Wed, 11 Dec 2019 09:42:26 +0000 (UTC)
Received: from thuth.com (ovpn-117-11.ams2.redhat.com [10.36.117.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 06CA16364A;
        Wed, 11 Dec 2019 09:42:24 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Cc:     Drew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 0/4] Improvements for the x86 tests
Date:   Wed, 11 Dec 2019 10:42:17 +0100
Message-Id: <20191211094221.7030-1-thuth@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 3iJghz3zOa2j2L5H8YZ-TA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

QEMU recently changed the error message that it prints out when a
kernel could not be loaded, so we have to adjust our script in
kvm-unit-tests accordingly.
Once this is fixed, add two missing tests (setjmp and cmpxchg8b) to
the unittests.cfg and CI pipelines.

Thomas Huth (4):
  scripts: Fix premature_failure() check with newer versions of QEMU
  x86: Fix coding style in setjmp.c
  x86: Add the setjmp test to the CI
  x86: Add the cmpxchg8b test to the CI

 .gitlab-ci.yml       |  4 ++--
 .travis.yml          |  6 +++---
 scripts/runtime.bash |  2 +-
 x86/setjmp.c         | 22 ++++++++++------------
 x86/unittests.cfg    |  7 +++++++
 5 files changed, 23 insertions(+), 18 deletions(-)

--=20
2.18.1

