Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FECE77DD4B
	for <lists+kvm@lfdr.de>; Wed, 16 Aug 2023 11:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243351AbjHPJaK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Aug 2023 05:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243315AbjHPJ3i (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Aug 2023 05:29:38 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C01EA26A5;
        Wed, 16 Aug 2023 02:29:37 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 41be03b00d2f7-565403bda57so3823196a12.3;
        Wed, 16 Aug 2023 02:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692178177; x=1692782977;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6f5BYvEce/F1cmXY7W4zhFqxHtG2dJLGLUEOjfJLzZY=;
        b=HF+IrMNDNVSOh5iej+S5xx12/PM9187CQXWG3aXHq61M+u6l5dWj7qaz4m8PgXBKD9
         PyVpw+V/ym9/fL+xuXzHTY8I7JAHFqRIdyCCL5DutWRpnCk9444bsM5mBcGBnQsGfRCe
         Lt90MjcMrNTkeQkZdk5WuAmRUOPIvZSdGXrfQfkgeuWjduIBnNqK3D1Um+kexN/dHTgW
         WSgy8AXOQ+kxQ6xg+x9Cr0zZ4xXQgEO2lGt1KZhpM6nu8aEpeA9opyCDjPyk5FsCAsvE
         4r86oCjTK5MQfd7YT/3MAFORY7vXEaM3rBhLpx7WADykuST2ZO/gI0nnM8vKd5Tw1FYw
         iUFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692178177; x=1692782977;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6f5BYvEce/F1cmXY7W4zhFqxHtG2dJLGLUEOjfJLzZY=;
        b=Zxa62jQRs5MH3KpbLRhYVFTAaqLZl5Raibs1550hctE4AT4oXPkhZPr27madH0mfrt
         CN3XEvjlyGzxWB1/yaCfSbncennQG1Z1ZUR/xPScnGNl87x8qLFB8Qi7uFsc7qkYyWcb
         JhdkNhDZLmuqM+pn896RKfscLvkk6U2blT5souCz6EUujdQA1vSi5DhiqBzmkK5J6Ra3
         ab2NVWyzd77FtcsCNssKsJVaqIhO3ZYg3NnjJFQXDHaUiBfLKNN6l2phQ2cpdxlrhAql
         sStenggfZ/HXjELTLGOZAaDm7r6T9JtJ0THJ+TRtq4VpJSIHBN7o2PIwBKixyqrY53bj
         h47Q==
X-Gm-Message-State: AOJu0YwkJFL4sZ9DshxE4GLIwoMPu+XEBt/5juRXMUTJ2WcaCl9f/bON
        X6KH2cpyQsKtLoc0n2CaoHQ=
X-Google-Smtp-Source: AGHT+IFBmK5dDRcDncGF7Hzo04/buq2t1ZRCk5LF+i4ASyWRT3YWs/uPIkm+FwAGNUPD3KVU5HYWWw==
X-Received: by 2002:a05:6a21:4985:b0:13b:79dc:4538 with SMTP id ax5-20020a056a21498500b0013b79dc4538mr1428744pzc.62.1692178177115;
        Wed, 16 Aug 2023 02:29:37 -0700 (PDT)
Received: from [192.168.0.105] ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902988400b001ae0152d280sm12507835plp.193.2023.08.16.02.29.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 02:29:36 -0700 (PDT)
Message-ID: <8cc000d5-9445-d6f1-f02e-4629a4a59e0e@gmail.com>
Date:   Wed, 16 Aug 2023 16:29:32 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Roman Mamedov <rm+bko@romanrm.net>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Regressions <regressions@lists.linux.dev>,
        Linux KVM <kvm@vger.kernel.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: kvm: Windows Server 2003 VM fails to work on 6.1.44 (works fine
 on 6.1.43)
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> Hello,
> 
> I have a virtual machine running the old Windows Server 2003. On kernels 6.1.44 and 6.1.45, the QEMU VNC window stays dark, not switching to any of the guest's video modes and the VM process uses only ~64 MB of RAM of the assigned 2 GB, indefinitely. It's like the VM is paused/halted/stuck before even starting. The process can be killed successfully and then restarted again (with the same result), so it is not deadlocked in kernel or the like.
> 
> Kernel 6.1.43 works fine.
> 
> I have also tried downgrading CPU microcode from 20230808 to 20230719, but that did not help.
> 
> The CPU is AMD Ryzen 5900. I suspect some of the newly added mitigations may be the culprit?

See Bugzilla for the full thread.

Anyway, I'm adding it to regzbot as stable-specific regression:

#regzbot introduced: v6.1.43..v6.1.44 https://bugzilla.kernel.org/show_bug.cgi?id=217799
#regzbot title: Windows Server 2003 VM boot hang (only 64MB RAM allocated)

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217799
-- 
An old man doll... just what I always wanted! - Clara
