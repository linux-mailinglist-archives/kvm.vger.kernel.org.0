Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B91FD2AEF37
	for <lists+kvm@lfdr.de>; Wed, 11 Nov 2020 12:09:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbgKKLJr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 Nov 2020 06:09:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbgKKLJq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 Nov 2020 06:09:46 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E45BC0613D1
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 03:09:44 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id e18so1854081edy.6
        for <kvm@vger.kernel.org>; Wed, 11 Nov 2020 03:09:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=pwKeITuNK0cZmhGHLwnsoeQdvMXGSXHamSDSuz0/43Y=;
        b=lIl6rXETkO/FlJJd0QkBuBP81K4/gmS/fbIUTfUcTAE2zBLFnzGJXfKuuTFv8tawQM
         H4LuT+rQTitoTGTkuLpJLIeYIIkbRGG/2bfi5uj4z9j2Ps11Lo0sa/SJUR95ARJ38Auo
         Quyj5m6bQJYvFLR/Q+E+4IdST0MgcOC9C3stSTvk3ckHUCRNL+PlIExLb2/DQANCKt88
         75N7tIAu9TiJ9Ux2KQ9P73Dosm1fbZ8y5OHHNv3SF7JdkTJrSgNzYG936wyd4WPQ+Hvd
         memNZ0HktXw8gmWgwFShWZFgdKIFXzy+le7Tq0Zs3W3fwzLl/JPoc67gXAbWJwKh9OdO
         GxPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=pwKeITuNK0cZmhGHLwnsoeQdvMXGSXHamSDSuz0/43Y=;
        b=K3t0uzk1l/0CleirIiVdOMw5RlmP1/+vdvqrIHJqhW7bPVJBlUms9apsOmCUVvEBRt
         FscxLMAtkrfCv0eF7u+5co79aY14jvjN3ypowDjK/R+Lt7/KKkBmHbYFq60wWc3bBS3L
         KV0mBVoTflTmuPeV9xvlCslm6/I7/G6QnbjtWTvK5Z2o6SgQoKwpXj5qzIl42dyXT85T
         fkjUSCCs5KuR34WUvLJ3uMlwbpzdgiZNkPc3DzwdKawZ0u6omgijY5hWhbneWubW3tf1
         gBcja23kdtGewQLQ05eRSiNKvuj5+Csdm+fAJoaNZ4TbNNwoMzTJaO/eJyqNA7FomWKc
         wOBg==
X-Gm-Message-State: AOAM530d9qR+ADxkoV74K3u8I4w63iNmYn5xDFkhOAu8yp5uEkGyDCF+
        0I/DzZtL3gfYTijLyY5Qmfo=
X-Google-Smtp-Source: ABdhPJxf7YHqzEUKF0gRF9Q8dk+nwBSNzhMnWJ8DzVWTu9hEo/Bg3X/joF/RpCMbO/kFxDVKQx+17g==
X-Received: by 2002:a50:a6c9:: with SMTP id f9mr1036000edc.158.1605092983007;
        Wed, 11 Nov 2020 03:09:43 -0800 (PST)
Received: from vm1 (ip-86-49-65-192.net.upcbroadband.cz. [86.49.65.192])
        by smtp.gmail.com with ESMTPSA id q26sm715737ejt.73.2020.11.11.03.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 03:09:42 -0800 (PST)
Date:   Wed, 11 Nov 2020 12:09:39 +0100
From:   Zdenek Kaspar <zkaspar82@gmail.com>
To:     Ben Gardon <bgardon@google.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jim Mattson <jmattson@google.com>
Subject: Re: Unable to start VM with 5.10-rc3
Message-ID: <20201111120939.54929a50.zkaspar82@gmail.com>
In-Reply-To: <CANgfPd-gaDhmwPm5CC=cAFn8mBczbUjs7u3KucAGdKmU81Vbeg@mail.gmail.com>
References: <20201110162344.152663d5.zkaspar82@gmail.com>
        <CANgfPd-gaDhmwPm5CC=cAFn8mBczbUjs7u3KucAGdKmU81Vbeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/QU7aE8.OaV7PS6RjHOBeIme"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

--MP_/QU7aE8.OaV7PS6RjHOBeIme
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi, I'm sure my bisect has nothing to do with KVM,
because it was quick shot between -rc1 and previous release.

This old CPU doesn't have EPT (see attached file)

./run_tests.sh
FAIL apic-split (timeout; duration=90s)
FAIL ioapic-split (timeout; duration=90s)
FAIL apic (timeout; duration=30)
... ^C
few RIP is_tdp_mmu_root observed in dmesg

Z.

On Tue, 10 Nov 2020 17:13:21 -0800
Ben Gardon <bgardon@google.com> wrote:

> Hi Zdenek,
> 
> That crash is most likely the result of a missing check for an invalid
> root HPA or NULL shadow page in is_tdp_mmu_root, which could have
> prevented the NULL pointer dereference.
> However, I'm not sure how a vCPU got to that point in the page fault
> handler with a bad EPT root page.
> 
> I see VMX in your list of flags, is your machine 64 bit with EPT or
> some other configuration?
> 
> I'm surprised you are finding your machine unable to boot for
> bisecting. Do you know if it's crashing in the same spot or somewhere
> else? I wouldn't expect the KVM page fault handler to run as part of
> boot.
> 
> I will send out a patch first thing tomorrow morning (PST) to WARN
> instead of crashing with a NULL pointer dereference. Are you able to
> reproduce the issue with any KVM selftest?
> 
> Ben
> 
> 
> On Tue, Nov 10, 2020 at 7:24 AM Zdenek Kaspar <zkaspar82@gmail.com>
> wrote:
> >
> > Hi,
> >
> > attached file is result from today's linux-master (with fixes
> > for 5.10-rc4) when I try to start VM on older machine:
> >
> > model name      : Intel(R) Core(TM)2 CPU          6600  @ 2.40GHz
> > flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr
> > pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ht tm pbe
> > syscall nx lm constant_tsc arch_perfmon pebs bts rep_good nopl
> > cpuid aperfmperf pni dtes64 monitor ds_cpl vmx est tm2 ssse3 cx16
> > xtpr pdcm lahf_lm pti tpr_shadow dtherm vmx flags       :
> > tsc_offset vtpr
> >
> > I did quick check with 5.9 (distro kernel) and it works,
> > but VM performance seems extremely impacted. 5.8 works fine.
> >
> > Back to 5.10 issue: it's problematic since 5.10-rc1 and I have no
> > luck with bisecting (machine doesn't boot).
> >
> > TIA, Z.


--MP_/QU7aE8.OaV7PS6RjHOBeIme
Content-Type: application/octet-stream; name=vmxcap-out
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=vmxcap-out

QmFzaWMgVk1YIEluZm9ybWF0aW9uCiAgSGV4OiAweDFhMDQwMDAwMDAwMDA3CiAgUmV2aXNpb24g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA3CiAgVk1DUyBzaXplICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAxMDI0CiAgVk1DUyByZXN0cmljdGVkIHRvIDMyIGJpdCBhZGRy
ZXNzZXMgICAgICBubwogIER1YWwtbW9uaXRvciBzdXBwb3J0ICAgICAgICAgICAgICAgICAgICAg
eWVzCiAgVk1DUyBtZW1vcnkgdHlwZSAgICAgICAgICAgICAgICAgICAgICAgICA2CiAgSU5TL09V
VFMgaW5zdHJ1Y3Rpb24gaW5mb3JtYXRpb24gICAgICAgICBubwogIElBMzJfVk1YX1RSVUVfKl9D
VExTIHN1cHBvcnQgICAgICAgICAgICAgbm8KcGluLWJhc2VkIGNvbnRyb2xzCiAgRXh0ZXJuYWwg
aW50ZXJydXB0IGV4aXRpbmcgICAgICAgICAgICAgICB5ZXMKICBOTUkgZXhpdGluZyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHllcwogIFZpcnR1YWwgTk1JcyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgbm8KICBBY3RpdmF0ZSBWTVgtcHJlZW1wdGlvbiB0aW1lciAgICAgICAgICAg
IG5vCiAgUHJvY2VzcyBwb3N0ZWQgaW50ZXJydXB0cyAgICAgICAgICAgICAgICBubwpwcmltYXJ5
IHByb2Nlc3Nvci1iYXNlZCBjb250cm9scwogIEludGVycnVwdCB3aW5kb3cgZXhpdGluZyAgICAg
ICAgICAgICAgICAgeWVzCiAgVXNlIFRTQyBvZmZzZXR0aW5nICAgICAgICAgICAgICAgICAgICAg
ICB5ZXMKICBITFQgZXhpdGluZyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHllcwogIElO
VkxQRyBleGl0aW5nICAgICAgICAgICAgICAgICAgICAgICAgICAgeWVzCiAgTVdBSVQgZXhpdGlu
ZyAgICAgICAgICAgICAgICAgICAgICAgICAgICB5ZXMKICBSRFBNQyBleGl0aW5nICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHllcwogIFJEVFNDIGV4aXRpbmcgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgeWVzCiAgQ1IzLWxvYWQgZXhpdGluZyAgICAgICAgICAgICAgICAgICAgICAgICBm
b3JjZWQKICBDUjMtc3RvcmUgZXhpdGluZyAgICAgICAgICAgICAgICAgICAgICAgIGZvcmNlZAog
IENSOC1sb2FkIGV4aXRpbmcgICAgICAgICAgICAgICAgICAgICAgICAgeWVzCiAgQ1I4LXN0b3Jl
IGV4aXRpbmcgICAgICAgICAgICAgICAgICAgICAgICB5ZXMKICBVc2UgVFBSIHNoYWRvdyAgICAg
ICAgICAgICAgICAgICAgICAgICAgIHllcwogIE5NSS13aW5kb3cgZXhpdGluZyAgICAgICAgICAg
ICAgICAgICAgICAgbm8KICBNT1YtRFIgZXhpdGluZyAgICAgICAgICAgICAgICAgICAgICAgICAg
IHllcwogIFVuY29uZGl0aW9uYWwgSS9PIGV4aXRpbmcgICAgICAgICAgICAgICAgeWVzCiAgVXNl
IEkvTyBiaXRtYXBzICAgICAgICAgICAgICAgICAgICAgICAgICB5ZXMKICBNb25pdG9yIHRyYXAg
ZmxhZyAgICAgICAgICAgICAgICAgICAgICAgIG5vCiAgVXNlIE1TUiBiaXRtYXBzICAgICAgICAg
ICAgICAgICAgICAgICAgICB5ZXMKICBNT05JVE9SIGV4aXRpbmcgICAgICAgICAgICAgICAgICAg
ICAgICAgIHllcwogIFBBVVNFIGV4aXRpbmcgICAgICAgICAgICAgICAgICAgICAgICAgICAgeWVz
CiAgQWN0aXZhdGUgc2Vjb25kYXJ5IGNvbnRyb2wgICAgICAgICAgICAgICBubwpzZWNvbmRhcnkg
cHJvY2Vzc29yLWJhc2VkIGNvbnRyb2xzCiAgVmlydHVhbGl6ZSBBUElDIGFjY2Vzc2VzICAgICAg
ICAgICAgICAgICBubwogIEVuYWJsZSBFUFQgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
bm8KICBEZXNjcmlwdG9yLXRhYmxlIGV4aXRpbmcgICAgICAgICAgICAgICAgIG5vCiAgRW5hYmxl
IFJEVFNDUCAgICAgICAgICAgICAgICAgICAgICAgICAgICBubwogIFZpcnR1YWxpemUgeDJBUElD
IG1vZGUgICAgICAgICAgICAgICAgICAgbm8KICBFbmFibGUgVlBJRCAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgIG5vCiAgV0JJTlZEIGV4aXRpbmcgICAgICAgICAgICAgICAgICAgICAgICAg
ICBubwogIFVucmVzdHJpY3RlZCBndWVzdCAgICAgICAgICAgICAgICAgICAgICAgbm8KICBBUElD
IHJlZ2lzdGVyIGVtdWxhdGlvbiAgICAgICAgICAgICAgICAgIG5vCiAgVmlydHVhbCBpbnRlcnJ1
cHQgZGVsaXZlcnkgICAgICAgICAgICAgICBubwogIFBBVVNFLWxvb3AgZXhpdGluZyAgICAgICAg
ICAgICAgICAgICAgICAgbm8KICBSRFJBTkQgZXhpdGluZyAgICAgICAgICAgICAgICAgICAgICAg
ICAgIG5vCiAgRW5hYmxlIElOVlBDSUQgICAgICAgICAgICAgICAgICAgICAgICAgICBubwogIEVu
YWJsZSBWTSBmdW5jdGlvbnMgICAgICAgICAgICAgICAgICAgICAgbm8KICBWTUNTIHNoYWRvd2lu
ZyAgICAgICAgICAgICAgICAgICAgICAgICAgIG5vCiAgRW5hYmxlIEVOQ0xTIGV4aXRpbmcgICAg
ICAgICAgICAgICAgICAgICBubwogIFJEU0VFRCBleGl0aW5nICAgICAgICAgICAgICAgICAgICAg
ICAgICAgbm8KICBFbmFibGUgUE1MICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5vCiAg
RVBULXZpb2xhdGlvbiAjVkUgICAgICAgICAgICAgICAgICAgICAgICBubwogIENvbmNlYWwgbm9u
LXJvb3Qgb3BlcmF0aW9uIGZyb20gUFQgICAgICAgbm8KICBFbmFibGUgWFNBVkVTL1hSU1RPUlMg
ICAgICAgICAgICAgICAgICAgIG5vCiAgTW9kZS1iYXNlZCBleGVjdXRlIGNvbnRyb2wgKFhTL1hV
KSAgICAgICBubwogIFN1Yi1wYWdlIHdyaXRlIHBlcm1pc3Npb25zICAgICAgICAgICAgICAgbm8K
ICBHUEEgdHJhbnNsYXRpb24gZm9yIFBUICAgICAgICAgICAgICAgICAgIG5vCiAgVFNDIHNjYWxp
bmcgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBubwogIFVzZXIgd2FpdCBhbmQgcGF1c2Ug
ICAgICAgICAgICAgICAgICAgICAgbm8KICBFTkNMViBleGl0aW5nICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIG5vClZNLUV4aXQgY29udHJvbHMKICBTYXZlIGRlYnVnIGNvbnRyb2xzICAgICAg
ICAgICAgICAgICAgICAgIGZvcmNlZAogIEhvc3QgYWRkcmVzcy1zcGFjZSBzaXplICAgICAgICAg
ICAgICAgICAgeWVzCiAgTG9hZCBJQTMyX1BFUkZfR0xPQkFMX0NUUkwgICAgICAgICAgICAgICBu
bwogIEFja25vd2xlZGdlIGludGVycnVwdCBvbiBleGl0ICAgICAgICAgICAgeWVzCiAgU2F2ZSBJ
QTMyX1BBVCAgICAgICAgICAgICAgICAgICAgICAgICAgICBubwogIExvYWQgSUEzMl9QQVQgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbm8KICBTYXZlIElBMzJfRUZFUiAgICAgICAgICAgICAg
ICAgICAgICAgICAgIG5vCiAgTG9hZCBJQTMyX0VGRVIgICAgICAgICAgICAgICAgICAgICAgICAg
ICBubwogIFNhdmUgVk1YLXByZWVtcHRpb24gdGltZXIgdmFsdWUgICAgICAgICAgbm8KICBDbGVh
ciBJQTMyX0JORENGR1MgICAgICAgICAgICAgICAgICAgICAgIG5vCiAgQ29uY2VhbCBWTSBleGl0
cyBmcm9tIFBUICAgICAgICAgICAgICAgICBubwogIENsZWFyIElBMzJfUlRJVF9DVEwgICAgICAg
ICAgICAgICAgICAgICAgbm8KVk0tRW50cnkgY29udHJvbHMKICBMb2FkIGRlYnVnIGNvbnRyb2xz
ICAgICAgICAgICAgICAgICAgICAgIGZvcmNlZAogIElBLTMyZSBtb2RlIGd1ZXN0ICAgICAgICAg
ICAgICAgICAgICAgICAgeWVzCiAgRW50cnkgdG8gU01NICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB5ZXMKICBEZWFjdGl2YXRlIGR1YWwtbW9uaXRvciB0cmVhdG1lbnQgICAgICAgIHllcwog
IExvYWQgSUEzMl9QRVJGX0dMT0JBTF9DVFJMICAgICAgICAgICAgICAgbm8KICBMb2FkIElBMzJf
UEFUICAgICAgICAgICAgICAgICAgICAgICAgICAgIG5vCiAgTG9hZCBJQTMyX0VGRVIgICAgICAg
ICAgICAgICAgICAgICAgICAgICBubwogIExvYWQgSUEzMl9CTkRDRkdTICAgICAgICAgICAgICAg
ICAgICAgICAgbm8KICBDb25jZWFsIFZNIGVudHJpZXMgZnJvbSBQVCAgICAgICAgICAgICAgIG5v
CiAgTG9hZCBJQTMyX1JUSVRfQ1RMICAgICAgICAgICAgICAgICAgICAgICBubwpNaXNjZWxsYW5l
b3VzIGRhdGEKICBIZXg6IDB4NDAzYzAKICBWTVgtcHJlZW1wdGlvbiB0aW1lciBzY2FsZSAobG9n
MikgICAgICAgIDAKICBTdG9yZSBFRkVSLkxNQSBpbnRvIElBLTMyZSBtb2RlIGd1ZXN0IGNvbnRy
b2wgbm8KICBITFQgYWN0aXZpdHkgc3RhdGUgICAgICAgICAgICAgICAgICAgICAgIHllcwogIFNo
dXRkb3duIGFjdGl2aXR5IHN0YXRlICAgICAgICAgICAgICAgICAgeWVzCiAgV2FpdC1mb3ItU0lQ
SSBhY3Rpdml0eSBzdGF0ZSAgICAgICAgICAgICB5ZXMKICBQVCBpbiBWTVggb3BlcmF0aW9uICAg
ICAgICAgICAgICAgICAgICAgIG5vCiAgSUEzMl9TTUJBU0Ugc3VwcG9ydCAgICAgICAgICAgICAg
ICAgICAgICBubwogIE51bWJlciBvZiBDUjMtdGFyZ2V0IHZhbHVlcyAgICAgICAgICAgICAgNAog
IE1TUi1sb2FkL3N0b3JlIGNvdW50IHJlY29tbWVuZGF0aW9uICAgICAgMAogIElBMzJfU01NX01P
TklUT1JfQ1RMWzJdIGNhbiBiZSBzZXQgdG8gMSAgbm8KICBWTVdSSVRFIHRvIFZNLWV4aXQgaW5m
b3JtYXRpb24gZmllbGRzICAgIG5vCiAgSW5qZWN0IGV2ZW50IHdpdGggaW5zbiBsZW5ndGg9MCAg
ICAgICAgICBubwogIE1TRUcgcmV2aXNpb24gaWRlbnRpZmllciAgICAgICAgICAgICAgICAgMApW
UElEIGFuZCBFUFQgY2FwYWJpbGl0aWVzCiAgSGV4OiAweDAKICBFeGVjdXRlLW9ubHkgRVBUIHRy
YW5zbGF0aW9ucyAgICAgICAgICAgIG5vCiAgUGFnZS13YWxrIGxlbmd0aCA0ICAgICAgICAgICAg
ICAgICAgICAgICBubwogIFBhZ2luZy1zdHJ1Y3R1cmUgbWVtb3J5IHR5cGUgVUMgICAgICAgICAg
bm8KICBQYWdpbmctc3RydWN0dXJlIG1lbW9yeSB0eXBlIFdCICAgICAgICAgIG5vCiAgMk1CIEVQ
VCBwYWdlcyAgICAgICAgICAgICAgICAgICAgICAgICAgICBubwogIDFHQiBFUFQgcGFnZXMgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgbm8KICBJTlZFUFQgc3VwcG9ydGVkICAgICAgICAgICAg
ICAgICAgICAgICAgIG5vCiAgRVBUIGFjY2Vzc2VkIGFuZCBkaXJ0eSBmbGFncyAgICAgICAgICAg
ICBubwogIEFkdmFuY2VkIFZNLWV4aXQgaW5mb3JtYXRpb24gZm9yIEVQVCB2aW9sYXRpb25zIG5v
CiAgU2luZ2xlLWNvbnRleHQgSU5WRVBUICAgICAgICAgICAgICAgICAgICBubwogIEFsbC1jb250
ZXh0IElOVkVQVCAgICAgICAgICAgICAgICAgICAgICAgbm8KICBJTlZWUElEIHN1cHBvcnRlZCAg
ICAgICAgICAgICAgICAgICAgICAgIG5vCiAgSW5kaXZpZHVhbC1hZGRyZXNzIElOVlZQSUQgICAg
ICAgICAgICAgICBubwogIFNpbmdsZS1jb250ZXh0IElOVlZQSUQgICAgICAgICAgICAgICAgICAg
bm8KICBBbGwtY29udGV4dCBJTlZWUElEICAgICAgICAgICAgICAgICAgICAgIG5vCiAgU2luZ2xl
LWNvbnRleHQtcmV0YWluaW5nLWdsb2JhbHMgSU5WVlBJRCBubwpWTSBGdW5jdGlvbnMKICBIZXg6
IDB4MAogIEVQVFAgU3dpdGNoaW5nICAgICAgICAgICAgICAgICAgICAgICAgICAgbm8K

--MP_/QU7aE8.OaV7PS6RjHOBeIme--
