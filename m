Return-Path: <kvm+bounces-49985-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8648FAE0AE2
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 17:50:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 259E53AFB42
	for <lists+kvm@lfdr.de>; Thu, 19 Jun 2025 15:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 369A5286D47;
	Thu, 19 Jun 2025 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Bw9meWho"
X-Original-To: kvm@vger.kernel.org
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57C11712;
	Thu, 19 Jun 2025 15:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750348238; cv=none; b=iWZtD/OdWeumqlWR0mft6fF6IdHutxaap7ZrIjUZlXzXfJ+9tmNDkMPakXo7C4CMCkEtsC8Hp+J/UNKKtUvJZKI9KHK4IokmMFtoIJ26QvyG26O3cxeonsZNVGCrct69jr2JhsePnaskP8d44Q3ljjTq2zIYGq4dzGVvmRtSkoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750348238; c=relaxed/simple;
	bh=OKsVibEkSv+hfR4J2CvdJJEcDJm0d1G4pRgyEnSM5co=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jl7Lg0aSc3Hn76/ad1gysn6TqUz78OB+LvHeJRH2jdv4ZaIBPt4e7FC99MT+CKHF0IZtvdxiAOE9lf2sCfDURdByTBAnPkss0cYRkqSKAcT7qJcrJe+jAt+kOJ/P9FtZpUvWBR2aWQCzLiUosRs93rirtEsln/qw7UDxHlHZZi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=casper.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Bw9meWho; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=casper.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OKsVibEkSv+hfR4J2CvdJJEcDJm0d1G4pRgyEnSM5co=; b=Bw9meWhos1tgAIc+K/544bWYY7
	TSrs4qSCCLwK/G59yXQbgmv2lmkCuMkvZxk0hrTtkOpznc9r9pAlYHynY14uNOPuXmJB9OwLNvUcI
	elmJR9YNWGf2mKdlNASMm/a1xOeU4qwTD53xc4HCErLoupHHCLNV6sLfS/JKHukPTXn8u0Ne2c922
	zlvIs92esqPKGhjpXeteV0mf8YVWXMzWxaR7TBu4Qc6iFEwFrNIuSf9SW1Pvh6LVrFCB9HWPqvWkI
	NBuMIBtV0y3/yxRkY0iNJMEu8uJCBtlNxR6m78RVbQ/tXU7Yly1mqDneI+6opUUl0VPDw/pix9OXz
	zQZno7uA==;
Received: from [2001:8b0:10b:5:748f:d833:d81c:4c8f] (helo=u09cd745991455d.ant.amazon.com)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uSHX4-00000009LhR-2ep8;
	Thu, 19 Jun 2025 15:50:30 +0000
Message-ID: <b1db820e965996b4d236caf15736162f161223e6.camel@infradead.org>
Subject: Re: [RFC PATCH 00/34] Running Qualcomm's Gunyah Guests via KVM in
 EL1
From: David Woodhouse <dwmw2@infradead.org>
To: Marc Zyngier <maz@kernel.org>, Karim Manaouil
 <karim.manaouil@linaro.org>,  Oliver Upton <oliver.upton@linux.dev>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 kvmarm@lists.linux.dev, Alexander Graf <graf@amazon.com>, Alex Elder
 <elder@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Fuad Tabba
 <tabba@google.com>, Joey Gouly <joey.gouly@arm.com>, Jonathan Corbet
 <corbet@lwn.net>, Mark Brown <broonie@kernel.org>, Mark Rutland
 <mark.rutland@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, Prakruthi
 Deepak Heragu <quic_pheragu@quicinc.com>, Quentin Perret
 <qperret@google.com>, Rob Herring <robh@kernel.org>,  Srinivas Kandagatla
 <srini@kernel.org>, Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>, Will
 Deacon <will@kernel.org>, Haripranesh S <haripran@qti.qualcomm.com>, Carl
 van Schaik <cvanscha@qti.qualcomm.com>, Murali Nalajala
 <mnalajal@quicinc.com>,  Sreenivasulu Chalamcharla
 <sreeniva@qti.qualcomm.com>, Trilok Soni <tsoni@quicinc.com>, Stefan
 Schmidt <stefan.schmidt@linaro.org>
Date: Thu, 19 Jun 2025 16:50:29 +0100
In-Reply-To: <86ikmtjy51.wl-maz@kernel.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
	 <aApaGnFPhsWBZoQ2@linux.dev> <86ikmtjy51.wl-maz@kernel.org>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-8oYh6WC82njjqP/La6PW"
User-Agent: Evolution 3.52.3-0ubuntu1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html


--=-8oYh6WC82njjqP/La6PW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2025-04-24 at 17:57 +0100, Marc Zyngier wrote:
> On Thu, 24 Apr 2025 16:34:50 +0100,
> Oliver Upton <oliver.upton@linux.dev> wrote:
> >=20
> > On Thu, Apr 24, 2025 at 03:13:07PM +0100, Karim Manaouil wrote:
> > > This series introduces the capability of running Gunyah guests via KV=
M on
> > > Qualcomm SoCs shipped with Gunyah hypervisor [1] (e.g. RB3 Gen2).
> > >=20
> > > The goal of this work is to port the existing Gunyah hypervisor suppo=
rt from a
> > > standalone driver interface [2] to KVM, with the aim of leveraging as=
 much of the
> > > existing KVM infrastructure as possible to reduce duplication of effo=
rt around
> > > memory management (e.g. guest_memfd), irqfd, and other core component=
s.
> > >=20
> > > In short, Gunyah is a Type-1 hypervisor, meaning that it runs indepen=
dently of any
> > > high-level OS kernel such as Linux and runs in a higher CPU privilege=
 level than VMs.
> > > Gunyah is shipped as firmware and guests typically talk with Gunyah v=
ia hypercalls.
> > > KVM is designed to run as Type-2 hypervisor. This port allows KVM to =
run in EL1 and
> > > serve as the interface for VM lifecycle management,while offloading v=
irtualization
> > > to Gunyah.
> >=20
> > If you're keen on running your own hypervisor then I'm sorry, you get t=
o
> > deal with it soup to nuts. Other hypervisors (e.g. mshv) have their own
> > kernel drivers for managing the host / UAPI parts of driving VMs.
> >=20
> > The KVM arch interface is *internal* to KVM, not something to be
> > (ab)used for cramming in a non-KVM hypervisor. KVM and other hypervisor=
s
> > can still share other bits of truly common infrastructure, like
> > guest_memfd.
> >=20
> > I understand the value in what you're trying to do, but if you want it
> > to smell like KVM you may as well just let the user run it at EL2.
>=20
> +1. KVM is not a generic interface for random third party hypervisors.

I don't think that should be true in the general case. At least, it
depends on whether you mean the literal implementation in
arch/arm64/kvm/ vs. the userspace API and set of ioctls on /dev/kvm.

The kernel exists to provide a coherent userspace API for all kinds of
hardware. That's what it's *for*. It provides users with a consistent
interface to all kinds of network cards, serial ports, etc. =E2=80=94 and t=
hat
includes firmware/platform features too.=20

There's no reason that shouldn't be the same for virtualisation. If the
kernel cannot provide an API which supports *all* kinds of
virtualization, then it seems like we've done something wrong.

On x86 we have /dev/kvm backed by different vendor-specific support for
Intel vs. AMD. And in recent years we've retrofitted confidential
compute to it too, with SEV-SNP, TDX, etc.

We haven't resorted to saying "no, sorry, KVM doesn't support that".

We shouldn't say that for Arm either.


--=-8oYh6WC82njjqP/La6PW
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MDYxOTE1NTAy
OVowLwYJKoZIhvcNAQkEMSIEII/fZn4RSpkWjs+K1CouaBN+lFLTetGT/HGblcvfb9w1MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAZF3UeKEp1fX1
qb4qMwFxPp240pSrWPJnjtAd+C45wLNgy0rvxM4a/SoZW03xflK6K8Fl2sIaPepLERERF9k/SLN+
sGKrsSCE0JHDTjq9lRalv1UHVEgnrQe9JaVa/2Jcu33rllcOv0y0v+h8xuhyEY4JoqwCwsfh2RS/
USZn9vxQnGeHPMJrQf/+avyLlRhzalNkQKst0yavMILRv7dtNS3yZifd0zWKDbka2nLfGRASnDks
dYRXre7Ya2jJ2HT330wE+IzCUaFxW9jVr9Cs0+ODC5NreKR7ZIfmx+/9nak7UDPY2mcArLtOEjE4
xr0q0POAiRD76lBIZxaUir34RsV+JesrNyvTOA5Ev0X2uGiSSgcJdESLKwdePjEWbUJL+ypcCHGY
hr7pzpHQ11iGqk8P3pX2y/kMGk1Q2RTScOpGUB0kZsR3KpH5Dlfwi8e9oikKP4dDYgq86D5lXQlr
yNT/iOP4fEtLYBDYePqZkgXLuECgWM6R1/91np3XXQKMa0YBiRMsbm4YUcpBQFExMtSyWVLXF7dS
pdWKfJqV3UFbFsXf7UKtLLcxmnxSaDA69q4aJG+2zoYgTz07rJT2+KKi1DWTIeezUQIVoeegb+Ln
gxTTxHkByue0WwZXarUb40fMbnMLt3JKR42IXHV74n6fslQNv5kwC9rDvP/Kj/gAAAAAAAA=


--=-8oYh6WC82njjqP/La6PW--

