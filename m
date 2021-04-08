Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48FC83588A5
	for <lists+kvm@lfdr.de>; Thu,  8 Apr 2021 17:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbhDHPi1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Apr 2021 11:38:27 -0400
Received: from mail-wm1-f44.google.com ([209.85.128.44]:41488 "EHLO
        mail-wm1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231526AbhDHPi1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Apr 2021 11:38:27 -0400
Received: by mail-wm1-f44.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso1493431wmi.0;
        Thu, 08 Apr 2021 08:38:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hM2s1bayeXBzOQ1SCTEyTyH5HnkWSxZsRwT7Sk9bV8E=;
        b=BkZC4V56b0GN67z3j5RVBicp03tgfrYuojkLvunpUfjd65veU/+aJ6RDfMrjOe0nEB
         nAmGY17MRUp0JIt0AIAavrHwu8zSFryRnAXnv38pTBaKwN2lIUvzPLzi1idbChy3jpZs
         nMWdWvv0LL5U/+XOaZ61YMGRRhTMGbRHXbyFLONOf6Z9MvQIL3MIoexG0iipLOBsQKoD
         DzkapdjNB/gP20F8/a60scFMXr+lvdI3gnMksJRPSJprLvPU6xWVldKbwGndWM78tcC3
         jG6y0yKeuIek0CdLlTIdKNlsROcXc5LwHej8hWENbZ4QhzH2qNO29JiUKFM80GsEi6jq
         vn/g==
X-Gm-Message-State: AOAM531Pe84DTvye2BzXP6HZEZjpADRy/brzuNotWWrlnQpLuFgojtvU
        zDFX0rvWJcQaPX0yEtJGoo0=
X-Google-Smtp-Source: ABdhPJxyM2i1pL0oF+sVfkW91dKRjbwZSuGBq6zVQMWrZNFY+W/lbcuEPaNJZSRVi3DmS3nsgn2jXA==
X-Received: by 2002:a1c:b7c3:: with SMTP id h186mr9060796wmf.140.1617896294865;
        Thu, 08 Apr 2021 08:38:14 -0700 (PDT)
Received: from liuwe-devbox-debian-v2 ([51.145.34.42])
        by smtp.gmail.com with ESMTPSA id d133sm3133861wmf.9.2021.04.08.08.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 08:38:14 -0700 (PDT)
Date:   Thu, 8 Apr 2021 15:38:13 +0000
From:   Wei Liu <wei.liu@kernel.org>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>,
        Siddharth Chandrasekaran <sidcha@amazon.de>, kys@microsoft.com,
        haiyangz@microsoft.com, sthemmin@microsoft.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com,
        seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com,
        jmattson@google.com, joro@8bytes.org, graf@amazon.com,
        eyakovl@amazon.de, linux-hyperv@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 0/4] Add support for XMM fast hypercalls
Message-ID: <20210408153813.iu3teoor6c6m6kzb@liuwe-devbox-debian-v2>
References: <20210407212926.3016-1-sidcha@amazon.de>
 <20210408152817.k4d4hjdqu7hsjllo@liuwe-devbox-debian-v2>
 <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <033e7d77-d640-2c12-4918-da6b5b7f4e21@redhat.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 08, 2021 at 05:30:26PM +0200, Paolo Bonzini wrote:
> On 08/04/21 17:28, Wei Liu wrote:
> > > Although the Hyper-v TLFS mentions that a guest cannot use this feature
> > > unless the hypervisor advertises support for it, some hypercalls which
> > > we plan on upstreaming in future uses them anyway.
> > 
> > No, please don't do this. Check the feature bit(s) before you issue
> > hypercalls which rely on the extended interface.
> 
> Perhaps Siddharth should clarify this, but I read it as Hyper-V being buggy
> and using XMM arguments unconditionally.
> 

There is no code in upstream Linux that uses the XMM fast hypercall
interface at the moment.

If there is such code, it has bugs in it and should be fixed. :-)

Wei.

> Paolo
> 
