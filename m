Return-Path: <kvm+bounces-71551-lists+kvm=lfdr.de@vger.kernel.org>
Delivered-To: lists+kvm@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iMk/KG/qnGnfMAQAu9opvQ
	(envelope-from <kvm+bounces-71551-lists+kvm=lfdr.de@vger.kernel.org>)
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:01:51 +0100
X-Original-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F2EB18017D
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 01:01:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E87B130A3CE1
	for <lists+kvm@lfdr.de>; Tue, 24 Feb 2026 00:01:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4338245012;
	Tue, 24 Feb 2026 00:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kbdryrbW"
X-Original-To: kvm@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0132E401
	for <kvm@vger.kernel.org>; Tue, 24 Feb 2026 00:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771891288; cv=pass; b=PVJO704bpOUcGVQMv4gOrEhvSyxXRoKy8ZEWF/MFDnnPN2ndxmWZM57L6qAP1PQ/ObI4+GyKIVpQSzAdDPMqFfAvVm0khLn/FaHSuyJWRHESSq4Bv6TlYJtv3UQyjfdhzTynGQ5JeavtYTf9KaINULURZoBqxRa+44qhLgeQ39M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771891288; c=relaxed/simple;
	bh=aTxboB9GucgmRPcQO44MW8P/VNQdv72V6gXQcbjiD4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mpO00VeI9lJ5tui2KRIdsixBYOk/TPwY9Wsbzv5oqjsElKKN9mSckWHguEMhdsH+QxgJ6/HugyX+lAySOtWv+gguLSAzJwmb+fe51ai4IZZSNNm6dH8sJtVt+gc7FLU/Q72EodTPy/urrWKplLN4hPXyYpVRbnPB0VAgGQp22EM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kbdryrbW; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-3870d178a9aso39909331fa.0
        for <kvm@vger.kernel.org>; Mon, 23 Feb 2026 16:01:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771891285; cv=none;
        d=google.com; s=arc-20240605;
        b=RJdINHd17UrT0ok+8PA4UNh6aEN19hJ+enDQVj30dbnI+yZYym0HJLj7emHueBOmha
         M76xWTOQ5/yeicil+E2LBQYRA8zDfkLC7gXdA+T3+Fy/xxBqKtv6B44CaB2EIioOZ6ND
         JSDDCR6K/PebzEeHLOaxu8zzURuUrTyBy8ToX4ql5ITjASegmGcI24NHdzCIlE9lyhDK
         jQ9YKBFH9EhXawyvV88mMa9azMYgfNbjfvJvESaGCdcSaJOPA7RXpp0N2rsg8juGhN6D
         qW6k+laVAiMfzRBo1XunnxYYfRtwzTdXmx1XCSvFPUDE8FcGYqCvQiviyBeJpAN9UEwS
         eC4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        fh=1PYj1WLlAHnaId3JJ7+aaDQVVhUUHVHZER2Ax4OySR0=;
        b=bZGKXMpkx8LDB3Z2fP5r/6XeybyXbTFLzRnMftfh6kA2/dYhr+hASeESVwntsV7X3T
         oUYiNGsWkNa8zEoDQfxu2rjTX7W4UoDqr7Ofc246lu0Gx3jjYvCAXldtcNwTHwTFAI+0
         OjKaIrU9q+XnZGKqi7HVxVFxcaVbl2HGyy4aOIAxzPutYsMRzIvW2QdL89rSOYLSxcO5
         Rga9nrWl/0wwabP9V4rfiOsP8veT5Vt2//sloVrWf7+uKYeDaY1GuCbNxDeAtNI5IF06
         s1gWS8rvGJwwnnbYUtOkiBcNgR9JmgkSMbFUBpLu80kl8I/5gJwyUPxKdCilCy1LCKOH
         GYrQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771891285; x=1772496085; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        b=kbdryrbWSHHGm5iTQP90PmBJfqS6sz6+HaWhcI5gmuaBT/st9JgTmvff1uccm2oXX2
         Ujaryx+/uNxY5D1tnjOZACsbEQLejgaRR+D8/XrwNcQ1ivGf/IieQnqx1CqWFUwcJMrk
         80mMdPGTjFjai52mrSqnyfVanhWjQ1JhuscFG9RB8freLq7X+CFQaQuyycQ3dYOnWDgq
         bZYHsZu5rK2V8qr2DSRL1jPiXSmcV+Fz1s/1KmGV+FYnTeDc3DIYq21U1B1mrxC0rMX7
         sYuMk0buDVYZv8NmVJoWZoT3cwVw/6K9+qJdRdbFvNVxL82YlJoCRCexFGbrtSnZt6ZP
         1mIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771891285; x=1772496085;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GriSu+rHCn93XDuWZWOQkqMZohlC+6Y/CRMlBkyQGvI=;
        b=jfnjf/oRjdaG7s5FvShXi9TWrdNcWWTEJ4k8bqZZTyuojGq3nKz+7IrY1TOsZDDTqF
         ync62kcuQIH9tbEetqX+c0HOER+FhJX12Cp77ESre6tOxNCEJUCmOKEWUs0hCtMWTi3i
         CL+0NAmfYXLvQX6PzOs35bLjJzlIJ+oY0Avcz9vAQ2qh3T7HZWov0Iv7yMeSXauOYmhm
         XaljCz+aojDfEcGsSV7GwbHrRJH0886aObxV9gVspvDtRSRMtZdXqZYL9CgkrbY67oYa
         LiyoyexMMSau7OeO71SgyWEc2KMLH77LxYpDned54zgmostfSZtRdGF9ISu/oK1qglBL
         eGJw==
X-Forwarded-Encrypted: i=1; AJvYcCVSxjH0WF/1oS629ZoKKS02kAkziViBhXybHu4kM3Rt4ydjYYrHz0uMnuPLKAMP47ycKiw=@vger.kernel.org
X-Gm-Message-State: AOJu0YwOhoqXdfq3MF2zLNBe5FxBdVFMxDLPfbT/N/XjPxPPSkMYO3A6
	ylwdCp+ItL3nyn+qZQaigNdQmIUiodES6qb7R1bc0yxrZ7V6i1uAtXSO7VSRnohjTv9+lsD6ST5
	sU4aTE1thRA2BhqM5KEIaTuOTcP/ZAk///5Ir3vj+
X-Gm-Gg: ATEYQzznrUmXVblrgYDCYuiBSLTKQVjlX3Xez52ncVUffJebLsQfFVo8iq/zQWydY99
	0IY7wjtVMfwRX47yAfnBaxJkzSlVmddMRN493UHYxcoeo5KnJgnTTeEjOXrUibnAxvbp3LSCryX
	X2ccu/PP3lf/yD06T2l9wRl7teBQgvzEi7pH15FnMNxTifNDXlfZ0Vi8MuuBJ/bhHF758BMSFg1
	SjrOrezy+BhyqKe7sm61ECeMxcrTlCbJHMIE9GZYLZpf+YhfzprYyeo6MwTbcOvbD3bGhRIs0sC
	IoxFdvg=
X-Received: by 2002:a05:651c:305b:b0:37c:c84a:99b9 with SMTP id
 38308e7fff4ca-389a5dbcff8mr25152861fa.24.1771891284261; Mon, 23 Feb 2026
 16:01:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
 <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com> <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
In-Reply-To: <574e4wq43zm5tyfvvtjfvzqlhoyijcgvvk7gptghrx3ofq5ck2@l2q7xbmtibbq>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 Feb 2026 16:00:56 -0800
X-Gm-Features: AaiRm52Dp6IBp6nUtMfXlMTK93T1cVz8F1V8LZFFdJp40no7f29X-MFiBmci9Nk
Message-ID: <CALzav=c1P7aoGzhSuGsFi6VYsNjygPvBR5jWXb9uqbJ+3MqARQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Samiullah Khawaja <skhawaja@google.com>
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
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-71551-lists,kvm=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TAGGED_RCPT(0.00)[kvm];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 0F2EB18017D
X-Rspamd-Action: no action

On Mon, Feb 23, 2026 at 3:43=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Mon, Feb 23, 2026 at 03:08:19PM -0800, David Matlack wrote:
> >On Mon, Feb 23, 2026 at 2:04=E2=80=AFPM Samiullah Khawaja <skhawaja@goog=
le.com> wrote:
> >> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:
> >
> >> >Drivers can notify the PCI subsystem whenever a device is preserved a=
nd
> >> >unpreserved with the following APIs:
> >> >
> >> >  pci_liveupdate_outgoing_preserve(pci_dev)
> >> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
> >>
> >> nit: Preserve and Unpreserve can only be done from outgoing kernel, ma=
ybe
> >> remove the "outgoing" from the function name.
> >
> >That's reasonable, I can make that change in v3.
>
> I should have added it earlier, but the same applies to the
> pci_liveupdate_incoming_finish() as it can only be done with incoming
> kernel. Maybe we can remove incoming from it also for consistency?

Yeah I can make that change as well.

I was erring on the side of being overly explicity with the
incoming/outgoing terminology, but I agree it's unnecessary in these
APIs.

