Return-Path: <kvm+bounces-6400-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 4AB07830B18
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 17:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B29731F2A0ED
	for <lists+kvm@lfdr.de>; Wed, 17 Jan 2024 16:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C808224CE;
	Wed, 17 Jan 2024 16:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b="fDJcpzlz"
X-Original-To: kvm@vger.kernel.org
Received: from smtp-fw-80009.amazon.com (smtp-fw-80009.amazon.com [99.78.197.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8F501E875
	for <kvm@vger.kernel.org>; Wed, 17 Jan 2024 16:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=99.78.197.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705509171; cv=none; b=BoxGVetlxK+K5c3HidMrGI1Bm4iVvkTrorw+BGAmW+gGwx8qC+TPtWn2nTSu2vaeIlN7LIFeUWwnnLG8cWcrwx6VfBpVBDJ6o4hOOnVGgy/CYbjfl3IwC7A6Ejh+e1ZWWsl5fKovLnI90n1U3brxhggilRkhC+BQL06kfodMD6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705509171; c=relaxed/simple;
	bh=kZF29l971OEze4fp9GcdEgD5AgXyDq4yWBaJB2rL4O0=;
	h=DKIM-Signature:X-Amazon-filename:X-IronPort-AV:Content-Type:
	 MIME-Version:Received:Received:Received:X-Farcaster-Flow-ID:
	 Received:Received:Received:From:To:CC:Subject:Thread-Topic:
	 Thread-Index:Date:Message-ID:References:In-Reply-To:
	 Accept-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:
	 x-originating-ip:MIME-Version; b=QpSQM/qD2XvVGeXK34Lg+ieOFeYTG1p0yHEQVaDf8AoELUYWgGp2UtBzivoGQvdTcdNwTtuZktovZ1vpCBgjLkB/mUwXU1ukTYqvmR0V/LMMxQACcH6OJY2CWupII9/RlsKM8S/HSYw0wObvKsWyeJr6GtsSWdHIDu5+NWt9GqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk; spf=pass smtp.mailfrom=amazon.co.uk; dkim=pass (1024-bit key) header.d=amazon.co.uk header.i=@amazon.co.uk header.b=fDJcpzlz; arc=none smtp.client-ip=99.78.197.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.co.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazon201209; t=1705509169; x=1737045169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to;
  bh=P+H+MP3pAB0zmqLqoXhHUEwHm7PtG9sVA0Hc27l9hjE=;
  b=fDJcpzlzL4w8ht/TRAjkF6+luG8g7qWKiEmCyqWQNPaz4AOgeX2KGga5
   PAxvHDjUJ8O+nfBadaHa/FsAO/sopHQ9jekF41jD4nw1Wi71K0Rqm6eHH
   vXpzE9ipLSaP6ytCgWp42S2q92P430QJ53/elCu+j4LG7yUgEcXhZSesQ
   s=;
X-Amazon-filename: smime.p7s
X-IronPort-AV: E=Sophos;i="6.05,200,1701129600"; 
   d="p7s'?scan'208";a="58962778"
Content-Type: multipart/mixed; boundary="===============8175054459963755501=="
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80009.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 16:32:39 +0000
Received: from smtpout.prod.us-west-2.prod.farcaster.email.amazon.dev (pdx2-ws-svc-p26-lb5-vlan3.pdx.amazon.com [10.39.38.70])
	by email-inbound-relay-pdx-2c-m6i4x-f7c754c9.us-west-2.amazon.com (Postfix) with ESMTPS id 79E2240E6A;
	Wed, 17 Jan 2024 16:32:39 +0000 (UTC)
Received: from EX19MTAEUB002.ant.amazon.com [10.0.10.100:58516]
 by smtpin.naws.eu-west-1.prod.farcaster.email.amazon.dev [10.0.41.56:2525] with esmtp (Farcaster)
 id d6789a5a-5aad-4d3b-a921-248da66414df; Wed, 17 Jan 2024 16:32:38 +0000 (UTC)
X-Farcaster-Flow-ID: d6789a5a-5aad-4d3b-a921-248da66414df
Received: from EX19D032EUC002.ant.amazon.com (10.252.61.185) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 17 Jan 2024 16:32:37 +0000
Received: from EX19D008UEC001.ant.amazon.com (10.252.135.232) by
 EX19D032EUC002.ant.amazon.com (10.252.61.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.40; Wed, 17 Jan 2024 16:32:36 +0000
Received: from EX19D008UEC001.ant.amazon.com ([fe80::4702:5d1a:c556:797]) by
 EX19D008UEC001.ant.amazon.com ([fe80::4702:5d1a:c556:797%3]) with mapi id
 15.02.1118.040; Wed, 17 Jan 2024 16:32:36 +0000
From: "Woodhouse, David" <dwmw@amazon.co.uk>
To: "seanjc@google.com" <seanjc@google.com>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "Durrant, Paul" <pdurrant@amazon.co.uk>
Subject: Re: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix locking
 issues
Thread-Topic: [PATCH] KVM: pfncache: rework __kvm_gpc_refresh() to fix locking
 issues
Thread-Index: AQHaSWLHnrMuqpEfr06LffYPpxRRow==
Date: Wed, 17 Jan 2024 16:32:35 +0000
Message-ID: <ef60725c38faa30132ab45cf14ee0af86e885596.camel@amazon.co.uk>
References: <9a82db197449bdb97ee889d2f3cdd7998abd9692.camel@amazon.co.uk>
	 <Zaf7yCYt8XFuMhAd@google.com>
In-Reply-To: <Zaf7yCYt8XFuMhAd@google.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
MIME-Version: 1.0

--===============8175054459963755501==
Content-Language: en-US
Content-Type: multipart/signed; micalg=sha-256;
	protocol="application/pkcs7-signature"; boundary="=-kMgXPlGUuGOSoLwtVVe0"

--=-kMgXPlGUuGOSoLwtVVe0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2024-01-17 at 08:09 -0800, Sean Christopherson wrote:
> On Fri, Jan 12, 2024, David Woodhouse wrote:
> > This function can race with kvm_gpc_deactivate(). Since that function
> > does not take the ->refresh_lock, it can wipe and unmap the pfn and
> > khva while hva_to_pfn_retry() has dropped its write lock on gpc->lock.
> >=20
> > Then if hva_to_pfn_retry() determines that the PFN hasn't changed and
> > that it can re-use the old pfn and khva, they get assigned back to
> > gpc->pfn and gpc->khva even though the khva was already unmapped by
> > kvm_gpc_deactivate(). This leaves the cache in an apparently valid
> > state but with ->khva pointing to an address which has been unmapped.
> > Which in turn leads to oopses in e.g. __kvm_xen_has_interrupt() and
> > set_shinfo_evtchn_pending().
> >=20
> > It may be possible to fix this just by making kvm_gpc_deactivate()
> > take the ->refresh_lock, but that still leaves ->refresh_lock being
> > basically redundant with the write lock on ->lock, which frankly
> > makes my skin itch, with the way that pfn_to_hva_retry() operates on
> > fields in the gpc without holding ->lock.
> >=20
> > Instead, fix it by cleaning up the semantis of hva_to_pfn_retry(). It
> > no longer operates on the gpc object at all; it's called with a uhva
> > and returns the corresponding pfn (pinned), and a mapped khva for it.
> >=20
> > The calling function __kvm_gpc_refresh() now drops ->lock before callin=
g
> > hva_to_pfn_retry(), then retakes the lock before checking for changes,
> > and discards the new mapping if it lost a race. And will correctly
> > note the old pfn/khva to be unmapped at the right time, instead of
> > preserving them in a local variable while dropping the lock.
> >=20
> > The optimisation in hva_to_pfn_retry() where it attempts to use the
> > old mapping if the pfn doesn't change is dropped, since it makes the
> > pinning more complex. It's a pointless optimisation anyway, since the
> > odds of the pfn ending up the same when the uhva has changed (i.e.
> > the odds of the two userspace addresses both pointing to the same
> > underlying physical page) are negligible,
> >=20
> > I remain slightly confused because although this is clearly a race in
> > the gfn_to_pfn_cache code, I don't quite know how the Xen support code
> > actually managed to trigger it. We've seen oopses from dereferencing a
> > valid-looking ->khva in both __kvm_xen_has_interrupt() (the vcpu_info)
> > and in set_shinfo_evtchn_pending() (the shared_info). But surely the
> > race shouldn't happen for the vcpu_info gpc because all calls to both
> > refresh and deactivate hold the vcpu mutex, and it shouldn't happen
>=20
> FWIW, neither kvm_xen_destroy_vcpu() nor kvm_xen_destroy_vm() holds the a=
ppropriate
> mutex.=C2=A0=20

Those shouldn't be implicated in the cases where we've seen it happen.
And I think it needs the GPC to be left in !active,valid state due to
the race and then *reactivated*, while still marked 'valid'. Which
can't happen after the destroy paths.

>=20
> > for the shared_info gpc because all calls to both will hold the
> > kvm->arch.xen.xen_lock mutex.
> >=20
> > Signed-off-by: David Woodhouse <dwmw@amazon.co.uk>
> > ---
> >=20
> > This is based on (and in) my tree at
> > https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/xen=
fv
> > which has all the other outstanding KVM/Xen fixes.
> >=20
> > =C2=A0virt/kvm/pfncache.c | 181 +++++++++++++++++++++------------------=
-----
> > =C2=A01 file changed, 85 insertions(+), 96 deletions(-)
>=20
> NAK, at least as a bug fix.=C2=A0 We've already shuffled deck chairs on t=
he Titanic
> several times, I have zero confidence that doing so one more time is goin=
g to
> truly solve the underlying mess.

Agreed, but as it stands, especially with refresh_lock, this is just
overly complex. We should make the rwlock stand alone, and not have
code which drops the lock and then makes assumptions that things won't
change.


> The contract with the gfn_to_pfn_cache, or rather the lack thereof, is al=
l kinds
> of screwed up.=C2=A0 E.g. I added the mutex in commit 93984f19e7bc ("KVM:=
 Fully serialize
> gfn=3D>pfn cache refresh via mutex") to guard against concurrent unmap(),=
 but the
> unmap() API has since been removed.=C2=A0 We need to define an actual con=
tract instead
> of continuing to throw noodles as the wall in the hope that something sti=
cks.
>=20
> As you note above, some other mutex _should_ be held.=C2=A0 I think we sh=
ould lean
> into that.=C2=A0 E.g.

I don't. I'd like this code to stand alone *without* making the caller
depend on "some other lock" just for its own internal consistency.


> =C2=A0 1. Pass in the guarding mutex to kvm_gpc_init() and assert that sa=
id mutex is
> =C2=A0=C2=A0=C2=A0=C2=A0 held for __refresh(), activate(), and deactivate=
().
> =C2=A0 2. Fix the cases where that doesn't hold true.
> =C2=A0 3. Drop refresh_mutex
>=20

I'll go for (3) but I disagree about (1) and (2). Just let the rwlock
work as $DEITY intended, which is what this patch is doing. It's a
cleanup.

(And I didn't drop refresh_lock so far partly because it wants to be
done in a separate commit, but also because it does provide an
optimisation, as noted.

--=-kMgXPlGUuGOSoLwtVVe0
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Disposition: attachment; filename="smime.p7s"
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExDzANBglghkgBZQMEAgEFADCABgkqhkiG9w0BBwEAAKCCEjww
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
5ZgtwCLXgAIe5W8mybM2JzCCBhAwggT4oAMCAQICEQC/QgfpbUT3q2fHshU/ReqfMA0GCSqGSIb3
DQEBCwUAMIGWMQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYD
VQQHEwdTYWxmb3JkMRgwFgYDVQQKEw9TZWN0aWdvIExpbWl0ZWQxPjA8BgNVBAMTNVNlY3RpZ28g
UlNBIENsaWVudCBBdXRoZW50aWNhdGlvbiBhbmQgU2VjdXJlIEVtYWlsIENBMB4XDTIyMDEwNzAw
MDAwMFoXDTI1MDEwNjIzNTk1OVowIjEgMB4GCSqGSIb3DQEJARYRZHdtd0BhbWF6b24uY28udWsw
ggIiMA0GCSqGSIb3DQEBAQUAA4ICDwAwggIKAoICAQCZgnzd4h6STv/MQcUPixvDN/dNtp4yVSdc
xz9mB1OcA7HXd4WdPyYagmkcH0WguDYaQnOszkSdElI+2XRFSlGXhY7U9tktvdWuY1zAY1UWES8e
3BUHqSKbIKx4SX6GuctCcPnyagVZ9Hk21YUElx9cdmrqt0bGoydgxAspEx56J9Q5a48WfvFYjLBF
NL1dw+P1eUeAljco30+Xggf5faawKfPArUX0cmU4VIh5DMUyv4d0xxfNN6cK1GMj/HGUg2T9OTHW
nbTdq+OHJwHGi/37mCWx1O3uV0hbZzA1fNklaqlsr1Acg0elPeCFXLb8dSkMgQZHNJVjn+mBvG4d
MG4FS3ntipApytA+a5IaMP3LNAo0EoBd5/xVy0M6TXbiYesYLq9rhnrLgO1qcw7+if0jH9YoEJ6a
Je1m7omfEXh2XpospSLaohmAqaBKlyhXDXbTnUVnIf79zU5ohHZof0cP2amnnvYUVD72iuf9qe7X
4L1Rj589qEWYROKiMil5X7l/smE1dAmxhKxx6YWvWkXH9u7JOcmLGdKST0voaY7j3Wk0lxK3NKsk
q0G3BpqbPz3P8BYtn38BvbkFnwVW7F7Qzus3KZJgP62eN25QHxoFj44x3sppx4I5WlYG4lxdFZsY
smQdj64c7MaJ7cp8RJN+eO32RKrkndEkihzxevl11wIDAQABo4IByjCCAcYwHwYDVR0jBBgwFoAU
CcDy/AvalNtf/ivfqJlCz8ngrQAwHQYDVR0OBBYEFJ418HpIgZaPnwpWdCNSvm4XgH/lMA4GA1Ud
DwEB/wQEAwIFoDAMBgNVHRMBAf8EAjAAMB0GA1UdJQQWMBQGCCsGAQUFBwMEBggrBgEFBQcDAjBA
BgNVHSAEOTA3MDUGDCsGAQQBsjEBAgEBATAlMCMGCCsGAQUFBwIBFhdodHRwczovL3NlY3RpZ28u
Y29tL0NQUzBaBgNVHR8EUzBRME+gTaBLhklodHRwOi8vY3JsLnNlY3RpZ28uY29tL1NlY3RpZ29S
U0FDbGllbnRBdXRoZW50aWNhdGlvbmFuZFNlY3VyZUVtYWlsQ0EuY3JsMIGKBggrBgEFBQcBAQR+
MHwwVQYIKwYBBQUHMAKGSWh0dHA6Ly9jcnQuc2VjdGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1
dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5jcnQwIwYIKwYBBQUHMAGGF2h0dHA6Ly9vY3Nw
LnNlY3RpZ28uY29tMBwGA1UdEQQVMBOBEWR3bXdAYW1hem9uLmNvLnVrMA0GCSqGSIb3DQEBCwUA
A4IBAQCSez7gtf1wlWJr568crX21nm6QFWRdJ/YxMOReeqYtGs8QZf2zm2vIEFab61MrgJFJcFJL
sRhVHwnH/hvax3ZldDpUhM0ODpA9soUjYsvKJ0boFAHPtI1BL0yrZNCBdsUGxMv0t64Acj2ovxQ+
OxPd5ngHu0MzYIKLDvTSehxkh/qW23X7Ey/fPR0sgnAK4IV7clidmuWBbrqX+WKEyEP2kaEvLsRg
8plzYbVVFJl37rX2waKnGaWYnJ3BrvcMMgDSQCuoxMThWAOr7wxOh0ni0K3rW7CwDIAjUSk+fFmS
2EacUvIv/0xUW1nXzGJ12/Qyi+Mw65m0qE776qfcftg3MIIGEDCCBPigAwIBAgIRAL9CB+ltRPer
Z8eyFT9F6p8wDQYJKoZIhvcNAQELBQAwgZYxCzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVy
IE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1NlY3RpZ28gTGltaXRlZDE+
MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9uIGFuZCBTZWN1cmUgRW1h
aWwgQ0EwHhcNMjIwMTA3MDAwMDAwWhcNMjUwMTA2MjM1OTU5WjAiMSAwHgYJKoZIhvcNAQkBFhFk
d213QGFtYXpvbi5jby51azCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAJmCfN3iHpJO
/8xBxQ+LG8M39022njJVJ1zHP2YHU5wDsdd3hZ0/JhqCaRwfRaC4NhpCc6zORJ0SUj7ZdEVKUZeF
jtT22S291a5jXMBjVRYRLx7cFQepIpsgrHhJfoa5y0Jw+fJqBVn0eTbVhQSXH1x2auq3RsajJ2DE
CykTHnon1DlrjxZ+8ViMsEU0vV3D4/V5R4CWNyjfT5eCB/l9prAp88CtRfRyZThUiHkMxTK/h3TH
F803pwrUYyP8cZSDZP05MdadtN2r44cnAcaL/fuYJbHU7e5XSFtnMDV82SVqqWyvUByDR6U94IVc
tvx1KQyBBkc0lWOf6YG8bh0wbgVLee2KkCnK0D5rkhow/cs0CjQSgF3n/FXLQzpNduJh6xgur2uG
esuA7WpzDv6J/SMf1igQnpol7WbuiZ8ReHZemiylItqiGYCpoEqXKFcNdtOdRWch/v3NTmiEdmh/
Rw/Zqaee9hRUPvaK5/2p7tfgvVGPnz2oRZhE4qIyKXlfuX+yYTV0CbGErHHpha9aRcf27sk5yYsZ
0pJPS+hpjuPdaTSXErc0qySrQbcGmps/Pc/wFi2ffwG9uQWfBVbsXtDO6zcpkmA/rZ43blAfGgWP
jjHeymnHgjlaVgbiXF0VmxiyZB2PrhzsxontynxEk3547fZEquSd0SSKHPF6+XXXAgMBAAGjggHK
MIIBxjAfBgNVHSMEGDAWgBQJwPL8C9qU21/+K9+omULPyeCtADAdBgNVHQ4EFgQUnjXwekiBlo+f
ClZ0I1K+bheAf+UwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYIKwYB
BQUHAwQGCCsGAQUFBwMCMEAGA1UdIAQ5MDcwNQYMKwYBBAGyMQECAQEBMCUwIwYIKwYBBQUHAgEW
F2h0dHBzOi8vc2VjdGlnby5jb20vQ1BTMFoGA1UdHwRTMFEwT6BNoEuGSWh0dHA6Ly9jcmwuc2Vj
dGlnby5jb20vU2VjdGlnb1JTQUNsaWVudEF1dGhlbnRpY2F0aW9uYW5kU2VjdXJlRW1haWxDQS5j
cmwwgYoGCCsGAQUFBwEBBH4wfDBVBggrBgEFBQcwAoZJaHR0cDovL2NydC5zZWN0aWdvLmNvbS9T
ZWN0aWdvUlNBQ2xpZW50QXV0aGVudGljYXRpb25hbmRTZWN1cmVFbWFpbENBLmNydDAjBggrBgEF
BQcwAYYXaHR0cDovL29jc3Auc2VjdGlnby5jb20wHAYDVR0RBBUwE4ERZHdtd0BhbWF6b24uY28u
dWswDQYJKoZIhvcNAQELBQADggEBAJJ7PuC1/XCVYmvnrxytfbWebpAVZF0n9jEw5F56pi0azxBl
/bOba8gQVpvrUyuAkUlwUkuxGFUfCcf+G9rHdmV0OlSEzQ4OkD2yhSNiy8onRugUAc+0jUEvTKtk
0IF2xQbEy/S3rgByPai/FD47E93meAe7QzNggosO9NJ6HGSH+pbbdfsTL989HSyCcArghXtyWJ2a
5YFuupf5YoTIQ/aRoS8uxGDymXNhtVUUmXfutfbBoqcZpZicncGu9wwyANJAK6jExOFYA6vvDE6H
SeLQretbsLAMgCNRKT58WZLYRpxS8i//TFRbWdfMYnXb9DKL4zDrmbSoTvvqp9x+2DcxggTHMIIE
wwIBATCBrDCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdv
IFJTQSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAL9CB+ltRPer
Z8eyFT9F6p8wDQYJYIZIAWUDBAIBBQCgggHrMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJ
KoZIhvcNAQkFMQ8XDTI0MDExNzE2MzIzNFowLwYJKoZIhvcNAQkEMSIEIOP4rayvmS6Xq3XSizTa
Ks/+yY5id6ryLampuPvvBvdjMIG9BgkrBgEEAYI3EAQxga8wgawwgZYxCzAJBgNVBAYTAkdCMRsw
GQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNVBAcTB1NhbGZvcmQxGDAWBgNVBAoTD1Nl
Y3RpZ28gTGltaXRlZDE+MDwGA1UEAxM1U2VjdGlnbyBSU0EgQ2xpZW50IEF1dGhlbnRpY2F0aW9u
IGFuZCBTZWN1cmUgRW1haWwgQ0ECEQC/QgfpbUT3q2fHshU/ReqfMIG/BgsqhkiG9w0BCRACCzGB
r6CBrDCBljELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4GA1UE
BxMHU2FsZm9yZDEYMBYGA1UEChMPU2VjdGlnbyBMaW1pdGVkMT4wPAYDVQQDEzVTZWN0aWdvIFJT
QSBDbGllbnQgQXV0aGVudGljYXRpb24gYW5kIFNlY3VyZSBFbWFpbCBDQQIRAL9CB+ltRPerZ8ey
FT9F6p8wDQYJKoZIhvcNAQEBBQAEggIAc714GA9+GaxxUkO7+SqGG4vds2dObYeoO7hEjAC9nOPd
MM+hueFWElhUQ9zUMuCNqCbbxx8BE3RoLzBtdNRSyEGp8axxYr3KJYzIkHK90ln9/o2x7BiMMO8/
VEU0zOqETO7wMQW2ccy6ZJXmI/t24Z2KPx9OL6VA6INJrcbFKGFkfvlOUgzFklhQ10/RhVhNuIuW
UTWLcxvwBtSRoEInnkPl4CA79EdhMrbf/ZuZvtQBaT/C8CAZxGK4+Ne7cizkGQDUMuH+lFdp4peA
A6/m0/OcupxABUlGWshxF8MG0It9xPKBvxNVEoEUm514eVRjal2MJfQLWRRO0LvcvY23RU6fvK3a
C0W6Om3zrZLBExZ4ORX85jHsXL8tH8btcIxB/60KDPR68zfvEKEjZ1E+rl4II8oCSH6rlymAY+hm
nkLs3srTxGtMKJC4oA29l6Gv4K1p5CiOotcMS5xqJLhSqfN05ID52lA9agmcedhx2VIBeaF4IVGD
6nxbi9mzwxhNMUpDHN7Ive4XjIZyEELxXVQc3798vVteZ+/vxNgW6wQlCR5uZE35du7LMs1FUvC6
JVVBW40ovjwa7UXdlHJ2gGExjG6fQNVbLmQw3mej/tPseX7uQupBwumboedu3pv9dyvEpdRlcgFU
J8bC0GQ2zn/lBOZDmqGEO43p8OR5NSEAAAAAAAA=


--=-kMgXPlGUuGOSoLwtVVe0--

--===============8175054459963755501==
Content-Type: multipart/alternative; boundary="===============0833964598395082214=="
MIME-Version: 1.0
Content-Disposition: inline

--===============0833964598395082214==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable




Amazon Development Centre (London) Ltd. Registered in England and Wales wit=
h registration number 04543232 with its registered office at 1 Principal Pl=
ace, Worship Street, London EC2A 2FA, United Kingdom.



--===============0833964598395082214==
Content-Type: text/html; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

<br><br><br>Amazon Development Centre (London) Ltd.Registered in England an=
d Wales with registration number 04543232 with its registered office at 1 P=
rincipal Place, Worship Street, London EC2A 2FA, United Kingdom.<br><br><br>

--===============0833964598395082214==--
--===============8175054459963755501==--

