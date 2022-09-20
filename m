Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEDD15BEBB3
	for <lists+kvm@lfdr.de>; Tue, 20 Sep 2022 19:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiITRQj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 20 Sep 2022 13:16:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiITRQi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 20 Sep 2022 13:16:38 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF97F4DB35
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:16:37 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q9so3302068pgq.8
        for <kvm@vger.kernel.org>; Tue, 20 Sep 2022 10:16:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Rij+pAdZG93DLyUN4lOyVYXvdWWBdU7yElR3oGxp4tI=;
        b=CoF2DL5FVziXAZnzwH3p7raTKDhzs5MGPnXVMka+FwlJeN7fHYRF2PKliF1g0LO2p3
         NaKA/erFgYz6ac2pqlM4ev/IhmPgHClhdeDrt1+9KbxYmigQIQ4uWeYe9NJt1mhkso2g
         DXjBtMMm+66ZS8weTC5uErPZdONGQ/j2FiJy1EZW9BrzdcpMLzAxDr9o7x5t4H5Z+Hz+
         d1Y8gm0vptqWpD2zmy1XVE9FAaOEl59hb8TAfn3fDMzBINfyMwCNt6bKuaKuMpMvA8ai
         Hi0aQN2JDw7o0halw48MKMUGMwvhMaBNm3eQFS7qKFfHeS/70+Qx/DcdWhlAM+aXUVsr
         L9wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Rij+pAdZG93DLyUN4lOyVYXvdWWBdU7yElR3oGxp4tI=;
        b=H0oTMfFl6Lo2HKLc3P/BO76cL4xyOvmvoAjmqstb55rTUIyzjuS3DwlBh7D/H6rSBF
         hS4iib4c1P8JQB+JtFeHJBcgBV21hpzzFYtkUhCVlWcItx4nHk7O1swn5aKJRmcMVbXS
         l7iYver4EsJu+YaJoUYiavFM+Ef6VLIt1GJt3Z1aMuGfFEPM6pmII2vHSTX1iW1ThJ4D
         Ge9eOicPaU//R/atKynZG0NenRLC9TbU87LGnBTSbEGtvW7Tw9SaEKPDg9lQVUIPM8ws
         DaYQRuNk+zcyjPt6XR9c0QwmJM+Zoz3eQ1ORHgGeHNp/4Jjdct2f9urAXWb4sK8yl6Aq
         kbCw==
X-Gm-Message-State: ACrzQf1IPykAHJfDbN67ycf1t+szLMPuW5WkaDyYwU4Weejo9JQNOCZ1
        aaYg/T84UtPyml+4YJlkEBJSah3AYygBQQ==
X-Google-Smtp-Source: AMsMyM56Vb6dmBkRmbK7gYA61Cui0gCYhcUYRs+HAXPb9xvszvLbViNd61Un/2fYJ+/q/1qOhggfHg==
X-Received: by 2002:a05:6a00:139b:b0:540:de3c:cf9d with SMTP id t27-20020a056a00139b00b00540de3ccf9dmr24896169pfg.54.1663694197079;
        Tue, 20 Sep 2022 10:16:37 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e5c400b0016cf3f124e1sm122496plf.234.2022.09.20.10.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 10:16:36 -0700 (PDT)
Date:   Tue, 20 Sep 2022 17:16:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     David Matlack <dmatlack@google.com>
Cc:     "Huang, Kai" <kai.huang@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "peterx@redhat.com" <peterx@redhat.com>
Subject: Re: [PATCH v2 01/10] KVM: x86/mmu: Change tdp_mmu to a read-only
 parameter
Message-ID: <Yyn1cL4dviXwTqXA@google.com>
References: <20220826231227.4096391-1-dmatlack@google.com>
 <20220826231227.4096391-2-dmatlack@google.com>
 <2433d3dba221ade6f3f42941692f9439429e0b6b.camel@intel.com>
 <CALzav=cgqJV+k5wAymUXFaTK5Q1h6UFSVSKjZZ30akq-q0FNOg@mail.gmail.com>
 <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALzav=cuwyFTn6zz+fJqjKNs6XYx2-N61sgMQ9K5C-Z=a4STZg@mail.gmail.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Sep 20, 2022, David Matlack wrote:
> On Thu, Sep 1, 2022 at 9:47 AM David Matlack <dmatlack@google.com> wrote:
> > On Tue, Aug 30, 2022 at 3:12 AM Huang, Kai <kai.huang@intel.com> wrote:
> > > On Fri, 2022-08-26 at 16:12 -0700, David Matlack wrote:
> [...]
> > > > +#else
> > > > +/* TDP MMU is not supported on 32-bit KVM. */
> > > > +const bool tdp_mmu_enabled;
> > > > +#endif
> > > > +
> > >
> > > I am not sure by using 'const bool' the compile will always omit the function
> > > call?  I did some experiment on my 64-bit system and it seems if we don't use
> > > any -O option then the generated code still does function call.
> > >
> > > How about just (if it works):
> > >
> > >         #define tdp_mmu_enabled false
> >
> > I can give it a try. By the way, I wonder if the existing code
> > compiles without -O. The existing code relies on a static inline
> > function returning false on 32-bit KVM, which doesn't seem like it
> > would be any easier for the compiler to optimize out than a const
> > bool. But who knows.
> 
> Actually, how did you compile without -O and is that a supported use-case?

Eh, IMO whether or not an unoptimized build is supported is moot.  KVM already
uses "#define <param> 0/false", e.g. see enable_sgx, I don't see any reason to
employ a different method.
