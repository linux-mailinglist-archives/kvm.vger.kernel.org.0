Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51B42182D53
	for <lists+kvm@lfdr.de>; Thu, 12 Mar 2020 11:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgCLKUa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 12 Mar 2020 06:20:30 -0400
Received: from mail-ed1-f44.google.com ([209.85.208.44]:46410 "EHLO
        mail-ed1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLKU3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 12 Mar 2020 06:20:29 -0400
Received: by mail-ed1-f44.google.com with SMTP id ca19so6684044edb.13
        for <kvm@vger.kernel.org>; Thu, 12 Mar 2020 03:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=gV8c7Buw/CuxlgEzytTMxZi05iRhJBPXMtS9tvlsmHE=;
        b=Xpm5tHXzEnfLES5GoqJwehX2nO5fd+xOs+7ogawcpAPySNyI0BfHekRR1pr6vitwjQ
         ZgoTWclzcIjeL/vSgtjewBCGZHqlQxz4BCQh/KdfDRAHkxkQght67yNqYc9Xn0Zd3Kno
         q6S+XL6A/IkUmbtxkwgMPYXGeRhArBf+OGaFrFIh12qA5dmzVvUv6RJOlLpcHwzQIzH+
         mcmSsCx7qA1VZOmUCzU2tCCWAe7+rLU/4pu41WMUgM4Tjp/CrtYlQg96PUaJ1VnvrTRJ
         lXwsu0Hdk2T4rfOucn7AcLfyLLyScGUg1ttVryIXhirSiV4NWMN1Pb+pqMfFrChKyNe7
         B0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=gV8c7Buw/CuxlgEzytTMxZi05iRhJBPXMtS9tvlsmHE=;
        b=YwMsi1c1Oeiyn6ejA2PYggd/H9lDC4RasWUgrDxFCu0E54GODQGTQkfs+rE8J0jD75
         4EJ8eMETdP5UOuv9k8v/J3lOgsQ/tenia9yxPwy9LEEgDXlTb7DoA/6dDZvnkaHQnhgo
         yOYL4+JSka+ItyI9ZGJpYbnAieJwR61K+UkvM7U416uxmrAa0bdghHcndfkdoP1b7h8k
         ru+HgH2N9CV106COI1Fo26A3g4IO2Rt3yfbm4+wf+iE6aotgf0/XmsFjwmTktFtw3djf
         xd2e8e2KFjgzKM6O/XhWKf873Jd5zRryuLfHpxJwTF7xk8hOJ6/vACw8XcKxrs94hxk6
         5IlQ==
X-Gm-Message-State: ANhLgQ3ET5UcjE2NWDqXg6tol2QXkDnKcZNGe5ynUkDF24AbgKqdI2Ul
        02wiw7jVfgSFctEdciUsb0IF0DkmAeGrUTKzfA==
X-Google-Smtp-Source: ADFU+vtiKDKBMQHjvRxkM/SC5mphVdm9wFL6DEofMM5yHdrpKoYPS2pHfmHqBog8UQ+oMoqaMz/pAV4AlM6IHlMEGGA=
X-Received: by 2002:a17:906:938e:: with SMTP id l14mr5931649ejx.374.1584008427839;
 Thu, 12 Mar 2020 03:20:27 -0700 (PDT)
MIME-Version: 1.0
From:   Haiwei Li <lihaiwei.kernel@gmail.com>
Date:   Thu, 12 Mar 2020 18:20:16 +0800
Message-ID: <CAB5KdOaiqS_nXq8_HfMH1PmjThFzmYNBcBrMnC3Utkw6-OPUfQ@mail.gmail.com>
Subject: Some warnings occur in hyperv.c.
To:     x86@kernel.org, kvm@vger.kernel.org
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>, wanpengli@tencent.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi, When i build kvm, some warnings occur. Just like:

/home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function =E2=80=98kvm_hv=
_flush_tlb=E2=80=99:
/home/kernel/data/linux/arch/x86/kvm//hyperv.c:1436:1: warning: the
frame size of 1064 bytes is larger than 1024 bytes
[-Wframe-larger-than=3D]
 }
 ^
/home/kernel/data/linux/arch/x86/kvm//hyperv.c: In function =E2=80=98kvm_hv=
_send_ipi=E2=80=99:
/home/kernel/data/linux/arch/x86/kvm//hyperv.c:1529:1: warning: the
frame size of 1112 bytes is larger than 1024 bytes
[-Wframe-larger-than=3D]
 }
 ^

Then i get the two functions in hyperv.c. Like:

static u64 kvm_hv_send_ipi(struct kvm_vcpu *current_vcpu, u64 ingpa, u64 ou=
tgpa,
                           bool ex, bool fast)
{
        struct kvm *kvm =3D current_vcpu->kvm;
        struct hv_send_ipi_ex send_ipi_ex;
        struct hv_send_ipi send_ipi;
        u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
        DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
        unsigned long *vcpu_mask;
        unsigned long valid_bank_mask;
        u64 sparse_banks[64];
        int sparse_banks_len;
        u32 vector;
        bool all_cpus;

static u64 kvm_hv_flush_tlb(struct kvm_vcpu *current_vcpu, u64 ingpa,
                            u16 rep_cnt, bool ex)
{
        struct kvm *kvm =3D current_vcpu->kvm;
        struct kvm_vcpu_hv *hv_vcpu =3D &current_vcpu->arch.hyperv;
        struct hv_tlb_flush_ex flush_ex;
        struct hv_tlb_flush flush;
        u64 vp_bitmap[KVM_HV_MAX_SPARSE_VCPU_SET_BITS];
        DECLARE_BITMAP(vcpu_bitmap, KVM_MAX_VCPUS);
        unsigned long *vcpu_mask;
        u64 valid_bank_mask;
        u64 sparse_banks[64];
        int sparse_banks_len;
        bool all_cpus;

The definition of sparse_banks for X86_64 is 512 B.  So i tried to
refactor it by
defining it for both tlb and ipi. But no preempt disable in the flow.
How can i do?

Thanks.
