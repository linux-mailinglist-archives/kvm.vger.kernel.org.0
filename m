Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAF43FA0F2
	for <lists+kvm@lfdr.de>; Fri, 27 Aug 2021 23:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231728AbhH0VBu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 27 Aug 2021 17:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231572AbhH0VBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 27 Aug 2021 17:01:49 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A61C1C0613D9
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:01:00 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id g184so6925434pgc.6
        for <kvm@vger.kernel.org>; Fri, 27 Aug 2021 14:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tI9HaMdZqkoEnotuhkZgxR2Gc8e4BrKX2M4IPXxMnmc=;
        b=eORG6cTFVBzvjQlKb0t4WrPnjrfgcop0ivusY7ffhvlya+zHiy1ug0uTSELeH6vvFx
         VsS2QTwuL2YYMqjw52935/8Svg0+YeQEgxlnNDN+obOsU6mNGGsMYKJ7j2CCWLspu+F9
         ya6gDS7MTd56GIQU0i4yJJ5B2Xis0az9id56bSd2WPs0W1hda4X3Xyk8ucKr1dig7XsB
         KtmPyK5rvLUBXlg2bgZgJ3qfyc3ZUp7ShSPDbTkMF4+hX/OoewiwkFhVah4+Hjn8SjiP
         fgGoT8aiOsqY922blOu/4yQPeDqA2kuUqhhf/ZfsAgo37j6wcwCz1FC9KI3xOokv8wdd
         zwlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tI9HaMdZqkoEnotuhkZgxR2Gc8e4BrKX2M4IPXxMnmc=;
        b=DwGHKYMEEr5tBLXdDYZhJkgHhGwiU+O7J68A9ikdpICEA+vSniPUSjH6ldRVXwdujM
         36nYsj5KLfm1KTkrAuu3fu90umdQjZ4ozM/exYLRobMHatIPjfNClwhxviQ1AkJE5wa6
         kIFJb4B0UP4B1KmxswsB1A4jeKGsTx8zo6UT0Kg8nU/nDpYkoLC2mIc1Ab7InRN+4dyV
         l6ebvnTtk4yi41hzZEMDDELSVcGk+e3emvu/ryrkm2CBDJp3Gv5gVopAWYPEWoqsHNe1
         5Wm8Bm79Hq/3bQU4Ly38F+iambe9wNlPCsoXFbrCh9rU48C5lLrkuIa0iILpkPyAIbSg
         Om0A==
X-Gm-Message-State: AOAM531savU7txTJmpgeMqf8yCEW0XNou2gi0lNCqf/V0lNeniQPY2gr
        evaOKiZdSLK9QWl9HmjVeOapSw==
X-Google-Smtp-Source: ABdhPJznM9fpAh+AvFST7AUQYXH02fD9bOsT8exCbASeNEsRYI4fihaJrWE7eUH0BtDdO2RhLfMN8g==
X-Received: by 2002:aa7:8246:0:b029:39a:1e0a:cd48 with SMTP id e6-20020aa782460000b029039a1e0acd48mr10845556pfn.14.1630098059922;
        Fri, 27 Aug 2021 14:00:59 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id o10sm6871191pfk.212.2021.08.27.14.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 14:00:59 -0700 (PDT)
Date:   Fri, 27 Aug 2021 21:00:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Bill Wendling <morbo@google.com>
Cc:     kvm@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>,
        David Matlack <dmatlack@google.com>
Subject: Re: [PATCH] libcflag: define the "noinline" macro
Message-ID: <YSlSh+xe0k4hK7Le@google.com>
References: <20210826210406.18490-1-morbo@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210826210406.18490-1-morbo@google.com>
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Aug 26, 2021, Bill Wendling wrote:
> Define "noline" macro to reduce the amount of typing for functions using
> the "noinline" attribute.
> 
> Signed-off-by: Bill Wendling <morbo@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>

For your own sanity, you'll probably want to send this as part of your other
series to fix clang's zealous inlining, there's a decent chance Paolo won't get
to this for several weeks.
