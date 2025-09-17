Return-Path: <kvm+bounces-57889-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 90630B7F5C2
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 15:34:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79A5C4A3CFA
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 13:24:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C26452EC0B6;
	Wed, 17 Sep 2025 13:24:35 +0000 (UTC)
X-Original-To: kvm@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704A12DA76C
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115475; cv=none; b=UNSqOeNTxjREh/cd6On5QUF3AwNJWhKR/ubkWWd50ELjaIC3Ppv9RlI1FnegatbKqktuzUpcsyVLgkE1BTKCAStm5m5j+HQIKdUpWmZCDk0HP34xJ6RAfYrfYDHTZ51QuYj1CYb2PiKf4Dxuyw3Wizd76qxax8z5IzOlQabbI74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115475; c=relaxed/simple;
	bh=FCVWkLnUHjeQ4+kVOABHct45GhK6KK3Oxcex8LSoYsc=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ic5e7Uc7WR8SNIrnn5W0qiIE6xFP6xhT+U5thC2TVtwfSfuKb0yVR64tPCNdaFuNAkMcEkB5UHi3CbQa1sEKCXiTHGDMBSae70oEt1nYvfp9iFrJ8UsjaelspHQv/iY45IGwJi2QpNfzcwNKGHyrezCl0+837Y5x7U1oBlJthiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4cRfb36G2vz6GDKy;
	Wed, 17 Sep 2025 21:22:55 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id CF4CE1400F4;
	Wed, 17 Sep 2025 21:24:28 +0800 (CST)
Received: from localhost (10.203.177.15) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Wed, 17 Sep
 2025 15:24:25 +0200
Date: Wed, 17 Sep 2025 14:24:24 +0100
From: Jonathan Cameron <jonathan.cameron@huawei.com>
To: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
CC: <qemu-devel@nongnu.org>, Richard Henderson <richard.henderson@linaro.org>,
	Peter Maydell <peter.maydell@linaro.org>, "=?ISO-8859-1?Q?C=E9dric?= Le
 Goater" <clg@kaod.org>, Steven Lee <steven_lee@aspeedtech.com>, Troy Lee
	<leetroy@gmail.com>, Jamin Lin <jamin_lin@aspeedtech.com>, Andrew Jeffery
	<andrew@codeconstruct.com.au>, Joel Stanley <joel@jms.id.au>, Eric Auger
	<eric.auger@redhat.com>, Helge Deller <deller@gmx.de>, Philippe
 =?ISO-8859-1?Q?Mathieu-Daud=E9?= <philmd@linaro.org>, =?ISO-8859-1?Q?Herv?=
 =?ISO-8859-1?Q?=E9?= Poussineau <hpoussin@reactos.org>, Aleksandar Rikalo
	<arikalo@gmail.com>, "Edgar E. Iglesias" <edgar.iglesias@gmail.com>, Alistair
 Francis <alistair@alistair23.me>, Ninad Palsule <ninad@linux.ibm.com>, Paolo
 Bonzini <pbonzini@redhat.com>, "Eduardo Habkost" <eduardo@habkost.net>,
	"Michael S. Tsirkin" <mst@redhat.com>, Marcel Apfelbaum
	<marcel.apfelbaum@gmail.com>, Jason Wang <jasowang@redhat.com>, Yi Liu
	<yi.l.liu@intel.com>, =?ISO-8859-1?Q?Cl=E9m?= =?ISO-8859-1?Q?ent?=
 Mathieu--Drif <clement.mathieu--drif@eviden.com>, Nicholas Piggin
	<npiggin@gmail.com>, Aditya Gupta <adityag@linux.ibm.com>, Gautam Menghani
	<gautam@linux.ibm.com>, Song Gao <gaosong@loongson.cn>, Bibo Mao
	<maobibo@loongson.cn>, Jiaxun Yang <jiaxun.yang@flygoat.com>, "Fan Ni"
	<fan.ni@samsung.com>, David Hildenbrand <david@redhat.com>, "Igor Mammedov"
	<imammedo@redhat.com>, Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
	Beniamino Galvani <b.galvani@gmail.com>, Strahinja Jankovic
	<strahinja.p.jankovic@gmail.com>, Subbaraya Sundeep <sundeep.lkml@gmail.com>,
	Jan Kiszka <jan.kiszka@web.de>, Laurent Vivier <laurent@vivier.eu>, Andrey
 Smirnov <andrew.smirnov@gmail.com>, "Aurelien Jarno" <aurelien@aurel32.net>,
	BALATON Zoltan <balaton@eik.bme.hu>, Bernhard Beschow <shentey@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>, Elena Ufimtseva
	<elena.ufimtseva@oracle.com>, Jagannathan Raman <jag.raman@oracle.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Weiwei Li <liwei1518@gmail.com>, "Daniel
 Henrique Barboza" <dbarboza@ventanamicro.com>, Liu Zhiwei
	<zhiwei_liu@linux.alibaba.com>, Matthew Rosato <mjrosato@linux.ibm.com>, Eric
 Farman <farman@linux.ibm.com>, Thomas Huth <thuth@redhat.com>, "Halil Pasic"
	<pasic@linux.ibm.com>, Christian Borntraeger <borntraeger@linux.ibm.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>, "Fam Zheng" <fam@euphon.net>, Bin Meng
	<bmeng.cn@gmail.com>, Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	Artyom Tarasenko <atar4qemu@gmail.com>, Peter Xu <peterx@redhat.com>, Marcelo
 Tosatti <mtosatti@redhat.com>, "Max Filippov" <jcmvbkbc@gmail.com>,
	<qemu-arm@nongnu.org>, <qemu-ppc@nongnu.org>, <qemu-riscv@nongnu.org>,
	<qemu-s390x@nongnu.org>, <qemu-block@nongnu.org>, <kvm@vger.kernel.org>, Alex
 Williamson <alex.williamson@redhat.com>, =?ISO-8859-1?Q?C=E9dric?= Le Goater
	<clg@redhat.com>, Stefano Garzarella <sgarzare@redhat.com>, "Alistair
 Francis" <alistair.francis@wdc.com>
Subject: Re: [PATCH 13/35] hw/mem: QOM-ify AddressSpace
Message-ID: <20250917142424.000019d3@huawei.com>
In-Reply-To: <20250917-qom-v1-13-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
References: <20250917-qom-v1-0-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
	<20250917-qom-v1-13-7262db7b0a84@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml500006.china.huawei.com (7.191.161.198) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 17 Sep 2025 21:56:25 +0900
Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp> wrote:

> Make AddressSpaces QOM objects to ensure that they are destroyed when
> their owners are finalized and also to get a unique path for debugging
> output.
> 
> The name arguments were used to distinguish AddresSpaces in debugging
> output, but they will represent property names after QOM-ification and
> debugging output will show QOM paths. So change them to make them more
> concise and also avoid conflicts with other properties.
> 
> Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Assuming the fundamental change makes sense (which I haven't looked into in
enough depth!), this CXL bit looks fine to me.

Acked-by: Jonathan Cameron <jonathan.cameron@huawei.com>
> 


