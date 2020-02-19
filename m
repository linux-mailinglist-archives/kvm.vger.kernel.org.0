Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84308164EFF
	for <lists+kvm@lfdr.de>; Wed, 19 Feb 2020 20:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgBSTgz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 19 Feb 2020 14:36:55 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:36778 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgBSTgz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 19 Feb 2020 14:36:55 -0500
Received: by mail-io1-f68.google.com with SMTP id d15so1902484iog.3
        for <kvm@vger.kernel.org>; Wed, 19 Feb 2020 11:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wq9tupoisv9mbZ6pEYhyTpZEcWy//yLq2ZAN2dQ2ijM=;
        b=Meky6vvd4oYZY09DvdwQQjgU6CkwFRob0EaEEI3q3ohpna9S8w1bGmm49w8GXdZEPS
         BWkJ3ful0jrtpclZbopK6ot0O4fKjR+YJ2svxRypf66vJssxvAQEe9KVgdEcDKVhOdLR
         8fjIrEuZM4jUbI/3Qlo12kCnnkkBbNtk31ODn4uOGkC9YIAbLvVl88LhmUKZp8uOF9fY
         qDg152BEeokBxQIZPPMl1W+ARMETekjJcBcd+MZbQtVjTKv8lHdfn1IU3DbjgFIYdFhY
         pn/aJmLVKQoJko92zqTBG/YiZjIULXTXBSWHFnZVJoMnWx0ROzeEOunVwcwdoUaCsKlV
         50Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wq9tupoisv9mbZ6pEYhyTpZEcWy//yLq2ZAN2dQ2ijM=;
        b=ARtPHJO2Brm2uJilSxF0RnFNBiXJ/sFVuOSdLYv9ZUgKgwlYAbP5jv3kdl0/jP3aEL
         hpnz7kLSA7I5U94PGC+NGz8pJRvF6Kfu/1JHesJkRcAPncNaaqIrWEUpTjWGLpyCQePG
         DKyQGewSrmKHwKs7UsDAaNcY7sRNyZGpuQeQieGwN4sCPc/CSNkRIWImmQAvB63kRwtw
         l50iIEQinZHVCtkdR3JHG5s+IuNh2KQNAl0m4EVgBycdLLu1Jp3v3i/2CrTxYUxmaPNC
         j4PJP5KPcH0gBzmDZxLH5kWpDCtatJXFOSLNzQjEzGCvKFm5pMxg8u3ivh0h92jy9J33
         B0rg==
X-Gm-Message-State: APjAAAUT2OHT3QFY9tKXfaxTzcscF/4zM2RlWQ7i8rS68gKethSmSLf9
        yImYv4a9ps4IothH+qqWoalMBBif84MZM7Pgm9kffpyz
X-Google-Smtp-Source: APXvYqy/85QpbQO1vmm8lX5sDGs69JYATpUdh7+nbK7268D9rYqQJTFsAsNfHXTM3YHdY8zlXEy1t1MXwbsdu7ZkRyA=
X-Received: by 2002:a5d:8555:: with SMTP id b21mr21048220ios.200.1582141012922;
 Wed, 19 Feb 2020 11:36:52 -0800 (PST)
MIME-Version: 1.0
References: <20200213213036.207625-1-olvaffe@gmail.com> <8fdb85ea-6441-9519-ae35-eaf91ffe8741@redhat.com>
 <CAPaKu7T8VYXTMc1_GOzJnwBaZSG214qNoqRr8c7Z4Lb3B7dtTg@mail.gmail.com>
 <b82cd76c-0690-c13b-cf2c-75d7911c5c61@redhat.com> <20200214195229.GF20690@linux.intel.com>
 <CAPaKu7Q4gehyhEgG_Nw=tiZiTh+7A8-uuXq1w4he6knp6NWErQ@mail.gmail.com>
 <CALMp9eRwTxdqxAcobZ7sYbD=F8Kga=jR3kaz-OEYdA9fV0AoKQ@mail.gmail.com>
 <20200214220341.GJ20690@linux.intel.com> <d3a6fac6-3831-3b8e-09b6-bfff4592f235@redhat.com>
 <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <AADFC41AFE54684AB9EE6CBC0274A5D19D78D6F4@SHSMSX104.ccr.corp.intel.com>
From:   Chia-I Wu <olvaffe@gmail.com>
Date:   Wed, 19 Feb 2020 11:36:42 -0800
Message-ID: <CAPaKu7RyTbuTPf0Tp=0DAD80G-RySLrON8OQsHJzhAYDh7zHuA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] KVM: x86: honor guest memory type
To:     "Tian, Kevin" <kevin.tian@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        kvm list <kvm@vger.kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        Gurchetan Singh <gurchetansingh@chromium.org>,
        Gerd Hoffmann <kraxel@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Feb 19, 2020 at 1:52 AM Tian, Kevin <kevin.tian@intel.com> wrote:
>
> > From: Paolo Bonzini
> > Sent: Wednesday, February 19, 2020 12:29 AM
> >
> > On 14/02/20 23:03, Sean Christopherson wrote:
> > >> On Fri, Feb 14, 2020 at 1:47 PM Chia-I Wu <olvaffe@gmail.com> wrote:
> > >>> AFAICT, it is currently allowed on ARM (verified) and AMD (not
> > >>> verified, but svm_get_mt_mask returns 0 which supposedly means the
> > NPT
> > >>> does not restrict what the guest PAT can do).  This diff would do the
> > >>> trick for Intel without needing any uapi change:
> > >> I would be concerned about Intel CPU errata such as SKX40 and SKX59.
> > > The part KVM cares about, #MC, is already addressed by forcing UC for
> > MMIO.
> > > The data corruption issue is on the guest kernel to correctly use WC
> > > and/or non-temporal writes.
> >
> > What about coherency across live migration?  The userspace process would
> > use cached accesses, and also a WBINVD could potentially corrupt guest
> > memory.
> >
>
> In such case the userspace process possibly should conservatively use
> UC mapping, as if for MMIO regions on a passthrough device. However
> there remains a problem. the definition of KVM_MEM_DMA implies
> favoring guest setting, which could be whatever type in concept. Then
> assuming UC is also problematic. I'm not sure whether inventing another
> interface to query effective memory type from KVM is a good idea. There
> is no guarantee that the guest will use same type for every page in the
> same slot, then such interface might be messy. Alternatively, maybe
> we could just have an interface for KVM userspace to force memory type
> for a given slot, if it is mainly used in para-virtualized scenarios (e.g.
> virtio-gpu) where the guest is enlightened to use a forced type (e.g. WC)?
KVM forcing the memory type for a given slot should work too.  But the
ignore-guest-pat bit seems to be Intel-specific.  We will need to
define how the second-level page attributes combine with the guest
page attributes somehow.

KVM should in theory be able to tell that the userspace region is
mapped with a certain memory type and can force the same memory type
onto the guest.  The userspace does not need to be involved.  But that
sounds very slow?  This may be a dumb question, but would it help to
add KVM_SET_DMA_BUF and let KVM negotiate the memory type with the
in-kernel GPU drivers?


>
> Thanks
> Kevin
