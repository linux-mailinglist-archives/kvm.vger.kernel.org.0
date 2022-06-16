Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B3F354DECC
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 12:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiFPKVa (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 06:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiFPKV3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 06:21:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 03F235C778
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 03:21:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655374885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1w6kfhI5BLQxYZjNyCbEc+mC0M3DMAszPSrEnT91i7U=;
        b=d/w3TgM+16OVe+qcOmHk/b8PsHk3fUv0idY06/ZQD8+6zOJaXuW1DWiW/vqcAa+EmkhV/0
        xg8NoLRvg9BZ3TxYab9/yugomMrLHxDp6DhQ8tBtbKs4qTng++1o8tC07f+XreZ6IJhD6I
        InNaAEF2RKEONfCN0ofQk+RBvosTj8I=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-422-xT-QHXGoNKeNj_HeZJvwHg-1; Thu, 16 Jun 2022 06:21:24 -0400
X-MC-Unique: xT-QHXGoNKeNj_HeZJvwHg-1
Received: by mail-ed1-f72.google.com with SMTP id s15-20020a056402520f00b004327f126170so963864edd.7
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 03:21:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=1w6kfhI5BLQxYZjNyCbEc+mC0M3DMAszPSrEnT91i7U=;
        b=5g1sRvj5Rn1i9VdeB3z3lP6f7mSH1SxXUCfoPav8Qa5TqIRAakVuRSP4ZYC/hEqN3G
         gdSED6WtKZhKBjk3Yh+4sPne0QwrTO4Vbw08bdc+gv+ugxRTIJ4f/YiF3xaMc4EamE6L
         8KwfIn+dNHoGhbjt+Y4FdYyN8jjI9gaU023QesYcv9fi9iZxvrtj9VCl6gw+/Md26fON
         PB5ny/nGug9a56p9birpeFJhwHY+jRE7vFz9UeGohwIXKvxTOk8GAUVNUnBoRf9vGe+9
         ExdE5N5/TvxDIvbZjj9Prk0SUJfuri35oSjDJ98hTXh7tIRcC3radtQNBExMj0orkyYq
         tLKA==
X-Gm-Message-State: AJIora/O74eouRux7Z1vjpcPrbR9lP/Ez/RBR40pOWScLGj+MEwr8k5c
        LNcK35Am0o8e/cMfg5pqFdXpWGDbl/kFUyHu1qLMpWxm58ecvVvjEuI6EBj+KrcSVOcemwns1r6
        ys+4wkkfcC3ZH
X-Received: by 2002:a17:906:3793:b0:702:eea9:843a with SMTP id n19-20020a170906379300b00702eea9843amr3748378ejc.465.1655374883396;
        Thu, 16 Jun 2022 03:21:23 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tgCWmsWMJUg/6tveJy1I3YO0SejWe+BvTvhEDY4zt/3QRTQGEueFH0aeakfSd9pTKp03hBGw==
X-Received: by 2002:a17:906:3793:b0:702:eea9:843a with SMTP id n19-20020a170906379300b00702eea9843amr3748363ejc.465.1655374883212;
        Thu, 16 Jun 2022 03:21:23 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id 9-20020a170906310900b006fe8b456672sm620540ejx.3.2022.06.16.03.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 03:21:22 -0700 (PDT)
Message-ID: <62d4f7f0-e7b2-83ad-a2c7-a90153129da2@redhat.com>
Date:   Thu, 16 Jun 2022 12:21:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Peter Zijlstra <peterz@infradead.org>,
        Yang Weijiang <weijiang.yang@intel.com>
Cc:     seanjc@google.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rick.p.edgecombe@intel.com
References: <20220616084643.19564-1-weijiang.yang@intel.com>
 <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 00/19] Refresh queued CET virtualization series
In-Reply-To: <YqsB9upUystxvl+d@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 6/16/22 12:12, Peter Zijlstra wrote:
> Do I understand this right in that a host without X86_KERNEL_IBT cannot
> run a guest with X86_KERNEL_IBT on? That seems unfortunate, since that
> was exactly what I did while developing the X86_KERNEL_IBT patches.
> 
> I'm thinking that if the hardware supports it, KVM should expose it,
> irrespective of the host kernel using it.

For IBT in particular, I think all processor state is only loaded and 
stored at vmentry/vmexit (does not need XSAVES), so it should be feasible.

Paolo

