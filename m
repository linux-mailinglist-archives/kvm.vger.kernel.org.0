Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9042358A04
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 18:46:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbhDHQrB (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 12:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231908AbhDHQrA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 12:47:00 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7433DC061760
        for <kvm@vger.kernel.org>; Thu,  8 Apr 2021 09:46:49 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso1741086pje.0
        for <kvm@vger.kernel.org>; Thu, 08 Apr 2021 09:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rxPCMkndqBYyRhJ/HXHkePVgl2qqmdEp7NRGSyXPBwE=;
        b=rVRP8FlD02/Kcpzcm2LxEXgFVmkF4P8HSE7/pAEFDtt/RYzWu/LX5Oz0ZX/HHBINFp
         /DzeMJFV4/tODu1sDSFbmv9UgCEX6iFRrpossXbauH+I2tuJT76mtfoGGeE13qnaUR3t
         RO5JRvQa8g6Z8f6pW5Pi6njlEF9juZjiJ/nLcYTqpSHYX0lYzRP0X/oFZrKw3fOw4gfH
         6P9Lb9TSYHBMpMGeOrDPG3elIGZqlXbBoG0zvxrwBq0RV+sALIp8pHzjq+YGmmDV5BSv
         i1695ulENjUv8FYLMtObZ9sPMFRA2jIeEYG3+pBStLN3b+oCP8k2QDl0OWDee6qOjgz9
         7+YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rxPCMkndqBYyRhJ/HXHkePVgl2qqmdEp7NRGSyXPBwE=;
        b=Lc9xQQlSjjfKV6GoU8ze6dj3MPd4rrdIcnGS/TmQaahWkBWcZiKqe5syJZHxVXJ9pz
         IlCuXSRY/LiYcBe/jc7BTmaBz6wgM71WkMq9c4Z2d1z8zs5IN0xUee3zSAT6IDcaCIiX
         Vq2mNwDvhojQlwAIlAuRtsrpfWrl7iZRbS5iUKIrvx8lz21tPIOUnonxcnkN5uirnZPj
         UxOSrHMILKlEn9QodXvS53KY6knZtyiwzDUVwrOBtdvIkmnpjFPNOdaPYAR/jOfCeySx
         if/zIZia6dzEeDwnHWzhW4xmxsZi5SySBXe2bT4VdOV32pM65E+2iT/eJtZNdeXyncyK
         RFpw==
X-Gm-Message-State: AOAM531fkBhVayHaRAVb23Jok/B4FDnUKeiYPXgsIpAlPASakQ7QCYjK
        /HAaTFj4RueLMS9eOR2urQ03rA==
X-Google-Smtp-Source: ABdhPJzzY5/QY+pnZm/cuKyW3EnmO6dE28lDqOhT/RBtDjH4QS8QdeuXpcuFjvksaGy9llMX0aoDww==
X-Received: by 2002:a17:90a:9413:: with SMTP id r19mr9297821pjo.236.1617900408941;
        Thu, 08 Apr 2021 09:46:48 -0700 (PDT)
Received: from google.com (240.111.247.35.bc.googleusercontent.com. [35.247.111.240])
        by smtp.gmail.com with ESMTPSA id h137sm20628pfe.151.2021.04.08.09.46.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 09:46:48 -0700 (PDT)
Date:   Thu, 8 Apr 2021 16:46:44 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Keqian Zhu <zhukeqian1@huawei.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        wanghaibin.wang@huawei.com, jiangkunkun@huawei.com
Subject: Re: [PATCH] KVM: x86: Remove unused function declaration
Message-ID: <YG8zdKd/RRawGmUR@google.com>
References: <20210406063504.17552-1-zhukeqian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210406063504.17552-1-zhukeqian1@huawei.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 06, 2021, Keqian Zhu wrote:
> kvm_mmu_slot_largepage_remove_write_access() is decared but not used,
> just remove it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>

Reviewed-by: Sean Christopherson <seanjc@google.com>
