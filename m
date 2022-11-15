Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8DA62A089
	for <lists+kvm@lfdr.de>; Tue, 15 Nov 2022 18:40:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiKORkc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 15 Nov 2022 12:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKORka (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 15 Nov 2022 12:40:30 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B35B52E9C1
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:40:29 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y13so14768045pfp.7
        for <kvm@vger.kernel.org>; Tue, 15 Nov 2022 09:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ky6Mco0OalSrctJAu1EOJBd+lJAoIkQi5z5MeDuMBMM=;
        b=KYQzKZ5kcNqdDmtXq+8AHgkZoCrX86BWNNeDNjWO4Wbiwl1R008xFm5xBobnkhpp6v
         msK3WCcdsJtN3aiBzR3P6mKT0ehY6yg9Ml5tR1PKiH8R9PWYZJtURob0x0A0GFkXbjLJ
         3wSHpsSuQhwqcyE5SbBNVoNZUtweeoqSgmU+Dl0UPXexvkvATztQfxuPXvQEd9/CvJPZ
         Iz1ZCBBs4blkTzkRCPtpB05buILbd/bmlkiRSZpyD63g8FKCCbi0WOctDv6edTddEf9c
         GcN+rJ5uokAZu23ugVWDOE2i0TLpoDKuoC0bZboLmIUcbMlNhn/s5/EUjN9yBbpGh0nM
         iNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ky6Mco0OalSrctJAu1EOJBd+lJAoIkQi5z5MeDuMBMM=;
        b=QvUj7wiIruSdOwbjKBXU+O8VmhLSs7CVTyOqXqYu2vxQRWhwmmjH8VCheXns2RGsXi
         MBleC0RM8CeC39RcwqjgChUTxXhoty3L5MwnkLe2HIuA/4RPr+D6zXFPJydCUoOe4oyE
         2Jcy8tPMtkUeGArTBavPAaLvk4o3gK7cqdM13NKvs63QY8jKd7pruMyxpanlOWfMZoIq
         6GWxmV0fJMEVoM0GfrhOIjXZlVAmpQFLjRn9WbOwKn3pv2uBMprI1HXGiAPDm8gmgzoF
         Og1+UgYtWBIjDwcDnZ0bwHMzd7SPdWUF2nIMQGay1GmNhViU0PGrF/E10KnC1WyC3JxW
         CbMg==
X-Gm-Message-State: ANoB5pmyONRcgY9JMRbvZJxrzHk6wfKqEqILcCuWNsnP3zfSh6NFPGRr
        Fp4eD1AX4y7d3YFjSJCznxdrMhn865SubA==
X-Google-Smtp-Source: AA0mqf79mdJMF/8Ew3sSkavuSrcAbRmS/zbCzf3ypigfhk0Vlku9YwXG4P0Aed3ocsjGOjf0/DlxZg==
X-Received: by 2002:a63:ce56:0:b0:457:e41:c767 with SMTP id r22-20020a63ce56000000b004570e41c767mr16636972pgi.244.1668534029048;
        Tue, 15 Nov 2022 09:40:29 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id y25-20020aa79439000000b0056bd1bf4243sm9063441pfo.53.2022.11.15.09.40.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 09:40:28 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:40:24 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     guo.ziliang@zte.com.cn, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] KVM: replace DEFINE_SIMPLE_ATTRIBUTE with
 DEFINE_DEBUGFS_ATTRIBUTE
Message-ID: <Y3PPCHa9Yzi1sSnQ@google.com>
References: <202211150858513761518@zte.com.cn>
 <Y3PM4euxrCFhZnCc@google.com>
 <b81f9af0-28a0-fe23-37df-64a785bfe52a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b81f9af0-28a0-fe23-37df-64a785bfe52a@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Nov 15, 2022, Paolo Bonzini wrote:
> On 11/15/22 18:31, Sean Christopherson wrote:
> > On Tue, Nov 15, 2022, guo.ziliang@zte.com.cn wrote:
> > > From: guo ziliang <guo.ziliang@zte.com.cn>
> > > Fix the following coccicheck warning:
> > > /virt/kvm/kvm_main.c: 3849: 0-23: WARNING: vcpu_get_pid_fops
> > > should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> > > 
> > > Signed-off-by: guo ziliang <guo.ziliang@zte.com.cn>
> > > ---
> > > virt/kvm/kvm_main.c | 2 +-
> > > 1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> > > index 2719e10..6e58aec 100644
> > > --- a/virt/kvm/kvm_main.c
> > > +++ b/virt/kvm/kvm_main.c
> > > @@ -3846,7 +3846,7 @@ static int vcpu_get_pid(void *data, u64 *val)
> > > return 0;
> > > }
> > > 
> > > -DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
> > > ++DEFINE_DEBUGFS_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
> > 
> > NAK, third time is not a charm.
> > 
> > https://lore.kernel.org/all/20221101072506.7307-1-liubo03@inspur.com
> > https://lore.kernel.org/all/20220815031228.64126-1-ye.xingchen@zte.com.cn
> 
> Screw it, I'm going to send a pull request just to delete that file.

Heh, I was seriously considering sending a patch to do that too.
