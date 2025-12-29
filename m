Return-Path: <kvm+bounces-66776-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B294CE6CD2
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 14:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 2F1053002490
	for <lists+kvm@lfdr.de>; Mon, 29 Dec 2025 13:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 201171E47A3;
	Mon, 29 Dec 2025 13:01:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F+GWk7Zv"
X-Original-To: kvm@vger.kernel.org
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB5F1AA7BF;
	Mon, 29 Dec 2025 13:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767013290; cv=none; b=ndnzdoDJH5GvFtSv2+iOxReJ+fTuGwRQB/dWjDgh7RoyoT7vD0joDrlaxAEO1p1sv4aIaGU8GmCQKJkxwQi8cMvDoviypwOsTsR6yG5wgGYeRBKDr17VqW/2YUvBMDsJVQaypVWJHLiO5QyduOfNPNyqPXKq0JkSw+oHNt4mcOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767013290; c=relaxed/simple;
	bh=JIFPzHkIgnbYNc388d0sZnf0ReHYy1q3upDXWmuswLs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uoLTIIo7Sn6Zai9WGYm5BbGANUFHrjsKLg5gwJOlq4YM7C8zKg2oac79PaCVx1brl6OcYcxvgqsRVvj3BJAImJOQouOsw+fl2RAxSCtCDkhPPRLHgj2vODUsBvYBGdiWpbnaL+XihKUMPbWvV43OYboMXMx9KeLOt6XM5lzQgoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=desiato.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F+GWk7Zv; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=desiato.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=JIFPzHkIgnbYNc388d0sZnf0ReHYy1q3upDXWmuswLs=; b=F+GWk7ZvNcpeHbA7nkFZFCUvSl
	ShSRHmUXG7yppK6Rk7HE0vdXDkehl3wIbvYtJzH3WYcBM/+xhHdMeLYv8qs43dwPPkOk61IqfYLHR
	Ix19wJ3Duxjehkh9fDXZ1LPeoOcJKhc5T20FwwN9CTrRwiFgul2zojV/WLYxQ9hFqd7XDc1JboI2g
	AVa2NCKM48YjtftctDOSlUMoqit+9fcrto5CB/SGwNzdHsxULOpXYI6NwiWsC88f/UlZUmQW5jxJa
	G5UmmA2OIj2zTVf4Hw1Hma/ZRa3SXXr9sreBsm/hTHeHpSrNcbOiulrgSiYwF2SHmKBrsj24Qjg4U
	zCdR+rHQ==;
Received: from [172.31.31.148] (helo=u09cd745991455d.lumleys.internal)
	by desiato.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vaCrz-00000002mcl-3m8N;
	Mon, 29 Dec 2025 13:01:15 +0000
Message-ID: <9a04f3dda43aa50e2a160ccfd57d0d4f168b3dce.camel@infradead.org>
Subject: Re: [PATCH v5 2/3] KVM: x86/ioapic: Implement support for I/O APIC
 version 0x20 with EOIR
From: David Woodhouse <dwmw2@infradead.org>
To: Khushit Shah <khushit.shah@nutanix.com>
Cc: "seanjc@google.com" <seanjc@google.com>, "pbonzini@redhat.com"
 <pbonzini@redhat.com>, "kai.huang@intel.com" <kai.huang@intel.com>, 
 "mingo@redhat.com" <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
 "bp@alien8.de" <bp@alien8.de>, "hpa@zytor.com" <hpa@zytor.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,  "dave.hansen@linux.intel.com"
 <dave.hansen@linux.intel.com>, "tglx@linutronix.de" <tglx@linutronix.de>, 
 Jon Kohler <jon@nutanix.com>, Shaju Abraham <shaju.abraham@nutanix.com>
Date: Mon, 29 Dec 2025 13:01:07 +0000
In-Reply-To: <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
References: <20251229111708.59402-1-khushit.shah@nutanix.com>
	 <20251229111708.59402-3-khushit.shah@nutanix.com>
	 <7294A61D-A794-4599-950C-9EC9B5E94B58@infradead.org>
	 <DD13B2B3-5719-410F-8B98-9DB3E1738997@nutanix.com>
Content-Type: multipart/signed; micalg="sha-256"; protocol="application/pkcs7-signature";
	boundary="=-OddROMwxIRwaZcgAl3fC"
User-Agent: Evolution 3.52.3-0ubuntu1.1 
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html


--=-OddROMwxIRwaZcgAl3fC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-12-29 at 12:21 +0000, Khushit Shah wrote:
>=20
> > On 29 Dec 2025, at 5:09=E2=80=AFPM, David Woodhouse <dwmw2@infradead.or=
g>
> > wrote:
> >=20
> > On 29 December 2025 11:17:07 GMT, Khushit Shah
> > <khushit.shah@nutanix.com> wrote:
> > > From: David Woodhouse <dwmw@amazon.co.uk>
> > >=20
> > > Introduce support for I/O APIC version 0x20, which includes the
> > > EOI
> > > Register (EOIR) for directed EOI.=C2=A0 The EOI register allows guest=
s
> > > to
> > > perform EOIs to individual I/O APICs instead of relying on
> > > broadcast EOIs
> > > from the local APIC.
> > >=20
> > > When Suppress EOI Broadcast (SEOIB) capability is advertised to
> > > the guest,
> > > guests that enable it will EOI individual I/O APICs by writing to
> > > their
> > > EOI register instead of relying on broadcast EOIs from the
> > > LAPIC.=C2=A0 Hence,
> > > when SEOIB is advertised (so that guests can use it if they
> > > choose), use
> > > I/O APIC version 0x20 to provide the EOI register.=C2=A0 This prepare=
s
> > > for a
> > > userspace API that will allow explicit control of SEOIB support,
> > > providing
> > > a consistent interface for both in-kernel and split IRQCHIP mode.
> > >=20
> > > Add a tracepoint (kvm_ioapic_directed_eoi) to track directed EOIs
> > > for
> > > debugging and observability.
> > >=20
> > > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > > Signed-off-by: Khushit Shah <khushit.shah@nutanix.com>
> > > ---
> > > arch/x86/kvm/ioapic.c | 31 +++++++++++++++++++++++++++++--
> > > arch/x86/kvm/ioapic.h | 19 +++++++++++--------
> > > arch/x86/kvm/trace.h=C2=A0 | 17 +++++++++++++++++
> > > 3 files changed, 57 insertions(+), 10 deletions(-)
> > >=20
> > > diff --git a/arch/x86/kvm/ioapic.c b/arch/x86/kvm/ioapic.c
> > > index 6bf8d110aece..eea1eb7845c4 100644
> > > --- a/arch/x86/kvm/ioapic.c
> > > +++ b/arch/x86/kvm/ioapic.c
> > > @@ -48,8 +48,11 @@ static unsigned long
> > > ioapic_read_indirect(struct kvm_ioapic *ioapic)
> > >=20
> > > switch (ioapic->ioregsel) {
> > > case IOAPIC_REG_VERSION:
> > > - result =3D ((((IOAPIC_NUM_PINS - 1) & 0xff) << 16)
> > > -=C2=A0=C2=A0 | (IOAPIC_VERSION_ID & 0xff));
> > > + if (kvm_lapic_advertise_suppress_eoi_broadcast(ioapic->kvm))
> > > + result =3D IOAPIC_VERSION_ID_EOIR;
> > > + else
> > > + result =3D IOAPIC_VERSION_ID;
> > > + result |=3D ((IOAPIC_NUM_PINS - 1) & 0xff) << 16;
> >=20
> > I think that wants to depend on _respect_ not _advertise_?
> > Otherwise you're changing existing behaviour in the legacy/quirk
> > case where the VMM neither explicitly enables not disables the
> > feature.
>=20
> I think _advertise_ is correct, as for legacy case, in kernel IRQCHIP
> mode, _advertise_ is false. For kernel IRQCHIP, _advertise_ is only
> true when *enabled*.

Hm? IIUC kvm_lapic_advertise_suppress_eoi_broadcast() is true whenever
userspace *hasn't* set KVM_X2APIC_DISABLE_SUPPRESS_EOI_BROADCAST
(either userspace has explicitly *enabled* it instead, or userspace has
done neither and we should preserve the legacy behaviour).

If the kernel I/O APIC is enabled when userspace has not explicitly
either enabled or disabled EOI suppression, then the I/O APIC should
advertise precisely the same features as before. As far as I can tell,
this will make the kernel I/O APIC advertise the newer version and
support the EOI register in that legacy case, which it shouldn't?


--=-OddROMwxIRwaZcgAl3fC
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
ggE3MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIyOTEzMDEw
N1owLwYJKoZIhvcNAQkEMSIEIBfV/8zrImnTvcN/HqXps9R6Htv12ebMWtNVL5C1Hb44MGQGCSsG
AQQBgjcQBDFXMFUwQTELMAkGA1UEBhMCQVUxEDAOBgNVBAoTB1Zlcm9rZXkxIDAeBgNVBAMTF1Zl
cm9rZXkgU2VjdXJlIEVtYWlsIEcyAhAH5JEPagNRXYDiRPdlc1vgMGYGCyqGSIb3DQEJEAILMVeg
VTBBMQswCQYDVQQGEwJBVTEQMA4GA1UEChMHVmVyb2tleTEgMB4GA1UEAxMXVmVyb2tleSBTZWN1
cmUgRW1haWwgRzICEAfkkQ9qA1FdgOJE92VzW+AwDQYJKoZIhvcNAQEBBQAEggIAshG4Vyy6mfb/
fwX9x8XRkx55E0AE+ImK+NYJjWYgEQB3cAI4Wakl+l9i7hscPOZqaqr+et/ruzUd0sfNOM5BOfSj
WkrwI71tcR7kc68R8PwGgc+RDVsnSU8eHTKgrwAcWS5Pbjibd/pjVrUAc/B1SJpFa7G0rycGL+M7
+030rCJgD1DTbSa4+pkeDug2yRtxBMJjCB6EhyG9u4Xn7I42vMpIPZwqGpW+ymmmc+sabhNgQsm3
IkeNuKc+XgKtDpf9koElEhw5JA8ALUw+pmNx90hiLAWSCRS4BFSq0FexbeNgHfW3FYVdg7jBbwjk
naNg5ZW9zcIgakEs1eOfePTT6LLnufq7mnZ9bmlF9egENcLiEndorhyLnGaGf+gFQ2L0qMu7UoHJ
nsBlP4OirD+2OFAMzL3SApuG1NiP9EXlGECBX2NH/RhhXlxEdrHNvOwYOxfF7Klt1HPPgKCiGpUf
M9/mOXAmomvawWKG8+7q5XEGMiaT8gMmXKvhR5V3JI82IIxyrH/Be7bNvkeIINbrmHstF69tkbg0
UC4w/YcmlpIG0W0IzmPOtk5ZOdBWJR/6K0Oz9XyBapKMpknj0tTaZBAJXRH381nPr1JDPc4Cyze0
xi87BdvCuz32T1qWZCDRsQAAZNAdgqSR/mXXB0mb4Lz9nInulOVdi5qLTk7+bUoAAAAAAAA=


--=-OddROMwxIRwaZcgAl3fC--

