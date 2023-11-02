Return-Path: <kvm+bounces-355-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 346B47DEB46
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 04:18:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6130C1C20E46
	for <lists+kvm@lfdr.de>; Thu,  2 Nov 2023 03:18:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10F21865;
	Thu,  2 Nov 2023 03:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BDF184F
	for <kvm@vger.kernel.org>; Thu,  2 Nov 2023 03:18:38 +0000 (UTC)
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBAE411D;
	Wed,  1 Nov 2023 20:18:32 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5b9377e71acso365312a12.0;
        Wed, 01 Nov 2023 20:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698895111; x=1699499911;
        h=content-transfer-encoding:content-disposition:mime-version
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hgjUtC+zu8DJl3nutAj39PQhgJ4yZrn+eZKN8r9ua1A=;
        b=MDrEhN5w37xqz8vOSUwLeOdmDFXHkF2kdBDeD4ePD0gJjd9x8M58D47HaAd9WGlhpV
         /8OhSf03xIcZbqVOBNxs0B97+Ltx3a9mdnGk7tIzX8TneBc6alr/DmZEqaaXWpySnSoZ
         KrFiiLFyHxjg9TDjlRPYXbH2xTq0SpcPZc8o7cyR9S7e47V5mzUSrtCjEeC5D7NoRiA7
         aw4CV2pVdCp+jX5BGkQWomNJXQYFxXE5dr+pd5vyI45+JlCY6sbaJFJS1jd9uoFdpMZI
         OZIgEx2b3JCswrfxklxvhcUhVoY350gnOdFkW1CwLuTly85VBHC7HZJUKyVBmywlK6TL
         X9tQ==
X-Gm-Message-State: AOJu0Yx1658X51kZaPFoEBJiReL/3fYu/8cb//dp4dKCQgpKDA7QWqGv
	EVzmrdDwGxVyt/p7/yJsDq69dohMyoQ=
X-Google-Smtp-Source: AGHT+IGSCfdmNS3mXmmzwZOCcGimxAePh6gkFXbuO2VON++1MpnZsCB/34fPgfD7x43Ga95vlV7Ung==
X-Received: by 2002:a05:6a20:8f07:b0:181:6f00:2f73 with SMTP id b7-20020a056a208f0700b001816f002f73mr3080416pzk.3.1698895111246;
        Wed, 01 Nov 2023 20:18:31 -0700 (PDT)
Received: from localhost (fpd11144dd.ap.nuro.jp. [209.17.68.221])
        by smtp.gmail.com with ESMTPSA id v3-20020a17090ac90300b002800b26dbc1sm1442581pjt.32.2023.11.01.20.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Nov 2023 20:18:30 -0700 (PDT)
Date: Thu, 2 Nov 2023 12:18:28 +0900
From: Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To: Linux PCI <linux-pci@vger.kernel.org>,
	Linux IOMMU <iommu@lists.linux.dev>,
	Linux KVM <kvm@vger.kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?utf-8?B?SsO2cmc=?= Roedel <jroedel@suse.de>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: The VFIO/IOMMU/PCI MC at LPC 2023 - See you soon!
Message-ID: <20231102031828.GA951173@rocinante>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

Hello everyone!

Time truly flies!  The Linux Plumbers Conference starts in less than two
weeks. Hopefully, everyone is excited and has booked their attendance,
hotel rooms, flights, etc. :)

The conference agenda is now available at https://lpc.events/event/17/program,
and the complete schedule is at https://lpc.events/event/17/timetable.  All the
talks this year look amazing!

The VFIO/IOMMU/PCI micro-conference schedule has also been finalised and
can seen at https://lpc.events/event/17/sessions/172/#20231115.  We have
some fantastic speakers this year!

As before, please keep an eye on the  official conference website for
updates:

  https://lpc.events

Previous posts about the MC:

  - https://lore.kernel.org/linux-pci/20230821170936.GA749626@rocinante/
  - https://lore.kernel.org/linux-pci/20230711200916.GA699236@rocinante/
  - https://lore.kernel.org/linux-pci/20230620114325.GA1387614@rocinante/
  - https://lore.kernel.org/all/20230828140306.GA1457444@rocinante/

See you at the LPC 2023!

	Alex, Bjorn, Jörg, Lorenzo and Krzysztof

