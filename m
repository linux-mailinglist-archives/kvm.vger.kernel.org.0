Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F565AB573
	for <lists+kvm@lfdr.de>; Fri,  6 Sep 2019 12:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390019AbfIFKKe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 6 Sep 2019 06:10:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49808 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389449AbfIFKKd (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 6 Sep 2019 06:10:33 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 345163084288;
        Fri,  6 Sep 2019 10:10:33 +0000 (UTC)
Received: from thuth.remote.csb (ovpn-116-159.ams2.redhat.com [10.36.116.159])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D616D5D6A9;
        Fri,  6 Sep 2019 10:10:28 +0000 (UTC)
Subject: Re: [kvm-unit-tests PATCH] travis.yml: Enable running of tests with
 TCG
To:     David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Drew Jones <drjones@redhat.com>,
        Laurent Vivier <lvivier@redhat.com>,
        =?UTF-8?Q?Alex_Benn=c3=a9e?= <alex.bennee@linaro.org>
References: <20190830184509.15240-1-thuth@redhat.com>
 <b94ed46f-7e50-daae-321c-c01b473ca0ea@redhat.com>
 <3cc8a3c5-c86f-5b06-bff0-753ef628c7e3@redhat.com>
 <4a9fe8b4-053a-80db-8631-b9f3fd269c82@redhat.com>
From:   Thomas Huth <thuth@redhat.com>
Openpgp: preference=signencrypt
Autocrypt: addr=thuth@redhat.com; prefer-encrypt=mutual; keydata=
 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
Organization: Red Hat
Message-ID: <336604c9-f9b8-2c1a-c6ea-4f9756881d21@redhat.com>
Date:   Fri, 6 Sep 2019 12:10:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4a9fe8b4-053a-80db-8631-b9f3fd269c82@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.40]); Fri, 06 Sep 2019 10:10:33 +0000 (UTC)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/09/2019 12.02, David Hildenbrand wrote:
> On 06.09.19 11:54, Thomas Huth wrote:
>> On 06/09/2019 11.43, David Hildenbrand wrote:
>>> On 30.08.19 20:45, Thomas Huth wrote:
>>>> Currently the tests at the end of the .travis.yml script are ignored,
>>>> since we can not use KVM in the Travis containers. But we can actually
>>>> run of some of the kvm-unit-tests with TCG instead, to make sure that
>>>> the binaries are not completely broken.
>>>> Thus introduce a new TESTS variable that lists the tests which we can
>>>> run with TCG. Unfortunately, the ppc64 and s390x QEMUs in Ubuntu also
>>>> need some extra love: The ppc64 version only works with the additional
>>>> "cap-htm=off" setting. And the s390x package lacks the firmware and
>>>> refuses to work unless we provide a fake firmware file here. Any file
>>>> works since the firmware is skipped when "-kernel" is used, so we can
>>>> simply use one of the pre-existing files in the source tree.
>>>>
>>>> Signed-off-by: Thomas Huth <thuth@redhat.com>
>>>> ---
>>>>  .travis.yml | 19 ++++++++++++++++++-
>>>>  1 file changed, 18 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/.travis.yml b/.travis.yml
>>>> index a4a165d..6c14953 100644
>>>> --- a/.travis.yml
>>>> +++ b/.travis.yml
>>>> @@ -20,24 +20,40 @@ env:
>>>>    matrix:
>>>>      - CONFIG=""
>>>>        BUILD_DIR="."
>>>> +      TESTS="vmexit_cpuid vmexit_mov_from_cr8 vmexit_mov_to_cr8 vmexit_ipi
>>>> +             vmexit_ple_round_robin vmexit_tscdeadline vmexit_tscdeadline_immed"
>>>>      - CONFIG=""
>>>>        BUILD_DIR="x86-builddir"
>>>> +      TESTS="ioapic-split ioapic smptest smptest3 eventinj msr port80 syscall
>>>> +             tsc rmap_chain umip intel_iommu vmexit_inl_pmtimer vmexit_ipi_halt"
>>>>      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
>>>>        BUILD_DIR="."
>>>> +      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
>>>>      - CONFIG="--arch=arm --cross-prefix=arm-linux-gnueabihf-"
>>>>        BUILD_DIR="arm-buildir"
>>>> +      TESTS="pci-test pmu gicv2-active gicv3-active psci selftest-setup"
>>>>      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
>>>>        BUILD_DIR="."
>>>> +      TESTS="selftest-vectors-kernel selftest-vectors-user selftest-smp"
>>>>      - CONFIG="--arch=arm64 --cross-prefix=aarch64-linux-gnu-"
>>>>        BUILD_DIR="arm64-buildir"
>>>> +      TESTS="pci-test pmu gicv2-active gicv3-active psci timer selftest-setup"
>>>>      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
>>>>        BUILD_DIR="."
>>>> +      TESTS="spapr_hcall emulator rtas-set-time-of-day"
>>>> +      ACCEL="tcg,cap-htm=off"
>>>>      - CONFIG="--arch=ppc64 --endian=little --cross-prefix=powerpc64le-linux-gnu-"
>>>>        BUILD_DIR="ppc64le-buildir"
>>>> +      TESTS="rtas-get-time-of-day rtas-get-time-of-day-base"
>>>> +      ACCEL="tcg,cap-htm=off"
>>>>      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>>>>        BUILD_DIR="."
>>>> +      TESTS="diag10 diag308"
>>>> +      ACCEL="tcg,firmware=s390x/run"
>>>>      - CONFIG="--arch=s390x --cross-prefix=s390x-linux-gnu-"
>>>>        BUILD_DIR="s390x-builddir"
>>>> +      TESTS="sieve"
>>>> +      ACCEL="tcg,firmware=s390x/run"
>>>
>>> What about the other s390x tests? (is the QEMU binary too old to make
>>> them pass?)
>>
>> Yes. All the others are failing.
> 
> So the QEMU versions is that old that not even the selftest works? :/ Is
> there a more recent distribution we can use?

I already tested with "dist: bionic", and that's all I've got to get
working there. According to
https://docs.travis-ci.com/user/reference/overview/ there are no newer
distros available yet.

>>> The issue with TCG is that you can easily get false negatives in case
>>> the QEMU binary changes (e.g., new Ubuntu release).
>>
>> That should not be a big deal, since the Ubuntu version is locked to a
>> certain release in the travis.yml file. So we should not get a new
>> version of QEMU by accident here, only if we explicitly update the
>> "dist:" line in the yml file.
> 
> Or if the dist updates QEMU. Not sure how often that happens in QEMU.
> (but as not even the selfest passes, it cannot really get any worse :D )

I don't think that they will update the QEMU version during the
life-cycle of a certain release - they likely only apply some bug fixes,
which won't change much of the behavior here. Remember that
qemu-system-s390x is almost completely broken in these Ubuntu versions
since they do not ship the firmware image in the package. I only got
something running by luck with that "firmware=..." trick.

 Thomas

