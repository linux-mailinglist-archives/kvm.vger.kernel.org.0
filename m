Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B51724B2BC4
	for <lists+kvm@lfdr.de>; Fri, 11 Feb 2022 18:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352129AbiBKR31 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 11 Feb 2022 12:29:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345763AbiBKR3Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 11 Feb 2022 12:29:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B3D612C6
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:29:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644600562;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fJwoEUodOxqJxI6JQu9HVJf3q8mKU8ZP5xXQX7JvN34=;
        b=KERomP3JuBY93UD9qPoExJf5iDzt9bBCoiGxPywHpDOgZVgrpKKW+y0svxICAQ72UJw9Uv
        9O4WZghIVQKtjf24N0n2VpncaCkxQ1SKmAz9+WzDK13HtkTqsuoypY2Qrd9jmnHDVmZnX9
        wMs8rKUWgG4EsYoVfRj9RISN8EDV7mo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-657-UzMi_dAbMxmc79K8Ap5ixQ-1; Fri, 11 Feb 2022 12:29:21 -0500
X-MC-Unique: UzMi_dAbMxmc79K8Ap5ixQ-1
Received: by mail-wm1-f69.google.com with SMTP id f7-20020a1cc907000000b0034b63f314ccso2793658wmb.6
        for <kvm@vger.kernel.org>; Fri, 11 Feb 2022 09:29:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fJwoEUodOxqJxI6JQu9HVJf3q8mKU8ZP5xXQX7JvN34=;
        b=K7kLUwM4lKRMdCGESnZr5HLBjrJ+oPOkeEOCYMsJyNQz95ActDSdRRbpjF0U4lKHU0
         SmLTmxYoOXoDPhx2iGWFce9YA9dRsPhPvnMMTQ+/nLPgw0tjwNuWGKv9z2WcR1528L9E
         gCghWto7rGroZkB/3bq+5dt2W+cHQWpGAMFrKy/pdAjK5UNM/0KR4I1H7PycKFXtslIX
         HuC4YFE9dUTKBd9oyMx7/f1cYXlXPD5AvgGkwjaZyJ+cTIUGX1aPYzBQJp3FlsPnHs16
         Esfb0pNT6q5eWmkt644Lp31yAAsTH+orELo8+CVMzuOltjfLjtTwz5ziZ720C3ucAc5P
         HC7Q==
X-Gm-Message-State: AOAM530YWKMAo94XStLZuxy29N+LOua+tYqQOljCbokiUPx6Gii3m9/7
        vA9j5+KAKCDAV7ckhLp1mxf1+drkznWpUqMW5pAt7Bg1Lg1itMJK7LMHX8AAbZNysH1BaF7mEAg
        f4igRjWrG+63z
X-Received: by 2002:adf:f9ca:: with SMTP id w10mr2228490wrr.190.1644600560229;
        Fri, 11 Feb 2022 09:29:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJw7p0FZpxIDDsgFffzaBDj6oFCNLkazIuT0L/L4KWvjnftItejXB/GIXaQlFVoH1z3tOSTE4g==
X-Received: by 2002:adf:f9ca:: with SMTP id w10mr2228479wrr.190.1644600560059;
        Fri, 11 Feb 2022 09:29:20 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:63a7:c72e:ea0e:6045? ([2001:b07:6468:f312:63a7:c72e:ea0e:6045])
        by smtp.googlemail.com with ESMTPSA id j30sm1936734wms.2.2022.02.11.09.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Feb 2022 09:29:19 -0800 (PST)
Message-ID: <3f8e8e3d-8bd7-dfd4-f4a0-63520d817c10@redhat.com>
Date:   Fri, 11 Feb 2022 18:28:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 3/3] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
Content-Language: en-US
To:     Sean Christopherson <seanjc@google.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com
References: <20220211110117.2764381-1-pbonzini@redhat.com>
 <20220211110117.2764381-4-pbonzini@redhat.com> <YgaYyJGN0v07vfzc@google.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <YgaYyJGN0v07vfzc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 2/11/22 18:11, Sean Christopherson wrote:
>> +		/* Process the interrupt with a vmexit.  */
>
> Double spaces at the end.  But I would prefer we omit the comment entirely,
> there is no guarantee the vCPU is in the guest or even running.

Sure, or perhaps "process the interrupt in inject_pending_event".

Regarding the two spaces, it used to a pretty strict rule in the US with 
typewriters.  It helps readability of monospaced fonts 
(https://www.cultofpedagogy.com/two-spaces-after-period/), and code is 
mostly monospaced...  But well, the title of the article says it all.

Paolo

