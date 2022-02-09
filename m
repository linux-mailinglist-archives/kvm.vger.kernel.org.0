Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00DB54AEDC4
	for <lists+kvm@lfdr.de>; Wed,  9 Feb 2022 10:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbiBIJPO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Feb 2022 04:15:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230056AbiBIJPN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Feb 2022 04:15:13 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A992E00D0E1
        for <kvm@vger.kernel.org>; Wed,  9 Feb 2022 01:15:07 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id z13so3238823pfa.3
        for <kvm@vger.kernel.org>; Wed, 09 Feb 2022 01:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=eS24qNdegIWCdHUi8b2hejyGS+Oi29jL5tYMjfpE3SI=;
        b=TtrsaU40achQzujy1rNECYWMBqDpsytYbX5mv0c/WYCrSh7Df2smiRbELWG99GGaku
         P4rmxVMd6TOSSbnuHemBRH95HCVLvredGtjzAkKc3iIQQr85arjgELJSnKnYmDeSDLq0
         Pqr3HrQaK1hC6ku0vpFD/Fp1OYZVV1+ANLCL/Y0OL4X9S95vqp7ZHTI27VR653n8J8Fx
         d3YbMaIhYoRGYMPfzgageLQoJLbH8A0snx11xKUnPXsfkhdW5Eju+u+yg0tkOm35isyv
         7wZ2/IMXWHHk1tfrEtLPT0giISYycggTuntP0I3QAPJwY9oNsH6rVYwxQ/CZlLMfHllI
         3A4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:cc:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=eS24qNdegIWCdHUi8b2hejyGS+Oi29jL5tYMjfpE3SI=;
        b=TB4ggOkcmG0jicwMkpMQSMZzdvk+cVIWOJld7HpFw0GO8/4DaaVCA6DCHNZiKNQmzM
         VzEZ9f+XDKoKwNk7g/e6d+W/qmYCTsdmjmTYRWhrdWv5dO47JWtsq+Wxt3mkBECiRJ6K
         xtHGu9caHrFu8WZMxlx1DwilQL51upJnmtycgsIyzkCHQD8siUilHcKuP0now/ZPfWrO
         oK2US8UCc6sg4lNidlbZ2kOdfTYc/skrRqQcW6V46JRkUU4jvMvcLxu1SryVH3eJgOef
         dBVhNVKygqFZFVKVHNwSAvbzrhFxjIHBUZbXIUobmxlhkpCv+SQpjVsVfyrmEi/YRyRW
         7+dw==
X-Gm-Message-State: AOAM5320fV3qKwl18BO2kiOQCIJrIv7pqiclevTcMao1laNZabkuo0fd
        tubwgquY2DNnhHZX+VfPdyYlpur5vd8U7n/y
X-Google-Smtp-Source: ABdhPJw5UWH0anEoO2uEPvQY29O0uY8OHqH5jsXXXp7i9xHQQvi4zXUqhjJ8Kt5tQmCYKT/oXBXcxw==
X-Received: by 2002:a63:5166:: with SMTP id r38mr1137257pgl.99.1644398073469;
        Wed, 09 Feb 2022 01:14:33 -0800 (PST)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id d10sm18714695pfl.16.2022.02.09.01.14.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Feb 2022 01:14:33 -0800 (PST)
Message-ID: <e2c18d80-7c4e-6a0a-d37e-3a585d53d3f2@gmail.com>
Date:   Wed, 9 Feb 2022 17:14:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.0
Subject: Re: [PATCH v5 0/2] Enable legacy LBR support for guest
Content-Language: en-US
To:     Yang Weijiang <weijiang.yang@intel.com>
References: <20220122161201.73528-1-weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, ehabkost@redhat.com, mtosatti@redhat.com,
        richard.henderson@linaro.org, qemu-devel@nongnu.org,
        kvm@vger.kernel.org, likexu@tencent.com, wei.w.wang@intel.com
From:   Like Xu <like.xu.linux@gmail.com>
Organization: Tencent
In-Reply-To: <20220122161201.73528-1-weijiang.yang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Weijiang,

On 23/1/2022 12:11 am, Yang Weijiang wrote:
> KVM legacy LBR patches have been merged in kernel 5.12, this patchset
> is to expose the feature to guest from the perf capability MSR. Qemu can
> add LBR format in cpu option to achieve it, e.g., -cpu host,lbr-fmt=0x5,

Some older Intel CPUs may have lbr-fmt=LBR_FORMAT_32 (which is 0), would
you help verify that KVM is supported on these platforms ? If so, how do we enable
guest LBR form the QEMU side, w/ -cpu host,lbr-fmt=0x0 ?

> the format should match host value in IA32_PERF_CAPABILITIES.
> 
> Note, KVM legacy LBR solution accelerates guest perf performace by LBR MSR
> passthrough so it requires guest cpu model matches that of host's, i.e.,

Would you help add live migration support across host/guest CPU models when
hosts at both ends have the same number of LBR entries and the same lbr-fmt ?

Thanks,
Like Xu

> only -cpu host is supported.
> 
> Change in v5:
> 	1. This patchset is rebased on tip : 6621441db5
> 	2. No functional change since v4.
