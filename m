Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69C29674415
	for <lists+kvm@lfdr.de>; Thu, 19 Jan 2023 22:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjASVMZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 19 Jan 2023 16:12:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbjASVKk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 19 Jan 2023 16:10:40 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59A105584
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:04:50 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id d10-20020a631d4a000000b00491da16dc44so1550588pgm.16
        for <kvm@vger.kernel.org>; Thu, 19 Jan 2023 13:04:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nvmk2/jak230OqvlUzM7kqwdVz758d1LaNNIenA2q88=;
        b=RSK235oiGkX+MEF1SJf0PHRcdlBagAhddBhFeC1XNbAWK1zPQCAnV4WEPDIDboHywp
         GHCgiww11RKxAp1ZMBvRYG3y5uzqN4UT3Co0wm+5SvIlPGySY8SU5z/IWCNIf3ehnZSD
         b3hSNsy3LYIaj683uLnQBAjE1Zz0unS7+iQUaoaj1lbkFEp7D9/Krr4FCo5bIvN/tYVo
         IbL0C8qM1GSEYzg2Z3I/6pSJTgwS/oJlCAPQlzkQeSO7+asVtcO5LZKjJamsIkdTvwN5
         7hK9ZsiA9dXgB/0Jw+0netALBDs27IowRv05vRe1Jv/ZIQeBnXtXuZS5pfBXNs/gHmiG
         KVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nvmk2/jak230OqvlUzM7kqwdVz758d1LaNNIenA2q88=;
        b=BG9LFC0hTsffQLDP+VY4dCjKR9e0OdioPpK0x265k4iCBQd6BhI/rwst86N32x5DAF
         D11/yrjxC8RZqO6nacWeeXI2AaQ7DsWUXqzkK/9Ryo3Xp1ZvkEZgAg3yb7UKg7LkVfas
         udvaLOYbK60Qd703aMUk0abVtuhLe3Ux9ms2DM8o2t0V52W6UwjGfBKDBWaMm81Cbwws
         H4vyRo/9jXKoz+I4PlqkqKnku/vkpEa9u+QHELA2L7vFHcEND7VUIB1ek4UFpkorHsVr
         WgZu93ALgUqbBYI1sKauDwSWICD5y+FBNd++wXZRfGwy6xXVgHyVIYuGUy7gsMpSe3jI
         dldA==
X-Gm-Message-State: AFqh2kqiaCfJak1i5uBeEm5KtiDKPhs05pbUYrIlnd0l0z1AOQpFkVqm
        9/Hgh05u/DLLgMqPXoASzC0hfTjL0Vo=
X-Google-Smtp-Source: AMrXdXssljGqQ+0w5mOWKaeVHAG8iyFA0OE5O+uBTvzOFiovVAsGUYvmmAWnVUx41ebtO84b5X/YN8Gb2Zw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:90b:1201:b0:229:81a7:c5a2 with SMTP id
 gl1-20020a17090b120100b0022981a7c5a2mr1126674pjb.187.1674162289487; Thu, 19
 Jan 2023 13:04:49 -0800 (PST)
Date:   Thu, 19 Jan 2023 21:04:32 +0000
In-Reply-To: <20220920060210.4842-1-wangliangzz@126.com>
Mime-Version: 1.0
References: <20220920060210.4842-1-wangliangzz@126.com>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
Message-ID: <167409120474.2377579.16608951423859920496.b4-ty@google.com>
Subject: Re: [PATCH] kvm_host.h: fix spelling typo in function declaration
From:   Sean Christopherson <seanjc@google.com>
To:     Sean Christopherson <seanjc@google.com>, pbonzini@redhat.com,
        wangliangzz@126.com
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangliangzz@inspur.com
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

On Tue, 20 Sep 2022 14:02:10 +0800, wangliangzz@126.com wrote:
> Make parameters in function declaration consistent with
> those in function definition for better cscope-ability
> 
> 

Applied to kvm-x86 generic, thanks!

[1/1] kvm_host.h: fix spelling typo in function declaration
      https://github.com/kvm-x86/linux/commit/b6ca5cb72f58

--
https://github.com/kvm-x86/linux/tree/next
https://github.com/kvm-x86/linux/tree/fixes
