Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 055962F9A02
	for <lists+kvm@lfdr.de>; Mon, 18 Jan 2021 07:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732621AbhARGjh (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Jan 2021 01:39:37 -0500
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:54163 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729956AbhARGj3 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 18 Jan 2021 01:39:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 36CDF16A5;
        Mon, 18 Jan 2021 01:38:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 18 Jan 2021 01:38:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=DgEncLxHOwju3s3qsQovwzM5MS
        urO/+K7pT6AH/ZnM4=; b=ccWMOF063Ku6MMNGUrlAMjPF9KPsClnCmWNEv2gxFJ
        LHXYvLUKN/6/lyxJbxnhB8vkYgHY6hlFiuLDt8hVJbz0U5Y+ElqsXBXuvyiOfld+
        gzw2H3KEYEorw9Px/yJw6MZzS7xLsyGv3N/dgIq1bVCwo86/EtOuKvyJ0aoEBo0y
        hMSREwiHo9J3JRkF7H7W7uhqCxAeggDwJAL2gMfPWkBDf2ma88Nw4VQzRY9A64LG
        r0m7IrAscxNo9P4821yweTzSAG/Z7JSxju8Siwwjz/2P1zW8MIzcJVWpSXswMFSq
        QIvdVdYFncngMS7tvWYZpTCKUZwvEZs+VRZ6qe2BdwEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=DgEncLxHOwju3s3qs
        QovwzM5MSurO/+K7pT6AH/ZnM4=; b=PlOoDjisa4rhkTAeEfJ3RsmKiRi1CJp/j
        QBz6jvD79OAzrVn+kO2p38KMV0cJtt1fzw2xvkA3DrK0EcEA9UmGKVmBTT3P99ia
        SAKBpcXmpSvHJxta9BFMyk7G5h+XkteSIBf7lCI/Y90Vluq9crgHMf931GN4Hm3V
        a+/ib6owhucEoRsSqVmnZQAIqdAPKHFHwLOu6QaruBJoFU9shd6cgzdMamkNnQt+
        gO1a2Yp0C6SpWeZwqsEhV5YRDEPYZIvEN9ReQKWkDMMrFnM5zs50iOd9NEOVQh2p
        1OlK3OjyshSvqQCeg4nmL1Fgp5mzRvwFbmNzodR1IPrgeWMFjlslg==
X-ME-Sender: <xms:3CwFYPZnlIm_u1iAn_-aPsgdP0k7feH3gYh01eT1ePDpoVddwVcqIg>
    <xme:3CwFYOZjVVwEQAHZKZidXGCj53XOgBWvXU07BM_kGOEQMo_tY7PamVALyrdjWGI3q
    Hox2Aht5XmzNII2RMY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdejgdeliecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomheplfhirgiguhhnucgj
    rghnghcuoehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhmqeenucggtffrrg
    htthgvrhhnpeehgfdtkefggfetgeffgfeuuedtjeejudekveevfeevjeefgeettdefleet
    gfdvudenucffohhmrghinhepghhithhlrggsrdgtohhmnecukfhppeduudeirddvvdekrd
    ekgedrvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehjihgrgihunhdrhigrnhhgsehflhihghhorghtrdgtohhm
X-ME-Proxy: <xmx:3CwFYB-FhIvTYl22E5U7prntTbIAkVigIumpzLl1HjSL0jtlcrxk0Q>
    <xmx:3CwFYFr0fVb4rO2ztQKeuDlf9XSO8wtNSVGE0e3ErVGG_4Gc1AChIg>
    <xmx:3CwFYKqqZYhwv1Prk61mmqPA5O307gjgeFNXe6eVATbxmK9boI-DVw>
    <xmx:3SwFYObR50qMvbcydSoD8bUFcrqPLgOFZp2BrXBguJZBls6qd9lbZbW_talotIup>
Received: from strike.U-LINK.com (unknown [116.228.84.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4F4BD24005B;
        Mon, 18 Jan 2021 01:38:14 -0500 (EST)
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     qemu-devel@nongnu.org
Cc:     David Gibson <david@gibson.dropbear.id.au>, qemu-ppc@nongnu.org,
        Greg Kurz <groug@kaod.org>, Max Reitz <mreitz@redhat.com>,
        kvm@vger.kernel.org,
        =?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@redhat.com>,
        Wainer dos Santos Moschetta <wainersm@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Fam Zheng <fam@euphon.net>,
        Viktor Prutyanov <viktor.prutyanov@phystech.edu>,
        Alistair Francis <alistair@alistair23.me>,
        Thomas Huth <thuth@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        qemu-block@nongnu.org, Kevin Wolf <kwolf@redhat.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>
Subject: [PATCH v2 0/9] Alpine Linux build fix and CI pipeline
Date:   Mon, 18 Jan 2021 14:37:59 +0800
Message-Id: <20210118063808.12471-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.30.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Alpine Linux is a security-oriented, lightweight Linux distribution
based on musl libc and busybox.

It it popular among Docker guests and embedded applications.

Adding it to test against different libc.

Patches pending review at v2 are: 7, 8, 9

Tree avilable at: https://gitlab.com/FlyGoat/qemu/-/commits/alpine_linux_v2
CI All green: https://gitlab.com/FlyGoat/qemu/-/pipelines/242003288

It is known to have checkpatch complains about identation but they're
all pre-existing issues as I'm only doing string replacement. 

v2:
 - Reoreder patches (Wainer)
 - Add shadow to dockerfile (Wainer)
 - Pickup proper signal.h fix (PMM)
 - Correct clock_adjtime title (Thomas Huth)
 - Collect review tags

Jiaxun Yang (8):
  configure: Add sys/timex.h to probe clock_adjtime
  libvhost-user: Include poll.h instead of sys/poll.h
  hw/block/nand: Rename PAGE_SIZE to NAND_PAGE_SIZE
  elf2dmp: Rename PAGE_SIZE to ELF2DMP_PAGE_SIZE
  tests: Rename PAGE_SIZE definitions
  accel/kvm: avoid using predefined PAGE_SIZE
  tests/docker: Add dockerfile for Alpine Linux
  gitlab-ci: Add alpine to pipeline

Michael Forney (1):
  osdep.h: Remove <sys/signal.h> include

 configure                                 |  1 +
 meson.build                               |  1 -
 contrib/elf2dmp/addrspace.h               |  6 +-
 include/qemu/osdep.h                      |  4 --
 subprojects/libvhost-user/libvhost-user.h |  2 +-
 accel/kvm/kvm-all.c                       |  3 +
 contrib/elf2dmp/addrspace.c               |  4 +-
 contrib/elf2dmp/main.c                    | 18 +++---
 hw/block/nand.c                           | 40 ++++++-------
 tests/migration/stress.c                  | 10 ++--
 tests/qtest/libqos/malloc-pc.c            |  4 +-
 tests/qtest/libqos/malloc-spapr.c         |  4 +-
 tests/qtest/m25p80-test.c                 | 54 ++++++++---------
 tests/tcg/multiarch/system/memory.c       |  6 +-
 tests/test-xbzrle.c                       | 70 +++++++++++------------
 .gitlab-ci.d/containers.yml               |  5 ++
 .gitlab-ci.yml                            | 23 ++++++++
 tests/docker/dockerfiles/alpine.docker    | 57 ++++++++++++++++++
 18 files changed, 198 insertions(+), 114 deletions(-)
 create mode 100644 tests/docker/dockerfiles/alpine.docker

-- 
2.30.0

