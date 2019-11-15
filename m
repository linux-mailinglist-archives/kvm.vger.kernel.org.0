Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C97FD233
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 02:05:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727334AbfKOBF6 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Nov 2019 20:05:58 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:39848 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727020AbfKOBF6 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Nov 2019 20:05:58 -0500
Received: by mail-il1-f194.google.com with SMTP id a7so7467348ild.6
        for <kvm@vger.kernel.org>; Thu, 14 Nov 2019 17:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=h1uxTGN5+YblWsbkVROQho4rgB56Wr9P7YbibXnLDaE=;
        b=RG2RxUvMbsXCXXPnhgXBBoeS5QssRf0FvyXi2HTy1698EKlNgSARUpgbE+Ui4vc08t
         zKL5Yn0oHufjSAemQzruAeHennelmsctEwhdIjEBV4fLKqP306ZABpy/iNmRvBg5ZEaQ
         0ipKDLrbKp2u5WMpTqpXaEzo8/5LW50kKrk98Qz2xNl/bWTFdCpP3PVRZuAdklbzTKuz
         mfgh99mvzjjl6DVKYyF67AEzdjyI3VUf4t3MnshZfWC2xeaf5nXzTFT6QWX1jhRm740v
         D+x6B03/KXWBzqt3TxwQjvlr35cIILH79Rtw4UlXqzPg0vq97c86oWpSO827QDEIoNLF
         1i0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=h1uxTGN5+YblWsbkVROQho4rgB56Wr9P7YbibXnLDaE=;
        b=gOEoMc85kc/s+nPywU/9W9sSDR5/u1Rppcz6SlHvNs3/eQOpnoURGY1GJ7W2+VncDu
         4YiUGAD58oM/W0AoxtWnQ7IeYbUIDBkgq2Q6y4vg5Y7JF29Z8mXM8sw/u5O5+ao4iaGF
         il8ZUt4K3xpSm31TdVrUjXHlyoVZQISI+hDNM2NfSb7kxn2A7d17i//G9K3xkDulfvmN
         j2Fb3lQh93EtDy6yo5ikIAWaBS9ky9LlEvlMl5HMps9Fk5DPQOVtjBA7iQEC8/w84+e4
         RS4nbgGisXKgwI1C3GqWM/YX8snNjUH+0RR3Z0qPYdlqTZWV29Q74ZOJKFqs6FN+Y1+7
         SeNA==
X-Gm-Message-State: APjAAAW9aP+O02+hahPLBgDp9Im7zMi2zKmRmsphqu2MDCkg0t8EHeNW
        5Z8R0as+mvRVoUXD6wlx4Tyalo4vHcCV2pRvuj4dTg==
X-Google-Smtp-Source: APXvYqzjWv9tjP/8U1BqciewaRNxz3du0AgTJKOD6NT0/lTJf9xtLxjDEZSvl13XXGfmAACzuc0gwZYStcn2Lxvg8L0=
X-Received: by 2002:a92:85:: with SMTP id 127mr13723179ila.118.1573779956774;
 Thu, 14 Nov 2019 17:05:56 -0800 (PST)
MIME-Version: 1.0
References: <CALMp9eTT6oJMibHh0OTXgj83LXmjGt7CQ22Tr6NM4NRB_bfA8Q@mail.gmail.com>
 <CB679B0C-00FF-400E-B760-4AC8641252AC@oracle.com> <CALMp9eRbSL+y6-LV8YSRpOBa+t0dnEG5=tc91EZy1_CZRvMYiw@mail.gmail.com>
 <C9723F4E-01AA-4739-B93B-7F49477A15AF@oracle.com>
In-Reply-To: <C9723F4E-01AA-4739-B93B-7F49477A15AF@oracle.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Thu, 14 Nov 2019 17:05:45 -0800
Message-ID: <CALMp9eSdm9cQamj3mMiyQHL1W+FXZ497AH_hZecmeHowjJoUxg@mail.gmail.com>
Subject: Re: KVM_GET_MSR_INDEX_LIST vs KVM_GET_MSR_FEATURE_INDEX_LIST
To:     Liran Alon <liran.alon@oracle.com>
Cc:     kvm list <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Nov 14, 2019 at 4:35 PM Liran Alon <liran.alon@oracle.com> wrote:
>
>
>
> > On 15 Nov 2019, at 0:07, Jim Mattson <jmattson@google.com> wrote:
> >
> > On Sat, Sep 8, 2018 at 5:58 PM Liran Alon <liran.alon@oracle.com> wrote=
:
> >>
> >>
> >>> On 7 Sep 2018, at 21:37, Jim Mattson <jmattson@google.com> wrote:
> >>>
> >>> Are these two lists intended to be disjoint? Is it a bug that
> >>> IA32_ARCH_CAPABILITIES appears in both?
> >
> > Here's a more basic question: Should any MSR that can be read and
> > written by a guest appear in KVM_GET_MSR_INDEX_LIST? If not, what's
> > the point of this ioctl?
>
> I think the point of KVM_GET_MSR_INDEX_LIST ioctl is for userspace to kno=
w what are all the MSR values it needs to save/restore on migration.
> Therefore, any MSR that is exposed to guest read/write and isn=E2=80=99t =
determined on VM provisioning time, should be returned from this ioctl.
>
> In contrast, KVM_GET_MSR_FEATURE_INDEX_LIST ioctl is meant to be used by =
userspace to query KVM capabilities based on host MSRs and KVM support and =
use that information to validate the CPU features that the user have reques=
ted to expose to guest.
>
> For example, MSR_IA32_UCODE_REV is specified only in KVM_GET_MSR_FEATURE_=
INDEX_LIST. This is because it is determined by userspace on provisioning t=
ime (No need to save/restore on migration) and userspace may require to kno=
w it=E2=80=99s host value to define guest value appropriately. MSR_IA32_PER=
F_STATUS is not specified in neither ioctls because KVM returns constant va=
lue for it (not required to be saved/restored).
>
> However, I=E2=80=99m also not sure about above mentioned definitions=E2=
=80=A6 As they are some bizarre things that seems to contradict it:
> 1) MSR_IA32_ARCH_CAPABILITIES is specified in KVM_GET_MSR_FEATURE_INDEX_L=
IST to allow userspace to know which vulnerabilities apply to CPU. By defau=
lt, vCPU MSR_IA32_ARCH_CAPABILITIES value will be set by host value (See kv=
m_arch_vcpu_setup()) but it=E2=80=99s possible for host userspace to overri=
de value exposed to guest (See kvm_set_msr_common()). *However*, it seems t=
o me to be wrong that this MSR is specified in KVM_GET_MSR_INDEX_LIST as it=
 should be determined in VM provisioning time and thus not need to be saved=
/restore on migration. i.e. How is it different from MSR_IA32_UCODE_REV?
> 2) MSR_EFER should be saved/restored and thus returned by KVM_GET_MSR_IND=
EX_LIST. But it=E2=80=99s not. Probably because it can be saved/restored vi=
a KVM_{GET,SET}_SREGS but this is inconsistent with semantic definitions of=
 KVM_GET_MSR_INDEX_LIST ioctl...
> 3) MSR_AMD64_OSVW_ID_LENGTH & MSR_AMD64_OSVW_STATUS can be set by guest b=
ut it doesn=E2=80=99t seem to be specified in emulated_msrs[] and therefore=
 not returned by KVM_GET_MSR_INDEX_LIST ioctl. I think this is a migration =
bug...
>
> Unless someone disagrees, I think I will submit a patch for (1) and (3).

I assume that we're also skipping the x2APIC MSRs because they can be
read/modified with KVM_{GET,SET}_LAPIC. At least until you start
thinking about userspace instruction emulation.

What about MSR_F15H_PERF_*, MSR_K7_EVNTSEL*, MSR_K7_PERFCTR*,
MSR_MTRR*, HV_X64_MSR_STIMER[12]_CONFIG,
HV_X64_MSR_STIMER[0123]_COUNT, MSR_VM_CR, and possibly others I'm
missing on the first pass?
