Return-Path: <kvm+bounces-1366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E6BA07E7261
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 20:33:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A12DE281055
	for <lists+kvm@lfdr.de>; Thu,  9 Nov 2023 19:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 688E137143;
	Thu,  9 Nov 2023 19:33:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="NORYTqq/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF1036AFC
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 19:33:31 +0000 (UTC)
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434A13ABA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 11:33:31 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-6c115026985so1314249b3a.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 11:33:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1699558411; x=1700163211; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LmQUwtKqBsbUaMBDQyLDzBgdhUAqOrOc7yxWsj82q/k=;
        b=NORYTqq/xj8lgK6dgwNNBfCZQDscOCdzMPlRj5KS/3BqzRqSrrEXb8DsDq7YaNpMyT
         m0vw7UMkVfYJpZE8G6pI4KFV/pEEAq7/CB/9/cetvb8hBW2PyTJmdVYnpc3GnVCtKMnN
         710+DkQCtb7I2Hts0g8aRhD4E+z8A8LHPFBk6zcOgNNS61s1aqVNTo9sa8KP7Nl8CJ0+
         rI2nznZ/GIfKY2lPWexOC88H6yh/y5H8BkE/2k+vGS4EZCKTw7M2P4Qu/VPM/lM9zbnA
         D83SFVVZd967Gbo2AJXcAcP/eXVijTKPtD+BMkd6kLWa0fb3p6k4qZw0w9Ihz8tsWjjt
         BIpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699558411; x=1700163211;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LmQUwtKqBsbUaMBDQyLDzBgdhUAqOrOc7yxWsj82q/k=;
        b=POp3p1YfiecRqgUMmyYatcL5UK83Trg0OOflAXDwrx4V4/lNuR7lNtQgLHSaKSHhNn
         iEijPP/sDcI5uqot5DK++U2jp6FKV9Ixr4DXKKn8A3V4jAgR1ioeZLFH1FjIwf2n0et/
         0Xf/Z7D8bJsG3wskpOyX8GH61vcoaRsy7TWFcqD2CdVwjM5ctf7FSWAEpMxU1ePgLV/t
         s2+Y0Z8ZBd7kRDztoEOgwq8XitAyEaJn92hW+7RnmKniqZNDM6n5oSnhdUO86dLeJFa+
         VYT2q28JZ/uh8V3zEapHqNo4HYRwAq3kVVhyjkwgp5rkPe/TVu84+7FWalq3ILOmJrBU
         gEsw==
X-Gm-Message-State: AOJu0Yxg3uQ2Ek+Tb8AEkiBlBVaQ+gEc7xOVMSKjcgChdfeACZLMO3kc
	EaZDCKEuXdygjxPr81woK+urtQ==
X-Google-Smtp-Source: AGHT+IGH69bRWqdVbLK+NVzUA93eXn4nsYO4Al4pSQgrJlCb5OqnjuN8XHVwkFHQJEaiAPcbiFvo0Q==
X-Received: by 2002:a05:6a20:3955:b0:15c:b7ba:6a4d with SMTP id r21-20020a056a20395500b0015cb7ba6a4dmr7445798pzg.50.1699558410754;
        Thu, 09 Nov 2023 11:33:30 -0800 (PST)
Received: from [192.168.68.107] ([179.193.10.161])
        by smtp.gmail.com with ESMTPSA id fi20-20020a056a00399400b006c4d0b53365sm138627pfb.88.2023.11.09.11.33.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Nov 2023 11:33:30 -0800 (PST)
Message-ID: <5d60b71e-d470-449c-b23f-77ae0a6528bb@ventanamicro.com>
Date: Thu, 9 Nov 2023 16:33:25 -0300
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
Content-Language: en-US
From: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
In-Reply-To: <mvmr0kz469m.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/9/23 06:37, Andreas Schwab wrote:
> On Jul 31 2023, Daniel Henrique Barboza wrote:
> 
>> Existing userspaces can be affected by this error code change. We
>> checked a few. As of current upstream code, crosvm doesn't check for any
>> particular errno code when using kvm_(get|set)_one_reg(). Neither does
>> QEMU.
> 
> That may break qemu:
> 
> $ qemu-system-riscv64 -cpu rv64 -machine virt,accel=kvm
> qemu-system-riscv64: Unable to read ISA_EXT KVM register ssaia, error -1

Which QEMU version are you using? This is a problem that was fixed upstream by:


commit 608bdebb6075b757e5505f6bbc60c45a54a1390b
Author: Daniel Henrique Barboza <dbarboza@ventanamicro.com>
Date:   Tue Oct 3 10:21:48 2023 -0300

     target/riscv/kvm: support KVM_GET_REG_LIST


If you're getting this error with upstream QEMU let me know and I'll take a look
there.


Thanks,


Daniel


> 

