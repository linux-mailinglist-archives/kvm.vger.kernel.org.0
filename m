Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B617F67438B
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 21:36:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjASUgv (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 15:36:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbjASUgr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 15:36:47 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A526F9D294
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:36:46 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id u2-20020a17090341c200b00192bc565119so1955677ple.16
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 12:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pgZXxu6xB/BEes7deu2wLBXk37A215LCr3P0IdqMWvA=;
        b=CXpiYlK3Tq4ZdVuhlFMCjkJlE6wMrxk8Au37HF3vSlctQPw+kpu5nPxJCPDyfQRhWT
         7r2oYvgh67qW8/nwt6koTMvYqbhDdW+5tj/Sf+Et6qxhKSxMd6Lacns/aaRVfkpmwfh7
         v/iLBQ+v2nxdvyOIKatiBjyxIIRm8W5TZ5XsntXKN5G0sfDMjWSIHcOfpiJzd/flWWfv
         wZyNss1LSSa9CH9NpnzvefplKBaI7kYrkT6yKiF8/ONND7kIz7vMESTrduFJGb0Qk5pG
         1fm1ouHGMfztC2645URPGS5E+/2LLk+vKLv0Ygekq6mO8DpLu9S/2S8T4R+2u44DzVD3
         vEhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pgZXxu6xB/BEes7deu2wLBXk37A215LCr3P0IdqMWvA=;
        b=2qgH5Fibe45HvDQHwVHEo5ZHfWjFcR/7u8s+siCfpVctRzRuhGiA8Io4fVZQJRXBt/
         T/phgl03BiKYvJ1oSMNEQxq8ZgI/D4+/z/1Uixik+ESP0j5P0F0RQffqhYRHW3Lx6ZVY
         DVgvWWJvMAhPdKTVbk5XdwsHqU/BB7FFm/4D/7GvU0mhV6C8BZaJSOQbxE4SW05uHGuJ
         NzYe91YIwdT1cNhkSnxVGwMSW3xg2uTALMJmMBOh8ay74S9QoqMT+mN/JQ1gaVcE12Ll
         o3O0TCzG2cg66lh7FdFBzxITZCE69jaieeYz2vxzKBxK7RWEAW4QWj6L6EAFtypExsbg
         rUzw==
X-Gm-Message-State: AFqh2koA/2aVflSUqdkRVLDkd2b4Ijgf+PpCbUxcdAX7NvowZu6YbJ5c
        6gdiua9gb9TzUAFlMKCzVUaDD+YPxto=
X-Google-Smtp-Source: AMrXdXuZHdODfkF+foaLMzLhhcCvRj/U9gWzaQ56sDdyJJ1cmO2Kr3nEjMRm8qS+DNlPEYq82o41J8TfSFA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:690f:b0:229:1e87:285c with SMTP id
 r15-20020a17090a690f00b002291e87285cmr1599919pjj.200.1674160606002; Thu, 19
 Jan 2023 12:36:46 -0800 (PST)
Date:   Thu, 19 Jan 2023 20:35:24 +0000
In-Reply-To: <202211231704457807160@zte.com.cn>
Mime-Version: 1.0
References: <202211231704457807160@zte.com.cn>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167408775757.2362935.3713773100695862688.b4-ty@google.com>
Subject: Re: [PATCH linux-next] KVM: x86: remove redundant ret variable
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, zhang.songyi@zte.com.cn
Cc:     pbonzini@redhat.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, 23 Nov 2022 17:04:45 +0800, zhang.songyi@zte.com.cn wrote:
> Return value from apic_get_tmcct() directly instead of taking
> this in another redundant variable.

This patch was whitespace damaged, please fix your setup.  I manually applied it
(and one other) since it's a trivial change, but I likely won't have that luxury
for future patches.

Applied to kvm-x86 apic, thanks!

[1/1] KVM: x86: remove redundant ret variable
      https://github.com/kvm-x86/linux/commit/14bd05184168

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
