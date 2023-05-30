Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 646D5716A95
	for <lists+kvm@lfdr.de>; Tue, 30 May 2023 19:14:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233056AbjE3ROV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 30 May 2023 13:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjE3ROT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 30 May 2023 13:14:19 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90EC3F1
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:14:17 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d2e1a72fcca58-64d5b4c4484so3113761b3a.3
        for <kvm@vger.kernel.org>; Tue, 30 May 2023 10:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685466857; x=1688058857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=oW5kBn+PdJEe6rnXOx+ck1CwnlYyJC8NqkWMcNa5q8w=;
        b=5tqIC4aQWleru/7zEQ0O/WXJ4FaBYf8tAGYm6xgyYMK7b5MfPQD9AYDQ4YYAtrWSov
         sBHidJlws2X4SVko9faCr5yMOkwlEig9tMKy1cR+PrS6TJ//Uby+sck61oO29XO31jl1
         OxwY51SC8xVggRqjPel2Md8LNUuwnqlXJ8x5DG0An4gTYsKEmprDK736L5gwekv/MiWL
         VD0mRxnXpuF+S0DWCgL590UkgyZj3C69nzVCIaiB7+es2moWAfLtqrydqaEhdQyvJw7+
         IA23MdOc3WAECAZjKkoJe1yglPb6B+6MjV4nKmKwToSLcfLOlPTZBOqJf64uEpk0NQsl
         i6EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685466857; x=1688058857;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oW5kBn+PdJEe6rnXOx+ck1CwnlYyJC8NqkWMcNa5q8w=;
        b=D5+iikjC0cXahVhGd+XHKu+JhTNxT788/pc3JOhlrRM3+EVtG/AKx2mzu/XDvPyj7g
         iOXCH4kUfkch+3kJlGcxCWlCpvNj9sr/T9ahTq4yn4G4Ya0/O4Vs9Lqk3hZerEmSX/hc
         ara232jVL63cfEvyuJd9s/kqOkb2t8kZMVt2saau6p3svr+1cV7JlYuQ1KonP/T869hY
         EJl94ZdGFi8iY4ll1moV1az+qyt8N63Ls4QzdLNK/EaXsWrpCLphvXqe91w6Zd0UU/cu
         Fo6ICYO2iVv2aMCQCuZUYh/J+juVfzvzox5pM7hAczuS+H5UROD3J8/CUtbN8cHB13Dh
         qLlw==
X-Gm-Message-State: AC+VfDzgX5CnQ7ywrrb6WIg1MS5a+4x3IpOIPLtDWciYGhdiYlCXamEB
        r+4u/dP5iyvgyXFSBNc5g2+q/oakaDQ=
X-Google-Smtp-Source: ACHHUZ7Yj3FRLJmuyE2r93i9n0+xfvuQ5ZojKX+qIj+lPi2L12IcMOFH/kvwC3UzWxnLDX34U4WpmBgLQac=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a0e:b0:643:53b6:d86d with SMTP id
 p14-20020a056a000a0e00b0064353b6d86dmr1072552pfh.4.1685466857070; Tue, 30 May
 2023 10:14:17 -0700 (PDT)
Date:   Tue, 30 May 2023 10:14:15 -0700
In-Reply-To: <20230530215036.000066d9.zhi.wang.linux@gmail.com>
Mime-Version: 1.0
References: <cover.1685333727.git.isaku.yamahata@intel.com>
 <e628e2d235d9b6c00b9bd5d81bb69136b77d13c4.1685333727.git.isaku.yamahata@intel.com>
 <20230530215036.000066d9.zhi.wang.linux@gmail.com>
Message-ID: <ZHYu5yvtw7oMDUAP@google.com>
Subject: Re: [PATCH v14 004/113] KVM: TDX: Initialize the TDX module when
 loading the KVM intel kernel module
From:   Sean Christopherson <seanjc@google.com>
To:     Zhi Wang <zhi.wang.linux@gmail.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>, erdemaktas@google.com,
        Sagi Shahar <sagis@google.com>,
        David Matlack <dmatlack@google.com>,
        Kai Huang <kai.huang@intel.com>, chen.bo@intel.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, May 30, 2023, Zhi Wang wrote:
> On Sun, 28 May 2023 21:18:46 -0700 isaku.yamahata@intel.com wrote:
> > +	/* tdx_enable() in tdx_module_setup() requires cpus lock. */
> > +	cpus_read_lock();
> > +	on_each_cpu(vmx_tdx_on, &err, true);	/* TDX requires vmxon. */
> > +	r = atomic_read(&err);
> > +	if (!r)
> > +		r = tdx_module_setup();
> > +	on_each_cpu(vmx_off, NULL, true);
> 
> Out of curiosity, why VMX has to be turned off after tdx_module_setup()?

KVM has historically enabled VMX if and only if KVM has active VMs.  Whether or
not it still makes sense to do dynamic enabling is debatable, but that's a
discussion for another day.
