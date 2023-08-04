Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3EB770935
	for <lists+kvm@lfdr.de>; Fri,  4 Aug 2023 21:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229827AbjHDT4Z (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Aug 2023 15:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbjHDT4Y (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Aug 2023 15:56:24 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBEAE60
        for <kvm@vger.kernel.org>; Fri,  4 Aug 2023 12:56:23 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bc02bd4eafso21299195ad.1
        for <kvm@vger.kernel.org>; Fri, 04 Aug 2023 12:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=clockwork.io; s=google; t=1691178982; x=1691783782;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=18yzC8adv9d9r+TrJP/sYCyYX1o5TbNOmnh9ZbK4xbE=;
        b=Zhdub2mEbvcFSBs4xu3gYCFyhODseJCxaONqVMs56k0aRA/6bw/FimH/OvzwkaGYIn
         7OQS1dqGCZusk4JX+tXZ9smNP+MdFrnKwZeOgGksU/VPjYbVwLEnNG7hyJv/IHjEYrn0
         ZtZrygohKS26EtizV4gvMgrjKK1I8Xb5Hbi3GksGeSoaWAglo8sQ6mH6PcTDQY9WfGzN
         K1Tx8/BbRmkMndMnI9wal5/BIMaau4JEYXi4gT2vcApwpyJnvpAWYSeoc573bkLN92Au
         KGM7hD20IUu/dpSMc1dthAlHeEMAmI+UixIqxmtUHAHNZPYCLy9QEVZLa4PdkcTndqog
         Qk8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691178982; x=1691783782;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=18yzC8adv9d9r+TrJP/sYCyYX1o5TbNOmnh9ZbK4xbE=;
        b=IknYfAMVI7eRsXOWE5BvtyKVTy15a6vjwvI7TdTMwAXe6u901Kt5Dh/nWnknLTRYzm
         cDMMOLdywY9IK9/rpcgVuvwzPJEQymnM9VTFx2dSy7/kwKi9mpJe+qShBwBR6He+Kb9w
         hbEtD1pwW98iUjxhLfhOgdFJ7hkJxYf1THZi8jJDx2JeofCCY1aD/AM6g/8YpAIZ9JmI
         Y+aHXugPjIyILcMKPcvPWUDscWVvbGVNTVVSqDNM3tX2KcZ2ay4zCEMnl08UIwBoooQc
         fxRGBD29/K/soW+qUlvsRQOjV7uQ6bWxHLqgW4w/W0NM9xcAhR0Zwlow+xwBD/TJ5beg
         7SEQ==
X-Gm-Message-State: AOJu0YytQCXrUmxCsmyuwhtunrhvWhrZWChxws72RwrTLRDssYlCdFg1
        CeMUflJY/eLierMGpGL8x1xTCqi+yy0kc/zRCQ==
X-Google-Smtp-Source: AGHT+IFyOta4rHlSljMofwk2Ho043nHk+F+jUsvCXpBmuxIatUdz90HVedZKC5g74dLj0z83xPwsrw==
X-Received: by 2002:a17:902:db06:b0:1b2:1a79:147d with SMTP id m6-20020a170902db0600b001b21a79147dmr2909718plx.2.1691178982650;
        Fri, 04 Aug 2023 12:56:22 -0700 (PDT)
Received: from smtpclient.apple ([2603:3024:1825:5a00:25c7:a45e:f98c:8b1b])
        by smtp.gmail.com with ESMTPSA id ji5-20020a170903324500b001bc445e249asm2126240plb.124.2023.08.04.12.56.22
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Aug 2023 12:56:22 -0700 (PDT)
From:   Yifei Ma <yifei@clockwork.io>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Question about the KVM API KVM_VCPU_TSC_CTRL to control guest TSC
Message-Id: <ED93F288-CA91-4D4D-85C3-3482234287D7@clockwork.io>
Date:   Fri, 4 Aug 2023 12:56:11 -0700
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi KVM communication,

    I am working on TSC synchronization between host and guests.
    I found this doc =
(https://docs.kernel.org/virt/kvm/devices/vcpu.html#group-kvm-vcpu-tsc-ctr=
l), which gives some instructions of how to synchronize them. When I =
reading the KVM APIs (kernel version 6.4), I am a little confused. It =
seems to me the KVM APIs don=E2=80=99t match the instructions in the =
doc.
    The doc says "Read the KVM_VCPU_TSC_OFFSET attribute for *every =
vCPU* to record the guest TSC offset=E2=80=9D. However, the KVM API for =
getting/setting the offset is not through vCPU=E2=80=99s fd, it is =
through KVM device's fd,=20
    E.g., when I refer to the KVM selftest code, I found accessing =
TSC_OFFSET is through the =E2=80=9CKVM_SET_DEVICE_ATTR=E2=80=9D cmd, =
with args =E2=80=9CKVM_VCPU_TSC_CTRL=E2=80=9D & =
=E2=80=9CKVM_VCPU_TSC_OFFSET=E2=80=9D. It looks like the API sets the =
TSC offset on all vCPUs, instead of a single vCPU.
    Can someone help on it and give some input? Thanks a lot!

    Yifei=
