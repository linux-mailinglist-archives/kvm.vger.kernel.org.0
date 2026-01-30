Return-Path: <kvm+bounces-69668-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KElpJSRFfGnfLgIAu9opvQ
	(envelope-from <kvm+bounces-69668-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:44:04 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 34700B7628
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 06:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id F0E49302F727
	for <lists+kvm@lfdr.de>; Fri, 30 Jan 2026 05:43:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E0283783B6;
	Fri, 30 Jan 2026 05:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2NEkiG3"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9316533CEB7;
	Fri, 30 Jan 2026 05:43:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769751807; cv=none; b=mRoJ3aLoPqSNgt5PhgU1TSHDlBan4T2Zo7URx6XK7+mdWaWWgeqKPmsjfLERC0hI1328qpniuZwgfmmTJHHB+YiIKi4vyf+TvdgfrRIk3arwzPN6XMkbqz6fo9KIA9UDQNV/iVE6CCRRoWjINkIqFIE7WAn2zJA5z48i2T0LWoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769751807; c=relaxed/simple;
	bh=1mj10mAR+dREfsDvfo4M+yfN+P1zHg8E8B5cbP3m5V0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fko8fCH5zz6UEdGzqCIY78Q73QC33w2MFVpzRZljxa76z8YTlII1H23KG/A6oNl1E7pZA5SNXbLfLQosC+ia+jaEeZb7/lT5WhJNh2wudk8+ImMylTWy5OzIKBzDriwvDn83vNO6wqb5NzMxZ5D6O2Cw1eQcDq1mBAmOR6GAvpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2NEkiG3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E00EC4CEF7;
	Fri, 30 Jan 2026 05:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769751807;
	bh=1mj10mAR+dREfsDvfo4M+yfN+P1zHg8E8B5cbP3m5V0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M2NEkiG3nXvvzMUybPf9u2NsYSvRQJPu/txpSsJ+Qsxe4sqfutLmoEU01sEJ8CMIg
	 I8qJygosMIvzV8Of29N3Q+NJ4IHqtJpQhzT+fhE6yUEPTeU+erOtBeCAbmFGR6dG/L
	 E41kzSGtTsuhJoFAsbxx660eUE1Lspm74+ePErFMRfookARjIAbj+d5y8bxZjOG3DU
	 tQFiGiDeQxNuiZkSlsQtK41CFeWa6ILJtXkFNDVk30w/Rnxyezaqc8f7v77sWasdlr
	 bW4sKqqCB6eR9qjkzlxTaYVQ4r7qf/9DIoodjgENpnF0X4+qtu5CzCULpCvoHa985+
	 ryXH1ILEAGAQw==
Date: Fri, 30 Jan 2026 06:43:17 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: "Tian, Kevin" <kevin.tian@intel.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Pranjal Shrivastava <praan@google.com>, Sumit Semwal
 <sumit.semwal@linaro.org>, Christian =?UTF-8?B?S8O2bmln?=
 <christian.koenig@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 "David Airlie" <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Gerd
 Hoffmann <kraxel@redhat.com>, Dmitry Osipenko
 <dmitry.osipenko@collabora.com>, Gurchetan Singh
 <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, Maarten
 Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, "Lucas De
 Marchi" <lucas.demarchi@intel.com>, Thomas =?UTF-8?B?SGVsbHN0csO2bQ==?=
 <thomas.hellstrom@linux.intel.com>, "Vivi, Rodrigo"
 <rodrigo.vivi@intel.com>, Joerg Roedel <joro@8bytes.org>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Felix Kuehling
 <Felix.Kuehling@amd.com>, "Alex Williamson" <alex@shazbot.org>, Ankit
 Agrawal <ankita@nvidia.com>, "Kasireddy, Vivek"
 <vivek.kasireddy@intel.com>, "linux-media@vger.kernel.org"
 <linux-media@vger.kernel.org>, "dri-devel@lists.freedesktop.org"
 <dri-devel@lists.freedesktop.org>, "linaro-mm-sig@lists.linaro.org"
 <linaro-mm-sig@lists.linaro.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>, "amd-gfx@lists.freedesktop.org"
 <amd-gfx@lists.freedesktop.org>, "virtualization@lists.linux.dev"
 <virtualization@lists.linux.dev>, "intel-xe@lists.freedesktop.org"
 <intel-xe@lists.freedesktop.org>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "iommu@lists.linux.dev"
 <iommu@lists.linux.dev>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Subject: Re: [PATCH v5 4/8] vfio: Wait for dma-buf invalidation to complete
Message-ID: <20260130064317.3c0fead7@foz.lan>
In-Reply-To: <BN9PR11MB5276907FC927424043C636E68C9FA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20260124-dmabuf-revoke-v5-0-f98fca917e96@nvidia.com>
	<20260124-dmabuf-revoke-v5-4-f98fca917e96@nvidia.com>
	<aXfUZcSEr9N18o6w@google.com>
	<20260127085835.GQ13967@unreal>
	<20260127162754.GH1641016@ziepe.ca>
	<BN9PR11MB5276B99D4E8C6496B0C447888C9EA@BN9PR11MB5276.namprd11.prod.outlook.com>
	<20260129145851.GE2307128@ziepe.ca>
	<BN9PR11MB5276907FC927424043C636E68C9FA@BN9PR11MB5276.namprd11.prod.outlook.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-69668-lists,kvm=lfdr.de,huawei];
	RCVD_COUNT_THREE(0.00)[4];
	TO_DN_EQ_ADDR_SOME(0.00)[];
	FREEMAIL_CC(0.00)[ziepe.ca,kernel.org,google.com,linaro.org,amd.com,gmail.com,ffwll.ch,redhat.com,collabora.com,chromium.org,linux.intel.com,suse.de,intel.com,8bytes.org,arm.com,shazbot.org,nvidia.com,vger.kernel.org,lists.freedesktop.org,lists.linaro.org,lists.linux.dev];
	RCPT_COUNT_TWELVE(0.00)[36];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[mchehab@kernel.org,kvm@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.996];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[kvm];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,intel.com:email,ziepe.ca:email]
X-Rspamd-Queue-Id: 34700B7628
X-Rspamd-Action: no action

On Fri, 30 Jan 2026 03:12:02 +0000
"Tian, Kevin" <kevin.tian@intel.com> wrote:

> > From: Jason Gunthorpe <jgg@ziepe.ca>
> > Sent: Thursday, January 29, 2026 10:59 PM
> >=20
> > On Thu, Jan 29, 2026 at 07:06:37AM +0000, Tian, Kevin wrote: =20
> > > Bear me if it's an ignorant question.
> > >
> > > The commit msg of patch6 says that VFIO doesn't tolerate unbounded
> > > wait, which is the reason behind the 2nd timeout wait here. =20
> >=20
> > As far as I understand dmabuf design a fence wait should complete
> > eventually under kernel control, because these sleeps are
> > sprinkled all around the kernel today.
> >=20
> > I suspect that is not actually true for every HW, probably something
> > like "shader programs can run forever technically".
> >=20
> > We can argue if those cases should not report revocable either, but at
> > least this will work "correctly" even if it takes a huge amount of
> > time. =20
>=20
> good to know those background.
>=20
> >=20
> > I wouldn't mind seeing a shorter timeout and print on the fence too
> > just in case.
> >  =20
>=20
> either way is OK. It's not difficult to figure out a long wait anyway. =
=F0=9F=98=8A

Please don't use Outlook when answering to patches - or ensure that
it is properly patched to only send plain text - which I don't
think it is possible.

If you look on this message source code, it is not in plain text:

	Content-Type: text/plain; charset=3D"utf-8"
	Content-Transfer-Encoding: base64

Your message content is:

	PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0B6aWVwZS5jYT4NCj4gU2VudDogVGh1cnNkYX=
ks
	IEphbnVhcnkgMjksIDIwMjYgMTA6NTkgUE0NCj4gDQo+IE9uIFRodSwgSmFuIDI5LCAyMDI2IG=
F0
	IDA3OjA2OjM3QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+IEJlYXIgbWUgaWYgaX=
Qn
	cyBhbiBpZ25vcmFudCBxdWVzdGlvbi4NCj4gPg0KPiA+IFRoZSBjb21taXQgbXNnIG9mIHBhdG=
No
	NiBzYXlzIHRoYXQgVkZJTyBkb2Vzbid0IHRvbGVyYXRlIHVuYm91bmRlZA0KPiA+IHdhaXQsIH=
do
	aWNoIGlzIHRoZSByZWFzb24gYmVoaW5kIHRoZSAybmQgdGltZW91dCB3YWl0IGhlcmUuDQo+IA=
0K
	PiBBcyBmYXIgYXMgSSB1bmRlcnN0YW5kIGRtYWJ1ZiBkZXNpZ24gYSBmZW5jZSB3YWl0IHNob3=
Vs
	ZCBjb21wbGV0ZQ0KPiBldmVudHVhbGx5IHVuZGVyIGtlcm5lbCBjb250cm9sLCBiZWNhdXNlIH=
Ro
	ZXNlIHNsZWVwcyBhcmUNCj4gc3ByaW5rbGVkIGFsbCBhcm91bmQgdGhlIGtlcm5lbCB0b2RheS=
4N
	Cj4gDQo+IEkgc3VzcGVjdCB0aGF0IGlzIG5vdCBhY3R1YWxseSB0cnVlIGZvciBldmVyeSBIVy=
wg
	cHJvYmFibHkgc29tZXRoaW5nDQo+IGxpa2UgInNoYWRlciBwcm9ncmFtcyBjYW4gcnVuIGZvcm=
V2
	ZXIgdGVjaG5pY2FsbHkiLg0KPiANCj4gV2UgY2FuIGFyZ3VlIGlmIHRob3NlIGNhc2VzIHNob3=
Vs
	ZCBub3QgcmVwb3J0IHJldm9jYWJsZSBlaXRoZXIsIGJ1dCBhdA0KPiBsZWFzdCB0aGlzIHdpbG=
wg
	d29yayAiY29ycmVjdGx5IiBldmVuIGlmIGl0IHRha2VzIGEgaHVnZSBhbW91bnQgb2YNCj4gdG=
lt
	ZS4NCg0KZ29vZCB0byBrbm93IHRob3NlIGJhY2tncm91bmQuDQoNCj4gDQo+IEkgd291bGRuJ3=
Qg
	bWluZCBzZWVpbmcgYSBzaG9ydGVyIHRpbWVvdXQgYW5kIHByaW50IG9uIHRoZSBmZW5jZSB0b2=
8N
	Cj4ganVzdCBpbiBjYXNlLg0KPiANCg0KZWl0aGVyIHdheSBpcyBPSy4gSXQncyBub3QgZGlmZm=
lj
	dWx0IHRvIGZpZ3VyZSBvdXQgYSBsb25nIHdhaXQgYW55d2F5LiDwn5iKDQo=3D

which is something that patch tools - in special patchwork - won't handle.

Thanks,
Mauro

