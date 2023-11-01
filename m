Return-Path: <kvm+bounces-297-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC267DE005
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 12:02:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F3927B211BE
	for <lists+kvm@lfdr.de>; Wed,  1 Nov 2023 11:02:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E94910A09;
	Wed,  1 Nov 2023 11:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DBJCW2Ns"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AE410954;
	Wed,  1 Nov 2023 11:02:25 +0000 (UTC)
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65AEFFC;
	Wed,  1 Nov 2023 04:02:24 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-32f8441dfb5so2259928f8f.0;
        Wed, 01 Nov 2023 04:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698836543; x=1699441343; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lLGQwWjL2Aw3sFfyWPVTh2LkEYh2Jo+b78gHIPc7ugc=;
        b=DBJCW2NsUaqE0lQjq3liJexnkoVaIj4KK0h4KXmguzQSy8anfcloF93TuCrsuT9IPt
         Fhkg950aQykwX6PBRgzXw5hXphmNo2u1xdGuJ7uxYBvnGHFriLYM5IL+gWdIQOeDcUuz
         fqcJTO/ilUd6HvlZQfC6LGJp3xtQZURa2mxQbkcpSRzZ9bZd2A50J2yCwJdXal3EmAbg
         aTk0oh15xTILtIEY3rE4lYLes13o+BOAqyG0oxvXMQ9rYNpmS7Dn5lXZuavuUPrC1QB4
         jHKnMP8QW6ndB3y5qT+uLGtPmf4C5piIgb5kdSc3g/jhD84nApD4lgz9iLPt/K8T8/rO
         VnFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698836543; x=1699441343;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLGQwWjL2Aw3sFfyWPVTh2LkEYh2Jo+b78gHIPc7ugc=;
        b=EdJsOsS/59cJ7Yq+tqMyoVrDdDaODkkTouhNSPCWznd5h98xqrxCR5ZAtU2ScXq4uZ
         J18YE9hY1osvZ9PF1EYOfTTnYgDOuFWOWq9/agv0LFdz91jA0v2WGybMkKsjGGTViugm
         NMdVmwI5i3kgC3n5EVkpuv2MHm6pprnUonkJZKx+xY+eNYoFLBsxY86E/fW2roKDeBuc
         eoMRgwiIvotuhlMTwRheo/JqWaYknpuNI64Iw5qBqzU3qbKH0exOxhiBHkaRcQ3bcgDv
         UcQJeFSirK3SKYbgaEp3Eeq61SadTSbPMtM164t+qfWF4Xi6vhn7EpDjqijq9k4lvuwz
         qm4w==
X-Gm-Message-State: AOJu0YxLtZewPrG1I+aFFERCPxPBq21bNYM4wYue7DrxG+NyJ+DBF830
	v+xjf6Jveba8telt/BFQNBdBo38i9HZ3fA==
X-Google-Smtp-Source: AGHT+IGhSCFjWDlSAeyzhKo7ObrQNOoHY2TZnOfL4+qkuskUlpbXSKzRJk8C/Me6qA29voKfgh8GNg==
X-Received: by 2002:adf:eb47:0:b0:32c:837e:ef0 with SMTP id u7-20020adfeb47000000b0032c837e0ef0mr11190912wrn.50.1698836542620;
        Wed, 01 Nov 2023 04:02:22 -0700 (PDT)
Received: from [10.95.173.140] (54-240-197-235.amazon.com. [54.240.197.235])
        by smtp.gmail.com with ESMTPSA id g8-20020a056000118800b0032f933556b8sm3897074wrx.7.2023.11.01.04.02.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Nov 2023 04:02:22 -0700 (PDT)
From: Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <f850458d-c1a3-4851-921e-e04404e827b9@xen.org>
Date: Wed, 1 Nov 2023 11:02:16 +0000
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
Organization: Xen Project
In-Reply-To: <028f629d16377f9a7e9fd87ef9564846b0ab4ed9.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 31/10/2023 22:48, David Woodhouse wrote:
> On Tue, 2023-10-31 at 15:39 -0700, Sean Christopherson wrote:
>> On Tue, Oct 31, 2023, Paul Durrant wrote:
>>>
>>> +       if (force_tsc_unstable)
>>> +               guest_hv_clock->flags &= ~PVCLOCK_TSC_STABLE_BIT;
>>
>> I don't see how this works.  This clears the bit in the guest copy, then clobbers
>> all of guest_hv_clock with a memcpy().
> 
> Agreed, that seems wrong.
> 

It is indeed. Looks like it got moved the wrong side of the memcpy() 
when I rebased.

   Paul

