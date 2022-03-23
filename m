Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 094B34E581C
	for <lists+kvm@lfdr.de>; Wed, 23 Mar 2022 19:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbiCWSI7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Mar 2022 14:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238453AbiCWSI5 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Mar 2022 14:08:57 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01838888FB
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:07:28 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id z7so2681072iom.1
        for <kvm@vger.kernel.org>; Wed, 23 Mar 2022 11:07:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6WfovYqoRINN5ewrjsJajufKxICxtDG1bQZ2e+C3x4I=;
        b=rf7kB/bG1sUglJuj1VORlxGYQhCZJWSma6P2amN7uTyvwN/JL21bAPu/HZUv6wovhn
         BKvlE1MZyFyryX7jmENq+fsyOFj4RgT33mFCLpYNC0W/rIpneqBPnrwj1Erlm7s+AmwK
         YNxZ3EIbE3pym9sTiBPgz6BdlfFYk2djfXfwan8uOVDmEnd6CIA++bVuTu/6fMz4rORT
         ujF7rFuxnm09X621JqveGtSQrJ0nVCJRr9Uy9lu1nhZ5K1EzB/r6AP/NkcHCS2QHJwDn
         mA2drnJLrYyaoaueVKVkhFPMyVikyFKbafqmeClXyQauVtzBWsuogy7PJf7fEC/ZWJ9z
         pcgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6WfovYqoRINN5ewrjsJajufKxICxtDG1bQZ2e+C3x4I=;
        b=D69PJwEJZBuOf5/TqfW/Oeij+1sOgyOmeu0Tfk60Y82C4n/MVEXXdeEPMgkMIjky1M
         XZtN+5sJo9+h3BcoftpGPjDo2TpW0TOZmEUTYZA3r5/gKe/dDpDQ8D5GuF9RBcE4BDsC
         pW6MyTCF1Sk9/NkZ7qMI/25Lb3zyy7f9EmfKOcg4VO28dhO/thswyJ4OoS8EyAiFgGiA
         LJGhLINDqKmZ9r1AQFqQW7kt9eu5/PL5DaZEg7WNtCyINYVO9zD1+40lzmyinsT6dAXL
         vuhxWv1LPL3u4SrfMtYK2BKkYmgrWE6eq+jygmPrPvIOc+ONKYLHlV0uGHF8dX5/XNfI
         7GbA==
X-Gm-Message-State: AOAM530kelKnE1IgpHPr3ogm3jbnPZTrGmeWxEUwWXh/n+c22e2Vb1ji
        2no7CgxAzxMM3Y5Z1pQTfyK+iQ==
X-Google-Smtp-Source: ABdhPJxZFCBQjB576z7b7Q4c3lB/HGhmIbF3QZ09QOOC0Hsgr46QcsYqtPPdcTToKolKlaRdGX2LlA==
X-Received: by 2002:a02:aa85:0:b0:321:4b0d:6423 with SMTP id u5-20020a02aa85000000b003214b0d6423mr625961jai.219.1648058847205;
        Wed, 23 Mar 2022 11:07:27 -0700 (PDT)
Received: from google.com (194.225.68.34.bc.googleusercontent.com. [34.68.225.194])
        by smtp.gmail.com with ESMTPSA id t13-20020a056e02160d00b002c808d68c60sm376113ilu.15.2022.03.23.11.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:07:26 -0700 (PDT)
Date:   Wed, 23 Mar 2022 18:07:23 +0000
From:   Oliver Upton <oupton@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        mlevitsk@redhat.com, jmattson@google.com
Subject: Re: [PATCH 2/3] Documentation: KVM: add virtual CPU errata
 documentation
Message-ID: <Yjth27hiWLnHRGza@google.com>
References: <20220322110712.222449-1-pbonzini@redhat.com>
 <20220322110712.222449-3-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220322110712.222449-3-pbonzini@redhat.com>
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

Hi Paolo,

On Tue, Mar 22, 2022 at 12:07:11PM +0100, Paolo Bonzini wrote:
> Add a file to document all the different ways in which the virtual CPU
> emulation is imperfect.  Include an example to show how to document
> such errata.
>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>

+100, this is excellent!

Reviewed-by: Oliver Upton <oupton@google.com>

> ---
>  Documentation/virt/kvm/x86/errata.rst | 39 +++++++++++++++++++++++++++
>  Documentation/virt/kvm/x86/index.rst  |  1 +
>  2 files changed, 40 insertions(+)
>  create mode 100644 Documentation/virt/kvm/x86/errata.rst
> 
> diff --git a/Documentation/virt/kvm/x86/errata.rst b/Documentation/virt/kvm/x86/errata.rst
> new file mode 100644
> index 000000000000..df394d34a836
> --- /dev/null
> +++ b/Documentation/virt/kvm/x86/errata.rst
> @@ -0,0 +1,39 @@
> +
> +=======================================
> +Known limitations of CPU virtualization
> +=======================================

In an attempt for us KVM developers to save face, would it make
sense to rip the table for KVM_CAP_DISABLE_QUIRKS2 out of api.rst and
drop it here?

That way, we can discuss all of the known errata in KVM *and* mention
the chicken bits we provide to mitigate :)

--
Thanks,
Oliver
