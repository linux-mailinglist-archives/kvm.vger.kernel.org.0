Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE5A5F4BBB
	for <lists+kvm@lfdr.de>; Wed,  5 Oct 2022 00:15:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbiJDWPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 4 Oct 2022 18:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230492AbiJDWPm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 4 Oct 2022 18:15:42 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E0667179
        for <kvm@vger.kernel.org>; Tue,  4 Oct 2022 15:15:41 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id f37so4755464lfv.8
        for <kvm@vger.kernel.org>; Tue, 04 Oct 2022 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=meSjc4aXT55E3rWNvcOz7x/3lORQVPvQW9FF+/V1k1s=;
        b=tB5APfaDpcFTE8yyymcGaosMmKfRq9I5Y08Pl3ACzzpqU86Wn0U4W8hc3iws5ugPjD
         oFhKYD1pGu2hzj6XgUwE4MfOa4BxS6V6dZ6sDA5KSI2NL0yzAASkoW0prkPdwZQuomqK
         wLKM7Z9luQZFt6V4+nRN2AcfoeM/pqcpekH1m8Dpv31cQnOms24cUX1sCx03fdkTIbMT
         hJ0UmjtDzDzGlN54lTLJYjfZVI0B0B+hWC0RLNBPBy/3mSqfTjBRCmVLS946Zsx+VJiJ
         88ABmPZwuyQTJA8FlpTj6Ft7gIWK82Z2jaAFrxwhSaj661pR4MUTZnaFB1jKFKOf6GFy
         fiHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=meSjc4aXT55E3rWNvcOz7x/3lORQVPvQW9FF+/V1k1s=;
        b=Bo7lyxpGqLwUzQNr+BScmxzWai2tElXctHIpinYKgBgCIts0KLlX5AgqlQAfYT2EFv
         BSdduVY967XeI8tGQd99tqKNf6R02/RNmECJDVpruogixfV7A5XKxi7nAa1yM28u7fKw
         fRpIImVP3T7BjoijqXJNxR2A/6xn6xOPbhAZmYiL0hNiE7iGT6KW+k0bO9Cyivna3BxA
         lP82sTzDMLYYb4m6YlSTj8ufCB08wZ4+jVPT6XiDt3jPtPshKAQrZKF3kZXb7ddWrHOs
         /jX55Rnpaexp7yRmZyZmCfWavygQ7tEzVg4aTeXgLwkruDM6+2Me2AkOiJ40RSCMDIf4
         j1Sg==
X-Gm-Message-State: ACrzQf1EWacnSPYga7N8SrlLUbiAwb+Nh9myYqbARuWV4ZEVH0hcsfjZ
        RcU4clgxxDNGucxlivmQn1w0UsXHGYA1wQOIh2AeJ6Uj51XdtQ==
X-Google-Smtp-Source: AMsMyM6TJlVm/cblD0jHEbHuQzYeAx/yobPlRCU2ciPh2yOXjN5yXQG2i8fqq2PT0ihS7UQdCl2BLpvXfeH3ypjPv5I=
X-Received: by 2002:ac2:5cd1:0:b0:4a2:291a:9460 with SMTP id
 f17-20020ac25cd1000000b004a2291a9460mr5358697lfq.203.1664921739203; Tue, 04
 Oct 2022 15:15:39 -0700 (PDT)
MIME-Version: 1.0
From:   Vipin Sharma <vipinsh@google.com>
Date:   Tue, 4 Oct 2022 15:15:02 -0700
Message-ID: <CAHVum0cbWBXUnJ4s32Yn=TfPXLypv_RRT6LmA_QoBHw3Y+kA7w@mail.gmail.com>
Subject: HvExtCallQueryCapabilities and HvExtCallGetBootZeroedMemory
 implementation in KVM for Windows guest
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "yury.norov@gmail.com" <yury.norov@gmail.com>,
        sunilmut@microsoft.com, tianyu.lan@microsoft.com
Cc:     KVM <kvm@vger.kernel.org>, David Matlack <dmatlack@google.com>,
        Shujun Xue <shujunxue@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Vitaly, Yury, Sunil, Tianyu

Before I work on a patch series and send it out to the KVM mailing
list, I wanted to check with you a potential Windows VM optimization
and see if you have worked on it or if you know about some obvious
known blockers regarding this feature.

Hypervisor Top-Level Functional Specification v6.0b mentions a hypercall:

    HvExtCallGetBootZeroedMemory
    Call Code = 0x8002

This hypercall can be used by Windows guest to know which pages are
already zeroed and then guest can avoid zeroing them again during the
boot, resulting in Windows VM faster boot time and less memory usage.

KVM currently doesn't implement this feature. I am thinking of
implementing it, here is a rough code flow:
1. KVM will set bit 20 in EBX of CPUID leaf 0x40000003 to let the
Windows guest know that it can use the extended hypercall interface.
2. Guest during the boot will use hypercall HvExtCallQueryCapabilities
(Call Code = 0x8001) to see which extended calls are available.
3. KVM will respond to guest that the hypercall
HvExtCallGetBootZeroedMemory is available.
4. Guest will issue the hypercall HvExtCallGetBootZeroedMemory to know
which pages are zeroed.
5. KVM or userspace VMM will respond with GPA and page count to guest.
6. Guest will skip zeroing these pages, resulting in faster boot and
less memory utilization of guest.

This seems like a very easy win for KVM to increase Windows guest boot
performance but I am not sure if I am overlooking something. If you
are aware of any potential side effects of enabling these hypercalls
or some other issue I am not thinking about please let me know,
otherwise, I can start working on this feature and send RFC patches to
the mailing list.

Thanks
Vipin
