Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3FA67D5992
	for <lists+kvm@lfdr.de>; Tue, 24 Oct 2023 19:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344067AbjJXRPn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Oct 2023 13:15:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234850AbjJXRPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Oct 2023 13:15:42 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442EE12C
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:15:40 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-6be1bc5aa1cso4551864b3a.3
        for <kvm@vger.kernel.org>; Tue, 24 Oct 2023 10:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=clockwork.io; s=google; t=1698167739; x=1698772539; darn=vger.kernel.org;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=dppvRuLoTWx39XZIBf6OmKaoFgssjVwdslbWLos9tmw=;
        b=Rd3fa62r54lvcsLSVsIhmHrA97UQ7jXwNeQlATYW0b7GWQp7Qq8YaBlU55/5wr1HHw
         CBdS1lLZToz/6xU8LXvxe2EgdcgXUvk86yGtWpFuZG6yy+wsWyzjkwW6cvKZXHFahjm6
         t5hfw729LG1LzaG10mkW7iQmaB6eAwuqH72mY9cVSDHdhptAgkix0cvXxpk3BUajbTHj
         aR3w7nENWNkhk9kj/AtkKrMaa2fvo736wuiv+POoB6VsQm1fIf+S/cBPlybE/yvAjZSK
         74+58TtEKlJTwwX2JnBSY/LbMDuzjU3al8kKMLEsRigNTOyimvRU/3NBT0rvVEwxqSOM
         41Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698167739; x=1698772539;
        h=to:date:message-id:subject:mime-version:content-transfer-encoding
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dppvRuLoTWx39XZIBf6OmKaoFgssjVwdslbWLos9tmw=;
        b=kwwj9aLPuMEn4i8o4Vf+3fRl2gdUK7pmSaStrpuNLHqMwJ1S+pGDSuCcbIRqCtEUry
         pJ9HutEfvUsl+noIT6HtFM8TWIerW+mYhHratH7QlVELzg5ZPIUJE1Iq6lDGTdy8qShU
         D7bVSmwdxxLF31d4zfM0IwWXSkY2YP6W4b6l1B7VV4rcvQRLuLFjXgkCNohuzz3yQHYR
         3zGNQccmfVCSsmPxgzGc0gJNV7p1NNedUffOyUlwVIzIU6JW+jRHwzulKDG2X7H26Onx
         lL9DrHol9ccN8dPs8YYURpOBvA+P1OdNXxmQ1y2VFyz8TnANb1z5vUclpZVDgEB/+Nyv
         GGKw==
X-Gm-Message-State: AOJu0Ywh17oq6YlS4/ANELMBHMtU8PafDBznoaXIZrrB5mio3Gs6ap2K
        3bSv/Lnw0JB+YcW6AU0FwAOUA7tEHPtebB8cKh5x
X-Google-Smtp-Source: AGHT+IGMdVASqPzYid8ZMXkHHlC7kIWPyz6XJKHX65rsxhgMoifhiupeXKNuXAPXjWsQpeGIMMZbxQ==
X-Received: by 2002:a05:6a20:3d20:b0:15c:cb69:8e64 with SMTP id y32-20020a056a203d2000b0015ccb698e64mr3619793pzi.25.1698167739478;
        Tue, 24 Oct 2023 10:15:39 -0700 (PDT)
Received: from smtpclient.apple ([2603:3024:1825:5a00:f0a6:86a2:9501:1613])
        by smtp.gmail.com with ESMTPSA id c187-20020a6335c4000000b005776446f7cbsm7309348pga.66.2023.10.24.10.15.38
        for <kvm@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Oct 2023 10:15:39 -0700 (PDT)
From:   Yifei Ma <yifei@clockwork.io>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.200.110.1.12\))
Subject: Questions about TSC virtualization in KVM
Message-Id: <594A322A-8100-429A-A3E8-64362E3ED5A2@clockwork.io>
Date:   Tue, 24 Oct 2023 10:15:26 -0700
To:     kvm@vger.kernel.org
X-Mailer: Apple Mail (2.3731.200.110.1.12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi KVM community,

   I am trying to figure out how TSC is virtualized in KVM-VMX world.
   According to the kernel documentation, reading TSC register through =
MSR can be trapped into KVM and VMX. I am trying to figure out the KVM =
code handing this trap.
   In order to understand it, I have run a kernel traced by GDB, and =
added break points to the code I thought they may handle the MSR trap, =
e.g., kvm_get_msr, vmx_exec_control, etc. Then ran rdtsc from guest =
application, however, it  didn=E2=80=99t trigger these breakpoints. I am =
a little lost in how TSC is virtualized.
   Two questions:
   - does the TSC MRS instructions are emulated and trapped into KVM?
   - if TSC is trapped, which code handles it?

Any background about TSC virtualization and suggestions on tracing its =
virtualization are appreciated.

Thank you,

Yifei=
