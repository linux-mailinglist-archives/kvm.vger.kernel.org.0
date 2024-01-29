Return-Path: <kvm+bounces-7394-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F39F6841437
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 21:25:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 25E561C23B61
	for <lists+kvm@lfdr.de>; Mon, 29 Jan 2024 20:25:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90F6476054;
	Mon, 29 Jan 2024 20:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="mRsgy2nT"
X-Original-To: kvm@vger.kernel.org
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7AC7603D
	for <kvm@vger.kernel.org>; Mon, 29 Jan 2024 20:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706559924; cv=none; b=X28W1OqUIseljwbc/vKA1QykATQ1s1tW+kFtcyFglr92Cjs3x0LyBL/321wAgYqFN/at3Gbe8N/XdXjnyhZXXR/Dqi41Gb9sIUI2j4/5gkpBIYUwppIwcuazjjEQvu6Itzii+7X0FDGSJajLi24sQNJfSSIqTGpFoGlabf/tPX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706559924; c=relaxed/simple;
	bh=t4y5O2v80/N1buYxN57NYKAZ0Bev0mKEYyc3wQDHke4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A5vkgWnFNRl20FGC7cIfab3D75V/0Ti32SytAMlRFtbNovfk3WRGprFFe84YBCISfVc12Yo1u6V4MjL/qHadcSuqiDSu8J+cba0aznrwukY3zV5Ok45Jhf5uaKIjhXqNwnOkACBJGDVy65qx8VlPT86uK6+uDehOgxOMcFoPrtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b=mRsgy2nT; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1706559910; x=1707164710; i=deller@gmx.de;
	bh=t4y5O2v80/N1buYxN57NYKAZ0Bev0mKEYyc3wQDHke4=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=mRsgy2nT6qg8doTPKWg4MJ8aGSLokAoS9T4Eafl/q8XtDYcMDg3532PQD++oGrRT
	 3AraDvWUJgRR5EjTogtJZeR0z4N+pI1HP9KfPf45tGRecBwuxqaseu/JylHEtUBln
	 OFyiA4eAxAnR8T5H72f2blTcWuaqIGYEgGWsjLt+6Yka3+0J9JXgnKdvfQKf2EKw2
	 +4RD6EVxuZzZl0Eoq2dKa3VSHuDqtmXZ/xgyYWZYwp+7Bim704xg3pwU3lk4P24Zp
	 3QQ0yEQbeGNnQtqjlCRm1XkFFSTEVv3yn41ussPVuQm5k15VaV/1H5k1P7XVXF7aN
	 h3py3MQZrEHfAwSeLA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.55] ([94.134.155.171]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mlw3N-1qnYBx1vRz-00j11b; Mon, 29
 Jan 2024 21:25:10 +0100
Message-ID: <9c2e60fa-7a23-496d-bf81-8826810e6351@gmx.de>
Date: Mon, 29 Jan 2024 21:25:09 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 12/29] target/hppa: Prefer fast cpu_env() over slower
 CPU QOM cast macro
Content-Language: en-US
To: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 qemu-devel@nongnu.org
Cc: qemu-riscv@nongnu.org, qemu-s390x@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
 qemu-ppc@nongnu.org, qemu-arm@nongnu.org,
 Richard Henderson <richard.henderson@linaro.org>
References: <20240129164514.73104-1-philmd@linaro.org>
 <20240129164514.73104-13-philmd@linaro.org>
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <20240129164514.73104-13-philmd@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:xCtZ4NVqvrToy67dRKju7QMLsPslL2OSiWJVmyiAeOUiyCESqoD
 utHKpaNLSE25RvMViB2HhD3ifvw/it1fJE+hDZOweA1JBACyRGeRvLOD7qfBYGjQwipvsWQ
 LpwzihaLy0Y59ZL29TDPSaLRld7pGiLOH5/p+OPlYQdLGEpPB3auOcwJ5yPiy4zf5BzDZna
 z5wQQw5llbjlnpHDsgVmQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5RFp/sdB+cw=;jxsVH2MuGrETdaV8Hb4NfNGRGdm
 d9Ev6uyc5cnRIlJVbZ2yPy1Go/1UwnYnLQval1/SlifLvYoTlAwtLNbaWioe0arMG7tQUvDos
 N3s7vntWS4eKrcUxpI1U3rvrEDX8fZrilxMnnvsfnyIlSQJdTmVQ6MRoge/LbAbP+t1t//HKa
 roDskNom3sAoaDmCp0768gnn+O7zLtpgKtBt0JKWHM05b7bLBctGSeFXdccPG3lZ6jj/0OMpL
 h45ywtHk1zn6ddZxKYxo5vy/LZ+i1BKpRt5gTxYaDCV2rRZb6XIKYDQRDcsGVBd2VEpyANT2M
 ORG27OEppDmWfmPhkKamrzqbvlHk/lk/lDrA3GN+JC+o4+H7HY0C0UDsRwXlTSgWbAmu28/yS
 uQ7IsdItn/B1X6mNsRktror78EvMNlT+Lf2pHtwkEvFB1O9tNhoP+DpwHZ9JQ1yJitFRJEgbF
 FaYFY3GkfVU2fbv6b61h2NQfOnoKx3MPwLTaFkoMxGx24gbc02aXqmfm3m7nU1mQ43tYmHS5i
 488JLHtL8NOxI977NG5u0RYU3JbzjjTpfcrepr1w4dvt22bHr6d2xXAET8BHthDXm+uxBwCDW
 xHn0Conl74rKt/FURDX+jnX2AsVLE/qJG10EXHpBI89/I+JeqIKcyy4AdTHMTD6xLrXrtsjMy
 etlpA6Lcd62djZdAVtlI+t1kVg3j5ExSb9EYC6agW7ZAmxjkQEGulVt661/egM2HP9sQm4gJu
 MhobtE97chh1d8+G5Hb7HgKavWGGv7rIUxZleDOzg+zmfMsimZBYBPtUhoAE8RVgSoEkhHUsW
 vgdRYfaWZjIjUesSwyQczew5YX9qMA577tdTzziJLb/kg3a7ucr1f9KV/Tqn+VSHHxAn86Igt
 C7FuC1HDzr8Ac65/Fp5HESPIIbi5el9xbRc7wHS5asptW0Mz3VWtCr2m29OB5Oh9B+1e9cQ6i
 ZOQmCq4eJE3vzgQemJJVoxW8DQQ=

On 1/29/24 17:44, Philippe Mathieu-Daud=C3=A9 wrote:
> Mechanical patch produced running the command documented
> in scripts/coccinelle/cpu_env.cocci_template header.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>
> Reviewed-by: Richard Henderson <richard.henderson@linaro.org>
> ---
>   target/hppa/cpu.c        | 8 ++------
>   target/hppa/int_helper.c | 8 ++------
>   target/hppa/mem_helper.c | 3 +--
>   3 files changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/target/hppa/cpu.c b/target/hppa/cpu.c
> index 14e17fa9aa..3200de0998 100644
> --- a/target/hppa/cpu.c
> +++ b/target/hppa/cpu.c
> @@ -106,11 +106,8 @@ void hppa_cpu_do_unaligned_access(CPUState *cs, vad=
dr addr,
>                                     MMUAccessType access_type, int mmu_i=
dx,
>                                     uintptr_t retaddr)
>   {
> -    HPPACPU *cpu =3D HPPA_CPU(cs);
> -    CPUHPPAState *env =3D &cpu->env;
> -
>       cs->exception_index =3D EXCP_UNALIGN;
> -    hppa_set_ior_and_isr(env, addr, MMU_IDX_MMU_DISABLED(mmu_idx));
> +    hppa_set_ior_and_isr(cpu_env(cs), addr, MMU_IDX_MMU_DISABLED(mmu_id=
x));
>
>       cpu_loop_exit_restore(cs, retaddr);
>   }
> @@ -145,8 +142,7 @@ static void hppa_cpu_realizefn(DeviceState *dev, Err=
or **errp)
>   static void hppa_cpu_initfn(Object *obj)
>   {
>       CPUState *cs =3D CPU(obj);
> -    HPPACPU *cpu =3D HPPA_CPU(obj);
> -    CPUHPPAState *env =3D &cpu->env;
> +    CPUHPPAState *env =3D cpu_env(CPU(obj));

Here it can become cpu_env(cs) too.

The rest looks ok, so with that changed:
Reviewed-by: Helge Deller <deller@gmx.de>

Helge


