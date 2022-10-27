Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B6160ECED
	for <lists+kvm@lfdr.de>; Thu, 27 Oct 2022 02:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234079AbiJ0ASt (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 20:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233803AbiJ0ASr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 20:18:47 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2195C96CF
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:18:46 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d59-20020a17090a6f4100b00213202d77e1so4574795pjk.2
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 17:18:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cpmTL2/1PYTa7BDsc47ElXf8nd6yERw7dn9uBkHqT3w=;
        b=h9ZMKebnOz8F+gVPqZtPQA4/OR1eSgCKAhOz7BgjYHy2b1k3kaDig+Kf5VV+F73SER
         6XXJvvWwbagaFrEhyyFOzX7I41+vwarVAMdhYiP/zs8bfkRiQWQ4vC2veioa7iDalEVg
         /hQ88wxQ5AxEGW7kmVwMy61Fj5ag6fPo1eXVlsuyAC8Hg4Bd/R/aaYWy3VzrApCOC9Vg
         scwX0nAS9Li+NDeNMdWFtSssK+uVGF00iuS+UXitn/v65ydVXfuTAog1rGySG9WtJq0C
         0NwelsHcdxMT046T8+M4qNNjJQ+emId8WGmEprAIeR4D4gDmMLQ3DefJU9MJQwUJKkxj
         49GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpmTL2/1PYTa7BDsc47ElXf8nd6yERw7dn9uBkHqT3w=;
        b=oihjwda/2I/cpSk4bufN0K2M1g1SoYj4HAOcUHN021ADcn509AqK5+WAz7PpBBC639
         VCjjcBENANHzCVW20RMeCSjOIbw+TLumvGya1HkLg6o821I9Rb7orHQKB2lsDMlWr6RC
         K2bEBtFMfyCQgsUyEcZjEUjHpr1xaxkVeHsLq9WL0+iWFL7Hy+37urELxMdpWTrPxIy/
         D5WO2atXBn4Pvhkepiu7n4ueaRw+/ski+Mqn2IJAhkC20ryoseVtRToOJPgdjaByI4p3
         xllpYMS5MOS+8Zh3FBsHUjhDx+p2mwHESSDBRCWAnStW7G3Z5A/7o0frojOcDaGGkUdH
         Z0sQ==
X-Gm-Message-State: ACrzQf2KtCUu+2dCpz0M2boD52TM1oO0jVM163C6KoDmm/yP9iAMP+Db
        znhuvMlceRekKq8ztVvXMHkuuw==
X-Google-Smtp-Source: AMsMyM5WlRdF3qzud38gBCnKr84xPcEWAgItCljrGlZxtsu2PkOGl1Nb/5E15rrjbPEUaZEdJI8dAw==
X-Received: by 2002:a17:90b:3ec4:b0:20d:93bc:32fb with SMTP id rm4-20020a17090b3ec400b0020d93bc32fbmr6985861pjb.124.1666829926200;
        Wed, 26 Oct 2022 17:18:46 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id p3-20020a170902e74300b00186b06963f9sm3468101plf.180.2022.10.26.17.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 17:18:45 -0700 (PDT)
Date:   Thu, 27 Oct 2022 00:18:42 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Wang <wei.w.wang@intel.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, vipinsh@google.com,
        ajones@ventanamicro.com, eric.auger@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 12/18] KVM: selftests/rseq_test: name the migration
 thread and some cleanup
Message-ID: <Y1nOYihuurZKi5XL@google.com>
References: <20221024113445.1022147-1-wei.w.wang@intel.com>
 <20221024113445.1022147-13-wei.w.wang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221024113445.1022147-13-wei.w.wang@intel.com>
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

On Mon, Oct 24, 2022, Wei Wang wrote:
> @@ -272,7 +271,8 @@ int main(int argc, char *argv[])
>  	TEST_ASSERT(i > (NR_TASK_MIGRATIONS / 2),
>  		    "Only performed %d KVM_RUNs, task stalled too much?\n", i);
>  
> -	pthread_join(migration_thread, NULL);
> +	r = pthread_join(migration_thread, NULL);
> +	TEST_ASSERT(r == 0, "failed to join the migration thread");

!r is the preferred style.

>  
>  	kvm_vm_free(vm);
>  
> -- 
> 2.27.0
> 
