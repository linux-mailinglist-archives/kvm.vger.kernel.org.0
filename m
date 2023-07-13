Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E201E7527F6
	for <lists+kvm@lfdr.de>; Thu, 13 Jul 2023 18:02:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbjGMQCs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 13 Jul 2023 12:02:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233618AbjGMQCq (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 13 Jul 2023 12:02:46 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F44226B2;
        Thu, 13 Jul 2023 09:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=FGfECluQ+8FqgloN5y7njhMRYgbNQmkghpgv24LmuxM=; b=0XY4/FQJa9khQp7bFpbGplPtrB
        5SpA/Xwz1+y5xMC8TkQ/RIwD1YWvtpubNsS1DOufMRk8U8ZOw4QBT/2OcdaSsugIN7fvQtpI7FoTv
        cytb12hmpQ++kNkMjOGEjV3X0J/VuBhB9uSnfg9JjtfUZNml3TMudThtLyoBgiurIyPLTXfpsW1zN
        ZtXFfJPqxyrJBHJb3985aNxuQmUFSYt3wjhQoX2i+JeMJunamtLIY8iXJ5jgN3F/OMabSTImubkKK
        MN74NscjU6mryhy24nJ4dBieOuA4YvnVsMsArDKWNb60xY8A4s7oL4npScU177xtucZj0Dk4Lyl65
        o8/EadpQ==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1qJym9-003r1C-08;
        Thu, 13 Jul 2023 16:02:41 +0000
Message-ID: <801dbd65-ee7f-526d-6cd8-27cb0291c4ba@infradead.org>
Date:   Thu, 13 Jul 2023 09:02:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v2 18/18] fbdev: Document that framebuffer_alloc() returns
 zero'ed data
Content-Language: en-US
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Cc:     deller@gmx.de, javierm@redhat.com, linux-sh@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-staging@lists.linux.dev,
        linux-arm-kernel@lists.infradead.org,
        linux-geode@lists.infradead.org, linux-nvidia@lists.surfsouth.com,
        linux-hyperv@vger.kernel.org, linux-omap@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
        Miguel Ojeda <ojeda@kernel.org>
References: <20230713130338.31086-1-tzimmermann@suse.de>
 <20230713130338.31086-19-tzimmermann@suse.de>
 <CANiq72mbLmMKph8aiz4apNF9n3MtVO-nhM9rEWYApZbSVAO9Qw@mail.gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <CANiq72mbLmMKph8aiz4apNF9n3MtVO-nhM9rEWYApZbSVAO9Qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 7/13/23 06:21, Miguel Ojeda wrote:
> On Thu, Jul 13, 2023 at 3:03 PM Thomas Zimmermann <tzimmermann@suse.de> wrote:
>>
>> Most fbdev drivers depend on framebuffer_alloc() to initialize the
>> allocated memory to 0. Document this guarantee.
>>
>> Suggested-by: Miguel Ojeda <ojeda@kernel.org>
>> Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
>> Cc: Helge Deller <deller@gmx.de>
> 
> Thanks for sending this! Maybe this would be best earlier in the
> series, so that later patches make more sense (since they use the
> guarantee), but it is not a big deal.
> 
>> + * aligned to sizeof(long). Both, the instance of struct fb_info and
>> + * the driver private data, are cleared to zero.
> 
> I think both commas may be best omitted (but I am not a native speaker).

Yes, it would be better to omit them.

> Reviewed-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Cheers,
> Miguel

-- 
~Randy
