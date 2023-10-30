Return-Path: <kvm+bounces-64-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 38DA37DB967
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 13:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 33509B20EE8
	for <lists+kvm@lfdr.de>; Mon, 30 Oct 2023 12:00:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AE25156FB;
	Mon, 30 Oct 2023 12:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Noz1G952"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A6814F6B
	for <kvm@vger.kernel.org>; Mon, 30 Oct 2023 12:00:26 +0000 (UTC)
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82FB4F1;
	Mon, 30 Oct 2023 05:00:23 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-32dc918d454so2766818f8f.2;
        Mon, 30 Oct 2023 05:00:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698667221; x=1699272021; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9T5S8kCI0IiXREJBxPiHYf6awYVTefKwzkyELqsdrZo=;
        b=Noz1G9520KNvd0+YjFw9dE7qpt0CrYBhVW4XdvRQ6Cu3ZQtDPUFtKiKGAEvCfTXqa+
         On+Fdcnl2qT+xPqHk7TYJiS33gg3xZbfNM+QZTOXYwt+GCuSc31GygWJRePV0vz59Ghf
         H0SV1wHPTvD0ZbCEr6GNa70H3DlvjMz9NxNkMnie3RwQQPuRgVJFlY4nFuuQtZhV0hHm
         20i247AgoqODHinunqPnSJDwySR/m4oKgWbXHTmg23UHJLvsY3LMMoqpFuUgxRMfB/Wo
         3cMYpjGxcHi7+7mz4m3Fi3QxMUDerKdStVDlXThpi6NDEkQ59nSrLsYxfln8qyu/4FbD
         NH/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698667221; x=1699272021;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9T5S8kCI0IiXREJBxPiHYf6awYVTefKwzkyELqsdrZo=;
        b=SNHSxieI0yYl9jmpExw2v48C7XjWE76a95eztt8nsEy9uJpJtLtgaxt6gDBlu6zZ8k
         lEOKMQCCMoF6bOmFyuigQcd0TpeI4wwgnFTjMwTP4z3G7vt2P5O0gLTaOaRdlumNsh9Y
         umB7DTEp0nhMTeiWL32wA9X3aJl3qTI1P1gsDFD/0SDpCEhanAAwcpH64drDYCYK1eqO
         6Lkl4EOZxAxvUsdWEMKhDlFTx2k/GhD8ZX9GE9VLmHTy5C9I1alUTO0/VOQNKHOIITbR
         QAI9/BZnjZ+0xhP9lMcFo5/RmElIw83l9TeexsRZuz/8SU74vZ6j+wyum3Nwre8JGh2k
         E/gw==
X-Gm-Message-State: AOJu0Yy81Z3KgtBMlWv80vRiYBvrYIcNdcN+Em1k6GpCKSaBNLf4STXR
	osoMgU1NfE3mF76d1MQpAaQ=
X-Google-Smtp-Source: AGHT+IHtRzHF4q6z4FowSshP7nN2TfJP0FrDkHaAdi0mhZlwavk9Z4J+Uu0HHLX/PFA2391Un1ZvuQ==
X-Received: by 2002:a5d:59a5:0:b0:32f:89fb:771d with SMTP id p5-20020a5d59a5000000b0032f89fb771dmr1596003wrr.12.1698667221311;
        Mon, 30 Oct 2023 05:00:21 -0700 (PDT)
Received: from [192.168.14.164] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id h16-20020adfe990000000b0032dc24ae625sm8118864wrm.12.2023.10.30.05.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Oct 2023 05:00:20 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <1f528e23-b58e-483e-8d65-97a822544167@xen.org>
Date: Mon, 30 Oct 2023 12:00:16 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH v7 00/11] KVM: xen: update shared_info and vcpu_info
 handling
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: Paul Durrant <pdurrant@amazon.com>, "H. Peter Anvin" <hpa@zytor.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <20231002095740.1472907-1-paul@xen.org>
 <6629b7f0b56e0fb2bad575a1d598cce26b1c6432.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <6629b7f0b56e0fb2bad575a1d598cce26b1c6432.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 05/10/2023 07:41, David Woodhouse wrote:
> On Mon, 2023-10-02 at 09:57 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> The following text from the original cover letter still serves as an
>> introduction to the series:
>>
>> "Currently we treat the shared_info page as guest memory and the VMM
>> informs KVM of its location using a GFN. However it is not guest memory as
>> such; it's an overlay page. So we pointlessly invalidate and re-cache a
>> mapping to the *same page* of memory every time the guest requests that
>> shared_info be mapped into its address space. Let's avoid doing that by
>> modifying the pfncache code to allow activation using a fixed userspace HVA
>> as well as a GPA."
>>
>> This version of the series is functionally the same as version 6. I have
>> simply added David Woodhouse's R-b to patch 11 to indicate that he has
>> now fully reviewed the series.
> 
> Thanks. I believe Sean is probably waiting for us to stop going back
> and forth, and for the dust to settle. So for the record: I think I'm
> done heckling and this is ready to go in.
> 

Nudge.

Sean, is there anything more I need to do on this series?

   Paul


