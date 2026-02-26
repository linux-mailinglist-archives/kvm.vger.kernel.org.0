Return-Path: <kvm+bounces-71912-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cKo3EuqXn2k9cwQAu9opvQ
	(envelope-from <kvm+bounces-71912-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:46:34 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD7B619F900
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 01:46:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 8ADEF3033BD1
	for <lists+kvm@lfdr.de>; Thu, 26 Feb 2026 00:46:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EABB36F415;
	Thu, 26 Feb 2026 00:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="RL7yH3su"
X-Original-To: kvm@vger.kernel.org
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470DF36215D
	for <kvm@vger.kernel.org>; Thu, 26 Feb 2026 00:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772066784; cv=pass; b=qll/BMYE/1KZspthFQpPaivMLxUm07vqwbcG4HoMVYdro7GMB/sZswC4HEu+MPsVaCXVBpcHA1G1lHvTtzr8XxN4CCXdmxNRAQfor/pQpVR0eSC326fhWa0v4zpEfLfVf/Cz6UqRWwEgg/iCuXh6k5OLwp5XCWfb3Cj39xMUnBw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772066784; c=relaxed/simple;
	bh=WPcUxRWIf+xdW3rZUp57loGNhqTLwpDKpkxUCRZJXnY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=frQzNd7XbSIF+KNrYJnGb55tXlX1HAR1qulHFeX9We/YKFZ2jnipj4Wk1kSA31TIkFwvG9VG9v+Jby9nyt02zfWLfi49CqA3FbGwqtlnzBbbE1c+ARXS3EHkvvKBJPgOMsLFKsZRV8CMyJGURu9l+DL/5N8CrF5il1pZuToVsjA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=RL7yH3su; arc=pass smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-94dd7178d63so173046241.3
        for <kvm@vger.kernel.org>; Wed, 25 Feb 2026 16:46:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772066782; cv=none;
        d=google.com; s=arc-20240605;
        b=NZZiyqAbFdIXw1hIQQoDiwS9sbAOQ0ZO6eK9M3FDIf2hEHlmmiLcF5TlmaAxEHbtLY
         Xj0vSRbAyMVusk99aHMmAEdnm0fyJu4pC6thTaZLm8STKFkFVI/0k+dfieqonA0t0hyY
         VjqfZUJhVNCUVAoo2P46CpdO/v1ybvhsiO97H3yyjy3e/5zXHU9rJGx0yRaVFaIeAriT
         sAF+SHfJrpw0LBf87oxejRs1YjOZc96cy/FluOmwYrD9AD+gCx/DgQJcOGL5drpxX8bq
         J85Sfvf2KGctIA9VEs77kxIBsEWx/BJ8VNqxV1fAadNosjmk+rf1gRsEBfV7tHK+aOeq
         BnLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        fh=fJmKhhXVDLacC1VKnOJk7LF/i9bA0Xs/YVbHjAmo0Mo=;
        b=Hqh+itvuhmpDhe7KvbpQhUWXotDFKYLuh4YLx5PpUBnM4/mcp1XcZ3ULPdf++ou0uX
         DdHp+0+yFsA3/JETKGHcomgVW9d8beASLRiD9X2gIzjMdMdfu11InnJD15ZuIqgTggah
         988/SKN/XDxelt4niMgIN2H0NUbliCSU5xxD5KA5nEqDU4nAJ+djp1H7VgrMXkD6kc8d
         K8hSTmomOs2D5oQs0cg9/znjVVPi3eopagZJlRxZ1lJKhXTnAPCsWkj51ph3n5OjjQwl
         GCYFqSnu04K8y3MvHLkIDBXpiYxMdQd2ODvReyYbKUN5IoMAyGiGzQxLb6qrXCjVpyK6
         2eVg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772066782; x=1772671582; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        b=RL7yH3sudTnq/XClkaOpF3fuWXUwGuIqMamfzIbLqr7qujx2xZe0DcpkmcUC7pE3nU
         ZlU5K692jKuZVitqPgrzLEDQZYQk0eJeIbWEkOb2MtLDwVBZ9oYbS0eXyTQ5FNLiAjwc
         FdiVg+nwiFAqo1ov/dnoj5KWN1G6zF5SKeofg5TuwnHMu0KjGZYY/y7HEZdug/q91atJ
         BM7ZNRkC9gUeRWYKt3P3ulTmom2i7kp+/uDLB/Sa8RPZYKUnERBZveY94zFkdLU1HwmJ
         Wogt1NZL2yCAafNB320aJceTY/6MTXu8q5NR/zFWbXLqStgoCH3jMnSWvTD7p0w3ECa3
         eppw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772066782; x=1772671582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ACpb0o7E3VaAsC1KFvr2yXYuV7ohO1EROiDs9rJDa00=;
        b=o3g9YibGIvF8DJfxH1PbXm/BDS7ZzTE2otA3zjooh9jUR9Flu/CDbYUL4rqW/pK56w
         Zez1Nn1JBHx7JIkQza/D1BO/M3qZb1R/mcXw9e5nWM1oCo+YpajIW7hEc2MPXaGMG7aI
         U6m82evdbtrd0GPgQHE8bRzDv88rvbCEQEIOUkCQigyog88MYqF9bJlhKAJgZ4CidmBu
         Vk177RSWG7UO6vufx89HrRJs3pTlLW/Fltmocw1oRmTSuGKlGTuiqfKvJUxPtQ4PzB6T
         7hvgmRichFML0lk25BBwi9Ecc48lKdmuPmMTJUHwxwV6p8cBql9Rx0lhhc+9ninarZbG
         F1TA==
X-Forwarded-Encrypted: i=1; AJvYcCXV1bSg4TZSUZZrpmgQTW8LWo7dlnkKTEgLuM14X6CmgIIlGPYIDErFiVwtzTfDYvACt6g=@vger.kernel.org
X-Gm-Message-State: AOJu0YxDOz3fulmpj1zHEC4X+YP+erl0zBdaM3RlWnG6z7Zfysl1pQcb
	7D7BBsm7d4pUHJapq470BReEqZj/6j3yHSfcLiY99365kopPkR275lNkjJ0bZ8gHnb0+tFA0ozu
	giWd3Mo2hIGBK0J7PhC4xHgbxzXEKt4HO0GsmHTi7
X-Gm-Gg: ATEYQzzXha2gteHJ5YTMQOC6ZU48TRZjgz4xS4g7dDL25FagsXdibNN2nZmSZpg4W4u
	Yf6wgVUs/xN+kyW/HO5U/nyGpJTEHoPxFl3ySPv128I4/UEl/5HfUOngVSL1slHMvly/3bdfid5
	Ktcv5SP0TAGvaLDxH4/lTZhToYeeGCKR5iEBMEQWSAdSXyxnp499FbTVDtOkQRYMSEfvELiV47H
	r4uBAVWfbfxJJbR7lLPbi9zgS7DcUvo2u7pfcM1fsEWbhebX0vxuVtpaZsxE0DgY3GsVOdU5LoA
	KM0eXL4=
X-Received: by 2002:a05:6102:94d:b0:5e5:6eee:8adb with SMTP id
 ada2fe7eead31-5feb2e8f35emr8956594137.4.1772066781725; Wed, 25 Feb 2026
 16:46:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-8-dmatlack@google.com>
 <aZ6rB-zmpaR3RLB_@google.com>
In-Reply-To: <aZ6rB-zmpaR3RLB_@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 25 Feb 2026 16:45:52 -0800
X-Gm-Features: AaiRm53bfmGZyNFLKGENFMQ0ksttnoZ823ayheFdxpLxg9pxKiAgxb_V1e66-JA
Message-ID: <CALzav=fQtLd0DfWcVku1BDUzcvvYu7MBY+=G7rMMr-gjLUioAA@mail.gmail.com>
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[google.com,reject];
	R_DKIM_ALLOW(-0.20)[google.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71912-lists,kvm=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[shazbot.org,nvidia.com,amazon.com,fb.com,linux-foundation.org,google.com,kernel.org,linux.microsoft.com,ziepe.ca,lwn.net,intel.com,lists.infradead.org,vger.kernel.org,kvack.org,wunner.de,soleen.com,linuxfoundation.org,linux.intel.com,gmail.com,linux.dev];
	RCPT_COUNT_TWELVE(0.00)[44];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[dmatlack@google.com,kvm@vger.kernel.org];
	DKIM_TRACE(0.00)[google.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD7B619F900
X-Rspamd-Action: no action

On Tue, Feb 24, 2026 at 11:56=E2=80=AFPM Pranjal Shrivastava <praan@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:54PM +0000, David Matlack wrote:

> >  int __init vfio_pci_liveupdate_init(void)
> >  {
> > +     int ret;
> > +
> >       if (!liveupdate_enabled())
> >               return 0;
> >
> > -     return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +     ret =3D liveupdate_register_file_handler(&vfio_pci_liveupdate_fh)=
;
> > +     if (ret)
> > +             return ret;
>
> Nit: We might need to handle the retval here if we remove the
> liveupdate_enabled() check above (as discussed in patch 2).

I think you mean for the below call to pci_liveupdate_register_fh(),
but yes agreed :).

