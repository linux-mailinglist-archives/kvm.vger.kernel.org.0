Return-Path: <kvm+bounces-300-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090A37DE01B
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:06:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B54F7281345
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E1F6111B0;
	Wed,  1 Nov 2023 11:06:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W4o/eeB/"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508611181;
	Wed,  1 Nov 2023 11:06:34 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C9511A;
	Wed,  1 Nov 2023 04:06:33 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-32da4ffd7e5so433482f8f.0;
        Wed, 01 Nov 2023 04:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698836791; x=1699441591; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BVXP6hetv0Lu3iDopEwUmA4SId0aO7rZ36h8eY2NRl8=;
        b=W4o/eeB/EwFxaoanyQtG53kGxBgy5h7goN7fE4gpGMXNYOxSLo3LebwrB/QPBa4laW
         3vHCXle14TJ8iEGMhLNMLXQaTphGbSExR4D35RkIWL5JuHx74oCe0j/g2Kh9r6zmd8oN
         2HRtnXqFQ8yY01zGkAtE7gpq/UIIL5uF4ZgZ5giuHLC9Nj5An8RqQfqrSWqmCP8MbZ0K
         igDZNSPy8DeTdBD48rLSAL6hBUXAEibHvQpgK5lDI1FqbX6tygSoYLmx65j7poQaiAbg
         EXaqnuW7G/lEvX3rOVagPnwj0SVCpJvtcUCEw5Z8aj0XbDXNcuz72IQo2/cot4nZc2Pg
         oxQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698836791; x=1699441591;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BVXP6hetv0Lu3iDopEwUmA4SId0aO7rZ36h8eY2NRl8=;
        b=kinWw2KyU/qg+8E2IwPcDJYrNl7GwC5BuGo+jIRpx0GDbhaw7qq/PHDB5GHC6pXYLc
         erd6RrD0YCU6w07yN0xlNtvQIl1sV8MoPxjnfl3WLp9r9lyumnpty8cXFHG8mUd1fBg1
         Uj7SYQOhjL3rvLf6E1f1ZhMRZpmmHyHYwbXMLe+jjQhczVqdO8J47BDpm8AflF3ffFJk
         oXGlerzQhh2h+OqmfDmh5o7I4A9YpM1w08r6wjSNwipQ2uvKTXjNZJOSz5JCDDZFQTKC
         meGRHu9VvV7ZyotlokDQS4hd8yV5c+IacqRWxJM4Yo1BJeyoYBxXZGVc7+dLdYMpAuUx
         Lk/w==
X-Gm-Message-State: AOJu0Yzw1ZrMLhNJEhNdiwWgHuBdPkvQTbG3ry2ltJgjweWq6c8WEQrA
	xcCEOHgsQefjXyPAbfcXk4o=
X-Google-Smtp-Source: AGHT+IE/ocuDq9qhrrreSATrFqB494n8L808Le/wM26oHjvbnH/fXVLRG8ca4ZYl2uNPYv0tY7Ke/g==
X-Received: by 2002:a5d:6daa:0:b0:32f:8b51:3708 with SMTP id u10-20020a5d6daa000000b0032f8b513708mr2662127wrs.2.1698836791654;
        Wed, 01 Nov 2023 04:06:31 -0700 (PDT)
Received: from [10.95.173.140] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id z13-20020adfec8d000000b0032db1d741a6sm3867888wrn.99.2023.11.01.04.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 04:06:31 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <45bd5778-6217-427e-8ac2-f7b997470476@xen.org>
Date: Wed, 1 Nov 2023 11:06:25 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v2] KVM x86/xen: add an override for
 PVCLOCK_TSC_STABLE_BIT
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>,
 Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231031115748.622578-1-paul@xen.org>
 <ZUGCPQegUeTutsrb@google.com>
 <028f629d16377f9a7e9fd87ef9564846b0ab4ed9.camel@infradead.org>
 <ZUGGqOCU7TAU6c6p@google.com>
 <3c71731a4f3390dc0c660f854e732df793d78bb4.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <3c71731a4f3390dc0c660f854e732df793d78bb4.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/10/2023 23:06, David Woodhouse wrote:
[snip]
>>                  mutex_lock(&kvm->lock);
>>                  if (!kvm->created_vcpus) {
>>                          kvm->arch.force_tsc_unstable = true;
>>                          r = 0;
>>                  }
>>                  mutex_unlock(&kvm->lock);
>>
>> So that it would be blatantly obvious that there's no race with checking a per-VM
>> flag without any lock/RCU protections.
> 
> Makes sense. Although TBH if the VMM wants to flip this bit on and off
> at runtime while the guest clocks are being updated, it deserves what
> it gets. It's not a problem for KVM.
> 

The first version of the patch that used an attribute requested a clock 
update when the attribute was set. I dropped that in this version but I 
think it'd best to re-instate it.

   Paul

