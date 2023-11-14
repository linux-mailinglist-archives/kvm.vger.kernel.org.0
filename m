Return-Path: <kvm+bounces-1689-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 573757EB43F
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:57:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 442211C209FC
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:57:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F12EE4177E;
	Tue, 14 Nov 2023 15:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="bgwhwUbv"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44F441773
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:56:55 +0000 (UTC)
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241DC12C
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:MIME-Version:Message-ID:References:In-Reply-To:Subject:CC:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=JfeV0qK8CgxsVSu2eoR2UV6eTjBlrnZLZoYR1NzgBIE=; b=bgwhwUbvJ39iHovOHLIjZRuYBI
	iqXx8yCvVgl16/UeT3qm+ITCuxnj7dx/R19vrz6jG4ClQBKJZB2HlsWRvTfgl7QINLlnCDSniROfZ
	TvXrdS6AObLK2YQuW5WAgCoSqIW6+6pjppciWZKYJ4LxHBad9Zo/xlQFXy+D1v5IoJxWevGiF4C3H
	jvUOBc8KZLf+Dg/5oCTe0K00sFe/Di6RytUaBWsDh3pwdCsLv/shZtt5AXYtqV5CAepgDLUx3ULWm
	/4/pOMD7KYrL3+skL+3V8pO4O1Q0c5Dz+kPmNHK5F/rzeI5WrIWKFi3LAtjNrsms6s3kuYjw8XEUj
	Oj643nXA==;
Received: from [12.186.190.2] (helo=[127.0.0.1])
	by desiato.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1r2vmM-002YdA-0t;
	Tue, 14 Nov 2023 15:56:42 +0000
Date: Tue, 14 Nov 2023 10:56:38 -0500
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
 Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
 Eduardo Habkost <eduardo@habkost.net>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH-for-9=2E0_v2_18/19=5D_hw/i386/xe?= =?US-ASCII?Q?n=3A_Compile_=27xen-hvm=2Ec=27_with_Xen_CPPFLAGS?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20231114143816.71079-19-philmd@linaro.org>
References: <20231114143816.71079-1-philmd@linaro.org> <20231114143816.71079-19-philmd@linaro.org>
Message-ID: <F6740A4D-7968-4F51-835E-E50AD646468B@infradead.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by desiato.infradead.org. See http://www.infradead.org/rpr.html

On 14 November 2023 09:38:14 GMT-05:00, "Philippe Mathieu-Daud=C3=A9" <phil=
md@linaro=2Eorg> wrote:
>xen-hvm=2Ec calls xc_set_hvm_param() from <xenctrl=2Eh>,
>so better compile it with Xen CPPFLAGS=2E
>
>Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro=2Eorg>

Reviewed-by: David Woodhouse <dwmw@amazon=2Eco=2Euk>


