Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5601064EFDA
	for <lists+kvm@lfdr.de>; Fri, 16 Dec 2022 17:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231516AbiLPQ5H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Dec 2022 11:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiLPQ4x (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Dec 2022 11:56:53 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 537001CB3D
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:56:53 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id f3so2176732pgc.2
        for <kvm@vger.kernel.org>; Fri, 16 Dec 2022 08:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bu/bqpjOOoV9CiRdEEIx92Zb97X3rpjaXiK1D6Uy+bY=;
        b=EV0///5/+qU/iyQNxhltKNp2TihIR0Sl6NmjoP4n6grg3/uMFZveh8Ye6ieZ52/D3V
         8gqvZ8+H3Gm+WghYU7aY2flBoBj8vCzAuNBwOHzJenLslaVd3fetfspb5vtnyfXmLqwp
         skY9n44oQFrqO+KyxP1rFclq46frGlxFdXkbUEbcTblZSCFcceoYPW6B2LyOfHCkDzkJ
         /AYJ76WNQuvCjDWkMw+L22xISxcJghUAXXgU6RmL1a5Ke6Gndk2BPYgj8YPH/nCTWZpF
         jA6eJyE2QGMTQCy0WLJDbOVJsa4jO/QiDeZFDeJ20EhAxWJmo4x7IXjBLYKJ+tBU2xBF
         H+2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bu/bqpjOOoV9CiRdEEIx92Zb97X3rpjaXiK1D6Uy+bY=;
        b=PTW71UlZpoyM9lUxSJuMpyxl1VsO0f5jKwpHy/S37pqk1BbCdHbKZMAKjxSJiy42Vh
         eRstxICKxCbB2h2xbCf8/JNP2MOzucAM8wnI/8BG4Uj9f6kY8I/DqPSgq/wjrGG2SKfk
         wiGNZZ/WwYwy57wT4Oojrsdk2gNN1VZxJrpGo4H6ZjUtAlO4WeIuHGUflxc3vCk9BCuk
         StlZUzLZ2/LxMsZryh3KwjM/OyOhot/C/cPt7+L0HSUgQBzCZZ3txeJy+FWKgLmiXK3U
         0+nz9LtMOdwQ5Je91qqrb/mpznVbeapqaPgFt3DEDRt0my7qANiVjBlb8cGNrUmNOME3
         y5nw==
X-Gm-Message-State: AFqh2ko1HEYEn65q1sDTFVO9gbdoR/2SIYN27wsG+MCwG/YYcbig2ko2
        9xfjp0DaiUkU/qnN20sAOZT+lvhhU6JDTVwh
X-Google-Smtp-Source: AMrXdXukIaOqriMfC5iWd4yjwYF/O6ePpySKYijHIguBSBUaaiLLpTtXW0Du7xeh+ftPxy9usPat/g==
X-Received: by 2002:a05:6a00:1a8d:b0:577:36ba:6a86 with SMTP id e13-20020a056a001a8d00b0057736ba6a86mr533650pfv.1.1671209812710;
        Fri, 16 Dec 2022 08:56:52 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id n5-20020a056a00212500b005775c52dbc4sm1715981pfj.167.2022.12.16.08.56.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Dec 2022 08:56:51 -0800 (PST)
Date:   Fri, 16 Dec 2022 16:56:47 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kvm: kvm_main: Remove unnecessary (void*) conversions
Message-ID: <Y5yjT2Xu0Jd8ueQ2@google.com>
References: <20221213080236.3969-1-kunyu@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221213080236.3969-1-kunyu@nfschina.com>
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

On Tue, Dec 13, 2022, Li kunyu wrote:
> void * pointer assignment does not require a forced replacement.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  virt/kvm/kvm_main.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index fab4d3790578..1682b269ad4a 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3861,7 +3861,7 @@ static int create_vcpu_fd(struct kvm_vcpu *vcpu)
>  #ifdef __KVM_HAVE_ARCH_VCPU_DEBUGFS
>  static int vcpu_get_pid(void *data, u64 *val)
>  {
> -	struct kvm_vcpu *vcpu = (struct kvm_vcpu *) data;
> +	struct kvm_vcpu *vcpu = data;
>  	*val = pid_nr(rcu_access_pointer(vcpu->pid));

Unrelated to your patch: doesn't this need proper RCU protection?  E.g. if
KVM_RUN changes vcpu->pid between the read and dereference in pid_nr(), and puts
the last reference to the old pid.
