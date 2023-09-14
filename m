Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33A5379FFD4
	for <lists+kvm@lfdr.de>; Thu, 14 Sep 2023 11:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236606AbjINJRq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Sep 2023 05:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbjINJRp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Sep 2023 05:17:45 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31D7CF3;
        Thu, 14 Sep 2023 02:17:40 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-5230a22cfd1so819034a12.1;
        Thu, 14 Sep 2023 02:17:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694683059; x=1695287859; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dUORqEcZFTSmgOVwGiyiZj+DURLWbwbPRSzvGKzKRWU=;
        b=B7HzsWai4se7R+g5I5aBza8mVBzIoTvHHAk88ilIG5RKTIWrJ7UKJoRo+ZK+5EkXTa
         F54Go0Dz7GNCBNzNwnUBrdQfGQ8AtWxkyhKQamJfS5QNPLYHC5eEv+HP+Aw3HHJZElH9
         J41kEvII9DxIXuVEQoXpbEovgU1/Q/jeFvtB2g8Ljl/xFYF2dAZycbuMrd0ie9c98pqD
         z8TIxdDvj/9b61I/GRLIltIxLQeV4QxObsJhSryl6rh2G/7y4NqeDyjjjD5m7vbi0nCH
         pv7ZeWLRarDnoioomYHu8OunvQ+D5oiio3bAG1a3PSN//m4nCFNZgf9bQB9ucVgfd1MT
         KUSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694683059; x=1695287859;
        h=content-transfer-encoding:in-reply-to:organization:references:cc:to
         :content-language:subject:reply-to:user-agent:mime-version:date
         :message-id:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dUORqEcZFTSmgOVwGiyiZj+DURLWbwbPRSzvGKzKRWU=;
        b=hJzOBsWL3FBAQmPYdW2V8MTzdpb7NuZAov2dvKIMhG5IcJWAbWUVxdMaFQ2K1r5jDq
         PH9XfjLIN47QmZvSmqyFSS5NA1oYuObS2La4mVCT+w6wOmagEfuzRxZudvxaxxIDgoW+
         PGMqwBBXkJnjjy/LpsPZlI+CaJGf0Ogw3afbN90/lCTiYM5u/t8McjKrnsp/SBqI+m/z
         kFa50ezA6ll/IZICoc6RrOcNEuDTX3DVeCdmXe4jU6ELP5lJMieZ4jzB+2y084pxmEKv
         QZ3DKWuS6vzg5/XjnCj1ZPOROQj6wb87V3Lnj/rgs5IUigCwt2OgTteSTX0G/5OW08HK
         RUDg==
X-Gm-Message-State: AOJu0Yw37diaP66pBLc5qmsspGXSYIWo6h/C5VwYgS/mAdylXdhQBnZ3
        Re67hew0VraRaavndgTTVCs=
X-Google-Smtp-Source: AGHT+IFsigbWdV5tCrTqHdfWUDGlw4g2bpeJWgj8Y3J03r3804Ap1JY1gQvpxdXhcnte92QwKAn5aQ==
X-Received: by 2002:a17:906:31d9:b0:9a2:232f:6f85 with SMTP id f25-20020a17090631d900b009a2232f6f85mr4042989ejf.52.1694683058977;
        Thu, 14 Sep 2023 02:17:38 -0700 (PDT)
Received: from [192.168.6.126] (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id qq7-20020a17090720c700b009920a690cd9sm720969ejb.59.2023.09.14.02.17.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 02:17:38 -0700 (PDT)
From:   Paul Durrant <xadimgnik@gmail.com>
X-Google-Original-From: Paul Durrant <paul@xen.org>
Message-ID: <855b06c9-50d2-e2e3-c0e2-fd9c3652e65b@xen.org>
Date:   Thu, 14 Sep 2023 11:17:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Reply-To: paul@xen.org
Subject: Re: [PATCH 8/8] KVM: xen: automatically use the vcpu_info embedded in
 shared_info
Content-Language: en-US
To:     David Woodhouse <dwmw2@infradead.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Paul Durrant <pdurrant@amazon.com>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
References: <20230914084946.200043-1-paul@xen.org>
 <20230914084946.200043-9-paul@xen.org>
 <340cf9f24c85b17a1fe752715d95b2c3b84ac700.camel@infradead.org>
Organization: Xen Project
In-Reply-To: <340cf9f24c85b17a1fe752715d95b2c3b84ac700.camel@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 14/09/2023 10:09, David Woodhouse wrote:
> On Thu, 2023-09-14 at 08:49 +0000, Paul Durrant wrote:
>> From: Paul Durrant <pdurrant@amazon.com>
>>
>> Add a KVM_XEN_HVM_CONFIG_DEFAULT_VCPU_INFO flag so that the VMM knows it
>> need only set the KVM_XEN_VCPU_ATTR_TYPE_VCPU_INFO attribute in response to
>> a VCPUOP_register_vcpu_info hypercall, and modify get_vcpu_info_cache()
>> to pass back a pointer to the shared info pfn cache (and appropriate
>> offset) for any of the first 32 vCPUs if the attribute has not been set.
> 
> Might be simpler just to link this behaviour to the
> KVM_XEN_ATTR_TYPE_SHARED_INFO_HVA support? If userspace sets the
> shared_info as an HVA, then the default vcpu_info will be used therein.

Well there's no problem in using the default embedded vcpu_info even if 
the guests sets the shared_info via GPA... it still saves the VMM making 
a few ioctls. So do we really want to link the two things?

   Paul
