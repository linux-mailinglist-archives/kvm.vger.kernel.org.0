Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174111DDCB1
	for <lists+kvm@lfdr.de>; Fri, 22 May 2020 03:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgEVBdX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 May 2020 21:33:23 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:23722 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbgEVBdX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 May 2020 21:33:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1590111220; x=1621647220;
  h=date:from:to:cc:subject:in-reply-to:message-id:
   references:mime-version;
  bh=/dhekmzFTgIlB9T7AkbhzCg/aXbY4QZ8mH7f4WQrVIg=;
  b=qxEbZjwDV6w9K18SlDaXOrg+oKVWXcePbZHxMDSIDOW7QC177K9sMmqt
   YdDiBfNO88i3odj9YoujyWErpDf/kRkQRjw1ku8NdFFL3mTY5VQMsB5PM
   HFRNTv2ye+MtngOAJ8so22kMxk12DZB5kD2OV72jvmeJLqIOdvBThjMd1
   76s0OWynezJvPDK0FoLh6T4EpFZu87tjNrD1qQTeT3i06XrLyEj6DxxbU
   2P91SkhiNdw61DHFW97LVNAYRdHY2dZkBGCPXp64bzmZkszMw0QsqEZB6
   DZHj/dQAoY/NcE6JyP8ibl9pV1ywbqcTDojsl4cJYi03XcK1t+lrnw+oQ
   Q==;
IronPort-SDR: J6Xz4/qxf4I7aVBBAIcg9A8Lt+ZLaPJ3PxMsL2Hvm7G1ifuza39JWmmspJhRd7/s6Dml1J9BT8
 Eyi0N3B9/ZAJrIA1b5CbUbpfUEHoiHVdDW6Bu5RkhOWXvaTjgAQEHh6g3+k3AqIh7ZxTVWnXoJ
 judEFufj9c3noMzonBzQGr9TyRyQjxQyRD+9bSbhKeKrM+WD6fx+0JMJ1uxpm9ZOs7Exnydhr4
 21jWZ0kuBcN7pEDja7/zd0HxGwK9+ZMMm3yPdTr/hpzc1Q11i7hZXNr/yfNCOhGFvKAIDDOH9V
 GHM=
X-IronPort-AV: E=Sophos;i="5.73,419,1583164800"; 
   d="scan'208";a="241031113"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 May 2020 09:33:39 +0800
IronPort-SDR: WMhJcEL+sj7MtQb9zsB1cxp5O4rQVIzAU1vdo4jHkf/fKCASSq3bwwJ4xSuFouRuvZxWM96Yvl
 4lb3xmkJ02T4SXreVT9fZ0bSUIpE2nZwk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 18:22:49 -0700
IronPort-SDR: tHTLxVk1/JY8zWtT8+eTjABPWjnVNE3nlfSZOV7gSmosL80R+z4ScVeJSLBf9hYi5hRU5PeOBk
 rMUVcST+XS0A==
WDCIronportException: Internal
Received: from unknown (HELO redsun52) ([10.149.66.28])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 18:33:17 -0700
Date:   Fri, 22 May 2020 02:33:12 +0100 (BST)
From:   "Maciej W. Rozycki" <macro@wdc.com>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
cc:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Serge Semin <fancer.lancer@gmail.com>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Huacai Chen <chenhc@lemote.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Cedric Hombourger <Cedric_Hombourger@mentor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <f4bug@amsat.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Paul Cercueil <paul@crapouillou.net>,
        Zhou Yanjie <zhouyanjie@zoho.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Allison Randal <allison@lohutok.net>,
        Liangliang Huang <huanglllzu@gmail.com>,
        =?UTF-8?Q?=E5=91=A8=E7=90=B0=E6=9D=B0_=28Zhou_Yanjie=29?= 
        <zhouyanjie@wanyeetech.com>, YunQiang Su <syq@debian.org>,
        Zou Wei <zou_wei@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Kamal Dasu <kdasu.kdev@gmail.com>, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        "Maciej W. Rozycki" <macro@linux-mips.org>
Subject: Re: [PATCH v4 03/13] mips: Add MIPS Release 5 support
In-Reply-To: <20200521140725.29571-4-Sergey.Semin@baikalelectronics.ru>
Message-ID: <alpine.LFD.2.21.2005220228310.21168@redsun52.ssa.fujisawa.hgst.com>
References: <20200521140725.29571-1-Sergey.Semin@baikalelectronics.ru> <20200521140725.29571-4-Sergey.Semin@baikalelectronics.ru>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 21 May 2020, Serge Semin wrote:

> There are five MIPS32/64 architecture releases currently available:
> from 1 to 6 except fourth one, which was intentionally skipped.
> Three of them can be called as major: 1st, 2nd and 6th, that not only
> have some system level alterations, but also introduced significant
> core/ISA level updates. The rest of the MIPS architecture releases are
> minor.

 Well, strictly speaking R3 added microMIPS support, which was all but
minor (of course there were minor updates too, such as 2008-NaN support).

  Maciej
