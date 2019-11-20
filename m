Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11FC6104655
	for <lists+kvm@lfdr.de>; Wed, 20 Nov 2019 23:17:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbfKTWRZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Nov 2019 17:17:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:31225 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725936AbfKTWRZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Nov 2019 17:17:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574288243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:openpgp:openpgp;
        bh=H8HIqkTm0TUODDBjgSmJKMBaP+hcw/d3WGfCVEEZ65o=;
        b=T21T93hYJPh/8lFhNeYn/4FHhAM1QOvX4OtX7yEG2QIFcZxz6z7DxfyGWWwVUQb9WHwE8K
        2k3sjP4wwk2EyKDpw6qxWRoDoaUoEGKWJaGVWuPiN7t6nsyqlfW8IrfPOVMrqxTwd3tLfR
        +j3E1uIwuAMZGRxnwEYS3Va4WZiLFRE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-li1F_6e6NgmuKB2U2Z1jnw-1; Wed, 20 Nov 2019 17:17:22 -0500
Received: by mail-wm1-f71.google.com with SMTP id 2so843197wmd.3
        for <kvm@vger.kernel.org>; Wed, 20 Nov 2019 14:17:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0JBkjaZI5HtXho+Pc072zURILqnqrUJDw1qJ9nl9oY0=;
        b=sD4Rn6LKs4W26N6sXN04gnm/yXAVW7FpXXgefqP8dvexMaUc20gbhwBSqLOBCcVvZ8
         boCpAuaXinzmO0nXz1kDT9e/q7rVXgqXPVAHLvvGPBmyDgk28Vv5rAJ9YMgxC4U7BH/e
         ArYwl1XB4y88GneVDw6dnEsfLVqHJyN+i1IgNPdoLUHBU2s+V+atZ/6kZdYyBYzLBI6Z
         c7E6adMuEZAQ65fqQ1Jpj6QfmQLFq9fmqrd64nQcNstzwYzj5IhXLpZaQhmEBbyV9STj
         p5z5kXyzNmnCr/c7VjcpPBu3DDtlGifhcmuzDf1gEC+KVU1Ayfm5kP4BgTT+xuMiE9CW
         D2hQ==
X-Gm-Message-State: APjAAAWxzOkE0VIu9N3N0l4Wds4NJ9P3OoDfT0AoqZcoFn/f9+bnEIh1
        0PR4jre4dMvoXcrhNdW8/mr3GQme90WdVkgHH1Ev7pmRhi+SBIysB/U6yWoNzgCKAZbOSEzDWtS
        Rp0Cq+fTUBAVD
X-Received: by 2002:a5d:6a08:: with SMTP id m8mr6292766wru.52.1574288240848;
        Wed, 20 Nov 2019 14:17:20 -0800 (PST)
X-Google-Smtp-Source: APXvYqzgHRIPYXzVu071CpWjajKVV2vlOlAPUxAZP+HrxQPN1QYHI2MzYIu43XYMkkYZQnZgrof1iQ==
X-Received: by 2002:a5d:6a08:: with SMTP id m8mr6292744wru.52.1574288240566;
        Wed, 20 Nov 2019 14:17:20 -0800 (PST)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id w11sm914454wra.83.2019.11.20.14.17.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2019 14:17:20 -0800 (PST)
Subject: Re: [PATCH kvm-unit-tests] x86: add tests for MSR_IA32_TSX_CTRL
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>
References: <1574098136-48779-1-git-send-email-pbonzini@redhat.com>
 <CALMp9eQERkb76LvGDRQbJafK75fo=7X6xyBb+PfwfzGaY5_qeA@mail.gmail.com>
 <710cd64e-b74e-0651-2045-156ba47ce04b@redhat.com>
 <CALMp9eTnTOsch_fjSc92Jo+DoWE1AHwx04Vij7KKb4-Fy6nWEA@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f5fcab3a-21f3-8025-5773-1bed4ef75f13@redhat.com>
Date:   Wed, 20 Nov 2019 23:17:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <CALMp9eTnTOsch_fjSc92Jo+DoWE1AHwx04Vij7KKb4-Fy6nWEA@mail.gmail.com>
Content-Language: en-US
X-MC-Unique: li1F_6e6NgmuKB2U2Z1jnw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/11/19 23:16, Jim Mattson wrote:
> On Wed, Nov 20, 2019 at 10:43 AM Paolo Bonzini <pbonzini@redhat.com> wrot=
e:
>>
>> On 20/11/19 19:13, Jim Mattson wrote:
>>> On Mon, Nov 18, 2019 at 9:29 AM Paolo Bonzini <pbonzini@redhat.com> wro=
te:
>>>>
>>>> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
>>>
>>> I had to add tsx-ctrl to x86/unittests.cfg:
>>>
>>> +[tsx-ctrl]
>>> +file =3D tsx-ctrl.flat
>>> +extra_params =3D -cpu host
>>> +groups =3D tsx-ctrl
>>> +
>>>
>>> With qemu 4.1, I get:
>>>
>>> timeout -k 1s --foreground 90s /root/kvm-unit-tests/deps/qemu.sh
>>> -nodefaults -device pc-testdev -device
>>> isa-debug-exit,iobase=3D0xf4,iosize=3D0x4 -vnc none -serial stdio -devi=
ce
>>> pci-testdev -machine accel=3Dkvm -kernel x86/tsx-ctrl.flat -smp 1 -cpu
>>> host # -initrd /tmp/tmp.7wOLppNO4W
>>> enabling apic
>>> SKIP: TSX_CTRL not available
>>>
>>> Maybe qemu is masking off ARCH_CAP_TSX_CTRL_MSR? I haven't investigated=
.
>>
>> Yes, you need "-cpu host,migratable=3Doff" if you don't have the
>> corresponding QEMU patches (which I've only sent today, but just
>> allowing unmigratable features in extra_params will be okay for you to
>> test).
>=20
> Okay, that works!
>=20
> enabling apic
> PASS: TSX_CTRL should be 0
> PASS: Transactions do not abort
> PASS: TSX_CTRL hides RTM
> PASS: TSX_CTRL hides HLE
> PASS: TSX_CTRL=3D0 unhides RTM
> PASS: TSX_CTRL causes transactions to abort
> PASS: TSX_CTRL=3D0 causes transactions to succeed
> SUMMARY: 7 tests

Great, should I merge the patches in 5.5 with your Tested-by annotation?

Paolo

> ...and, for the vmexit test...
>=20
> enabling apic
> paging enabled
> cr0 =3D 80010011
> cr3 =3D 61e000
> cr4 =3D 20
> pci-testdev at 0x10 membar febff000 iobar c000
> wr_tsx_ctrl_msr 2058
>=20

