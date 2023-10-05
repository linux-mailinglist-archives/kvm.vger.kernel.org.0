Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 016D97B9DC9
	for <lists+kvm@lfdr.de>; Thu,  5 Oct 2023 15:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjJENzz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 5 Oct 2023 09:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244437AbjJENxv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 5 Oct 2023 09:53:51 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FA0A9006;
        Thu,  5 Oct 2023 01:36:24 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id ffacd0b85a97d-323ef9a8b59so709844f8f.3;
        Thu, 05 Oct 2023 01:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696494982; x=1697099782; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DS8K+XHoGaVgihShBlAXOiMSirNQsWv+QIMA5Sd0iZI=;
        b=FH6tDJ+1ms3dh+fFBwaT/jl6JVu9QfGZj+hjtWwg9K7Dro0nrFv2RVlcc2u4JbWCTQ
         1kLWzGoEntQsJrHUhXpiYfN8pyylihWLoF9YKvBuEyEGEoJcb2u76MfBCuT9Fclc28vu
         DRyAR/GEG+JyTba2fmdj7JezPBteQizSn728KFfBUkrVv/cw1GbjXGPIx2k8k5CePqs8
         vuKm9vB+4vu55UhqLDDamv8Qdl0N/gN1mzhnRunbvUCQYNj3pbGS4+jMG+Sry2iVg7+/
         o9EJLtEaH/MwMLTue1zkuiaBBoG4nLFR4PEjsltQh6sbnhP2A2u4x6WqAmebjlqObdql
         hWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696494982; x=1697099782;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DS8K+XHoGaVgihShBlAXOiMSirNQsWv+QIMA5Sd0iZI=;
        b=DC+WNlVBrqF/dz7IU9vllhTRQ6zFUjwHB+mfflHoOB1FGnwEukl269Cj5Xc/mcW+6G
         3rxv3ZZ1G0OuQESP0Y7XYHJmgFcub3q6wTfFRPV3ghw4qmrFj90ZNPrTxFaGjIQYyYLE
         GJ0EJrBPJPUqi5TPaY9Gg4pX/RBw9C/b7raXMayqRRiFguzJkri5nLWkm4DEKflUay23
         VaF6IV/Sw3Iyo5g9SWyQFScMlgnIIRHOsR9rwcTMiZxFw/LEOTEAdnQVmhrflgx35ifY
         e43BwGKYcvZX98bKMUmemEwnDRnnWtXYq8KOrUab3J1up2X+EgQdC5DzkjNsMCjEx4X9
         shHw==
X-Gm-Message-State: AOJu0YxuI/dmS+d8NLl0cx/C7DRNnpQ1+XHT4UUiCUG4kZVuO5Dm5DaA
        NmINYvyld91roYnnqmZv6gI=
X-Google-Smtp-Source: AGHT+IFoQaJ4Ym0msmNcFG2q+D4PAASwivLOY76MFke0qSXuGvHqzyK3mRM/SardfnS3HNJOBvj3xQ==
X-Received: by 2002:a5d:40c9:0:b0:31f:ef77:67e8 with SMTP id b9-20020a5d40c9000000b0031fef7767e8mr4544874wrq.13.1696494982152;
        Thu, 05 Oct 2023 01:36:22 -0700 (PDT)
Received: from [192.168.196.210] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id n1-20020adffe01000000b0031ae8d86af4sm1212537wrr.103.2023.10.05.01.36.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 01:36:21 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <bf34f990-4f32-4cd3-9dd0-df1cf9187b25@xen.org>
Date:   Thu, 5 Oct 2023 09:36:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v7 00/11] KVM: xen: update shared_info and vcpu_info
 handling
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org
References: <20231002095740.1472907-1-paul@xen.org>
 <6629b7f0b56e0fb2bad575a1d598cce26b1c6432.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <6629b7f0b56e0fb2bad575a1d598cce26b1c6432.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

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
> Are you doing the QEMU patches or am I?
> 

I'll do the QEMU changes, once the patches hit kvm/next.


