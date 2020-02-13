Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8932315BFB5
	for <lists+kvm@lfdr.de>; Thu, 13 Feb 2020 14:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730081AbgBMNuH (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Feb 2020 08:50:07 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]:44922 "EHLO
        mail-qt1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729994AbgBMNuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Feb 2020 08:50:06 -0500
Received: by mail-qt1-f174.google.com with SMTP id k7so4367576qth.11
        for <kvm@vger.kernel.org>; Thu, 13 Feb 2020 05:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=hYWzdyVfx8Qtyuo6FsSKCev9Wngp3vI5dQBFQPr+z38=;
        b=asQduntXxoDqj4rpCaoGvHOQ1wkbE2AIP+WmNjqJd4jJ98NSHc6WIIqySVY11MhBmc
         HiFoySnWDJCxGHwvHEM9glItkO9hpTzcFtUckVvstoeeSNOAqdHXoXrg3zz00XXxdOjM
         Y5lTj22qEBaKgI2eyn4DhbDnhs2dwiB9Z2aiYqv5GWtqDVXn7aszCbsYAR0AGus8FuVo
         qQjEc87hgGcZYHnqmfOI/c+pfSsXTLkG0iRDvDqmccu2soP5bnV0VlNytNIQUpLvuerO
         k4oKTneOg6Arr1DH2cceGUoO0HzMRStdSMUfpve35PAuhJhH6EZHqU4aKC8Gf0jzcQPR
         GUSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:mime-version
         :content-transfer-encoding;
        bh=hYWzdyVfx8Qtyuo6FsSKCev9Wngp3vI5dQBFQPr+z38=;
        b=U80enEDeEkpFand31Mlbz5GWrWnk7fzoliC6FEd9T+z5+KqWDiyDVSw1G95dmEm4Zn
         ZtwX7G4y7toSGX3B5vfwmS7bV2pdQeGiOcjetrBenGXu7eNZDkcy4nrQ19ldN2pxrmQy
         St2SM5dYLhUFZp8Y4VmBM2nNImheA3CRm02NCvY9r08BrDEisDCRI299Lc1/cQRbtrl5
         LkgutE527wdBDmgUonUXgZ+GfzJHMIhowaBPX45IDj6OUn1LvH3dRSSISUOFv+544cs8
         0x2prFCw8oCctS/3+7qOIbwrRM3CF+KImVhWaQTCpUlPUL0fBlP6g6Q7gc6/ywyhOn29
         XEJQ==
X-Gm-Message-State: APjAAAVKHUnojnpFE806Sqzj7P2oB/p47qS3psdqN2NeINhMyZc/tK6P
        VJPTJrQ5v9/lwxbgPIxdWGnFUP09lvrBrQ==
X-Google-Smtp-Source: APXvYqwA+9/ZAaF2KlXuLlj8Uncda4mkIqcNiui+fb6MIQTtai11Pu7pHSfxSn6DOLXREHif/a9goA==
X-Received: by 2002:ac8:1a19:: with SMTP id v25mr24196508qtj.146.1581601805810;
        Thu, 13 Feb 2020 05:50:05 -0800 (PST)
Received: from dhcp-41-57.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c14sm1327859qkj.80.2020.02.13.05.50.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Feb 2020 05:50:05 -0800 (PST)
Message-ID: <1581601803.7365.57.camel@lca.pw>
Subject: "KVM: x86: enable -Werror" breaks W=1 compilation
From:   Qian Cai <cai@lca.pw>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     joe@perches.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 13 Feb 2020 08:50:03 -0500
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6 (3.22.6-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

People have been running W=1 to catch additional compilation warnings with an
expectation that not all of warnings will be fixed, but the linux-next commit
ead68df94d24 ("KVM: x86: enable -Werror") breaks the build for them.

arch/x86/kvm/../../../virt/kvm/kvm_main.c:663:12: error: no previous prototype
for ‘kvm_arch_post_init_vm’ [-Werror=missing-prototypes]
 int __weak kvm_arch_post_init_vm(struct kvm *kvm)
            ^~~~~~~~~~~~~~~~~~~~~
arch/x86/kvm/../../../virt/kvm/kvm_main.c:672:13: error: no previous prototype
for ‘kvm_arch_pre_destroy_vm’ [-Werror=missing-prototypes]
 void __weak kvm_arch_pre_destroy_vm(struct kvm *kvm)
