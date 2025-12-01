Return-Path: <kvm+bounces-65008-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 81EA1C97E44
	for <lists+kvm@lfdr.de>; Mon, 01 Dec 2025 15:45:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 323FB3A385D
	for <lists+kvm@lfdr.de>; Mon,  1 Dec 2025 14:45:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C82E931ED77;
	Mon,  1 Dec 2025 14:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="WhL8pCv7"
X-Original-To: kvm@vger.kernel.org
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869C319847;
	Mon,  1 Dec 2025 14:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.158.23.94
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764600325; cv=none; b=rZBVYEPY/WV95551ql4W5UXW/4i+9EejZcPJ7lzA07QiNKuW94g8JOJuf1u5dMGZEU++dyJ5e5KMLb0ei6OCC7g0smw5gXRC+Z2F6UMVA/Ukgt5Lge7QfIpq4BwLGTrnwCNothkKlGMDgfibbAMR+LTX6X4SfdG/u9I5Ju4bK9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764600325; c=relaxed/simple;
	bh=UVDg1Guy9p2UufxCecABsSiNaOF6TmJ+4fooO+Q3umg=;
	h=Content-Type:MIME-Version:From:To:CC:Subject:Date:Message-ID:
	 References:In-Reply-To:MIME-Version; b=E7xlS8hA7e7qpuG+N9JxGtkf1BraVjBYhB2Ad8AoybhGf4iKcno5aaKoyT4klSjZnmhfAMivy0JQPsal5L8n1jk0nh/jQ+l/TTBgFon9HZ/zYoaY0vf3sd9CoTm66pCwUZUvuIJlSWX4P0i+2Tenvju1Rb3qbDb97lzqjU4czAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (2048-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=WhL8pCv7; arc=none smtp.client-ip=35.158.23.94
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764600323; x=1796136323;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=9HHszQ8uLB9Nvtsv/IwkKoL+lxIQrnvS8+HyJWF9b8g=;
  b=WhL8pCv7cLFlKLg+FBhrPe6vEJ6UUbJ7amS93DIc4SFxnEYM3Iw43+u3
   lwPftbn0qYDzPydZ+ZqnDGem9gOkROiSDHg3v3J5hEwAhQr32pmQCZhLB
   0+OwpJc+zM7F8RDnJjvBoNF/ncHkEO4/WsV9lPbSKvBTDw94UbVgdK7eZ
   wYATcYa/MaEqeC2uR6PTvR8hRZQCW0brL4xwBeG/fj/UwXr4LkBvADEGq
   JwVK8MANI69INhg2oDfVYGQrN9fjpeL+iehM8Dty/sCR3D7OgUyqU0QKE
   Oi6mn24wpVEEFjznGg/zzsJ3D8Qlt4IqLJXh3e5UYFiS70nyz1lMl/FxX
   Q==;
X-CSE-ConnectionGUID: 4Eg1OA0cSqaz6jGMyfVPNQ==
X-CSE-MsgGUID: Kc6OAJ51ROutevJSH+oJ2A==
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.20,240,1758585600"; 
   d="p7s'346?scan'346,208,346";a="6064819"
Content-Type: multipart/mixed; boundary="===============5292545290439379605=="
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Dec 2025 14:45:04 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:17436]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.31.35:2525] with esmtp (Farcaster)
 id a47c10cd-14e2-4fc5-9e7c-0778affee4d5; Mon, 1 Dec 2025 14:45:04 +0000 (UTC)
X-Farcaster-Flow-ID: a47c10cd-14e2-4fc5-9e7c-0778affee4d5
Received: from EX19D005EUA004.ant.amazon.com (10.252.50.241) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 14:45:03 +0000
Received: from EX19D001UEB002.ant.amazon.com (10.252.135.17) by
 EX19D005EUA004.ant.amazon.com (10.252.50.241) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Mon, 1 Dec 2025 14:45:03 +0000
Received: from EX19D001UEB002.ant.amazon.com ([fe80::19d6:e954:f18:6292]) by
 EX19D001UEB002.ant.amazon.com ([fe80::19d6:e954:f18:6292%3]) with mapi id
 15.02.2562.029; Mon, 1 Dec 2025 14:45:02 +0000
From: "Woodhouse, David" <dwmw@amazon.co.uk>
To: "Sieber, Fernand" <sieberf@amazon.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"peterz@infradead.org" <peterz@infradead.org>
CC: "Saenz Julienne, Nicolas" <nsaenz@amazon.es>, "Busse, Anselm"
	<abusse@amazon.de>, "x86@kernel.org" <x86@kernel.org>, "bp@alien8.de"
	<bp@alien8.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	=?utf-8?B?U2Now7ZuaGVyciwgSmFuIEgu?= <jschoenh@amazon.de>, "Borghorst,
 Hendrik" <hborghor@amazon.de>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "nh-open-source@amazon.com"
	<nh-open-source@amazon.com>
Subject: Re: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Thread-Topic: [PATCH] KVM: x86/pmu: Do not accidentally create BTS events
Thread-Index: AQHcYs40OjRv5LDqzEukxebtznpJ0bUM3IWA
Date: Mon, 1 Dec 2025 14:45:01 +0000
Message-ID: <0ce1757e3267df037912b303f60c662c45d0a6e6.camel@amazon.co.uk>
References: <20251201142359.344741-1-sieberf@amazon.com>
In-Reply-To: <20251201142359.344741-1-sieberf@amazon.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
MIME-Version: 1.0

--===============5292545290439379605==
Content-Language: en-US
Content-Type: multipart/signed; micalg=sha-256;
	protocol="application/pkcs7-signature"; boundary="=-STgedMsGNI3h0h+/AFyg"

--=-STgedMsGNI3h0h+/AFyg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-12-01 at 16:23 +0200, Fernand Sieber wrote
> Perf considers the combination of PERF_COUNT_HW_BRANCH_INSTRUCTIONS with
> a sample_period of 1 a special case and handles this as a BTS event (see
> intel_pmu_has_bts_period()) -- a deviation from the usual semantic,
> where the sample_period represents the amount of branch instructions to
> encounter before the overflow handler is invoked.

That's kind of awful, and seems to be the real underlying cause of the KVM
issue. Can we kill it with fire? Peter?

--=-STgedMsGNI3h0h+/AFyg
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEkYw
ggYQMIID+KADAgECAhBNlCwQ1DvglAnFgS06KwZPMA0GCSqGSIb3DQEBDAUAMIGIMQswCQYDVQQG
EwJVUzETMBEGA1UECBMKTmV3IEplcnNleTEUMBIGA1UEBxMLSmVyc2V5IENpdHkxHjAcBgNVBAoT
FVRoZSBVU0VSVFJVU1QgTmV0d29yazEuMCwGA1UEAxMlVVNFUlRydXN0IFJTQSBDZXJ0aWZpY2F0
aW9uIEF1dGhvcml0eTAeFw0xODExMDIwMDAwMDBaFw0zMDEyMzEyMzU5NTlaMIGWMQswCQYDVQQG
EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYD
VQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50
aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKC
AQEAyjztlApB/975Rrno1jvm2pK/KxBOqhq8gr2+JhwpKirSzZxQgT9tlC7zl6hn1fXjSo5MqXUf
ItMltrMaXqcESJuK8dtK56NCSrq4iDKaKq9NxOXFmqXX2zN8HHGjQ2b2Xv0v1L5Nk1MQPKA19xeW
QcpGEGFUUd0kN+oHox+L9aV1rjfNiCj3bJk6kJaOPabPi2503nn/ITX5e8WfPnGw4VuZ79Khj1YB
rf24k5Ee1sLTHsLtpiK9OjG4iQRBdq6Z/TlVx/hGAez5h36bBJMxqdHLpdwIUkTqT8se3ed0PewD
ch/8kHPo5fZl5u1B0ecpq/sDN/5sCG52Ds+QU5O5EwIDAQABo4IBZDCCAWAwHwYDVR0jBBgwFoAU
U3m/WqorSs9UgOHYm8Cd8rIDZsswHQYDVR0OBBYEFAnA8vwL2pTbX/4r36iZQs/J4K0AMA4GA1Ud
DwEB/wQEAwIBhjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdJQQWMBQGCCsGAQUFBwMCBggrBgEF
BQcDBDARBgNVHSAECjAIMAYGBFUdIAAwUAYDVR0fBEkwRzBFoEOgQYY/aHR0cDovL2NybC51c2Vy
dHJ1c3QuY29tL1VTRVJUcnVzdFJTQUNlcnRpZmljYXRpb25BdXRob3JpdHkuY3JsMHYGCCsGAQUF
BwEBBGowaDA/BggrBgEFBQcwAoYzaHR0cDovL2NydC51c2VydHJ1c3QuY29tL1VTRVJUcnVzdFJT
QUFkZFRydXN0Q0EuY3J0MCUGCCsGAQUFBzABhhlodHRwOi8vb2NzcC51c2VydHJ1c3QuY29tMA0G
CSqGSIb3DQEBDAUAA4ICAQBBRHUAqznCFfXejpVtMnFojADdF9d6HBA4kMjjsb0XMZHztuOCtKF+
xswhh2GqkW5JQrM8zVlU+A2VP72Ky2nlRA1GwmIPgou74TZ/XTarHG8zdMSgaDrkVYzz1g3nIVO9
IHk96VwsacIvBF8JfqIs+8aWH2PfSUrNxP6Ys7U0sZYx4rXD6+cqFq/ZW5BUfClN/rhk2ddQXyn7
kkmka2RQb9d90nmNHdgKrwfQ49mQ2hWQNDkJJIXwKjYA6VUR/fZUFeCUisdDe/0ABLTI+jheXUV1
eoYV7lNwNBKpeHdNuO6Aacb533JlfeUHxvBz9OfYWUiXu09sMAviM11Q0DuMZ5760CdO2VnpsXP4
KxaYIhvqPqUMWqRdWyn7crItNkZeroXaecG03i3mM7dkiPaCkgocBg0EBYsbZDZ8bsG3a08LwEsL
1Ygz3SBsyECa0waq4hOf/Z85F2w2ZpXfP+w8q4ifwO90SGZZV+HR/Jh6rEaVPDRF/CEGVqR1hiuQ
OZ1YL5ezMTX0ZSLwrymUE0pwi/KDaiYB15uswgeIAcA6JzPFf9pLkAFFWs1QNyN++niFhsM47qod
x/PL+5jR87myx5uYdBEQkkDc+lKB1Wct6ucXqm2EmsaQ0M95QjTmy+rDWjkDYdw3Ms6mSWE3Bn7i
5ZgtwCLXgAIe5W8mybM2JzCCBhUwggT9oAMCAQICEFQru/eJkU7BxeS7T6sWKmYwDQYJKoZIhvcN
AQELBQAwgZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
BAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+MDwGA1UEAxM1U2VjdGlnbyBS
U0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EwHhcNMjQxMjE1MDAw
MDAwWhcNMjYxMjE1MjM1OTU5WjAiMSAwHgYJKoZIhvcNAQkBFhFkd213QGFtYXpvbi5jby51azCC
AiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANhjs6T4tJ0lcw4+6sawEn2FowmhunUBsnSV
ccB+aA7s3Zd9PZV46CU6phAlCWpKk1yFVcD1Rnc4ux17o4LbUgFXiKrORS0jiF/5Oa0rXG3FISG1
Xdjt8oPKIq+9Z1s2e7Ipi5WWj4AG/xlkH/YMMctL9O8CCRHSrhiChbE/gR57x9PAnt5aeZZ2YWza
GOOeceaZe+u6vHCHITRmknSAnAX/aNoNJNsQCGcfrE83y9iHmP8BFrSRZqajBKlKq8tyJd5FnSwP
H3kSUcQlHOwiIfCRFXP4rpXSZ7nKOEZr3SXH06ADY9gZtrSpwBbuzKWDPGWMRuRnz8ogj/Y6DeU4
2zB/ZAIi5b0BzWf4u0rBEQD5xtpOCxYHc2nXQaFSWu36kP1JaNqElE51OQ92EyVKfW3N6qZcKiBr
VijXY2EtR+/5W9ixRFnEs4nIeb94Sf92UMEeG9ew2yVvcYXXNPaicGnrkESNC19/a8YXxQEZfrmB
eAPT9viQJhn3O+sD4pP0Ss3SjVZc6EO7vfoP07bt2n9YE08XSPkxcyb1J/4t/+AskkKeYFBGdpjg
xd+iLFxjSwBytZuh3+7DuHUfg876WA44ieQDrhHSjuvuAZ1Wb8WUsrpzrcLoYjqFmb/bf6/yyoxl
t31mdgPC+FLc+Yu1BQwXC3JMbrvbFBVTtn5X2EKDAgMBAAGjggHQMIIBzDAfBgNVHSMEGDAWgBQJ
wPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUWvtA1XsSV8xjgfFQL/DUTNIbJu4wDgYDVR0P
AQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwEwYDVR0lBAwwCgYIKwYBBQUHAwQwUAYDVR0gBEkwRzA6
BgwrBgEEAbIxAQIBCgIwKjAoBggrBgEFBQcCARYcaHR0cHM6Ly9zZWN0aWdvLmNvbS9TTUlNRUNQ
UzAJBgdngQwBBQEDMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2VjdGlnby5jb20vU2Vj
dGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcmwwgYoGCCsGAQUF
BwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9TZWN0aWdvUlNBQ2xp
ZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEFBQcwAYYXaHR0cDov
L29jc3Auc2VjdGlnby5jb20wHAYDVR0RBBUwE4ERZHdtd0BhbWF6b24uY28udWswDQYJKoZIhvcN
AQELBQADggEBAED6T+rfP2XPdLfHoCd5n1iGIcYauWfPHRdZN2Tw7a7NEXIkm2yZNizOSpp3NrMi
WOBN13XgqnYLsqdpxJhbjwKczKX50/qfhhkOHtrQ0GRkucybK447Aaul80cZT8T3WG9U9dhl3Ct/
MuyKBWQg3MYlbUT6u4kC9Pk8rd+cR14ttYRUWDKTS2BrL7e8jpNmtCoEakDkMY4MrpoMwM1f4ANV
qZ8cnDntwXq5ormZIksN2DqxsKLmrFyVAONhqSST72ImBfIVWhFRTCF9tTcI5wE/0Skl25FZmSsB
B2LUgecgK7MZyw9Do/b0sYS+8YmA/ujUCqNb0fPJBE/B9vBomhswggYVMIIE/aADAgECAhBUK7v3
iZFOwcXku0+rFipmMA0GCSqGSIb3DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3Jl
YXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0
ZWQxPjA8BgNVBAMTNVNlY3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJl
IEVtYWlsIENBMB4XDTI0MTIxNTAwMDAwMFoXDTI2MTIxNTIzNTk1OVowIjEgMB4GCSqGSIb3DQEJ
ARYRZHdtd0BhbWF6b24uY28udWswggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQDYY7Ok
+LSdJXMOPurGsBJ9haMJobp1AbJ0lXHAfmgO7N2XfT2VeOglOqYQJQlqSpNchVXA9UZ3OLsde6OC
21IBV4iqzkUtI4hf+TmtK1xtxSEhtV3Y7fKDyiKvvWdbNnuyKYuVlo+ABv8ZZB/2DDHLS/TvAgkR
0q4YgoWxP4Eee8fTwJ7eWnmWdmFs2hjjnnHmmXvrurxwhyE0ZpJ0gJwF/2jaDSTbEAhnH6xPN8vY
h5j/ARa0kWamowSpSqvLciXeRZ0sDx95ElHEJRzsIiHwkRVz+K6V0me5yjhGa90lx9OgA2PYGba0
qcAW7sylgzxljEbkZ8/KII/2Og3lONswf2QCIuW9Ac1n+LtKwREA+cbaTgsWB3Np10GhUlrt+pD9
SWjahJROdTkPdhMlSn1tzeqmXCoga1Yo12NhLUfv+VvYsURZxLOJyHm/eEn/dlDBHhvXsNslb3GF
1zT2onBp65BEjQtff2vGF8UBGX65gXgD0/b4kCYZ9zvrA+KT9ErN0o1WXOhDu736D9O27dp/WBNP
F0j5MXMm9Sf+Lf/gLJJCnmBQRnaY4MXfoixcY0sAcrWbod/uw7h1H4PO+lgOOInkA64R0o7r7gGd
Vm/FlLK6c63C6GI6hZm/23+v8sqMZbd9ZnYDwvhS3PmLtQUMFwtyTG672xQVU7Z+V9hCgwIDAQAB
o4IB0DCCAcwwHwYDVR0jBBgwFoAUCcDy/AvalNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFFr7QNV7
ElfMY4HxUC/w1EzSGybuMA4GA1UdDwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoG
CCsGAQUFBwMEMFAGA1UdIARJMEcwOgYMKwYBBAGyMQECAQoCMCowKAYIKwYBBQUHAgEWHGh0dHBz
Oi8vc2VjdGlnby5jb20vU01JTUVDUFMwCQYHZ4EMAQUBAzBaBgNVHR8EUzBRME+gTaBLhklodHRw
Oi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29SU0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3Vy
ZUVtYWlsQ0EuY3JsMIGKBggrBgEFBQcBAQR+MHwwVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuc2Vj
dGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5j
cnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3NwLnNlY3RpZ28uY29tMBwGA1UdEQQVMBOBEWR3bXdA
YW1hem9uLmNvLnVrMA0GCSqGSIb3DQEBCwUAA4IBAQBA+k/q3z9lz3S3x6AneZ9YhiHGGrlnzx0X
WTdk8O2uzRFyJJtsmTYszkqadzazIljgTdd14Kp2C7KnacSYW48CnMyl+dP6n4YZDh7a0NBkZLnM
myuOOwGrpfNHGU/E91hvVPXYZdwrfzLsigVkINzGJW1E+ruJAvT5PK3fnEdeLbWEVFgyk0tgay+3
vI6TZrQqBGpA5DGODK6aDMDNX+ADVamfHJw57cF6uaK5mSJLDdg6sbCi5qxclQDjYakkk+9iJgXy
FVoRUUwhfbU3COcBP9EpJduRWZkrAQdi1IHnICuzGcsPQ6P29LGEvvGJgP7o1AqjW9HzyQRPwfbw
aJobMYIExDCCBMACAQEwgaswgZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNo
ZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+MDwGA1UE
AxM1U2VjdGlnbyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0EC
EFQru/eJkU7BxeS7T6sWKmYwDQYJYIZIAWUDBAIBBQCgggHpMBgGCSqGSIb3DQEJAzELBgkqhkiG
9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTI1MTIwMTE0NDQ1OVowLwYJKoZIhvcNAQkEMSIEIJrH/AT9
F70Hd7ffDDnndW5PLOBxF6cJBAv57+v3vFX8MIG8BgkrBgEEAYI3EAQxga4wgaswgZYxCzAJBgNV
BAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAW
BgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xpZW50IEF1dGhl
bnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1haWwgQ0ECEFQru/eJkU7BxeS7T6sWKmYwgb4GCyqGSIb3
DQEJEAILMYGuoIGrMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVy
MRAwDgYDVQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNl
Y3RpZ28gUlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBAhBUK7v3
iZFOwcXku0+rFipmMA0GCSqGSIb3DQEBAQUABIICAJ1lQkvA2INWEEGOUXLvGHzSdAQsWc8ySiYC
/kTlT95Hwws/Wg1UD2kDEoNMELPw+a2zBMbfj9s3fDDjmWEziqKDo7MsNaKWu+CIP0za9NEe7XEF
HDcYchxEyVrl6JSJHVPdOyMmXk2nmIRJdDtrg8+Um91qYSm0cvFA8ochrLIaMZ5nIOXQMi1lWiRp
8mt06VFm1ATSsGXS7V8RX3nTNxqmkFgDbvFCBBtaFG0xYmSBcPZMUkCiPsf5xcniEQ2i/rxGQD2i
iYgguKe7ldIpYiWomNvcrOyu/8m2NXiabLsYQAzYo4u6V+jGxecVPKYTXSZCmwnwoDe7yz+BCKSS
ENFbzxqH8DvwgT2SsIcKZuky1KHOyJuOODFlbSbs8BZDHGDxmG+y8cU1g4Q0IlafecJ3/2lTHaFT
Sz2NJvDA+LJKlmLDcRn0VxXAAkEicvg2T8NBTZVmhJGg0UGd4ncha1Besxi6f48Wf7n8l/H+v+KX
NGe1RiYlU4eL1YtkRD/+kzRTyyZghvtQysBhJN1RTJNuNKnVkKbUcChH1mcDumhjh0QP8oIMIgm7
dtz7uId8/eHu8O3g1cKmBo7gw4DNCSws0Nfhqgp+oJ6Sj3BkbZwzieM/DFfv3PQjrtziv2Dwwzk3
z8T4HFnDbzDDi4yMtyq+YFz5a4//l4JqF/81qTa4AAAAAAAA


--=-STgedMsGNI3h0h+/AFyg--

--===============5292545290439379605==
Content-Type: multipart/alternative; boundary="===============6592948740844980269=="
MIME-Version: 1.0
Content-Disposition: inline

--===============6592948740844980269==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============6592948740844980269==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============6592948740844980269==--
--===============5292545290439379605==--

