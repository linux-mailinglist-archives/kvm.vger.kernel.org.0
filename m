Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3CB84B9526
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 01:56:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbiBQA4k (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 19:56:40 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiBQA4k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 19:56:40 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B822F6150
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:56:26 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id y18so3328903plb.11
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=raL6J9eMru9YQU6SpJHo/L0yRIYy/dAOHaeiYNsGiWw=;
        b=IcTKRsnHT0VQJlo359RNywDz4qq+ZAhT8od+JBNFm5i1a85JpFQ/CYB53dxzJUEPh/
         AHQQb9huwiT48dQrCS61KeGGe/8AjZhFRScgfFED7n5/+jbFWMMnayULdvxUpQUBntO3
         mLDgLIcKBpAHOcZiwCSVOyuxkx172LxKciO154TCKiZolxpO/DnnzIAzJTyWq3W7oLBe
         gRw9Uyro91oljBvEx//biq+2ebM5E1yJaA1RH5Ge3b0asIjwtSr/1YYyl1x4uzd51YeT
         yAbX4OzolS12rwfRphXT8iHBx1ZgRhkAFLvRb4pxn54OzNGsGQe+sQqg+WT0BMf1Em/J
         rntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=raL6J9eMru9YQU6SpJHo/L0yRIYy/dAOHaeiYNsGiWw=;
        b=lSDOT7ZX2oHwkQuW/WwMUkhveEt932seFtWyOZZ8zaKV+EK8wD2rnUiy+LvCkeotwI
         JQpF7o0t06puHNPqbL8YMdiVX4mGU+55qoDzXNMQ1jU9xQ5Y11tf1VPe3RIpkCk8zrNh
         UVsoJdQkbvzgf/kfPZWWJOcDLRAbKenFl31IIivxQShEXJIrSiVDazaWUyOXFkMj6Mrk
         sSjLS4/y3g/baQYNg5IyfxAcnra9KvPucKH5xwV+0hEPxolfCqZ09cf9uaciTrzWIh+R
         BiCg8iu72GaMU5cgK+8EEFOIr1tlDTYLitq/aqLo+jEvgeLLDklhK2e7P+/MNi3FBJTS
         tLQQ==
X-Gm-Message-State: AOAM530rgS99ftWJ45r05mAv/8EsjNxbXk640z402aUzyaoIDo3v4VDG
        3tuW51I+K6t9AG4aLo5t1EBrhw==
X-Google-Smtp-Source: ABdhPJx8ctxoCH30q8YO05rtWT5A0mv5YYIvWd3904Fops0JxOfOhSsJVBwb3qR5miJhFNQ63Fkd3A==
X-Received: by 2002:a17:902:db07:b0:14f:3f88:1b96 with SMTP id m7-20020a170902db0700b0014f3f881b96mr559846plx.123.1645059386060;
        Wed, 16 Feb 2022 16:56:26 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id mm15sm223373pjb.46.2022.02.16.16.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 16:56:25 -0800 (PST)
Date:   Thu, 17 Feb 2022 00:56:21 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v3 PATCH 1/3] vmx: Cleanup test_vmx_vmlaunch to
 generate clearer and more consolidated test reports
Message-ID: <Yg2dNU3wlmYEz+F9@google.com>
References: <20220216170149.25792-1-cavery@redhat.com>
 <20220216170149.25792-2-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216170149.25792-2-cavery@redhat.com>
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

On Wed, Feb 16, 2022, Cathy Avery wrote:
> In cases when xerror is 0 ( the test is not expected to error ) and
> the test does error we get a confusing test result as the vmlaunch status
> is based on !xerror:
> 
> FAIL: Enable-EPT enabled; EPT page walk length 24: vmlaunch succeeds
> 
> This patch also eliminates the double call to report per launch and
> clarifies the failure messages. New format suggested by seanjc@google.com
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  x86/vmx_tests.c | 21 ++++++++++++++-------
>  1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/x86/vmx_tests.c b/x86/vmx_tests.c
> index 3d57ed6..0dab98e 100644
> --- a/x86/vmx_tests.c
> +++ b/x86/vmx_tests.c
> @@ -3392,14 +3392,21 @@ static void test_vmx_vmlaunch(u32 xerror)
>  	bool success = vmlaunch_succeeds();
>  	u32 vmx_inst_err;
>  
> -	report(success == !xerror, "vmlaunch %s",
> -	       !xerror ? "succeeds" : "fails");
> -	if (!success && xerror) {
> -		vmx_inst_err = vmcs_read(VMX_INST_ERROR);
> +	if (!success)
> +	vmx_inst_err = vmcs_read(VMX_INST_ERROR);

Needs to be indended.  With that fixed,

Reviewed-by: Sean Christopherson <seanjc@google.com>
