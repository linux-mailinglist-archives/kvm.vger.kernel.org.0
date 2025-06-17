Return-Path: <kvm+bounces-49688-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D3353ADC5ED
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 11:16:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C15253B6722
	for <lists+kvm@lfdr.de>; Tue, 17 Jun 2025 09:16:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC5E921B91F;
	Tue, 17 Jun 2025 09:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b="t/ebtiKW"
X-Original-To: kvm@vger.kernel.org
Received: from outbound.qs.icloud.com (p-east3-cluster4-host6-snip4-6.eps.apple.com [57.103.84.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25701C7017
	for <kvm@vger.kernel.org>; Tue, 17 Jun 2025 09:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=57.103.84.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750151781; cv=none; b=PyMGbvoFNI0OaX8SyhnqFWL57ggXMPRPI5CzzJRvlJV2vg0xKPlv/6UXL0uxtzAnEN957HViLtXdrsWqdk0jW4Y9Ji4ek5xmBskUCY70vPJa+LzhHyqxSQJI7sgDFYrLcTXLNRS1/KmrwJJf7t33OHiOhX3Umq4v9byG5fGSlNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750151781; c=relaxed/simple;
	bh=rE/ubjQFdgiuI0vmZM0ZIJcs50rcoMqd4pS81/2JG/k=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=R8L4NYF9L04XU07j56pkENAcqGIeZ8Mc9Cqe35lZ1qHDWPCrXKyVZ71y+aygNy2LYUDp8pj22iIPhNgYy/e5m2obGvx0ZkbmJmBGXz2t88nOqVcm6e/qvdmd5JttuyIxp2rU1JrE1fGdhnCgHpHEh9i4mYB4/7qmygx9CmJKjgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk; spf=pass smtp.mailfrom=ynddal.dk; dkim=pass (2048-bit key) header.d=ynddal.dk header.i=@ynddal.dk header.b=t/ebtiKW; arc=none smtp.client-ip=57.103.84.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ynddal.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ynddal.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ynddal.dk; s=sig1;
	bh=F2Lk87g/ffbwU6AtjA/WqgttL7/b0yIw5RLWx7pPGH8=;
	h=Content-Type:Mime-Version:Subject:From:Date:Message-Id:To:x-icloud-hme;
	b=t/ebtiKWDY2QkbdzHbQ8JHAQfW1irYE31MIXq5FeLuQBVi2srySC4AW71wet8gKuQ
	 NlCtlcJtugl2N8OExL2XPUcYb01vz9cJeaP4XAHUNki1VR/W0mWuIgJx8RWVrvaWRH
	 Byaa4t7oX7MCpWsgwXdEpyufTUl6xr1VGUemjO2LowKLdrX8vshUlah0LMXLG0/Otn
	 DqAICXcAFc5hhPAYSdZkfGlEh+oBwZSg/5iGUd51B84db5dd/YZZ76xa8b442qkjH0
	 ayL40utni9I3IDatF919KJrglGL7z8PuqtzAFeSjhXkTD/GNBcY1MXtOOq2jDTx/F/
	 PhTKUTD3kuRQA==
Received: from outbound.qs.icloud.com (unknown [127.0.0.2])
	by outbound.qs.icloud.com (Postfix) with ESMTPS id 45B861800400;
	Tue, 17 Jun 2025 09:16:15 +0000 (UTC)
Received: from smtpclient.apple (qs-asmtp-me-k8s.p00.prod.me.com [17.57.155.37])
	by outbound.qs.icloud.com (Postfix) with ESMTPSA id 9338118011E4;
	Tue, 17 Jun 2025 09:16:04 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.600.51.1.1\))
Subject: Re: [PATCH v2 06/12] python: upgrade to python3.9+ syntax
From: Mads Ynddal <mads@ynddal.dk>
In-Reply-To: <20250612205451.1177751-7-jsnow@redhat.com>
Date: Tue, 17 Jun 2025 11:15:53 +0200
Cc: qemu-devel@nongnu.org,
 Joel Stanley <joel@jms.id.au>,
 Yi Liu <yi.l.liu@intel.com>,
 =?utf-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Helge Deller <deller@gmx.de>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Andrew Jeffery <andrew@codeconstruct.com.au>,
 Fabiano Rosas <farosas@suse.de>,
 Alexander Bulekov <alxndr@bu.edu>,
 Darren Kenny <darren.kenny@oracle.com>,
 Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
 =?utf-8?Q?C=C3=A9dric_Le_Goater?= <clg@kaod.org>,
 Ed Maste <emaste@freebsd.org>,
 Gerd Hoffmann <kraxel@redhat.com>,
 Warner Losh <imp@bsdimp.com>,
 Kevin Wolf <kwolf@redhat.com>,
 Tyrone Ting <kfting@nuvoton.com>,
 Eric Blake <eblake@redhat.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>,
 Troy Lee <leetroy@gmail.com>,
 Halil Pasic <pasic@linux.ibm.com>,
 Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
 Michael Roth <michael.roth@amd.com>,
 Laurent Vivier <laurent@vivier.eu>,
 Ani Sinha <anisinha@redhat.com>,
 Weiwei Li <liwei1518@gmail.com>,
 Eric Farman <farman@linux.ibm.com>,
 Steven Lee <steven_lee@aspeedtech.com>,
 Brian Cain <brian.cain@oss.qualcomm.com>,
 Li-Wen Hsu <lwhsu@freebsd.org>,
 Jamin Lin <jamin_lin@aspeedtech.com>,
 qemu-s390x@nongnu.org,
 Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
 qemu-block@nongnu.org,
 Bernhard Beschow <shentey@gmail.com>,
 =?utf-8?Q?Cl=C3=A9ment_Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
 Maksim Davydov <davydov-max@yandex-team.ru>,
 Niek Linnenbank <nieklinnenbank@gmail.com>,
 =?utf-8?Q?Herv=C3=A9_Poussineau?= <hpoussin@reactos.org>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Paul Durrant <paul@xen.org>,
 Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 Jagannathan Raman <jag.raman@oracle.com>,
 Igor Mitsyanko <i.mitsyanko@gmail.com>,
 Max Filippov <jcmvbkbc@gmail.com>,
 Markus Armbruster <armbru@redhat.com>,
 Pierrick Bouvier <pierrick.bouvier@linaro.org>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Anton Johansson <anjo@rev.ng>,
 Peter Maydell <peter.maydell@linaro.org>,
 Cleber Rosa <crosa@redhat.com>,
 Eric Auger <eric.auger@redhat.com>,
 Yanan Wang <wangyanan55@huawei.com>,
 qemu-arm@nongnu.org,
 Hao Wu <wuhaotsh@google.com>,
 Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
 qemu-riscv@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Michael Rolnik <mrolnik@gmail.com>,
 Zhao Liu <zhao1.liu@intel.com>,
 Alessandro Di Federico <ale@rev.ng>,
 Thomas Huth <thuth@redhat.com>,
 Antony Pavlov <antonynpavlov@gmail.com>,
 Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Hanna Reitz <hreitz@redhat.com>,
 Ilya Leoshkevich <iii@linux.ibm.com>,
 Marcelo Tosatti <mtosatti@redhat.com>,
 Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
 Daniel Henrique Barboza <danielhb413@gmail.com>,
 Qiuhao Li <Qiuhao.Li@outlook.com>,
 Hyman Huang <yong.huang@smartx.com>,
 =?utf-8?B?IkRhbmllbCBQLiBCZXJyYW5nw6ki?= <berrange@redhat.com>,
 Magnus Damm <magnus.damm@gmail.com>,
 qemu-rust@nongnu.org,
 Bandan Das <bsd@redhat.com>,
 Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
 Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
 =?utf-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org,
 Fam Zheng <fam@euphon.net>,
 Jia Liu <proljc@gmail.com>,
 =?utf-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
 Alistair Francis <alistair@alistair23.me>,
 Subbaraya Sundeep <sundeep.lkml@gmail.com>,
 Kyle Evans <kevans@freebsd.org>,
 Song Gao <gaosong@loongson.cn>,
 Alexandre Iooss <erdnaxe@crans.org>,
 Aurelien Jarno <aurelien@aurel32.net>,
 Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
 Peter Xu <peterx@redhat.com>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 BALATON Zoltan <balaton@eik.bme.hu>,
 Elena Ufimtseva <elena.ufimtseva@oracle.com>,
 "Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
 =?utf-8?B?RnLDqWTDqXJpYyBCYXJyYXQ=?= <fbarrat@linux.ibm.com>,
 qemu-ppc@nongnu.org,
 Radoslaw Biernacki <rad@semihalf.com>,
 Beniamino Galvani <b.galvani@gmail.com>,
 David Hildenbrand <david@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>,
 Eduardo Habkost <eduardo@habkost.net>,
 Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
 Huacai Chen <chenhuacai@kernel.org>,
 Mahmoud Mandour <ma.mandourr@gmail.com>,
 Harsh Prateek Bora <harshpb@linux.ibm.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <9C057F25-8BE4-45FC-9332-99F24440DB92@ynddal.dk>
References: <20250612205451.1177751-1-jsnow@redhat.com>
 <20250612205451.1177751-7-jsnow@redhat.com>
To: John Snow <jsnow@redhat.com>
X-Mailer: Apple Mail (2.3826.600.51.1.1)
X-Proofpoint-GUID: cS2XhPuk0PL7nqO6eEaVM1REG4Ybtl7b
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDA3NSBTYWx0ZWRfX08K7PivxpQIe
 JIe07Ty/NOGrx2MTXIvpSFeyomB4YbIOT4b6MYUQtfEB3ouMu+SNxxFs2tM+rrNQo47+9iSJurY
 P8VXJ6xuKUkf2f8BhJKMV4s70++CGINS7BXOh6rU+z1BzJ9XUk0c+hLcVt5onyRSDY7+ofXLOIX
 HuXVAq7dtrqHWF4XsUvjNncufvqMgc8sQE5C2XgUuo4IRNAuXlmhc9S1F5AIlYOcZSyxtGcjmHz
 4/YONWYJ5eqltCUefecDWnZR/HJRs98UUeXAhcHBYv+8lAa1kmPrDDgnXBdLe8Yvp2MOQBEPA=
X-Proofpoint-ORIG-GUID: cS2XhPuk0PL7nqO6eEaVM1REG4Ybtl7b
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_04,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 adultscore=0 spamscore=0 bulkscore=0 mlxlogscore=714 phishscore=0
 clxscore=1030 suspectscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.22.0-2506060001 definitions=main-2506170075


> diff --git a/scripts/simpletrace.py b/scripts/simpletrace.py
> index cef81b0707f..a013e4402de 100755
> --- a/scripts/simpletrace.py
> +++ b/scripts/simpletrace.py
> @@ -9,13 +9,15 @@
> #
> # For help see docs/devel/tracing.rst
>=20
> -import sys
> -import struct
> import inspect
> +import struct
> +import sys
> import warnings
> -from tracetool import read_events, Event
> +
> +from tracetool import Event, read_events
> from tracetool.backend.simple import is_string
>=20
> +
> __all__ =3D ['Analyzer', 'Analyzer2', 'process', 'run']
>=20
> # This is the binary format that the QEMU "simple" trace backend
> @@ -166,11 +168,9 @@ def runstate_set(self, timestamp, pid, =
new_state):
>=20
>     def begin(self):
>         """Called at the start of the trace."""
> -        pass
>=20
>     def catchall(self, event, rec):
>         """Called if no specific method for processing a trace event =
has been found."""
> -        pass
>=20
>     def _build_fn(self, event):
>         fn =3D getattr(self, event.name, None)
> @@ -208,7 +208,6 @@ def _process_event(self, rec_args, *, event, =
event_id, timestamp_ns, pid, **kwar
>=20
>     def end(self):
>         """Called at the end of the trace."""
> -        pass
>=20
>     def __enter__(self):
>         self.begin()
> @@ -263,7 +262,6 @@ def runstate_set(self, new_state, *, timestamp_ns, =
pid, **kwargs):
>=20
>     def catchall(self, *rec_args, event, timestamp_ns, pid, event_id, =
**kwargs):
>         """Called if no specific method for processing a trace event =
has been found."""
> -        pass
>=20
>     def _process_event(self, rec_args, *, event, **kwargs):
>         fn =3D getattr(self, event.name, self.catchall)
> @@ -279,7 +277,7 @@ def process(events, log, analyzer, =
read_header=3DTrue):
>     """
>=20
>     if isinstance(events, str):
> -        with open(events, 'r') as f:
> +        with open(events) as f:
>             events_list =3D read_events(f, events)
>     elif isinstance(events, list):
>         # Treat as a list of events already produced by =
tracetool.read_events
> @@ -332,7 +330,7 @@ def run(analyzer):
>     except (AssertionError, ValueError):
>         raise SimpleException(f'usage: {sys.argv[0]} [--no-header] =
<trace-events> <trace-file>\n')
>=20
> -    with open(trace_event_path, 'r') as events_fobj, =
open(trace_file_path, 'rb') as log_fobj:
> +    with open(trace_event_path) as events_fobj, open(trace_file_path, =
'rb') as log_fobj:
>         process(events_fobj, log_fobj, analyzer, read_header=3Dnot =
no_header)
>=20
> if __name__ =3D=3D '__main__':

I'm not really a fan of the implicit default arguments, but I guess the =
rest is fine. If this is the way everyone else wants to go, I won't =
stand in the way.

=E2=80=94
Mads Ynddal


