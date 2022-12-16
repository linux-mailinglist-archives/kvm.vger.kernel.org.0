Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 132F464E684
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 04:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230096AbiLPD61 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 15 Dec 2022 22:58:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbiLPD6Z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 15 Dec 2022 22:58:25 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A594AF19;
        Thu, 15 Dec 2022 19:58:25 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1161664pjj.4;
        Thu, 15 Dec 2022 19:58:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uaxgo5LlIOi0S9JhLYqDMZ4gD6Tc+L6skMURu3UvP5M=;
        b=VhKJWMt/vBbVHTOsROGaTOiEgWFUEkhaYjOnufZYir75TQ1WusnkY8EayMfHzsOIHM
         MI9f1yV5IvtPNbGxgpeL5G25+BhhGZcoSOQAw7tCQznHWT46Zbr6aa/fAgpnB6q6WVlH
         tnKzteOV0o9ac11RfS0XPTIqRXrin9XIvWWYXDomMjAW4Yt7VwaXR7QR0udOPfD84rlY
         b8ebobqKHhSF5c217HYTCAu5MxYLNT17uD7PPPUcBCLttBp5nYoxvcxtjlZyfL5edYNF
         DTZVP8IfOyc8kjqWLYwipHwKAOFFk23xcVwcrX1/80ktMo8/n5/vfoD1hABfFATe3u+s
         h1gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uaxgo5LlIOi0S9JhLYqDMZ4gD6Tc+L6skMURu3UvP5M=;
        b=Aqm+f7BELEuCYcczv17DZs5Uze4/4mEZyWJq3kYNnUkTwS/MkjTmoijOik4y1/LqfD
         zYyuCkkrJbA8pZt1Lx/uNrpoyk4a+nisEbVsUKv/AuxEXNHDH02KP9hQ1+x31vwh9sOc
         /qeURm+ulJhk+i1u0+JieY0EVuQvYANzmfptrEsQINmKRXtIdf+UGgoLKZExdNtVT/Wh
         Nlcu9v9+RLngw7YGRkD0HUhJrTELCiUCGuj0N1IPpM0fnP/JgUSY9mVkC0MxZ8AsTVQA
         fULqFdijUFSwAf9oV+Ifyb6pc8F0tHsI9SaxIo3OU4U7U3lGRSIeuexfyv8SpPhVFfw7
         81Dw==
X-Gm-Message-State: ANoB5plhc+HKx+KUu5KQg9PU5jeNHRv33Tt2kbFczsZot6JtzoRmUcjg
        yVM6LbComgKVYuz2FNeJXpVDZYRtkeA=
X-Google-Smtp-Source: AA0mqf5T364XIYvr0zuGPJhY9BDJUvUGHREqsmLjaIaY2M9pI3/LXv6EP0TdJcMdcaeWGGea7BLTEg==
X-Received: by 2002:a17:902:e811:b0:189:d8fb:152d with SMTP id u17-20020a170902e81100b00189d8fb152dmr44450718plg.25.1671163104670;
        Thu, 15 Dec 2022 19:58:24 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id v17-20020a63d551000000b00477bdc1d5d5sm499680pgi.6.2022.12.15.19.58.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Dec 2022 19:58:24 -0800 (PST)
Date:   Thu, 15 Dec 2022 19:58:23 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Binbin Wu <binbin.wu@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v10 106/108] Documentation/virt/kvm: Document on Trust
 Domain Extensions(TDX)
Message-ID: <20221216035823.GE527635@ls.amr.corp.intel.com>
References: <cover.1667110240.git.isaku.yamahata@intel.com>
 <fcf376f0f7703d06b6e7466e95cea624b58f746a.1667110240.git.isaku.yamahata@intel.com>
 <faf65da9-aeb4-d7b2-0e60-995848e47d14@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <faf65da9-aeb4-d7b2-0e60-995848e47d14@linux.intel.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Nov 25, 2022 at 11:49:08AM +0800,
Binbin Wu <binbin.wu@linux.intel.com> wrote:

> > +New KVM API, ioctl (sub)command, to manage TD VMs
> > +-------------------------------------------------
> > +Additional KVM API
> API -> APIs
> >   are needed to control TD VMs. The operations on TD
> > +VMs are specific to TDX.
> > +
> > +- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP
> > +
> > +  Although not all operation isn't memory encryption,
> 
> How to understand it?
> 
> 
> > repupose to get

How about the followings?

New KVM API, ioctl (sub)command, to manage TD VMs
-------------------------------------------------
Additional KVM APIs are needed to control TD VMs. The operations on TD
VMs are specific to TDX.

- Piggyback and repurpose KVM_MEMORY_ENCRYPT_OP

  Although operations for TD VMs aren't necessarily related to memory
  encryption, define sub operations of KVM_MEMORY_ENCRYPT_OP for TDX specific
  ioctls.

  Pros:

  - No major change in common x86 KVM code.
  - Follows the SEV case.

  Cons:

  - The sub operations of KVM_MEMORY_ENCRYPT_OP aren't necessarily memory
    encryption, but operations on TD VMs.


-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
