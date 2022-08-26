Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CAA5A28DD
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 15:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243071AbiHZNxV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 09:53:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244975AbiHZNxU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 09:53:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB7B3DCFE1
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 06:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661521999;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vqElSHodHe5dMjXui5yc3jNaVfh8G1uXU43vY209xjE=;
        b=Xkpi5c7geWnexft3Zo2HtKjv6z97DjeXosf+DXOtW/XrlEBxI3744Pyz3fN8Ppif0Tpfe9
        G4tSIZo7FhfFAlYUDmKbfv4CusLPYUdRrlRS/aqkjeSBHgVZ59sW9AYy0Z0M6Fbb1OFhbG
        2TrgQj6szZQu2FHRhYvJGnQtUD/wXbY=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-44-0rs9-eKlPoedUnukMM8L3w-1; Fri, 26 Aug 2022 09:53:17 -0400
X-MC-Unique: 0rs9-eKlPoedUnukMM8L3w-1
Received: by mail-qt1-f197.google.com with SMTP id bq11-20020a05622a1c0b00b003434f125b77so1321283qtb.20
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 06:53:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=vqElSHodHe5dMjXui5yc3jNaVfh8G1uXU43vY209xjE=;
        b=BF984OUwpV1/RC0GFRp3VDXt5lgKSK8m0J9AovFGP6cC98Y7MW0AztVDs6gmFlVtAH
         OM5NvRjLwX2PfkzNkCHDRWzQbBaLT2+KwDUlKZoDaxuD9EZ5FgCCATLapTduAyuN9vau
         9VSQEBYTK/yMhfdk6eckj914FnqUWRBoQhl6jWcJLFTAiuzzWggjoeb7ojed9TAHVpx8
         aSRMcrUpL/8N08m//6s/yHrGXb0B/YcNxK8chTPvKj5FIp7xLoM0BVng+MsSoofE4tE5
         fLP7t50k96u+LZF7O0DO/rBNhUUxEthHKxj68jf5MSdawVm1++NRXsj3D75OKMry2XWZ
         DKnA==
X-Gm-Message-State: ACgBeo02z4QlqpvsYtfFvfJuCnw6APw1kP7xQKo8bCpPp86gMCndfmyz
        mctTQx3ZeboN440cSijFzUt2jwqkgdHCBKOkPqq+nV7KhZ8xbR5mv2/u6kIRRCR8P8b7NXEjS59
        lHehRV9dNP6k8
X-Received: by 2002:a05:6214:da6:b0:496:f5f3:de93 with SMTP id h6-20020a0562140da600b00496f5f3de93mr8112630qvh.102.1661521997022;
        Fri, 26 Aug 2022 06:53:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR77zCM0Fzzk4NBjoACaSmk35s2lT3gd6+6vVBZUUQhqRNfMiWWGfo0vptZAB3uoFOgVsxESSg==
X-Received: by 2002:a05:6214:da6:b0:496:f5f3:de93 with SMTP id h6-20020a0562140da600b00496f5f3de93mr8112615qvh.102.1661521996847;
        Fri, 26 Aug 2022 06:53:16 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id w19-20020a05620a445300b006b999c1030bsm1965943qkp.52.2022.08.26.06.53.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 06:53:16 -0700 (PDT)
Message-ID: <68150651-2c28-c173-d737-df4961646cd2@redhat.com>
Date:   Fri, 26 Aug 2022 15:53:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     Cornelia Huck <cohuck@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        David Hildenbrand <david@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com> <874jy4prvl.fsf@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <874jy4prvl.fsf@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



Am 22/08/2022 um 11:08 schrieb Cornelia Huck:
> On Tue, Aug 16 2022, Emanuele Giuseppe Esposito <eesposit@redhat.com> wrote:
> 
>> Instead of sending a single ioctl every time ->region_* or ->log_*
>> callbacks are called, "queue" all memory regions in a list that will
>> be emptied only when committing.
>>
>> This allow the KVM kernel API to be extended and support multiple
>> memslots updates in a single call.
>>
>> Signed-off-by: Emanuele Giuseppe Esposito <eesposit@redhat.com>
>> ---
>>  accel/kvm/kvm-all.c       | 99 ++++++++++++++++++++++++++++-----------
>>  include/sysemu/kvm_int.h  |  6 +++
>>  linux-headers/linux/kvm.h |  9 ++++
> 
> Meta comment: Please split out any linux-headers changes into a [dummy,
> if not yet accepted in the kernel] headers update patch.

Thank you for pointing that out, will do.

Emanuele

> 
>>  3 files changed, 87 insertions(+), 27 deletions(-)
> 

