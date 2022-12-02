Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90CEA640E2A
	for <lists+kvm@lfdr.de>; Fri,  2 Dec 2022 20:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234503AbiLBTDW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Dec 2022 14:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234500AbiLBTDU (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Dec 2022 14:03:20 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 439E3D8267
        for <kvm@vger.kernel.org>; Fri,  2 Dec 2022 11:03:19 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id 21so5742386pfw.4
        for <kvm@vger.kernel.org>; Fri, 02 Dec 2022 11:03:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BzQIwpfetdhZyRBwIU5BQIKvvSZ4/8R8B3ehTYDV0qE=;
        b=pMInxBnvJlc2PwOobJoCPRUbGkde7rIQZAndraY4wjHPI43Afosr7/lEyukYNxMO8i
         Hh3kqrXSCIX8ozRDJ0UnkkR2JMxcrcoOk99tWNgpR5DHDhi5zRMZcq2WXWGcPuUaFx+/
         aFKtFQslfLwzkuX+8SEgmLSVnpM+x+udn4zcj+knG/B75aXmKyevT/hvObqPcnSyYjWY
         mvU4o53cOx/LUp9qm1snhCRST+GUs6gD55kwo8Zt3GP0brp1z2L39/R1YjstAhA49xQO
         SCb4w8xsnX/dSedgzfWbS5VttObghrzTjrR4LYAlEELqbj7+m6hk/qm6m5Ka+zWjSDAV
         sH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BzQIwpfetdhZyRBwIU5BQIKvvSZ4/8R8B3ehTYDV0qE=;
        b=5KgI46LS7drT90eJzxdAupDhxpJ4eZQQ19dbURwllaFsx5xCOpFReG+QbruNDtY8Jr
         crNrEbPEQMzXyccfL+OFb7wstVm18FYzaaae5mbxRgN3QHPpcqocKZKou9EElCzRsE1B
         kFqcxS5Rt5wBooekvwGfw67NApNsMQMqs03AKSjVVSwLk1BpCeRoQkqGKHeAhr7vz6Mc
         2GbJua3bHRjK/6AVRNdrKw6mKFC4NIZJaUm7V8Ma3U6RRDsrpcdypa5VfgBKICmNU5Yt
         5AtUV1B1ZWU+1dSu85lmnRYyBDP1Ysuj3z94ewpx2zwDFRKtkH0Wbqz+GMqSEdG/S3HB
         AIbg==
X-Gm-Message-State: ANoB5plunDtIgq7rgzOHyQAlxt0v+qChY+2Wc7iXiOwj9VIC/wl9QgQD
        71cK1JQwHTOdhhHO442qa4BTIw==
X-Google-Smtp-Source: AA0mqf5hNo6+a3PnVvngDWd8q/2NCzbESkPgraiN8XkIDzUZMcV+QrHBgY9hN8Nk2l9MIH8CQtDrPg==
X-Received: by 2002:a63:1466:0:b0:476:cac7:16ad with SMTP id 38-20020a631466000000b00476cac716admr47839419pgu.128.1670007798641;
        Fri, 02 Dec 2022 11:03:18 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o10-20020a17090aeb8a00b00218f830c63esm5077371pjy.1.2022.12.02.11.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 11:03:18 -0800 (PST)
Date:   Fri, 2 Dec 2022 19:03:14 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>,
        Michal Luczaj <mhal@rbox.co>, kvm@vger.kernel.org
Subject: Re: [PATCH v1 0/2] KVM: x86/xen: Runstate cleanups on top of
 kvm/queue
Message-ID: <Y4pL8kieNaXZh5tF@google.com>
References: <20221127122210.248427-1-dwmw2@infradead.org>
 <cd107b6c-ae02-8fa6-50e0-d6cbca7d88bc@redhat.com>
 <24408924dbe6041472f5e401f40c29311e1edd99.camel@infradead.org>
 <561885a1-e1de-21f2-1da9-5abfea2a1045@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <561885a1-e1de-21f2-1da9-5abfea2a1045@redhat.com>
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

On Fri, Dec 02, 2022, Paolo Bonzini wrote:
> On 11/30/22 20:51, David Woodhouse wrote:
> > On Wed, 2022-11-30 at 17:03 +0100, Paolo Bonzini wrote:
> > > On 11/27/22 13:22, David Woodhouse wrote:
> > > > Clean the update code up a little bit by unifying the fast and slow
> > > > paths as discussed, and make the update flag conditional to avoid
> > > > confusing older guests that don't ask for it.
> > > > 
> > > > On top of kvm/queue as of today at commit da5f28e10aa7d.
> > > > 
> > > > (This is identical to what I sent a couple of minutes ago, except that
> > > > this time I didn't forget to Cc the list)
> > > > 
> > > > 
> > > 
> > > Merged, thanks.
> > 
> > Thanks. I've rebased the remaining GPC fixes on top and pushed them out
> > (along with Metin's SCHEDOP_poll 32-bit compat support) to
> > 
> > https://git.infradead.org/users/dwmw2/linux.git/shortlog/refs/heads/gpc-fixes
> 
> Oh, so we do pull requests now too?  I'm all for it, but please use signed
> tags. :)
> 
> > I still haven't reinstated the last of those patches to make gpc->len
> > immutable, although I think we concluded it's fine just to make the
> > runstate code claim gpc->len=1 and manage its own destiny, right?
> 
> Yeah, I'm not super keen on that either, but I guess it can work with any of
> len == 1 or len == PAGE_SIZE - offset.
> 
> Related to this, for 6.3 I will send a cleanup of the API to put together
> lock and check.

We ended up with multiple threads on this topic.  Maybe pick up the conversation
here?   https://lore.kernel.org/all/Y4ovbTiLQ2Jy0em9@google.com
