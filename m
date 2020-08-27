Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD997254A1D
	for <lists+kvm@lfdr.de>; Thu, 27 Aug 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbgH0QBT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Aug 2020 12:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgH0QBR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Aug 2020 12:01:17 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D53C061264;
        Thu, 27 Aug 2020 09:01:17 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b14so6335526qkn.4;
        Thu, 27 Aug 2020 09:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8moOsqRnYIhz4ZttMW9zwcBUEs7klx/rrFKF2mMjY8s=;
        b=OYZTMqQJaSZueJVUNgDzpIsruyaBu+TLAQQdPAiItmnBT0Q8V/rihSpvpJcEUthbc6
         geBvAlOovV3Ci6jklaFysg/H+C1ATiiH390HryGB1FmK5IsI24tgmgWVdrvtIDp5oHa0
         0cIgc//70fiGXQuSM9otGWtsqS6fz9ddgNnBdeiTirTQ88KlzI7WT9xedMHnfLGGwRKR
         UpXpnXkqjhNvJIbfTJgefsYcbCModlIQaGKvZE/VT56UQJiPEHYQPHqdxSvDxVRlKuyY
         yqKywcMW9HlFYFN/P1EL0KZLOdiLEFvpy09wpXWlqUeMc0747ziToJPe79hIWxO3BYqF
         caTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8moOsqRnYIhz4ZttMW9zwcBUEs7klx/rrFKF2mMjY8s=;
        b=icR02EI1yyEH1Fy0Wlt3nyS0JHiDUDoa7GM4kP0KkDC/VW0avo+dG+i0bDbRCyLlGm
         YjwBaiQ6ZX8/v9uHRy9KQWttdHBGJfw+K4oHIx/LFTGu2hSINcDKixy4sEDuVfRsXIKi
         leYPmmPp5DPjhBtruwfc21vAnKJSrMPXtCUTow+lVKuz/JKUou9wLWGJlUMczDsdVCwg
         LUe4YA5lY6xM6kXdG89x9wpwtc5/MQPPu/X78EFUuyIrEZq7vge/N8E/LLIchJd1uF23
         M0wyeztEnco0CcLBJINj1KplbD96rxlsPnXHdoU4CXX6X0No1xNGtY99b48EZZPigHDW
         rmQA==
X-Gm-Message-State: AOAM531uoAINV3wvoKZmb9kdujJs6bledqLteJvf2deSIaBLs6wOKPi8
        BeDtN3Hyzt9Vedo2S3YR0r4=
X-Google-Smtp-Source: ABdhPJzdZ+ZP5PyVj/QsANQkew3oPOWo8PnejboP8Zc8k+cK1AZVqg4lvdxOYROjb+F7t8I2zaySgw==
X-Received: by 2002:a37:9ad4:: with SMTP id c203mr4792839qke.420.1598544076808;
        Thu, 27 Aug 2020 09:01:16 -0700 (PDT)
Received: from rani.riverdale.lan ([2001:470:1f07:5f3::b55f])
        by smtp.gmail.com with ESMTPSA id 19sm2087813qkj.123.2020.08.27.09.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 09:01:16 -0700 (PDT)
From:   Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date:   Thu, 27 Aug 2020 12:01:13 -0400
To:     Borislav Petkov <bp@alien8.de>
Cc:     Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Joerg Roedel <jroedel@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, hpa@zytor.com,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>,
        Juergen Gross <jgross@suse.com>,
        Kees Cook <keescook@chromium.org>,
        David Rientjes <rientjes@google.com>,
        Cfir Cohen <cfir@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mike Stunes <mstunes@vmware.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Martin Radev <martin.b.radev@gmail.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v6 02/76] KVM: SVM: Add GHCB definitions
Message-ID: <20200827160113.GA721088@rani.riverdale.lan>
References: <20200824085511.7553-1-joro@8bytes.org>
 <20200824085511.7553-3-joro@8bytes.org>
 <20200824104451.GA4732@zn.tnic>
 <20200825092224.GF3319@8bytes.org>
 <20200825110446.GC12107@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200825110446.GC12107@zn.tnic>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Aug 25, 2020 at 01:04:46PM +0200, Borislav Petkov wrote:
> On Tue, Aug 25, 2020 at 11:22:24AM +0200, Joerg Roedel wrote:
> > I don't think so, if I look at the history of these checks their whole
> > purpose seems to be to alert the developer/maintainer when their size
> > changes and that they might not fit on the stack anymore. But that is
> > taken care of in patch 1.
> 
> Why? What's wrong with:
> 
> 	BUILD_BUG_ON(sizeof(struct vmcb_save_area) != VMCB_SAVE_AREA_SIZE);
> 	BUILD_BUG_ON(sizeof(struct vmcb_control_area) != VMCB_CONTROL_AREA_SIZE);
> 	BUILD_BUG_ON(sizeof(struct ghcb) != PAGE_SIZE);
> 
> ?
> 
> -- 
> Regards/Gruss,
>     Boris.
> 
> https://people.kernel.org/tglx/notes-about-netiquette

Wouldn't we rather just remove the checks?
