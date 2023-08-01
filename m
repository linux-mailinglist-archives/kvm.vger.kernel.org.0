Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 338A776A6EE
	for <lists+kvm@lfdr.de>; Tue,  1 Aug 2023 04:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbjHAC0e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Jul 2023 22:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjHAC0d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Jul 2023 22:26:33 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC4410DD;
        Mon, 31 Jul 2023 19:26:32 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id d2e1a72fcca58-686ba97e4feso5102151b3a.0;
        Mon, 31 Jul 2023 19:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690856791; x=1691461591;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cPBkPU6pOihNZ+8qOl23uBpzBus2ZE0LpwP2jVT0H+U=;
        b=DiTjZdx5vxGxyZrmv4KPJAH/UrwxSUsy+ipCod4w3wSFp+DdhG7jtnITlxnQrDFd9R
         uN8LDx/9nou7pHANe66gRAciB+i3n3xtLSaah22XN2Ck9hE8dGidr0upSbl7qbdOLR5y
         8lS2NJMO/nHT97xSbJ0wj3hcqC402licC3XvFottxtNF0KYrWFFaCUZ5qczQ3KJ+Lsmu
         VrXvGlpcuVdGfH+NiNLAcSVKpHA36vcnnWVJHb89HN/9ngPlrdmWm8BnGzi28w99YDRD
         BFSP9BehBOaZmZSmzuo9h5fbTCYpCT7LeEgrOuzGhEkNnehk+tillGy9vrmhb4wEskYw
         ZFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690856791; x=1691461591;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cPBkPU6pOihNZ+8qOl23uBpzBus2ZE0LpwP2jVT0H+U=;
        b=kMJxVwl5c9gly0hM4MM+URx9/oTg7hmHdkSezcWcU9KDoogHzGQC0iXR78o0bbVTBq
         bLtcBTxFki6utVt7LazWKiNboNDaIa9gOwrAy4ybeGLiUdSYwY0UbTD9mbT97IziMmmq
         Ba+6NME0OB3LAbWSabZ8Hgj50Q45ZtrirpX3STl31I+QK18H/lMzjw7iGi4Mi+yrFHPM
         XtR6E4ILwVcqbyc/99U5CkGNVE+N6z4oZNx9jPAjTmAkvsjGaOo70+D+lYWiH1NER+72
         KAevHgaI7xY+/P3I2wx9RB87Sfg8bNjNrb/NLXjw5LIVUQX+6aVWPCveGpHQbtlHogFB
         Jkyg==
X-Gm-Message-State: ABy/qLYfl+lPg2XnYAUxpy9sqHotyEsJTY8z9xUO7NiwpgngPJRcI1vf
        B6IrJkd3gl+B82Bs55Q0GdA=
X-Google-Smtp-Source: APBJJlHsc4sDhFL7ISNWpg43ETHJObEFnNGyB+mXLi30ij9iXjUMm2rq/LKFIp5DpiXsEqRt1BK4FQ==
X-Received: by 2002:a05:6a00:2449:b0:681:415d:ba2c with SMTP id d9-20020a056a00244900b00681415dba2cmr13659016pfj.31.1690856791115;
        Mon, 31 Jul 2023 19:26:31 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id l21-20020a62be15000000b0068743cab196sm1755069pff.186.2023.07.31.19.26.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jul 2023 19:26:30 -0700 (PDT)
Message-ID: <2a542f07-2158-16aa-e3cb-5431081ee1f6@gmail.com>
Date:   Tue, 1 Aug 2023 10:26:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v3] KVM: x86/tsc: Don't sync user changes to TSC with
 KVM-initiated change
To:     Oliver Upton <oliver.upton@linux.dev>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230731080758.29482-1-likexu@tencent.com>
 <ZMf9ovBFpGNEOG3c@linux.dev>
Content-Language: en-US
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <ZMf9ovBFpGNEOG3c@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/8/2023 2:29 am, Oliver Upton wrote:
> On Mon, Jul 31, 2023 at 04:07:58PM +0800, Like Xu wrote:
>> From: Like Xu <likexu@tencent.com>
>>
>> Add kvm->arch.user_changed_tsc to avoid synchronizing user changes to
>> the TSC with the KVM-initiated change in kvm_arch_vcpu_postcreate() by
>> conditioning this mess on userspace having written the TSC at least
>> once already.
>>
>> Here lies UAPI baggage: user-initiated TSC write with a small delta
>> (1 second) of virtual cycle time against real time is interpreted as an
>> attempt to synchronize the CPU. In such a scenario, the vcpu's tsc_offset
>> is not configured as expected, resulting in significant guest service
>> response latency, which is observed in our production environment.
> 
> The changelog reads really weird, because it is taken out of context
> when it isn't a comment over the affected code. Furthermore, 'our
> production environment' is a complete black box to the rest of the
> community, it would be helpful spelling out exactly what the use case
> is.
> 
> Suggested changelog:
> 
>    KVM interprets writes to the TSC with values within 1 second of each
>    other as an attempt to synchronize the TSC for all vCPUs in the VM,
>    and uses a common offset for all vCPUs in a VM. For brevity's sake
>    let's just ignore what happens on systems with an unstable TSC.
> 
>    While this may seem odd, it is imperative for VM save/restore, as VMMs
>    such as QEMU have long resorted to saving the TSCs (by value) from all
>    vCPUs in the VM at approximately the same time. Of course, it is
>    impossible to synchronize all the vCPU ioctls to capture the exact
>    instant in time, hence KVM fudges it a bit on the restore side.
> 
>    This has been useful for the 'typical' VM lifecycle, where in all
>    likelihood the VM goes through save/restore a considerable amount of
>    time after VM creation. Nonetheless, there are some use cases that
>    need to restore a VM snapshot that was created very shortly after boot
>    (<1 second). Unfortunately the TSC sync code makes no distinction
>    between kernel and user-initiated writes, which leads to the target VM
>    synchronizing on the TSC offset from creation instead of the
>    user-intended value.

Great clarification. Thanks, we're on the same page.

> 
>    Avoid synchronizing user-initiated changes to the guest TSC with the
>    KVM initiated change in kvm_arch_vcpu_postcreate() by conditioning the
>    logic on userspace having written the TSC at least once.
> 
> I'll also note that the whole value-based TSC sync scheme is in
> desperate need of testing.
> 
