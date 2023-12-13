Return-Path: <kvm+bounces-4388-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 58D92811F12
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 20:39:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CD071F21A30
	for <lists+kvm@lfdr.de>; Wed, 13 Dec 2023 19:39:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A30786828C;
	Wed, 13 Dec 2023 19:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QIbU+Lr7"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E8ABB2
	for <kvm@vger.kernel.org>; Wed, 13 Dec 2023 11:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1702496375;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pKJ2gmaWxKAK6Y/wvzA1srhiIXS0NochFPI0HVkNASs=;
	b=QIbU+Lr7B8/Bj0t6vXZJFT6Bmoq39y+tN10ts0xUlbxp+C3JQxqLUNrJROsJzODiHk1Esx
	OQQVYqnXqumY2EzLL7JbwOl4/li+QrCIro6WCePE9G9JIp7uVbKwx2SeWBG1KTe+KreLhR
	1p4X3NnKmvIDx69OH1qYtEbxdJN4A1g=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-HANLME-LOSCusGI_e2kGGg-1; Wed, 13 Dec 2023 14:39:29 -0500
X-MC-Unique: HANLME-LOSCusGI_e2kGGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E444488FC26;
	Wed, 13 Dec 2023 19:39:28 +0000 (UTC)
Received: from p1.localdomain.some.host.somewhere.org (ovpn-114-21.gru2.redhat.com [10.97.114.21])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 104BE1121306;
	Wed, 13 Dec 2023 19:39:20 +0000 (UTC)
From: Cleber Rosa <crosa@redhat.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>, Radoslaw Biernacki
 <rad@semihalf.com>, Paul Durrant <paul@xen.org>, Leif Lindholm
 <quic_llindhol@quicinc.com>, Peter Maydell <peter.maydell@linaro.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Alex =?utf-8?Q?Benn=C3=A9e?=
 <alex.bennee@linaro.org>,
 kvm@vger.kernel.org, qemu-arm@nongnu.org, Philippe =?utf-8?Q?Mathieu-Daud?=
 =?utf-8?Q?=C3=A9?=
 <philmd@linaro.org>, Beraldo Leal <bleal@redhat.com>, Wainer dos Santos
 Moschetta <wainersm@redhat.com>, Sriram Yagnaraman
 <sriram.yagnaraman@est.tech>, Marcin Juszkiewicz
 <marcin.juszkiewicz@linaro.org>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 02/10] tests/avocado: mips: add hint for fetchasset plugin
In-Reply-To: <8717f71f-5350-45ef-9712-89c1240bc77c@daynix.com>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-3-crosa@redhat.com>
 <8717f71f-5350-45ef-9712-89c1240bc77c@daynix.com>
Date: Wed, 13 Dec 2023 14:39:05 -0500
Message-ID: <87zfydvqna.fsf@p1.localdomain>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

Akihiko Odaki <akihiko.odaki@daynix.com> writes:

> On 2023/12/09 4:09, Cleber Rosa wrote:
>> Avocado's fetchasset plugin runs before the actual Avocado job (and
>> any test).  It analyses the test's code looking for occurrences of
>> "self.fetch_asset()" in the either the actual test or setUp() method.
>> It's not able to fully analyze all code, though.
>> 
>> The way these tests are written, make the fetchasset plugin blind to
>> the assets.  This adds redundant code, true, but one that doesn't hurt
>> the test and aids the fetchasset plugin to download or verify the
>> existence of these assets in advance.
>> 
>> Signed-off-by: Cleber Rosa <crosa@redhat.com>
>
> Why not delete fetch_asset() in do_test_mips_malta32el_nanomips()?

I was trying to preserve do_test_mips_malta32el_nanomips() in such a way
that with the eventual migration to the "dependency" system in newer
Avocado, the lines added here could simply be reversed.

But, that's not a strong enough reason to justify the duplication.  I'll
follow your suggestion on v2.

Thanks!
- Cleber.


