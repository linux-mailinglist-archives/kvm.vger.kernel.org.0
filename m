Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B89BB22A
	for <lists+kvm@lfdr.de>; Mon, 23 Sep 2019 12:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439493AbfIWKVr (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Sep 2019 06:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43664 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439441AbfIWKVr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Sep 2019 06:21:47 -0400
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com [209.85.221.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 986472D6A0D
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 10:21:46 +0000 (UTC)
Received: by mail-wr1-f72.google.com with SMTP id z17so4665217wru.13
        for <kvm@vger.kernel.org>; Mon, 23 Sep 2019 03:21:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OmMWAPk3NRNh1ylKLS9ZJCZTMkn6Nstafcul+5/qUp8=;
        b=JHKDBZ+7/byrEuLmLEduG6LuaawCw/c0n+3K00NZ2KKIaOZfZ69u52DPDB1OYSQLR7
         6fAQHIy2472i1K5dbKCZQw+hPVanSu3ozc9o5nLeSCSvnUdG5X38E/iFAYL32H9T5sND
         3e8AFIqjJHr1tWpAyd+2SPETET1vAZRsyxbLZVJXJ3sbae4SDXtWHUQMeNFN/UhCEC8V
         EMUD4sik5rdlpy4aAS65zUkyAXH+ZiTfs3uEus3yj+niRJWp72/RDhgvWqVjJZw5wdT9
         Trlg7qEmXo1YYLLuo4qcL/o7aoyCXDeu47ViorOZS3xA9R+42nv2xWDz+VO5+6mOtzKa
         Aygg==
X-Gm-Message-State: APjAAAUaP/+W9Q+yc547ZGx4+bKUtgclLKDL7/FG2R32aFERfwM4dozB
        Y/BqaTWLEj43wXMtz0F3GIx0LBc0rNFl0zr9ZNM/UCybO0hphzLtV1jj3F/3Bfm6Y0wn3eQqVk1
        ImuDlj420qXKk
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr8375578wrr.390.1569234105215;
        Mon, 23 Sep 2019 03:21:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxueZ/N0VlXRwKFrYfaXJRgCGYard8ckjZfTB0PSl7gPQxsJBf8/9SSdLkbd6pbpUSZ1j7TIA==
X-Received: by 2002:a5d:43d0:: with SMTP id v16mr8375567wrr.390.1569234104944;
        Mon, 23 Sep 2019 03:21:44 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9520:22e6:6416:5c36? ([2001:b07:6468:f312:9520:22e6:6416:5c36])
        by smtp.gmail.com with ESMTPSA id h17sm24346572wme.6.2019.09.23.03.21.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Sep 2019 03:21:44 -0700 (PDT)
Subject: Re: [PATCH 13/17] KVM: monolithic: x86: drop the kvm_pmu_ops
 structure
To:     Andrea Arcangeli <aarcange@redhat.com>
Cc:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Peter Xu <peterx@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190920212509.2578-1-aarcange@redhat.com>
 <20190920212509.2578-14-aarcange@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <057fc5f2-7343-943f-ed86-59f1ad5122e5@redhat.com>
Date:   Mon, 23 Sep 2019 12:21:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920212509.2578-14-aarcange@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/09/19 23:25, Andrea Arcangeli wrote:
> Cleanup after this was finally left fully unused.
> 
> Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
> ---
>  arch/x86/include/asm/kvm_host.h |  3 ---
>  arch/x86/kvm/pmu.h              | 19 -------------------
>  arch/x86/kvm/pmu_amd.c          | 15 ---------------
>  arch/x86/kvm/svm.c              |  1 -
>  arch/x86/kvm/vmx/pmu_intel.c    | 15 ---------------
>  arch/x86/kvm/vmx/vmx.c          |  2 --
>  6 files changed, 55 deletions(-)

Is there any reason not to do the same for kvm_x86_ops?

(As an aside, patch 2 is not copying over the comments in the struct
kvm_x86_ops declarations.  Granted there aren't many, but we should not
lose the few that exist).

Paolo
