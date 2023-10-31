Return-Path: <kvm+bounces-209-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 938007DD094
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 16:34:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C48621C20CD8
	for <lists+kvm@lfdr.de>; Tue, 31 Oct 2023 15:34:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893E41E532;
	Tue, 31 Oct 2023 15:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="hExEgqMn"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C2FA1E523
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 15:34:09 +0000 (UTC)
Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC633E4
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:34:07 -0700 (PDT)
Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jrauti)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4SKZ1T2zRFz49Q2C
	for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 17:34:02 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1698766445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=VfJXTD7iomH+cqMsP8IcfH94ZQFQg/URBbNkLzvQVJY=;
	b=hExEgqMnGamqvITblH0Z+jJ0rtblVzQtdogBR31tWtybxaN1CJGB6DZn+++Qqz3BY3UeBe
	NRPnrZbJ3AW7PEndJnlETKl3CjsLIb4n1Te91+gcEtbx81VcQ4AcSPQkqo/Tj4yNih/lQn
	ihZirg4zshRrLYllk6p/boB/AYShLpiQ4FcF52At7RqIk/PfJ28c2QxY0tN5bCgTPT5hiM
	jzDW0FW0IHM08k7J2NeER5c5xjjTZIqS0HXPNJs37bPPVdhpnsHqJAS+Y0ZbFuNKlMhzys
	g1rzgZIFT1dy0EXrgPRikpJ2+m/x977Gp4jC5dIFV7UA22JfwLlXRCqlKhrcbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1698766445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type;
	bh=VfJXTD7iomH+cqMsP8IcfH94ZQFQg/URBbNkLzvQVJY=;
	b=AZRjd3fq3wf5lGSDGt5usrfZH10vanB8UmyERS/8nI5/RpRB9oLx3omL4Y/+eA+P8DoMPx
	xw0p8AKoB3z/9nf2Abe9F7xVgEglO9d9s1Vli0e/2dq498HaR6gVcao0eJuHgJoop+3fai
	mVidVmNm67+eH79oFXMd+YzbjBs2f5vXGSRFoLV1e58+ezc6Jpz1Y6hwDzgdYEMFbZsZH5
	RqmctO0X11F7D8F1TsSY7zmQEnXwA4ytuwhi4CU9FiNqaE5qAt4/aBVm1f8VK+dS4M0Jx5
	w2/jNDhmm5gbkPNKRF3lzaqD7FTbU0AOjCwm30t0W1zsA+yZMtQAzkLsqH6xig==
ARC-Seal: i=1; s=lahtoruutu; d=iki.fi; t=1698766445; a=rsa-sha256;
	cv=none;
	b=W7BI36UA6rqWd8ybZlgHBKIly/akB54bGxopAOPy9O67y37Xb+tE1kKisB5Ncgqq6SFjfL
	hTMDVxp2qAF+nsVe36Fjh6y2pcZhd0V7Ci+D+NWxfjdn7xDhE1sTSDpjGoapMzeuHSuEyX
	Izo4REvldlFZa7rQhyiELZciHHh4NIKSA76toQ2nKSlUySH/3Y+H0jNgw6IP3wEvdDW3Dx
	jKqr7nXIsDydBr28UF5Vv7XsvuPi+mWPoTaLyNSkXB+ckwAChhVEu2EvGhHBDTDEVCZYjH
	Q1xkM1nvVaW++6e58yuF7fxL6Q4CM2gzyK938/zVI4s60cpxD43L8eDPMqha/Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jrauti smtp.mailfrom=jrauti@iki.fi
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-457d9ffc9d2so3691250137.1
        for <kvm@vger.kernel.org>; Tue, 31 Oct 2023 08:34:02 -0700 (PDT)
X-Gm-Message-State: AOJu0YxlLxyTSWx6GWTYDeLj+cwsKyJNrri1o3HS8/aNkpgDYSrXxbXz
	0nGFx/9VJJAPg7l/sao9QHZsKj9lJDzxyV3kfQ==
X-Google-Smtp-Source: AGHT+IFd4W0AtXqF7qOBf2tp9P4o7H8tcLMEDhI9k+DMMJSZv67z7t87XGrph4OV5QHvHmn9kOvDBYg4McmFDTQJKN0=
X-Received: by 2002:a67:c18a:0:b0:457:ad3b:2902 with SMTP id
 h10-20020a67c18a000000b00457ad3b2902mr2248336vsj.0.1698766441223; Tue, 31 Oct
 2023 08:34:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Juhani Rautiainen <jrauti@iki.fi>
Date: Tue, 31 Oct 2023 17:33:50 +0200
X-Gmail-Original-Message-ID: <CAN74MCztYUcQJwpc_coR5Fn8XBWdAg_Lb4R4G_kmEzq_7sNXMQ@mail.gmail.com>
Message-ID: <CAN74MCztYUcQJwpc_coR5Fn8XBWdAg_Lb4R4G_kmEzq_7sNXMQ@mail.gmail.com>
Subject: Different behavior with vfio-pci between 6.4.8->6.5.5
To: kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi!

I noticed a change in my home server which breaks some of KVM VM's
with newer kernels. I have two Intel I350 cards: one with two ports
and another with four ports. I have been using the card with two ports
in a firewall VM with vfio-pci. Other ports have been given to other
VM's as host interface devices in KVM. When I upgraded to 6.6 I
noticed that the four port card is now using vfio-pci driver and not
igb as with 6.4.8 did and those VM's using host interfaces didn't
start. I had earlier built 6.5.5 so I tried that and it works same way
as the 6.6 kernel does, so if something has changed it is probably in
6.5 series. I have this in /etc/modprope.d/vfio.conf:

options vfio_pci ids=8086:1521

With  6.4.8 lspci -vv shows this:
01:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network
Connection (rev 01)
        Subsystem: Intel Corporation Ethernet Server Adapter I350-T4
        Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx+
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 67
        IOMMU group: 11
....
        Kernel driver in use: igb
        Kernel modules: igb

And with 6.5.5 I get:
01:00.0 Ethernet controller: Intel Corporation I350 Gigabit Network
Connection (rev 01)
        Subsystem: Intel Corporation Ethernet Server Adapter I350-T4
        Control: I/O- Mem- BusMaster- SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Interrupt: pin A routed to IRQ 255
        IOMMU group: 11
....
        Kernel driver in use: vfio-pci
        Kernel modules: igb

Have I been just lucky previously with my config or did something
change? I tried to figure out the change from 6.5 release notes but
could not. My home server is running on AMD Ryzen 5700g and Alma Linux
8.8 (I just compile newer kernels out of habit).

Thanks,
Juhani
-- 
Juhani Rautiainen                                   jrauti@iki.fi

