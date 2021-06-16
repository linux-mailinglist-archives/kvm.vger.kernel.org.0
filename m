Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFA083AA29A
	for <lists+kvm@lfdr.de>; Wed, 16 Jun 2021 19:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhFPRrU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Jun 2021 13:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbhFPRrT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Jun 2021 13:47:19 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAAFC061574
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 10:45:13 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id e33so2609074pgm.3
        for <kvm@vger.kernel.org>; Wed, 16 Jun 2021 10:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Yk03bFezodLyicEMs6IIQNwcwu9itLVuqYU49j8NtE8=;
        b=GJOP5+28MCLf/q9C4Xlb9ADJEY5GzKYlhetf+lkXbGt78ntNkw1u0XllyNDlUamJlF
         VpRky77ERNhTan4PVaUpePxBZUZbaqMT9vO6MwRJyPQuzUsdzJ/YNujTupQC2e0aTmP5
         lLx58Bmk9be9e2w0vxWIJX/VCE3u52Xub597oP4U7gsLiiCAAmW1x9IvbpTT1aiYUPMv
         o1v1qTOyUS6RTnLx/5Ww62+Otr1V1xRpGzEosr2ZTSRSkn+Rspe7lJUvRg7RiOHT9Z6+
         87mNpqA+lVecTwmZIL3dzKYDN+xlAE2U/iIpnPSG1VpP3N5Pfv5hQry5gOhJ8P6WdJgW
         HPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Yk03bFezodLyicEMs6IIQNwcwu9itLVuqYU49j8NtE8=;
        b=XiW/CZ/WRzfvUjmAYrjKkiRbvgjswQp/5txuyCeoEkBcf/APMpIt+5Y/1sNkFsFTze
         BkVKXI3++wsNXaUlAHFApPtU6CZQsyyvT3pF5sXyrM8kc0E2x+c+85FsUfgsmudwVQLW
         FQPZUH6rxeIoTXpfWY+ENej/R04y9+M6JTEsWp69HNi128FjqzwyrFopkHLHrZHQhDIZ
         MUKxiEe5C0T9It5l41zuwEpYSEL3HqB54moDR25y7l5hDF0FTfE7pI7RX0I0M/G3M8m4
         Qcg6HSNk8ElafmrStkVIukUwiWmu8jtISNQq4+Ard15j9AoJuy345DcEzzpLeIclBMRX
         4IBA==
X-Gm-Message-State: AOAM532Z9jvB8wGyvwConzxTHTigEd4PWKw2Raj0+kmjPowyoOdvm4dp
        OibuTfD/ggXxLnPaLc84PFQ=
X-Google-Smtp-Source: ABdhPJzcyBWfe84QuQ4ASRs4duPuqmeyb39M7fxcnH0SLoBSFOVh76to0gpISbs+eoZEAk97ulrMOQ==
X-Received: by 2002:a63:180c:: with SMTP id y12mr794586pgl.180.1623865512556;
        Wed, 16 Jun 2021 10:45:12 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id o12sm2722061pgq.83.2021.06.16.10.45.11
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 16 Jun 2021 10:45:12 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.100.0.2.22\))
Subject: Re: [PATCH v3 0/2] Wrap EFL binaries into ISO images
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20210613124724.1850051-1-yi.sun@intel.com>
Date:   Wed, 16 Jun 2021 10:45:10 -0700
Cc:     kvm@vger.kernel.org, gordon.jin@intel.com
Content-Transfer-Encoding: 7bit
Message-Id: <068C06EE-8479-4DF1-BD38-D3621CD7809A@gmail.com>
References: <20210613124724.1850051-1-yi.sun@intel.com>
To:     Yi Sun <yi.sun@intel.com>
X-Mailer: Apple Mail (2.3654.100.0.2.22)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Jun 13, 2021, at 5:47 AM, Yi Sun <yi.sun@intel.com> wrote:
> 
> This patch set make use of tool 'grub-mkrescue' to wrap ELF binaries 
> into bootable ISO images.
> 
> Cases in kvm-unit-tests can be run with QEMU. But the problem is that
> some newer VMMs such as Crosvm/Cloud-hyperviosr does NOT support 
> multiboot protocol with which QEMU loads and executes those testing 
> binaries correctly. This patch set can wrap each kvm-unit-tests EFL 
> binaries into a bootable ISO image aiming to adapt it to more usage 
> scenarios. As we know, all PC BIOSes and vBIOSes know how to boot 
> from a ISO from CD-ROM drive, hence it can extend the KVM-unit-tests 
> a lot.
> 
> The patch set provides two approaches to create ISO. One is via 
> "make iso". It wrap each ELF in foler x86 into a ISO without any 
> parameters passed to the test cases.  The other is via script 
> create_iso.sh. The script wraps the ELF according to the configure
> file unittests.cfg which descripes various parameters for each testing.
> 
> Patch History:
> V1: Initial version.
> V2: Add the second parament to the script create_iso.sh, that could 
> pass environment variables into test cases via the file.
> V3: Add some failure handle.

Thanks for doing that. I find your work very useful (at least for me).

For what it worth in kvm-unit-tests, I should have gave before:

Tested-by: Nadav Amit <nadav.amit@gmail.com>


Thanks,
Nadav
