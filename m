Return-Path: <kvm+bounces-61474-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 1665DC1FDD2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 12:42:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id B7EBA3434C2
	for <lists+kvm@lfdr.de>; Thu, 30 Oct 2025 11:42:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45F9433F370;
	Thu, 30 Oct 2025 11:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.yodel.dev header.i=@mail.yodel.dev header.b="BR9/mlZc"
X-Original-To: kvm@vger.kernel.org
Received: from pc232-55.mailgun.net (pc232-55.mailgun.net [143.55.232.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C0132D437
	for <kvm@vger.kernel.org>; Thu, 30 Oct 2025 11:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=143.55.232.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761824568; cv=none; b=lFG0uYCWw8nOoYrcfBnP3/ygKltCWv4gSo+L9oq7ygFSU79V0vTIH/ijmyQhgDXsZFabGEnUyfWKcnOBTUq/OJJ8x0xg1Scxl1NiIGtia8qkzxx24PnY4dTbVX0hoAI2ygfCR+BmqdccTwhnOma2sZBqbIXJOgmttjzDphC+kpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761824568; c=relaxed/simple;
	bh=yZoChXLznwSscAm+JJJt2BYR/avxL8jDXJ0N3C+Wfi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SSYsTwoHZzXS/hn459M06LjQBqgT3NGvLrfaksTtR1PhsPECLn4C+xmIje47cu5FOiIrB4sKaqv97PtWZ2W0bPIq8iEwzNcl/FnwK9pYTTH3lEGjAdtCIcFP3/mZtFKW+XsWbZeCYRClLYzHDFSmmy0brwPyoVBOrpfwbwiCUD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yodel.dev; spf=pass smtp.mailfrom=mail.yodel.dev; dkim=pass (1024-bit key) header.d=mail.yodel.dev header.i=@mail.yodel.dev header.b=BR9/mlZc; arc=none smtp.client-ip=143.55.232.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yodel.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.yodel.dev
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mail.yodel.dev; q=dns/txt; s=dkim; t=1761824563; x=1761831763;
 h=Content-Transfer-Encoding: Content-Type: In-Reply-To: From: From: References: Cc: To: To: Subject: Subject: MIME-Version: Date: Message-ID: Sender: Sender;
 bh=BX8WMM54/X2z4JKKterrQ+u3+tKia/gkKKQAUuSGQIw=;
 b=BR9/mlZcGJOgzJb9C5XSJSqttREsKlgcbgvKqjAs3SPCxp5hoFCR5MAVUXL4FFT6MLi5Q318/y3y4cWHIoTIzt8mRR/z6qqWSOd13xPSYf5mkUPXzODliEMGOMsAB93HYj+QD+3GmICuQyvQaKXd2y2JERaVYXVmsG/zg/0bGCU=
X-Mailgun-Sid: WyI1YzlhMSIsImt2bUB2Z2VyLmtlcm5lbC5vcmciLCIzM2U5MjAiXQ==
Received: from mail.yodel.dev (mail.yodel.dev [35.209.39.246]) by
 82b7b0aa6a9490e1d37f90288d42dfc2781b07d0e3a3464ca437034ccc894751 with SMTP id
 69034f33e4319a89b6306c09; Thu, 30 Oct 2025 11:42:43 GMT
X-Mailgun-Sending-Ip: 143.55.232.55
Sender: yodel.eldar=yodel.dev@mail.yodel.dev
Message-ID: <f1a0f03f-54b8-4fa8-8e03-b00a617bd462@yodel.dev>
Date: Thu, 30 Oct 2025 06:42:41 -0500
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/7] cpus: Constify some CPUState arguments
To: Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
 =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
Cc: qemu-devel@nongnu.org, Richard Henderson <richard.henderson@linaro.org>,
 Kyle Evans <kevans@freebsd.org>, Warner Losh <imp@bsdimp.com>,
 kvm@vger.kernel.org, Laurent Vivier <laurent@vivier.eu>
References: <20250120061310.81368-1-philmd@linaro.org>
 <395c7c86-08b1-4af4-a5ca-012a9aa89339@linaro.org>
 <CAAjaMXZSkxCgzdC6w-onUxVxU_ZW5fiBtW5-ioeKaXwD_7tJeQ@mail.gmail.com>
Content-Language: en-US
From: Yodel Eldar <yodel.eldar@yodel.dev>
Autocrypt: addr=yodel.eldar@yodel.dev; keydata=
 xjMEZxqXdhYJKwYBBAHaRw8BAQdAkletQdG3CLyANZyuf2t7Z9PK4b6HiT+DdSPUB2mHzmPN
 I1lvZGVsIEVsZGFyIDx5b2RlbC5lbGRhckB5b2RlbC5kZXY+wpkEExYKAEECGwMFCQOcG00F
 CwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQTTzRjNQG27imap+N+V7k+3NmVNrAUCaNWASwIZ
 AQAKCRCV7k+3NmVNrNnSAPoDjQXa6v7ZzdQSaLdRfAQy/5SsUucv+zp3WAP4pXdgJQEAzMMC
 Ctx4l6b13Fs2hZdRXEnF/4BZ9t1K68nwzZOV3QnOOARnGpd2EgorBgEEAZdVAQUBAQdAKPIy
 3W/DKFsm1e+31zoqmOY0pqz8vjIM846wM6lEY2QDAQgHwn4EGBYIACYCGwwWIQTTzRjNQG27
 imap+N+V7k+3NmVNrAUCaNWG7QUJA5wi9wAKCRCV7k+3NmVNrPusAQCQDQwETy7VT6UhHPho
 TkrQnsNqQfFU3tXqCTiViToktQD7B/U2/to97hQIJCWbK6yd3T+KPZJPMcHMg2XRyedUvgA=
In-Reply-To: <CAAjaMXZSkxCgzdC6w-onUxVxU_ZW5fiBtW5-ioeKaXwD_7tJeQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 30/10/2025 01:59, Manos Pitsidianakis wrote:
> On Wed, Oct 29, 2025 at 7:59 PM Philippe Mathieu-Daudé
> <philmd@linaro.org> wrote:
>>
>> On 20/1/25 07:13, Philippe Mathieu-Daudé wrote:
>>> This is in preparation of making various CPUClass handlers
>>> take a const CPUState argument.
>>>
>>> Philippe Mathieu-Daudé (7):
>>>     qemu/thread: Constify qemu_thread_get_affinity() 'thread' argument
>>>     qemu/thread: Constify qemu_thread_is_self() argument
>>>     cpus: Constify qemu_cpu_is_self() argument
>>>     cpus: Constify cpu_get_address_space() 'cpu' argument
>>>     cpus: Constify cpu_is_stopped() argument
>>>     cpus: Constify cpu_work_list_empty() argument
>>>     accels: Constify AccelOpsClass::cpu_thread_is_idle() argument
>>
>> ping?
>>
> 
> Hi Philippe, I can't find this series in my mailbox and it's not on
> lore.kernel.org/patchew/lists.gnu.org either. Resend?
> 

Hi,

Looks like it landed on the kvm mailing list via Cc but was left out of
qemu-devel, despite the seemingly correct To header:

https://lore.kernel.org/kvm/20250120061310.81368-1-philmd@linaro.org/

Regards,
Yodel

