Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A5FE653E9D
	for <lists+kvm@lfdr.de>; Thu, 22 Dec 2022 12:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235351AbiLVLAd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 22 Dec 2022 06:00:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229907AbiLVLAa (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 22 Dec 2022 06:00:30 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B6527DE7;
        Thu, 22 Dec 2022 03:00:30 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id w26so963554pfj.6;
        Thu, 22 Dec 2022 03:00:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ygtuIC/+I5eDLPAPhh99PqfQhdOBagaoC0VerFFJYws=;
        b=WmkCpNWLVjXoU1j/UktboZeY3MFRFUIa4lrR8Rw/p2n5mVfxKLTiJZfg8sK3kdPjoJ
         rxuvhXV7r7nYjpIiiO3ElxgJ/G3seU3w6G4vizMHu7eRcdVDywdlOOLTa36U7LItN8L9
         s8Q06j6BPKv0f9vsdyws1F03tHr040TQoDUIGWxTv347PQFEVeAGWWvlJhdedG820daf
         Zx3T+bzf9EqAukHULL49nJjqOSrnW687hB8Cg5VWbMrkcxDXm9rQ9ywPVZZJC2itYxji
         AFDP6RcG9u4I7+tizUOdgQJFJ+SEQUo2X6muw17ZLbPlASzSdWH9ocAGFHktsqt/ZcDm
         7Ysw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ygtuIC/+I5eDLPAPhh99PqfQhdOBagaoC0VerFFJYws=;
        b=Kanj3mFX8OZI2pGR3l0VZ4z7/Xv04EqMh8XgEBIGSn8NSnWE2tte5bvL+xX4rpvvd7
         GSodAKlDRL3QifssG3RuLbHQzWvEiXwWCDhvRBO8/gBhc+NT0o1rj+EQSSKG7v7+yZTB
         FFQtJAiViHf1clYUzVIxb8bQDd/E0x45mNgxKry6/jFJgUCvTEPlyzX7fh+aLaQ5isiN
         IxuxQ/MWyTd8f+Dnb4f5QK0OH833iqK9DSjJSj/LFVwksT+dYjVj80AwEHsbdh1putBz
         uhBPCTbPWHm7pxITfhEHNb/9KmHcy84MB+JCnem8+w2A/WMbFvcszGakBJu/y8nbq5XR
         UdmA==
X-Gm-Message-State: AFqh2koJDhvlbGuW6AKmhmo1IdfpNQjJtxSxogLTHhbUUCMEUHHw7jQI
        OEdc5p0Z+yZ2lOsB8SkqYUoBfYOhQWjXwtRs
X-Google-Smtp-Source: AMrXdXuGtm2N8eH1MvcHSNED4kwz9CdRxShsynE9jNVyQEq5ddxiOktR8/o7RtJFqdpMqQFCcbbFiw==
X-Received: by 2002:a05:6a00:1485:b0:575:b783:b6b3 with SMTP id v5-20020a056a00148500b00575b783b6b3mr7235948pfu.28.1671706829516;
        Thu, 22 Dec 2022 03:00:29 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id 76-20020a62154f000000b005776867a97dsm455784pfv.29.2022.12.22.03.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Dec 2022 03:00:29 -0800 (PST)
Message-ID: <b90aefab-e091-7656-b58b-fd2247e8e375@gmail.com>
Date:   Thu, 22 Dec 2022 19:00:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.0
Subject: Re: [PATCH v2 05/15] KVM: vmx/pmu: Emulate MSR_ARCH_LBR_DEPTH for
 guest Arch LBR
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     kan.liang@linux.intel.com, wei.w.wang@intel.com, seanjc@google.com,
        pbonzini@redhat.com, jmattson@google.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20221125040604.5051-1-weijiang.yang@intel.com>
 <20221125040604.5051-6-weijiang.yang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20221125040604.5051-6-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 25/11/2022 12:05 pm, Yang Weijiang wrote:
> @@ -571,6 +571,9 @@ struct kvm_pmu {
>   	 * redundant check before cleanup if guest don't use vPMU at all.
>   	 */
>   	u8 event_count;
> +
> +	/* Guest arch lbr depth supported by KVM. */
> +	u64 kvm_arch_lbr_depth;

Please drop the "kvm_" prefix for per-vcpu "struct kvm_pmu".

>   };
>   
