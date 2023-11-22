Return-Path: <kvm+bounces-2257-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2670C7F4074
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 09:44:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AB2F2B20FD8
	for <lists+kvm@lfdr.de>; Wed, 22 Nov 2023 08:44:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C00F6224EA;
	Wed, 22 Nov 2023 08:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eexoc8pX"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9C5B9;
	Wed, 22 Nov 2023 00:44:06 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-32deb2809daso4303178f8f.3;
        Wed, 22 Nov 2023 00:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700642645; x=1701247445; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=slAcUkpoN5O9hRUVnE7svsPnWaijh/20uVM8xtCNQd0=;
        b=eexoc8pXo/qELT7pI8M7U3YARvolmeq3a+aUOwzhfn1IOO0JibDdyd6SG2iQqwA7Oo
         USw+m23/hq9mxS45a3ya0Qt9aFfCk08b7EDYxCdeDrQzXmIp8D4oTsXBlFTd2GSkqU/9
         jR/eQNTdcgKdXIDU8Ya1s3cqEqx9gH19Y6Zv8+VGGstgWUPjnp9y9C3dxv5JK58e/O4w
         eaEDtaRlTSWc7ct4crU50Feg/qF7gslfi7SQy97hHH61/hh1DHDG0P/rrz/Bq5WKnfZn
         6Hgn4MxHmtTLn0+xA6qzNeuLwznJTYu9kkxWRGDXuFZODrHe+9ClOc2lhtwS3Zl0cXah
         r1ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700642645; x=1701247445;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slAcUkpoN5O9hRUVnE7svsPnWaijh/20uVM8xtCNQd0=;
        b=YpTPJTNe1sq7MrE/OQbmcvJtjzt/ThTBiRTM/reeSguf8YBagT5+Y3smM3WFgqovdD
         9vrejkvhEi8AL39XVvZ+gDs2M/a6Mh3C5LSPqRbeaf1W/yfN7R9F9eQbV7Yl+7bB2wN9
         HrSjEPvLP8zGXCQdAPi6VCFaCgIF9JfNujt7OiWIJO/TDoxn7UQp/XH2SUU5IJJUbcJO
         PfceKQPwC7JbTNZNEZiOE3nNc9/bGQ53Pjm92lly1aF9SG9QgKqzr9TsjSOFDpHX/sZv
         ekFP2owiDvtFVZQttyXoLLKMcPnpLb29Jj3N+il7diCusfYCJd1AqvS7wg5+am06VuJI
         IToA==
X-Gm-Message-State: AOJu0YzsjSTiQG6ckr6TFvC9hyO0S9CqPfXgUpw8w8cCnmQG4uZbuRAm
	pziyk+HQVFGybfDTvY890jk=
X-Google-Smtp-Source: AGHT+IEytRtILQlhSMgpN7zpBPji4Wh/miHxpihiFYPojEQMtgWL6L0nDQViwvjblkH7lob8K9xySw==
X-Received: by 2002:a5d:60c3:0:b0:32d:b8f8:2b18 with SMTP id x3-20020a5d60c3000000b0032db8f82b18mr1003331wrt.32.1700642644978;
        Wed, 22 Nov 2023 00:44:04 -0800 (PST)
Received: from [10.95.134.92] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id bs13-20020a056000070d00b00332d3c78e11sm429224wrb.85.2023.11.22.00.44.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 00:44:04 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <c461e1e6-3378-4e7a-a44d-decaa7cf0e79@xen.org>
Date: Wed, 22 Nov 2023 08:44:03 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v8 02/15] KVM: pfncache: remove unnecessary exports
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>, Paolo Bonzini
 <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20231121180223.12484-1-paul@xen.org>
 <20231121180223.12484-3-paul@xen.org>
 <3cf7281c619bb27d922688c4e7aff7608524fe22.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <3cf7281c619bb27d922688c4e7aff7608524fe22.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 21/11/2023 21:49, David Woodhouse wrote:
> On Tue, 2023-11-21 at 18:02 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> There is need for the existing kvm_gpc_XXX() functions to be exported. Clean
>> up now before additional functions are added in subsequent patches.
>>
> 
> I think you mean "no need".
> 

Oh yes. Will fix.

>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>
> 

Thanks,

   Paul


