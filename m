Return-Path: <kvm+bounces-3991-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 92F3780B8D4
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 05:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1A3F3B20AB9
	for <lists+kvm@lfdr.de>; Sun, 10 Dec 2023 04:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0B4D17D9;
	Sun, 10 Dec 2023 04:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=daynix-com.20230601.gappssmtp.com header.i=@daynix-com.20230601.gappssmtp.com header.b="1GAsdOHz"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD18CEA
	for <kvm@vger.kernel.org>; Sat,  9 Dec 2023 20:11:36 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-35d6c8d83dbso14067445ab.1
        for <kvm@vger.kernel.org>; Sat, 09 Dec 2023 20:11:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=daynix-com.20230601.gappssmtp.com; s=20230601; t=1702181496; x=1702786296; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NHiKyIW8CW8KPATS7dT57c/viP6HxCdGRmtk+8noqOo=;
        b=1GAsdOHzW4pUaXBTJk2cQjIJvpPx+JKjuqWXFxAjIoDLekteLkxkpFf1mb1WzqNFl3
         xB8ERa0bkolFEV/iR2ELouBFQiYHo7t/4/7p/vMPn5yOM1/qGtohWjAqNzyw4tmWIKoS
         RNnKXBkMORK28TOxqEJgKy5szupuNtB8+IGNFFMRP2H80K2hKSmvVuKHzDGRLFy/U/av
         4j3stKcN7YDi14D7gLDIHhEiNhgXAPgGhBYkj6ggdCgn7AbBUaDpA8GzOYlispi2TiAm
         KxSX3qxosURmjpkP1AZBQLpgH+4bfLf088XXJNYQIiDFBsmM8eYeQZC4QJGVc/JZeME6
         4yYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702181496; x=1702786296;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHiKyIW8CW8KPATS7dT57c/viP6HxCdGRmtk+8noqOo=;
        b=AyJuaQpOuBWO+RclkWjcbR4+LQZ/NOsXWZ+lBf/leaWjFgI4UEOP4SQ67PcF133vce
         yC5UjE8m+ZzWIWnShTWMDaaSdWKArnA91h8SgjjRnkDs9SUdpEyb4t78hLzaDh0tOCWc
         H8FKIHDv16xCB+a6f0qaE4qKgzmrv5e3Aq1g63DDTifqOyfR3ccoJ3rx8BUOUelIeX4W
         v0BlQb/qRj2U3LWUrgZ6hzpHzmFBP6f5hrqSv7K4pF1+x2bLqYXrVLWgO1qGruF3Dp+U
         mN+LOHnLxePvnNVLoS1C/THM7aqbBtvSM7GpK4EPfxkPusvcF9YlkM4FQUJfVAojRxwF
         FalQ==
X-Gm-Message-State: AOJu0Yw1RpVDpdk3T+zJ8YOOtS7QBoDl0ydwHlrLQ07EM5hmCexy5F9G
	KpW/ATHY+9EHELzAsjT/siIzXLNyZdurc6RIP4Rr2A==
X-Google-Smtp-Source: AGHT+IFYCMkj99QK+5QRZnG+Mwna4RVhNEAb4Bwjmkcesu1zs/Hyw4q9Djvk4LdrPsOGzmBTk8IIDg==
X-Received: by 2002:a05:6e02:198d:b0:35e:6bbf:4e5a with SMTP id g13-20020a056e02198d00b0035e6bbf4e5amr3032157ilf.44.1702181495955;
        Sat, 09 Dec 2023 20:11:35 -0800 (PST)
Received: from [157.82.205.15] ([157.82.205.15])
        by smtp.gmail.com with ESMTPSA id u3-20020a631403000000b005c6aa4d4a0dsm3949945pgl.45.2023.12.09.20.11.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Dec 2023 20:11:35 -0800 (PST)
Message-ID: <8717f71f-5350-45ef-9712-89c1240bc77c@daynix.com>
Date: Sun, 10 Dec 2023 13:11:31 +0900
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] tests/avocado: mips: add hint for fetchasset plugin
To: Cleber Rosa <crosa@redhat.com>, qemu-devel@nongnu.org
Cc: Jiaxun Yang <jiaxun.yang@flygoat.com>,
 Radoslaw Biernacki <rad@semihalf.com>, Paul Durrant <paul@xen.org>,
 Leif Lindholm <quic_llindhol@quicinc.com>,
 Peter Maydell <peter.maydell@linaro.org>, Paolo Bonzini
 <pbonzini@redhat.com>, =?UTF-8?Q?Alex_Benn=C3=A9e?=
 <alex.bennee@linaro.org>, kvm@vger.kernel.org, qemu-arm@nongnu.org,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 Beraldo Leal <bleal@redhat.com>,
 Wainer dos Santos Moschetta <wainersm@redhat.com>,
 Sriram Yagnaraman <sriram.yagnaraman@est.tech>,
 Marcin Juszkiewicz <marcin.juszkiewicz@linaro.org>,
 David Woodhouse <dwmw2@infradead.org>
References: <20231208190911.102879-1-crosa@redhat.com>
 <20231208190911.102879-3-crosa@redhat.com>
Content-Language: en-US
From: Akihiko Odaki <akihiko.odaki@daynix.com>
In-Reply-To: <20231208190911.102879-3-crosa@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023/12/09 4:09, Cleber Rosa wrote:
> Avocado's fetchasset plugin runs before the actual Avocado job (and
> any test).  It analyses the test's code looking for occurrences of
> "self.fetch_asset()" in the either the actual test or setUp() method.
> It's not able to fully analyze all code, though.
> 
> The way these tests are written, make the fetchasset plugin blind to
> the assets.  This adds redundant code, true, but one that doesn't hurt
> the test and aids the fetchasset plugin to download or verify the
> existence of these assets in advance.
> 
> Signed-off-by: Cleber Rosa <crosa@redhat.com>

Why not delete fetch_asset() in do_test_mips_malta32el_nanomips()?

