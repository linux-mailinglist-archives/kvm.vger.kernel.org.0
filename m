Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6913261BD
	for <lists+kvm@lfdr.de>; Wed, 22 May 2019 12:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfEVK34 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 22 May 2019 06:29:56 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51522 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728438AbfEVK34 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 22 May 2019 06:29:56 -0400
Received: by mail-wm1-f65.google.com with SMTP id c77so1656744wmd.1
        for <kvm@vger.kernel.org>; Wed, 22 May 2019 03:29:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FIJ17jfOhg95N8FH17P449CIgHx99VfxRPbLIeRnIVw=;
        b=nof4OgfpPdkkJTBBnamaqfRw8sBk8BsDCWAz0x2AuRf8XiMtKN8PQIR5b8XC/08ESC
         M06MC/OABTIClwJPE8B8xeKBD9eCWVRU6YqH1Y8GiPeGe3snljtN9ZtxUO+Fx8UUx3kD
         Ud36aj3xm2CmYxbm/CMoBlQZbFmvJYc+fDSOxcH3XbBTcmD55MnJg323H9fjcrUG14ym
         ReBZj1gApCJ2WZul0DD78RHEn0dZMfaeH23ZTJTk2lXwujHLOYIy0XwDMf2yefQYHbKg
         ooVIFjJreI0qVDeBOM7NrtnyvgmboWLd1Huo5g6hgDLw/yFYa7pWjNsLL12xD5sKC6S8
         KF6w==
X-Gm-Message-State: APjAAAVln3dHoxo02X6zOt5wEFUnlsaKstQjcV28EScRXCE3hu26Ycn5
        lxN3ScFORXGC4q9PVVKG6sIT2Q==
X-Google-Smtp-Source: APXvYqynPS5UMMCQT+g0dIELP7726wnmy0u2E2xGgcd7y8qEWz63vZ0fvKwsypHRz6XG/dggP4i7iA==
X-Received: by 2002:a05:600c:254e:: with SMTP id e14mr6365781wma.70.1558520994382;
        Wed, 22 May 2019 03:29:54 -0700 (PDT)
Received: from [10.32.181.147] (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id a128sm5368403wma.23.2019.05.22.03.29.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 03:29:53 -0700 (PDT)
Subject: Re: [PATCH] i386: Enable IA32_MISC_ENABLE MWAIT bit when exposing
 mwait/monitor
To:     Eduardo Habkost <ehabkost@redhat.com>
Cc:     Wanpeng Li <kernellwp@gmail.com>, qemu-devel@nongnu.org,
        kvm@vger.kernel.org,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
References: <1557813999-9175-1-git-send-email-wanpengli@tencent.com>
 <dcbf44c3-2fb9-02c0-79cc-c8a30373d35a@redhat.com>
 <20190520210525.GE10764@habkost.net>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <ebc26122-d6a8-a3a0-1b42-aa2cc6522c2b@redhat.com>
Date:   Wed, 22 May 2019 12:29:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190520210525.GE10764@habkost.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/05/19 23:05, Eduardo Habkost wrote:
> What if enable_cpu_pm is false but we're running TCG, or if
> enable_cpu_pm is true but we're not using -cpu host?
> 
> Shouldn't this be conditional on
>   (env->features[FEAT_1_ECX] & CPUID_EXT_MONITOR)
> instead?

Yes, it should.  I fixed it locally.

Paolo
