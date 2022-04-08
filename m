Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFB434F8E7B
	for <lists+kvm@lfdr.de>; Fri,  8 Apr 2022 08:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiDHDgE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 7 Apr 2022 23:36:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230133AbiDHDgD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 7 Apr 2022 23:36:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBB41D2B47;
        Thu,  7 Apr 2022 20:34:00 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q142so6658799pgq.9;
        Thu, 07 Apr 2022 20:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dw+ROn8RvBkqEEh4rGoMJ1WVteSRDkuc1/T16Z5qZMc=;
        b=EeBrjzYK8SkX1OqjP+i4bvgZKa+egv6bbbX6Xseqd75gu8/cTyTmEKI66pcq42X4Tt
         jUu+tdejhl+pgRUDFf3ekJue/654i8tzbQvbIqOElao4jnOElmCskBymalqtkaTdS7td
         4B41UNZxOQSsBUXzZI7JAuypNaXHFhb90Int7OPOhfDVDz7wMoiEOiUf8ka6R2+Qk7H0
         2SHBCSD0e181CRTA+6Ww96XYGQD6xsDEiQ/BlD4kvrq4ITL/TcB1KFDGKNft7l/ycYcC
         l666RQJjkeA7+bKN3J4WOGxeH8isiZMHyGn8NoU+Am/JyeLwRLmzOppBIF6BOofCi9mi
         IqdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dw+ROn8RvBkqEEh4rGoMJ1WVteSRDkuc1/T16Z5qZMc=;
        b=mJF17z/z7me98J0N1Piupk6WPYhieZxg7exRZwf8Y1nT5jcHiBPslDK3t7L3gBZRlv
         g4mLYYKm9XNh4TF4mxtn4TPEr1tYL0kMv9Nf3TnewmqOhRME5ArucHNXJkONCtdzn80Z
         HT50FuVZXOrT2RwBRBWWrhXNcc6vviRa0aLFYGxM9LCMDrXizj5fkGMijBwSgxU0r27H
         yoQfgXfZb/UE9hi/0RxB7/eiXuD4MBvfM/+kzMg3mZwHhiH74dZSqNusupijoMTY/hT1
         3zCHgGwXBhs2L8LQ/y/HKxYPOT9SOq+gZW3YRaLfZJRI/RQaSFPBVnAMphfyBDhZPqAF
         YBfw==
X-Gm-Message-State: AOAM531Y/eV58Ja8e7DILfILX1GTcKqETKxfheeq0yqXMQaOA2V32EC5
        jC2Jfmior7DPo2sA7iMuQjk=
X-Google-Smtp-Source: ABdhPJw2JVZSjgvThPvGb8qxgxHfxjyJ37Kl9thDcERfEhZZSRsH+ojMV4RqYMA6JgZqguQ1nXD3wg==
X-Received: by 2002:a63:f24c:0:b0:383:c279:e662 with SMTP id d12-20020a63f24c000000b00383c279e662mr13907253pgk.303.1649388839948;
        Thu, 07 Apr 2022 20:33:59 -0700 (PDT)
Received: from localhost ([192.55.54.52])
        by smtp.gmail.com with ESMTPSA id r10-20020a17090a454a00b001c96a912aa0sm10618624pjm.3.2022.04.07.20.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Apr 2022 20:33:59 -0700 (PDT)
Date:   Thu, 7 Apr 2022 20:33:57 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Kai Huang <kai.huang@intel.com>
Cc:     Xiaoyao Li <xiaoyao.li@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, isaku.yamahata@intel.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        isaku.yamahata@gmail.com, Jim Mattson <jmattson@google.com>,
        erdemaktas@google.com, Connor Kuehl <ckuehl@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [RFC PATCH v5 027/104] KVM: TDX: initialize VM with TDX specific
 parameters
Message-ID: <20220408033357.GF2864606@ls.amr.corp.intel.com>
References: <cover.1646422845.git.isaku.yamahata@intel.com>
 <c3b37cf5c83f92be0e153075d81a80729bf1031e.1646422845.git.isaku.yamahata@intel.com>
 <e392b53a-fbaa-4724-07f4-171424144f70@redhat.com>
 <a1052ec0-4ea6-d5db-a729-deec08712683@intel.com>
 <34d773c8d32c8d38033aae7e0fee572d757e242c.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34d773c8d32c8d38033aae7e0fee572d757e242c.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Apr 07, 2022 at 01:51:38PM +1200,
Kai Huang <kai.huang@intel.com> wrote:

> On Thu, 2022-04-07 at 09:29 +0800, Xiaoyao Li wrote:
> > On 4/5/2022 8:58 PM, Paolo Bonzini wrote:
> > > On 3/4/22 20:48, isaku.yamahata@intel.com wrote:
> > > > +    td_params->attributes = init_vm->attributes;
> > > > +    if (td_params->attributes & TDX_TD_ATTRIBUTE_PERFMON) {
> > > > +        pr_warn("TD doesn't support perfmon. KVM needs to save/restore "
> > > > +            "host perf registers properly.\n");
> > > > +        return -EOPNOTSUPP;
> > > > +    }
> > > 
> > > Why does KVM have to hardcode this (and LBR/AMX below)?  Is the level of 
> > > hardware support available from tdx_caps, for example through the CPUID 
> > > configs (0xA for this one, 0xD for LBR and AMX)?
> > 
> > It's wrong code. PMU is allowed.
> > 
> > AMX and LBR are disallowed because and the time we wrote the codes they 
> > are not supported by KVM. Now AMX should be allowed, but (arch-)LBR 
> > should be still blocked until KVM merges arch-LBR support.
> 
> I think Isaku's idea is we don't support them in the first submission?
> 
> If so as I suggested, we should add a TODO in comment..

Sure, will add a TODO comment.

-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
