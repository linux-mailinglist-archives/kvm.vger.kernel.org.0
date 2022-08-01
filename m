Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332C2586B51
	for <lists+kvm@lfdr.de>; Mon,  1 Aug 2022 14:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiHAMuZ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 1 Aug 2022 08:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234539AbiHAMuG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 1 Aug 2022 08:50:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9C9762620
        for <kvm@vger.kernel.org>; Mon,  1 Aug 2022 05:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1659357815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WS+3ThxPSCx9TTKskcZREuLQziOp6sjXVWQAmlUDQSk=;
        b=Jt2NONQt6VY0n8NAjfzRrH6RwbDoOfjaqMvU7fGG51e6HpgSVtmuRrihyDfp7FRk5G+Ayf
        jkdMxQqV/nqRutJnzvYHtLeMsb8EbMJkfYRXIOpgYNmCRZEdAJYYtwYByoLHTjZi0hn1YH
        JvhsjL0+1kHftFPx2JCldv6foovfKtw=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-616-lBnU1-TNMIOzhYzdL5FIJg-1; Mon, 01 Aug 2022 08:43:34 -0400
X-MC-Unique: lBnU1-TNMIOzhYzdL5FIJg-1
Received: by mail-ed1-f71.google.com with SMTP id s17-20020a056402521100b0043ade613038so7121761edd.17
        for <kvm@vger.kernel.org>; Mon, 01 Aug 2022 05:43:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=WS+3ThxPSCx9TTKskcZREuLQziOp6sjXVWQAmlUDQSk=;
        b=1qmTDKUTKoofirMAJIuwWGop5fBreAP+xCGuqoTrUGZbl5XaOOE5UKkElF15OZ8BAa
         bCOWaNs3wUcDmgVLwF7QS9rWzMemrv4PVAtFLtncNP2KDg/VmQgu2yS6ArUtF7OQHrJb
         Ygj3qqt69X59/o2M+h6Ui0cyo+e1tI0jIluLi4apkEyY8nvLBjJzwEjoHaXwhvaCRAOc
         8Pr6KafTMAT8aKsMpg8lIhyjXxkuXBUgrEYvV34eNPI749hqGvhxl2UWUW9nNlj+oIFc
         5umwGXrDm2OPTOUQRe+NHxSfw9nMQOEoUU+wgBpbglph3kgisAZbxikLIG7L8qY6YQji
         +y2A==
X-Gm-Message-State: AJIora/PXibRYyYfU6c082oVUMXS2z8GHDnJnvEVHeIjfpFkHrMp4Qa9
        dUEjPd/f6L3w28rpgrcc2I6fM8nE8RMqIiF0k30y9X9+Z14JNauz+jkvROif51PFIlhIdRwRsIv
        HikWTbnUdgi1b
X-Received: by 2002:a05:6402:430a:b0:43b:ea0d:dc59 with SMTP id m10-20020a056402430a00b0043bea0ddc59mr15559105edc.387.1659357812822;
        Mon, 01 Aug 2022 05:43:32 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vOjWj0y3iMX53pyz5V46T+O5+5Aq6q+J+CKRYTdzRlJRudv67mcAECsSA+HsYERrnBrII1gA==
X-Received: by 2002:a05:6402:430a:b0:43b:ea0d:dc59 with SMTP id m10-20020a056402430a00b0043bea0ddc59mr15559087edc.387.1659357812628;
        Mon, 01 Aug 2022 05:43:32 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id d27-20020a056402517b00b0043577da51f1sm6740601ede.81.2022.08.01.05.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Aug 2022 05:43:31 -0700 (PDT)
Message-ID: <54fbb1e1-c9b1-db59-6388-1aab74eb5b11@redhat.com>
Date:   Mon, 1 Aug 2022 14:43:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 4/5] selftests/kvm/x86_64: set rax before vmcall
Content-Language: en-US
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Andrei Vagin <avagin@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <seanjc@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jianfeng Tan <henry.tjf@antfin.com>,
        Adin Scannell <ascannell@google.com>,
        Konstantin Bogomolov <bogomolov@google.com>,
        Etienne Perot <eperot@google.com>
References: <20220722230241.1944655-1-avagin@google.com>
 <20220722230241.1944655-5-avagin@google.com> <87y1w819o7.fsf@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87y1w819o7.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 8/1/22 13:32, Vitaly Kuznetsov wrote:
> Fixes: ac4a4d6de22e ("selftests: kvm: test enforcement of paravirtual cpuid features")

Queued, thanks.

Paolo

