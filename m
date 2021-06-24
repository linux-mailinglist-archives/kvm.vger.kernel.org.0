Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 586A63B3564
	for <lists+kvm@lfdr.de>; Thu, 24 Jun 2021 20:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFXSQV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 24 Jun 2021 14:16:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:57744 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232397AbhFXSQU (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 24 Jun 2021 14:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624558441;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=VR9PUnGp4b6JJVTcXaW0aKG4pQaXLGBRGVmZc91YcFY=;
        b=MHIWVHQnkkugBRhPz6nadf7Yai9/JbY3JJlR9ANsv58IzLplpi/n8MxcnOgixsTjLcQIt6
        yLKkH0k5IXGuvQLrxpm2w6dbLwv7Y2p7tg+YYT8UHEMh7vilPs7Jn3bAgoGUBuCmsWdv2i
        wOepdDgSDIACk1TqIAfnYWcLpKCaU60=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-487-rCKKMDBOPg-EaHnGHYKAYw-1; Thu, 24 Jun 2021 14:13:59 -0400
X-MC-Unique: rCKKMDBOPg-EaHnGHYKAYw-1
Received: by mail-qv1-f70.google.com with SMTP id k12-20020a0cfd6c0000b029020df9543019so7860429qvs.14
        for <kvm@vger.kernel.org>; Thu, 24 Jun 2021 11:13:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VR9PUnGp4b6JJVTcXaW0aKG4pQaXLGBRGVmZc91YcFY=;
        b=KVqdjx8hDsRDiIRpUQAboIkq1LEn/QwDtwkrad952aWSzW18U0a9F/Yi/zWfLRJWVN
         CuiKxhw0MDhP1rdDulUR96VQbUGNgjIGRN8Sd1HzfpieyE+IXOFlQCF652rhiyZ9mh8m
         tdVS5JZ7GcKcC4J2DOkMMjsj+Lmcx/Ld7/0QmupRwrjfbDSUjVHntnI+UQCOloqcdqWK
         vTpgA5b9piFzv/YXbzLgbfMlRL2uW/V0jauGavT6EXKAv9ygBQtsQqTq/88CZ62FQPO2
         lMntTiEEm5nBTgrBsMMC88gzgoE8sO9MP8SiPE1Zi0FgSV9wIDjahv9/jY2OkD6ejgla
         eEZg==
X-Gm-Message-State: AOAM53272/1dClM/wqiPf3o6Cgve1M9YBbW7gLjTWoU/RMzliRR98HRc
        QmwCnopthNGjpJGWVUhBBwFO+9Z91vsZlhWOBbyyFzJ90C7CvVqGS3/g37MFrCiWGgqqaiJP/SD
        UNlbMOqxiLPVHYecK+JknGkzfnJjL7KbsI2p5DZI2+OxSth2Jmba5k9nMzAgAHQ==
X-Received: by 2002:ac8:5a52:: with SMTP id o18mr5923670qta.1.1624558438939;
        Thu, 24 Jun 2021 11:13:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwF6dR5JeRO/Eva1Q6mZPKqbjXTVReFbi2rg3h+UCplMmO9tvIFJA0EON78r3W/UEKeuJYahw==
X-Received: by 2002:ac8:5a52:: with SMTP id o18mr5923636qta.1.1624558438571;
        Thu, 24 Jun 2021 11:13:58 -0700 (PDT)
Received: from t490s.redhat.com (bras-base-toroon474qw-grc-65-184-144-111-238.dsl.bell.ca. [184.144.111.238])
        by smtp.gmail.com with ESMTPSA id b7sm2529301qti.21.2021.06.24.11.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 11:13:58 -0700 (PDT)
From:   Peter Xu <peterx@redhat.com>
To:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Maxim Levitsky <mlevitsk@redhat.com>, peterx@redhat.com,
        Sean Christopherson <seanjc@google.com>
Subject: [PATCH 0/9] KVM: X86: Some light optimizations on rmap logic
Date:   Thu, 24 Jun 2021 14:13:47 -0400
Message-Id: <20210624181356.10235-1-peterx@redhat.com>
X-Mailer: git-send-email 2.31.1
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

(This is still based on a random 5.13-rc3-ish branch, but I can rebase if n=
eeded)=0D
=0D
All things started from patch 1, which introduced a new statistic to keep "=
max=0D
rmap entry count per vm".  At that time I was just curious about how many r=
map=0D
is there normally for a guest, and it surprised me a bit.=0D
=0D
For TDP mappings it's all fine as mostly rmap of a page is either 0 or 1=0D
depending on faulted or not.  It turns out with EPT=3DN there seems to be a=
 huge=0D
number of pages that can have tens or hundreds of rmap entries even for an =
idle=0D
guest.  Then I continued with the rest.=0D
=0D
To understand better on "how much of those pages", I did patch 2-6 which=0D
introduced the idea of per-arch per-vm debugfs nodes, and added a debug fil=
e to=0D
do statistics for rmap, which is similar to kvm_arch_create_vcpu_debugfs() =
but=0D
for vm not vcpu.=0D
=0D
I did notice this should be the clean approach as I also see other archs=0D
randomly create some per-vm debugfs nodes there:=0D
=0D
---8<---=0D
*** arch/arm64/kvm/vgic/vgic-debug.c:=0D
vgic_debug_init[274]           debugfs_create_file("vgic-state", 0444, kvm-=
>debugfs_dentry, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_64_mmu_hv.c:=0D
kvmppc_mmu_debugfs_init[2115]  debugfs_create_file("htab", 0400, kvm->arch.=
debugfs_dir, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_64_mmu_radix.c:=0D
kvmhv_radix_debugfs_init[1434] debugfs_create_file("radix", 0400, kvm->arch=
.debugfs_dir, kvm,=0D
=0D
*** arch/powerpc/kvm/book3s_hv.c:=0D
debugfs_vcpu_init[2395]        debugfs_create_file("timings", 0444, vcpu->a=
rch.debugfs_dir, vcpu,=0D
=0D
*** arch/powerpc/kvm/book3s_xics.c:=0D
xics_debugfs_init[1027]        xics->dentry =3D debugfs_create_file(name, 0=
444, powerpc_debugfs_root,=0D
=0D
*** arch/powerpc/kvm/book3s_xive.c:=0D
xive_debugfs_init[2236]        xive->dentry =3D debugfs_create_file(name, S=
_IRUGO, powerpc_debugfs_root,=0D
=0D
*** arch/powerpc/kvm/timing.c:=0D
kvmppc_create_vcpu_debugfs[214] debugfs_file =3D debugfs_create_file(dbg_fn=
ame, 0666, kvm_debugfs_dir,=0D
---8<---=0D
=0D
PPC even has its own per-vm dir for that.  I think if patch 2-6 can be=0D
considered to be accepted then the next thing to consider is to merge all t=
hese=0D
usages to be under the same existing per-vm dentry with their per-arch hook=
s=0D
introduced.=0D
=0D
The last 3 patches (patch 7-9) are a few optimizations of existing rmap log=
ic.=0D
The major test case I used is rmap_fork [1], however it's not really the id=
eal=0D
one to show their effect for sure as that test I wrote covers both=0D
rmap_add/remove, while I don't have good idea on optimizing rmap_remove wit=
hout=0D
changing the array structure or adding much overhead (e.g. sort the array, =
or=0D
making a tree-like structure somehow to replace the array list).  However i=
t=0D
already shows some benefit with those changes, so I post them out.=0D
=0D
Applying patch 7-8 will bring a summary of 38% perf boost when I fork 500=0D
childs with the test I used.  Didn't run perf test on patch 9.  More in the=
=0D
commit log.=0D
=0D
Please review, thanks.=0D
=0D
[1] https://github.com/xzpeter/clibs/commit/825436f825453de2ea5aaee4bdb1c92=
281efe5b3=0D
=0D
Peter Xu (9):=0D
  KVM: X86: Add per-vm stat for max rmap list size=0D
  KVM: Introduce kvm_get_kvm_safe()=0D
  KVM: Allow to have arch-specific per-vm debugfs files=0D
  KVM: X86: Introduce pte_list_count() helper=0D
  KVM: X86: Introduce kvm_mmu_slot_lpages() helpers=0D
  KVM: X86: Introduce mmu_rmaps_stat per-vm debugfs file=0D
  KVM: X86: MMU: Tune PTE_LIST_EXT to be bigger=0D
  KVM: X86: Optimize pte_list_desc with per-array counter=0D
  KVM: X86: Optimize zapping rmap=0D
=0D
 arch/x86/include/asm/kvm_host.h |   1 +=0D
 arch/x86/kvm/mmu/mmu.c          |  90 +++++++++++++++++-----=0D
 arch/x86/kvm/mmu/mmu_internal.h |   1 +=0D
 arch/x86/kvm/x86.c              | 131 +++++++++++++++++++++++++++++++-=0D
 include/linux/kvm_host.h        |   2 +=0D
 virt/kvm/kvm_main.c             |  36 +++++++--=0D
 6 files changed, 233 insertions(+), 28 deletions(-)=0D
=0D
-- =0D
2.31.1=0D
=0D

