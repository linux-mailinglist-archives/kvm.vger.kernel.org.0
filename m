Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ADBD5B24EE
	for <lists+kvm@lfdr.de>; Thu,  8 Sep 2022 19:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbiIHRlS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 8 Sep 2022 13:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiIHRky (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 8 Sep 2022 13:40:54 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 988282651
        for <kvm@vger.kernel.org>; Thu,  8 Sep 2022 10:39:38 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id s14so9021265plr.4
        for <kvm@vger.kernel.org>; Thu, 08 Sep 2022 10:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=Ibf2Rs7XFT5ZnX84v5i/nCzDWYA2lLRXva8K8FpnKaE=;
        b=Y1apfqUNpBKh81zUqjNz1zjMg6kCkBJJJN9WteQ+RsktQ/RnDF/aJpbfaW7HhGImBW
         I6P4aLNQbSdMkhGytc09SCNTDoZ3YoqMzr/CFGx2sfHPm69nyrOtmXodhGug7ygKWe5q
         iGC2Etc7Q3+g1DEFu5gFNnwLPnvsKO3TUpxyxgsWTUpTWZhWVEB8OKz4yYBb56GD21mY
         JIRMd1p4V2v8sYhkTCyBTM+uTv5Wpg7um3AB/xvrKBxiFWk4spYPyNhr2ZAQQY1S/D/8
         KrBjQEwqY/9MjDJvgRgp5HSQ0Kn/Z9NVJ6Tx8fj4Pj9OUEQ9cM5m+6hfcDk1qsjIunoX
         sfMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=Ibf2Rs7XFT5ZnX84v5i/nCzDWYA2lLRXva8K8FpnKaE=;
        b=B3ceqHVsXgiR5srzSNFqF6N6EE03qPbffnPcKeRi9878zAPfy+nWb/J7bxfcE0rv+X
         I80wSwjJdGebWoB1PTCud2YP+V7rhUS/lCfuAQO7reBTKapFy3xOMcyVCPfeIn7jv+7Y
         7hoPHa0YXHUOeTjIaVNZp6U6djh7H8jM7n0irJmSLx+Fuj5icRZFUof5mprk5u/Kxj+6
         5MX6O5zaX8NWU6HzA5Uqe5kIYX/yGQy9Wq7KM6zBcagGwfaludgazNtWAp0NSriWTBvs
         h5qP1tk1dxWzUCaRuw0eNcAEBQYC2elUKYR0FSUP18lSY2dIA+bLG/jRcPAcYLqd8Xse
         w0ew==
X-Gm-Message-State: ACgBeo3WKRG8MeHwHxyD+6A3Ua1hgh8f/vyP9KgOrILEDmWTk/mucQ6m
        typF/NT5NRLH53J0rRKoDlW0gQ==
X-Google-Smtp-Source: AA6agR42smilAfgdcEGqi/GQJRCr5wSe+lozghtjTz9mRCUatdQBZeBUjvQ2+qaawU0RYByIr+/NIw==
X-Received: by 2002:a17:90b:1c8f:b0:1fb:9d43:8ecf with SMTP id oo15-20020a17090b1c8f00b001fb9d438ecfmr5439682pjb.160.1662658776881;
        Thu, 08 Sep 2022 10:39:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b00173411a4385sm4599069plg.43.2022.09.08.10.39.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 10:39:36 -0700 (PDT)
Date:   Thu, 8 Sep 2022 17:39:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     cgel.zte@gmail.com
Cc:     pbonzini@redhat.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ye xingchen <ye.xingchen@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] KVM:define vcpu_get_pid_fops with
 DEFINE_DEBUGFS_ATTRIBUTE
Message-ID: <Yxoo1A2fmlAWruyV@google.com>
References: <20220815031228.64126-1-ye.xingchen@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815031228.64126-1-ye.xingchen@zte.com.cn>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Aug 15, 2022, cgel.zte@gmail.com wrote:
> From: ye xingchen <ye.xingchen@zte.com.cn>
> 
> From the coccinelle check:
> ./virt/kvm/kvm_main.c line 3847
> WARNING  vcpu_get_pid_fops should be defined with DEFINE_DEBUGFS_ATTRIBUTE
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: ye xingchen <ye.xingchen@zte.com.cn>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 515dfe9d3bcf..a0817179f8e4 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -3844,7 +3844,7 @@ static int vcpu_get_pid(void *data, u64 *val)
>  	return 0;
>  }
>  
> -DEFINE_SIMPLE_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");
> +DEFINE_DEBUGFS_ATTRIBUTE(vcpu_get_pid_fops, vcpu_get_pid, NULL, "%llu\n");

Based on the comments in scripts/coccinelle/api/debugfs/debugfs_simple_attr.cocci,
it seems that using DEFINE_DEBUGFS_ATTRIBUTE is only beneficial if the file is
created with debugfs_create_file_unsafe().  IIUC, using DEFINE_DEBUGFS_ATTRIBUTE
without switching to debugfs_create_file_unsafe() will actually _add_ overhead.

	//# Rationale: DEFINE_SIMPLE_ATTRIBUTE + debugfs_create_file()
	//# imposes some significant overhead as compared to
	//# DEFINE_DEBUGFS_ATTRIBUTE + debugfs_create_file_unsafe().

Using DEFINE_DEBUGFS_ATTRIBUTE also effectively drops ->llseek() support.  I assume
that's not a problem?  But someone that knows how this is actually used should
chime in.
