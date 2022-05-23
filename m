Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162C8531645
	for <lists+kvm@lfdr.de>; Mon, 23 May 2022 22:50:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232367AbiEWUIy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 May 2022 16:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232362AbiEWUIv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 May 2022 16:08:51 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E03F980BA;
        Mon, 23 May 2022 13:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Ro7WGsVUuxCOeDrWNgjM+lNVv7dX3AAFuu5yPbLuSWE=; b=mxa1UsCgTepiNnJQtOaoPD2lkR
        uUkPb2ehCURC1r8VNigD58lSgad6dPH5mlsHRMibm3rxfE2Rud6fkebWxcgAMddMkzK8551j6whiW
        LuXcA3z6NzvyHvsYctJtzsmObRuuPoCV09UtRbnbCXRypgXNjViyONrpi+qFlK+/nxwiFQy2IC50u
        DY6exdGA+F8VYy5Aj9FsPxisn9LvN2TfNjinK4wc6ANuACQ3RyxmJiBF/70Sl5miLWcVD0MuA4MCY
        IDzeU6kKqy521/8Ts3inwYs46FYP7C+J/qKi6unFhktlyKDQxUbR7zRKCmokQN4Of1H8LeNJi67Ck
        9qHt4sqg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ntEMA-00GVTA-Fu; Mon, 23 May 2022 20:08:47 +0000
Message-ID: <c7449167-b6fe-02b7-9cf4-0a4a2a8fab39@infradead.org>
Date:   Mon, 23 May 2022 13:08:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH] s390/uv_uapi: depend on CONFIG_S390
Content-Language: en-US
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Christian Borntraeger <borntraeger@linux.ibm.com>,
        linux-s390@vger.kernel.org
References: <20220523192420.151184-1-pbonzini@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220523192420.151184-1-pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



On 5/23/22 12:24, Paolo Bonzini wrote:
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/s390/char/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/s390/char/Kconfig b/drivers/s390/char/Kconfig
> index ef8f41833c1a..108e8eb06249 100644
> --- a/drivers/s390/char/Kconfig
> +++ b/drivers/s390/char/Kconfig
> @@ -103,6 +103,7 @@ config SCLP_OFB
>  config S390_UV_UAPI
>  	def_tristate m
>  	prompt "Ultravisor userspace API"
> +        depends on S390

Please use a tab for indentation instead of spaces.

>  	help
>  	  Selecting exposes parts of the UV interface to userspace
>  	  by providing a misc character device at /dev/uv.

-- 
~Randy
