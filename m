Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0930D1F7
	for <lists+kvm@lfdr.de>; Wed,  3 Feb 2021 04:11:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231862AbhBCDHP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 2 Feb 2021 22:07:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232507AbhBCDG4 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 2 Feb 2021 22:06:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB26C06178C
        for <kvm@vger.kernel.org>; Tue,  2 Feb 2021 19:06:59 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id g15so3710872pjd.2
        for <kvm@vger.kernel.org>; Tue, 02 Feb 2021 19:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20150623.gappssmtp.com; s=20150623;
        h=date:subject:in-reply-to:cc:from:to:message-id:mime-version
         :content-transfer-encoding;
        bh=WBiTH8QiguqnLOv32t9GF9mOlJTuAE6/25gykx61sYM=;
        b=M5JXY8IOoN/AO5OQf8cIeE5pJvWOwOo7jf5M5eLJ52ZDNXMRq3NNhhTha2vH5aQwYu
         foKeKzd3GaDXSQsjcskk4mTcyvW5Xw4RnTEn7rcfjhPLh07rz8ZACCAZEg2M3C1yYT59
         j+EyhqkermOi9e8CCoPGlhV0TA4qufUp+L4q6gdaZKYRZjBgmiDZsRXtJ6eyXUK/Oa6M
         nnd2e/sO+Z57GFfSYQDTPlkS4PRnhl5QF5yppnmQ880G1E77/UG7jZKGIMyTtuoECB3n
         DT2h1TAGI5KR6Ol6p7fW6qeudqA8I+4eVB/C6LbKCjWP+fEEoy/cAY2FxmNxYY/TeKC7
         AIqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:subject:in-reply-to:cc:from:to:message-id
         :mime-version:content-transfer-encoding;
        bh=WBiTH8QiguqnLOv32t9GF9mOlJTuAE6/25gykx61sYM=;
        b=DJP06szNBlSxz/7VbDBtXHXvvJ+asPasxeRK8+5Ws+HvBVtpDxYdMwnPsD+L+A8xrt
         oNORuKj7LzO5G3gVUrv+T1X1GnrPoXM70gQf5gmq/+wlj2fEzi1uLJ+5chYtY22whGvz
         yHvMHAGSsNAoNFHh7IUIGwN08YbO5zYDPLYnuq0nlCHycESCtPwlJnLuBHZHYReczRUN
         lPtKAAO+B+PxtNgqVLZEiltfrZRSqJ5OndvVu+CRbACm9UME1AuNetw1nMvEFsmwQDqK
         aVYCw1hPi8pUbSZddUnWkLe4JveaqM1e0pQgpmIaN0//lSkqaHnywg1z/ZwDKO9+OAxf
         a2pA==
X-Gm-Message-State: AOAM532ztkeng6kLY9WcvtaPq89WOUEIffYhz2kbSq/N73kkLRIKzO+g
        zwoBI6qWUu3cyFXzma1UOHD7QQ==
X-Google-Smtp-Source: ABdhPJws1V1h8N9CDU/SagO0L0jOxEHTfE1KH2PH0XV3/QmxsiTyPbjYe2LHodfb7doMmzJ71GFU7A==
X-Received: by 2002:a17:90b:618:: with SMTP id gb24mr1013574pjb.146.1612321618953;
        Tue, 02 Feb 2021 19:06:58 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id 141sm330169pfa.65.2021.02.02.19.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Feb 2021 19:06:58 -0800 (PST)
Date:   Tue, 02 Feb 2021 19:06:58 -0800 (PST)
X-Google-Original-Date: Tue, 02 Feb 2021 19:06:42 PST (-0800)
Subject:     Re: [Announcement] Successful KVM RISC-V bring up on FPGA (Rocket core with H extension)
In-Reply-To: <CAOnJCULY7PTcyZ4d0MiC6YBW3_ZdN3tVC4jg_wAJdJs_YeCnMQ@mail.gmail.com>
CC:     linux-riscv@lists.infradead.org, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org
From:   Palmer Dabbelt <palmer@dabbelt.com>
To:     atishp@atishpatra.org
Message-ID: <mhng-48f94a66-52fd-4e2d-80e8-c33bc521d0f5@penguin>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 02 Feb 2021 00:43:51 PST (-0800), atishp@atishpatra.org wrote:
> Hi,
> We are glad to announce that we are able to boot Linux in KVM guest on
> a FPGA (Rocket chip + H extension v0.6.1). We now have three
> hypervisors working on a Hardware with H extension.
>
> 1. KVM [1]
> 2. Xvisor [2]
> 3. Bao [3]
>
> KVM bring up was done using Firesim and the detailed instructions will
> be available very soon. Here are the software versions used for
> bringup. Please find the attached boot log.
>
> OpenSBI: v0.9
> Linux kernel: 5.11-rc5 + KVM patches(v16) + few kernel fixes [4].
> Kvmtool: Upstream + RISC-V KVMTOOL patches (v6) [5]
>
> We would like to thank Sandro & Jose who implemented the H extension.
> The Rocket-H design is available as an AFI image to be used within
> Firesim or a stand alone FPGA board.
>
> We would also like to thank Andrew/John/Greg & others for defining such
> a clean specification as we did not discover any significant issues
> while doing the bring up. As there are no changes proposed to the H
> extension in the last year, we believe the current version of the H
> extension can be considered as a freeze candidate. Please let us know
> if that is not the case.

Congratulations!   Hopefully we can get this thing frozen, it's been a long 
time.
