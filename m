Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690CD4BC53C
	for <lists+kvm@lfdr.de>; Sat, 19 Feb 2022 04:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiBSDXS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 18 Feb 2022 22:23:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbiBSDXR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 18 Feb 2022 22:23:17 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE775418B
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 19:22:59 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id w4so12058488vsq.1
        for <kvm@vger.kernel.org>; Fri, 18 Feb 2022 19:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qjYa/2NkGCm4gmPOmla0FkCh+CgKJrjMOVp02V6Ou2s=;
        b=LpAvbqmpycOC+7dXewxhz88wQm27FF4fyJVlzlmi5syeuW2ygmrn+RmjrZQG6li19I
         VH4XCxsEWeZREYLWR2+/tLxasj3Y3IlD4Ge39WrWIgkNDitmwpcJLlMEchVlbKDi8b+2
         SuypNCtIp7hFEuX3oGPw3IZvwsGKW/dKoGjIJ7wjNAwaPQZ/IZnKQvxMm66vTx+KQEgN
         NEVhjDK3RoRYdY6mzz32f1W/QKV0ezyIn8YJaRin78A5ejW0tSHZ8SefVQu5WCQLv6N6
         52kr/gy25s/VXf9GUyfYeb5sH9qmHmzwX7rV9HiaDu/dV8ZTA6NUXIE4fUurAmQtjJOC
         4ryg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=qjYa/2NkGCm4gmPOmla0FkCh+CgKJrjMOVp02V6Ou2s=;
        b=TWzM5DRvFRbHzMmH2CWO+iwr5pYByKsFyXkyiAXvQHaIPuHQW0K60aoYWaxl8H4s0c
         /bBM7sBDZvDJIdyZin1eA0WUcuzyEhYQkixdLh//yOlD/0haO0KAXJl+sebas4YjiUjf
         3tj1hf7gnE2L5Tg5Zu4b2Rcic/qsAVpEHof3/fkY2U3TkgKizsPEOunhd2ah+CDQoJRk
         rOC5mGlnUyzrAL2wfaIPJ4IKXCyBzMCqOeS8y/2I1dctDrW4oNUInhvziCmKfKvx4h1f
         TzgkTYFCfsctS2tx8E1aqg6WNLoeHF8Sf92gcICe3MvoIIHJExZj+lFFkpCy7BLUSNu1
         sfsA==
X-Gm-Message-State: AOAM532+LxWRY5rutUbhSLN80u1aX0sMpF3XjehpOChaq7ASFI24ryIv
        HEm22o/7WG/+7dpQcLH3BZiafm6j/hUlvRARWydL6TIFCs8n/s9h
X-Google-Smtp-Source: ABdhPJy79ugbVD18xNKgeJJS7R7I9nPbJRri2hmZvqYNv5xJmUbCZ+Bw18AvqxwtMQU8vlxFZSr21upUZuxx/sHlYLA=
X-Received: by 2002:a67:ee53:0:b0:31b:90ff:6a17 with SMTP id
 g19-20020a67ee53000000b0031b90ff6a17mr4756824vsp.84.1645240978155; Fri, 18
 Feb 2022 19:22:58 -0800 (PST)
MIME-Version: 1.0
From:   =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Date:   Sat, 19 Feb 2022 05:22:47 +0200
Message-ID: <CAOE4rSyvnWW6jcGjTvT3Z+=BtykfUN2A9v7d+qGn2rA_fipkTw@mail.gmail.com>
Subject: WARN_ON(!svm->tsc_scaling_enabled)
To:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

I'm using:

kvm ignore_msrs=3D1
kvm_amd nested=3D1

invtsc=3Don
tsc-deadline=3Don
tsc-scale=3Doff
svm=3Don

and my dmesg gets spammed with warnings like every second.
Also sometimes guest VM freezes when booting.


if (svm->tsc_ratio_msr !=3D kvm_default_tsc_scaling_ratio) {
    WARN_ON(!svm->tsc_scaling_enabled);
    nested_svm_update_tsc_ratio_msr(vcpu);
}

WARNING: CPU: 6 PID: 21336 at arch/x86/kvm/svm/nested.c:582
nested_vmcb02_prepare_control (arch/x86/kvm/svm/nested.c:582
(discriminator 1)) kvm_amd
RIP: 0010:nested_vmcb02_prepare_control (arch/x86/kvm/svm/nested.c:582
(discriminator 1)) kvm_amd
Call Trace:
 <TASK>
enter_svm_guest_mode (arch/x86/kvm/svm/nested.c:480 (discriminator 3)
arch/x86/kvm/svm/nested.c:491 (discriminator 3)
arch/x86/kvm/svm/nested.c:647 (discriminator 3)) kvm_amd
nested_svm_vmrun (arch/x86/kvm/svm/nested.c:726) kvm_amd
kvm_arch_vcpu_ioctl_run (arch/x86/kvm/x86.c:10243 arch/x86/kvm/x86.c:10449)=
 kvm
kvm_vcpu_ioctl (arch/x86/kvm/../../../virt/kvm/kvm_main.c:3908) kvm
__x64_sys_ioctl (fs/ioctl.c:52 fs/ioctl.c:874 fs/ioctl.c:860 fs/ioctl.c:860=
)
do_syscall_64 (arch/x86/entry/common.c:50 arch/x86/entry/common.c:80)
? kvm_on_user_return (./arch/x86/include/asm/paravirt.h:194
./arch/x86/include/asm/paravirt.h:227 arch/x86/kvm/x86.c:370) kvm
? fire_user_return_notifiers (kernel/user-return-notifier.c:42
(discriminator 11))
? exit_to_user_mode_prepare (./arch/x86/include/asm/entry-common.h:53
kernel/entry/common.c:209)
? syscall_exit_to_user_mode (./arch/x86/include/asm/jump_label.h:55
./arch/x86/include/asm/nospec-branch.h:302
./arch/x86/include/asm/entry-common.h:94 kernel/entry/common.c:131
kernel/entry/common.c:302)
? do_syscall_64 (arch/x86/entry/common.c:87)

Maybe this warning is wrong?

Best regards,
D=C4=81vis
