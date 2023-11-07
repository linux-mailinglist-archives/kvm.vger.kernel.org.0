Return-Path: <kvm+bounces-829-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E17057E3363
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 04:02:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9BFD4280ED4
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 03:02:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67065211C;
	Tue,  7 Nov 2023 03:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Axkm3X+X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310BDA49
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 03:02:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FF31B2
	for <kvm@vger.kernel.org>; Mon,  6 Nov 2023 19:02:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699326141;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Tz6O63wS9xvXe/DSKsh5Kh+EKEvdNpB8Byv3/EykdAg=;
	b=Axkm3X+XMmiAa29Ye+m403O7mD9VzgBX1X0SapDToVImBIXdn5Pw1jfuBuc3BbQUTVVjgX
	cxL5+NFYYTdVg02WzhIaJasBqlKbq6ONOGV6StcZfpjweSMBmdlFKQHhbSeQJI/nCTT4pA
	XiJkw+lBs9a4NbnwxvWGm/W6DKAJSYM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-Pk4mdENMOXq5-CxBqCqMvw-1; Mon, 06 Nov 2023 22:02:01 -0500
X-MC-Unique: Pk4mdENMOXq5-CxBqCqMvw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F70082193C;
	Tue,  7 Nov 2023 03:02:01 +0000 (UTC)
Received: from localhost (unknown [10.39.192.48])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5019F502B;
	Tue,  7 Nov 2023 03:01:59 +0000 (UTC)
Date: Tue, 7 Nov 2023 11:01:58 +0800
From: Stefan Hajnoczi <stefanha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: qemu-devel@nongnu.org, qemu-stable@nongnu.org,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>, Kevin Wolf <kwolf@redhat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
	kvm@vger.kernel.org
Subject: Re: [PULL 0/7] xenfv-stable queue
Message-ID: <20231107030158.GA952663@fedora>
References: <20231106103955.200867-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="wp5z172Ctjx3Blgf"
Content-Disposition: inline
In-Reply-To: <20231106103955.200867-1-dwmw2@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5


--wp5z172Ctjx3Blgf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.2 for any user-visible changes.

--wp5z172Ctjx3Blgf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVJqKYACgkQnKSrs4Gr
c8gMmwf9GAB7eByH2P6TUvsHNM0P8Xl1xHhxPxDQ3frOBLumzDoLuebaCa2oVib4
T0tEdiG0loSkUc7+MT4y4gWe1+1L5baYwlw2hu4e+6l1lI9qTrvE4BZhn2Dd8Qzz
iJtMERsgLr7Xm1qAId88EC9/FxL4k1fWAaZ2cOzRxtRtJNwfHm8vzTpXryIfnsRz
B/FxIY/zGBpbww8qOA7kUeftb+XRa8O82jSdh/WyHFN0nO4HspLkmnTW3a/LSHUx
qrdweXdCLgmMJHuwqb2aQ3dWK6KKQQphfwSeAlIb+CfmT2aGdt5j1bFVlMDdFuic
aqhiL+Ibvu++zxPXLMagJrI+jY01oQ==
=u1Xn
-----END PGP SIGNATURE-----

--wp5z172Ctjx3Blgf--


