Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A11A61A3122
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 10:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgDIIqY (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 04:46:24 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:39795 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIIqY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 04:46:24 -0400
Received: by mail-il1-f195.google.com with SMTP id r5so9501484ilq.6
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 01:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GEYEchC93kprcsaItYbNcU2jdynXG/AgD+PfcM6lGis=;
        b=FW/oVxMb4Hjl5s7npqCzWP2OUcRSZ9PHGTaYZM/QsUN+0LRV2jXcLfM+rvp2xDxOyk
         k0QPv6Iy9HjMJMDYwzXGYI02YxnBZZc01/w6GuLmhlLbBI3ntd/95ctxm8zEaVuP6Dk/
         +MSHOCaMaCjUIwD/IEjM2P+mpWHJHKmFtWw057PkfNdqA8PplNhxYqVTH9XdbmaBxlfW
         ZYmeEnhQo7AzZqIVIGU1tvrxY13FSgVhbp65fWi7FIVO/bdRPaBxw88AaYeU+W1FiGYk
         +OuXMouh0IctviLj06cdMQWeArbimoVuD352tTEKAZBA6Fl5qHvQCGg+BDQv/FpvN7s0
         9b9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GEYEchC93kprcsaItYbNcU2jdynXG/AgD+PfcM6lGis=;
        b=DUsvm0NHgogF4181ax/CwtCRaDki8UGGhpDXmuRuhqAKFzbR8P6LQctkzjfvC8Pi1g
         jUW+60C7LBxN7vamcqWmMXrf/xI5ImDE1D0+ZCvDienYd0dJ2kfwHk6ONt3hFVyuHHUv
         cOtkfMxQqjSbcqZoCktddFHCaIaYe/zXEu5IBht0Re3YN0orpzQYv36kJ80bx92UhRwg
         CphMNDmHPXAmaEQV3p1bcxLQPB+R44PuB2j/JNUTZiEz4NKkWncFByGcDO2QQx7xnB/Y
         UuF2R4cq+RJ9ntdJ8D8Hig+kHUacc2TOO+T0/zlxylbSwqEJQjqKP1kTMPRyYmKT1T45
         9j/A==
X-Gm-Message-State: AGi0PuYeqVfXgyIIz81CCjkqXz3Rd1QkAOCs7gYNePluTWKCms6NBwMA
        nPbrijkMQwxsjEcwFrEKLvSfXMtw6tjPP5sYe7SUvQcpepY=
X-Google-Smtp-Source: APiQypKo0+ZtHtPbv+vI37gqLhu0KY9PDsZYRKVbRO68XArF79OfRxzU/Zl9bIMw/9gS1JoB97xqv06L4/yO/ENwu5g=
X-Received: by 2002:a92:8f53:: with SMTP id j80mr12594438ild.171.1586421983807;
 Thu, 09 Apr 2020 01:46:23 -0700 (PDT)
MIME-Version: 1.0
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
 <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
In-Reply-To: <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 9 Apr 2020 10:46:12 +0200
Message-ID: <CAFULd4Y8Z0t2QUoMnscbJf-JqRyy=KYRZXyswH3PRwsZer4yyg@mail.gmail.com>
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 9, 2020 at 10:33 AM Paolo Bonzini <pbonzini@redhat.com> wrote:
>
> On 09/04/20 10:20, Uros Bizjak wrote:
> > Current mainline kernel fails to build (on Fedora 31) with:
> >
> >   GEN     .version
> >   CHK     include/generated/compile.h
> >   LD      vmlinux.o
> >   MODPOST vmlinux.o
> >   MODINFO modules.builtin.modinfo
> >   GEN     modules.builtin
> >   LD      .tmp_vmlinux.btf
> > ld: arch/x86/kvm/svm/sev.o: in function `sev_flush_asids':
> > /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:48: undefined reference to
> > `sev_guest_df_flush'
> > ld: arch/x86/kvm/svm/sev.o: in function `sev_hardware_setup':
> > /hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:1146: undefined reference
> > to `sev_platform_status'
> >   BTF     .btf.vmlinux.bin.o
>
> Strange, the functions are defined and exported with
> CONFIG_CRYPTO_DEV_SP_PSP, which is "y" in your config.

I tried to continue with a single make job (if there is something
wrong with dependencies). Still fails to build, but I can post the
continuation of errors from this single job:

[uros@localhost linux]$ make
  CALL    scripts/checksyscalls.sh
  CALL    scripts/atomic/check-atomics.sh
  DESCEND  objtool
  CHK     include/generated/compile.h
  CHK     kernel/kheaders_data.tar.xz
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  LD      vmlinux.o
  MODPOST vmlinux.o
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.btf
ld: arch/x86/kvm/svm/sev.o: in function `sev_flush_asids':
/hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:48: undefined reference to
`sev_guest_df_flush'
ld: arch/x86/kvm/svm/sev.o: in function `sev_hardware_setup':
/hdd/uros/git/linux/arch/x86/kvm/svm/sev.c:1146: undefined reference
to `sev_platform_status'
  BTF     .btf.vmlinux.bin.o
tag__check_id_drift: subroutine_type id drift, core_id: 1644,
btf_type_id: 1642, type_id_off: 0
libbpf: Unsupported BTF_KIND:0
btf_elf__encode: btf__new failed!
free(): double free detected in tcache 2
scripts/link-vmlinux.sh: vrstica 114: 725221 Aborted
(izpis jedra) LLVM_OBJCOPY=${OBJCOPY} ${PAHOLE} -J ${1}
  LD      .tmp_vmlinux.kallsyms1
.btf.vmlinux.bin.o: file not recognized: file format not recognized
make: *** [Makefile:1086: vmlinux] Error 1

Uros.
