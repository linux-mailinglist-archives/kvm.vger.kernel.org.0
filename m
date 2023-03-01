Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A4C6A6456
	for <lists+kvm@lfdr.de>; Wed,  1 Mar 2023 01:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCAAkn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Feb 2023 19:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbjCAAkm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Feb 2023 19:40:42 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4944B3527E;
        Tue, 28 Feb 2023 16:40:41 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id m20-20020a17090ab79400b00239d8e182efso4700750pjr.5;
        Tue, 28 Feb 2023 16:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677631241;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=4Q3dbKi+iyhH5ZZDJD+GAAG/A6eK/g9uSDVx6w0hSwg=;
        b=Xpmi6CRfthY08AnlRZDjcGId7TzbCCS48tU2AzkgYiLtR3Q+E48dSmUUKJYrykUqfh
         8ErO/AACdZVxo+b8ZlaxXX6XBTuovdMYEinUiRz93IjLbmDpGbkofRGL2MYrMLjmns5G
         xzXBHlLDrntJDH5Z1NxEd73iZLQZXfnE+DT1gEy8ueYzh8+a9gtmqXDMAY0xqz20vTdt
         +1c5TOyovejIT2vZsSKNSQz/cFmu9uo4RHkDgYjRRUecTFFVBE/dktqxfUwAOHLquhY8
         bY5YGt0//aCtgpVMbQlveTrOKssfqorEcdAAm9rNUBn5tKmGoR5iHDF/88FDuFvPsT0b
         PFwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677631241;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4Q3dbKi+iyhH5ZZDJD+GAAG/A6eK/g9uSDVx6w0hSwg=;
        b=PAD2EytAiy9zD0Gsvye1Up/JrLN0IYlEWkCgPgmBzfNM4zyBZcjQVa/amHxJlmz3gU
         jFPcy+HGvPFcKX/V2Z6ofJipaVwDbXDcoR6U6TcV9erNJSd3r/1QzMvndqxDAZXjTeMj
         z+JJ4L8gjMx4jtbPhFeK9881POzyooc6U8V+I0ou46ma+PSVwwqC2zb5i2x6PKIXd8EG
         M+Yf2P3/aMzKwROgbEjCzFqNZtr8amU07lFaUbe6szFBd+RS3OuemtFw3pHHjOQC4vCp
         tih9Y59+DQrdSK7Fgap4yelFhyqCE2lzS2V3JjCm5uJMD55Qwc8Hh1vZXKFhioj03D9+
         FARg==
X-Gm-Message-State: AO0yUKWWFWUHEdzZd+JWbdo0JPWhDDEW6WOf2i3zV9284VB1IfOPunq3
        6ftLXfVyFgztRAEYsFGoaPZVfhmXqwQ=
X-Google-Smtp-Source: AK7set+Ws4NkaRxDduxG608VbhOHpVlLn3M5w/RoRGwXSSFzolU1t9kfBtqs7MwiO3qRCgO2f+hpOQ==
X-Received: by 2002:a17:903:4308:b0:19c:bb8e:bf76 with SMTP id jz8-20020a170903430800b0019cbb8ebf76mr3705181plb.68.1677631240635;
        Tue, 28 Feb 2023 16:40:40 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id v1-20020a1709028d8100b00194d2f14ef0sm7084381plo.23.2023.02.28.16.40.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Feb 2023 16:40:40 -0800 (PST)
Date:   Tue, 28 Feb 2023 16:40:38 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "isaku.yamahata@gmail.com" <isaku.yamahata@gmail.com>,
        "Christopherson,, Sean" <seanjc@google.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Aktas, Erdem" <erdemaktas@google.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "dmatlack@google.com" <dmatlack@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Message-ID: <20230301004038.GB3852341@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
 <5f9870acec07c47de5bab460c8c0d4a2c0db08fc.camel@intel.com>
 <20230227212605.GF4175971@ls.amr.corp.intel.com>
 <bdf8b2e1aa52ae8f4d5e2a6c92e0f8e426b97234.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bdf8b2e1aa52ae8f4d5e2a6c92e0f8e426b97234.camel@intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Feb 28, 2023 at 09:57:50PM +0000,
"Huang, Kai" <kai.huang@intel.com> wrote:

> On Mon, 2023-02-27 at 13:26 -0800, Isaku Yamahata wrote:
> > > > TDX attestation includes the maximum number of vcpu that the guest can
> > > > accommodate.  
> > > > 
> > > 
> > > I don't understand why "attestation" is the reason here.  Let's say TDX is
> > > used
> > > w/o attestation, I don't think this patch can be discarded?
> > > 
> > > IMHO the true reason is TDX has it's own control of maximum number of vcpus,
> > > i.e. asking you to specify the value when creating the TD.  Therefore, the
> > > constant KVM_MAX_VCPUS doesn't work for TDX guest anymore.
> > 
> > Without TDX attestation, this can be discarded.  The TD is created with
> > max_vcpus=KVM_MAX_VCPUS by default.
> 
> This parses like: 
> 
> If we have attestation, the TD can be created with a user-specified non-default
> value.  Otherwise, the TD is always created with default value.
> 
> It doesn't make sense, right?
> 
> Because architecturally whether TD can be created with a user specified value
> doesn't depend on attestation at all.

I'm not sure if I got your point.
Even without attestation, it's allowed to specify max vcpus.   Not "always".
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
