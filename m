Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238AA50990C
	for <lists+kvm@lfdr.de>; Thu, 21 Apr 2022 09:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385716AbiDUH1U (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 21 Apr 2022 03:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiDUH1T (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 21 Apr 2022 03:27:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1CBD61837E
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650525867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ueojm38snUDgcNkd8GnzNsJGz3O6fhwaTuAkVszcmuo=;
        b=NFX49FIfuJj38zcz16yV4P/6aSjoTusGBllY1/OEwfb0RwP6Qy82hMDY4GJt1RhlIRlng4
        HKyWz9W23Agso2rWzeewUhHR6zJsjPew0fyyvGsYNREMpWmbH/ip26keS6BZPR1Lk+mMZh
        LATtvf2rgZq1sEaQV54puq9cg6VSJjs=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-277-KLvRBc_XPGSd0fL4RBf18g-1; Thu, 21 Apr 2022 03:24:25 -0400
X-MC-Unique: KLvRBc_XPGSd0fL4RBf18g-1
Received: by mail-wm1-f70.google.com with SMTP id az19-20020a05600c601300b003914ac8efb8so2055586wmb.2
        for <kvm@vger.kernel.org>; Thu, 21 Apr 2022 00:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=Ueojm38snUDgcNkd8GnzNsJGz3O6fhwaTuAkVszcmuo=;
        b=5jhwSTc1w7loxde+9uT/ISsl2st+r3dmR8o+vcEa9N114a/QNXptQYBSorD+iFpIjC
         NgLgq7I4+HL3DHb4fgQiS/Goc4AD+lgVXoc4wdpp+pMUYp04p8cKvp+ZRZ/dB+xhYct+
         2HkvH2MZjtuxh1TfY7KXnsTBFKMTtox+uzlWDEED/bGJVtQDRDq9cooxzc3XkkbX9kkR
         9GGTr+item9Z2qEkr0PMnfNMTlvUA5aUhCcDISuNT6naGHEhflPtYvgvNw64jnI12JPG
         nPtelvObyr3Unbvel4sO3RW90gEBWCjCWAZIVZJ0TdYvsVsARjAqwa2J235nZIs314uM
         +q+A==
X-Gm-Message-State: AOAM530mXehhO6Q62vve9dJIfT6yf8gVgG7aD8rsayFfab1aclOEofxh
        oQ9kYgk6J0wMfctx4OUEzAiuyfI8Kd6o6SrCcZWxGu/ANaKzpVls6lZBlk1uida/Ri5nfPaNVR+
        V9WLGySD+MAdi
X-Received: by 2002:a05:600c:4f53:b0:392:e99:3002 with SMTP id m19-20020a05600c4f5300b003920e993002mr7271152wmq.35.1650525864749;
        Thu, 21 Apr 2022 00:24:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyT3pnm5Sh+vV0Sy7hhyznn/LgwWMwSX+xjIVufjxa9zkFnFGy5AD9tPDmaVij6DMrjv3pJ9w==
X-Received: by 2002:a05:600c:4f53:b0:392:e99:3002 with SMTP id m19-20020a05600c4f5300b003920e993002mr7271129wmq.35.1650525864513;
        Thu, 21 Apr 2022 00:24:24 -0700 (PDT)
Received: from ?IPV6:2003:cb:c702:de00:711b:76af:b335:9b70? (p200300cbc702de00711b76afb3359b70.dip0.t-ipconnect.de. [2003:cb:c702:de00:711b:76af:b335:9b70])
        by smtp.gmail.com with ESMTPSA id t9-20020adfa2c9000000b002061561d4a7sm1601302wra.96.2022.04.21.00.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Apr 2022 00:24:21 -0700 (PDT)
Message-ID: <f2edeb89-54be-6100-9464-c99fdc4bd439@redhat.com>
Date:   Thu, 21 Apr 2022 09:24:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH 3/4] KVM: s390: replace bitmap_copy with
 bitmap_{from,to}_arr64 where appropriate
Content-Language: en-US
To:     Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Heiko Carstens <hca@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Sven Schnelle <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org,
        kvm@vger.kernel.org
References: <20220420222530.910125-1-yury.norov@gmail.com>
 <20220420222530.910125-4-yury.norov@gmail.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220420222530.910125-4-yury.norov@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 21.04.22 00:25, Yury Norov wrote:
> Copying bitmaps from/to 64-bit arrays with bitmap_copy is not safe
> in general case. Use designated functions instead.
> 

Just so I understand correctly: there is no BUG, it's just cleaner to do
it that way, correct?

IIUC, bitmap_to_arr64() translates to bitmap_copy_clear_tail() on s390x.

As the passed length is always 1024 (KVM_S390_VM_CPU_FEAT_NR_BITS), we
essentially end up with bitmap_copy() again.


Looks cleaner to me

Reviewed-by: David Hildenbrand <david@redhat.com>


-- 
Thanks,

David / dhildenb

