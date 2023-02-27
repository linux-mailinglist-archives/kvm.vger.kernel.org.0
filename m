Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C506A4D29
	for <lists+kvm@lfdr.de>; Mon, 27 Feb 2023 22:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbjB0V2k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Feb 2023 16:28:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjB0V2j (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Feb 2023 16:28:39 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7419D1D932;
        Mon, 27 Feb 2023 13:28:38 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id p20so7026815plw.13;
        Mon, 27 Feb 2023 13:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=slLNr0NsMjriSSsni08kykPIRKfCMvPjbEMyeTQjtz4=;
        b=ciuVNWCc4LBkN1dXsxMRgZuSJP6Tn2yb576/zRvm+Ie1bFDljvvkgWH5FtSch18HWs
         4KdSo8A98AMGVAHPuo1hDAkG6t4EkybpMw89ClGO4KV5Xt4pQKa0Alfv/K99VZOhcUvt
         VBfCO3IHUlGke2q1sEjBUERqNhv4mdxpS2of4VO1rpYq9rTelJSwYP5WFUeOsaKCg6Ak
         vht/Hn2ww7rqsNeaZxCi2UAqpPRmwFVBuaijk62u9nOyn9sYbC3r8p8Y3nyLnPNyXnXe
         YiySTke7+yTCWvAqKJL+nTw+IcVB/Go9A71u08iMXdYB4Lvad7jo3V1jLbV1ctRKSSQw
         o4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=slLNr0NsMjriSSsni08kykPIRKfCMvPjbEMyeTQjtz4=;
        b=dDS1pjE6BGHJ8AjDoxIRRrA8+u25f6QDk6NkzH0AVPlVHq1ku4DxonXzDgXrE6f/+K
         3qCXmp+/8LAfETpfy39eZfqVy5BJ2oE1uUjlRSKfws1EL6mUs8nPzFBujoddXwt+mvmD
         kR8viQtPMjMl/rqcbotBjL38Z9qPTnz2ExD072MzuD7rjQekFpWTIHCx+3rgdpPkqw/B
         abGW7/MWnF7fZYM1jAVf0o4QYrpsJd08U4A7uJOwUtaFW7xT6nwSyX4t/RPl14d+8Wea
         1ck1AVgmANG0jiZAa1n2yy++HgQZvcxsYPfNxV3aERg45uvM+9oYU/Fa84mXmjjXXSam
         pMow==
X-Gm-Message-State: AO0yUKVXAf2kNJj3EwiXA0y14jVwGRNr9LZLudHdxSTi985i2lzHxvoI
        IZt1bYtpaLziYyU3P4ZktLDt19FZq6g=
X-Google-Smtp-Source: AK7set8J6y0a5InH1v6RPIeTqs39FOmPTUAxnkRfo2h7jDT1hIjec2MnnsR/3gA1qQ4QkK+oFWwOmg==
X-Received: by 2002:a17:90b:1a8a:b0:237:35f9:655c with SMTP id ng10-20020a17090b1a8a00b0023735f9655cmr592150pjb.36.1677533317877;
        Mon, 27 Feb 2023 13:28:37 -0800 (PST)
Received: from localhost ([192.55.54.55])
        by smtp.gmail.com with ESMTPSA id o4-20020a17090ab88400b0023086d280c5sm4792885pjr.3.2023.02.27.13.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Feb 2023 13:28:37 -0800 (PST)
Date:   Mon, 27 Feb 2023 13:28:35 -0800
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sean Christopherson <seanjc@google.com>,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH v11 017/113] KVM: Support KVM_CAP_MAX_VCPUS for
 KVM_ENABLE_CAP
Message-ID: <20230227212835.GG4175971@ls.amr.corp.intel.com>
References: <cover.1673539699.git.isaku.yamahata@intel.com>
 <01e061779b88ce4d32bbe483ed2bd3224cd8e330.1673539699.git.isaku.yamahata@intel.com>
 <20230113145507.0000115c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230113145507.0000115c@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jan 13, 2023 at 02:55:07PM +0200,
Zhi Wang <zhi.wang.linux@gmail.com> wrote:

> On Thu, 12 Jan 2023 08:31:25 -0800
> isaku.yamahata@intel.com wrote:
> 
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> > 
> > TDX attestation includes the maximum number of vcpu that the guest can
> > accommodate.  For that, the maximum number of vcpu needs to be specified
> > instead of constant, KVM_MAX_VCPUS.  Make KVM_ENABLE_CAP support
> > KVM_CAP_MAX_VCPUS.
> > 
> > Suggested-by: Sagi Shahar <sagis@google.com>
> > Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
> > ---
> >  virt/kvm/kvm_main.c | 20 ++++++++++++++++++++
> >  1 file changed, 20 insertions(+)
> > 
> > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > index a235b628b32f..1cfa7da92ad0 100644
> > --- a/virt/kvm/kvm_main.c
> > +++ b/virt/kvm/kvm_main.c
> > @@ -4945,7 +4945,27 @@ static int kvm_vm_ioctl_enable_cap_generic(struct
> > kvm *kvm, }
> >  
> >  		mutex_unlock(&kvm->slots_lock);
> > +		return r;
> > +	}
> > +	case KVM_CAP_MAX_VCPUS: {
> 
> Better mention the KVM_CAP_MAX_VCPUS defined in XXX patch in the comments.

This already exists as KVM api and documented in Documentation/virt/kvm/api.rst
to get the possible maximum number of vcpus.
This patch make it settable.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
