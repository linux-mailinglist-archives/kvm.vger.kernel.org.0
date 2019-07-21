Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EA196F255
	for <lists+kvm@lfdr.de>; Sun, 21 Jul 2019 11:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbfGUJFk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 21 Jul 2019 05:05:40 -0400
Received: from mout.web.de ([212.227.17.12]:55091 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725851AbfGUJFk (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 21 Jul 2019 05:05:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1563699927;
        bh=B2EUR8gua5S+sAYR7/1h849NJDFz7hP/0DLNVS+yFyU=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=c665SBM1XzDkoMC2W9xpRUzRaJOFITMl0KH/WzGi7CzFlfTg7S4dEsND+IKU/VydK
         FH3H0v2qTmiJkR9lEFn3gHjc7OwyZ4q775o6N9F49lMOWB82ADsCAZZYqmEtYawltS
         EYWXWglxlgi+cezdIilFnsCtfpunkj8fb2OCttIk=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb102
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LuuS5-1iXZKw2FNZ-0103q3; Sun, 21
 Jul 2019 11:05:27 +0200
Subject: Re: KVM_SET_NESTED_STATE not yet stable
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Ralf Ramsauer <ralf.ramsauer@oth-regensburg.de>,
        "Raslan, KarimAllah" <karahmed@amazon.de>,
        "jmattson@google.com" <jmattson@google.com>,
        "liran.alon@oracle.com" <liran.alon@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
References: <9eb4dd9f-65e5-627d-b288-e5fe8ade0963@siemens.com>
 <1562772280.18613.25.camel@amazon.de>
 <f1936ed9-e41b-4d36-50bb-3956434d993c@siemens.com>
 <cfd86643-dbac-3a69-9faf-03eaa8aee6a1@siemens.com>
 <47e8c75d-f39a-89f8-940f-d05a9bc91899@oth-regensburg.de>
 <e81b5c46-1700-33d2-4db7-a887e339d4ac@redhat.com>
 <68880241-ff91-1cb1-1bd5-ab5d2e307bec@redhat.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <c44c9d59-3ef0-cda9-fd4a-6e6c67fd9e71@web.de>
Date:   Sun, 21 Jul 2019 11:05:26 +0200
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12)
 Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
In-Reply-To: <68880241-ff91-1cb1-1bd5-ab5d2e307bec@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rJTpkl0xOG/9M4JH4FEBat/avPfQMsnHR1CEfxxgjbtfyaT6Yzg
 fxP0B/MKBDUIjSFhjWwtutbpN93XaSPF42GR0q1IafjZ3eJd/KX4q5uHOOPy8NxN0I7fv2o
 AUSTQwGGOJk2YDo4HMSdHGaM44LUm2Kyl9mQbglb4W6WwqLWs4Zo8pfFyUjOQnVsNGUdDgt
 /E/NuogfiVcF7Rneh3gmg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sQ3rPPAORkI=:U8J6J6RgBrzR3S35ZQBpsN
 DDoTHddGnsrG7TkWOh0TfTNPAvJkjRtV8Lelvae8lTjDODnZPWJevwmN9htEG26EPlPy0bIZl
 cax84ON/+chdLHRh4Xm8DHMLbXx27TPSEGrGsg8OyHCUgRfHHyWJlaYZhgW+mQr5TAmplIixp
 ReXbMRdoYSHOeTcUM0NtmrGEmi/yOYCGYytEKGbwrJ0ZK8u/0TyBtpvbVU3HQM/zYT2VwfGcD
 rPJ+IlLPQI43tPr8IAg3+F78jiP0fVqHwfK9CDcAf2FR6xsZ3jiU+m3RBUcxqwveuJoNO7sLa
 YuO4hrJIdU7mTuatsiMtxRkADwBY6iUwEHqfC94vmNeSWosaG2Tmmq+WFSoVyohC7deTx3Nkf
 MG9yHJg5WNA1h3PHAiWS8mifdDAFPUnH5AsJswcAJ71HCD1uUfMP3Us9Pswx1EKSXeZR0rlQG
 6yUxY+ulRGc1bOZjsRJP9vDQonwD8ijJt/udcGrKJ9c3rSSG4TD17OIaVZ78NS88Qp4aBhe82
 HWqaC+aOEaUbuzVb4SbYFpyjJOou4MoGsVkQJtf7axivyuh4F8Ny/z3VDwcNsp3/Tj28zvb2v
 J0k7nIaZ0I0tYIkAp1/j4iNMxXbgChWuUUIL5tBwZOpHuPsKfJ9lnOSNXS/rf++3BV8EqqFTQ
 nm5NhSMR50i77za1rLvlNU0l3HZb6/ALi4AdP7wRE2JA1vjdgmA+wV825YHW0jVY5YclZnFOX
 egOyynB3XgRyLgJ6BTNceXe2B2FA2taXxzDVJT6EfI9DwOJ+kbJr/qfyjKzkcDMZZiv4zBx2n
 lcOljGfiLCWjm8AM9I/nEwXZavBgJNrA6HiVilgQKuvjVArxU61uQfFjztXG05kBCBzQeXTXI
 sCxenq6I5oQ3KBpa+GvRD05RCotUUVQBkR5CpZ7g6Q6uLDRiWP3JtJoECVgpnCClICpXoPs7r
 QyW6UvonbsA6RDXH63xA8Eu2DMRMn4zWrLt+9XN14EYTiH81wW7MDpeNlVDajdPAf9lIQpp0w
 XttgrJ4GBWNW3wp0saYJEwYtWLJRv59BBVyoY7KxrV2UdUgAgYgtOnI1Fx0qNcQ1uKRkgyEVF
 3Xg8KJGwIXBC/gbFhs8M6vwgV+Qh342fzTw
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 19.07.19 18:38, Paolo Bonzini wrote:
> On 11/07/19 19:30, Paolo Bonzini wrote:
>> On 11/07/19 13:37, Ralf Ramsauer wrote:
>>> I can reproduce and confirm this issue. A system_reset of qemu after
>>> Jailhouse is enabled leads to the crash listed below, on all machines.
>>>
>>> On the Xeon Gold, e.g., Qemu reports:
>>>
>>> EAX=3D00000000 EBX=3D00000000 ECX=3D00000000 EDX=3D00000f61
>>> ESI=3D00000000 EDI=3D00000000 EBP=3D00000000 ESP=3D00000000
>>> EIP=3D0000fff0 EFL=3D00000246 [---Z-P-] CPL=3D0 II=3D0 A20=3D1 SMM=3D0=
 HLT=3D0
>>> ES =3D0000 00000000 0000ffff 00009300
>>> CS =3Df000 ffff0000 0000ffff 00a09b00
>>> SS =3D0000 00000000 0000ffff 00c09300
>>> DS =3D0000 00000000 0000ffff 00009300
>>> FS =3D0000 00000000 0000ffff 00009300
>>> GS =3D0000 00000000 0000ffff 00009300
>>> LDT=3D0000 00000000 0000ffff 00008200
>>> TR =3D0000 00000000 0000ffff 00008b00
>>> GDT=3D     00000000 0000ffff
>>> IDT=3D     00000000 0000ffff
>>> CR0=3D60000010 CR2=3D00000000 CR3=3D00000000 CR4=3D00000680
>>> DR0=3D0000000000000000 DR1=3D0000000000000000 DR2=3D0000000000000000
>>> DR3=3D0000000000000000
>>> DR6=3D00000000ffff0ff0 DR7=3D0000000000000400
>>> EFER=3D0000000000000000
>>> Code=3D00 66 89 d8 66 e8 af a1 ff ff 66 83 c4 0c 66 5b 66 5e 66 c3 <ea=
> 5b
>>> e0 00 f0 30 36 2f 32 33 2f 39 39 00 fc 00 00 00 00 00 00 00 00 00 00 0=
0
>>> 00 00 00 00
>>>
>>> Kernel:
>>> [ 1868.804515] kvm: vmptrld           (null)/6b8640000000 failed
>>> [ 1868.804568] kvm: vmclear fail:           (null)/6b8640000000
>>>
>>> And the host freezes unrecoverably. Hosts use standard distro kernels
>>
>> Thanks.  I'm going to look at it tomorrow.
>
> Ok, it was only tomorrow modulo 7, but the first fix I got is trivial:
>
> diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
> index 6e88f459b323..6119b30347c6 100644
> --- a/arch/x86/kvm/vmx/nested.c
> +++ b/arch/x86/kvm/vmx/nested.c
> @@ -194,6 +194,7 @@ static void vmx_disable_shadow_vmcs(struct vcpu_vmx =
*vmx)
>  {
>  	secondary_exec_controls_clearbit(vmx, SECONDARY_EXEC_SHADOW_VMCS);
>  	vmcs_write64(VMCS_LINK_POINTER, -1ull);
> +	vmx->nested.need_vmcs12_to_shadow_sync =3D false;
>  }
>
>  static inline void nested_release_evmcs(struct kvm_vcpu *vcpu)
>
> Can you try it and see what you get?
>

Confirmed that this fixes the host crashes for me as well.

Now I'm only still seeing guest corruptions on vmport/vmmouse accesses fro=
m L2.
Looking into that right now.

Jan
