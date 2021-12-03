Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09FCD466F20
	for <lists+kvm@lfdr.de>; Fri,  3 Dec 2021 02:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350116AbhLCBfi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 2 Dec 2021 20:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240087AbhLCBfi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 2 Dec 2021 20:35:38 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20392C06174A
        for <kvm@vger.kernel.org>; Thu,  2 Dec 2021 17:32:15 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id r26so2796141oiw.5
        for <kvm@vger.kernel.org>; Thu, 02 Dec 2021 17:32:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=fCZviD4JBw7RKaUDicoaAYHpPhK3JU5HeimHj44tWoo=;
        b=Q4ylpz89mqlDQUyM939g3TnkBivQ9S8q6xO8gziL8k3vmBIFKvSYfRiwVP35zF1PlT
         bpCLt0T5+z/dwScQZVlTloqnsARTXkxPX1bGXudqdK/1MV0zqpxWu24GgxCQQVMU9ntC
         6iWgjjVE7n3gRkYgEnUIjAgcBexRVVB8PPmR5DksHB39Zxm1C/cl/tbyGTrqaP1Wmhm2
         NyWL+mq6UraQldMGXEBeuTNswTP2IEG6Pz89ZwWD6fy4FF2BXmF3HFHQxt9vwY2exgtv
         4Z9BZ6niaTAwbvg+9N4mU6Rp/6UTYqDq6iW+IggXcCCMpoTZMRp2Hk0pBU1oapDxlfxW
         M9mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=fCZviD4JBw7RKaUDicoaAYHpPhK3JU5HeimHj44tWoo=;
        b=3HG2tQflk8J86GbhLsxqVOpfsLTRbBbF+Tg8R49SVE+DRV+XSCuroiVTXL41i5wd85
         qwROfyc64klnAUB7PbCZ9Z7XN4USbvVc24qaF6nPIaE/pNH0G4n4STJWUmeUPwKt/ynk
         OrG73Llz31Uw1Fnn8GWwahE+BT/2jOOBI9T7vYRDssvxm2jA5AaRCu2DNecLXwE95pZz
         L9VMOTPgkfQHBAn06WqceBGue84LzGNMLCYkBR1QoAASferQ0Ev4dDf5T2Kbg+XW7Qwx
         1z18HFZOPBh6didPzbrYwHG7mNBJ3+KZq78CbFFOJeGtPqCPamuTJ1DL6xhJJBqBRkzf
         5mLQ==
X-Gm-Message-State: AOAM5312/wcHozhgq9B7NmDJ8/btJoGtGtLaeniOhyZdLhS2pig582K2
        CGkqDOf+xY6dTRimnmSlMw0r4eRQBCoT7nuThdse2ahOsIw=
X-Google-Smtp-Source: ABdhPJyau9UHsqIWkJrZ5DHXp249yV6NgS1RSzKVehgF5zrCPrCUm9tVPT5JwCSVqSKCekjm7JmCJEZjtbkaVsbXdxY=
X-Received: by 2002:aca:acc4:: with SMTP id v187mr7194949oie.35.1638495134015;
 Thu, 02 Dec 2021 17:32:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6838:1952:0:0:0:0 with HTTP; Thu, 2 Dec 2021 17:32:13
 -0800 (PST)
From:   Makarand Sonare <makarandsonare@google.com>
Date:   Fri, 3 Dec 2021 01:32:13 +0000
Message-ID: <CA+qz5sqUKk46BcRKCyM1rdvtGL3QE7C8gDt0D7qx8_x_M8bKtQ@mail.gmail.com>
Subject: KVM patches for Hyper-V improvements
To:     Vitaly Kuznetsov <vkuznets@redhat.com>, kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hello Vitaly,
                  I am interested in knowing the exact set of KVM
patches that were added for the Nested Hyper-V scenario. Could you
please point me to them?

-- 
Thanks,
Makarand Sonare
