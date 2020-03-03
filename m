Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C07A0176DF6
	for <lists+kvm@lfdr.de>; Tue,  3 Mar 2020 05:25:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727052AbgCCEZn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 23:25:43 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:33125 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726859AbgCCEZn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 23:25:43 -0500
Received: by mail-il1-f196.google.com with SMTP id r4so1602192iln.0
        for <kvm@vger.kernel.org>; Mon, 02 Mar 2020 20:25:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aA3rcp37ynjDu323kR9lCxo/VdLX9hbo1ymg1oSY7S0=;
        b=oTw2GfzGDJ0OMWgicWBB4xW5WXn76GCVh2YKU/tozHXB4mTl2yYRIchpoJtv1xTOil
         jLA0hw4IBTGABDDTx+c3ivnH1+4pzygwbKXJiiJpG+QdB1seituXo8R0bxEynjj3Mp6j
         OKMQgy+sFpv+/bIqAnqWHW1H7E092voDCvhx+fNXiD6tvWkOWNsH6oXuM9ArJvs6yidI
         QoGvJZq/p3jhr8PU+mLBfPn2Uz59MQZ89WvErgYo9l/Xx1261x9mzRs450YGkcPrg1hJ
         h3qW0dttkHW7Vm23Ek8h53hPVobnIiusnRQZfhwELxBb8+WDUG0lWKve27Azgb0aq+Sx
         abdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aA3rcp37ynjDu323kR9lCxo/VdLX9hbo1ymg1oSY7S0=;
        b=tLXqFTqWUgr2U2cOUvzQul5uCviMf7senPP932lpcdNLP/8XYCRX+b8SQnXh6T3Qid
         fosJacw0Ew19U1j33TdmJiedKso1nvsvV8abhTmYg2l7uwE7CfmUX36MmfEMu7bdgIXT
         jYX5220Kp8qQsbe4jRMLaA9uHjZwW366NV4foif37y/LFiOzqspA8693u0WRcpc+dzVp
         QuPLSpu30MWDkkfnrxxrObve9+Jmev0vBtcC8xNatJWpzFwGAMQByak8qOSNdQs3pWyE
         4JBwLmx7zfK7wWC4D3U7GrBbwnBkLzdcc7ElKGwGCVsizaqcvJfyossbErd6JCsv6DBA
         EpTQ==
X-Gm-Message-State: ANhLgQ0TPdsNDEX9fg0/DSTVaX1QiBY/36ua5SvwRvprGeM49I4LHuBW
        zUP93RoPIO239JM6Wu67HgE3RqzxNAZPsDPcd7kJfA==
X-Google-Smtp-Source: ADFU+vtiBNqH2OPw0N2pJtfK+G7U2UzZDbiRRJlnhpRPIPpeGlUsbvg6RWXrTljxxVNVtiVIvJ5UkLSPHJ/E4N50zrE=
X-Received: by 2002:a92:8547:: with SMTP id f68mr3077508ilh.26.1583209542408;
 Mon, 02 Mar 2020 20:25:42 -0800 (PST)
MIME-Version: 1.0
References: <20200302195736.24777-1-sean.j.christopherson@intel.com>
 <20200302195736.24777-3-sean.j.christopherson@intel.com> <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
In-Reply-To: <CALMp9eThBnN3ktAfwhNs7L-O031JDFqjb67OMPooGvmkcdhK4A@mail.gmail.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 2 Mar 2020 20:25:31 -0800
Message-ID: <CALMp9eR0Mw8iPv_Z43gfCEbErHQ6EXX8oghJJb5Xge+47ZU9yQ@mail.gmail.com>
Subject: Re: [PATCH 2/6] KVM: x86: Fix CPUID range check for Centaur and
 Hypervisor ranges
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 2, 2020 at 7:25 PM Jim Mattson <jmattson@google.com> wrote:
>
> On Mon, Mar 2, 2020 at 11:57 AM Sean Christopherson
> <sean.j.christopherson@intel.com> wrote:
>
> > The bad behavior can be visually confirmed by dumping CPUID output in
> > the guest when running Qemu with a stable TSC, as Qemu extends the limit
> > of range 0x40000000 to 0x40000010 to advertise VMware's cpuid_freq,
> > without defining zeroed entries for 0x40000002 - 0x4000000f.
>
> I think it could be reasonably argued that this is a userspace bug.
> Clearly, when userspace explicitly supplies the results for a leaf,
> those results override the default CPUID values for that leaf. But I
> haven't seen it documented anywhere that leaves *not* explicitly
> supplied by userspace will override the default CPUID values, just
> because they happen to appear in some magic range.

In fact, the more I think about it, the original change is correct, at
least in this regard. Your "fix" introduces undocumented and
unfathomable behavior.
