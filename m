Return-Path: <kvm+bounces-1681-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 361807EB36E
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 16:22:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C26811F25194
	for <lists+kvm@lfdr.de>; Tue, 14 Nov 2023 15:22:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 53E3841755;
	Tue, 14 Nov 2023 15:22:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BKS+HISC"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A53FE27
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 15:22:30 +0000 (UTC)
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0CB123
	for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:22:28 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id 4fb4d7f45d1cf-53e2308198eso8812610a12.1
        for <kvm@vger.kernel.org>; Tue, 14 Nov 2023 07:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699975347; x=1700580147; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MUHR/sFEjdzbvDET4onhF+bWIy1sGTTug2OAYdlSeSM=;
        b=BKS+HISCsbLSSm3tOEmrAFUJaIAd84sWcMGYzGBNB8mbqPc1g0jnWN7G+wCduEK7dE
         gbUMAudRLjIqN97oY9ZKdxttcEl7LFA17SCtP4QFdmckDadzYAyNugayq2svOokghK2O
         v3Mmji5OslJvRfhiGXoBHqeyLTy/vvK4TZyxut0moEbOiWS3//g+rqHUGc3Vnfu53zr3
         osFQj42TpzWZp82Y6FKQ2h6wkN3hZTsgXld2CUkTe66k5abOM21EPo85qpzO8E36rJIn
         /7iDdAtDSGfckorKTwu72reK/Q9mG/7lSOq4idLuRXAGUEG2zQ1Mywc1D65QIzLNX2YB
         eztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699975347; x=1700580147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MUHR/sFEjdzbvDET4onhF+bWIy1sGTTug2OAYdlSeSM=;
        b=o1N0K3xAJpliNQFDU50KPBRsqp6NwkE8hs+5jr5kQ3+O1MWPY6DeB+CPiULVkB0Kea
         QlrlhSKNwvhxiYREfCC8wFX4ZL+s/3acTNvueJQDy2vbZT/LqNKnj7pT6dQoRRg9KgCV
         6dsvOxSWDrKPkCXPsLjE5SOwtBhMkfxaJyIQtSF0zmu7DBftG/A/Too6KX8K4GPDLX+0
         cibWJv6XQQyr4Vrcs0K+rSUyeHHejdZzPmamGaCyCJhfbisRO4hnDABOID0wbFjn0ti5
         K4fs24mev/Ch2eO1nswJpAPW+a00q9v12T4Clio219Jd4Kv4j03mtwZdQ9dsb13NDm8b
         WIAA==
X-Gm-Message-State: AOJu0YyQ0DpwfPbBCPFcqQGw1KwADVI9/1UIKO9QrQ6ZWZxCf/94vUT/
	NgA6A1SJ5+jjmhcgKoRUBdYQBQ==
X-Google-Smtp-Source: AGHT+IF5d1ESnNl3DW6y2+imScFbz4lvkI6XZHXfhsQrAJwxX/tlICwDYWPVmK4nZgJvWNEuauG4+g==
X-Received: by 2002:a17:906:3615:b0:9be:834a:f80b with SMTP id q21-20020a170906361500b009be834af80bmr7614130ejb.75.1699975346999;
        Tue, 14 Nov 2023 07:22:26 -0800 (PST)
Received: from [192.168.69.100] (cac94-h02-176-184-25-155.dsl.sta.abo.bbox.fr. [176.184.25.155])
        by smtp.gmail.com with ESMTPSA id ov3-20020a170906fc0300b00977cad140a8sm5694156ejb.218.2023.11.14.07.22.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Nov 2023 07:22:26 -0800 (PST)
Message-ID: <7fd25b34-6fd9-4f7c-90b4-e44338b2b09e@linaro.org>
Date: Tue, 14 Nov 2023 16:22:23 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-for-9.0 v2 06/19] hw/pci/msi: Restrict xen_is_pirq_msi()
 call to Xen
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, David Woodhouse
 <dwmw@amazon.co.uk>, qemu-devel@nongnu.org
Cc: =?UTF-8?Q?Alex_Benn=C3=A9e?= <alex.bennee@linaro.org>,
 Paul Durrant <paul@xen.org>, qemu-arm@nongnu.org,
 Paolo Bonzini <pbonzini@redhat.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 xen-devel@lists.xenproject.org, qemu-block@nongnu.org,
 Anthony Perard <anthony.perard@citrix.com>, kvm@vger.kernel.org,
 Thomas Huth <thuth@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
 Marcel Apfelbaum <marcel.apfelbaum@gmail.com>
References: <20231114143816.71079-1-philmd@linaro.org>
 <20231114143816.71079-7-philmd@linaro.org>
 <EEC18CA6-88F2-4F18-BDE5-5E9AAE5778A7@infradead.org>
From: =?UTF-8?Q?Philippe_Mathieu-Daud=C3=A9?= <philmd@linaro.org>
In-Reply-To: <EEC18CA6-88F2-4F18-BDE5-5E9AAE5778A7@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 14/11/23 16:13, David Woodhouse wrote:
> On 14 November 2023 09:38:02 GMT-05:00, "Philippe Mathieu-Daudé" <philmd@linaro.org> wrote:
>> Similarly to the restriction in hw/pci/msix.c (see commit
>> e1e4bf2252 "msix: fix msix_vector_masked"), restrict the
>> xen_is_pirq_msi() call in msi_is_masked() to Xen.
>>
>> Signed-off-by: Philippe Mathieu-Daudé <philmd@linaro.org>
> 
> Hm, we do also support the Xen abomination of snooping on MSI table writes to see if they're targeted at a Xen PIRQ, then actually unmasking the MSI from QEMU when the guest binds the corresponding event channel to that PIRQ.
> 
> I think this is going to break in CI as kvm_xen_guest.py does deliberately exercise that use case, doesn't it?

Hmmm I see what you mean.

So you mentioned these checks:

- host Xen accel
- Xen accel emulated to guest via KVM host accel

Maybe we need here:

- guest expected to run Xen

   Being (
                 Xen accel emulated to guest via KVM host accel
	OR
                 host Xen accel
         )

If so, possibly few places incorrectly check 'xen_enabled()'
instead of this 'xen_guest()'.

"Xen on KVM" is a tricky case...

> I deliberately *didn't* switch to testing the Xen PV net device, with a comment that testing MSI and irqchip permutations was far more entertaining. So I hope it should catch this?

¯\_(ツ)_/¯

