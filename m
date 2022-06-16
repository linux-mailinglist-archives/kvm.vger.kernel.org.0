Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4FE054E108
	for <lists+kvm@lfdr.de>; Thu, 16 Jun 2022 14:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbiFPMrO (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 16 Jun 2022 08:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229702AbiFPMrN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 16 Jun 2022 08:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 99945473BD
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655383630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eHLQpuAU4wLXl8S1FY+BvKbQEk+v7epLCejlC4CMvYY=;
        b=htb/cpE8/QpnNTlBjUvWUkdBjq3JWDE0TpMC6MWbo4hZmIXWmvBJKfjm4belUoaHWiA6Hm
        YfzasaexmYRmAt5CgpsV6hwxwoLNlqbSAKleAWvFkdh/I9jAqlsuUGp5mI5feAZrWfP2gD
        Ru9iTDutWh6WhuLRPEl2synub3TlEU0=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-190-vWEdkT8NOWOp1NTJaZ-j0w-1; Thu, 16 Jun 2022 08:47:09 -0400
X-MC-Unique: vWEdkT8NOWOp1NTJaZ-j0w-1
Received: by mail-ej1-f69.google.com with SMTP id fp4-20020a1709069e0400b00711911cecf9so562932ejc.3
        for <kvm@vger.kernel.org>; Thu, 16 Jun 2022 05:47:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eHLQpuAU4wLXl8S1FY+BvKbQEk+v7epLCejlC4CMvYY=;
        b=y0a9n2mRednNFY//zoOa7LJHGqS9QI5VFlbHl6q+CuefZ7BfnVmx5mSLHNrY0TodTi
         bCM4hRIzgQjyDTBYrVHnjmhBNKEPOY7KmW1eqbZlvwMdFtct2QkCsNn2hkexQGS7nvgG
         PYcrL+7uiKJBAdyezQdiLIC6GleiqaoGunz2oLOyfFmwEWp9sAO+iS+XTzC7jhDwSbv0
         Uv4MqjL3MntvaF2aJmpYr8pNxTFePNm36jduW8c2ndwOO8dXVd9ZpSMAXV+mLkHC3RYz
         c3LNa7j4eTg9lUl7xDgUh0WkWxkvnUcomd4tD/lCz5RTeeefk+jbK+RqKwrQxcKAtQfI
         PaTg==
X-Gm-Message-State: AJIora/1S54EMrCuFqYGJlB46FafhUKmt7iQNlGjQSBqMEZquqNRc9P3
        BvxMPoUQ75NqmABLbWOSIsvJyVv3lWnB/OUAHg3CX9sKiocMfwake8cbx4PxwJ3KtNgCWdFeimw
        NLdZQD0bjTen4
X-Received: by 2002:a05:6402:23a3:b0:42e:251a:c963 with SMTP id j35-20020a05640223a300b0042e251ac963mr6296498eda.173.1655383628443;
        Thu, 16 Jun 2022 05:47:08 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tpIYwJjkFopmtzI0GIlGcLZdwZ6PcGGP/8fD6qnBnNu7Xzc7i8G+/aM6OTa6GGy5Vz99TU8Q==
X-Received: by 2002:a05:6402:23a3:b0:42e:251a:c963 with SMTP id j35-20020a05640223a300b0042e251ac963mr6296486eda.173.1655383628301;
        Thu, 16 Jun 2022 05:47:08 -0700 (PDT)
Received: from gator (cst2-173-67.cust.vodafone.cz. [31.30.173.67])
        by smtp.gmail.com with ESMTPSA id j4-20020a50ed04000000b004318ba244dcsm1714996eds.10.2022.06.16.05.47.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 05:47:07 -0700 (PDT)
Date:   Thu, 16 Jun 2022 14:47:05 +0200
From:   Andrew Jones <drjones@redhat.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
        pbonzini@redhat.com, seanjc@google.com, vkuznets@redhat.com,
        thuth@redhat.com, maz@kernel.org
Subject: Re: [PATCH 1/4] KVM: selftests: enumerate GUEST_ASSERT arguments
Message-ID: <20220616124705.wsll33usok4gfhqc@gator>
References: <20220615193116.806312-1-coltonlewis@google.com>
 <20220615193116.806312-2-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220615193116.806312-2-coltonlewis@google.com>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Jun 15, 2022 at 07:31:13PM +0000, Colton Lewis wrote:
> Enumerate GUEST_ASSERT arguments to avoid magic indices to ucall.args.
> 
> Signed-off-by: Colton Lewis <coltonlewis@google.com>
> ---
>  tools/testing/selftests/kvm/include/ucall_common.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/tools/testing/selftests/kvm/include/ucall_common.h b/tools/testing/selftests/kvm/include/ucall_common.h
> index 98562f685151..dbe872870b83 100644
> --- a/tools/testing/selftests/kvm/include/ucall_common.h
> +++ b/tools/testing/selftests/kvm/include/ucall_common.h
> @@ -32,6 +32,14 @@ uint64_t get_ucall(struct kvm_vcpu *vcpu, struct ucall *uc);
>  				ucall(UCALL_SYNC, 6, "hello", stage, arg1, arg2, arg3, arg4)
>  #define GUEST_SYNC(stage)	ucall(UCALL_SYNC, 2, "hello", stage)
>  #define GUEST_DONE()		ucall(UCALL_DONE, 0)
> +
> +enum guest_assert_builtin_args {
> +	GUEST_ERROR_STRING,
> +	GUEST_FILE,
> +	GUEST_LINE,
> +	GUEST_ASSERT_BUILTIN_NARGS
> +};
> +
>  #define __GUEST_ASSERT(_condition, _condstr, _nargs, _args...) do {    \
>  	if (!(_condition))                                              \
>  		ucall(UCALL_ABORT, 2 + _nargs,                          \
> -- 
> 2.36.1.476.g0c4daa206d-goog
>

Reviewed-by: Andrew Jones <drjones@redhat.com>

