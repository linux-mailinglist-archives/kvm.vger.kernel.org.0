Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B05D614D2B
	for <lists+kvm@lfdr.de>; Tue,  1 Nov 2022 15:55:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230274AbiKAOza (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Nov 2022 10:55:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230137AbiKAOz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Nov 2022 10:55:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F652DEF
        for <kvm@vger.kernel.org>; Tue,  1 Nov 2022 07:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667314466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UpfQYVzMIcuMXx56DkvqTXydEG0Wdlj350I7KRytfvw=;
        b=hyqrnk5KOZGGUOP7rDSltT+yMb+hYiL1dY9CyEmhxtaVUqUZNSnkFQus+ClkvCYI+UoN2z
        aZZm4wOwhBbbTKOsD+91JMzt2I6eTb/USCsgOC1Y+KAsVeoRJ5Lay4fYK5Ej9JT8YCKvEa
        TVS7AJ4cxmhKZ7LsD/E6obuSAFcTAiA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-458-JUDpx6-UNhWbCosms0i1Yw-1; Tue, 01 Nov 2022 10:54:25 -0400
X-MC-Unique: JUDpx6-UNhWbCosms0i1Yw-1
Received: by mail-ed1-f71.google.com with SMTP id dz9-20020a0564021d4900b0045d9a3aded4so10249643edb.22
        for <kvm@vger.kernel.org>; Tue, 01 Nov 2022 07:54:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UpfQYVzMIcuMXx56DkvqTXydEG0Wdlj350I7KRytfvw=;
        b=saoHhO0hW3CW1L/BYBFF0Z4AvCvfBjD+9pIr+LBjLKoCzQd4clW4WNfX5lSAB8iAOY
         f+LNPEiWEv4+c6EKnAtPY8DQ+97idUl80qWm9sUDTVCTE6MqZgfK4e+WnmDqMSxOpRu1
         HmtCMsfOwiyaBPCMmI1DXijjzNefojqeSJbY8RuYaRVH4PEfRo5CruVzDFsEkXiIAejL
         1BqUX98ozTsiR3xoD9Zx+i65d9AvI4+i4POml7lEokJKEJv6KB1MnnTRpByfgWNuI4OD
         +cq0TOsK7rIPcVKTqo6NRKgQdwQ+FjEjH70RGXjIwHNHb6Rzj28bEFQ/xclTCy+/2c3c
         zj3g==
X-Gm-Message-State: ACrzQf06ptyD6h78Taa22G1OYtCrb9ihAFYwQnEUlUDFvLFTx9PMKPxe
        MPEYBOevLPylQMPzWjN6Fyj84UpD5/8bYJTYt7lgKyn7KdWvrJF6E8b+o5e/mHp0FW19dQu8qEP
        pHRSoLQxg40u4
X-Received: by 2002:a17:907:8a24:b0:795:bb7d:643b with SMTP id sc36-20020a1709078a2400b00795bb7d643bmr19113935ejc.115.1667314464042;
        Tue, 01 Nov 2022 07:54:24 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM6cO4rk8NeV9RvMCaBS52ImLLAf4ZLqcdpiLZqjgPxz3IJI9NfZXhSLsdW9KGQGq3mQMXBZDg==
X-Received: by 2002:a17:907:8a24:b0:795:bb7d:643b with SMTP id sc36-20020a1709078a2400b00795bb7d643bmr19113910ejc.115.1667314463791;
        Tue, 01 Nov 2022 07:54:23 -0700 (PDT)
Received: from ovpn-194-149.brq.redhat.com (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id m23-20020a170906849700b0079e11b8e891sm4207005ejx.125.2022.11.01.07.54.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Nov 2022 07:54:23 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     kvm@vger.kernel.org, Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Michael Kelley <mikelley@microsoft.com>,
        Siddharth Chandrasekaran <sidcha@amazon.de>,
        Yuan Yao <yuan.yao@linux.intel.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-hyperv@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v12 00/46] KVM: x86: hyper-v: Fine-grained TLB flush +
 L2 TLB flush features
In-Reply-To: <87zgdcs65g.fsf@ovpn-194-149.brq.redhat.com>
References: <20221021153521.1216911-1-vkuznets@redhat.com>
 <Y1m0ef+LdcAW0Bzh@google.com> <Y1m1Jnpw5betG8CG@google.com>
 <87zgdcs65g.fsf@ovpn-194-149.brq.redhat.com>
Date:   Tue, 01 Nov 2022 15:54:21 +0100
Message-ID: <87h6zisp2a.fsf@ovpn-194-149.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Vitaly Kuznetsov <vkuznets@redhat.com> writes:

>
> Paolo,
>
> do you want to follow this path or do you expect the full 'v13' from me? 

v13 it is :-) I've added all the tags and addressed the remaining
feedback (a typo fixed + a comment added).

-- 
Vitaly

