Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE2815C061
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 15:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbgBMOdS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 09:33:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36026 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726780AbgBMOdS (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 09:33:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581604397;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=oGtow9nh8dtc4aTC5O2Xg5N2hKJc+xrZ4V6BZwWGSEA=;
        b=ToepIe898AY/pwiwUV13t+5hiFlsMgo8ZMZh2EwDLY1ITPuMuP4O5h1mg3iKLFd3usUyl4
        ssuH9Qt39w+LtLZjsCh3boYp+MKfVoVW7awgolSBP2dSOb4CtDGI7jZhBhTEmNjcbN17n9
        AW4lwflt1SLzJgQH/m1uDpJuKoNhBHo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-240-n9XcrUVLNd6SMX6P5o8RMg-1; Thu, 13 Feb 2020 09:33:10 -0500
X-MC-Unique: n9XcrUVLNd6SMX6P5o8RMg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D09FD1902EA0;
        Thu, 13 Feb 2020 14:33:08 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.43.2.160])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A4B475C1D6;
        Thu, 13 Feb 2020 14:33:01 +0000 (UTC)
From:   Andrew Jones <drjones@redhat.com>
To:     kvm@vger.kernel.org
Cc:     peter.maydell@linaro.org, alex.bennee@linaro.org,
        pbonzini@redhat.com, lvivier@redhat.com, thuth@redhat.com,
        david@redhat.com, frankja@linux.ibm.com, eric.auger@redhat.com
Subject: [PATCH kvm-unit-tests 0/2] runtime: Allow additional VMM parameters to be provided
Date:   Thu, 13 Feb 2020 15:32:58 +0100
Message-Id: <20200213143300.32141-1-drjones@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Occasionally users want to temporarily add additional VMM (QEMU)
parameters to all tests (run_tests.sh) or to tests executed with
$ARCH/run. With $ARCH/run it's already easy to do, just append
them to the command line, but with run_tests.sh there wasn't any
way to do it. This series provides two ways. It allows the
parameters to be appended to the $QEMU environment variable,
which is reasonable thing to expect to work, but doesn't
solve the problem of providing parameters that override what
is specified in the unittests.cfg file. So VMM_PARAMS is also
introduced, which is another environment variable just for
the additional parameters, and that variable takes care to
show up on the command line in the appropriate places, depending
on how the tests are being invoked.

Thanks,
drew


Andrew Jones (2):
  arch-run: Allow $QEMU to include parameters
  runtime: Introduce VMM_PARAMS

 README.md             |  5 +++++
 arm/run               |  4 +++-
 powerpc/run           |  4 +++-
 s390x/run             |  1 +
 scripts/arch-run.bash | 14 +++++++++++++-
 scripts/runtime.bash  |  4 +++-
 x86/run               |  4 +++-
 7 files changed, 31 insertions(+), 5 deletions(-)

--=20
2.21.1

