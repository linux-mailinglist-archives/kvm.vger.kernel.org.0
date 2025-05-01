Return-Path: <kvm+bounces-45122-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 238B8AA60B2
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 17:23:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B00FC9C5175
	for <lists+kvm@lfdr.de>; Thu,  1 May 2025 15:23:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4480201278;
	Thu,  1 May 2025 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="A+M40svn"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA451EEA46
	for <kvm@vger.kernel.org>; Thu,  1 May 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746113029; cv=none; b=YQL3Xqm2ZIK6moslcrBYqScShde1OrrmWgip1avNjV6Dj5eMn48Qu/FXCazkqkKB28Tp943LZnk3bm8CVBOGr2x6Zxf5jdel/Mehbs2qrxUkf6XSxXlRzFaBwuYro/22dM0Vx3O9jr3BouEoDDjrYlxYne7/tiFPy4dggcDwa5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746113029; c=relaxed/simple;
	bh=/6MNDkNjvgplwI6717/jIJ/8yPa46ThdMGbbkhSS9z8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6WJdvlmHhI6sXIcy/89JYK7KgSyyQJqqaKKe/eK+uKgFutT8y6WOVnZilw5sT9N9NWbCoczKRCtiiCPyHsF2RG5NKlBcUS27J0a62jlE2FNmB5yvQ12lS/JzvDXk3zOfuFJYxzgjAIvLG6QfP4tLT/tbVyn/RuzKxR1+NUpFtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=A+M40svn; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-af52a624283so1025220a12.0
        for <kvm@vger.kernel.org>; Thu, 01 May 2025 08:23:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746113027; x=1746717827; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=A+M40svnneKnf6H51MZ5NS/xZ4Y7Lywx1bboxEKk7lIYq6K3cn8yF27Hth6bGYyigH
         lW3JiYfcM8WCxHEy7OLGqUk0WJM686GSVAoB6Ij+35XD9nwW72uQiSI+u9J8C46R6xZk
         xmQfWyCkQ8YpwY1SQmJ0JYP0vZR0NGK6LbQaQBNu09y8xroSNzgEWIXpsKRIRItbdnSa
         SYyW9/VSeFOCvgNCHv56yLM93N4zOIhlSTWjJRuVRtbuRiYKu2IgqbKJJsnS3w0ErUE9
         AnCfD86P3UIGo7baf5gdP3JT7xzJ5Vm9Yewgdsxo05qvUYNGGRZokZB+xnkBK+XTP04s
         PeDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746113027; x=1746717827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oTb37Xh3764UHx4GkunEtiY4YocHVNCV/2Hme8te8Ks=;
        b=XyqM5cbsJvhUfr5h7Sy19rjQpu3DJZ2ftY2hieiqD4t/GjsUMMfjhijZc2AVXxW11y
         QYPuwUHFhk5Sy2Hbl3ba9v14SuzGoHUlWK7soqHTvds3DZZ/Gj4GZ7pb2W/Cr4wGx+SI
         p1p8ryCdqBnl9jfdXcHGOe8LFAKiTJ8/JQYr7tat6gZjZ+wTSfd0iKJHG8p0g2QlxHTC
         lVdOX70yLNJS6JG/3OSQtl/Y0sm1N1Q33SIcnOENCEw13UbGlwcCaqLw2FgSnmHIwEMK
         NOf8yETtI9K9EMSUL0QGdhbNUnw1pfeHnz/vhZPpwVBjV7nu6bKRJto6E8YPY22nEpUu
         X6pQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwLfDgQEi4xhtusjOUd8DZz7EN/TgLTUri9J540UQa0qZENQeTdguN+3bacT5FGXYyP0w=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjS32lPUPvPbaseFJlp+LMOSxO96JN4GslbT4OJ2sypyixRIBo
	DkG2VPVx9u5LuC4ZkMu3UalDiRETCdWr0mP2IiCpB1m9Xt+G8FZ/36BKH9n3rQg=
X-Gm-Gg: ASbGncvlgtW4h0CFVK96/SL2Fu4QB7Dqsgte3wbImH+kLcBKZ+6cc21ouDRbW1PfKIA
	9D4jk6qJ95Fq+GeO1QPWrlrGORLZS1L8j+etnXQYVBmLiIlKQ+jopD9UI67ohfQfd3JtK7+9v+K
	q+iou2Tw8r5+A9SuCeGy0DfUe6HGwgWFhi75fCAmHcTmRVyPkX4Y4Gw73L/POQNd1cBOzJ9BpbK
	2/Sv47UUlth8gY8B4gCHn488/mD8dIcKhlst/9pklIwCr3pHd0IH7B7d5tAx6cQouoRaulxQpF9
	mKRMt+U9qgUm2i1j/l5MDNUAgU6fiXqbOLfonhxrHdPaoLB006A4krPKeogQC11fbHk5Ra78oIE
	iXY/Tc1mH/dEfDGmngw==
X-Google-Smtp-Source: AGHT+IGeIGOXpxe2jTOUCDPMZOtd+K4fLjVDkKah9tXMcswEOyenkaTjPmkGiWjX74LVyS7YdNXcsQ==
X-Received: by 2002:a05:6a20:9c9a:b0:1f5:8cf7:de4b with SMTP id adf61e73a8af0-20bdcd9eabcmr4194086637.16.1746113026817;
        Thu, 01 May 2025 08:23:46 -0700 (PDT)
Received: from [192.168.0.4] (71-212-47-143.tukw.qwest.net. [71.212.47.143])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7404f9fe120sm914753b3a.86.2025.05.01.08.23.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 May 2025 08:23:46 -0700 (PDT)
Message-ID: <f3fc3946-a191-44df-a610-fb636e2b314a@linaro.org>
Date: Thu, 1 May 2025 08:23:44 -0700
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 26/33] target/arm/arch_dump: compile file once (system)
To: Pierrick Bouvier <pierrick.bouvier@linaro.org>, qemu-devel@nongnu.org
Cc: Peter Maydell <peter.maydell@linaro.org>, qemu-arm@nongnu.org,
 alex.bennee@linaro.org, Paolo Bonzini <pbonzini@redhat.com>, anjo@rev.ng,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
 kvm@vger.kernel.org
References: <20250501062344.2526061-1-pierrick.bouvier@linaro.org>
 <20250501062344.2526061-27-pierrick.bouvier@linaro.org>
Content-Language: en-US
From: Richard Henderson <richard.henderson@linaro.org>
In-Reply-To: <20250501062344.2526061-27-pierrick.bouvier@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/25 23:23, Pierrick Bouvier wrote:
> Signed-off-by: Pierrick Bouvier<pierrick.bouvier@linaro.org>
> ---
>   target/arm/meson.build | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)

Reviewed-by: Richard Henderson <richard.henderson@linaro.org>

r~

