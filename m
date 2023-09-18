Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 437EF7A4960
	for <lists+kvm@lfdr.de>; Mon, 18 Sep 2023 14:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241888AbjIRMPm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 18 Sep 2023 08:15:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241855AbjIRMPK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 18 Sep 2023 08:15:10 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E01C59F;
        Mon, 18 Sep 2023 05:15:04 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-401da71b83cso50218275e9.2;
        Mon, 18 Sep 2023 05:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695039303; x=1695644103; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qsbs7mJLcF8G5slec32Pc/Ep523Xdkco37pA+QpO39g=;
        b=OyHVjNqkA+sg88izKvQA9nmOm3ODh7NRvBTp/SryoJ/6qxRQKA0SUgcOuzY2eZdDk9
         kE3wYhQ01o4qrrKyIfWNJcDImdstmZyzrAEmBbp2fAn3wK1/jrt7iMRUSmww95dKzVMR
         6bBHYK1ogHl16e6TQWNdddLr21+4Dj61iB17Z9Vsy9VZ3fm6KoEve0rrQzzxeSzuHpqK
         NFuHkaomwu0zh/HZHRtC6iayM45v3m0VypnJmZFtyF0ZJTZURbfLptFEliyu3LF8D/gc
         Vb2Wsip1EaS3OJpYTDhklQglyykwDB4RRDhURkBdgZFPxPZWFP6GCgzsQ5a6DUYPEnX2
         ngNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695039303; x=1695644103;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qsbs7mJLcF8G5slec32Pc/Ep523Xdkco37pA+QpO39g=;
        b=Yp9wmpK5pZensp6ci0eZie+mCgEh3P7a8w3GynLBjx+FhRKKG0Av9HUGHVCAeAwGCj
         k9LBoTx756DWN7bWbsK/XIdalKkQptDZZyYmQtMTMLIjCsl4G55pz7QdNpev2dEblvPw
         OzaiqGw1rjGDrehuLiEOeIIg8NBp/KAJB1ALgr7hnmKs7alpXIDj4dJKcp7VbJZDsW0n
         JU6Zp+r6RVsNEwGdE8WKtqwTBrwXlyXO/VP2eTMnCTaRLBRj+9r+bw+kAog9uw3iZVEG
         mfqcsmszrNqdxBQvo/OkfywIC7PxiPltXi7ISFCUNKnalT41kU46BJfyktBHGS82qhkL
         7cuQ==
X-Gm-Message-State: AOJu0Yw+XfS/9QLO2bxpu7qHIZjbA402sNRswM2R69Z7FZd82MzKVJaj
        yA3JjCh+805228B+s/bTB6k=
X-Google-Smtp-Source: AGHT+IEy8LWiiAjWPFCffhc46oCov/4YjV9A3sMzEzO5nVugW86KyKErdH9wI4J/H36pQERKdUMoiw==
X-Received: by 2002:a5d:420c:0:b0:319:7a9f:c63 with SMTP id n12-20020a5d420c000000b003197a9f0c63mr7694181wrq.50.1695039303033;
        Mon, 18 Sep 2023 05:15:03 -0700 (PDT)
Received: from [192.168.7.59] (54-240-197-228.amazon.com. [54.240.197.228])
        by smtp.gmail.com with ESMTPSA id w4-20020a5d6804000000b003197efd1e7bsm12559076wru.114.2023.09.18.05.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 05:15:01 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <35e9aa4c-f1f3-9b98-a7e9-4ce7200b01df@xen.org>
Date:   Mon, 18 Sep 2023 13:15:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH v2 08/12] KVM: xen: automatically use the vcpu_info
 embedded in shared_info
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230918112148.28855-1-paul@xen.org>
 <20230918112148.28855-9-paul@xen.org>
 <51027eb7552cac992f4c856ea2344f7d35c0185d.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <51027eb7552cac992f4c856ea2344f7d35c0185d.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 18/09/2023 12:49, David Woodhouse wrote:
> On Mon, 2023-09-18 at 11:21 +0000, Paul Durrant wrote:
>> -                                              This is because KVM may
>> -  not be aware of the Xen CPU id which is used as the index into the
>> -  vcpu_info[] array, so may know the correct default location.
> 
> Hm, that *was* true at the time of writing, but we did end up teaching
> KVM about the Xen vcpu_id so that we can handle timers. (We required
> userspace to provide the APIC ID for all the other event channel stuff,
> but timer hypercalls come straight from the guest).
> 
> But I think the *only* thing we use vcpu->arch.xen.vcpu_id for right
> now is acceleration of the timer hypercalls that are restricted to the
> vCPU that they're called from, e.g.:
> 
> 	case VCPUOP_set_singleshot_timer:
> 		if (vcpu->arch.xen.vcpu_id != vcpu_id) {
> 			*r = -EINVAL;
> 
> So it's never mattered much before now if the Xen vcpu_id changes at
> runtime.
> 
> Maybe you now want to invalidate the vcpu_info pfncache for a vCPU if
> its Xen vcpu_id changes? Or just *forbid* such a change after the
> shinfo page has been set up? What locking prevents the xen.vcpu_id
> changing in the middle of your new get_vcpu_info_cache() function?

That's a good point; the vcpu lock itself won't be enough. I think 
forbidding a change of id while a shared_info page is in place is 
probably the most sensible semantic.

   Paul

