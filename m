Return-Path: <kvm+bounces-278-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DE3197DDBB7
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 04:55:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A8491C20D91
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 03:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35C8315A8;
	Wed,  1 Nov 2023 03:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="o4k8Uf8I"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1F7ED5
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 03:55:43 +0000 (UTC)
Received: from meesny.iki.fi (meesny.iki.fi [IPv6:2001:67c:2b0:1c1::201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADF0EF5
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 20:55:37 -0700 (PDT)
Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jrauti)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4SKtT06K81zyTs
	for <kvm@vger.kernel.org>; Wed,  1 Nov 2023 05:55:30 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1698810933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uGvrI3cY3RCQ6IrwVb6pc41u62tt2FRAqSkxcB81h9E=;
	b=o4k8Uf8IgcZPL8yBw9Ymhp65ovbBW3yAudGt4vaIi8/8GIHqPVkMxt2/dswYCPoEytiqHf
	mdMN2hFVhxEyfpiJTq4Kdz4Qn9cr+sSMVq2G693WbjNer+u3nnDKKaSncLxccwiI8Hr9p/
	BzU1RpWCyILQ17oL9+gRwEaIobpX00U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1698810933;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uGvrI3cY3RCQ6IrwVb6pc41u62tt2FRAqSkxcB81h9E=;
	b=SyeGuP3UK8469dJsgXLwmz3WbiZAnYgnxSODdWDZjKvjrzWPse2HFUQn+oB2JGQaTmW/QP
	x8YRCsFKyfWnFUmp9pBRsVur+9f80Ug8CWb2IHCrTNa602PVnRm/YVUvrmgEZe07HNqBD/
	W3xNJ5o2aIWNlpYQJkOAH2Jy9dso4q4=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jrauti smtp.mailfrom=jrauti@iki.fi
ARC-Seal: i=1; s=meesny; d=iki.fi; t=1698810933; a=rsa-sha256; cv=none;
	b=k8Y9R7TvV/MwdZMoCJjDePVaMn7u0hPHW3z/4mSZK2JBS+sHyXF1LaZ9r+DYBLIbphjEhU
	SR+KBAb2clL1C4dlnW62teAolirldBFg3hQ8HYBm4aTW3zf5CLU71DtileNtc3HPq3s5vM
	FKZ7hV9megt84nxm2qykhIVRhnosXoY=
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7aae07e7ba4so2305087241.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 20:55:29 -0700 (PDT)
X-Gm-Message-State: AOJu0YzAas+NZ+29F4qdtenLuEvAlKM9qDWfBk2YD0Og9H2OnnN0Sj2R
	Ra6vt/3h5bu4pzaW+2FTBQhU1ibcWM1+3RpmfQ==
X-Google-Smtp-Source: AGHT+IGhcC35Wrb40rLv8N250CfqarGRS6gL19OetduMireiRYHjQyaQhRHhQywnK9LvTKh0Z8mnYw7pH6tIefPCR3Q=
X-Received: by 2002:a05:6102:4711:b0:457:cc32:39c6 with SMTP id
 ei17-20020a056102471100b00457cc3239c6mr13230587vsb.16.1698810928602; Tue, 31
 Oct 2023 20:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAN74MCztYUcQJwpc_coR5Fn8XBWdAg_Lb4R4G_kmEzq_7sNXMQ@mail.gmail.com>
 <20231031101913.4245dbf6.alex.williamson@redhat.com>
In-Reply-To: <20231031101913.4245dbf6.alex.williamson@redhat.com>
From: Juhani Rautiainen <jrauti@iki.fi>
Date: Wed, 1 Nov 2023 05:55:17 +0200
X-Gmail-Original-Message-ID: <CAN74MCyTDq0J7JXwYVkBYAa=AH5Y2FB5z01Vof3Taq0bahdoLw@mail.gmail.com>
Message-ID: <CAN74MCyTDq0J7JXwYVkBYAa=AH5Y2FB5z01Vof3Taq0bahdoLw@mail.gmail.com>
Subject: Re: Different behavior with vfio-pci between 6.4.8->6.5.5
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

 The 2 port card was added during the summer as replacement for the
older Intel card and I probably was lucky with timing as I just fixed
the ID's to modprobe.conf. I checked the dmesg logs and you are
correct about reserving all the interfaces to either one. With 6.4.8
igb gets all the interfaces and with 6.5 onwards vfio-pci wins. So
libvirt with 6.4.8 KVM can reclaim interface from the igb. So maybe I
don't need the modprobe config at all... The base config for libvirt
qemu FW started probably around 2014 when I started using KVM and it
has survived couple of HW and OS upgrades :D. I will try without
modprobe and check that driverctl so I can figure this out.

Thanks for the help,
-Juhani


On Tue, Oct 31, 2023 at 6:19=E2=80=AFPM Alex Williamson
<alex.williamson@redhat.com> wrote:
>


> Do you launch your VMs with libvirt, which might have automatically
> bound the devices to vfio-pci and now there's something loading the
> vfio-pci module before igb?

Libvirt is running the show. What I forgot to mention is that 2 port
version i recent replacement in 6.4 the era (old card was intel card
but using e1000 driver). I probably was lucky with timing as I just
fixed the ID's to modprobe.conf and everything continued to work. I
checked the dmesg logs and you are correct about reserving all the
interfaces to either driver. With 6.4.8 igb gets all the interfaces
and with 6.5 onwards vfio-pci wins. Libvirt with 6.4.8 KVM can reclaim
interface from the igb. So maybe I don't need the modprobe config at
all. The base config for the libvirt qemu FW config started around
2014 when I started using KVM and it has survived couple of HW and OS
upgrades.

>
> The driverctl tool might be useful for you to specify a specific
> driver for specific devices.  Otherwise I'm not sure what kernel change
> might have triggered this behavioral change without knowing more about
> how and when the vfio-pci module is loaded relative to the igb module.

I will try without the modprobe and check that driverctl so I can
figure this out.

> Thanks,
>
> Alex
>
Thanks for the help. I half suspected that I messed up something :D.
-Juhani
--=20
Juhani Rautiainen                                   jrauti@iki.fi

