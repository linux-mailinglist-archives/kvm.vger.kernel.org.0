Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ADB7570EFF
	for <lists+kvm@lfdr.de>; Tue, 12 Jul 2022 02:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiGLAkA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 11 Jul 2022 20:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLAkA (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 11 Jul 2022 20:40:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA4B2DA8B;
        Mon, 11 Jul 2022 17:39:59 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id f11so5867589plr.4;
        Mon, 11 Jul 2022 17:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qKjoEwy1ne1D5LbdAqN/NueJz7pPtNyuHan8nYhGCr0=;
        b=ZEMW/bBwXkZP9Tbez9uvhsX/NVaMgyPufwW8z2Bch1vWFotJBcPAC+QW92ikJje0bA
         JmU5G+bozCvAXo75dcNIpWuQd1tkqamPpN79CgH1APEMVWgZ+939zeNcyXAMVf3jpsFU
         rYkvnutc50uo1nb8hTsRBBSTXqgXWl+1c5YTU3p4kSq4A2ZXaU2tPW8aMMAoPoC51AJb
         y8rG53UGd297osyDzg6z7NDpKNNtSoeNU9+bOpwpaHDFcl8EjFytAfQoo49D9R9DSCPt
         VyMklcKZFKQbNaId98Uiu5y/TnfLFj0OHI6pBbYsZdnICSZyL4ZVXNNJjT4O0EAF6zPC
         KVIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qKjoEwy1ne1D5LbdAqN/NueJz7pPtNyuHan8nYhGCr0=;
        b=r8pRadv4sWmN7UP84/C3s0EGV5t+dt9rp4S2y2hYvP/b2mQTrp2/vrgj3o8HFfKXlc
         3sUF0J9rY2a7UgohITTIpEpDKR60Z6nqhWh1UdKJ0b7LLE6ML0lLSmYFtIzkH2sJ5QON
         fa65u5oPgdkcV9aimdxLq4YOtXqcfDsbmm3L3Ukeq6abyxtjzTpyYq47iDLC4/vaA5sM
         Ao8Th6Z1PYkX7kFqc9gabWtMrW4GxEJCmznQoyDLcbcEFIj+E4nIyNnWtT2h48ybZK+b
         moj5epYsSWZJ2jBWNPJx09Dtgm5wrZ8/uVkVnS9ADbjPE7TLxeXoPWboC6ZDioMCGO1+
         JPUA==
X-Gm-Message-State: AJIora/MLixmBhBLWZiNnHLAVCoWkkSSB8xK0PrpXE5++hZJL9W9dSFF
        aUJXWEfsAk+Gk3tNpJtERL0=
X-Google-Smtp-Source: AGRyM1tR6xfEM0sb00PzUR3hhlc5gGOQ0/15bN46s1wuQtrfd8s0ThXAFG6+INGZGgClXJjOJYcpPA==
X-Received: by 2002:a17:903:120e:b0:16b:8167:e39e with SMTP id l14-20020a170903120e00b0016b8167e39emr21099496plh.165.1657586398780;
        Mon, 11 Jul 2022 17:39:58 -0700 (PDT)
Received: from localhost (fmdmzpr02-ext.fm.intel.com. [192.55.54.37])
        by smtp.gmail.com with ESMTPSA id o12-20020a170902d4cc00b0016c433f7c12sm3312893plg.271.2022.07.11.17.39.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 17:39:58 -0700 (PDT)
Date:   Mon, 11 Jul 2022 17:39:57 -0700
From:   Isaku Yamahata <isaku.yamahata@gmail.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     isaku.yamahata@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, isaku.yamahata@gmail.com,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v7 010/102] x86/virt/tdx: Add a helper function to return
 system wide info about TDX module
Message-ID: <20220712003957.GC1379820@ls.amr.corp.intel.com>
References: <cover.1656366337.git.isaku.yamahata@intel.com>
 <2e722b58684c3cfbedda7d2a5a446255784a615e.1656366338.git.isaku.yamahata@intel.com>
 <20220707024602.i5ym5nlnps3cjvj6@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220707024602.i5ym5nlnps3cjvj6@yy-desk-7060>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jul 07, 2022 at 10:46:02AM +0800,
Yuan Yao <yuan.yao@linux.intel.com> wrote:

> On Mon, Jun 27, 2022 at 02:53:02PM -0700, isaku.yamahata@intel.com wrote:
> > From: Isaku Yamahata <isaku.yamahata@intel.com>
> >
> > TDX KVM needs system-wide information about the TDX module, struct
> > tdsysinfo_struct.  Add a helper function tdx_get_sysinfo() to return it
> > instead of KVM getting it with various error checks.  Move out the struct
> > definition about it to common place tdx_host.h.
> 
> Please correct the tdx_host.h to tdx.h or arch/x86/include/asm/tdx.h

Oops. Thanks for catching it. fixed it.
-- 
Isaku Yamahata <isaku.yamahata@gmail.com>
