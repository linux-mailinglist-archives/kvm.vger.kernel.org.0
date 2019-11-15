Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC251FDD4D
	for <lists+kvm@lfdr.de>; Fri, 15 Nov 2019 13:19:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbfKOMTw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Nov 2019 07:19:52 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:46239 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727196AbfKOMTw (ORCPT
        <rfc822;kvm@vger.kernel.org>); Fri, 15 Nov 2019 07:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573820391;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=O3GG6LSfMSc0uDcpwxg2S/arXIPizB1hEdSUupeQYTo=;
        b=dBCNoYgRtnEZ1TB6kKJoXftXu9ovc78EIwRzVkg9mfdhYoMNhh6pZvBO0P8C4VUKFDqEm0
        OjQXCs83/pm/WKvWaQO7SVZNF2JZXRlpWZb7gJ/7RQXT01aAx+x0dfKON3c3fG4loRYTvs
        QN8hHcZRO55FqyWqtj42nOMtj/+M50g=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-ltkL6q0GPS20VOmS_axbbg-1; Fri, 15 Nov 2019 07:19:49 -0500
Received: by mail-wm1-f71.google.com with SMTP id t203so5916493wmt.7
        for <kvm@vger.kernel.org>; Fri, 15 Nov 2019 04:19:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g3j6fYP04WXYbKX6Zu4vTpJrhgEiu4HzYogrXdMrkl8=;
        b=KtCy36vpHCeCDxNz83y+9bvzwEQaejsHOcHsFsY8ex+hJQFemwE9pKHdgOpZ+Zxoyx
         sh03Ix5EOKKCE5VUl4mRPH++kw7LGSX1XbyU1+vEhr7unJPc9pMfyMrNcCtrMLn6oxPs
         cyMmE7+/qfTlLc78hfYMfZt4O9IU9ZZX6F3LbofptkPBD1A8/1Rw++5KQ48zuCgIKKxQ
         I6c4Qa8lvbVYxSHi5QNFNnmbwOW9shs3IIWRxyfWjHk4k9SpPEE/nBp5BhBqvU+JNbT1
         zBNlDZQ/f3LwIKBkZa+LEMhK4SCWTVYeCiAALSTM5/ziHG0hkMwBLRFzCS8nPuA6TvXz
         3Ckw==
X-Gm-Message-State: APjAAAUHBUBDjN/7WboRApWrTwwwcM7LIpIzZfRjbORRYk1Q0zi63pTv
        nznGLjIUZFyjhGp/c9bRDrTRPjVP2Tm+W8/2ZsdWsmONM2e4jRlpQt3t/4jIqtLkmNxFLaoMQY+
        GopCBE+eg6hdL
X-Received: by 2002:a05:6000:18e:: with SMTP id p14mr14828740wrx.98.1573820388625;
        Fri, 15 Nov 2019 04:19:48 -0800 (PST)
X-Google-Smtp-Source: APXvYqz00eXFcdwef+s7n1th2kbDcU9QKzHIXOJTe4+ltNCB75yv1pu3Tc+C4YeRIY8LimBdkqU3Jw==
X-Received: by 2002:a05:6000:18e:: with SMTP id p14mr14828715wrx.98.1573820388270;
        Fri, 15 Nov 2019 04:19:48 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:a15b:f753:1ac4:56dc? ([2001:b07:6468:f312:a15b:f753:1ac4:56dc])
        by smtp.gmail.com with ESMTPSA id t185sm10991373wmf.45.2019.11.15.04.19.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Nov 2019 04:19:47 -0800 (PST)
Subject: Re: [PATCH v5 0/8] KVM: nVMX: Add full nested support for "load
 IA32_PERF_GLOBAL_CTRL" VM-{Entry,Exit} control
To:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Jim Mattson <jmattson@google.com>, Peter Shier <pshier@google.com>,
        Krish Sadhukhan <krish.sadhukhan@oracle.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20191114001722.173836-1-oupton@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <828732bd-4b22-6ae8-7dd9-a8ec54c927ec@redhat.com>
Date:   Fri, 15 Nov 2019 13:19:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191114001722.173836-1-oupton@google.com>
Content-Language: en-US
X-MC-Unique: ltkL6q0GPS20VOmS_axbbg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/11/19 01:17, Oliver Upton wrote:
> [v1] https://lore.kernel.org/r/20190828234134.132704-1-oupton@google.com
> [v2] https://lore.kernel.org/r/20190903213044.168494-1-oupton@google.com
> [v3] https://lore.kernel.org/r/20190903215801.183193-1-oupton@google.com
> [v4] https://lore.kernel.org/r/20190906210313.128316-1-oupton@google.com
>=20
> v1 =3D> v2:
>  - Add Krish's Co-developed-by and Signed-off-by tags.
>  - Fix minor nit to kvm-unit-tests to use 'host' local variable
>    throughout test_load_pgc()
>  - Teach guest_state_test_main() to check guest state from within nested
>    VM
>  - Update proposed tests to use guest/host state checks, wherein the
>    value is checked from MSR_CORE_PERF_GLOBAL_CTRL.
>  - Changelog line wrapping
>=20
> v2 =3D> v3:
>  - Remove the value unchanged condition from
>    kvm_is_valid_perf_global_ctrl
>  - Add line to changelog for patch 3/8
>=20
> v3 =3D> v4:
>  - Allow tests to set the guest func multiple times
>  - Style fixes throughout kvm-unit-tests patches, per Krish's review
>=20
> v4 =3D> v5:
>  - Rebased kernel and kvm-unit-tests patches
>  - Reordered and reworked patches to now WARN on a failed
>    kvm_set_msr()
>  - Dropped patch to alow resetting guest in kvm-unit-tests, as the
>    functionality is no longer needed.
>=20
> This patchset exposes the "load IA32_PERF_GLOBAL_CTRL" to guests for nest=
ed
> VM-entry and VM-exit. There already was some existing code that supported
> the VM-exit ctrl, though it had an issue and was not exposed to the guest
> anyway. These patches are based on the original set that Krish Sadhukhan
> sent out earlier this year.
>=20
> Oliver Upton (6):
>   KVM: nVMX: Expose load IA32_PERF_GLOBAL_CTRL VM-{Entry,Exit} control
>   KVM: nVMX: Load GUEST_IA32_PERF_GLOBAL_CTRL MSR on VM-Entry
>   KVM: nVMX: Use kvm_set_msr to load IA32_PERF_GLOBAL_CTRL on VM-Exit
>   KVM: nVMX: Check HOST_IA32_PERF_GLOBAL_CTRL on VM-Entry
>   KVM: nVMX: Check GUEST_IA32_PERF_GLOBAL_CTRL on VM-Entry
>   KVM: VMX: Add helper to check reserved bits in IA32_PERF_GLOBAL_CTRL
>=20
>  arch/x86/kvm/pmu.h           |  6 ++++++
>  arch/x86/kvm/vmx/nested.c    | 51 ++++++++++++++++++++++++++++++++++++++=
+++++++++++--
>  arch/x86/kvm/vmx/nested.h    |  1 +
>  arch/x86/kvm/vmx/pmu_intel.c |  5 ++++-
>=20

Queued, thanks.

But I had to squash this in patch 8:

diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
index 3129385..b6233ae 100644
--- a/x86/vmx_tests.c
+++ b/x86/vmx_tests.c
@@ -7161,6 +7161,7 @@ static void test_perf_global_ctrl(u32 nr, const
char *name, u32 ctrl_nr,
 =09=09report_prefix_pop();
 =09}

+=09data->enabled =3D false;
 =09report_prefix_pop();
 =09vmcs_write(ctrl_nr, ctrl_saved);
 =09vmcs_write(nr, pgc_saved);

and I'm not sure about how this could have worked for you.

Paolo

