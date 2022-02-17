Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A86484B952D
	for <lists+kvm@lfdr.de>; Thu, 17 Feb 2022 01:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbiBQA5T (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Feb 2022 19:57:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbiBQA5R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Feb 2022 19:57:17 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554CC1D334
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:57:00 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id z4so3552657pgh.12
        for <kvm@vger.kernel.org>; Wed, 16 Feb 2022 16:57:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Uh62l1WKRs9l6xKPdkb4nPHzt/03HxUwoKzq8r1A1Ns=;
        b=Sm9AFd++LJ9LAAX6P8/7ps7kYTUh6U60C8vGQE2bNAH1SdhdWVnjNCcUQvqoNVPX+r
         Tf/eZX+PV43INXpPB0qWz+ImQI3q9OjZTjVLSbdK71zdUjb0W+MprCPvAeh9jbp4rzDW
         FXaAvyGYScwBi2JiFWc/Ty5P8kAdBod8KWclfQ9myPqSVef/AbueFxZ4kdwJYtyvMCDG
         ZYu82XC43QUovdRXsA/EudHdAv5iQ1AD2MTfYdAP8fQScZPg8o+/uisfAbstSpN/3f7k
         jJZub8wRk2wFGR37vrUe20hbyYLQFg+h4ExdXBJLM7UDmNPimXV9hMDipSzUmxZfajTg
         9Fgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Uh62l1WKRs9l6xKPdkb4nPHzt/03HxUwoKzq8r1A1Ns=;
        b=Ba3fgQlAwEj1b4ZflQ/TC3BkdiYsUrFP1wg2Kxx2VjbFSot7NEO3vXJvqejDeXcWP/
         HGNCm5R96wURBidg4+ts/x5GkWN7NESz9UzQCc73bH9rwvpoE4nwtN0X9sDVxxQtttPh
         PLjg3W5vaL2Nx3cSyAPOo3eUX1KB7/Mvu3atT/X+mYwbuvDXUgbFwSHklMn7054gr4X4
         E8+oBNcroOW7Il/kJYFbrCVQsUP5hahzNU3DO3XwhC7QpJ0k6/1884QjvfCBiMkAaB/J
         g1Ap1S2a65GrDhKbuZ6hV2DkPmxCwpP1UkszcIKEdtGsPqPrLk7mCeLWqqn3php0cj7d
         Ydeg==
X-Gm-Message-State: AOAM533U8VIClyWE9ogD/kygSbnO6s3jSCCZxwe5R4rc63n9uFRY7leF
        j8zuGDOlePoTCZlcYyT2ZMSmZQ==
X-Google-Smtp-Source: ABdhPJzT0Z+0U66TzQAWZDlTw0MvVyYwMUyAH2k/FryBqolm+w1Er04XrvUexYvFSU98kXqC/1UxNA==
X-Received: by 2002:a63:10c:0:b0:36c:6dd0:44af with SMTP id 12-20020a63010c000000b0036c6dd044afmr475564pgb.41.1645059419690;
        Wed, 16 Feb 2022 16:56:59 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q94sm226627pja.27.2022.02.16.16.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Feb 2022 16:56:59 -0800 (PST)
Date:   Thu, 17 Feb 2022 00:56:55 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Cathy Avery <cavery@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: Re: [kvm-unit-tests v3 PATCH 2/3] vmx: Explicitly setup a dummy EPTP
 in EPT accessed and dirty flag test
Message-ID: <Yg2dVwqT8R1/+LzP@google.com>
References: <20220216170149.25792-1-cavery@redhat.com>
 <20220216170149.25792-3-cavery@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216170149.25792-3-cavery@redhat.com>
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
> test_ept_eptp is not explicitly calling setup_dummy_ept() to initialize
> EPTP to a good starting value resulting in test failures when it is called
> in isolation or when EPTP has been changed by some previous test.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
