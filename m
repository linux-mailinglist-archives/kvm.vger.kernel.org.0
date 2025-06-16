Return-Path: <kvm+bounces-49592-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C30FEADAD41
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 12:24:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6876616D053
	for <lists+kvm@lfdr.de>; Mon, 16 Jun 2025 10:24:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52CDA27F728;
	Mon, 16 Jun 2025 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="u8P2EHe+"
X-Original-To: kvm@vger.kernel.org
Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF151EFFB8
	for <kvm@vger.kernel.org>; Mon, 16 Jun 2025 10:24:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750069490; cv=none; b=T/oVw0CU2alP/NB4a3rmm6HvzwgOPjnIXgSUJDw4K46TYsV8fUhDb4BILUShiBGgJj6Vra48D5zPCsmOSSvlLBWWIoYxbZ+KHTswsVvf0l2LcXTfAyLpp6+2yeOKe67gbYDvsvk356lXz2YcvgboObRLewOsomXGE//QxXlMzkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750069490; c=relaxed/simple;
	bh=MBJ1fwiGsEOMhk7qn3/3wMBkhZzdkWQqVEAhQhHap98=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=PBPwU7nHhCoKkp0u4T4+BxIdoh0AGgMbTD82TAhYKvHOPt3WU/bYfjQEVS5KFm4l87KMwHaNWsZ2JvFORhpYTwtM10UstMUGjaQN6+uU2lFWesLw6VyOqC/BtXzrL7f5rYDpKNNM8cmLHXBdFi2ufiE8kA/9jHihcsEC2cp1O4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=u8P2EHe+ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Received: from [133.11.54.205] (h205.csg.ci.i.u-tokyo.ac.jp [133.11.54.205])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 55G8rZGk082978
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 16 Jun 2025 17:53:35 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KScVJRjX5qHx2qPV2Idy8E22L/QoVbymW4s2ZmhlRqk=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=Message-ID:Date:From:Subject:To;
        s=rs20250326; t=1750064017; v=1;
        b=u8P2EHe+1Y+3zACB4AUA3bkn/KAg15g60iwqmmx8tIcExa0kj2B3qDQM0W6d7OY+
         VSnFJGbZc2rJgdN5gK8R7ctygc0RUk3VAF7yFGFwbbQEaW7nx/1j99kraEJM522U
         880sw6x8Y0OFe7fe1iLwC4VUTiJZfCP2sX7s/EF+VrmF7u3x2fGeDYlp2LNKYWbj
         EIMlWMtydWaTXPmIe6mZv1bmhCS9fwPPGINHFbhzxcqIJs4ukEN6xFpliyxAsq4l
         kdwV17yNkvKZujSwi0NB3erFgwCY1Bv8y8tlCJDE9A/q9Fru+iBod8QBtDaFASvS
         xtUzTYDCN4eH5DW21FDDYg==
Message-ID: <ffdab955-0255-4781-8bcf-909dcc195a01@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 16 Jun 2025 17:53:35 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Subject: Re: [PATCH v2 00/12] Python: Fix 'make check-dev' and modernize to
 3.9+
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
Content-Language: en-US
In-Reply-To: <20250612205451.1177751-1-jsnow@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 2025/06/13 5:54, John Snow wrote:
> This series does a couple things that I'll probably end up splitting out
> into smaller series if history is any guide, but either way, here it
> goes:

I'm surprised with the large number of Ccs. I suggest splitting the 
series with subsystem boundaries to reduce the number of Ccs for each 
split series.

> 
> A) Convert qemu.git/python/ to a PEP517/pyproject.toml
> package. Ultimately this means deleting setup.py and fully migrating to
> newer python infrastructure. I think this should be safe to do by now,
> but admittedly I am not *confident* as it relies on setuptools versions
> in the wild, not python versions. My motivation for trying it is to fix
> "make check-dev", which has been broken for the last two Fedora releases
> under newer setuptools which have started removing support for the
> pre-PEP517 packaging formats, which will only continue to get worse from
> here on out.

I'm afraid this change may not be safe.

The documentation of setuptools says pyproject.toml is supported since 
61.0.0:
https://setuptools.pypa.io/en/stable/userguide/pyproject_config.html

Looking at Repology as suggested in docs/about/build-platforms.rst, the 
following distributions have older setuptools, unfortunately:
CentOS Stream 9: 53.0.0
Debian 11: 44.1.1
Ubuntu 22.04: 44.1.1

docs/about/build-platforms.rst also says:
 > Optional build dependencies
 >   Build components whose absence does not affect the ability to build
 >   QEMU may not be available in distros, or may be too old for our
 >   requirements. Many of these, such as additional modules for the
 >   functional testing framework or various linters, are written in
 >   Python and therefore can also be installed using ``pip``.

In my understanding, QEMU Python Tooling is an optional component so 
dropping the support of old Linux distribution is tolerated according to 
the documentation. But I think we still need to assess the potential 
impact on the usability to justify that.

A possible option is to fetch a new version of setuptools version when 
necessary. The same documentation says:
 > Python build dependencies
 >   Some of QEMU's build dependencies are written in Python.  Usually
 >   these are only packaged by distributions for the default Python
 >   runtime.
 >   If QEMU bumps its minimum Python version and a non-default runtime
 >   is required, it may be necessary to fetch python modules from the
 >   Python Package Index (PyPI) via ``pip``, in order to build QEMU.

Automatically fetching a compatible version of setuptools as described 
here will reduce the adverse effect of the change.

The documentation page of setuptools I mentioned earlier has the 
following note:
 > If compatibility with legacy builds or versions of tools that don’t
 > support certain packaging standards (e.g. PEP 517 or PEP 660), a
 > simple setup.py script can be added to your project [1] (while keeping
 > the configuration in pyproject.toml):
 >
 > from setuptools import setup
 >
 > setup()

I have no idea what it means though. (Will it automatically fetch new 
setuptools to parse pyproject.toml or something?)

> C) Move us to 3.9+ style type hints. They are deprecated in 3.9, and
> *could* be removed at any time. I figured now was a good time as any to
> get rid of them before they become a problem randomly some day in the
> future.

I guess you meant that the old style type hints are deprecated.

Regards,
Akihiko Odaki

