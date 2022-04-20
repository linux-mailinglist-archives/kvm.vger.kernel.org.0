Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88145508B75
	for <lists+kvm@lfdr.de>; Wed, 20 Apr 2022 17:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiDTPEe (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Apr 2022 11:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379904AbiDTPEc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Apr 2022 11:04:32 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E469440E77;
        Wed, 20 Apr 2022 08:01:42 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id y21so1398584wmi.2;
        Wed, 20 Apr 2022 08:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XsQiKH6TajJPAJHa8yDpCvGZxUo92/efC5z+5+H0ZlA=;
        b=QgKJcishop3aV1xXrheRV4qyylb1AI5grf9+ZvrBgbbHio91mGzOh5Sujl1rBYh5HS
         yPYdO/Rwprg0JLDluwQVIlnxMABdTWOdgiKbnEvQCe6wvGAb7QkRyMrd9c92iPGNZBcc
         ClsZmZQCDrCbjxPIywrrQ3LHxysH8DgN50f9Hvd8ua+hioe42+3WKdeaAh+71xIMRyAZ
         v5MMQMNd1zciCw3y/DgAY/GTBvdO2IOsFVbqb0jri9eOFcmqsmRN77dcBnjLUPhXDmFx
         w3NBnyGr/fqQcCrB2SQFnTD9YULHVm0OLSEWdVaM2QA0fv2RbpJDlVAB5bgfZbKQc+40
         9Kbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XsQiKH6TajJPAJHa8yDpCvGZxUo92/efC5z+5+H0ZlA=;
        b=PXZUsEVzujfnYEc7Eof626x4LJ3J6zDQ26H30SnbGPDuLw4xBoYLHXbBydZ6nE8rEQ
         GhxxXJjd/pZJcQo62xRLY0z/r6Bx0bLkQl+YrDeZcE/aHdLAuxnF8kXmyQPPOIPAtz6e
         YNR2n6VTevuaNCUlHIm2mNB1gfMH+4yrj1qAjUvCN6NxZgRUEN0pLdGh7fwzXEa+DYkW
         3G4Hoq4ODfXWY+QBnaywlT27/UGKWK3P9F8ZAhvtTqCdGBmexTb8jIwFuW3Yp7FAwaRT
         7B7M5lAq2qHvOh6wj/egDYmI5/jWFwk0uek+XO4jKUhSyGnO0rEd1gUbc9XpEGvzWTUb
         FXfg==
X-Gm-Message-State: AOAM532vNHep422WMoFV5mVn7Raq99s2WSt2qcjoFeMH0wy5ppc5waUt
        47lTG0uKuJ4ymyUBAqF+uH+3aRUNBQxdyw==
X-Google-Smtp-Source: ABdhPJxR8PYfXuaXr7lmmOaz11HRXe8ImqDUmbKI+XvfJWLNFr3Gfkjge/cQEqozYmF/1axP319Q2g==
X-Received: by 2002:a05:600c:1987:b0:392:90f9:98df with SMTP id t7-20020a05600c198700b0039290f998dfmr4115302wmq.72.1650466901452;
        Wed, 20 Apr 2022 08:01:41 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.googlemail.com with ESMTPSA id y6-20020a05600015c600b0020a8f950471sm89128wry.115.2022.04.20.08.01.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Apr 2022 08:01:41 -0700 (PDT)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <792073cb-c1ea-2fd0-f05c-3f793a013ce2@redhat.com>
Date:   Wed, 20 Apr 2022 17:01:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 3/8] KVM: SVM: Unwind "speculative" RIP advancement if
 INTn injection "fails"
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>
References: <20220402010903.727604-1-seanjc@google.com>
 <20220402010903.727604-4-seanjc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <20220402010903.727604-4-seanjc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 4/2/22 03:08, Sean Christopherson wrote:
>   		 * but re-execute the instruction instead. Rewind RIP first
>   		 * if we emulated INT3 before.
>   		 */
> -		if (kvm_exception_is_soft(vector)) {
> -			if (vector == BP_VECTOR && int3_injected &&
> -			    kvm_is_linear_rip(vcpu, svm->int3_rip))
> -				kvm_rip_write(vcpu,
> -					      kvm_rip_read(vcpu) - int3_injected);
> +		if (kvm_exception_is_soft(vector))
>   			break;
> -		}

Stale comment.

Paolo
