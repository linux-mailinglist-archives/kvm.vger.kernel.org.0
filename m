Return-Path: <kvm+bounces-49607-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 943A8ADB00D
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 14:19:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AC6DC188DFCA
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:20:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A29B2E427E;
	Mon, 16 Jun 2025 12:19:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="mZqaBz0o"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D6B800
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 12:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750076389; cv=none; b=WxVgyXaX2hsokWbJ74yCOn5myfbB87cNA+dAr5iMwzgp0LSJ9fnu+08EcGR/jg2LSXA5VRXkZ0RH0RnS6AEE5tGn4dBcjH3i/0M+U7VmjTxQk8GvJ2aNWd2uqLz1/166tuxHqCaZFqxT35mNblM5TFUwl3KWqsr3tVuB22B6oHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750076389; c=relaxed/simple;
	bh=kLwETw261Rioaahl/JGM88BIEMBq8/p3prhpFtAnciI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C8l55TS/W2zmU/HsXD1/ZWiFg6FhcKpbUGzgpdV8dtAxwFVgPyN7dGACaAC5do5nHR9osPA5Jfij0EcPogqAcJZLL8sh8hsU5AeOx+tsk0rhaWTJDAoFgG3WajjAj0dk3pcIDdUGzya9L63dnxihyAxmSTNlBBLciQGH9YJD5HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=mZqaBz0o reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 55GCCXHI047420
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 16 Jun 2025 21:12:33 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=Jns4YUkWleKTus56PdGOGCjWkNbvBqyrqgM+AwVIKyk=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250326; t=1750075955; v=1;
        b=mZqaBz0oU0offbwtymE8Sm//X09ELO0dFO0tfbHgApWLR9Q4Bknj/QaUyYiuJydA
         yyJYNJ+VCOp90XsEUDR0yGsVHlYEMqJ0RZmCQh0nzWDw3F4Y8e7zHygfqO9slX9w
         dx+0envOgqaHrRtWY9squzB2pe8ehuUitPIaaDlhK9IUdWnQkwiu57scCt9m8zKf
         WxmP6PJz17dN1WkFyyavtGgaKiu5DwiETb5RmsOffPpvrzv4Um1YCsypFoXUiRU0
         9Pa7pLZ/B0IfZ7Wv3l1YGEJhpzuwTOfrodCMZfU5KaBz2QcSCMYkYr5HAhG7dtt7
         4kAKq7hnUOMzcum+Ld6hLg==
Message-ID: <f943a1b0-3da5-49d4-948d-fd3863c69ff0@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 16 Jun 2025 21:12:33 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/12] python: sync changes from external qemu.qmp
 package
To: John Snow <jsnow@redhat.com>, qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>, Yi Liu <yi.l.liu@intel.com>,
        =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Helge Deller <deller@gmx.de>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Andrew Jeffery <andrew@codeconstruct.com.au>,
        Fabiano Rosas
 <farosas@suse.de>, Alexander Bulekov <alxndr@bu.edu>,
        Darren Kenny <darren.kenny@oracle.com>,
        Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
        =?UTF-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
        Ed Maste <emaste@freebsd.org>, Gerd Hoffmann <kraxel@redhat.com>,
        Warner Losh <imp@bsdimp.com>, Kevin Wolf <kwolf@redhat.com>,
        Tyrone Ting <kfting@nuvoton.com>, Eric Blake <eblake@redhat.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Troy Lee <leetroy@gmail.com>, Halil Pasic <pasic@linux.ibm.com>,
        Michael Roth <michael.roth@amd.com>,
        Laurent Vivier <laurent@vivier.eu>, Ani Sinha <anisinha@redhat.com>,
        Weiwei Li <liwei1518@gmail.com>, Eric Farman <farman@linux.ibm.com>,
        Steven Lee <steven_lee@aspeedtech.com>,
        Brian Cain <brian.cain@oss.qualcomm.com>,
        Li-Wen Hsu <lwhsu@freebsd.org>, Jamin Lin <jamin_lin@aspeedtech.com>,
        qemu-s390x@nongnu.org,
        Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
        qemu-block@nongnu.org, Bernhard Beschow <shentey@gmail.com>,
        =?UTF-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
        Maksim Davydov <davydov-max@yandex-team.ru>,
        Niek Linnenbank <nieklinnenbank@gmail.com>,
        =?UTF-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Paul Durrant <paul@xen.org>,
        Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
        Jagannathan Raman <jag.raman@oracle.com>,
        Igor Mitsyanko <i.mitsyanko@gmail.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Markus Armbruster <armbru@redhat.com>,
        Pierrick Bouvier <pierrick.bouvier@linaro.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, Anton Johansson <anjo@rev.ng>,
        Peter Maydell <peter.maydell@linaro.org>,
        Cleber Rosa <crosa@redhat.com>, Eric Auger <eric.auger@redhat.com>,
        Yanan Wang <wangyanan55@huawei.com>, qemu-arm@nongnu.org,
        Hao Wu <wuhaotsh@google.com>, Mads Ynddal <mads@ynddal.dk>,
        Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
        qemu-riscv@nongnu.org, Paolo Bonzini <pbonzini@redhat.com>,
        Jason Wang <jasowang@redhat.com>, Nicholas Piggin <npiggin@gmail.com>,
        Michael Rolnik <mrolnik@gmail.com>, Zhao Liu <zhao1.liu@intel.com>,
        Alessandro Di Federico <ale@rev.ng>, Thomas Huth <thuth@redhat.com>,
        Antony Pavlov <antonynpavlov@gmail.com>,
        Jiaxun Yang <jiaxun.yang@flygoat.com>, Hanna Reitz <hreitz@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        Qiuhao Li <Qiuhao.Li@outlook.com>, Hyman Huang <yong.huang@smartx.com>,
        =?UTF-8?Q?Daniel_P=2E_Berrang=C3=A9?= <berrange@redhat.com>,
        Magnus Damm <magnus.damm@gmail.com>, qemu-rust@nongnu.org,
        Bandan Das <bsd@redhat.com>,
        Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
        Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        kvm@vger.kernel.org, Fam Zheng <fam@euphon.net>,
        Jia Liu <proljc@gmail.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Alistair Francis <alistair@alistair23.me>,
        Subbaraya Sundeep <sundeep.lkml@gmail.com>,
        Kyle Evans <kevans@freebsd.org>, Song Gao <gaosong@loongson.cn>,
        Alexandre Iooss <erdnaxe@crans.org>,
        Aurelien Jarno <aurelien@aurel32.net>,
        Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
        Peter Xu <peterx@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>,
        BALATON Zoltan <balaton@eik.bme.hu>,
        Elena Ufimtseva <elena.ufimtseva@oracle.com>,
        "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
        =?UTF-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
        qemu-ppc@nongnu.org, Radoslaw Biernacki <rad@semihalf.com>,
        Beniamino Galvani <b.galvani@gmail.com>,
        David Hildenbrand
 <david@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Eduardo Habkost
 <eduardo@habkost.net>,
        Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
        Huacai Chen <chenhuacai@kernel.org>,
        Mahmoud Mandour
 <ma.mandourr@gmail.com>,
        Harsh Prateek Bora <harshpb@linux.ibm.com>
References: <20250612205451.1177751-1-jsnow@redhat.com>
 <20250612205451.1177751-4-jsnow@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20250612205451.1177751-4-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2025/06/13 5:54, John Snow wrote:
> Synchronize changes from the standalone python-qemu-qmp repository for
> the primary purpose of removing some pre-3.9 compatibility crud that we
> no longer need or want.
> 
> My plan for this release cycle is to finally eliminate this duplication
> so this type of patch will no longer be necessary -- but for now, it is.
> 
> NB: A few changes are not synchronized; mostly license and documentation
> strings. Everything functional is fully copied verbatim. The license
> strings are not sync'd only because they point to different LICENSE
> filenames for the different repositories.
> 
> Signed-off-by: John Snow <jsnow@redhat.com>

Reviewed-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>

