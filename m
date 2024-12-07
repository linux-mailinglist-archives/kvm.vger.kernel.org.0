Return-Path: <kvm+bounces-33244-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D019E7F0D
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 09:39:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A5CD281B47
	for <lists+kvm@lfdr.de>; Sat,  7 Dec 2024 08:39:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B17E13C836;
	Sat,  7 Dec 2024 08:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q0aRBymL"
X-Original-To: kvm@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADAF3B19A;
	Sat,  7 Dec 2024 08:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733560770; cv=none; b=LzBOonq1idaIPkUKvSqARhCYu9odOsQ7XVbA+LdyAYJLYUwUX/BKzkDW6Vnn5xRXjF5rgJD3XBGSNgv00dmgsgr2p6kZ4QkAweIYUZPdKr+OCN22D5ommOx9QCUbjWIKmccxD13QX1MY+31+PMCAoivIjO7wNi9HvSp+KBi+BW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733560770; c=relaxed/simple;
	bh=5/pUUungQ8NgDYyXV69cVH1mhMQviRIiv82xmjhsv8Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iNNOb+YUAu7k/fXqWb9hZtKbaysGhigD1nTKoTAEcS2va4Td3yekwZ7uJajhLu9juLKjjSUyEw1ThoidyPriP/7wqN6LqSvMuSeDaaalrfJL/YW/OW2ySSWyo8JtwcPBIDFUE1hmHXNoXdc5YBG2M08YmS116pn+r7yPmgTgYho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q0aRBymL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F830C4CECD;
	Sat,  7 Dec 2024 08:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733560770;
	bh=5/pUUungQ8NgDYyXV69cVH1mhMQviRIiv82xmjhsv8Y=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=q0aRBymLLvkn7rpU7sHaKpPTbGSp7brUEOpZ+lM3xFLznQBE1CPRNcggMoMTHMHYk
	 a0WxS1DuPP2uMWnEvsFz3Sxi/lBFNGu/4X18volPeA+xfeNA6szsffVYP2Ihb60Z3h
	 /Q+Px8YsWA6akm1fX/WpeVXE5+9na3LcjKxMKltM3RnT0fS7NmAY0WKFe9yMbssVOn
	 RgD1/dkGqzmOMP8NydhXGZsq+4+An267qUuEYkamqMUdcCVPge6224btqcR1QbdmaE
	 cLDE2fLOxt09JXry6/bE1sqDsrOdog0vrJccUMIc0gxPOyWpdz1h3Jjug6hYazgOo1
	 /GsdPgkQ45P+g==
Date: Sat, 7 Dec 2024 09:39:22 +0100
From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To: Markus Armbruster <armbru@redhat.com>
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Shiju Jose <shiju.jose@huawei.com>, Philippe
 =?UTF-8?B?TWF0aGlldS1EYXVkw6k=?= <philmd@linaro.org>, Ani Sinha
 <anisinha@redhat.com>, Cleber Rosa <crosa@redhat.com>, Dongjiu Geng
 <gengdongjiu1@gmail.com>, Eduardo Habkost <eduardo@habkost.net>, Eric Blake
 <eblake@redhat.com>, Igor Mammedov <imammedo@redhat.com>, John Snow
 <jsnow@redhat.com>, Marcel Apfelbaum <marcel.apfelbaum@gmail.com>, Michael
 Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, Peter
 Maydell <peter.maydell@linaro.org>, Shannon Zhao
 <shannon.zhaosl@gmail.com>, Yanan Wang <wangyanan55@huawei.com>, Zhao Liu
 <zhao1.liu@intel.com>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 qemu-arm@nongnu.org, qemu-devel@nongnu.org
Subject: Re: [PATCH 00/31] Prepare GHES driver to support error injection
Message-ID: <20241207093922.1efa02ec@foz.lan>
In-Reply-To: <87wmgc2f48.fsf@pond.sub.org>
References: <cover.1733504943.git.mchehab+huawei@kernel.org>
	<87frn03tun.fsf@pond.sub.org>
	<87wmgc2f48.fsf@pond.sub.org>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.43; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

Em Sat, 07 Dec 2024 07:15:19 +0100
Markus Armbruster <armbru@redhat.com> escreveu:

> Markus Armbruster <armbru@redhat.com> writes:
> 
> > This is v10, right?  
> 
> Scratch that, the cover letter explains: "As agreed duing v10 review,
> I'll be splitting the big patch series into separate pull requests,
> starting with the cleanup series.  This is the first patch set,
> containing only such preparation patches."

Please scratch this series. It seems I picked the wrong git range,
sending a lot more patches than intended.

> However, it doesn't apply for me.  What's your base?

That's weird. Despite my mistake, the series is based on v9.2.0-rc3 
(which was identical to master last time I rebased).

Should it be based against some other branch?

Thanks,
Mauro

