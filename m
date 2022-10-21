Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56BD5607E69
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 20:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiJUSwD (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 14:52:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiJUSwC (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 14:52:02 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6190A261AEE
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:52:01 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id y1so3412621pfr.3
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 11:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N0CFaj+32/8x14w0nQ4TONmFGJUAgn8Stv8tbUzSYSA=;
        b=TKIaJH00umzCFjhoIJEmiPXrVnvyGPAZndTo8T/0WU+clyeTWc38ZL5O674zHv48Cs
         SlGLhdOca/TNkAskyGDivJ7XcNQeWKga4ktnmP9Js9cE2xnJFDzd59Q/9lkz4yQlohI2
         xlR6tzM50IBymsKBVSRulmUWKTPJQ0UCmhQUPg4AnFYm9LGQATwazSHAj7JMqH/j1AOa
         VjXhPOWnD6lIVEe3bR9eWp7c4gzhFk1LTSh0RMwtyW2ANEzRzm12MeT8GWIL0wWhPcEe
         kyMdh9qJy8e4N/rBAT/6jx2GMPqRbYXBlynWBnOon/h9JBvNZDKckQ3EcOKNfjCwo1tT
         43iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N0CFaj+32/8x14w0nQ4TONmFGJUAgn8Stv8tbUzSYSA=;
        b=z8QuXiQBVqevTPEj0QNae8inJfHCHsx5s5PfnvQnfndEhZ3XOQ1DqvV21mFW3sOiHa
         Qa1D8+egzCrDwz6A2M9sKwwZnG9lks2hL3oWl8v0Vf1kA5NX3HGH21f6cJ9uz4goFmLr
         iFfr1W+50Xqu3pouqykqA1msL3cG6VFl9QTb9jwf+QBo5EGmDiN3yeEugabYOy53vK0q
         gw+5mU9QT2odBhk71UGpXlhf1Dnv/EumDRZk2JDA3E4tnSpQwhOI/ou1YAkz3If1Rhpn
         Se3sJY5JcvHHnlarwHsDe8/nxog2J5zeo5wgJ0BYju+DUVK1ZNCc+xnUl495Epk64/m/
         di7Q==
X-Gm-Message-State: ACrzQf0Ye2eCYpZjipR8ys7xza9MSxNjdp66+ydlZJ77FGaVqCKgTqB7
        3vacpaKcsx9r2NQ/uP+b0ckIuw==
X-Google-Smtp-Source: AMsMyM5ZvJuhxcPkXdV1QBD4lepmJgO6t5Ah6Gkbm7nufbSF2Ycv25dfW2p6ZT4zlzw5QjM1PZgBhA==
X-Received: by 2002:a05:6a00:1947:b0:565:c337:c53b with SMTP id s7-20020a056a00194700b00565c337c53bmr20830243pfk.10.1666378320748;
        Fri, 21 Oct 2022 11:52:00 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e81200b001866eeacd53sm3048439plg.17.2022.10.21.11.52.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 11:52:00 -0700 (PDT)
Date:   Fri, 21 Oct 2022 18:51:56 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Like Xu <like.xu.linux@gmail.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests PATCH v2] x86: Add tests for Guest Processor
 Event Based Sampling (PEBS)
Message-ID: <Y1LqTKrJhDOS7pcm@google.com>
References: <20220728112119.58173-1-likexu@tencent.com>
 <Yz3XiP6GBp95YEW9@google.com>
 <fe9d582b-aae0-d219-863a-dbdca988e1d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe9d582b-aae0-d219-863a-dbdca988e1d6@gmail.com>
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

On Tue, Oct 18, 2022, Like Xu wrote:
> Most of the comments will be addressed in the next version.
> 
> On 6/10/2022 3:14 am, Sean Christopherson wrote:
> > On Thu, Jul 28, 2022, Like Xu wrote:
> > > +#include "vm.h"
> > > +#include "types.h"
> > > +#include "processor.h"
> > > +#include "vmalloc.h"
> > > +#include "alloc_page.h"
> > > +
> > > +#define PC_VECTOR	32
> > 
> > PC?
> 
> Part of legacy code, may be "performance counter vector" ?

Ah, it comes from the LVT Performance Counter Register".  

> It will be reused in the new lib/pmu.h.

Any objection to renaming it to PMI_VECTOR?  That's much more familiar for KVM
developers and it's still correct, e.g. it's the PMI vector that's programmed into
the LVT PC register.
