Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1840A67474B
	for <lists+kvm@lfdr.de>; Fri, 20 Jan 2023 00:38:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230249AbjASXi2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 18:38:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbjASXiY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 18:38:24 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7BE99F065
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:38:18 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id x10-20020a170902ec8a00b001949f64986bso2143662plg.12
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 15:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ml9HXgsWlhngPnr5LLGuwB7yZz4iONvMOGsoPpn+lFs=;
        b=sRQGguvtprbdmw+e8cPYJH8/ogys3HECUlSwrzw5y4MYeybvAva39pmFs73NJfk5l6
         RJMr8/EIO3bmkz3y5PMzE7c3GNdyx/YcNjIzMbVCj7zMHMqdfMhu7G2Pa84/w18B+qgB
         gIo0trzYoAlaecwGOnEg1wmQF1crmm8IDPMqejURYCUkX2B1XqDshijYAszDNo2PDk1+
         scCsc8/34YIwuUaR96rqE95pR8oNPCG71cJcq50LnqkVAn4QkW6nGObq+pMWmgZX4r3E
         IRXxgUHVp2wRpO+MkO2p4qicjlSMjF3RnFsJtRAQm2Gk6FHtEawj4/A5diFt1Ez8zJLy
         9CAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ml9HXgsWlhngPnr5LLGuwB7yZz4iONvMOGsoPpn+lFs=;
        b=Zaee9gt8XO2LbwqPZveSxZ7O9X9vtncqUou91+hK9ztL8yJakVtWhuh0RjOx4nxVsr
         j2WTjo2QZbe+BOkLSoNU0mKmRpkXoUnxyUr2TXX+BL5/i72a0u2MQ3WO4kGszdQhN71p
         wbAbW/Vv8fJ0PUXJcKm+lFLLTQfO6Vq4zVHLHC1UGL17tL1h2vMNnOzoKTSsjch1gV2o
         KJHfOeHLjIi+zuNDopx2PKqkvY9/UV+kdJ0r6x6SyHqcnhQASResvGFjQAceyK6vw9T6
         S2qh0oMrvpKG+N/2Ln3ykF5fkZkjDMfhOSVxEmIonlYGqHfRXrSJQpRUIoVsED/7nFmD
         AXtw==
X-Gm-Message-State: AFqh2kracantQqQ3caCm2wIezM2u7rIYnyPzvhwtZQQJEQKRtOc+uYpi
        b3QSmeCfbaaphvZyI7yDzjTBqCc95Go=
X-Google-Smtp-Source: AMrXdXuNY7nE6cPrEZuTnpdSnSbNpQnHAujMZmdw0F814eGvjY4r6VbiQta65zMxBxyRuPG3p6HE3cIFUd0=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90a:d995:b0:225:eaa2:3f5d with SMTP id
 d21-20020a17090ad99500b00225eaa23f5dmr14069pjv.2.1674171497748; Thu, 19 Jan
 2023 15:38:17 -0800 (PST)
Date:   Thu, 19 Jan 2023 23:37:39 +0000
In-Reply-To: <670882aa04dbdd171b46d3b20ffab87158454616.1673689135.git.christophe.jaillet@wanadoo.fr>
Mime-Version: 1.0
References: <670882aa04dbdd171b46d3b20ffab87158454616.1673689135.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167416883797.2559854.8461573625576324226.b4-ty@google.com>
Subject: Re: [PATCH v2] KVM: x86/mmu: Use kstrtobool() instead of strtobool()
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        kvm@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Sat, 14 Jan 2023 10:39:11 +0100, Christophe JAILLET wrote:
> strtobool() is the same as kstrtobool().
> However, the latter is more used within the kernel.
> 
> In order to remove strtobool() and slightly simplify kstrtox.h, switch to
> the other function name.
> 
> While at it, include the corresponding header file (<linux/kstrtox.h>)
> 
> [...]

Applied to kvm-x86 mmu, thanks!

[1/1] KVM: x86/mmu: Use kstrtobool() instead of strtobool()
      https://github.com/kvm-x86/linux/commit/48350639019f

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
