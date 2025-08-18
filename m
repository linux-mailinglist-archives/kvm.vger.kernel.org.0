Return-Path: <kvm+bounces-54919-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6393FB2B27E
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 22:36:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0EFF94E64D0
	for <lists+kvm@lfdr.de>; Mon, 18 Aug 2025 20:34:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4814E2248B4;
	Mon, 18 Aug 2025 20:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b="S9lZQARt"
X-Original-To: kvm@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19748190692
	for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 20:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755549243; cv=none; b=UNVblFN3E0Y2CnNAKuHBgLrW388Udlua3ySng7n7z1yeZVxZZAQbLjS2auRWsA6jY24PJmcLUdPI/bjQXoT1wwAp57fH/C2dApL0b72fimDflE5TAP1gt+wYxF3YAljE0jsVCrqjYW87cOIE/1dxLOD7YTwXa9y1Fl5yRzT+J7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755549243; c=relaxed/simple;
	bh=/dvxnJ7wY7jaLn1XY7+LGBz3G+AXEAX/pF//VdJh4EQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D48qPGkrgR8lbLDttViXgjuxj6VXdSSv8vDDczHra8vXjQWA4GDnhXEaGkxCjAKJLUdwrfXJMypO+waJCU0ZfzXc3NkPnSmFvDhLrzFYhV0hPPB01FqJvWGUmQ/M83FkqD+ac8Fc8KLkAA5TQsI9KG+p+v3O5D9MqUQ5s8EkAVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com; spf=pass smtp.mailfrom=ventanamicro.com; dkim=pass (2048-bit key) header.d=ventanamicro.com header.i=@ventanamicro.com header.b=S9lZQARt; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ventanamicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ventanamicro.com
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3e66c013e4dso5972335ab.0
        for <kvm@vger.kernel.org>; Mon, 18 Aug 2025 13:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ventanamicro.com; s=google; t=1755549241; x=1756154041; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wjJrmy2stspTCrvdXY1WIU0SYuKr2K0lvsiwRgTRkkg=;
        b=S9lZQARtfycaRGokGWKyRvyMAaKusty0X39WhTdGiY2TaFhNXqC7sf0st7wBQOC0Qq
         IQGkubFUD8liKEwWnLI4bDdfuDehv5EQoIHi99eH+qQuU8GAuPqHVLmrk8DGCzXTy593
         JiCWOzZFZVSdJdP4XKPzLTUVzh5dfOIYoWV81/a8Y+kdrLJXRPQ1joDBMVQzid3vkZtY
         FrjOFIjtIxBiWmq/MQQsDgilIC7zQMd1CS4KE26aQGD2EqzVp0rrjOlANvaGV2duesjP
         iYUgS4EXSFN2iVEkivLzajBuDhv+21YjyZHHswUfJ/xa4b8R0TJp5XbvkyeqxglpN8uk
         n7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755549241; x=1756154041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wjJrmy2stspTCrvdXY1WIU0SYuKr2K0lvsiwRgTRkkg=;
        b=oZOPr7Rg4HTqiLbSASdFvUGPyyl+37UYd98O37qhM/OIkvFRFX25bx+ztFKLT2Yk45
         Ima58oVSt3zSdSVhU75zrkBhc7uWwW9BLfPxNiZsnRoeixnzYUPp+lrfU3WTW6ZyxHXu
         kTFpvuabzRlEzaphe5NpRt1/fcRX3G88e+mpuFKEq+t4R8B4VImlHPmRXSaTFEfi0RiV
         9W5DD7fDtPUUHYuwXn6031yJgXVzIEsnkva71VkWJMm8YvwwSA3gMkrmVJv3Smi4BOpH
         ScWFybUnXiAKPcaKsQQMGF3ri1d76nMVNN/IB/rv3JA+zU9vadg5wc+Cre0ioUcg7Ba/
         +6ow==
X-Forwarded-Encrypted: i=1; AJvYcCX4CD0BQZrCGJk0W08qBuL1NhcmgYqx4IqBmwL20om0fXA2cwUJMXCCtmDsmWc8kAzOy9Q=@vger.kernel.org
X-Gm-Message-State: AOJu0YwsPRLj2h4g5q7abqSGPEIZH7/gkyFY22XCR+G9lGwVGU1oYcRM
	6dh2TJ/TlFnhj5SMq4g2jUz9wLLtTZZlJKTuzL6tgFNQD8yu4kCNQLcJYFTPoT8iQoo=
X-Gm-Gg: ASbGnctzr+6CeaBagXUEGx5TgBD4RjOswYN+/0Ot2p85QboB784uANlkHY8VuK/gk/V
	5OvzCfdGkwUzBRuiso08fMpQVZtolbB47VC17zOwqrKMIhOMwuyqLOIsVzBRyeSlpQAq1w7fG6A
	Fu8E4mABxdBESRf7o1HxGKUN9TVUy4seEeM0SgrWsNX3kG3TZR/Gy6fy+lG8V6u2e4Dol6iICwx
	5U8ukmAWWw2JWxBCfBtFwMMB3fvJw3YpAE8AvoPGJB8U++mV8ny4S3q1NG4BfJxZ0f3V+vJXamv
	kpVQvYLH/wZMkWPg2kyAjIVJemUktlRmc0ELlZvqIKRaDve9C1LaRwTX39ahcTzFfLYR95GToEu
	IqA3zIcW6Ir7KKQZHTQxsrdOL
X-Google-Smtp-Source: AGHT+IGRTgu1GwXkFLnvLr28LEmoS61swGqzhfNvkiuvx4bYf7qu9UcnEVK45d2zFEeHx8uZ9BB7/A==
X-Received: by 2002:a92:c267:0:b0:3e5:70b0:4f9c with SMTP id e9e14a558f8ab-3e674fe559cmr16147595ab.6.1755549241100;
        Mon, 18 Aug 2025 13:34:01 -0700 (PDT)
Received: from localhost ([140.82.166.162])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e66c6b0b12sm13099125ab.25.2025.08.18.13.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Aug 2025 13:34:00 -0700 (PDT)
Date: Mon, 18 Aug 2025 15:33:59 -0500
From: Andrew Jones <ajones@ventanamicro.com>
To: zhouquan@iscas.ac.cn
Cc: anup@brainfault.org, atishp@atishpatra.org, paul.walmsley@sifive.com, 
	palmer@dabbelt.com, linux-kernel@vger.kernel.org, linux-riscv@lists.infradead.org, 
	kvm@vger.kernel.org, kvm-riscv@lists.infradead.org
Subject: Re: [PATCH v2 2/6] RISC-V: KVM: Provide UAPI for Zicbop block size
Message-ID: <20250818-8beeedd83482f6e618be2ea0@orel>
References: <cover.1754646071.git.zhouquan@iscas.ac.cn>
 <befd8403cd76d7adb97231ac993eaeb86bf2582c.1754646071.git.zhouquan@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <befd8403cd76d7adb97231ac993eaeb86bf2582c.1754646071.git.zhouquan@iscas.ac.cn>

On Fri, Aug 08, 2025 at 06:18:34PM +0800, zhouquan@iscas.ac.cn wrote:
> From: Quan Zhou <zhouquan@iscas.ac.cn>
> 
> We're about to allow guests to use the Zicbop extension.
> KVM userspace needs to know the cache block size in order to
> properly advertise it to the guest. Provide a virtual config
> register for userspace to get it with the GET_ONE_REG API, but
> setting it cannot be supported, so disallow SET_ONE_REG.
> 
> Signed-off-by: Quan Zhou <zhouquan@iscas.ac.cn>
> ---
>  arch/riscv/include/uapi/asm/kvm.h |  1 +
>  arch/riscv/kvm/vcpu_onereg.c      | 14 ++++++++++++++
>  2 files changed, 15 insertions(+)
>

Reviewed-by: Andrew Jones <ajones@ventanamicro.com>

