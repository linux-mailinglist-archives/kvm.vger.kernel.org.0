Return-Path: <kvm+bounces-2970-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id CC2067FF3EC
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 16:49:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5DAE0B21102
	for <lists+kvm@lfdr.de>; Thu, 30 Nov 2023 15:49:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54A53537FF;
	Thu, 30 Nov 2023 15:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LOgMPLvS"
X-Original-To: kvm@vger.kernel.org
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3A46C1;
	Thu, 30 Nov 2023 07:49:13 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-40859dee28cso9262135e9.0;
        Thu, 30 Nov 2023 07:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701359352; x=1701964152; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=G8ImaGSq+yK32uci9kQ8gJDa7ZpsaoeN49Mmc0aXtG4=;
        b=LOgMPLvSO1wo4/NWXGQZLGa4gzMaod1ajDjN+AmhtWIXIKpJHHvBjj8jbSPaB3tOzo
         /y3Ak0CFwbpbbdM5crV7IYCTBGVxAaF5k34D1akQP1svwIrVGbzZd99uJGVa7MXfymg3
         UoNVcI7kVuajnNwMwDMVAsdvKsJDIlNL5CfGtVkC6r4pDXtuJmIZuKkmGN+SJ0ehHXx1
         hm6zpGOF8bCgav8wIDIraFjRBiTR3bhoDmOYKLknmszvYi3TX0x+An+uOjdXtaDKjNB+
         OK8LmHyZ15Ko6GHTPxx0ZXEu+q+/dw+lEjjRw81mXmEa78qAjAwAWb83kJDENfPVsHub
         NfQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701359352; x=1701964152;
        h=content-transfer-encoding:in-reply-to:organization:references:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G8ImaGSq+yK32uci9kQ8gJDa7ZpsaoeN49Mmc0aXtG4=;
        b=XizxQv0PLD9oUNACzbjz/j+Z7dAVcX0CPxiLOWT81vTbeS7fNCiAwbuwbVQg+R0kQJ
         3kb0GFKCfSxU4qZQ+DP/2toX2onBLSMh4AameX243danvUi+gAhokavdBV7rMWdaAmKg
         GCYulJJXyJi9+ylX+jw+S5z6HrIPn5r/u7zckvALcaQzIqbJGtOyClOVnlsZnB/qbryj
         9KcueSJs2uDV5/CWu3y+cOEnHNXNefJh5J6k12BDOXS7fd4SyLJ4AZNWS4JLTpCjYzQK
         C+GHYry7Ux8DrjLTT0kMHcN/E106iaT4FQlK8qUVmXmIGEKxzWvzDBx63zpab4hT0uZe
         uKqw==
X-Gm-Message-State: AOJu0YxxSUBj0wUfj0MfCuhoh1AnHnN+EF1y7CICkdtCC5jP0V5dgvTZ
	myzkNltGlgPH7yje1DmXqScYL+tNni0ucMOF
X-Google-Smtp-Source: AGHT+IEB9DPksNcsSDJF+gYbx+4U10uRUhKK0tMFC5I8x3MPbxcI5/dtvTBLoAnKpdVt/viAq1hJTw==
X-Received: by 2002:adf:f985:0:b0:332:c9be:d9bd with SMTP id f5-20020adff985000000b00332c9bed9bdmr14938111wrr.45.1701359351919;
        Thu, 30 Nov 2023 07:49:11 -0800 (PST)
Received: from [192.168.17.228] (54-240-197-239.amazon.com. [54.240.197.239])
        by smtp.gmail.com with ESMTPSA id d9-20020a056000114900b00332e8dd713fsm1846302wrx.74.2023.11.30.07.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 07:49:11 -0800 (PST)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <b28dc7d2-a83d-4e0e-8a01-524baeb23151@xen.org>
Date: Thu, 30 Nov 2023 15:49:07 +0000
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v5] KVM x86/xen: add an override for
 PVCLOCK_TSC_STABLE_BIT
Content-Language: en-US
To: David Woodhouse <dwmw2@infradead.org>, Paolo Bonzini
 <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, kvm@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 Sean Christopherson <seanjc@google.com>
References: <20231102162128.2353459-1-paul@xen.org>
 <356a88e424a58990a1b83afa719662e75f42bf98.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <356a88e424a58990a1b83afa719662e75f42bf98.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/11/2023 18:39, David Woodhouse wrote:
> On Thu, 2023-11-02 at 16:21 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Unless explicitly told to do so (by passing 'clocksource=tsc' and
>> 'tsc=stable:socket', and then jumping through some hoops concerning
>> potential CPU hotplug) Xen will never use TSC as its clocksource.
>> Hence, by default, a Xen guest will not see PVCLOCK_TSC_STABLE_BIT set
>> in either the primary or secondary pvclock memory areas. This has
>> led to bugs in some guest kernels which only become evident if
>> PVCLOCK_TSC_STABLE_BIT *is* set in the pvclocks. Hence, to support
>> such guests, give the VMM a new Xen HVM config flag to tell KVM to
>> forcibly clear the bit in the Xen pvclocks.
>>
>> Signed-off-by: Paul Durrant <pdurrant@amazon.com>
> 
> Reviewed-by: David Woodhouse <dwmw@amazon.co.uk>

Sean,

   Is any more work needed on this?

   Paul

