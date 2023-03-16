Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E65F6BD8BB
	for <lists+kvm@lfdr.de>; Thu, 16 Mar 2023 20:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbjCPTRt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Mar 2023 15:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229808AbjCPTRs (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Mar 2023 15:17:48 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19972B1EC9
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:17:47 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id o10-20020a17090ac08a00b0023f3196fa6fso1134308pjs.2
        for <kvm@vger.kernel.org>; Thu, 16 Mar 2023 12:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678994266;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TJcbWDGDY7mW2UZ8+dFYqV06yFsfykcIM5oQQgMomTE=;
        b=NXIQoi3YBWb27fNIE5+YxwwobwjsnMUlQCThLejvGIka8X9iKT1GPt141RafmdDhvJ
         Q1yQwnKxMawq65in8Dcskl0DbfPNT11jbIOrGadjZV/UCMTs/yuH812+5+U30Z66QnyT
         HkUxGY5+kGA3AtIxFr5v9jTPb9iXv6f98VnwwB+Bzm8SRrIGyFvbkfbc8/xRNJxr+bwM
         tOuADhijReGR7kTsHXr1YtDuCn8+YgJfv8fMSHPoAQtQ9TtOTWqiHUqi8w0znTR851GE
         bsNlnjrMYY9xN3gIFdMpAxSJuHJl50OBqvj5Re8bwjTuB2gF/zf+OdPk5JGRqOKVGY3u
         32og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678994266;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TJcbWDGDY7mW2UZ8+dFYqV06yFsfykcIM5oQQgMomTE=;
        b=I63EWJa4tpTO1TCdY4daco1YjcDlgyHrFLg1UL8Te76HwbYahx6cIXfhDWCouF94VH
         JZgQzg7VQPjRnBLkxfscSq55fWU+Ljmrn5NdGnY9oz9EILaHeQ6qfh3+jvhSo54zLKKU
         LI3q3jy+auUs33Q6a/R4PwfkvorcqB9h8QxvyPLCq4T/W+1VWWMp3FXO4UyskwZJS6OR
         fVs9Bg/cgN3vxl096c3XP4o8SIPvFZiCs0o/3JKDNV8zhwJ0eXeczJ9iTihSyRgI3lMA
         +QC4iY9rpTvLAKCze3JEqWQnMJiT12UEMyV/RDs0KF0ht3Nui7Hxe64hGYWgoT1xksQR
         AMKA==
X-Gm-Message-State: AO0yUKW8L3uceJX/YsapG7pFrzXCKIOcUBuHFLYGbGiA+SO4gnL6VM5p
        spR1Q8eAk03UaF75MR2EwwPQaURxxuU=
X-Google-Smtp-Source: AK7set9O/4knFRyTM8/eHnkpwXDC/N3CPpiLPCHA3JrSy8khWhbEwCudTVlbz9cm5U2vbO9zvEYs7/JAUnw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:218b:b0:625:c7de:48c1 with SMTP id
 h11-20020a056a00218b00b00625c7de48c1mr2123151pfi.4.1678994266635; Thu, 16 Mar
 2023 12:17:46 -0700 (PDT)
Date:   Thu, 16 Mar 2023 19:17:45 +0000
In-Reply-To: <0a42f824d24946ab86bcc6efa31b2863@huawei.com>
Mime-Version: 1.0
References: <0a42f824d24946ab86bcc6efa31b2863@huawei.com>
Message-ID: <ZBNrWZQhMX8AHzWM@google.com>
Subject: Re: WARNING in kvm_arch_vcpu_ioctl_run
From:   Sean Christopherson <seanjc@google.com>
To:     "zhangjianguo (A)" <zhangjianguo18@huawei.com>
Cc:     "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Renxuming <renxuming@huawei.com>,
        "Wangyuan (Ethan)" <wangyuan38@huawei.com>,
        "Ligang (J)" <stuart.li@huawei.com>,
        yuzenghui <yuzenghui@huawei.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

+LKML (lore isn't picking this up for some reason) and a real subject

On Thu, Mar 16, 2023, zhangjianguo (A) wrote:
> Hi all,
>=20
> Install the 6.3.0-rc1 kernel on the x86 server, and execute the https://s=
yzkaller.appspot.com/text?tag=3DReproC&x=3D14b34300880000 test case, the ca=
ll trace appears.
>=20
> [  +0.000028] ------------[ cut here ]------------
> [  +0.000002] WARNING: CPU: 36 PID: 73250 at arch/x86/kvm/x86.c:11060 kvm=
_arch_vcpu_ioctl_run+0x482/0x4b0 [kvm]
> [  +0.000086] Modules linked in: openvswitch nf_conncount nf_nat nf_connt=
rack nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c ebtable_filter ebtables ip6tab=
le_filter ip6_tables iptable_filter ip_tables intel_rapl_msr intel_rapl_com=
mon sb_edac x86_pkg_temp_thermal coretemp kvm_intel kvm irqbypass rapl inte=
l_cstate ixgbe ses intel_uncore mei_me enclosure pcspkr i2c_i801 mdio sunrp=
c mei intel_pch_thermal i2c_smbus joydev lpc_ich dca sg acpi_power_meter dr=
m vhost_net tun vhost fuse vhost_iotlb tap ext4 mbcache jbd2 sd_mod crct10d=
if_pclmul ipmi_si ahci crc32_pclmul crc32c_intel libahci ipmi_devintf ghash=
_clmulni_intel mpt3sas libata sha512_ssse3 ipmi_msghandler wdat_wdt raid_cl=
ass scsi_transport_sas dm_mod br_netfilter bridge stp llc nvme nvme_core t1=
0_pi crc64_rocksoft_generic crc64_rocksoft crc64 nbd
> [  +0.000077] CPU: 36 PID: 73250 Comm: run_vcpu_ioctrl Not tainted 6.3.0-=
rc1+ #2
> [  +0.000004] Hardware name: Huawei RH2288 V3/BC11HGSB0, BIOS 3.87 02/02/=
2018
> [  +0.000002] RIP: 0010:kvm_arch_vcpu_ioctl_run+0x482/0x4b0 [kvm]
> [  +0.000002] Call Trace:
> [  +0.000003]  <TASK>
> [  +0.000003]  kvm_vcpu_ioctl+0x279/0x680 [kvm]
> [  +0.000047]  ? vfs_write+0x2c8/0x3d0
> [  +0.000006]  __x64_sys_ioctl+0x8f/0xc0
> [  +0.000006]  do_syscall_64+0x3f/0x90
> [  +0.000007]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
> [  +0.000002]  </TASK>
> [  +0.000002] ---[ end trace 0000000000000000 ]---
>=20
> |        } else {
> |                WARN_ON_ONCE(vcpu->arch.pio.count);
> |                WARN_ON_ONCE(vcpu->mmio_needed);      // where the splat=
 triggered
> |        }

The splat occurs due to a longstanding (literally since KVM's inception) sh=
ortcoming
in KVM's uAPI.  On an emulated MMIO write, KVM finishes the instruction bef=
ore
exiting to userspace.  This is necessary given how KVM's uAPI works, as out=
side
of REP string instructions, KVM doesn't provide a way to restart an instruc=
tion
that partially completed before the MMIO was encountered.

For the vast majority of _emulated_ instructions, this doesn't cause proble=
ms as
there is a single memory accesses, i.e. any exceptions on the instruction w=
ill
occur _before_ the MMIO write.

What's happening here is that a PUSHA triggers an MMIO write and then runs =
past
the segment limit, resulting in a #SS after the MMIO is queued.  KVM inject=
s the
#SS (well, tries to) and thus loses track of the MMIO, but never clears mmi=
o_needed.

There's a second bug here that results in failed VM-Enter when KVM tries to=
 inject
the #SS: KVM doesn't ignore drop error code when the vCPU is in Real Mode. =
 This
too is a longstanding bug that has likely escaped notice because no real wo=
rk code
runs in Real Mode _and_ gracefully handles exceptions.

My plan, pending testing, is to suppress the MMIO write + exception scenari=
o since
the bug has been around for 15+ years without anyone noticing, let alone ca=
ring.
Fixing it properly would be a heck of a lot of complexity and code churn fo=
r no
real benefit.

And for the Real Mode exception bug, unless I'm missing something, the erro=
r code
can simply be suppressed when queueing the exception.

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 237c483b1230..b3bf3a0d74ab 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -646,6 +646,9 @@ static void kvm_multiple_exception(struct kvm_vcpu *vcp=
u,
=20
        kvm_make_request(KVM_REQ_EVENT, vcpu);
=20
+       /* Real Mode exceptions do not report error codes. */
+       has_error &=3D is_protmode(vcpu);
+
        /*
         * If the exception is destined for L2 and isn't being reinjected,
         * morph it to a VM-Exit if L1 wants to intercept the exception.  A
@@ -8883,6 +8886,8 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gp=
a_t cr2_or_gpa,
        }
=20
        if (ctxt->have_exception) {
+               WARN_ON_ONCE(vcpu->mmio_needed && !vcpu->mmio_is_write);
+               vcpu->mmio_needed =3D false;
                r =3D 1;
                inject_emulated_exception(vcpu);
        } else if (vcpu->arch.pio.count) {

