Return-Path: <kvm+bounces-1676-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 54D327EB306
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:08:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 84C5B1C20898
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:08:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 497B641237;
	Tue, 14 Nov 2023 15:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="u1gqmmwU"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007973FE3D
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:08:28 +0000 (UTC)
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8DE810D
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=gPlTnLrWpPWWoUPGEpERtBAlyTDR8Uk7y5kKdp/k5WQ=; b=u1gqmmwUiYpHqi0uHXy3+ToCOg
	KHEul+myRl+dxaYk/qNKWcNttIq8/dZePgwrAoIO8+fIFGcpyX/LBLL2RF3dFIzW6YXDETCZ5hfdq
	YZnC8QwR/QP/IvY2HE0U0K/ebiBiubW4IMEq4rDgmwiw4LF9zQ9Px1M/iVxncLveLC5156Q51zRLu
	GjIunmXq7yWhG/pb+jRvc4LqTUV4u3FdRaGslz3bGN3HeiCKr/xGZcicCi1VgEx37L59bWG6O/YPG
	/eR3o3YdWcexfFKmcOp0M3zHSiDW5cr8dZvQU9Ui86+l8t77xJryJcV0HGOzffZh0FI7e30+d1pvR
	v+oQjvuA==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1r2v1Q-008cvI-6u; Tue, 14 Nov 2023 15:08:12 +0000
Date: Tue, 14 Nov 2023 10:08:09 -0500
From: David Woodhouse <dwmw2@infradead.org>
To: =?ISO-8859-1?Q?Philippe_Mathieu-Daud=E9?= <philmd@linaro.org>,
 David Woodhouse <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
CC: =?ISO-8859-1?Q?Alex_Benn=E9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, Cleber Rosa <crosa@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Beraldo Leal <bleal@redhat.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_01/19=5D_tests/avocado=3A_A?= =?US-ASCII?Q?dd_=27guest=3Axen=27_tag_to_tests_running_Xen_guest?=
User-Agent: K-9 Mail for Android
In-Reply-To: <407f32ee-e489-4c05-9c3d-fa6c29bb1d99@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-2-philmd@linaro.org> <94D9484A-917D-4970-98DE-35B84BEDA1DC@infradead.org> <407f32ee-e489-4c05-9c3d-fa6c29bb1d99@linaro.org>
Message-ID: <074BCACF-C8D0-440A-A805-CDB0DB21C416@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

On 14 November 2023 10:00:09 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>On 14/11/23 15:50, David Woodhouse wrote:
>> On 14 November 2023 09:37:57 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <=
philmd@linaro=2Eorg> wrote:
>>> Add a tag to run all Xen-specific tests using:
>>>=20
>>>   $ make check-avocado AVOCADO_TAGS=3D'guest:xen'
>>>=20
>>> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>
>>> ---
>>> tests/avocado/boot_xen=2Epy      | 3 +++
>>> tests/avocado/kvm_xen_guest=2Epy | 1 +
>>> 2 files changed, 4 insertions(+)
>>=20
>> Those two are very different=2E One runs on Xen, the other on KVM=2E Do=
 we want to use the same tag for both?
>
>My understanding is,
>- boot_xen=2Epy runs Xen on TCG
>- kvm_xen_guest=2Epy runs Xen on KVM
>so both runs Xen guests=2E

Does boot_xen=2Epy actually boot *Xen*? And presumably at least one Xen gu=
est *within* Xen?

kvm_xen_guest=2Epy boots a "Xen guest" under KVM directly without any real=
 Xen being present=2E It's *emulating* Xen=2E

They do both run Xen guests (or at least guests which use Xen hypercalls a=
nd *think* they're running under Xen)=2E But is that the important classifi=
cation for lumping them together?


