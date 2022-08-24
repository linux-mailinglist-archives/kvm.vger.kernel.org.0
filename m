Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95EBD5A002D
	for <lists+kvm@lfdr.de>; Wed, 24 Aug 2022 19:15:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239984AbiHXRPs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 24 Aug 2022 13:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239996AbiHXRPW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 24 Aug 2022 13:15:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CC124947
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661361317;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tBF9fEWjO0IT8zbDZgL8JYNxrBpzGYLIgItnuEVcD9g=;
        b=N+WiYrh3rOQ7Hm40GeEd29k8qwYl6u+r8qj10Whw3PQModj+8oss3e2BLIZPQHjDdryqaU
        cIsy07l+Y3n9TSXXww3gJLf5pEYge1/a+TdtTaBPc4QlzNIJeplgZ6k+VGj4Z8HwzXqbR8
        jdoE+i8lttQHybD2OOqk/GqIzeARltM=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-613-WA2enw-LOz2sH43fyTK9Ng-1; Wed, 24 Aug 2022 13:15:16 -0400
X-MC-Unique: WA2enw-LOz2sH43fyTK9Ng-1
Received: by mail-wm1-f70.google.com with SMTP id f9-20020a7bcd09000000b003a62725489bso578313wmj.2
        for <kvm@vger.kernel.org>; Wed, 24 Aug 2022 10:15:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tBF9fEWjO0IT8zbDZgL8JYNxrBpzGYLIgItnuEVcD9g=;
        b=jhAIOGCdUrE+UCGm+//O2ejw71fGUYbF//o3lYwvMdjDrNd5skdLBNLuN/TFBIPOap
         Oa4NjjkbUevvVsSsIyy1WxRfpRYnhaFdYP3KPSMX+tQKnUOiIx+egEdDkAwp2sKgpa6W
         rR8gsfY9dmWVeiZ1x5baHjBDUUNKl5igbwXaCvgJCbAvP3LX2CG38MCb3NSJ8haKPDVA
         36BuSPnj0igAi5sB2GLhwRhr8fieVtSStRkvP8c56cTo9TbqteKv/fD/B8qj3a9nouan
         0aklTc5QmfsZjl5SBKelHauncyU9py5LMX/zdN7x/XHqFrtaTl/NjgXcMT2JHP3g3zO+
         beYQ==
X-Gm-Message-State: ACgBeo0/NS8W4CncaZ2/K6y+1Rhfgex7Mi8J55vOSOlnxn/qc5f2l8rH
        4qdLV4WECYFxB8ShqneGwB9CBxirPY2X5NTt25dElJfmc6sBwNdahU9ElbbK861MEMbb1M9sytr
        WtIx5rWy2Vs5V
X-Received: by 2002:adf:e8c7:0:b0:225:2f8e:7e21 with SMTP id k7-20020adfe8c7000000b002252f8e7e21mr109157wrn.83.1661361314888;
        Wed, 24 Aug 2022 10:15:14 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7LB1RIF7N/xxTcPcbnKurEqkOQ2Mr+HSmO0rFZY8OED/K2xUZ8dD3oxxO0KsEWMBEskXLm1Q==
X-Received: by 2002:adf:e8c7:0:b0:225:2f8e:7e21 with SMTP id k7-20020adfe8c7000000b002252f8e7e21mr109147wrn.83.1661361314691;
        Wed, 24 Aug 2022 10:15:14 -0700 (PDT)
Received: from ?IPV6:2001:b07:6468:f312:9af8:e5f5:7516:fa89? ([2001:b07:6468:f312:9af8:e5f5:7516:fa89])
        by smtp.googlemail.com with ESMTPSA id g11-20020a05600c310b00b003a682354f63sm2744337wmo.11.2022.08.24.10.15.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Aug 2022 10:15:14 -0700 (PDT)
Message-ID: <80e1f1d2-2d79-22b7-6665-c00e4fe9cb9c@redhat.com>
Date:   Wed, 24 Aug 2022 19:15:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH 1/2] KVM: x86: Allow userspace to opt out of hypercall
 patching
Content-Language: en-US
To:     Maxim Levitsky <mlevitsk@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Oliver Upton <oupton@google.com>, kvm@vger.kernel.org,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        David Dunn <daviddunn@google.com>,
        Peter Shier <pshier@google.com>
References: <20220316005538.2282772-1-oupton@google.com>
 <20220316005538.2282772-2-oupton@google.com> <Yjyt7tKSDhW66fnR@google.com>
 <2a438f7c-4dea-c674-86c0-9164cbad0813@redhat.com>
 <YjzBB6GzNGrJdRC2@google.com> <Yj5V4adpnh8/B/K0@google.com>
 <YkHwMd37Fo8Zej59@google.com> <YkH+X9c0TBSGKtzj@google.com>
 <48030e75b36b281d4441d7dba729889aa9641125.camel@redhat.com>
 <YwY5AxXHAAxjJEPB@google.com>
 <4c7f4ba7d6f4f796a2e7347113b280373a077d8a.camel@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <4c7f4ba7d6f4f796a2e7347113b280373a077d8a.camel@redhat.com>
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

On 8/24/22 17:06, Maxim Levitsky wrote:
> I wonder how hard it will be to ask Qemu to disable this quirk....

I think we should just do it.  Send a patch. :)

Paolo

