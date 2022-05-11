Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29065234BF
	for <lists+kvm@lfdr.de>; Wed, 11 May 2022 15:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244217AbiEKNyI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 11 May 2022 09:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiEKNyG (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 11 May 2022 09:54:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A591D2DD56
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652277244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=yiBquU9ycutIGVQ+Lafkd382/sLMfLYmiUneQuM6tdo=;
        b=MsY/08AfYeTOwfl6pJDuqCtHt2Tc3+5uum50FeUlkl7IhsDC/CM+GBT+Nlqylsev0t2ox5
        ZBIU41rZUqHiIFX/WBsP+uQY86apNDp+Gy/G7xnT0bCemmV9a8+Aj3b60NOyLH3CYyEY4v
        RzZk1bkExJygjMaPW7Cy3H68JNF+qCw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-OpFVzL0cPDKaU-FYc3vjCg-1; Wed, 11 May 2022 09:54:03 -0400
X-MC-Unique: OpFVzL0cPDKaU-FYc3vjCg-1
Received: by mail-ed1-f69.google.com with SMTP id ec44-20020a0564020d6c00b00425b136662eso1376890edb.12
        for <kvm@vger.kernel.org>; Wed, 11 May 2022 06:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yiBquU9ycutIGVQ+Lafkd382/sLMfLYmiUneQuM6tdo=;
        b=jnTlczy98Ej+Lknwz6OAuRgPc1iF8eIqKFUWRmnhtDHGb0v8cYDEvELI1kj+KoHeTx
         hcl8Pg3SJUIN2VMl11CoyLicjdAp8hUrrnvdDhdDenzWlrustEhY56b4uj/djpXldGbi
         Qy5/qO/G0YghOmd8HKWysTvS8999EmlPe5uGmHfvGU/dHNligktcxz90/LGhfKrRcUhu
         MTfUubbGV577pmpg7D25JDYWNBJNrlBWZYBXgd0H+NHFdBZFBMWIU4F6BQgZNHkuaby+
         7cVxF1En2aHm5cIZk4+aNlcf80RMNRax3CNBYfYLep7XlHs9zvDlw/Wrq6g9pHRMFljn
         0aog==
X-Gm-Message-State: AOAM532fasmbJZECDSaKvyULS62BdUjQpbk6EzoyQimYo/8eUDOwFkY4
        8nlJQrJsTiN7Pd+5MpqHlxajMRvOcf+qYjIuUN+dCH0PdNkiuMozWLlYwhqqgVcRVSXlfwTq3AU
        LUPnryBe6flix
X-Received: by 2002:a05:6402:2078:b0:428:1071:d9b2 with SMTP id bd24-20020a056402207800b004281071d9b2mr29798746edb.302.1652277242271;
        Wed, 11 May 2022 06:54:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyFNGrXEYB8j4ZnML/DgDYxNGSibD3TzmU9JnkCNgK/+z8cTd0gXxgIxWKyb7My6aTgwuk7Gw==
X-Received: by 2002:a05:6402:2078:b0:428:1071:d9b2 with SMTP id bd24-20020a056402207800b004281071d9b2mr29798734edb.302.1652277242095;
        Wed, 11 May 2022 06:54:02 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id b22-20020a170906491600b006f3ef214e2esm1034769ejq.148.2022.05.11.06.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 06:54:01 -0700 (PDT)
Message-ID: <7d9d5f72-21ed-070e-c063-1cd7ae6671ec@redhat.com>
Date:   Wed, 11 May 2022 15:53:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v2 1/2] KVM: LAPIC: Disarm LAPIC timer includes pending
 timer around TSC deadline switch
Content-Language: en-US
To:     Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>
References: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <1652236710-36524-1-git-send-email-wanpengli@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 5/11/22 04:38, Wanpeng Li wrote:
> 
> Fixes: 4427593258 (KVM: x86: thoroughly disarm LAPIC timer around TSC deadline switch)
> Signed-off-by: Wanpeng Li<wanpengli@tencent.com>
> ---

Please write a testcase for this.

Paolo

