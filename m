Return-Path: <kvm+bounces-1593-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E60B67E9A47
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 11:27:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85C301F20F9E
	for <lists+kvm@lfdr.de>; Mon, 13 Nov 2023 10:27:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E5FA1CA85;
	Mon, 13 Nov 2023 10:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="mcJbwMw+"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFAF3882F
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 10:27:38 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C5DD75
	for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:27:37 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-6c396ef9a3dso3493796b3a.1
        for <kvm@vger.kernel.org>; Mon, 13 Nov 2023 02:27:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1699871257; x=1700476057; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rv1AhH3eTB8RYD6tpZyG6/qCvengBvymMG2O9I43VwE=;
        b=mcJbwMw+RVY7J2vMXpnaH2xkt1WoH3ElYt2etR6OPw2R12lxhxr1w3KLrlQizvxSgr
         twgMaDLxDYCUhqnkI4ZvzGdG05NM/XXtDxV2ajwXIzuv8790dLeN0M8X0+KsrJu8R7ct
         sV3QhPG9JUYd5ayjOgB9bjugwhHIK8tHgS1d56tg32QCSFSNPA+wZrEj7RQtAL15+7AV
         7a6TzHQyZTtjde7Z4C3iJ4NAc3LynQlE+wuVfHaWZl1eCMuxGG6lOH+Xj2+yJEWKoNIK
         gisCNiLnB5rvcP6T0HvtLzEI7Z66od2ClpasTD0XZZHFkM3+ieJ8NMWoWj72Syantq52
         23KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699871257; x=1700476057;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rv1AhH3eTB8RYD6tpZyG6/qCvengBvymMG2O9I43VwE=;
        b=PTe9NVJKJMITigTn5fwjDEz4jqU+sU2iy++wJk7Ghr1Dft5M154m9YDsqy7TcdGblS
         YArtwNbBwZX5Mt1ESmhLkQbvnfu12iXKwtzV+PxOobxe/ptoJhSx9qpeemlfjLmUDahw
         tywouqhnEB9kf/QiT+lcLiQl/sVXf6GVSwocAcG2eeECJHEbiqnPzEiXpUS19+Inhmqn
         DV9Qqf/9WebgCCiYPovUw8k3iAlkf+dcGI5SPA9SgplEzQCkcEvebHqHKrXoKGhlDn9j
         W/ti4p2dPRfFavwZYyOvIR1ZA2WX5s5SFbIzLUlW5Dw9YPo6TR7sTBWqimXm4eIMiC2J
         MGBA==
X-Gm-Message-State: AOJu0Yzslb4I8hB/Y2L6cEt6bv2Tmd4lFpapayb9ku1K1DCfGzDAH7O6
	f3uBwD6Ab3OzGLj+wvPaQmmf6kCidJ1sUJu0ilE=
X-Google-Smtp-Source: AGHT+IEFqZyGx2ecg6LIuVE9/qU5wiuzEX0ujNes8kMNMyFS2eIny6dsgSr1J1ePq1Po+ryjGlMjxQ==
X-Received: by 2002:aa7:9a84:0:b0:6b3:aded:7e9a with SMTP id x4-20020aa79a84000000b006b3aded7e9amr3865790pfi.27.1699871257098;
        Mon, 13 Nov 2023 02:27:37 -0800 (PST)
Received: from [192.168.68.107] ([152.250.131.148])
        by smtp.gmail.com with ESMTPSA id s18-20020a056a00195200b006c3328c9911sm3640433pfk.93.2023.11.13.02.27.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Nov 2023 02:27:36 -0800 (PST)
Message-ID: <6d8ff85e-b0b6-46f2-8554-b9543f3eab31@ventanamicro.com>
Date: Mon, 13 Nov 2023 07:27:32 -0300
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/6] RISC-V: KVM: return ENOENT in *_one_reg() when reg is
 unknown
To: Andreas Schwab <schwab@suse.de>
Cc: kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 kvm@vger.kernel.org, anup@brainfault.org, atishp@atishpatra.org,
 ajones@ventanamicro.com
References: <20230731120420.91007-1-dbarboza@ventanamicro.com>
 <20230731120420.91007-2-dbarboza@ventanamicro.com> <mvmr0kz469m.fsf@suse.de>
 <5d60b71e-d470-449c-b23f-77ae0a6528bb@ventanamicro.com>
 <mvmfs1a3vjl.fsf@suse.de>
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <mvmfs1a3vjl.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/13/23 05:30, Andreas Schwab wrote:
> On Nov 09 2023, Daniel Henrique Barboza wrote:
> 
>> Which QEMU version are you using?
> 
> The very latest release, both host and guest.

If by "latest release" you mean kernel 6.6 and QEMU 8.1, this combination is
broken ATM.

Back in 8.1 QEMU was checking for EINVAL to make an educated guess of whether an
extension was unavailable but the register exists, versus if the register was alien
to KVM at all (qemu commit f7a69fa6e6). This turned out to be a mistake because
EINVAL was being thrown for all sorts of errors, and QEMU would be wiser to just
error out in all errors like other VMMs were doing (including kvmtool).

These were considerations made when proposing this KVM side change in the cover letter.
Other VMMs would be unaffected by it, and QEMU would need changes to adapt to the new
error codes. QEMU 8.2 is already adapted. It's not ideal, but it's better to take
a hit now while the RISC-V ecosystem is still new and make things tidy for the
future.

And now that I'm thinking more about it, I'll push a QEMU change in 8.1-stable to
alleviate the issue for 8.1. My apologies, I should've thought about it earlier ...


Thanks,

Daniel


> 

