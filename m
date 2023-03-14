Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAEB76B9CC1
	for <lists+kvm@lfdr.de>; Tue, 14 Mar 2023 18:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjCNRQI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 14 Mar 2023 13:16:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjCNRQH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 14 Mar 2023 13:16:07 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373021F4B5;
        Tue, 14 Mar 2023 10:16:06 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id h8so17303580plf.10;
        Tue, 14 Mar 2023 10:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678814166;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=laWpBcMzHhjKIPT4w7M0mFNNEaB3TmbvAAxRcUnp1HE=;
        b=pkbJFadmC1NoeD3YNWnA/5JGq8Kf5dJwO46GyxYB2OrMy2jL+7nO8lBd0UimP2SahT
         k1eKCE5zPgQKu9guqKTEFA58ohGvugkaTNTLpvjOEEgmBrTU9zcJwqcnd0r32TwyTYCI
         kUtF9MigeEvTCYfb9k4fBEM4d2DkWMQtUyOpzCgY9vVSgX0bK4hoa6aUJ9Zb1agMfyyz
         feyXtiffNOGQnSgnYIj6Wn8xADF7f+RQ3AwdzjDrBdQB3wGgxTfM+l6q5BFrwpHuo/dE
         7otytjwuJnt++ymLg7kc51koMGDA5gh/pAq7dkpGbV6tmAbhi9VEv+CZD78OX00ggxYs
         7sIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678814166;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laWpBcMzHhjKIPT4w7M0mFNNEaB3TmbvAAxRcUnp1HE=;
        b=5CJvcRDNv3OpmuWw94EV7tBhCdlGYWCE8cSjnxi5Q+IOMtozelNE/QuMPjia0SiyAD
         P6wmfREOugjgOkG3MMyP8W6+EgkTgwPNAEI9UxwHXRKOSKgXIYeFlHkIisATiGVpUcH+
         B3IRbCbKkBRVrEK85gKjeR4n4AjEyZYIh2AI5qhAzvMeifdHCVcHY25HSpa6iIwIVp+c
         e0Bx8T7K4VZHzLPnxXoxVsNPE8iT01eDOmlV/p/uG8jZPP3nXzFeiZKmHVLSIO/dfQjr
         KEdd5zsXUG6W+iFI8ZTqz5k33RFuzlDzd0i4upsA9fjsa7J3rrh+S90YVCzDHIOJNpwh
         WJhA==
X-Gm-Message-State: AO0yUKUsqLz6S21hta6AmjghyIMpnp11qeZyAiD4S0KBmzdWzdbzHwm7
        g0VctcxhUj9oiadKSXYGXGs=
X-Google-Smtp-Source: AK7set8HH4/ZpBw6aqoaMvhv39/BwFyJarg+B8aRPYEF39d4sSrzalafr8SZGsyoXNQ1BBAIgB/IRQ==
X-Received: by 2002:a17:90b:3c49:b0:237:5a3c:e86c with SMTP id pm9-20020a17090b3c4900b002375a3ce86cmr38367746pjb.24.1678814165327;
        Tue, 14 Mar 2023 10:16:05 -0700 (PDT)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id my13-20020a17090b4c8d00b002339195a47bsm1978761pjb.53.2023.03.14.10.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 10:16:04 -0700 (PDT)
Date:   Tue, 14 Mar 2023 10:16:03 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Isaku Yamahata <isaku.yamahata@gmail.com>,
        "Huang, Kai" <kai.huang@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "david@redhat.com" <david@redhat.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v10 05/16] x86/virt/tdx: Add skeleton to enable TDX on
 demand
Message-ID: <20230314171603.GE3922605@ls.amr.corp.intel.com>
References: <cover.1678111292.git.kai.huang@intel.com>
 <f150316b975b5ca22c6c4016ffd90db79d657bbf.1678111292.git.kai.huang@intel.com>
 <20230308222738.GA3419702@ls.amr.corp.intel.com>
 <96b56c5b8a5876aaf6d5ccbb81bab334b10983eb.camel@intel.com>
 <20230313234916.GC3922605@ls.amr.corp.intel.com>
 <a62497059fc3f31706a532b822d6c966bd981468.camel@intel.com>
 <20230314040200.GD3922605@ls.amr.corp.intel.com>
 <902b0166-6156-8def-a7a3-f0ce8995fa9c@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <902b0166-6156-8def-a7a3-f0ce8995fa9c@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 13, 2023 at 10:45:45PM -0700,
Dave Hansen <dave.hansen@intel.com> wrote:

> On 3/13/23 21:02, Isaku Yamahata wrote:
> >> Then it is a hidden behaviour of the TDX module that is not reflected in the
> >> spec.  I am not sure whether we should handle because: 
> >>
> >> 1) This is an extremely rare case.  Kernel would be basically under attack if
> >> such error happened.  In the current series we don't handle such case in
> >> KEY.CONFIG either but just leave a comment (see patch 13).
> >>
> >> 2) Not sure whether this will be changed in the future.
> >>
> >> So I think we should keep as is.
> > TDX 1.5 spec introduced TDX_RND_NO_ENTROPY status code.  For TDX 1.0, let's
> > postpone it to TDX 1.5 activity.
> 
> What the heck does this mean?
> 
> I don't remember seeing any code here that checks for "TDX 1.0" or "TDX
> 1.5".  That means that this code needs to work with _any_ TDX version.
> 
> Are features being added to new versions that break code written for old
> versions?

No new feature, but new error code. TDX_RND_NO_ENTROPY, lack of entropy.
For TDX 1.0, some APIs return TDX_SYS_BUSY. It can be contention(lock failure)
or the lack of entropy.  The caller can't distinguish them.
For TDX 1.5, they return TDX_RND_NO_ENTROPY instead of TDX_SYS_BUSY in the case
of rdrand/rdseed failure.

Because both TDX_SYS_BUSY and TDX_RND_NO_ENTROPY are recoverable error
(bit 63 error=1, bit 62 non_recoverable=0), the caller can check error bit and
non_recoverable bit for retry.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
