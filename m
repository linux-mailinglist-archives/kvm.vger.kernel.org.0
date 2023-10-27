Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9D47D9546
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 12:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjJ0Kck (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 06:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231386AbjJ0Kcj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 06:32:39 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26AC18A
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 03:32:36 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id 5b1f17b1804b1-40838915cecso15259515e9.2
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 03:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698402755; x=1699007555; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EnKvJtLdMM1klAtGShdO3PmXCUUiIZMF8/1aPxmDPfI=;
        b=ePMPi0WrW7J3tfjLtyhQZIBhP6TWfzZn0BSsGdc3QqshQT2ju4UHSzZYGeuHaaw9H8
         e69We4ws9yGj5IOeWj3uBXOrlv+GsVcv45Yuhjx3D5wKiBRvsezJmJE3kcUDawT8umBN
         jeAlxxMBIFhau+lL+Fxt6iHtOfROK5Uykvl8Aap40ToJAY3zJofsA3qAlhuafto1uzJ+
         FRnpuH2zZWOlwWLQIVXcb5Y3qIjXPHe9T+mZRyzztRjLm6FWSbYi+RrwtAhZalAf22CG
         pJbwjJPhjqkAVeEB71rl91mLx4ZorAgvABD+vCfiPFx4dcdWjJlMRJPvk34dpwPVloYi
         qNKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698402755; x=1699007555;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EnKvJtLdMM1klAtGShdO3PmXCUUiIZMF8/1aPxmDPfI=;
        b=AofWEDvkQwIFFgDGpaTFL2LVHPwdfGiUHlax0Gq81w23mBFtP5/CMC8uNyTx8d1JPI
         YzVWiybLMNVL2Hzwl8PEY3fAzYT2PPJl10pM9rrDg4ZMQ+MroK9w4upCj6u733eqgUx+
         PGwLyiQ1yk9vPLhbqMatITEWOBa1AXSoNU3Jx05OYV8pXgJ62wuL85s3iabZJTW0xITf
         Jxj4F5qxc70PIAYXDcC0SmfTwxQav3WMzoc9riLZYNgSiVD7fZAPg9SEOTaBvm/18Z+u
         tfquX0ICeyos1CS2/wVCu4VaPsUjXIMScgPG+uIcJKwob+++8FIeUZB4VRpGh9OvH7uF
         omKA==
X-Gm-Message-State: AOJu0YySFCzF6yqKVcMmVFtoe6cJuyxWP2hzOXbPyWgj5nbEFGZqWoKY
        o/9zpPnR4nI6zEzc//q9Cb0=
X-Google-Smtp-Source: AGHT+IGWDabcILZvppndibIT+VlcAXisSRXRTOoY9Ub291eXsQSLS1cJV/CaQEshHMvzRuA7gSjyGg==
X-Received: by 2002:a05:600c:1f94:b0:406:7232:1431 with SMTP id je20-20020a05600c1f9400b0040672321431mr2033254wmb.33.1698402754916;
        Fri, 27 Oct 2023 03:32:34 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id o14-20020a05600c4fce00b0040775501256sm1300940wmq.16.2023.10.27.03.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 03:32:34 -0700 (PDT)
Message-ID: <c538ea45-dac7-49f3-ad50-8c3a59755dee@gmail.com>
Date:   Fri, 27 Oct 2023 11:32:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: paul@xen.org
Subject: Re: [PATCH v3 13/28] hw/xen: automatically assign device index to
 block devices
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, paul@xen.org,
        qemu-devel@nongnu.org
Cc:     Kevin Wolf <kwolf@redhat.com>, Hanna Reitz <hreitz@redhat.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Anthony Perard <anthony.perard@citrix.com>,
        =?UTF-8?Q?Marc-Andr=C3=A9_Lureau?= <marcandre.lureau@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        Eduardo Habkost <eduardo@habkost.net>,
        Jason Wang <jasowang@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, qemu-block@nongnu.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Bernhard Beschow <shentey@gmail.com>,
        Joel Upham <jupham125@gmail.com>
References: <20231025145042.627381-1-dwmw2@infradead.org>
 <20231025145042.627381-14-dwmw2@infradead.org>
 <74e54da5-9c35-485d-a13c-efac3f81dec2@gmail.com>
 <f72e2e7feed3ecf17af8ab8442c359eea329ef17.camel@infradead.org>
 <9fb67e52-f262-4cf4-91c2-a42411ba21c4@gmail.com>
 <b6458e730fd861243f534e33a48a857122e77ed5.camel@infradead.org>
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <b6458e730fd861243f534e33a48a857122e77ed5.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/2023 11:25, David Woodhouse wrote:
> On Fri, 2023-10-27 at 10:01 +0100, Durrant, Paul wrote:
>>
>> This code is allocating a name automatically so I think the onus is on
>> it not create a needless clash which is likely to have unpredictable
>> results depending on what the guest is. Just avoid any aliasing in the
>> first place and things will be fine.
> 
> 
> Yeah, fair enough. In which case I'll probably switch to using
> xs_directory() and then processing those results to find a free slot,
> instead of going out to XenStore for every existence check.
> 
> This isn't exactly fast path and I'm prepared to tolerate a little bit
> of O(n²), but only within reason :)

Yes, doing an xs_directory() and then using the code 
xen_block_get_vdev() to populate a list of existent disks will be neater.

