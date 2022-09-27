Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F26A35EC237
	for <lists+kvm@lfdr.de>; Tue, 27 Sep 2022 14:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232233AbiI0MPP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Sep 2022 08:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232294AbiI0MPC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Sep 2022 08:15:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC82AC46
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664280897;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rSE3SZr7AU4BSfTZW9EzqUJqNHJZJS1agFSm+3MsOAM=;
        b=gGv9rBASIqKf0hfUNjI3Fy4WclMD7UAVLGnwpDwSM67gA6rG6RqVd06N3mlrrxUkrG3dqY
        OrH99ADbRpd5/r1Eismt+QDazxLnzFvUJHClyYTkHKXj+m8SgXpEc2+WDpXHUA/AsVIPOD
        W0N3q/zomAb9f5KB9udPBs9GjhDrl3g=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-601-Y0a00L55MPypfVB4ZYJ9dA-1; Tue, 27 Sep 2022 08:14:56 -0400
X-MC-Unique: Y0a00L55MPypfVB4ZYJ9dA-1
Received: by mail-ed1-f70.google.com with SMTP id dz21-20020a0564021d5500b0045217702048so7548793edb.5
        for <kvm@vger.kernel.org>; Tue, 27 Sep 2022 05:14:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=rSE3SZr7AU4BSfTZW9EzqUJqNHJZJS1agFSm+3MsOAM=;
        b=XokGRatuo1TeTF7zskdz+b8KsqyjWSfQ05iTjeFSCqmv782C0B4Q5jNH/gvFZVoPLR
         19b2prIXzKr1F+hKNpQhJEaLb2280yZPcirP+XGtGIldRfnDZsbd+yAcxrMjHiWu86AQ
         yBz5NK1aq2DMsxA/MCMg8XcZlD9M4LiVO7uM9nb3TPwK2zsYOYUhGH6nR51KCHDEBjQH
         R98ybnvvpyEbQr0pl0/65DmBayZzZxYTuOjg/rrV+dw0MeaWk0CY2DEhR/rJ3aSSA7IT
         SeO0tR5VYd3msxUQ0+vl1Nn/plQ0yIcTIuIQHnxrLpHIzgX9lE8HpaZjeOsvWf1RlckM
         WI/A==
X-Gm-Message-State: ACrzQf0J50xOI2To/L25XtqLd3CU9Mx7nsmrMZPkPdbkoTevHZCP/T04
        hChTc9g3BVs5qMTwqCPWSJIE9xQVLED17vlC32s5d71pD7SBQ8E3KLT9L5DN2HK3/FKMEEt63i0
        opi+vmCe/XXMr
X-Received: by 2002:aa7:c04f:0:b0:457:1b08:d056 with SMTP id k15-20020aa7c04f000000b004571b08d056mr14655690edo.146.1664280895437;
        Tue, 27 Sep 2022 05:14:55 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5dF2l0zCe+9PMvtpzvSQRGqYKmswR21oDA/D9ukNUOBwPFoxUVmoO0fb4CxB4+uAI8q522lA==
X-Received: by 2002:aa7:c04f:0:b0:457:1b08:d056 with SMTP id k15-20020aa7c04f000000b004571b08d056mr14655669edo.146.1664280895219;
        Tue, 27 Sep 2022 05:14:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id u11-20020a170906780b00b0077a8fa8ba55sm695214ejm.210.2022.09.27.05.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Sep 2022 05:14:54 -0700 (PDT)
Message-ID: <005c8afa-d290-d140-0dac-19a41f2ef81a@redhat.com>
Date:   Tue, 27 Sep 2022 14:14:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] KVM: selftests: replace assertion with warning in
 access_tracking_perf_test
Content-Language: en-US
To:     Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        kvm@vger.kernel.org
Cc:     Shuah Khan <shuah@kernel.org>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Jim Mattson <jmattson@google.com>,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220926082923.299554-1-eesposit@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220926082923.299554-1-eesposit@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 9/26/22 10:29, Emanuele Giuseppe Esposito wrote:
> Page_idle uses {ptep/pmdp}_clear_young_notify which in turn calls
> the mmu notifier callback ->clear_young(), which purposefully
> does not flush the TLB.
> 
> When running the test in a nested guest, point 1. of the test
> doc header is violated, because KVM TLB is unbounded by size
> and since no flush is forced, KVM does not update the sptes
> accessed/idle bits resulting in guest assertion failure.
> 
> More precisely, only the first ACCESS_WRITE in run_test() actually
> makes visible changes, because sptes are created and the accessed
> bit is set to 1 (or idle bit is 0). Then the first mark_memory_idle()
> passes since access bit is still one, and sets all pages as idle
> (or not accessed). When the next write is performed, the update
> is not flushed therefore idle is still 1 and next mark_memory_idle()
> fails.

Queued, thanks.

Paolo

