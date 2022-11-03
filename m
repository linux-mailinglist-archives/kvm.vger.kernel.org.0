Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAC72617E82
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 14:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbiKCN4e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 09:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbiKCN4d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 09:56:33 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7266B13D7A;
        Thu,  3 Nov 2022 06:56:32 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id io19so1990154plb.8;
        Thu, 03 Nov 2022 06:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ign6P2397IfFIK8m+Wt90gPlj7W1vvnJv9kawkVb51E=;
        b=HI60mlPg8m4ViBKO0Ko7cuIw5CWkpo8OHY1k84Ajd5UAw+zDBFvmBRD4QqqhAkWjrN
         lNmUO5a0U0c9OsgC2lnIcjG0iXaXQwj1Rjdhdq3CWXM3n20R6+lqm1pCRuvrf7JrLUxY
         ty8hjsDXeWQExDcegMa7fgsxIufgE5FGrldncF2oy/UlSjaix/bMMutFDFEgSiuDnZQO
         0DgEIpgx/XfW3tmQMZa/NUd6jvrjEc1L14YPWBE1ZcnUtLREdMF8hBrirywpkLkCcwtx
         B38Pd5TkQTOi5rbP8ECHzsFmcft2lugGBX2bI3whqkTYnqsAwTPuWQomeqr5pzoOSuec
         9FCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ign6P2397IfFIK8m+Wt90gPlj7W1vvnJv9kawkVb51E=;
        b=OMTMIziAe3R9XIwA4OSkxc4H44Z0tTRt7WZJ4eM6zcnFln10CpSnoVq1Xo73eYEfUN
         dxkDCPrNZgaKQt84tqT+rqczvIHQHOULMpGtOdYLQZ7xY9K0d+ZbGcMZk87v6CJicfqi
         /C9vOnLnv1n1fW4YSkJlhQiRPU5LeSJ6udbkxEH1oMcAMd5JsHNJ9w/HdfGzkiRkJIHK
         HFZkp3CUHdXavM+DhuiGWJLYIA9617omZ9fzg4CHJvhJigfD4iXPgbwLFa0+74nRkwAN
         4jWzuOHJw0BLNF4OeCG5S8Af02TXxmjGdoTsEYKrPxz+GQdKVnMOuI26dt8/iwxUN3LW
         /L7g==
X-Gm-Message-State: ACrzQf2DIuv5/JmZdxq/JqDh0FfFv2L0LR5LIly7iJgc1LWbS1VuYpqm
        JCJgZKP9LSotyR/bibg6upE=
X-Google-Smtp-Source: AMsMyM4vIEMLHQ7RSu1HWrdVM/SWZEWnhtUUleBmGwGYurtfIHzBYGeVcxvcjRtNSl0mHNh1iLLDqg==
X-Received: by 2002:a17:90b:1c8d:b0:203:cc25:4eb5 with SMTP id oo13-20020a17090b1c8d00b00203cc254eb5mr31460357pjb.132.1667483791949;
        Thu, 03 Nov 2022 06:56:31 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id b6-20020a170903228600b00187033cac81sm689757plh.145.2022.11.03.06.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 06:56:31 -0700 (PDT)
Message-ID: <5636b9a1-dbb8-5ab3-8b56-05f6faaccded@gmail.com>
Date:   Thu, 3 Nov 2022 20:56:25 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [External] Re: [RFC 1/6] KVM: arm64: Document PV-lock interface
Content-Language: en-US
To:     Usama Arif <usama.arif@bytedance.com>
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
        linux-doc@vger.kernel.org,
        virtualization@lists.linux-foundation.org, linux@armlinux.org.uk,
        yezengruan@huawei.com, catalin.marinas@arm.com, will@kernel.org,
        maz@kernel.org, steven.price@arm.com, mark.rutland@arm.com,
        fam.zheng@bytedance.com, liangma@liangbit.com,
        punit.agrawal@bytedance.com
References: <20221102161340.2982090-1-usama.arif@bytedance.com>
 <20221102161340.2982090-2-usama.arif@bytedance.com>
 <Y2M6eU6xW7jjVQNx@debian.me>
 <61800b69-5f6a-d173-fc42-628ee3db15d8@bytedance.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <61800b69-5f6a-d173-fc42-628ee3db15d8@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 11/3/22 20:15, Usama Arif wrote:
> Hi,
> 
> Thanks for the review. I will include the changes in the next version I send for pvlock. I have sent a patch to fix pvtime here https://lore.kernel.org/all/20221103131210.3603385-1-usama.arif@bytedance.com/.
> 

Please please please *DON'T* top-post; reply inline instead.

-- 
An old man doll... just what I always wanted! - Clara

