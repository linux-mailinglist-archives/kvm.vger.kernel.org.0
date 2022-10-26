Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F48860EAB3
	for <lists+kvm@lfdr.de>; Wed, 26 Oct 2022 23:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbiJZVNJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Oct 2022 17:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233698AbiJZVNI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Oct 2022 17:13:08 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC79F6832
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:13:07 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id 78so16176785pgb.13
        for <kvm@vger.kernel.org>; Wed, 26 Oct 2022 14:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2Qilsnv6r8pJOHYLQVSxKSlBXo3G/jvH/KvBcw2vZro=;
        b=RvYcK3VRNj+4sPOtO3cDwQ4gYNVBcOK3tzToqj7iGe6IyxLrscQl15h3jwo/9IIY6j
         g2GklglI7uIwlxhVLooB+VdY4T+WzJxnnOnqVwJvVRWgMKoqQukH10KWHi6iWcgmiccu
         TWuLjMx3/ycvhyf9KaIyp/bvWEF5YoI/gY5SxO7/3q//ysOcu66Rs+hTI3Cg9A7An/Zp
         vcRhpEpvMPVjICRY2GVFd/K0YnaIaMzT+my4J5lN0fcWlJsmQ0YdfJlV6hX8yMDWuggR
         1MTy3ECrhCfJD2V0mWSwYA5ocp99e9NkCHSylWq394yeFiyRmCjiY8DjgYGeSQstI9fy
         Cytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2Qilsnv6r8pJOHYLQVSxKSlBXo3G/jvH/KvBcw2vZro=;
        b=yatRA+XpthiFwXhRyurvc+uW/GpvZEupzURkZyQ0lInQgF0cqhWRZE2pBfGJEjK40P
         ivzWzmI4tbOx7RNPPa+SbCcC1M8j0b2DQbngYXyBAKtgCf67Pji1ZbG+3hFXoAWXJk1B
         Lcbx6SDGNIGNHCYm7gvODva09rI+YPuvDXV/Tl5y12mkHOQGpSElzj+CD4C7sfZGpbLk
         5053ZdMS2/a6yA7jqq6JToiMWmIUQkdLPRcvja1mTMIcfHYZ1gJfQRHgd67n4zp3OHTS
         IrZTQlWBWvSI70c0jpsN2xq7UgtBrOTOWFHoL8K51nEr7H9qY9k8bdy6iIru6nW+4tWo
         h13w==
X-Gm-Message-State: ACrzQf0dbiW35/0+mhMwxv/Yhqg5eN420T6j0A9OJ/a0OLaxaIaWtE6V
        vciA08DjPtyN3RNBcclvwLTfiQyOTijWig==
X-Google-Smtp-Source: AMsMyM55ElazOH3h0SKjIiGhH3sFvvHC4h69o0XUNghh7+lEbE5r+UyZcaxcLxgPzPTg+R/OCXQw4g==
X-Received: by 2002:a63:8ac2:0:b0:460:6480:8c59 with SMTP id y185-20020a638ac2000000b0046064808c59mr39297937pgd.472.1666818787129;
        Wed, 26 Oct 2022 14:13:07 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id c6-20020a170902b68600b0018691ce1696sm3315103pls.131.2022.10.26.14.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 14:13:06 -0700 (PDT)
Date:   Wed, 26 Oct 2022 21:13:03 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Colton Lewis <coltonlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, oupton@google.com, ricarkol@google.com
Subject: Re: [PATCH v7 3/3] KVM: selftests: randomize page access order
Message-ID: <Y1mi34Qq5oQhzswU@google.com>
References: <20221019221321.3033920-1-coltonlewis@google.com>
 <20221019221321.3033920-4-coltonlewis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019221321.3033920-4-coltonlewis@google.com>
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

On Wed, Oct 19, 2022, Colton Lewis wrote:
> @@ -422,11 +426,15 @@ int main(int argc, char *argv[])
>  
>  	guest_modes_append_default();
>  
> -	while ((opt = getopt(argc, argv, "eghi:p:m:nb:v:or:s:x:w:")) != -1) {
> +	while ((opt = getopt(argc, argv, "aeghi:p:m:nb:v:or:s:x:w:")) != -1) {
>  		switch (opt) {
> +		case 'a':
> +			p.random_access = true;
> +			break;
>  		case 'e':
>  			/* 'e' is for evil. */
>  			run_vcpus_while_disabling_dirty_logging = true;
> +			break;

Heh, I appreciate the fix for my bug, but this belongs in a separate patch.
Isolating bug fixes isn't exactly critical for selftests, but it does matter.
E.g. Vipin also has an in-flight patch to fix this, and isolating the fix makes
it easier on maintainers to resolve the conflicts between the two series.

[*] https://lore.kernel.org/all/20221021211816.1525201-2-vipinsh@google.com
