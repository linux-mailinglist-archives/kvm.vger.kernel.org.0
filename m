Return-Path: <kvm+bounces-53833-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B58DB181BC
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 14:26:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3F0FA85479
	for <lists+kvm@lfdr.de>; Fri,  1 Aug 2025 12:26:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DEFA923BCE3;
	Fri,  1 Aug 2025 12:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U4GACaKs"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26ED72441B8;
	Fri,  1 Aug 2025 12:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754051159; cv=none; b=A30hVFOWl3oJ8Y1ViTI8YbSB035M226lbe07Wp7vzuudWxfPxydReOp2QAm6x1en4Gkcr89DlUUBNEty90eVM20vIiVXdDiurwBFV3FfEFQyRg7vQsOZ3EXY6EpvrRr7hJO42pA6I8za6eCqZ1rXf4Q/VTN5nugJ5lUL0bleWU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754051159; c=relaxed/simple;
	bh=+Ltd4Hy3tdsuA5Vc2mPQHqD/Wg7sA0TicSGOKBy5Rpk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=OaT4GPgkM7BlVw7P9LdH/mhdHmphVua0tpVn63kRi0fmzxUJQafB0wEi/mSa/sAD8WEztHlKHfvPHv13b/kilWsap839H84KZb06zmD+D5NmEkKOU0u58DHuC6BsZbGgzZN+DbsUt9ubqY5ImPSqA7EOHmpvSs47HJq6lbHM9Y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=U4GACaKs; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+Ltd4Hy3tdsuA5Vc2mPQHqD/Wg7sA0TicSGOKBy5Rpk=; b=U4GACaKsgynZ6ANU/dUYe0WO9B
	HqZjffV8Z+YKe7oAyOvYfE4OXc+Tp3guH5IQ3bOT/NTHN6EX3gzv88hkJEvWA1triNTC+jCVKsmuO
	ceIbz4xWOhlCiNxRX7/HxEv4zTy6SC+JvMl8MCNHsL4MxvJOkdcwtOXwxDkucj5X4vjWhLpUDVRel
	rUMuAxgeUQIxSuYIF6XTym15EPB10OefYNbY4r5DDq0nd1suq51reXMZr2j9Jqa5s7L2L3yA0pMHR
	TF3yFX26DG54wZP9CI3+zV28zxdaw3orGuQ+tAvHeOD8mhFGMvbWTlPVP4Qjs7K5A7JttrigDkEa1
	RvdLI+PQ==;
Received: from 54-240-197-232.amazon.com ([54.240.197.232] helo=edge-m2-r3-179.e-iad50.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uhopV-0000000E6LM-42Z2;
	Fri, 01 Aug 2025 12:25:47 +0000
Message-ID: <2700e50c6ca07b58c4a4a0c219815cf3e1319f35.camel@infradead.org>
Subject: Re: [RFC PATCH 06/34] KVM: gunyah: Add initial Gunyah backend
 support
From: David Woodhouse <dwmw2@infradead.org>
To: Karim Manaouil <karim.manaouil@linaro.org>,
 linux-kernel@vger.kernel.org,  kvm@vger.kernel.org,
 linux-arm-msm@vger.kernel.org,  linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, Steven Price <steven.price@arm.com>, Gavin Shan
 <gshan@redhat.com>, Suzuki Poulose's avatarSuzuki K Poulose
 <suzuki.poulose@arm.com>, "Usug, Ugur" <ugurus@amazon.co.uk>
Cc: Alexander Graf <graf@amazon.com>, Alex Elder <elder@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Fuad Tabba <tabba@google.com>, Joey
 Gouly <joey.gouly@arm.com>,  Jonathan Corbet <corbet@lwn.net>, Marc Zyngier
 <maz@kernel.org>, Mark Brown <broonie@kernel.org>,  Mark Rutland
 <mark.rutland@arm.com>, Oliver Upton <oliver.upton@linux.dev>, Paolo
 Bonzini <pbonzini@redhat.com>, Prakruthi Deepak Heragu
 <quic_pheragu@quicinc.com>,  Quentin Perret <qperret@google.com>, Rob
 Herring <robh@kernel.org>, Srinivas Kandagatla <srini@kernel.org>, 
 Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>, Will Deacon
 <will@kernel.org>, Haripranesh S <haripran@qti.qualcomm.com>,  Carl van
 Schaik <cvanscha@qti.qualcomm.com>, Murali Nalajala <mnalajal@quicinc.com>,
 Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>, Trilok Soni
 <tsoni@quicinc.com>, Stefan Schmidt <stefan.schmidt@linaro.org>
Date: Fri, 01 Aug 2025 13:25:43 +0100
In-Reply-To: <20250424141341.841734-7-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
	 <20250424141341.841734-7-karim.manaouil@linaro.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-kuiyOGxGFoDOQHVFJxGm"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-kuiyOGxGFoDOQHVFJxGm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-04-24 at 15:13 +0100, Karim Manaouil wrote:
>=20
> - Introduces a new Kconfig split: `CONFIG_KVM_ARM` for native support,
> =C2=A0 and a variant for Gunyah-backed virtualization.
> - Adds `gunyah.c`, a new arch backend file that implements the minimal
> =C2=A0 KVM architecture callbacks and stub interfaces required by the KVM
> =C2=A0 core to build and boot.
> - Refactors Makefile and build rules to support mutually exclusive
> =C2=A0 builds of `CONFIG_KVM_ARM` and `CONFIG_GUNYAH`.
> - Introduces a dummy implementation of required KVM stubs such as:
> =C2=A0 `kvm_arch_init_vm()`, `kvm_arch_vcpu_create()`, `kvm_age_gfn()`, e=
tc.

I quite like this, conceptually. I do think it's important for the
kernel to provide a generic virtualization API regardless of the
underlying hardware/firmware =E2=80=94 that is, after all, what an OS kerne=
l is
*for*. So the answer "not in KVM" is just fundamentally not realistic.

I'd like to see fewer #ifdefs though. The model we have on x86 with
static_calls for the AMD vs. Intel back ends seems to work out OK.

We ought to be able to come up with a model inspired by x86 where we
allow certain methods to be provided by one of many sets of 'lowvisor'
ops or whatever we want to call them:

 =E2=80=A2 Native KVM (at EL2)
 =E2=80=A2 pKVM
 =E2=80=A2 Gunyah
 =E2=80=A2 CCA
 =E2=80=A2 ... and potentially one or two others.

Currently we have completely separate work on some of those; can we
combine at least the basic hooks/operations and come up with something
which is minimally intrusive where each one just plugs in its own
implementation but the KVM userspace API is as unified as possible?

--=-kuiyOGxGFoDOQHVFJxGm
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCD9Aw
ggSOMIIDdqADAgECAhAOmiw0ECVD4cWj5DqVrT9PMA0GCSqGSIb3DQEBCwUAMGUxCzAJBgNVBAYT
AlVTMRUwEwYDVQQKEwxEaWdpQ2VydCBJbmMxGTAXBgNVBAsTEHd3dy5kaWdpY2VydC5jb20xJDAi
BgNVBAMTG0RpZ2lDZXJ0IEFzc3VyZWQgSUQgUm9vdCBDQTAeFw0yNDAxMzAwMDAwMDBaFw0zMTEx
MDkyMzU5NTlaMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYDVQQDExdWZXJv
a2V5IFNlY3VyZSBFbWFpbCBHMjCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAMjvgLKj
jfhCFqxYyRiW8g3cNFAvltDbK5AzcOaR7yVzVGadr4YcCVxjKrEJOgi7WEOH8rUgCNB5cTD8N/Et
GfZI+LGqSv0YtNa54T9D1AWJy08ZKkWvfGGIXN9UFAPMJ6OLLH/UUEgFa+7KlrEvMUupDFGnnR06
aDJAwtycb8yXtILj+TvfhLFhafxroXrflspavejQkEiHjNjtHnwbZ+o43g0/yxjwnarGI3kgcak7
nnI9/8Lqpq79tLHYwLajotwLiGTB71AGN5xK+tzB+D4eN9lXayrjcszgbOv2ZCgzExQUAIt98mre
8EggKs9mwtEuKAhYBIP/0K6WsoMnQCcCAwEAAaOCAVwwggFYMBIGA1UdEwEB/wQIMAYBAf8CAQAw
HQYDVR0OBBYEFIlICOogTndrhuWByNfhjWSEf/xwMB8GA1UdIwQYMBaAFEXroq/0ksuCMS1Ri6en
IZ3zbcgPMA4GA1UdDwEB/wQEAwIBhjAdBgNVHSUEFjAUBggrBgEFBQcDBAYIKwYBBQUHAwIweQYI
KwYBBQUHAQEEbTBrMCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5kaWdpY2VydC5jb20wQwYIKwYB
BQUHMAKGN2h0dHA6Ly9jYWNlcnRzLmRpZ2ljZXJ0LmNvbS9EaWdpQ2VydEFzc3VyZWRJRFJvb3RD
QS5jcnQwRQYDVR0fBD4wPDA6oDigNoY0aHR0cDovL2NybDMuZGlnaWNlcnQuY29tL0RpZ2lDZXJ0
QXNzdXJlZElEUm9vdENBLmNybDARBgNVHSAECjAIMAYGBFUdIAAwDQYJKoZIhvcNAQELBQADggEB
ACiagCqvNVxOfSd0uYfJMiZsOEBXAKIR/kpqRp2YCfrP4Tz7fJogYN4fxNAw7iy/bPZcvpVCfe/H
/CCcp3alXL0I8M/rnEnRlv8ItY4MEF+2T/MkdXI3u1vHy3ua8SxBM8eT9LBQokHZxGUX51cE0kwa
uEOZ+PonVIOnMjuLp29kcNOVnzf8DGKiek+cT51FvGRjV6LbaxXOm2P47/aiaXrDD5O0RF5SiPo6
xD1/ClkCETyyEAE5LRJlXtx288R598koyFcwCSXijeVcRvBB1cNOLEbg7RMSw1AGq14fNe2cH1HG
W7xyduY/ydQt6gv5r21mDOQ5SaZSWC/ZRfLDuEYwggWbMIIEg6ADAgECAhAH5JEPagNRXYDiRPdl
c1vgMA0GCSqGSIb3DQEBCwUAMEExCzAJBgNVBAYTAkFVMRAwDgYDVQQKEwdWZXJva2V5MSAwHgYD
VQQDExdWZXJva2V5IFNlY3VyZSBFbWFpbCBHMjAeFw0yNDEyMzAwMDAwMDBaFw0yODAxMDQyMzU5
NTlaMB4xHDAaBgNVBAMME2R3bXcyQGluZnJhZGVhZC5vcmcwggIiMA0GCSqGSIb3DQEBAQUAA4IC
DwAwggIKAoICAQDali7HveR1thexYXx/W7oMk/3Wpyppl62zJ8+RmTQH4yZeYAS/SRV6zmfXlXaZ
sNOE6emg8WXLRS6BA70liot+u0O0oPnIvnx+CsMH0PD4tCKSCsdp+XphIJ2zkC9S7/yHDYnqegqt
w4smkqUqf0WX/ggH1Dckh0vHlpoS1OoxqUg+ocU6WCsnuz5q5rzFsHxhD1qGpgFdZEk2/c//ZvUN
i12vPWipk8TcJwHw9zoZ/ZrVNybpMCC0THsJ/UEVyuyszPtNYeYZAhOJ41vav1RhZJzYan4a1gU0
kKBPQklcpQEhq48woEu15isvwWh9/+5jjh0L+YNaN0I//nHSp6U9COUG9Z0cvnO8FM6PTqsnSbcc
0j+GchwOHRC7aP2t5v2stVx3KbptaYEzi4MQHxm/0+HQpMEVLLUiizJqS4PWPU6zfQTOMZ9uLQRR
ci+c5xhtMEBszlQDOvEQcyEG+hc++fH47K+MmZz21bFNfoBxLP6bjR6xtPXtREF5lLXxp+CJ6KKS
blPKeVRg/UtyJHeFKAZXO8Zeco7TZUMVHmK0ZZ1EpnZbnAhKE19Z+FJrQPQrlR0gO3lBzuyPPArV
hvWxjlO7S4DmaEhLzarWi/ze7EGwWSuI2eEa/8zU0INUsGI4ywe7vepQz7IqaAovAX0d+f1YjbmC
VsAwjhLmveFjNwIDAQABo4IBsDCCAawwHwYDVR0jBBgwFoAUiUgI6iBOd2uG5YHI1+GNZIR//HAw
HQYDVR0OBBYEFFxiGptwbOfWOtMk5loHw7uqWUOnMDAGA1UdEQQpMCeBE2R3bXcyQGluZnJhZGVh
ZC5vcmeBEGRhdmlkQHdvb2Rob3Uuc2UwFAYDVR0gBA0wCzAJBgdngQwBBQEBMA4GA1UdDwEB/wQE
AwIF4DAdBgNVHSUEFjAUBggrBgEFBQcDAgYIKwYBBQUHAwQwewYDVR0fBHQwcjA3oDWgM4YxaHR0
cDovL2NybDMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDA3oDWgM4YxaHR0
cDovL2NybDQuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNybDB2BggrBgEFBQcB
AQRqMGgwJAYIKwYBBQUHMAGGGGh0dHA6Ly9vY3NwLmRpZ2ljZXJ0LmNvbTBABggrBgEFBQcwAoY0
aHR0cDovL2NhY2VydHMuZGlnaWNlcnQuY29tL1Zlcm9rZXlTZWN1cmVFbWFpbEcyLmNydDANBgkq
hkiG9w0BAQsFAAOCAQEAQXc4FPiPLRnTDvmOABEzkIumojfZAe5SlnuQoeFUfi+LsWCKiB8Uextv
iBAvboKhLuN6eG/NC6WOzOCppn4mkQxRkOdLNThwMHW0d19jrZFEKtEG/epZ/hw/DdScTuZ2m7im
8ppItAT6GXD3aPhXkXnJpC/zTs85uNSQR64cEcBFjjoQDuSsTeJ5DAWf8EMyhMuD8pcbqx5kRvyt
JPsWBQzv1Dsdv2LDPLNd/JUKhHSgr7nbUr4+aAP2PHTXGcEBh8lTeYea9p4d5k969pe0OHYMV5aL
xERqTagmSetuIwolkAuBCzA9vulg8Y49Nz2zrpUGfKGOD0FMqenYxdJHgDCCBZswggSDoAMCAQIC
EAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQELBQAwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoT
B1Zlcm9rZXkxIDAeBgNVBAMTF1Zlcm9rZXkgU2VjdXJlIEVtYWlsIEcyMB4XDTI0MTIzMDAwMDAw
MFoXDTI4MDEwNDIzNTk1OVowHjEcMBoGA1UEAwwTZHdtdzJAaW5mcmFkZWFkLm9yZzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBANqWLse95HW2F7FhfH9bugyT/danKmmXrbMnz5GZNAfj
Jl5gBL9JFXrOZ9eVdpmw04Tp6aDxZctFLoEDvSWKi367Q7Sg+ci+fH4KwwfQ8Pi0IpIKx2n5emEg
nbOQL1Lv/IcNiep6Cq3DiyaSpSp/RZf+CAfUNySHS8eWmhLU6jGpSD6hxTpYKye7PmrmvMWwfGEP
WoamAV1kSTb9z/9m9Q2LXa89aKmTxNwnAfD3Ohn9mtU3JukwILRMewn9QRXK7KzM+01h5hkCE4nj
W9q/VGFknNhqfhrWBTSQoE9CSVylASGrjzCgS7XmKy/BaH3/7mOOHQv5g1o3Qj/+cdKnpT0I5Qb1
nRy+c7wUzo9OqydJtxzSP4ZyHA4dELto/a3m/ay1XHcpum1pgTOLgxAfGb/T4dCkwRUstSKLMmpL
g9Y9TrN9BM4xn24tBFFyL5znGG0wQGzOVAM68RBzIQb6Fz758fjsr4yZnPbVsU1+gHEs/puNHrG0
9e1EQXmUtfGn4InoopJuU8p5VGD9S3Ikd4UoBlc7xl5yjtNlQxUeYrRlnUSmdlucCEoTX1n4UmtA
9CuVHSA7eUHO7I88CtWG9bGOU7tLgOZoSEvNqtaL/N7sQbBZK4jZ4Rr/zNTQg1SwYjjLB7u96lDP
sipoCi8BfR35/ViNuYJWwDCOEua94WM3AgMBAAGjggGwMIIBrDAfBgNVHSMEGDAWgBSJSAjqIE53
a4blgcjX4Y1khH/8cDAdBgNVHQ4EFgQUXGIam3Bs59Y60yTmWgfDu6pZQ6cwMAYDVR0RBCkwJ4ET
ZHdtdzJAaW5mcmFkZWFkLm9yZ4EQZGF2aWRAd29vZGhvdS5zZTAUBgNVHSAEDTALMAkGB2eBDAEF
AQEwDgYDVR0PAQH/BAQDAgXgMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEFBQcDBDB7BgNVHR8E
dDByMDegNaAzhjFodHRwOi8vY3JsMy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMDegNaAzhjFodHRwOi8vY3JsNC5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVtYWlsRzIu
Y3JsMHYGCCsGAQUFBwEBBGowaDAkBggrBgEFBQcwAYYYaHR0cDovL29jc3AuZGlnaWNlcnQuY29t
MEAGCCsGAQUFBzAChjRodHRwOi8vY2FjZXJ0cy5kaWdpY2VydC5jb20vVmVyb2tleVNlY3VyZUVt
YWlsRzIuY3J0MA0GCSqGSIb3DQEBCwUAA4IBAQBBdzgU+I8tGdMO+Y4AETOQi6aiN9kB7lKWe5Ch
4VR+L4uxYIqIHxR7G2+IEC9ugqEu43p4b80LpY7M4KmmfiaRDFGQ50s1OHAwdbR3X2OtkUQq0Qb9
6ln+HD8N1JxO5nabuKbymki0BPoZcPdo+FeRecmkL/NOzzm41JBHrhwRwEWOOhAO5KxN4nkMBZ/w
QzKEy4PylxurHmRG/K0k+xYFDO/UOx2/YsM8s138lQqEdKCvudtSvj5oA/Y8dNcZwQGHyVN5h5r2
nh3mT3r2l7Q4dgxXlovERGpNqCZJ624jCiWQC4ELMD2+6WDxjj03PbOulQZ8oY4PQUyp6djF0keA
MYIDuzCCA7cCAQEwVTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMX
VmVyb2tleSBTZWN1cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJYIZIAWUDBAIBBQCg
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDgwMTEyMjU0
M1owLwYJKoZIhvcNAQkEMSIEIOCh638+fg6HH0s6fKaXunZT8sKstrN7UYcBZ1ogkLEEMGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIASdHLiVQmlr6W
jlNNL+KtVJ+ZydQztNDdK3u1lkYjE9evUTAnQtuA9hOtD+VfuBi/e1lZinYZqLUJKDoFf96ery5i
ACKJPCmpW4tfgkDHPPGscM6J7kKP+OIhDv5rKd/i61jXZsQQ6f1sGAcGWUluNzdrAfuB1ycvAtjr
IEqvfmRtAN3MxORUMabjkzHuYJG5FvTSGtyYhpcMbjpBhD4/petj3DdoQvyVkH0QFnH+Fy8D5VDo
mgbDKWmlK//4sIceKkc0dBBoLm9i2B8UsQ76oREiWM/zRcQGGuJ1tiiBx2iTucIXh91QCR/RHB0M
SqUuSCIhPjOkt4xpv6CRr4rgNRVN1RnZto+nBaHsp6NNVht9Mxep61y3nlh5hAJ9LcGQcZOUFhir
fSUZ1qkN3RfbsJSjrDJUpMeFi+gHECitcp1jMiFr+g+WbIfsDzFzfoOVOL4zhEpd45A3IN5+6RI8
9FABy/Otw1m92tDtJJgvnqw0OdkqrdEZRWTBsrJg6JLdzZnNRLWDoedzEkE/LL++7PuhaSy+6BXt
mqid7HxGosGrFHZGxxf3k1WfMxQQdiICaTOkV+O72ZEdvJ62rsnuiFZOIsw/xxAxhqGrvaMNzhWx
syhYmPopOYx0BLpEMj2kFDO9jqHDjRt8sReAu6sl1/o5LKAWlWXxU6jmpLvSx5MAAAAAAAA=


--=-kuiyOGxGFoDOQHVFJxGm--

