Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C85FA1753A0
	for <lists+kvm@lfdr.de>; Mon,  2 Mar 2020 07:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgCBGTX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 2 Mar 2020 01:19:23 -0500
Received: from mout.web.de ([212.227.15.3]:34245 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbgCBGTW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 2 Mar 2020 01:19:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1583129948;
        bh=NJpNrRJ5CMKJh/UmYmXgpYGdiD3+9ziRrII/1O0NHHo=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=ov1+patt/t4YOvbAcrqt/Qozr/xn1diewcatpn0kYmfl3ut1LXJPCqlhL8rLzZUMF
         eTx8Yjc9OP0Tf5R4xeY1DZS+FSmqYojjTN6FV4cknIbl1YTYmgdLmYBYtBCiDknn5O
         E9ZK4w8xZz7EqH8uQpBhM7+2HoU1ihRfW/BOzfGE=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.10] ([95.157.55.156]) by smtp.web.de (mrweb003
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0LshXV-1jX1rp1ANt-012L0H; Mon, 02
 Mar 2020 07:19:08 +0100
Subject: Re: [PATCH] kvm: x86: Make traced and returned value of kvm_cpuid
 consistent again
To:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, kvm <kvm@vger.kernel.org>
Cc:     Jim Mattson <jmattson@google.com>
References: <dd33df29-2c17-2dc8-cb8f-56686cd583ad@web.de>
 <b9244d91-93a6-e663-6497-e91c1dca49ef@intel.com>
From:   Jan Kiszka <jan.kiszka@web.de>
Message-ID: <83ce6f66-c178-bebe-40d4-53bd4df4a6c6@web.de>
Date:   Mon, 2 Mar 2020 07:19:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <b9244d91-93a6-e663-6497-e91c1dca49ef@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yGUNKoy/z1tJyzSfdw+kjLQIFbd8X8yRxOlEowffnKSu81K8VaZ
 n/II5ZLIUh2sP/XrcZc4nldKnypiE0+s97UxuwxtXafXKoJnoypY4LRnjM0qWAdMyJy4xVy
 BGyqMHJM2fZqcT21dd5jIWty4BYvY3FH8rpg8LuS5KtKmQpJ8q700gk1ZHJTzVuP+CtQ4bu
 DXd81ACt5D2+iCtl7MC0A==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LPA79uIUkhA=:1O5gkvv9WymRbOTELpeJzc
 MHEW2u0EkHaBdmE8977qQdTITKa7DRN7d3wIo4Fgf2zKO67Ej2wPUk2uJh7Xb6qxLfbZNmcyG
 0GptGmiw3ai9h63ff2nfZldozIKz69luCe8annwxqCKuQB0EHGxDEr/U+zVy8D4brPUQQL2fV
 8jLOwn2UuKg2HHsIJ5foq4KKCr0uvn6K6ghGnTLnwVH2yitYePrSm2f2aEuTWXPE/1PdlNd/F
 4bkUItxD+GiTlJJfbNF0FbSgSsyFW7C7tWwaen38JTT7jq0HXZz15Z7TW7utkLqDZrVGtKqGd
 T+diyvQGiCJyIpjVq/NEnNfmfSJ6kSe+I9ryBM5xGtADnL7bGj9BhvV4usJ9XNFXwhqh+Lep9
 UpmIZUZudpxceYuK+9ALk8PcVxvy3gcjCy5GZ7yDXXgHA6W9V0PffTKFZVbw2SGhMU+M4yRfB
 f1LbHXHLCdrjzS2N9A6sKin8DwbdSVOaeb5Y5PXcepeTi83miJPmoGosK1lSjQLAX6XW7Pil6
 uBbmROIRuXMLSTzvNudXLjCftVVuSISJYa+WZHyc4DBBG9aKBamWeP9dye1Vot0AYgLxE+Z81
 7I87N/TH4xzX1YR2TvwDRq4IgKgyTE29iZsGjVSaFRQx3ZFV+O0kSny8bNyVcDzrTrahXzTq3
 8BbX17De+LViHnXxP9waxqE3Wu/Z8XRkDAMDg6dO/1JRR0PC1O0okheVThmH+a2DDnRFmBmyw
 rZP4WtG+ewmArDo1bY9dDe2YZUJfOCWKbIvO8bvqZNZviNJ3KWJtx84Pb3BOUAKdKy4PZDhV2
 //2d6gbId2ro9P4J9Ra1yKDki28JrklWDW0kD3PtvH1iGngU503+wtuCE3g2G8cEoLCQNIrrb
 zbvn6/VZ/VAi3lw4HCI073T7yBFnmQfXLdd2qGuu9VLM7NL+EWXtYJNLHC+uRPvH8PEpuhI4Z
 8L35G/Qjr9+ytIkIiLEl+99FAXGIBM+mUfdhOo4lJkeHq4o2WZZHJPVhYWw5XsD1bG6h9qgPM
 x0/pSQbXOdKoqTfLkGSK5Xazqp5KX8c4gWWKiWbFesxdLvol728n+jELbDCwxNBjpLgOxiCZj
 OOT1ddk0XgVuU+L+FMTvQzA+76Jl8Hk3lDxiw+zRQr0J/BIpkly68FFMTCHCRPdCFnnJt2gdC
 ugJjy34m/Iy4x1+jK2/pc8lPNz1UcDTs+iG3e+ksrGShD/ODa169dRA7yWfZrvABhIu5TlLdY
 gsWeYJ5y6LYdnnmiR
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 01.03.20 13:25, Xiaoyao Li wrote:
> On 3/1/2020 6:47 PM, Jan Kiszka wrote:
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> After 43561123ab37, found is not set correctly in case of leaves 0BH,
>> 1FH, or anything out-of-range. This is currently harmless for the retur=
n
>> value because the only caller evaluating it passes leaf 0x80000008.
>
> Nice catch!
>
>> However, the trace entry is now misleading due to this inaccuracy. It i=
s
>> furthermore misleading because it reports the effective function, not
>> the originally passed one. Fix that as well.
>
> BTW, the trace lacks subleaf(ECX) info, it's meaning for the the leaf
> does have a subleaf, maybe we'd better add it?
>

Yes, was also thinking about that. Could be done on top.

Jan

>> Fixes: 43561123ab37 ("kvm: x86: Improve emulation of CPUID leaves 0BH
>> and 1FH")
>> Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
>> ---
>> =C2=A0 arch/x86/kvm/cpuid.c | 6 +++---
>> =C2=A0 1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
>> index b1c469446b07..79a738f313f8 100644
>> --- a/arch/x86/kvm/cpuid.c
>> +++ b/arch/x86/kvm/cpuid.c
>> @@ -1000,13 +1000,12 @@ static bool cpuid_function_in_range(struct
>> kvm_vcpu *vcpu, u32 function)
>> =C2=A0 bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax, u32 *ebx,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0 u32 *ecx, u32 *edx, bool check_limit)
>> =C2=A0 {
>> -=C2=A0=C2=A0=C2=A0 u32 function =3D *eax, index =3D *ecx;
>> +=C2=A0=C2=A0=C2=A0 u32 orig_function =3D *eax, function =3D *eax, inde=
x =3D *ecx;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_cpuid_entry2 *entry;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct kvm_cpuid_entry2 *max;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bool found;
>>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 entry =3D kvm_find_cpuid_entry(vcpu, fun=
ction, index);
>> -=C2=A0=C2=A0=C2=A0 found =3D entry;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 /*
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Intel CPUID semantics treats any=
 query for an out-of-range
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * leaf as if the highest basic lea=
f (i.e. CPUID.0H:EAX) were
>> @@ -1049,7 +1048,8 @@ bool kvm_cpuid(struct kvm_vcpu *vcpu, u32 *eax,
>> u32 *ebx,
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> -=C2=A0=C2=A0=C2=A0 trace_kvm_cpuid(function, *eax, *ebx, *ecx, *edx, f=
ound);
>> +=C2=A0=C2=A0=C2=A0 found =3D entry;
>> +=C2=A0=C2=A0=C2=A0 trace_kvm_cpuid(orig_function, *eax, *ebx, *ecx, *e=
dx, found);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return found;
>> =C2=A0 }
>> =C2=A0 EXPORT_SYMBOL_GPL(kvm_cpuid);
>> --
>> 2.16.4
>>
>

