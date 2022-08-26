Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 368DF5A2996
	for <lists+kvm@lfdr.de>; Fri, 26 Aug 2022 16:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344453AbiHZOcn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 26 Aug 2022 10:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344477AbiHZOcZ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 26 Aug 2022 10:32:25 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B34AA3D3D
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661524340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QGZw/B06Xt7uHBwCcLTIzdIO1MiFBujJ32paM0Irz6g=;
        b=JPyvE82syFPmeYuwNGVbWgXCmJb+b5wPgXwSwZ4eP7gAbPbXfdsv9oMYR2wmQbuYZ/WUHf
        zt0SwVjSId5MGU40dcbmveZV/fxPZ+fpp2apLsyHoht1Bw6Zj3s1YAFSjytwuvkN+GOqHU
        E/63xq1p2sVAfvsxwkWgxP9/svbMSMg=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-537-GSoN_ZdrPqaY0WHzqE7vHg-1; Fri, 26 Aug 2022 10:32:18 -0400
X-MC-Unique: GSoN_ZdrPqaY0WHzqE7vHg-1
Received: by mail-qt1-f198.google.com with SMTP id h19-20020ac85493000000b00343408bd8e5so1410449qtq.4
        for <kvm@vger.kernel.org>; Fri, 26 Aug 2022 07:32:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=QGZw/B06Xt7uHBwCcLTIzdIO1MiFBujJ32paM0Irz6g=;
        b=S48Lmq3pN0YYHHOvNSpNMx7solDNP1ANPZmkr4qO0SZCYlibgPRAUPBcbTgHa+4xwi
         VmoLmvRrMrLopha31yaD+PwMkEyp/XkTX4i3QIGgXnHT2oVg/Iy9MMi6ER9JaqSePCCD
         lWOHSXCGZv9sMYA2IporeKI+mFmh+BkKFclTXWxc2gZc5qsL104tFDiDTfCLYhr6OvX+
         AEmpHcO8QnExELAwJ6rmyeAVoF1ADC3ht99MlXQpGS4QB7XNutKPyS/fmHsSZgveU2Z/
         Z53qnLMFJyEeZg+nYh8SxPjsvCYFfrsAoNr2usEsSOnqHIquBCIMYdaLLU30iC20A+xR
         m7sQ==
X-Gm-Message-State: ACgBeo2OoA6FwfdubOMO9SR10XlAE6B0HyDMWpZT35x3fUpaWv0nHc23
        sbrgp9hWy3NLAhUoMoHlsGXCsypFzjw5CThI95CmQxSPmWp32GnlFYta7CAncwbZoFH3p2A9wRA
        QBxwbeWttIh88
X-Received: by 2002:a05:6214:c82:b0:496:d33e:7ac4 with SMTP id r2-20020a0562140c8200b00496d33e7ac4mr8498766qvr.32.1661524338330;
        Fri, 26 Aug 2022 07:32:18 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7oZCzHp9cR+Q31GCLnS19UTQV/Eu8SuRgWfQdKCRpwYzUEUhpOGoY9m6chiMCNKXPz6PLD0Q==
X-Received: by 2002:a05:6214:c82:b0:496:d33e:7ac4 with SMTP id r2-20020a0562140c8200b00496d33e7ac4mr8498739qvr.32.1661524338133;
        Fri, 26 Aug 2022 07:32:18 -0700 (PDT)
Received: from [192.168.149.123] (58.254.164.109.static.wline.lns.sme.cust.swisscom.ch. [109.164.254.58])
        by smtp.gmail.com with ESMTPSA id bq7-20020a05622a1c0700b00344cb66b860sm1265238qtb.38.2022.08.26.07.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 07:32:17 -0700 (PDT)
Message-ID: <c1e0a91e-5c95-8c10-e578-39e41de79f6a@redhat.com>
Date:   Fri, 26 Aug 2022 16:32:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [RFC PATCH 2/2] kvm/kvm-all.c: listener should delay kvm_vm_ioctl
 to the commit phase
Content-Language: en-US
To:     David Hildenbrand <david@redhat.com>, qemu-devel@nongnu.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Cornelia Huck <cohuck@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        =?UTF-8?Q?Philippe_Mathieu-Daud=c3=a9?= <f4bug@amsat.org>,
        Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
References: <20220816101250.1715523-1-eesposit@redhat.com>
 <20220816101250.1715523-3-eesposit@redhat.com>
 <6cb75197-1d9e-babd-349a-3e56b3482620@redhat.com>
From:   Emanuele Giuseppe Esposito <eesposit@redhat.com>
In-Reply-To: <6cb75197-1d9e-babd-349a-3e56b3482620@redhat.com>
Content-Type: text/plain; charset=UTF-8
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



Am 26/08/2022 um 16:15 schrieb David Hildenbrand:
> On 16.08.22 12:12, Emanuele Giuseppe Esposito wrote:
>> Instead of sending a single ioctl every time ->region_* or ->log_*
>> callbacks are called, "queue" all memory regions in a list that will
>> be emptied only when committing.
>>
> 
> Out of interest, how many such regions does the ioctl support? As many
> as KVM theoretically supports? (32k IIRC)
> 

I assume you mean for the new ioctl, but yes that's a good question.

The problem here is that we could have more than a single update per
memory region. So we are not limited anymore to the number of regions,
but the number of operations * number of region.

I was thinking, maybe when pre-processing QEMU could divide a single
transaction into multiple atomic operations (ie operations on the same
memory region)? That way avoid sending a single ioctl with 32k *
#operation elements. Is that what you mean?

Emanuele

