Return-Path: <kvm+bounces-888-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 191157E402D
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 14:40:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 503DB1C20C92
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 13:40:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F8F330CF7;
	Tue,  7 Nov 2023 13:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aDyuVW2Z"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A932FE3A
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 13:40:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8543A9
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 05:40:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699364446;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NHuO1OojHY7F9rWwEFTdZTm7zhHRCPLRzfq8vCij62c=;
	b=aDyuVW2ZFJEgplQUsn7mDg15Vyiya1vAiThnOELu/2ATUxA0mdq/TmGCku5mIoSqXRr0em
	IUwA2e9dfOF+5iqDdsC+HC9Dec072R/WlVh/RoZ5u6ns96+frMPqT3lNu2P1ejlQpdlLb0
	GHqqyS5UQQGVZ1PcPtUW9uTPM7CDFK8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-498-OXJe754lPCaTuJ2nvsmUSQ-1; Tue, 07 Nov 2023 08:40:45 -0500
X-MC-Unique: OXJe754lPCaTuJ2nvsmUSQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 381BD8556E9;
	Tue,  7 Nov 2023 13:40:44 +0000 (UTC)
Received: from localhost (unknown [10.39.194.130])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 46AA72026D66;
	Tue,  7 Nov 2023 13:40:42 +0000 (UTC)
Date: Tue, 7 Nov 2023 21:40:40 +0800
From: Stefan Hajnoczi <stefanha@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: qemu-devel@nongnu.org, Stefan Hajnoczi <stefanha@redhat.com>,
	Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Anthony Perard <anthony.perard@citrix.com>,
	Paul Durrant <paul@xen.org>,
	=?iso-8859-1?Q?Marc-Andr=E9?= Lureau <marcandre.lureau@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Jason Wang <jasowang@redhat.com>,
	Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
	xen-devel@lists.xenproject.org, kvm@vger.kernel.org
Subject: Re: [PULL 00/15] xenfv.for-upstream queue
Message-ID: <20231107134040.GA1010741@fedora>
References: <20231107092149.404842-1-dwmw2@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="GSuJ/hBc0Lx51aih"
Content-Disposition: inline
In-Reply-To: <20231107092149.404842-1-dwmw2@infradead.org>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.4


--GSuJ/hBc0Lx51aih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Applied, thanks.

Please update the changelog at https://wiki.qemu.org/ChangeLog/8.2 for any user-visible changes.

--GSuJ/hBc0Lx51aih
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmVKPlgACgkQnKSrs4Gr
c8go6QgAldelY+trwwwNMAllr73WkdwjqbENy+zeBaBa2FAdn9YSw3bke+1Xwo/M
i5mzyJahOWqCBm6B8JS3r7ERxhaln3x4jVxxkSBCcLKLh31WAaaPFRLb0WVr6Wqe
hWQ7dTmOu7V/J2xmpi+FTB4AP4ng5259uWKqsZgsfJvPU+tOsKxscm7ERerOO21A
IoH+7v+IK8uhN94hWcOXcsJlRY8HxMmigsDRTGjex/NuWuQkOW+iMJqhgyANnr+e
h1FMvC18NFzynfvr3Gd750fTps7SLhf0eDQUNpIZvPX6P1Trz9KD9DTQcJ9QZpra
V3L/gTy+FrrDaEEFB8KGtSwyYqSicg==
=TuL5
-----END PGP SIGNATURE-----

--GSuJ/hBc0Lx51aih--


