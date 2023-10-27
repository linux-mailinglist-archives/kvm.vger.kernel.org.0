Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 230887D92F2
	for <lists+kvm@lfdr.de>; Fri, 27 Oct 2023 11:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345544AbjJ0JBO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Oct 2023 05:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231340AbjJ0JBM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Oct 2023 05:01:12 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1510318F
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:01:10 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id 5b1f17b1804b1-40891d38e3fso13770775e9.1
        for <kvm@vger.kernel.org>; Fri, 27 Oct 2023 02:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698397268; x=1699002068; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kudjWF6BKXHcvZTM1tPFPJmSWancLrtDgA6AoiUkJqM=;
        b=QhRhIYF8IDD5TWi7BR71iPulYRkeT56s4kg4KlqKHeSqm5k1JmD7XLlillcxRqq4xz
         wO6cenbEonIkxNhVbck2hOiSHbKVH6L97yfIr02Jx3uMM4zXkTFyx50z0z88sWWb0iLo
         iFuhz747wjXaJ9pFgxQ9isuuOaCzzYzqu13oXxUy1vTXYjQXUXBA9XCnCYQAcxfhXyQN
         6b8Z+G/QLMs/7bVNjhjpqYtv3ycpVknJ8MxiolM4NYGYMRcF4fzyu/p1rEKrJXstNih7
         elAPMIO3nv9RDR3Z+w8idcbu0T04qN1PettD3CMtqbak89A3qs5VVqCc1G258+WpBX4I
         cxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698397268; x=1699002068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kudjWF6BKXHcvZTM1tPFPJmSWancLrtDgA6AoiUkJqM=;
        b=WxWWVd3e/1wuTBhRgcfa67KNP9EBvVOMaOFZQ8tkc62YMs1ntW+sez/b4XrpZOHA+P
         gV61Pq2go3cl+7nxhXyDy2lZSFPjq2dv04mFE42XDTJLeDW65z4L1hknTHzIQHuIaJUb
         iYfjj2d1OrUmWTTsJlsKvbwnIV1XYMwakWjvOJq9ep50aNYNFI0sdrPT0da5bDvagAZu
         CGBAK2ygPt+5NbYolQduYQBTWBWlmMspcbTxOmKLBTHYClA88opAZcYvXR3Rl5hspwhE
         RJeqf65JTDotcxtM7g6zL9biCG2mgW9ob6ha1UEnhBlRvYImJpRnxttndEeLZ06EUVAp
         hNNA==
X-Gm-Message-State: AOJu0YzWQTdRePchkLBGsZz9fX029VXBwdOwNsxNKbaBK4C0w5aqasfs
        XGebY4lubR8dn3HF/zT7mxE=
X-Google-Smtp-Source: AGHT+IF2wenxeyE7XIJ4gn5j7HE7kYt/efuEUfra8aTWvRCTeZ6usZClJatbl/oALDDone8ynTaYHQ==
X-Received: by 2002:a05:600c:1f92:b0:405:959e:dc7c with SMTP id je18-20020a05600c1f9200b00405959edc7cmr1735809wmb.30.1698397268254;
        Fri, 27 Oct 2023 02:01:08 -0700 (PDT)
Received: from [192.168.10.177] (54-240-197-227.amazon.com. [54.240.197.227])
        by smtp.gmail.com with ESMTPSA id o1-20020a05600c510100b003fe1c332810sm4617535wms.33.2023.10.27.02.01.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Oct 2023 02:01:07 -0700 (PDT)
Message-ID: <9fb67e52-f262-4cf4-91c2-a42411ba21c4@gmail.com>
Date:   Fri, 27 Oct 2023 10:01:06 +0100
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
From:   "Durrant, Paul" <xadimgnik@gmail.com>
In-Reply-To: <f72e2e7feed3ecf17af8ab8442c359eea329ef17.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 27/10/2023 09:45, David Woodhouse wrote:
> On Fri, 2023-10-27 at 08:30 +0100, Durrant, Paul wrote:
>>
>>> +    if (blockdev->props.vdev.type == XEN_BLOCK_VDEV_TYPE_INVALID) {
>>> +        XenBus *xenbus = XEN_BUS(qdev_get_parent_bus(DEVICE(xendev)));
>>> +        char fe_path[XENSTORE_ABS_PATH_MAX + 1];
>>> +        char *value;
>>> +        int disk = 0;
>>> +        unsigned long idx;
>>> +
>>> +        /* Find an unoccupied device name */
>>
>> Not sure this is going to work is it? What happens if 'hda' or 'sda', or
>> 'd0' exists? I think you need to use the core of the code in
>> xen_block_set_vdev() to generate names and search all possible encodings
>> for each disk.
> 
> Do we care? You're allowed to have *all* of "hda", "sda" and "xvda" at
> the same time. If a user explicitly provides "sda" and then provides
> another disk without giving it a name, we're allowed to use "xvda".
> 

Maybe sda and xvda can co-exist, but

https://xenbits.xen.org/gitweb/?p=xen.git;a=blob;f=docs/man/xen-vbd-interface.7.pandoc;h=ba0d159dfa7eaf359922583ccd6d2b413acddb13;hb=HEAD#l125

says that you'll likely run into trouble if hda exists and you happen to 
create xvda.

> Hell, you can also have *separate* backing stores provided as "hda1",
> "sda1" and "xvda1". I *might* have tolerated a heckle that this
> function should check for at least the latter of those, but when I was
> first coding it up I was more inclined to argue "Don't Do That Then".

This code is allocating a name automatically so I think the onus is on 
it not create a needless clash which is likely to have unpredictable 
results depending on what the guest is. Just avoid any aliasing in the 
first place and things will be fine.

   Paul

