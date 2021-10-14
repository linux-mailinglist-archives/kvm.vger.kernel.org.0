Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B15242D9BC
	for <lists+kvm@lfdr.de>; Thu, 14 Oct 2021 15:08:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhJNNKR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Oct 2021 09:10:17 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42498 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhJNNKR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Oct 2021 09:10:17 -0400
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1634216891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uAX07tJNk/b8kiPx+2gbX5YtIE9KbtJDVOrU25WzpHk=;
        b=oblDpIYJBxT9Q4pzd7ju8JODlw7gtdosHIo/l9bslwL++hAva4YS9mbznoZc4MquImCsjQ
        FfYq438Wl1UjelChD+Lrvkb+LvfNGp9Q0WB0Kt5NLxvGGlFczYzYhGZHCRc6ez1BJYV4r0
        muQrZ3INIaNNSENMqGwQLiDp36bWRfxPLmT7rZp6E1kEyaXfY7MnV5sHRlgtagkVAeG0IG
        yd8xm97Xss8S5ddwcv0ABJ3dbKe0zc03BHkwzLGuW/Dj8mrxKQ3lMgJI1O1mwiTeYEk29D
        OyiMm//MO8iExng6QnHPZktUhzc4AWbPhQeb4iHrPu5pPhNbSiznKNkZ86qwXA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1634216891;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uAX07tJNk/b8kiPx+2gbX5YtIE9KbtJDVOrU25WzpHk=;
        b=7ueE+uY30V52XHpVEdGT2vLdDf4OswOG35Ju7jSHdxF+BwWVOdyzDOwPLii1NQbRXaWNFC
        W0G96+DpmEOTm0AA==
To:     "Liu, Jing2" <jing2.liu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "Bae, Chang Seok" <chang.seok.bae@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Nakajima, Jun" <jun.nakajima@intel.com>,
        Jing Liu <jing2.liu@linux.intel.com>,
        "seanjc@google.com" <seanjc@google.com>
Subject: RE: [patch 13/31] x86/fpu: Move KVMs FPU swapping to FPU core
In-Reply-To: <BL0PR11MB3252466D4A10A141F025F425A9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
References: <BYAPR11MB3256B39E2A34A09FF64ECC5BA9B79@BYAPR11MB3256.namprd11.prod.outlook.com>
 <87sfx57ycw.ffs@tglx>
 <BL0PR11MB3252466D4A10A141F025F425A9B89@BL0PR11MB3252.namprd11.prod.outlook.com>
Date:   Thu, 14 Oct 2021 15:08:10 +0200
Message-ID: <87zgrb69fp.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Oct 14 2021 at 08:21, Jing2 Liu wrote:
>> 
>> Once that is sorted then we can create proper infrastructure for that in the
>> FPU core code and not just expose a random function to KVM and hack it into
>> submssion.
> Yes, we need a consensus on the way we choose and then to see if need a
> kernel function for KVM usage.

The question is not 'if'. The question is 'which' functionality we need.

Thanks,

        tglx
