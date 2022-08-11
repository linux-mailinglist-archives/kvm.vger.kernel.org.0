Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4EB5908CF
	for <lists+kvm@lfdr.de>; Fri, 12 Aug 2022 00:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236473AbiHKW4r (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 11 Aug 2022 18:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231131AbiHKW4q (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 11 Aug 2022 18:56:46 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24B9A94EFF;
        Thu, 11 Aug 2022 15:56:45 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id u133so17670783pfc.10;
        Thu, 11 Aug 2022 15:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=A5BvUw9DHDs145kZowhBaJ4O1ZR9lKngl0DmWaJQmow=;
        b=L+08adCWxhKXEZascNszKuNEllEEJ75u8zaDs3gl3ePwhzjJWEnlvQ/UO+Z+KswkmI
         KIDwOORijsD/8zQz6RNkQQSl6i2qrbG7oo/mAYzwpk3cQq5QKcghHsvHsH9Rn+uUdzdd
         nOOVTx0MKZXBa49izNI3MWGczTbzH01Mm5e8AcqrvkrMtxNpUgOQzjMTfWBf5ePfjiuI
         Yfey0YG1CseWGFZcZGTi7OMwa1sGEJRekwboB6hG/hWiimhMGaXvBjmCXl8t8b6VoO2N
         qU1yXiWHGGTIz0zrqMQ16WMhT20XP/bpH0IRQamUsjBBDpnQP8gS/I9kwrwBbfE1Gkk8
         q21A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=A5BvUw9DHDs145kZowhBaJ4O1ZR9lKngl0DmWaJQmow=;
        b=UX6UMhOWQW6w2vNgJepjhvcnPa2YU53LOaq/w5nkBDMMxAcc8cNmVrsPaBL6Y5A1F1
         oTKzLp4J7ag/Ck21Hf0QKvrOTCofGCQI788OLFVpCah6/Bf86tlMUe5KbONawLQ7r9O5
         k5P59hrEaXzeu0oZB4xIkD/3rFHRgf9E16xIQWU/dW6R2VDfq/YXroWVj1T7KlmwrosM
         yAEmhgdpaT24MQi3Tl2LY/ryZVvz9EhP+rFwTBhqjUXlXN9jNglT6UCLw1VpCBdoArG9
         SjF5vHHLC2JeWnp8dAgpPKw1XY4klXfLycJcWWbqIFHWny7tVvdp9W4ExvRMdt6HUvNO
         ckYA==
X-Gm-Message-State: ACgBeo2NwnFt3Pd09AQmwZqrXqooecy7ewpwt5mG+206x4A7S4V1WQVj
        XnWssB8SyUc817SoWUPTl+U=
X-Google-Smtp-Source: AA6agR6hUkYo4PiF0HYlysZjr6uPc20IERTxrPMMRhbiZqUW0ubj0RKGPBTMsrAU3LfjQIAi/rcvsg==
X-Received: by 2002:a63:f24e:0:b0:41d:7381:ee6b with SMTP id d14-20020a63f24e000000b0041d7381ee6bmr927921pgk.305.1660258604498;
        Thu, 11 Aug 2022 15:56:44 -0700 (PDT)
Received: from localhost ([192.55.54.53])
        by smtp.gmail.com with ESMTPSA id ik28-20020a170902ab1c00b0016dbb5bbeebsm180382plb.228.2022.08.11.15.56.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 15:56:43 -0700 (PDT)
Date:   Thu, 11 Aug 2022 15:56:42 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>
Subject: Re: [RFC PATCH 13/13] KVM: x86: remove struct
 kvm_arch.tdp_max_page_level
Message-ID: <20220811225642.GA826621@ls.amr.corp.intel.com>
References: <cover.1659854957.git.isaku.yamahata@intel.com>
 <1469a0a4aabcaf51f67ed4b4e25155267e07bfd1.1659854957.git.isaku.yamahata@intel.com>
 <e275d842-d115-d1d2-a4c2-07ddd057ece1@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <e275d842-d115-d1d2-a4c2-07ddd057ece1@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 08, 2022 at 01:40:53PM +0800,
Xiaoyao Li <xiaoyao.li@intel.com> wrote:

> On 8/8/2022 6:18 AM, isaku.yamahata@intel.com wrote:
> > From: Xiaoyao Li <xiaoyao.li@intel.com>
> > 
> > Now that everything is there to support large page for TD guest.  Remove
> > tdp_max_page_level from struct kvm_arch that limits the page size.
> 
> Isaku, we cannot do this to remove tdp_max_page_level. Instead, we need
> assign it as PG_LEVEL_2M, because TDX currently only supports AUG'ing a
> 4K/2M page, 1G is not supported yet.

I went too further. I'll fix it, thanks.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
