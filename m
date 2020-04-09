Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D206B1A3462
	for <lists+kvm@lfdr.de>; Thu,  9 Apr 2020 14:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgDIMvm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Apr 2020 08:51:42 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:46985 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725971AbgDIMvm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Apr 2020 08:51:42 -0400
Received: by mail-io1-f68.google.com with SMTP id i3so3634736ioo.13
        for <kvm@vger.kernel.org>; Thu, 09 Apr 2020 05:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xYyPzQ2DdU2lh/qLxAHvZYhZyn/lM7nZI3e/W68srRA=;
        b=VsXhMKKJnEpmcCy78hzjn5QwU09l+fVVKr+Rso4MVFIe2DXAIutoWgL3Tvp+S7wH4r
         EgTHucTamZVVTjftiIIfR6TSGrPYPdcg96rhWiZmsDeX259yu914M3pzbeLeQ8JPLcoh
         v/CTjjXsLZ1NrNy+NhzjRDRcQdClRnHFHPhcWOl4QQQ8AgsTi6shNXCf+dFBmDm3QbiY
         +/ZJ3G9wffp76wSnWR3MS2l+rMWZ2O486YH2PcK8+Pk2qCsAMLuPohT6SCvxCO9gtPMZ
         gi8/HRYu8RiwctZKbb7KzL23Rn8l14X6zd0omIYawf8Kny2WVgOFOWVsZMMeTcM8YPwM
         wRjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xYyPzQ2DdU2lh/qLxAHvZYhZyn/lM7nZI3e/W68srRA=;
        b=otbuZx3wIK+7hv+eTdi/mBYopc58MmfEMJywvyMSo33t4vsEROMl2bsgn49OtP4toF
         vi+3duE7R+3vvhUx8ZWRpd+oLgceiA3+0uPrFM/QO2m4oI+k1Q7fC+KeanJGqipIXsnM
         JWtXSwMBtdcdTQj3+ErvY5KAD6dVJCII2FvPZzYe90iUy6YWcBU58BFYPjSnIWiOCEeq
         NIPcdyvCm326rx5QaxCFlJL5o7I4hCnBzVL4EHeOjpG/Lo1WEqw5w/qaARH4NOUXHQNi
         nlSejfe2+csBw6Gc85l71hwF3iiduJGtXTCdMoumfMDrQbW8UUjCmSmrEiJF6E1Rp02y
         WAYg==
X-Gm-Message-State: AGi0PuZdkNawWRpTYZ7Zoak2xocSHkZ4HO5xRhKYIuDNxMH9prpvCnhZ
        4bUmVFqK5YXWX7l61En2W9SPwXU2a67d1Ryo0Us=
X-Google-Smtp-Source: APiQypJ1XPzeIoo11Ygog9vSoABGEzQUpgJCB2tA/jWpFL3zf6qS71jLITOxGdfhSAYALwi30zIaz/pUi4lO5Lg4X4A=
X-Received: by 2002:a6b:f002:: with SMTP id w2mr4655866ioc.48.1586436702074;
 Thu, 09 Apr 2020 05:51:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAFULd4adXFX+y6eCV0tVhg-iHZe+tAchJkuHMXe3ZWktzGk7Sw@mail.gmail.com>
 <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
In-Reply-To: <a2187cc0-cab6-78db-3e2d-6edaf647c882@redhat.com>
From:   Uros Bizjak <ubizjak@gmail.com>
Date:   Thu, 9 Apr 2020 14:51:30 +0200
Message-ID: <CAFULd4YG1Df_1HvjDUYCyW+VTLO3-xk8CU4Lwsv2Lq=G-wP+cQ@mail.gmail.com>
Subject: Re: Current mainline kernel FTBFS in KVM SEV
To:     Paolo Bonzini <pbonzini@redhat.com>, like.xu@intel.com
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

The problem is with

CONFIG_CRYPTO_DEV_CCP_DD=m

in combination with

CONFIG_KVM_AMD=y

in arch/x86/kvmKconfig, there is:

--cut here--
config KVM_AMD_SEV
    def_bool y
    bool "AMD Secure Encrypted Virtualization (SEV) support"
    depends on KVM_AMD && X86_64
    depends on CRYPTO_DEV_SP_PSP && !(KVM_AMD=y && CRYPTO_DEV_CCP_DD=m)
    ---help---
    Provides support for launching Encrypted VMs on AMD processors.
--cut here--

which doesn't disable the compilation of sev.o. The missing functions
are actually in ccp.o *module*, called from built-in functions of
sev.o

Enabling CRYPTO_DEV_CCP_DD=y as a built-in instead of a module fixes the build.

Uros.
