Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04B6D2D0EEC
	for <lists+kvm@lfdr.de>; Mon,  7 Dec 2020 12:26:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726628AbgLGLZ2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 7 Dec 2020 06:25:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:43656 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726110AbgLGLZ1 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 7 Dec 2020 06:25:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607340241;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=auivzVy5y6QOjO5B6onFwW2/1Tqt9pcw8PvGSGN2N6I=;
        b=Pkij+/YyV/8cz1PaXpNPsg7BK2zTqi/P0zpOmTQFulHhUnSpS3uovLH7AsGvVp1FPI2Fgb
        1XQwCZkktxOdeka/bDYg9/htbtFxTWyAnkW7lU5BiaAby6Z/+FqCJB1knP5G7yvqe7Y7mv
        TLriBJUKd0xzFy+LLwmEzxDjkqFOv40=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-28-X1OdqdOYMP2pwMF5LlJNzQ-1; Mon, 07 Dec 2020 06:23:58 -0500
X-MC-Unique: X1OdqdOYMP2pwMF5LlJNzQ-1
Received: by mail-wm1-f71.google.com with SMTP id k126so2276890wmb.0
        for <kvm@vger.kernel.org>; Mon, 07 Dec 2020 03:23:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=auivzVy5y6QOjO5B6onFwW2/1Tqt9pcw8PvGSGN2N6I=;
        b=OvF2y75UvqSJf1DlpQPafK5rNLE1jngDdPtKTtjSW4jL7JG01/qo/joKOAoRrMA1z8
         aoGC5wFtGEPXq2dMlicNAv3MmsTd5wfj3zCjPdKXx97G95nceAbeFTniydvGZgfdeCq3
         S97Ru9JtQIy6H/gKdLuo2d9ZLIcG9pX256fL9tTCtE2QloTVY+fstFwsDkoWV5v5oYzo
         tWY7icAehLcRHLwnRsOQb/yPcH9GgZp1aY6VeFsmOpRA3h0G5MBtxKq/yxIOw9L49+Jv
         MY8WMckf7ifuXzyb24OIh+UYJudlA4lltlW0ra1blaUghQdL/8qRZJLcDUFU+zbCGumh
         u+4A==
X-Gm-Message-State: AOAM5303NIOTQjg8QuJIvFNtxHHIp23dEs1N3MEKk/dOTPZtXA1aJ7mt
        1NQegliWJZfQavNYsJBU8ffHgf28hUn/NQQ5UKDkAtjOxSeldbbJ+GMB4b9+Dtu/cgxiwYqT34b
        KzyWB0AuwLr6q
X-Received: by 2002:a1c:750f:: with SMTP id o15mr17874285wmc.144.1607340237196;
        Mon, 07 Dec 2020 03:23:57 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxtEVzeEC7jhHuC2uJxrowF2KeO/P6RnnWe7mlJ0qlo0yRhGBZE6N17mpPfK6BoXPRNgR263w==
X-Received: by 2002:a1c:750f:: with SMTP id o15mr17874250wmc.144.1607340236966;
        Mon, 07 Dec 2020 03:23:56 -0800 (PST)
Received: from localhost.localdomain (101.red-88-21-206.staticip.rima-tde.net. [88.21.206.101])
        by smtp.gmail.com with ESMTPSA id 34sm14514869wrh.78.2020.12.07.03.23.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Dec 2020 03:23:56 -0800 (PST)
From:   =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>
To:     qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>, Thomas Huth <thuth@redhat.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Claudio Fontana <cfontana@suse.de>,
        Willian Rampazzo <wrampazz@redhat.com>, qemu-s390x@nongnu.org,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        xen-devel@lists.xenproject.org, Paul Durrant <paul@xen.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>
Subject: [PATCH v2 0/5] gitlab-ci: Add accelerator-specific Linux jobs
Date:   Mon,  7 Dec 2020 12:23:48 +0100
Message-Id: <20201207112353.3814480-1-philmd@redhat.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Since v1:=0D
- Documented cross_accel_build_job template (Claudio)=0D
- Only add new job for s390x (Thomas)=0D
- Do not add entry to MAINTAINERS (Daniel)=0D
- Document 'build-tcg-disabled' job is X86 + KVM=0D
- Drop the patches with negative review feedbacks=0D
=0D
Hi,=0D
=0D
I was custom to use Travis-CI for testing KVM builds on s390x/ppc=0D
with the Travis-CI jobs.=0D
=0D
During October Travis-CI became unusable for me (extremely slow,=0D
see [1]). Then my free Travis account got updated to the new=0D
"10K credit minutes allotment" [2] which I burned without reading=0D
the notification email in time (I'd burn them eventually anyway).=0D
=0D
Today Travis-CI is pointless to me. While I could pay to run my=0D
QEMU jobs, I don't think it is fair for an Open Source project to=0D
ask its forks to pay for a service.=0D
=0D
As we want forks to run some CI before contributing patches, and=0D
we have cross-build Docker images available for Linux hosts, I=0D
added some cross KVM/Xen build jobs to Gitlab-CI.=0D
=0D
Cross-building doesn't have the same coverage as native building,=0D
as we can not run the tests. But this is still useful to get link=0D
failures.=0D
=0D
Resulting pipeline:=0D
https://gitlab.com/philmd/qemu/-/pipelines/225948077=0D
=0D
Regards,=0D
=0D
Phil.=0D
=0D
[1] https://travis-ci.community/t/build-delays-for-open-source-project/1027=
2=0D
[2] https://blog.travis-ci.com/2020-11-02-travis-ci-new-billing=0D
=0D
Philippe Mathieu-Daud=C3=A9 (5):=0D
  gitlab-ci: Document 'build-tcg-disabled' is a KVM X86 job=0D
  gitlab-ci: Replace YAML anchors by extends (cross_system_build_job)=0D
  gitlab-ci: Introduce 'cross_accel_build_job' template=0D
  gitlab-ci: Add KVM s390x cross-build jobs=0D
  gitlab-ci: Add Xen cross-build jobs=0D
=0D
 .gitlab-ci.d/crossbuilds.yml | 80 ++++++++++++++++++++++++++----------=0D
 .gitlab-ci.yml               |  5 +++=0D
 2 files changed, 64 insertions(+), 21 deletions(-)=0D
=0D
-- =0D
2.26.2=0D
=0D

