Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0F179CFF8
	for <lists+kvm@lfdr.de>; Tue, 12 Sep 2023 13:32:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234709AbjILLcG (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Sep 2023 07:32:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235046AbjILLbw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Sep 2023 07:31:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56EF010E9
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:31:48 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1c3d8fb23d9so2772755ad.0
        for <kvm@vger.kernel.org>; Tue, 12 Sep 2023 04:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694518308; x=1695123108; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0wYwVLf5zX0+9z6NLjUA7O7NTF4lwYEUSLfKZyP50h4=;
        b=J4vzrtzygIhURovZhSrPXXZdmzxyZUGmQAgpgsGY2Mdlvog9v+zNsnax37krxFpyrL
         eSj+W1451NewX+JTEead+91isMeGCzUUj6o62712geKIB7ECbRZ2hBkyzhYWMQ07eXih
         hmFDXEQQSPCLcH6hcIz2CXuxrYu+wa2288AgKbIESg29MLYf8hAonjzDo77tK8Bz4Bql
         lCIN+jHnwF1jz9QTGRVhf6O2W/LdkJt4tL/LfOU7ET9fesugqS+jBTFiE386bV32p46t
         Ztu1oaKAL6uXdkynq9lb2j+tk4FlkBD1S+q6XpuOF2kNgLMPUbf3DRDFPWR/C2YU6WdO
         7rWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694518308; x=1695123108;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0wYwVLf5zX0+9z6NLjUA7O7NTF4lwYEUSLfKZyP50h4=;
        b=mwlrUxA+Pe3/uIQzM2roO0oih8QwMm7Flf8uZV/uEh1ycbkp1v0+46jcTdpnipPWRL
         pFKkq61SSNBOIke7JvZSx5fBIbK/2xbqoY+0UOEu2WvdrcunXYC9xQW5Why3wTcsPpyi
         uVsfkmv+b1cSk2YVbizVlJGI6a/TQI0FjWX7yARvhj9amX1oBTIbvBuWkVk3wKIqhL5q
         bwfUT4k01sK05llXg3HcuJYumRzuNTDtwiPVDH/R8fZL30U+Y7YXBfS6S14BowCYo0qE
         oKJ6XXW5eKPOxtA70MuopX8Ssq6bv6md3c9WGmyN1JEnd7LkDHOnBCGW3j/1XHu5fp0J
         e6Wg==
X-Gm-Message-State: AOJu0YwezjAL5EM9XKnwioFz5kuZ/wg+yMiZSi7NOI7T2YKiG0rjbg5s
        ZM0kJmzNSn9qV4aEaeE3C4U=
X-Google-Smtp-Source: AGHT+IGGTTrt/oY/a0/h+ER276dvanPhWBIafMobOccEJb9feDGUKAhSWQBZwCi/nr7XJPKC/tD8vw==
X-Received: by 2002:a17:902:8210:b0:1bf:73ec:b980 with SMTP id x16-20020a170902821000b001bf73ecb980mr9894173pln.66.1694518307757;
        Tue, 12 Sep 2023 04:31:47 -0700 (PDT)
Received: from [192.168.255.10] ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id li11-20020a170903294b00b001bde6fa0a39sm8271472plb.167.2023.09.12.04.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 04:31:47 -0700 (PDT)
Message-ID: <a6ee4f4f-63a6-4d7d-7986-6dd0e1255e92@gmail.com>
Date:   Tue, 12 Sep 2023 19:31:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 5/9] KVM: x86/pmu: Check CPUID.0AH.ECX consistency
Content-Language: en-US
To:     Xiong Zhang <xiong.y.zhang@intel.com>
Cc:     seanjc@google.com, zhiyuan.lv@intel.com, zhenyu.z.wang@intel.com,
        kan.liang@intel.com, dapeng1.mi@linux.intel.com,
        kvm list <kvm@vger.kernel.org>
References: <20230901072809.640175-1-xiong.y.zhang@intel.com>
 <20230901072809.640175-6-xiong.y.zhang@intel.com>
From:   Like Xu <like.xu.linux@gmail.com>
In-Reply-To: <20230901072809.640175-6-xiong.y.zhang@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 1/9/2023 3:28 pm, Xiong Zhang wrote:
> Once user specifies an un-consistency value, KVM can return an
> error to user and drop user setting, or correct the un-consistency
> data and accept the corrected data, this commit chooses to
> return an error to user.

Doing so is inconsistent with other vPMU CPUID configurations.

This issue is generic and not just for this PMU CPUID leaf.
Make sure this part of the design is covered in the vPMU documentation.
