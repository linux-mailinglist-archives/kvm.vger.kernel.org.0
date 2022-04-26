Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39443510492
	for <lists+kvm@lfdr.de>; Tue, 26 Apr 2022 18:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353458AbiDZQxl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 26 Apr 2022 12:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353455AbiDZQvf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 26 Apr 2022 12:51:35 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED91A199147
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:47:56 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id i5so7240590wrc.13
        for <kvm@vger.kernel.org>; Tue, 26 Apr 2022 09:47:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qt1xBfAjDwIVH/qIegeysO+xF5Q0Vhhl5yCUW73MsTA=;
        b=iPSdU9gEehCKhkBxHp2xL4tFvgTizzxi1PKvzJBe5HnNrGCh36tsMXgjSokdKFaOrV
         If/MeBrVHMQCyCUJHfnDC25OfBmq1wEPPxWYMlZtBXLhMJc4JnIox3pDRORS8LtTKq2E
         Ajgl5GOr4sVWUJ+KCG0R8VrEu2q0XAzqL0Lxsw9HeDwlL8WtX98YOi58HtzLeFQhtUKT
         CyyQzETYevzIc8wMtP3b9NfhvS+dWETbdmwXtroz1VKPZgrbn/aECzqYLU64TYkyhFGl
         SoEa/9kVqfFHkX2LzD9jV5wlnONiXwspI32odAp1TTZ5qVpNaqay19ULRGsci794LRvf
         O6Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qt1xBfAjDwIVH/qIegeysO+xF5Q0Vhhl5yCUW73MsTA=;
        b=JBYdNEe8cxjRHYbeI/Oh7Lr1BE2n3D9tLt/x7YfpCHY7oFQWAmdKXemKK5rVXQerAC
         GLmfbBQARo+KimcfXOQEcKPoPj+fyijJorH5QuddmUuiLaN1hyFhcGdB7h4rWVNiLAi/
         Ikq/gapaQ8fn6cOSHOx2JaSEMlwv9dfUgqauKjxgpJ5isUq0MfJ1E6E1kakLyhpvkE5V
         zb/qk9HcIF7ZWTwGFow1ZIEEU+JAvptlfHY5u/uVCue4YQj+g1AIen361y30glGlW6XO
         bFryyHxabGjsDcq1TkgS/inueB+4Ll1e3G58qU1i58ify8Zs9o/GL9Msf0sqsMmHEd7U
         evlQ==
X-Gm-Message-State: AOAM532DNxvqVHEdxjJ+FcTd9BPILMkh+FVOuzInnX5VxYJEBxCuRA/O
        ZYPPg9n295x+ZsHo5c+qsacpnBd0flkWZQ==
X-Google-Smtp-Source: ABdhPJxNerl8h48oNdhlPxP0K0QLg7jQc99z32TOeG8UnwyLQJK/4sfq+hMwCibz9iSbWLQuVSN4+A==
X-Received: by 2002:a5d:4dc7:0:b0:20a:ed1a:2c0 with SMTP id f7-20020a5d4dc7000000b0020aed1a02c0mr5619wru.448.1650991675458;
        Tue, 26 Apr 2022 09:47:55 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:1c09:f536:3de6:228c? ([2001:b07:6468:f312:1c09:f536:3de6:228c])
        by smtp.googlemail.com with ESMTPSA id y9-20020a05600015c900b0020adb0e106asm7513262wry.93.2022.04.26.09.47.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 09:47:55 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <7a627c97-0fb1-cb35-8623-7893e228852c@redhat.com>
Date:   Tue, 26 Apr 2022 18:47:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Another nice lockdep print in nested SVM code
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     Sean Christopherson <seanjc@google.com>
References: <8aab89fba5e682a4215dcf974ca5a2c9ae0f6757.camel@redhat.com>
 <17948270d3c3261aa9fc5600072af437e4b85482.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <17948270d3c3261aa9fc5600072af437e4b85482.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/26/22 18:43, Maxim Levitsky wrote:
> Actually for vmrun, that #GP is I think sort of correct now - that is
> what AMD cpus do on 'invalid physical address', but for VM exit, we
> just need to have the vmcb mapped instead of mapping it again -
> injecting #GP at that point which will go to the nested guest is just
> wrong.

Yeah, in that case I can't think of anything better than triple fault.

Paolo
