Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E319218044
	for <lists+kvm@lfdr.de>; Wed,  8 May 2019 21:10:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfEHTJP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 8 May 2019 15:09:15 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43867 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHTJO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 8 May 2019 15:09:14 -0400
Received: by mail-pl1-f194.google.com with SMTP id n8so10367816plp.10
        for <kvm@vger.kernel.org>; Wed, 08 May 2019 12:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1u1hPl/qFt03mb/D28lmazA0h5tpYZGyorQTHBrh5GU=;
        b=YVbqA8pEZxkKYOPsgpVm/AxaSnneIgfsGew5mgmu0L5BFrxUjoP9SlfabKNK8tdB40
         gMKA++vBrx/AY8AbzM9H3unXTPcRczl9U27uVs3747mvcfi0NNdoC0SZB3Tmqa0IByuA
         qXJxu2to4LBj1UtksXJq+OliL7YrJESDjhePp09CN8TOqOuwLFyY8mbePyQOYx+zz6jt
         wDbzjXpW5x6TMiE++IF60IESjcnX4ptLIxd3+HZ7K2k72u02AcRameobdA3H+TsoIrMI
         P2Sd9HsRW4arrY3i/OoJDwJXoHoB9z8Jfdz08ivv/tMhctJH4gedZ67jqFD41i3nghBx
         EuWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1u1hPl/qFt03mb/D28lmazA0h5tpYZGyorQTHBrh5GU=;
        b=rnL97ihZNe+9E3H+nwAVBLwBSMuyWRPgV3cI/ea0uPvDpnRF8jqz7hJ8Ckk/Qgi15w
         eQQBNHaSzRzckla8S3CmA9y3GvoV+4oE/OrG+5m48viCKJhygwLERIE97B+sBlIvSdvW
         TGhQViI3wgGK7aA3LXln/PqEdFxQcWtvqDrTw41L+18o/d/7VdwaryYrPYyfoCWJlu6x
         vzgzJYm5HZ95t5mJO3nbG6Yk6UQVK3nDOZKKQfMs2AftfHqvLNsqEK6QoEZHiD75GL+L
         h86iKwqHOYujAhHhSFgTAILRSIjcl8tGwc2sEmHU5uCAT31s9P3mSMaHhmisx31+ARhz
         j19w==
X-Gm-Message-State: APjAAAXDnmoZ2RjpBezMdfNYJG0u2MPgYrYqUGWL6yAjBvEoI4Z0awMi
        fBvyFmqPkBmOKq9IM1HlTVsH+5ffL5s=
X-Google-Smtp-Source: APXvYqwDzpjgwRBb94miav+muyG3UBQdNqJ5WpGztsdZRmB9wiotASQunWsmAMU7lfkFwQHdUwrk3w==
X-Received: by 2002:a17:902:4183:: with SMTP id f3mr41668725pld.63.1557342553836;
        Wed, 08 May 2019 12:09:13 -0700 (PDT)
Received: from [10.33.115.113] ([66.170.99.2])
        by smtp.gmail.com with ESMTPSA id g3sm18946555pgh.69.2019.05.08.12.09.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 May 2019 12:09:12 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH] Revert "KVM: nVMX: Expose RDPMC-exiting only when guest
 supports PMU"
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20190508173623.GC19656@linux.intel.com>
Date:   Wed, 8 May 2019 12:09:10 -0700
Cc:     Jim Mattson <jmattson@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?utf-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm list <kvm@vger.kernel.org>,
        David Hill <hilld@binarystorm.net>,
        Saar Amar <saaramar@microsoft.com>,
        Mihai Carabas <mihai.carabas@oracle.com>,
        Liran Alon <liran.alon@oracle.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <AB6487D4-4B9B-488E-9FDC-54C42B6631A5@gmail.com>
References: <20190508160819.19603-1-sean.j.christopherson@intel.com>
 <CALMp9eSrpi=Pagdt_3UhcWpDpHcVc6c2t0HAszZz105kN+ehsA@mail.gmail.com>
 <20190508173623.GC19656@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailer: Apple Mail (2.3445.104.8)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> On May 8, 2019, at 10:36 AM, Sean Christopherson =
<sean.j.christopherson@intel.com> wrote:
>=20
> On Wed, May 08, 2019 at 09:57:11AM -0700, Jim Mattson wrote:
>> On Wed, May 8, 2019 at 9:08 AM Sean Christopherson
>> <sean.j.christopherson@intel.com> wrote:
>>> The RDPMC-exiting control is dependent on the existence of the RDPMC
>>> instruction itself, i.e. is not tied to the "Architectural =
Performance
>>> Monitoring" feature.  For all intents and purposes, the control =
exists
>>> on all CPUs with VMX support since RDPMC also exists on all VCPUs =
with
>>> VMX supported.  Per Intel's SDM:
>>>=20
>>>  The RDPMC instruction was introduced into the IA-32 Architecture in
>>>  the Pentium Pro processor and the Pentium processor with MMX =
technology.
>>>  The earlier Pentium processors have performance-monitoring =
counters, but
>>>  they must be read with the RDMSR instruction.
>>>=20
>>> Because RDPMC-exiting always exists, KVM requires the control and =
refuses
>>> to load if it's not available.  As a result, hiding the PMU from a =
guest
>>> breaks nested virtualization if the guest attemts to use KVM.
>>=20
>> Is it true that the existence of instruction <X> implies the
>> availaibility of the VM-execution control <X>-exiting (if such a
>> VM-execution control exists)? What about WBINVD? That instruction has
>> certainly been around forever, but there were VMX-capable processors
>> that did not support WBINVD-exiting.
>=20
> Technically no, but 99% of the time yes.  It's kind of similar to =
KVM's
> live migration requirements: new features with "dangerous" =
instructions
> need an associated VMCS control, but there are some legacy cases where
> a VMCS control was added after the fact, WBINVD being the obvious =
example.
>=20
>> Having said that, I think our hands are tied by the assumptions made
>> by existing hypervisors, whether or not those assumptions are true.
>> (VMware's VMM, for instance, requires MONITOR-exiting and
>> MWAIT-exiting even when MONITOR/MWAIT are not enumerated by CPUID.)
>=20
> I'd say it's more of a requirement than an assumption, e.g. KVM
> *requires* RDPMC-exiting so that the guest can't glean info about the
> host.  I guess technically KVM is assuming RDPMC itself exists, but
> it's existence is effectively guaranteed by the SDM.
>=20
> I can't speak to the VMWare behavior, e.g. it might be nothing more
> than a simple oversight that isn't worth fixing, or maybe it's =
paranoid
> and really wants to ensure the guest can't execute MONITOR/MWAIT :-)

I am sure Jim is more knowledgable than I am to talk about the reasons =
for
VMware behavior. But I would send somewhen later a patch for
kvm-unit-tests/vmx, since they assume the MONITOR/MWAIT are supported if =
the
execution-control is supported. This is, as Jim indicated, not true on
VMware.

