Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2D514328A
	for <lists+kvm@lfdr.de>; Mon, 20 Jan 2020 20:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATTn0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 20 Jan 2020 14:43:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:21301 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726607AbgATTn0 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 20 Jan 2020 14:43:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579549405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9HQNrpu01ujUeqOXt7lXDMYnSe4YCnqq+ahF9f2gdqE=;
        b=Lr+tQeJTM3OTiE5N1iR5CM4iM1/wN0N4jGGmJ6oinrYNwXBHqbOapbx4Pch9nW0gFpab5C
        512MMb3L5632yJn8c7Avdv9dcJ3tUzcbdMSdMhj2Df3THBVhcvola64HexhGKhKy2OdOHg
        BG4nenRa4jIs6YrLJiXvKuTzQ10We1M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-283-sL5StgVQPq6ia0i82O1j8Q-1; Mon, 20 Jan 2020 14:43:24 -0500
X-MC-Unique: sL5StgVQPq6ia0i82O1j8Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3789C804703
        for <kvm@vger.kernel.org>; Mon, 20 Jan 2020 19:43:23 +0000 (UTC)
Received: from localhost.localdomain (ovpn-116-78.gru2.redhat.com [10.97.116.78])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3055F5C1BB;
        Mon, 20 Jan 2020 19:43:20 +0000 (UTC)
From:   Wainer dos Santos Moschetta <wainersm@redhat.com>
To:     kvm@vger.kernel.org
Cc:     pbonzini@redhat.com, drjones@redhat.com
Subject: [kvm-unit-tests v2 2/2] README: Add intro about the configuration file
Date:   Mon, 20 Jan 2020 16:43:10 -0300
Message-Id: <20200120194310.3942-3-wainersm@redhat.com>
In-Reply-To: <20200120194310.3942-1-wainersm@redhat.com>
References: <20200120194310.3942-1-wainersm@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The 'Guarding unsafe tests' section mention the unittests.cfg
file which was never introduced before. In this change
it was added a section with a few words about the tests
configuration file (unittests.cfg).

Signed-off-by: Wainer dos Santos Moschetta <wainersm@redhat.com>
---
 README.md | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/README.md b/README.md
index 367c92a..763759e 100644
--- a/README.md
+++ b/README.md
@@ -52,6 +52,17 @@ ACCEL=3Dname environment variable:
=20
     ACCEL=3Dkvm ./x86-run ./x86/msr.flat
=20
+# Tests configuration file
+
+The test case may need specific runtime configurations, for
+example, extra QEMU parameters and time to execute limited, the
+runner script reads those information from a configuration file found
+at ./ARCH/unittests.cfg.
+
+The configuration file also contain the groups (if any) each test belong
+to. So that a given group can be executed by specifying its name in the
+runner's -g option.
+
 # Unit test inputs
=20
 Unit tests use QEMU's '-append args...' parameter for command line
--=20
2.23.0

