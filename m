Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F21E66AA84
	for <lists+kvm@lfdr.de>; Sat, 14 Jan 2023 10:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229954AbjANJir (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 14 Jan 2023 04:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230090AbjANJik (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 14 Jan 2023 04:38:40 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6111BE;
        Sat, 14 Jan 2023 01:38:38 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id bp15so36332197lfb.13;
        Sat, 14 Jan 2023 01:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtg6HxGfvTpuQSGOT0JtHX38Qw/8TZGzOEiMub6DYM0=;
        b=YIoKNlxYYrHgAc/YoXlVUeE0MVte0t4e2xmpiiyDoLc/L7aGaCxEbA1vOUiGNZQj8S
         FQj0cOseSSvf4yYsTHT+9TrVkSf2p3052RtHQ8Ildrlyxu/RU/n352/WY1FqihG9YLw8
         l2K11u91sFkIRw1sk8+ojlBFqigBgwQFHP/L19nTQFUz6DadgHRUMhhCwOTAEHk4rSkT
         SDBYfmWoIoFKtR9ZL7F1MaMfs+Q20F21s65ntxJGex2MtS1qBR8iXm4kOx2wvgOoQYhs
         myEQ7j5cI+c5RhAIiIyW0DkrCzrlOmwTrJ7NcoPRfoHfN5+uAorqwp12utnxEFU25fuK
         Tung==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtg6HxGfvTpuQSGOT0JtHX38Qw/8TZGzOEiMub6DYM0=;
        b=ywSJZcOxTF9FV6G3iI63QQXvf6MiMYjBHwahhWpfkIqsDYQmbY586gtlj6rZWgBTl+
         2F7cX2E0RKqWYWLDT5hYUbvEt5HmCHnp0nai18Zv14bjhGar80RdfCsK27TaRdUfyDf1
         OLYp9ry1ivnvU8HqkJIwyIKUGKcgD4Rq3K6/hdYBvAHkux/h07Fx1tyyH26JA82zt76V
         53GF4RDQXz+Wr7gnEmkedfIoRhSfb9Qr8se9hzY7Y0wY1HVBTZIryDd4R8Us4ZeeGz0Q
         iG/Hv56pgHn1JFJFYMOH4Krrzp9EpSffKgIVji7yZui+Ssst7CpMYpoKnGYypR/OAlnn
         0Msg==
X-Gm-Message-State: AFqh2kpnWapgTJhT1kogduhp9hkWX+OSr55cxwV8fbns215CWB9IQSej
        s7VTD0BHdJfW3kVaKizjfKI=
X-Google-Smtp-Source: AMrXdXt57usTEIj2fGbi21EawRMoNo1Q8PcmqQ9EheUJb0Jkmc84Rcj8Cakpz4KPg0iuJqbLGgUamQ==
X-Received: by 2002:ac2:5313:0:b0:4d2:a03b:2840 with SMTP id c19-20020ac25313000000b004d2a03b2840mr252252lfh.4.1673689116910;
        Sat, 14 Jan 2023 01:38:36 -0800 (PST)
Received: from localhost (88-113-32-99.elisa-laajakaista.fi. [88.113.32.99])
        by smtp.gmail.com with ESMTPSA id f27-20020a2eb5bb000000b0027fd72dd6a1sm767947ljn.70.2023.01.14.01.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 01:38:36 -0800 (PST)
Date:   Sat, 14 Jan 2023 11:38:35 +0200
From:   Zhi Wang <zhi.wang.linux@gmail.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 013/113] x86/cpu: Add helper functions to
 allocate/free TDX private host key id
Message-ID: <20230114113835.0000019e@gmail.com>
In-Reply-To: <Y8F3Eo2lKB4hupQI@google.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
        <241994f1f6782753f3307fe999a3dad434477c16.1673539699.git.isaku.yamahata@intel.com>
        <20230113144712.00006f41@gmail.com>
        <Y8F3Eo2lKB4hupQI@google.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 13 Jan 2023 15:21:54 +0000
Sean Christopherson <seanjc@google.com> wrote:

> On Fri, Jan 13, 2023, Zhi Wang wrote:
> > On Thu, 12 Jan 2023 08:31:21 -0800 isaku.yamahata@intel.com wrote:
> > > @@ -132,6 +136,31 @@ static struct notifier_block tdx_memory_nb = {
> > >  	.notifier_call = tdx_memory_notifier,
> > >  };
> > >  
> > > +/* TDX KeyID pool */
> > > +static DEFINE_IDA(tdx_keyid_pool);
> > > +
> > > +int tdx_keyid_alloc(void)
> > > +{
> > > +	if (WARN_ON_ONCE(!tdx_keyid_start || !nr_tdx_keyids))
> > > +		return -EINVAL;
> > 
> > Better mention that tdx_keyid_start and nr_tdx_keyids are defined in
> > another patches.
> 
> Eh, no need.  That sort of information doesn't belong in the changelog
> because when this code is merged it will be a natural sequence.  The
> cover letter explicitly calls out that this needs the kernel patches[*].
>  A footnote could be added, but asking Isaku and co. to document every
> external dependency is asking too much IMO.
> 
> [*] https://lore.kernel.org/lkml/cover.1670566861.git.kai.huang@intel.com

Hi:

Thanks. I raised this concern from the reviewers' perspective. For example,
finding something was missing, grep, nothing was found, and jumping to
another window and grep. 

Finally, you can make sure if missing tdx_keyid_start in the patch is a
mistake or a dependency. Then the same happens on nr_tdx_keyids.

It would be nice to just say tdx_hkid_start, nr_tdx_keyid requires an
external patch in the comment. Or, just mention this patch depends
on an external patch in the comment. It will save quite some efforts.
